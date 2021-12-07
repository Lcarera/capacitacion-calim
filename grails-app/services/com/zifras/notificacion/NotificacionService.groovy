package com.zifras.notificacion

import com.zifras.AccessRulesService
import com.zifras.Estado
import com.zifras.Role
import com.zifras.User
import com.zifras.UserRole
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.cuenta.MovimientoCuenta
import com.zifras.documento.DeclaracionJuradaService
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.PagoCuentaService

import com.zifras.documento.Vep


import org.joda.time.LocalDate

import org.springframework.mail.MailMessage
import org.springframework.mail.javamail.MimeMessageHelper

import grails.validation.ValidationException
import grails.util.Environment
import groovy.json.JsonSlurper
import groovyx.net.http.HTTPBuilder
import groovyx.net.http.RESTClient
import org.joda.time.Duration
import org.joda.time.LocalDateTime
import org.joda.time.Period
import grails.web.mapping.LinkGenerator
import org.springframework.context.MessageSource
import static groovyx.net.http.ContentType.*
import static groovyx.net.http.Method.*
import org.springframework.context.i18n.LocaleContextHolder


class NotificacionService {
	AccessRulesService accessRulesService
	def mailService
	def pagoCuentaService
	static LinkGenerator grailsLinkGenerator
	def cuentaService
	MessageSource messageSource
	def grailsApplication

	def enviarEmailProgramados(){
		if (Environment.current == Environment.PRODUCTION){
			def fechaHora = new LocalDateTime()

			def emails = Email.createCriteria().list() {
				eq('programado', true)
				le('fechaHora', fechaHora)
			}

			def mailsSalvados = []

			emails.each{
				def mail = it
				def resp = mailService.sendMail {
					to mail.emailTo
					from '"Calim" <notificaciones@calim.com.ar>'
					subject mail.subject
					html mail.html
				}
				if(mail.textoNotificacionApp)
					enviarNotificacionPush(mail.cuenta.id,mail.tituloNotificacionApp,mail.textoNotificacionApp)

				def mailgunId = resp.getMimeMessageHelper().mimeMessage.getHeader("Message-id").toString()
				mail.mailgunId = mailgunId.getAt(2..(mailgunId.length()-3))
				mail.fechaHora = fechaHora
				mail.programado = null

				mailsSalvados.push(mail)
			}

			fechaHora = new LocalDateTime()

			if(mailsSalvados.size()>0){
				log.info(fechaHora.toString("dd/MM/YYYY HH:mm:ss") + " Cantidad de emails programados enviados: " + mailsSalvados.size())
				println fechaHora.toString("dd/MM/YYYY HH:mm:ss") + " Cantidad de emails programados enviados: " + mailsSalvados.size()
			}
			
			mailsSalvados.each{
				it.save(flush:true)
			}
		}
	}

	def notificarUsuarioVolanteSimplificado(String email, String nombreApellido, LocalDate fechaVencimiento, String linkDescarga, Boolean unificado = false){
		def nombre = nombreApellido.split(' ')[0]
		def fechaVenci = fechaVencimiento?.toString("dd-MM-YYYY")
		//def body = messageSource.getMessage('calim.email.body.avisoVolanteMonotributoSimplificado', [nombre,fechaVenci] as Object[], '', LocaleContextHolder.locale)
		//String asunto = messageSource.getMessage('calim.email.asunto.avisoVolanteMonotributoSimplificado', [] as Object[], '', LocaleContextHolder.locale)
		NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Aviso Volante Monotributo Simplificado")
		String tipo = unificado ? "Unificado" : "Simplificado"
		String bodyMail = plantilla.llenarVariablesBody([nombre,fechaVenci ?: "-", linkDescarga, tipo])
		enviarEmail(email, plantilla.asuntoEmail, bodyMail, 'instrucciones', null, plantilla.tituloApp, plantilla.textoApp)
	}

	def notificarErrorTaskTramite(Long cuentaId, String descripcion, String responsable){
		String contenido = "Ocurrió un error generando la Task de Servicio: " + descripcion + " para la cuenta de Id " + cuentaId + "<br> Por favor, generar el task manualmente.<br>"
		enviarEmailInterno("info@calim.com.ar", "Error: Task Servicio no creada", contenido, 'errorTask')
		enviarEmailInterno(responsable, "Error: Task Servicio no creada", contenido, 'errorTask')
	}

	def notificarErrorDealCobranza(Long cuentaId, String descripcion){
		String contenido = "Ocurrió un error generando el deal de " + descripcion + " para la cuenta de Id " + cuentaId + "<br> Por favor, generar el deal manualmente.<br>"
		enviarEmailInterno("info@calim.com.ar", "Error: Deal Cobranza no creada", contenido, 'errorDeal')
		enviarEmailInterno("samanta@calim.com.ar", "Error: Deal Cobranza no creada", contenido, 'errorDeal')
	}

	def notificarUsuarioNuevaFactura(String email, String nombreApellido, Long facturaId){
		def nombre = nombreApellido.split(' ')[0]
		def factura = FacturaCuenta.get(facturaId)
		def tipo = factura.notaCredito ? "Nota de Crédito" : "Factura"
		def plantilla = NotificacionTemplate.findByNombre("Aviso Factura Servicio")
		String urlDescargaPdf = grailsLinkGenerator.link(controller: 'facturaCuenta', action: 'bajarPdf', absolute: true, params:['id': facturaId])
		String asuntoEmail = plantilla.llenarVariablesAsunto([tipo])
		String bodyMail = plantilla.llenarVariablesBody([nombre,tipo,urlDescargaPdf])
		String tituloApp = plantilla.llenarVariablesTituloApp([tipo])
		enviarEmail(email, asuntoEmail, bodyMail, 'aviso', null, tituloApp, plantilla.textoApp)
	}
	
	def enviarEmail(String destino, String asunto, String contenido,String tag=null,LocalDateTime horaProgramada=null,String tituloApp=null,String textoApp=null, archivo=null){
		def usuario = User.findByUsername(destino)
		def cuenta = null
		if(usuario!=null)
			cuenta = usuario.cuenta

		def http = new HTTPBuilder( 'https://api.mailgun.net/v3/app.calim.com.ar/messages' )
		http.auth.basic 'api', 'e1eb6834c3084eacc1440bde6c3116f3-f696beb4-f41a07c2'
		
		def email = new Email()
		email.emailTo = destino
		email.subject = asunto
		email.html = contenido
		email.tag = tag
		email.cuenta = cuenta
		email.fechaHora = new LocalDateTime()
		email.tituloNotificacionApp = tituloApp
		email.textoNotificacionApp = textoApp

		if(horaProgramada==null){
			if (Environment.current == Environment.PRODUCTION){
				def resp
				if(archivo == null){
						resp = mailService.sendMail {
						to destino
						from '"Calim" <notificaciones@calim.com.ar>'
						subject asunto
						html contenido
					}
				}
				else{
						resp = mailService.sendMail {
						multipart true
						to destino
						from '"Calim" <notificaciones@calim.com.ar>'
						subject asunto
						html contenido
						attachBytes archivo.name, "application/x-compressed", archivo.bytes
					}
				}
				if(cuenta && tituloApp)
					enviarNotificacionPush(cuenta.id,tituloApp,(textoApp ?: ''))		
				def mailgunId = resp.getMimeMessageHelper().mimeMessage.getHeader("Message-id").toString()
				email.mailgunId = mailgunId.getAt(2..(mailgunId.length()-3))
			}
			else{
				println "\n\nEnvío de mail externo"
				println "Destino: " + destino
				println "Asunto: " + asunto
				println "\nCuerpo:"
				println contenido + "\n"*3
				if(tituloApp)
					println "Envio de notificacion push"
			}
		}else{
			email.programado = true
			email.fechaHora = horaProgramada
		}

		email.save(flush:true)		    
	}
	
	def enviarEmailInterno(String destino, String asunto, String contenido, String tag=null, archivo=null){
		def http = new HTTPBuilder( 'https://api.mailgun.net/v3/app.calim.com.ar/messages' )
		http.auth.basic 'api', 'e1eb6834c3084eacc1440bde6c3116f3-f696beb4-f41a07c2'
		
		def email = new Email()
		email.emailTo = destino
		email.subject = asunto
		email.html = contenido
		email.tag = tag
		email.cuenta = null
		email.fechaHora = new LocalDateTime()

		if (Environment.current == Environment.PRODUCTION){
			if(archivo == null){
				mailService.sendMail {
					to destino
					from '"Calim" <notificaciones@calim.com.ar>'
					subject asunto
					html contenido
				}
			}
			else{
				mailService.sendMail {
				multipart true
				to destino
				from '"Calim" <notificaciones@calim.com.ar>'
				subject asunto
				html contenido
				attachBytes archivo.name, "application/x-compressed", archivo.bytes
				}
			}
		}
		else{
			println "\n\nEnvío de mail Interno"
			println "Destino: " + destino
			println "Asunto: " + asunto
			println "\nCuerpo:"
			println contenido + "\n"*3
		}
		email.save(flush:true)
	}
	
	def mailgunDelivered(MailgunCommand command){
		def email = Email.findByMailgunId(command.mailgunId)
		
		if(email!=null){
			email.delivered = true
			
			def mailgunNotification = new MailgunNotification()
			mailgunNotification.event = command.event
			mailgunNotification.recipient = command.recipient
			mailgunNotification.domain = command.domain
			mailgunNotification.ip = command.ip
			mailgunNotification.tag = command.tag
			mailgunNotification.mailingList = command.mailingList
			mailgunNotification.customVariables = command.customVariables
			mailgunNotification.timestamp = command.timestamp
			mailgunNotification.token = command.token
			mailgunNotification.signature = command.signature
			
			email.addToNotificaciones(mailgunNotification)
			email.save(flush:true)
		}
		return email
	}
	
	def mailgunClick(MailgunCommand command){
		def email = Email.findByMailgunId(command.mailgunId)
		
		if(email!=null){
			email.click = true
			
			def mailgunNotification = new MailgunNotification()
			mailgunNotification.event = command.event
			mailgunNotification.recipient = command.recipient
			mailgunNotification.domain = command.domain
			mailgunNotification.ip = command.ip
			mailgunNotification.country = command.country
			mailgunNotification.region = command.region
			mailgunNotification.city = command.city
			mailgunNotification.userAgent = command.userAgent
			mailgunNotification.deviceType = command.deviceType
			mailgunNotification.clientType = command.clientType
			mailgunNotification.clientName = command.clientName
			mailgunNotification.clientOs = command.clientOs
			mailgunNotification.tag = command.tag
			mailgunNotification.mailingList = command.mailingList
			mailgunNotification.customVariables = command.customVariables
			mailgunNotification.timestamp = command.timestamp
			mailgunNotification.token = command.token
			mailgunNotification.signature = command.signature
			
			email.addToNotificaciones(mailgunNotification)
			email.save(flush:true)
		}
		return email
	}
	
	def mailgunOpen(MailgunCommand command){
		def email = Email.findByMailgunId(command.mailgunId)
		if(email!=null){
			email.open = true
			def mailgunNotification = new MailgunNotification()
			mailgunNotification.event = command.event
			mailgunNotification.recipient = command.recipient
			mailgunNotification.domain = command.domain
			mailgunNotification.ip = command.ip
			mailgunNotification.country = command.country
			mailgunNotification.region = command.region
			mailgunNotification.city = command.city
			mailgunNotification.userAgent = command.userAgent
			mailgunNotification.deviceType = command.deviceType
			mailgunNotification.clientType = command.clientType
			mailgunNotification.clientName = command.clientName
			mailgunNotification.clientOs = command.clientOs
			mailgunNotification.tag = command.tag
			mailgunNotification.mailingList = command.mailingList
			mailgunNotification.customVariables = command.customVariables
			mailgunNotification.timestamp = command.timestamp
			mailgunNotification.token = command.token
			mailgunNotification.signature = command.signature
			
			email.addToNotificaciones(mailgunNotification)
			email.save(flush:true)
		}
		return email
	}
	
    def getNotificacionesNuevas(){
		def currentUser = accessRulesService.getCurrentUser()
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(currentUser, role)
		if(userRole!=null)
			return null
		
		//return currentUser?.notificaciones
		def lista
		lista = Notificacion.createCriteria().list(sort: "fechaHora", order: "desc"){
			eq('estado', Estado.NUEVO)
			eq('usuario', currentUser)
		}
		
		return lista
    }
	
	def getNotificaciones(){
		def currentUser = accessRulesService.getCurrentUser()
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(currentUser, role)
		if(userRole!=null)
			return null
		
		def lista
		lista = Notificacion.createCriteria().list(sort: "fechaHora", order: "desc"){
			and{
				eq('usuario', currentUser)
				or{
					eq('estado', Estado.NUEVO)
					eq('estado', Estado.LEIDO)
					eq('estado', Estado.NO_LEIDO)
				}
			}
		}
		
		return lista
	}
	
	def getNotificacionesNoLeidas(){
		def currentUser = accessRulesService.getCurrentUser()
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(currentUser, role)
		if(userRole!=null)
			return null
		
		def lista
		lista = Notificacion.createCriteria().list(sort: "fechaHora", order: "desc"){
			and{
				eq('usuario', currentUser)
				or{
					eq('estado', Estado.NUEVO)
					eq('estado', Estado.NO_LEIDO)
				}
			}
		}
		
		return lista
	}
	
	def setNotificacionLeida(Long id){
		def currentUser = accessRulesService.getCurrentUser()
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(currentUser, role)
		if(userRole!=null)
			return null
			
		def notificacion = Notificacion.get(id)
		
		notificacion.estado = Estado.LEIDO
		notificacion.save(flush:true)
	}
	
	def setNotificacionNoLeida(Long id){
		def currentUser = accessRulesService.getCurrentUser()
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(currentUser, role)
		if(userRole!=null)
			return null
			
		def notificacion = Notificacion.get(id)
		
		notificacion.estado = Estado.NO_LEIDO
		notificacion.save(flush:true)
	}
	
	def setNotificacionBorrada(Long id){
		def currentUser = accessRulesService.getCurrentUser()
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(currentUser, role)
		if(userRole!=null)
			return null
			
		def notificacion = Notificacion.get(id)
		
		notificacion.estado = Estado.BORRADO
		notificacion.save(flush:true)
	}

	def getNotificacionTemplate(Long id){
		def notificacionTemplate = NotificacionTemplate.get(id)
		return notificacionTemplate
	}
	def getNotificacionTemplateCommand(Long id){
		def notificacionTemplate = NotificacionTemplate.get(id)

		if(notificacionTemplate){
			def templateCommand = new NotificacionTemplateCommand()
			templateCommand.notificacionTemplateId = id
			templateCommand.nombre = notificacionTemplate.nombre
			templateCommand.asuntoEmail = notificacionTemplate.asuntoEmail
			templateCommand.cuerpoEmail = notificacionTemplate.cuerpoEmail
			templateCommand.tituloApp = notificacionTemplate.tituloApp
			templateCommand.textoApp = notificacionTemplate.textoApp

			return templateCommand
		}
		else
			return null
	}

	def saveTemplate(NotificacionTemplateCommand templateCommand){

		def notificacionTemplateInstance = new NotificacionTemplate()

		notificacionTemplateInstance.nombre = templateCommand.nombre
		notificacionTemplateInstance.asuntoEmail = templateCommand.asuntoEmail
		notificacionTemplateInstance.cuerpoEmail = templateCommand.cuerpoEmail
		notificacionTemplateInstance.tituloApp = templateCommand.tituloApp
		notificacionTemplateInstance.textoApp = templateCommand.textoApp

		notificacionTemplateInstance.save(flush:true, failOnError:true)
	}

	def updateTemplate(NotificacionTemplateCommand templateCommand){

		def notificacionTemplateInstance = NotificacionTemplate.get(templateCommand.notificacionTemplateId)

		if (templateCommand.version != null) {
			if (notificacionTemplateInstance.version > templateCommand.version) {
				NotificacionTemplateCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["NotificacionTemplate"] as Object[],
					"Mientras usted editaba, otro usuario ha modificado la plantilla")
				throw new ValidationException("Error de versión", NotificacionTemplateCommand.errors)
			}
		}

		notificacionTemplateInstance.nombre = templateCommand.nombre
		notificacionTemplateInstance.asuntoEmail = templateCommand.asuntoEmail
		notificacionTemplateInstance.cuerpoEmail = templateCommand.cuerpoEmail
		notificacionTemplateInstance.tituloApp = templateCommand.tituloApp
		notificacionTemplateInstance.textoApp = templateCommand.textoApp

		notificacionTemplateInstance.save(flush:true, failOnError:true)
	}

	def deleteTemplate(Long id){
		def notificacionTemplateInstance = NotificacionTemplate.get(id)
		notificacionTemplateInstance.delete(flush:true, failOnError:true)
	}

	def listTemplates(){
		def templates
		templates = NotificacionTemplate.getAll()
		return templates
	}

	def actualizarNotificacionesPendientesCuenta(Long id){
		def cuenta = Cuenta.get(id)
		def emails = Email.createCriteria().list(){
			eq('cuenta', cuenta)
		}
		emails.each{
			if(it.notificacionLeida == false || it.notificacionLeida == null){
				it.notificacionLeida = true
				it.save(flush:true, failOnError:true)
			}
		}
	}

	def notificarProforma(String nombre, String importe, String fecha, String email){

		NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Aviso Proforma")
		String bodyMail = plantilla.llenarVariablesBody([nombre, importe, fecha])
		enviarEmail(email, plantilla.llenarVariablesAsunto([nombre]), bodyMail, 'aviso', null, plantilla.llenarVariablesTituloApp([nombre]), plantilla.llenarVariablesBodyApp([importe]))

	}

	def notificarMonotributo(Long cuentaId){
		def cuenta = Cuenta.get(cuentaId)
		def nombre = cuenta.nombreApellido.split(" ")[0]
		def obraSocial = cuenta.obraSocial?.toString() ?: "-"

		String path = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuenta.path + "/comprobantes/"

		new File(path + "fotos " + cuenta.cuit + ".zip").with{
			if (exists())
				delete()
		}
		
		def zipFile = new java.util.zip.ZipOutputStream(new FileOutputStream(path + "comprobantes " + cuenta.cuit + ".zip"))

		new File(path).listFiles().each { file -> 
		  //check if file
		  if (file.isFile() && ! file.name.contains(".zip")){
		    zipFile.putNextEntry(new java.util.zip.ZipEntry(file.name))
		    def buffer = new byte[file.size()]  
		    file.withInputStream { 
		      zipFile.write(buffer, 0, it.read(buffer))  
		    }  
		    zipFile.closeEntry()
		  }
		}  
		zipFile.close()
		def archivo = new File(path + "comprobantes " + cuenta.cuit + ".zip")

		/*response.setContentType("APPLICATION/OCTET-STREAM")
		response.setHeader("Content-Disposition", "Attachment;Filename=\"${archivo.getName()}\"")
		ByteArrayOutputStream output = response.getOutputStream()*/

		NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Aviso Exito Monotributo")
		String bodyMail = plantilla.llenarVariablesBody([nombre,obraSocial])
		enviarEmail(cuenta.email,plantilla.llenarVariablesAsunto([nombre]),bodyMail,'aviso',null,plantilla.llenarVariablesTituloApp([nombre]),plantilla.textoApp,archivo)

	}

	def notificarErrorUsuario(Boolean fotos, Boolean claveFiscal, Boolean direccion, Boolean codigoPostal, Long cuentaId){
		def strFotos = fotos ? "👉<b>Fotos</b>: Tus fotos fueron rechazadas por AFIP por no cumplir las condiciones. Para tu selfie, asegúrate de realizarla con fondo blanco, sin anteojos ni cabello sobre tu rostro. En la foto de tu DNI, asegúrate de que todos tus datos sean bien visibles.<br><br>" : ""
		def strClave = claveFiscal ? "👉<b>Clave fiscal</b>: Es necesario que nos envíes una Clave Fiscal de AFIP válida. En caso de no recordarla, podés obtener una nueva Clave Fiscal desde la app de AFIP. Podés seguir los pasos de nuestro video tutorial: &nbsp<a href=”https://youtu.be/bfy5pHV4RAQ”>https://youtu.be/bfy5pHV4RAQ</a><br><br>" : ""
		def strDireccion = direccion ? "👉<b>Dirección</b>: La dirección que nos indicaste no se pudo comprobar. Colócala nuevamente en Calim exactamente igual a como figura en tu DNI.<br><br>" : ""
		def strCodigo = codigoPostal ? "👉<b>Código postal</b>: No se pudo comprobar tu código postal. Podés consultarlo desde esta pagina ingresando tu direccion : <br><a href=”https://www.correoargentino.com.ar/formularios/cpa”>https://www.correoargentino.com.ar/formularios/cpa</a><br><br>" : ""
		def cuenta = Cuenta.get(cuentaId)
		def nombre = cuenta.nombreApellido.split(" ")[0]

		
		NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Aviso Error Monotributo")
		String bodyMail = plantilla.llenarVariablesBody([nombre,strClave,strFotos,strDireccion,strCodigo])
		enviarEmail(cuenta.email, plantilla.llenarVariablesAsunto([nombre]), bodyMail, 'aviso', null, plantilla.llenarVariablesTituloApp([nombre]), plantilla.textoApp)
		

		cuentaService.errorAltaNotificado(cuentaId,fotos,claveFiscal,direccion,codigoPostal)
		//queda pendiente ver que hacemos con codpos y dir
		cuenta.save(flush:true,failOnError:true)
	} 

	def notificarFacturacionHabilitadaDelivery(Long cuentaId){
		def cuenta = Cuenta.get(cuentaId)
		def nombre = cuenta.nombreApellido.split(" ")[0]

		NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Aviso Factura Electronica habilitada rider")
		String bodyMail = plantilla.llenarVariablesBody([nombre])
		enviarEmail(cuenta.email, plantilla.asuntoEmail, bodyMail, 'aviso', null, plantilla.tituloApp, plantilla.textoApp)
	}
	
	/*def setNotificacionPasoBorrado(CustomerProgreso progreso){
		def currentUser = accessRulesService.getCurrentUser()
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(currentUser, role)
		if(userRole!=null)
			return null
			
		def notificaciones = Notificacion.findAllByProgreso(progreso)
		
		notificaciones.each{
			it.estado = Estado.BORRADO
			it.save(flush:true)
		}
	}*/
	
	/*def createNotificacion(User usuario, String titulo, String texto, CodigoNotificacion codigo, CustomerProgreso progreso, User remitente){
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(usuario, role)
		if(userRole!=null)
			return null
			
		def notificacion = new Notificacion()
		
		notificacion.estado = Estado.NUEVO
		notificacion.fechaHora = new LocalDateTime()
		notificacion.titulo = titulo
		notificacion.texto = texto
		notificacion.progreso = progreso
		notificacion.codigo = codigo
		notificacion.remitente = remitente
		
		usuario.addToNotificaciones(notificacion)
		usuario.save(flush:true)
	}*/
	
	/*def emitirNotificacion(User usuario, CodigoNotificacion codigo){
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(usuario, role)
		if(userRole!=null)
			return null
			
		if(checkNotificacion(usuario, codigo)){
			return null
		}
		
		switch(codigo){
			case CodigoNotificacion.SIN_LOTE:
				def loteLink = grailsLinkGenerator.link(controller: 'lote', action: 'create')
				def videoTutorialLoteCreate = 'https://youtu.be/v8tpURTRfak'
				
				createNotificacion(usuario, 
					messageSource.getMessage("zifras.notificacion.Notificacion.SIN_LOTE.titulo", [loteLink] as Object[], null), 
					messageSource.getMessage("zifras.notificacion.Notificacion.SIN_LOTE.texto", [loteLink, videoTutorialLoteCreate] as Object[], null),
					codigo,
					CustomerProgreso.SIN_LOTE, 
					null)
				break;
			case CodigoNotificacion.SIN_INSUMO:
				def loteLink = grailsLinkGenerator.link(controller: 'agroquimico', action: 'list')
				def videoTutorialLoteCreate = 'https://youtu.be/RL_hrh5Pp2M?list=PLlZ5XRj6MAH08zwpKnU8-R78AdE6fifqK'
				
				createNotificacion(usuario,
					messageSource.getMessage("zifras.notificacion.Notificacion.SIN_INSUMO.titulo", [loteLink] as Object[], null),
					messageSource.getMessage("zifras.notificacion.Notificacion.SIN_INSUMO.texto", [loteLink, videoTutorialLoteCreate] as Object[], null),
					codigo,
					CustomerProgreso.SIN_INSUMO,
					null)
				break;
			case CodigoNotificacion.SIN_STOCK_INSUMO:
				def loteLink = grailsLinkGenerator.link(controller: 'stockInsumo', action: 'list')
				def videoTutorialLoteCreate = 'https://youtu.be/RL_hrh5Pp2M?list=PLlZ5XRj6MAH08zwpKnU8-R78AdE6fifqK'
				
				createNotificacion(usuario,
					messageSource.getMessage("zifras.notificacion.Notificacion.SIN_STOCK_INSUMO.titulo", [loteLink] as Object[], null),
					messageSource.getMessage("zifras.notificacion.Notificacion.SIN_STOCK_INSUMO.texto", [loteLink, videoTutorialLoteCreate] as Object[], null),
					codigo,
					CustomerProgreso.SIN_STOCK_INSUMO,
					null)
				break;
			case CodigoNotificacion.MES_PRUEBA_PREMIUM:
				createNotificacion(usuario,
					messageSource.getMessage("zifras.notificacion.Notificacion.MES_PRUEBA_PREMIUM.titulo", [] as Object[], null),
					messageSource.getMessage("zifras.notificacion.Notificacion.MES_PRUEBA_PREMIUM.texto", [] as Object[], null),
					codigo,
					null,
					null)
				break;
		}
	}*/
	
	def checkNotificacion(User usuario, CodigoNotificacion codigo){
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(usuario, role)
		if(userRole!=null)
			return false
			
		def notificacion=null
		//Verifica si ya tiene la notificacion con este codigo
		usuario.notificaciones.each{
			if((it.codigo == codigo)&&(it.tenantId==usuario.miTenantId())){
				notificacion = it
			}
		}
		
		def resultado = false
		
		if(notificacion!=null){
			//Si la notificacion existe entonces verifica si tiene más de 1 día, de ser así la activa nuevamente
			//if((notificacion.estado == Estado.BORRADO)||(notificacion.estado == Estado.LEIDO)){
				def hoy = new LocalDateTime()
				def duracion = new Duration(notificacion.fechaHora.getLocalMillis(), hoy.getLocalMillis())
				
				def dias = duracion.getStandardDays()
				if(dias>=1){
					notificacion.estado = Estado.NUEVO
					notificacion.fechaHora = hoy
					notificacion.save(flush:true)
				}
			//}
			resultado = true
		}
		
		return resultado
	}
	
	/*def emitirNotificacion(User usuario, String titulo, String texto, CustomerProgreso progreso){
		def role = Role.findByAuthority("ROLE_ADMIN")
		
		def userRole = UserRole.findByUserAndRole(usuario, role)
		if(userRole!=null)
			return null
			
		def notificacion
		//Verifica si ya tiene la notificacion con el "progreso"
		usuario.notificaciones.each{
			if(it.progreso == progreso){
				notificacion = it
			}
		}
		
		if(notificacion==null){
			//Si no existe crea la notificacion
			createNotificacion(usuario, titulo, texto, progreso, null)
		}else{
			//Si existe y tiene el estado en BORRADO y pasó más de un día, la vuelve a activar
			def hoy = new LocalDateTime()
			if((notificacion.estado == Estado.BORRADO)||(notificacion.estado == Estado.LEIDO)){
				def duracion = new Duration(notificacion.fechaHora.getLocalMillis(), hoy.getLocalMillis())//new Period(notificacion.fechaHora, hoy)
				
				def dias = duracion.getStandardDays() //periodo.getDays() 
				if(dias>=1){
					try{
						notificacion.estado = Estado.NUEVO
						notificacion.fechaHora = hoy
						notificacion.save(flush:true)
					}catch(e){
					}
				}
			}
		}
	}*/

	def enviarNotificacionPush(cuentaId, String titleA, String bodyA){
		try {
			grails.gorm.multitenancy.Tenants.withId(2) {
				if (Environment.current == Environment.PRODUCTION){
					String tokenA = Cuenta.get(cuentaId)?.tokenFCM
					if (!tokenA)
						return
			 		def keyToken = "key=" + grailsApplication.config.getProperty('tokenFCM')
			 		
			 		def http = new HTTPBuilder('https://fcm.googleapis.com')
					http.request( POST ) {
					    uri.path = '/fcm/send'
					    requestContentType = JSON
					    body =  [notification: [title:titleA,body:bodyA], to: tokenA]
					 	headers."Authorization" = keyToken
					    response.success = { resp ->
					    	if ("${resp.statusLine}" != "HTTP/1.1 200 OK")
					        	println "Firebase POST response status: ${resp.statusLine}"
			    		}
					}
				}
			}
		}
		catch(Exception e) {
			log.error("No pudo enviarse push a la cuenta $cuentaId \nError: " + e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
	}

	def crearEmailNotificacion(cuentaId, String tituloApp, String bodyApp){
		def cuenta = Cuenta.get(cuentaId)
		def email = new Email()
		email.tituloNotificacionApp = tituloApp
		email.textoNotificacionApp = bodyApp
		email.fechaHora = new LocalDateTime()
		email.cuenta = cuenta
		email.save(flush:true,failOnError:true)
	}
}
