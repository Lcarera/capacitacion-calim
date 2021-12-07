package com.zifras.notificacion

import com.zifras.AccessRulesService
import com.zifras.User
import com.zifras.UsuarioService
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.cuenta.MovimientoCuenta
import com.zifras.documento.PagoCuentaService
import com.zifras.documento.VencimientoDeclaracion
import com.zifras.liquidacion.LiquidacionIIBBService
import com.zifras.liquidacion.LiquidacionIvaService

import grails.converters.JSON
import grails.gorm.multitenancy.Tenants
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import grails.util.Environment
import grails.validation.ValidationException
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import org.springframework.context.MessageSource
import org.springframework.context.i18n.LocaleContextHolder
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.mail.MailMessage
import org.springframework.mail.javamail.MimeMessageHelper

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class NotificacionController {
	AccessRulesService accessRulesService
	MessageSource messageSource
	def cuentaService
	def liquidacionIIBBService
	def liquidacionIvaService
	def notificacionService
	def pagoCuentaService
	def springSecurityService
	def usuarioService
	def mailService

	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def index() {
		redirect(action: "list", params: params)
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def list() {
		def cuenta = accessRulesService.getCurrentUser()?.cuenta
	
		def notificacionesCuenta = Email.createCriteria().list(){
			eq('cuenta',cuenta)		
			}.findAll{it.tituloNotificacionApp}.sort{it.id}.reverse()

		[notificacionesCuenta:notificacionesCuenta, cuenta:cuenta]

	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def listApp() {
		def cuenta = accessRulesService.getCurrentUser()?.cuenta
		
		def notificacionesCuenta = Email.createCriteria().list(){
			eq('cuenta',cuenta)		
			}.findAll{it.tituloNotificacionApp}.sort{it.id}.reverse()
		
		render notificacionesCuenta as JSON

		notificacionService.actualizarNotificacionesPendientesCuenta(cuenta.id)
		return
	}
	
	@Secured(['permitAll'])
	def pagarMovimientosMail(Long p1, String p2, Long p3){ //Usuario, movimientos, Cuenta
		Tenants.withId(2) {
			String mensaje
			try {
				assert p1 && p2 && p3: "El link ingresado es incorrectofinerror" //Para evitar que la siguiente función rompa por parámetros nulos
				def usuario = User.get(p1)
				assert usuario: "El link ingresado es incorrectofinerror"
				assert p3 == usuario.cuenta?.id: "El link ingresado es incorrectofinerror"
				def idsMovimientos = p2.split(',')
				def movimientos = idsMovimientos.collect{MovimientoCuenta.get(it)}.findAll{!(!it || it.pagado)}
				assert movimientos : "Los movimientos a pagar ya no se encuentran disponiblesfinerror"
				def pago = movimientos[0].pago
				String linkSalida
				if (! pago || ! pago.linkMercadoPago || pago.estado.nombre != "Emitido" || pago.movimientos.findAll{! it.positivo}.collect{it.id.toString()} as Set != idsMovimientos as Set)
					linkSalida = pagoCuentaService.pagarMovimientos(movimientos,usuario)
				else
					linkSalida = pago.linkMercadoPago
				println "\n\n $linkSalida \n\n"
				redirect(url: linkSalida)
			}
			catch(java.lang.AssertionError e){
				mensaje = e.message.split("finerror")[0]
				render(view: "desactivarNotificaciones", model: [mensaje:mensaje])
			}
			catch(e){
				log.error("Error intentando pagar movimientos por mail: ${e.message}\n")
				redirect(controller:'start')
			}
		}
	}

	@Secured(['permitAll'])
	def pagarMovimientosMailPavoni(Long p1, String p2, Long p3){ //Cuenta, movimientos, Cuenta
		Tenants.withId(1) {
			String mensaje
			try {
				assert p1 && p2 && p3: "El link ingresado es incorrectofinerror" //Para evitar que la siguiente función rompa por parámetros nulos
				def cuenta = Cuenta.get(p1)
				assert cuenta: "El link ingresado es incorrectofinerror"
				assert p3 == p1: "El link ingresado es incorrectofinerror"
				def movimientos = p2.split(',').collect{MovimientoCuenta.get(it)}.findAll{!(!it || it.pagado)}
				assert movimientos : "Los movimientos a pagar ya no se encuentran disponiblesfinerror"
				redirect(url: pagoCuentaService.pagarMovimientos(movimientos,null,cuenta))
			}
			catch(java.lang.AssertionError e){
				mensaje = e.message.split("finerror")[0]
				render(view: "desactivarNotificaciones", model: [mensaje:mensaje])
			}
			catch(e){
				log.error("Error intentando pagar movimientos por mail: ${e.message}\n")
				redirect(controller:'start')
			}
		}
	}

	@Secured(['permitAll'])
	def desactivarNotificaciones(Long p1, Long p2){ //Usuario y Cuenta
		Tenants.withId(2) {
			String mensaje
			try {
				assert p1 && p2 //Para evitar que la siguiente función rompa por parámetros nulos
				cuentaService.desactivarNotificacionesCuenta(p1,p2)
				mensaje = "Las notificaciones para su cuenta se han desactivado."
			}
			catch(java.lang.AssertionError e){
				mensaje = "Las credenciales son incorrectas. Revise el link e intente nuevamente."
			}
			[mensaje:mensaje]
		}
	}

	@Secured(['permitAll'])
	def autorizarLiquidaciones(Long uId, Long cId, String mes, String ano, Boolean iva){
		def usuario = User.get(uId)
		if(usuario && mes && ano){
			if(usuario.cuenta.id==cId){
				def email = usuario.username

				springSecurityService.reauthenticate(email)
				String mensajeSalida = ""

				def declaracionIva

				boolean exito = false
				
				if(iva && usuario.cuenta?.aplicaIva){
					declaracionIva = liquidacionIvaService.autorizarMes(usuario.cuenta.id, mes, ano)
					if (!declaracionIva) // la declaración será null si no se pudo autorizar
						mensajeSalida += "La liquidación de IVA no se pudo autorizar. "
					else
						exito = true
				}

				def declaracionesIibb
				if (! iva){
					declaracionesIibb = liquidacionIIBBService.autorizarMes(usuario.cuenta.id, mes, ano)
					if (!declaracionesIibb) // la lista estará vacía si no se pudo autorizar nada
						mensajeSalida += "La liquidación de Igresos Brutos no se pudo autorizar. "
					else
						exito = true
				}

				String mensajeInternoHtml = "Email: " + usuario.username + "<br/>CUIT: " + usuario.cuenta.cuit + "<br/><br/>Fecha a autorizar: " + mes + "/" + ano
				if (!(declaracionIva || declaracionesIibb))
					mensajeInternoHtml += "<br/>Las liquidaciones no estaban listas para autorizar."
				
				notificacionService.enviarEmailInterno("gestion@calim.com.ar", "Usuario autorizo liquidacion", mensajeInternoHtml, 'autorizacionLiquidacion')

				if (exito)
					flash.message = "Gracias por autorizarnos a presentar tus liquidaciones"
				else
					flash.error = mensajeSalida
				if (usuario.cuenta?.with{!(maximoAutorizarIva || maximoAutorizarIIBB)})
					redirect(controller:"liquidacionUsuario",action:"montosMaximos")
				else
					redirect(controller:"dashboard",action:"index")
				return
			}
		}

		redirect(controller:"login", action:'auth')
		return
	}
	
	def enviarEmail(){
		notificacionService.enviarEmail('cgzechner@gmail.com', 'prueba', 'texto', 'registro')
	}

	def enviarNotificacionesPersonalizadas(){
		LocalDateTime horaProgramada
		String tipoNotif = ""
		if(params.fecha){	
			def hora = params.hora ?: "14:00"
			String fechaProgramada = params.fecha + " " + hora
			DateTimeFormatter formatter = DateTimeFormat.forPattern("dd/MM/yyyy HH:mm")
			horaProgramada = LocalDateTime.parse(fechaProgramada,formatter).plusHours(3)
		}
		
		try{
			def emails = params.emailCuentas.split(',')
			def asunto = params.asuntoMail ?: "Notificacion Calim"
			if(params.cuerpoEmail!='')
				emails.each{email -> notificacionService.enviarEmail(email,asunto,params.cuerpoEmail,'notificacionPersonalizada',horaProgramada,params.tituloApp,params.textoApp)}
			else{
				if (Environment.current == Environment.PRODUCTION)
					emails.each{email-> 
						notificacionService.enviarNotificacionPush(User.findByUsername(email).cuenta.id,params.tituloApp,(params.textoApp ?: ''))
						notificacionService.crearEmailNotificacion(User.findByUsername(email).cuenta.id,params.tituloApp,(params.textoApp ?: ''))
					}
				else
					println "Notificacion push enviada"
				}
			flash.message = horaProgramada ? "Notificaciones programadas!" : "Notificaciones enviadas!"
		}catch(e){
			flash.error = message(code: 'zifras.ticket.mensaje.hasErrors', default:'Ha ocurrido un error al enviar las notificaciones')
			}

		redirect(action:'notificacionesPersonalizables')
	}

	def createTemplate(){

	}

	def listTemplates(){

	}

	def deleteTemplate(Long id){
		def notificacionTemplateInstance = notificacionService.getNotificacionTemplate(id)
		if (!notificacionTemplateInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.NotificacionTemplate.label', default: 'NotificacionTemplate'), notificacionTemplateInstance.nombre])
			redirect(action: "listTemplates")
			return
		}

		try {
			notificacionService.deleteTemplate(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.documento.NotificacionTemplate.label', default: 'Plantilla de notificacion'),notificacionTemplateInstance.nombre], encodeAs:'none')
			redirect(action:"listTemplates")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.documento.NotificacionTemplate.label', default: 'Plantilla de notificacion'), notificacionTemplateInstance.nombre], encodeAs:'none')
			redirect(action: "listTemplates")
		}
	}

	def editTemplate(Long id){
		def notificacionTemplateInstance = notificacionService.getNotificacionTemplateCommand(id)

		if(!notificacionTemplateInstance){
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.NotificacionTemplate.label', default: 'NotificacionTemplate'), id])
			redirect(action:"listTemplates")
			return
		}
		[notificacionTemplateInstance:notificacionTemplateInstance]
	}

	def saveNotificacionTemplate(NotificacionTemplateCommand command){

		if (command.hasErrors()) {
			println command.errors.allErrors
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments, default:'Error en algun atributo')
			render(view: "createTemplate", model:[notificacionTemplateInstance:command])
			return
		}

		try {
			notificacionService.saveTemplate(command)
			flash.message = message(code:'zifras.notif.create' ,default:'Plantilla creada correctamente!')
		}catch (e){
			flash.error	= message(code: 'zifras.ticket.Notificacion.save.error', default: 'Error al intentar guardar la plantilla')
			render(view: "createTemplate", model: [notificacionTemplateInstance: command])
			return
		}	

		redirect(action:"listTemplates")
	}

	def updateNotificacionTemplate(NotificacionTemplateCommand command){

		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments, default:'Error en algun atributo')
			render(view: "createTemplate", model:[notificacionTemplateInstance:command])
			return
		}
		try{
			notificacionService.updateTemplate(command)
			flash.message = message(code:'zifras.notif.create' ,default:'Plantilla actualizada correctamente!')
		}catch(e){
			flash.error = message(code: 'zifras.ticket.Notificacion.save.error', default: 'Error al intentar guardar la plantilla')
		}
			redirect(action:"listTemplates")
	}

	def notificacionesPersonalizables(){

	}

	def testMail(){

		def plantilla = /*NotificacionTemplate.findByNombre("Nos Comunicaremos Con Vos")*/
		String bodyMail = plantilla.llenarVariablesBody(["Pedrito","https://facebook.com"])
		def email = new Email()
		email.emailTo = "agus9997@hotmail.com"
		email.subject = plantilla.asuntoEmail
		email.html = bodyMail
		email.tag = "TEST"
		email.fechaHora = new LocalDateTime()

		def mail = mailService.sendMail {
			to "sainatoagustin@gmail.com"
			from '"Calim" <notificaciones@calim.com.ar>'
			subject email.subject
			html email.html
		}

		println mail.getMimeMessageHelper().mimeMessage.getHeader("Message-id")
		def mailId = mail.getMimeMessageHelper().mimeMessage.getHeader("Message-id").toString()
		email.mailgunId = mailId.getAt(2..(mailId.length()-3))
		email.save(flush:true, failOnError:true)
		render "ok"
	}
	
	@Secured(['permitAll'])
	def mailgunDeliveredEvent(){
		def respuesta = request.JSON
		def command = new MailgunCommand()
		command.mailgunId = respuesta["event-data"].message.headers["message-id"]
		command.event = respuesta["event-data"].event
		command.recipient =  respuesta["event-data"].recipient
		command.domain = respuesta["event-data"]["recipient-domain"]
		command.ip = respuesta["event-data"].envelope["sending-ip"]
		command.tag = respuesta["event-data"].tags ?: ""
		command.customVariables = respuesta["event-data"]["user-variables"] ?: ""
		command.timestamp = respuesta.signature.timestamp
		command.token = respuesta.signature.token
		command.signature = respuesta.signature.signature
		
		//command.country 
		//command.region
		//command.city
		//command.userAgent
		//command.deviceType
		//command.clientType
		//command.clientName
		//command.clientOs
		//command.campaignId
		//command.campaignName
		//command.mailingList
		//command.mailgunId = command.mailgunId.getAt(1..(command.mailgunId.length()-2))

		def email = notificacionService.mailgunDelivered(command)

		render(status: 200, text: 'OK')
	}

	@Secured(['permitAll'])
	def mailgunOpensEvent(){
		def respuesta = request.JSON
		def command = new MailgunCommand()
		command.mailgunId = respuesta["event-data"].message.headers["message-id"]
		command.event = respuesta["event-data"].event
		command.recipient =  respuesta["event-data"].recipient
		command.domain = respuesta["event-data"]["recipient-domain"]
		command.ip = respuesta["event-data"].ip
		command.clientName = respuesta["event-data"]["client-info"]["client-name"]
		command.clientType = respuesta["event-data"]["client-info"]["client-type"]
		command.clientOs = respuesta["event-data"]["client-info"]["client-os"]
		command.userAgent = respuesta["event-data"]["client-info"]["user-agent"]
		command.deviceType = respuesta["event-data"]["client-info"]["device-type"]
		command.tag = respuesta["event-data"].tags ?: ""
		command.customVariables = respuesta["event-data"]["user-variables"] ?: ""
		command.timestamp = respuesta.signature.timestamp
		command.token = respuesta.signature.token
		command.signature = respuesta.signature.signature
		command.country = respuesta["event-data"].geolocation.country
		command.region = respuesta["event-data"].geolocation.region
		command.city = respuesta["event-data"].geolocation.city
		/*
		command.campaignId = params['campaign-id']
		command.campaignName = params['campaign-name']
		command.mailingList = params['mailing-list']
		*/
		def email = notificacionService.mailgunOpen(command)

		render(status: 200, text: 'OK')
	}

	@Secured(['permitAll'])
	def mailgunClicksEvent(){
		def respuesta = request.JSON
		def command = new MailgunCommand()
		command.mailgunId = respuesta["event-data"].message.headers["message-id"]
		command.event = respuesta["event-data"].event
		command.recipient =  respuesta["event-data"].recipient
		command.domain = respuesta["event-data"]["recipient-domain"]
		command.ip = respuesta["event-data"].ip
		command.clientName = respuesta["event-data"]["client-info"]["client-name"]
		command.clientType = respuesta["event-data"]["client-info"]["client-type"]
		command.clientOs = respuesta["event-data"]["client-info"]["client-os"]
		command.userAgent = respuesta["event-data"]["client-info"]["user-agent"]
		command.deviceType = respuesta["event-data"]["client-info"]["device-type"]
		command.tag = respuesta["event-data"].tags ?: ""
		command.customVariables = respuesta["event-data"]["user-variables"] ?: ""
		command.timestamp = respuesta.signature.timestamp
		command.token = respuesta.signature.token
		command.signature = respuesta.signature.signature
		command.country = respuesta["event-data"].geolocation.country
		command.region = respuesta["event-data"].geolocation.region
		command.city = respuesta["event-data"].geolocation.city
		/*
		command.campaignId = params['campaign-id']
		command.campaignName = params['campaign-name']
		command.mailingList = params['mailing-list']
		*/
		def email = notificacionService.mailgunClick(command)

		render(status: 200, text: 'OK')
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxActualizarNotificacionesPendientes(Long cuentaId){
		notificacionService.actualizarNotificacionesPendientesCuenta(cuentaId)
		render ""
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetNotificaciones(){
		def notificaciones = notificacionService.getNotificaciones()

		if(notificaciones!=null)
			render notificaciones as JSON
		else
			render ""
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetNotificacionesNuevas(){
		def notificaciones = notificacionService.getNotificacionesNuevas()

		if(notificaciones!=null)
			render notificaciones as JSON
		else
			render ""
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetNotificacionesNoLeidas(){
		def notificaciones = notificacionService.getNotificacionesNoLeidas()

		if(notificaciones!=null)
			render notificaciones as JSON
		else
			render ""
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxSetNotificacionNoLeida(Long id){
		def notificacion = notificacionService.setNotificacionNoLeida(id)

		if(notificacion!=null)
			render notificacion as JSON
		else
			render ""
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxSetNotificacionLeida(Long id){
		def notificacion = notificacionService.setNotificacionLeida(id)

		if(notificacion!=null)
			render notificacion as JSON
		else
			render ""
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxSetNotificacionBorrada(Long id){
		def notificacion = notificacionService.setNotificacionBorrada(id)

		def notificaciones =  notificacionService.getNotificaciones()

		if(notificaciones!=null)
			render notificaciones.size()
		else
			render 0
	}

	def ajaxGetTemplates(){
		def templates = notificacionService.listTemplates()

		if(templates)
			render templates as JSON
		else
			render ""
	}

	def ajaxNotificarMonotributo(Long cuentaId){
		def resp = [:]
		try{
			notificacionService.notificarMonotributo(cuentaId)
			resp['ok'] = "Usuario notificado correctamente!"
		}
		catch(e){
			resp['error'] = "Ocurrió un error al notificar al usuario"
		}
		render resp as JSON
	}

	def ajaxNotificarErrorUsuario(Boolean fotos, Boolean claveFiscal, Boolean direccion, Boolean codigoPostal, Long cuentaId){
		notificacionService.notificarErrorUsuario(fotos,claveFiscal,direccion,codigoPostal,cuentaId)
		def resp = [:]

		render resp as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA','ROLE_RIDER_PY', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def guardarTokenPush(String token){
		def cuentaId = accessRulesService.getCurrentUser().cuenta?.id
		cuentaService.guardarTokenFcm(cuentaId,token)
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def getCantidadNotificacionesNoLeidas(){
		def cuenta = accessRulesService.getCurrentUser().cuenta
		if(cuenta)
			render cuenta.notificacionesNoLeidas()
		else
			render 0
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def enviarNotificacionPush(cuentaId, String title, String body){
		try {
			notificacionService.enviarNotificacionPush(cuentaId,title,body)
			flash.message = "Se envio la notificación correctamente"
		}
		catch(Exception e) {
			flash.error = "No se pudo enviar la notificación"
		}
		redirect (controller:'cuenta',action:'list')
	}
}
