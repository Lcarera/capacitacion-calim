package com.zifras.security

import com.zifras.AccessRulesService
import com.zifras.BitrixService
import com.zifras.Contador
import com.zifras.Estado
import com.zifras.Provincia
import com.zifras.TokenGoogle
import com.zifras.User
import com.zifras.afip.AfipService
import com.zifras.app.App
import com.zifras.cuenta.CondicionIva
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.Domicilio
import com.zifras.cuenta.MovimientoCuenta
import com.zifras.cuenta.MovimientoCuentaService
import com.zifras.cuenta.ObraSocial
import com.zifras.cuenta.RegimenIibb
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.FacturaCuentaService
import com.zifras.documento.PagoCuentaService
import com.zifras.notificacion.ConsultaWeb
import com.zifras.notificacion.NotificacionService
import com.zifras.notificacion.NotificacionTemplate
import com.zifras.servicio.ItemServicioEspecial
import com.zifras.servicio.Servicio
import com.zifras.ventas.Vendedor
import com.zifras.ventas.VendedorService
import com.zifras.GoogleAPIService

import grails.converters.JSON
import grails.gorm.multitenancy.Tenants
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.annotation.Secured
import grails.plugin.springsecurity.authentication.dao.NullSaltSource
import grails.plugin.springsecurity.ui.AbstractS2UiController
import grails.plugin.springsecurity.ui.RegistrationCode
import groovyx.net.http.HTTPBuilder
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.springframework.context.i18n.LocaleContextHolder
import org.springframework.web.context.request.RequestContextHolder

@Secured(['permitAll'])
class RegistrarController extends AbstractS2UiController {

	// override default value from base class
	//static defaultAction = 'index'

	// override default value from base class
	static allowedMethods = [register: 'POST']

	def accessRulesService
	def bitrixService
	def mailService
	def messageSource
	def saltSource
	def springSecurityService
	def cuentaService
	def usuarioService
	def notificacionService
	def facturaCuentaService
	def movimientoCuentaService
	def pagoCuentaService
	def afipService
	def googleAPIService
	static vendedorService

	//final static String authClientify = "Token f63209a04d811cb7923713286231b920d5c5ac03"

	def index() {
		/*def copy = [:] + (flash.chainedParams ?: [:])
		copy.remove 'controller'
		copy.remove 'action'
		[command: new RegisterCommand(copy)]*/
		render view: 'index'
	}

	def registerMail(RegisterCommand command){
		//Muestra pantalla con formulario registro
		[datos:command]
	}

	def register(RegisterCommand command, Boolean app) {

		if (command.hasErrors()) {
			command.errors.allErrors.each {
				flash.message = it
			}
			render view: 'registerMail', model: [datos: command]
			return
		}
		command.with{
			username = username.toLowerCase()
		}
		def cuentaRegistrada
		try {
			cuentaRegistrada = cuentaService.registrarCuenta(command) //Se guarda el usuario con accountLocked = true
		}catch (e){
			flash.error	= message(code: 'zifras.cuenta.Cuenta.save.error', default: 'Error al intentar registrar la cuenta')
			render(view: "registerMail", model: [datos: command])
			return
		}

		def registrationCode = new RegistrationCode(username: command.username)
		registrationCode.save(flush: true)

		String url = generateLink('verifyRegistration', [t: registrationCode.token])

		String urlNotificaciones = usuarioService.getLinkDesactivarNotificaciones(usuarioService.getUsuario(command.username))

		def conf = SpringSecurityUtils.securityConfig
		//def bodyMail = message(code: 'calim.register.email.body', args: [url, urlNotificaciones])
		//String asunto = message(code: 'calim.register.email.subject', default:'Bienvenido a Calim')
		NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Email Registro")
		String bodyMail = plantilla.llenarVariablesBody([url,urlNotificaciones])
		notificacionService.enviarEmail(command.username, plantilla.asuntoEmail, bodyMail, 'registro', null, plantilla.tituloApp, plantilla.textoApp)

		Thread.start {
			def respuesta = bitrixService.guardarEnBitrix(command, cuentaRegistrada, "Registro Normal",null)
		}

		render(view: "mailRegistro")  //ANTES REDIRIGIA A MAILREGISTRO
		return
	}

	def terminosYCondiciones(){
	
	}

	@Secured(['ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
	def pasosRegistro(Boolean volver, Boolean mobile){
		/*
		Variable volver:
				True: Resta uno al paso actual.
				False: Guarda info y avanza de paso.
				Null: No hace ninguno de los anteriores, solamente renderiza.
		*/
		def cuentaInstance = accessRulesService.getCurrentUser()?.cuenta
		def cuentaId = cuentaInstance.id
		def pasoActual = params.pasoActual ?: cuentaService.getStepRegistro(cuentaInstance.id) //Es considerado en cada submit, a menos que el usuario haga refresh (en ese caso leo el guardado)
		def pasoSiguiente
		def modelPasoSiguiente = [:]

		if (volver == true){
			// Switch que al paso actual le resta uno y guarda en resultado el paso siguiente...
			switch (pasoActual){
				case "seleccionProfesion":
					pasoSiguiente="telefonoContacto"
					break
				case "seleccionApps":
					pasoSiguiente="seleccionProfesion"
					break
				case "adheridoMonotributo":
					pasoSiguiente="seleccionApps"
					modelPasoSiguiente['apps'] = App.getAll()
					break
				case "ingresoDNI":
					if(!cuentaInstance.inscriptoAfip && cuentaInstance.trabajaConApp())
						pasoSiguiente="adheridoMonotributo"
					else
						pasoSiguiente="poseeCUIT"
					break
				case "relacionDependencia":
					if(cuentaInstance.trabajaConApp())
						pasoSiguiente="ingresoDNI"
					else
						// pasoSiguiente="ingresoRangoFacturacion"
						pasoSiguiente="ingresoDescripcionActividad"
					break
				case "ingresoProvincia":
					if(cuentaInstance.inscriptoAfip){
						try{
							def datos=showDatosRefactor(cuentaInstance.cuit)
							pasoSiguiente = "showDatosRefactor"
							modelPasoSiguiente['datos']=datos
							break
						}
						catch(e){
							pasoSiguiente = "errorCUIT"
							modelPasoSiguiente['cuit']=cuentaInstance.cuit
							break
						}
					}
					else{
						if(cuentaInstance.trabajaConApp())
							pasoSiguiente="ingresoDomicilio"
						else
							pasoSiguiente="relacionDependencia"
					}

					break
				case "resultadoMonotributo":
					pasoSiguiente="ingresoProvincia"
					break
				case "seleccionObraSocial":
					pasoSiguiente="ingresoProvincia"
					break
				case "resumen":
					pasoSiguiente="seleccionObraSocial"
					modelPasoSiguiente['idOsdepym'] = ObraSocial.findBySigla("OSDEPYM").id
					break
				case "showDatosRefactor":
					if(cuentaInstance.inscriptoAfip)
						pasoSiguiente="ingresoCUIT"
					else
						pasoSiguiente="ingresoDNI"
					break
				case "ingresoDomicilio":
					pasoSiguiente="ingresoDNI"
					break
				case "ingresoDescripcionActividad":
					pasoSiguiente="ingresoDomicilio"
					break/*
				case "ingresoRangoFacturacion":
					pasoSiguiente="ingresoDescripcionActividad"
					break*/
				case "poseeCUIT":
					pasoSiguiente = "seleccionProfesion"
					break
				case "ingresoCUIT":
					if(cuentaInstance.trabajaConApp()){
						pasoSiguiente="adheridoMonotributo"
						Thread.start{
							bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),["fields":["UF_CRM_1600954662":"in-deal"]]) //Status
						}
					}
					else
						pasoSiguiente="poseeCUIT"
					break
				case "errorCUIT":
					pasoSiguiente="ingresoCUIT"
					break
			}

		}else if (volver == false){
			switch(pasoActual) {
				//Es el primer paso, se renderiza "telefonoContacto"
				case null:
				case "":
					pasoSiguiente = "telefonoContacto"
					break
				//Viene del paso "telefonoContacto", se actualiza el teléfono y luego debe ir ahora a "seleccionProfesion"
				case "telefonoContacto":
					def celular = corregirTelefono(params.celular)
					cuentaService.actualizarCelular(cuentaId, celular)
					pasoSiguiente = "seleccionProfesion"
					// Actualizo bitrix:
					
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
							"fields":
								[
								"PHONE":[["VALUE":celular]],
								"UF_CRM_1611603905329":"https://api.whatsapp.com/send?phone="+celular
								]
							])
					
					break
				//Viene de "seleccionProfesion", se actualiza la profesión y según la selección se va a "seleccionApps" ó "poseeCUIT"
				case "seleccionProfesion":
					def profesion = params.profesion
					cuentaService.actualizarProfesion(cuentaId, profesion)
					Thread.start {
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
						"fields":
							[
							"UF_CRM_1600972463": profesion
							]
						])
					}
					def vendedorAsignado = vendedorService.getVendedorAAsignar()
					crearContactoGoogle(cuentaInstance.nombreApellido?.split()[0],cuentaInstance.nombreApellido?.split()[1],cuentaInstance.whatsapp,cuentaInstance.email,vendedorAsignado.nombre)
					if (profesion == "app"){
						Thread.start{
							bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),["fields":["UF_CRM_1600954662":"in-deal"]]) //Status
							def bitrixDealId = bitrixService.crearNegociacionBitrix(cuentaInstance.bitrixId?.toString(),"Registro Delivery",vendedorAsignado.email,"delivery")
							cuentaService.actualizarBitrixDealId(cuentaId,bitrixDealId)
						}
						pasoSiguiente = "seleccionApps"
					}
					else{
						Thread.start{
							String titulo = profesion == "mercadolibre" ? "Registro MercadoLibre" : "Registro Normal"
							bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),["fields":["UF_CRM_1600954662":"in-deal"]]) //Status
							def bitrixDealId = bitrixService.crearNegociacionBitrix(cuentaInstance.bitrixId?.toString(),titulo,vendedorAsignado.email,"general")
							cuentaService.actualizarBitrixDealId(cuentaId,bitrixDealId)
						}
						pasoSiguiente = "poseeCUIT"
					}
					modelPasoSiguiente['apps'] = App.getAll()
					break
				//Viene de "seleccionApps", se actualiza la app que eligió y se va a "adheridoMonotributo"
				case "seleccionApps":
					def apps
					if (params.mobile)
						apps = params['app'].split(',')
					else
						apps = params.app
					String appsString = cuentaService.actualizarApps(cuentaId, apps)
					Thread.start {
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
							"fields":
								[
								"UF_CRM_1600953768": appsString //App
								]
							])
					}
					def appOtro = App.findByNombre("Otro").id
				
					if(!cuentaInstance.trabajaConApp())
						pasoSiguiente = "poseeCUIT"
					else
						pasoSiguiente = "adheridoMonotributo"
					break
				//Viene de "adheridoMonotributo", se actualiza la respuesta y si tiene monotributo va a "ingresoCUIT" "ingresoDNI"
				case "adheridoMonotributo":
					boolean inscripto = new Boolean(params.inscriptoAfip)
					cuentaService.actualizarInscriptoAfip(cuentaId, inscripto)
					if(cuentaInstance.bitrixDealId && inscripto){
						try{
							bitrixService.editarNegociacion(cuentaInstance.bitrixDealId,["fields":["STAGE_ID":"C5:EXECUTING"]]) //se pasa a stage No necesita Mono
						}
						catch(e){
							log.error("Error actualizando stage de Deal a No necesita Mono")
						}
					}
					pasoSiguiente = inscripto ? "ingresoCUIT" : "ingresoDNI"
					Thread.start {
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
							"fields":
								[
								"UF_CRM_1600953757": inscripto //Inscripto Afip
								]
							])
					}
					break
				//Viene de "ingresoDNI", se actualizan los datos y va a "relacionDependencia"
				case "ingresoDNI":
					String sexo = params.sexo
					String docTipo = params.tipoDocumento
					def docNro = params.documento
					String nacionalidadId = params.nacionalidadId
					cuentaService.actualizarDocumento(cuentaId, docNro, docTipo)
					cuentaService.actualizarSexo(cuentaId, sexo)
					cuentaService.actualizarNacionalidad(cuentaId, nacionalidadId)
					Thread.start {
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
							"fields":
								[
								"UF_CRM_1600953715": sexo, //Sexo
								"UF_CRM_1600953733": docTipo //Tipo Doc
								]
							])
					}
					if (cuentaInstance.trabajaConApp())
						pasoSiguiente = "ingresoDomicilio"
					else {
						if (docTipo == "dni") {
							try {
								def cuit = cuentaService.calcularCUIT(docNro, sexo == "hombre")
								def datos = showDatosRefactor(cuit)
								pasoSiguiente = "showDatosRefactor"
								modelPasoSiguiente['datos'] = datos
								break
							}
							catch (e) {
								cuentaInstance.cuit = cuentaInstance.email
							}
						}
						pasoSiguiente = "ingresoDomicilio"
					}
					break
				//Viene de "relacionDependencia", se actualiza y va a "ingresoProvincia"
				case "relacionDependencia":
					Boolean reldep = params.relacionDependencia == "Si"
					cuentaService.actualizarEstadoRelacionDependencia(cuentaId, reldep)
					
					Thread.start {
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
							"fields":
								[
								"UF_CRM_1600953682": reldep //Relacion Dependencia
								]
							])
					}
					pasoSiguiente = "ingresoProvincia"
					break
				//Viene de "ingresoProvincia", se actualiza y va a "resultadoMonotributo"
				case "ingresoProvincia":
					String provincia = cuentaService.actualizarProvincia(cuentaId, params.provinciaId)
					String nombreOportunidad
					if (cuentaInstance.with { inscriptoAfip || ! trabajaConApp() }){ // Este IF excluye del mail al caso de APP con botón de pago
						if (cuentaInstance.trabajaConApp())
							nombreOportunidad = "Registro APP (con CUIT)"
						else if (cuentaInstance.inscriptoAfip){
							nombreOportunidad = "Registro normal"
							if (cuentaInstance.registroConErrorAFIP)
								nombreOportunidad += " (con error)"
						}
						else
							nombreOportunidad = "Registro normal (no tiene CUIT)"
					}
					Thread.start {
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
							"fields":
								[
								"UF_CRM_1600953583": provincia //Provincia
								]
							])
					}
					if (cuentaInstance.inscriptoAfip) {
						cuentaService.activarCuenta(cuentaInstance)
						if (mobile)
							render "OK"
						else
							redirect(controller: "dashboard", action: "index")
						return
					}
					else {
						if (cuentaInstance.trabajaConApp()) {
							pasoSiguiente = "seleccionObraSocial"
							modelPasoSiguiente['importeMonotributo'] = calcularImporteMonotributo(cuentaInstance)
							modelPasoSiguiente['idOsdepym'] = ObraSocial.findBySigla("OSDEPYM").id
						}
						else {
							// Envío mail tutorial:
								def usuario = accessRulesService.getCurrentUser()
								String urlNotificaciones = usuarioService.getLinkDesactivarNotificaciones(usuario)
								def nombre = (usuario.cuenta.nombreApellido.split(' '))[0]
								//def body = messageSource.getMessage('calim.email.body.panelRequisitos', [nombre, urlNotificaciones] as Object[], '', LocaleContextHolder.locale)
								//String asunto = messageSource.getMessage('calim.email.asunto.panelRequisitos', [] as Object[], '', LocaleContextHolder.locale)
								NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Instrucciones Clave Fiscal")
								String bodyMail = plantilla.llenarVariablesBody([nombre,urlNotificaciones])

								notificacionService.enviarEmail(usuario.username, plantilla.asuntoEmail, bodyMail, 'instrucciones', null, plantilla.tituloApp, plantilla.textoApp)
							// Activo la cuenta y mando a dashboard:
							cuentaService.activarCuenta(cuentaInstance)
							if (mobile)
								render "OK"
							else
								redirect(controller: "dashboard", action: "index")
							return
						}
					}
					break
				//Viene de "ingresoProvincia" si trabaja con app, va a resumen"	
				case "seleccionObraSocial":
					String obraSocialId = params.obraSocialId
					cuentaService.actualizarObraSocial(cuentaId, obraSocialId)
					Boolean cuentaRappi = cuentaInstance.apps.collect{it.app.nombre}.any{it == "Rappi"}
					if(cuentaInstance.bitrixDealId){
						try{
							bitrixService.editarNegociacion(cuentaInstance.bitrixDealId,["fields":["STAGE_ID":"C5:PREPAYMENT_INVOICE"]]) //se pasa a stage Informo Obra Social
						}
						catch(e){
							log.error("Error actualizando stage de Deal a Informo Obra Social")
						}
					}
					modelPasoSiguiente['cuentaRappi'] = cuentaRappi
					modelPasoSiguiente['importeCalim'] = obtenerSmAlta(cuentaRappi)?.precio
					pasoSiguiente = "resumen"
					break
				//Viene de "resultadoMonotributo", se va a "resumen"
				case "resultadoMonotributo":
					def importeCalim = Servicio.findByCodigo("SE03")?.precio ?: new Double(690)
					pasoSiguiente = "resumen"
					modelPasoSiguiente['importeCalim'] = importeCalim
					break
				//Viene de "resumen", se hace redirect
				case "resumen":
					if(cuentaInstance.trabajaConApp())
						cuentaService.guardarStepRegistro(cuentaId,"registroEnCurso")
					cuentaService.activarCuenta(cuentaInstance)
					if(mobile){
						render generarFacturaInscripcion(cuentaId).linkPago 
					}
					else{
						redirect(url: generarFacturaInscripcion(cuentaId).linkPago)
					}
					return
					break
				case "poseeCUIT":
					Boolean inscripto = new Boolean(params.inscriptoAfip)
					cuentaService.actualizarInscriptoAfip(cuentaId, inscripto)
					Thread.start {
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
							"fields":
								[
								"UF_CRM_1600953757": inscripto //Inscripto Afip
								]
							])
					}
					if(params.inscriptoAfip=="true")
						pasoSiguiente="ingresoCUIT"
					else
						pasoSiguiente="ingresoDNI"
					break
				case "ingresoCUIT":		
					def datos
					def cuit = params.cuit
					Thread.start {
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
							"fields":
								[
								"UF_CRM_1600954388": cuit //CUIT
								]
							])
					}
					try{
						datos=showDatosRefactor(cuit)
						pasoSiguiente = "showDatosRefactor"
						modelPasoSiguiente['datos']=datos
					}catch(e){
						pasoSiguiente="errorCUIT"
						modelPasoSiguiente['cuit']=cuentaInstance.cuit
					}	
					break
				case "errorCUIT":
					cuentaService.actualizarErrorAfip(cuentaId, true)
					if (cuentaInstance?.tokenTiendaNube){
						cuentaService.actualizarProvincia(cuentaId, Provincia.findByNombre("CABA").id.toString())
						cuentaService.activarCuenta(cuentaInstance)
						if (mobile)
							render "OK"
						else
							redirect(controller: "dashboard", action: "index")
						return
					}
					pasoSiguiente="ingresoProvincia"
					break
				case "showDatosRefactor":
					if(confirmarCUIT(params.cuit)){
						cuentaService.actualizarErrorAfip(cuentaId, false)
						if (cuentaInstance?.tokenTiendaNube){
							cuentaService.actualizarProvincia(cuentaId, Provincia.findByNombre("CABA").id.toString())
							cuentaService.activarCuenta(cuentaInstance)
							if (mobile)
								render "OK"
							else
								redirect(controller: "dashboard", action: "index")
							return
						}
						if(cuentaInstance.inscriptoAfip)
							pasoSiguiente="ingresoProvincia"
						else
							pasoSiguiente="ingresoDomicilio"
					}
					else
						pasoSiguiente="ingresoCUIT"
					
					break	
				case "ingresoDomicilio":
					Provincia provincia = Provincia.get(params.provinciaId)
					String localidad = params.localidad
					String codigoPostal = params.codigoPostal
					String direccion = params.direccion
					Thread.start {
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
							"fields":
								[
								"UF_CRM_1600953583": provincia.nombre, //Provincia
								"ADDRESS": direccion,
								"ADDRESS_POSTAL_CODE":codigoPostal,
								"ADDRESS_CITY": localidad
								]
							])
					}
					def domicilio = new Domicilio()
					//Harcodeamos CABA para que luego se modifique cuando conteste la provincia
					domicilio.provincia = provincia
					domicilio.localidad = localidad
					domicilio.pisoDpto = params.pisoDpto
					domicilio.codigoPostal = codigoPostal
					domicilio.direccion = direccion

					cuentaService.actualizarDomicilio(cuentaId, domicilio)
					if(cuentaInstance.trabajaConApp())
						pasoSiguiente = "ingresoProvincia"
					else
						pasoSiguiente = "ingresoDescripcionActividad"
					break
				case "ingresoDescripcionActividad":
					String descActividad = params.descripcion
					Thread.start {
						bitrixService.editarContacto(cuentaInstance.bitrixId?.toString(),[
							"fields":
								[
								"UF_CRM_1600970981": descActividad //Descripcion Actividad
								]
							])
					}
					cuentaService.actualizarDescripcionActividad(cuentaId, descActividad)/*
					pasoSiguiente = "ingresoRangoFacturacion"
					break
				case "ingresoRangoFacturacion":
					String rangoFacturacion = params.rangoFacturacion
				
					cuentaService.actualizarRangoFacturacion(cuentaId, rangoFacturacion)*/
					pasoSiguiente = "relacionDependencia"
					break
			}
		}else{
			if((pasoActual==null)||(pasoActual==""))
				pasoActual = "telefonoContacto"
			pasoSiguiente = pasoActual
			def importeCalim = Servicio.findByCodigo("SE03")?.precio ?: new Double(690)
			modelPasoSiguiente['importeCalim'] = importeCalim
			modelPasoSiguiente['importeMonotributo'] = calcularImporteMonotributo(cuentaInstance)
			modelPasoSiguiente['apps'] = App.getAll()
			modelPasoSiguiente['cuit'] = cuentaInstance.cuit
			if (pasoActual == "showDatosRefactor")
				modelPasoSiguiente['datos'] = showDatosRefactor(cuentaInstance.cuit)
		}
		if(pasoSiguiente!=null)
			cuentaService.guardarStepRegistro(cuentaId,pasoSiguiente)
		modelPasoSiguiente['tiendaNube'] = !! cuentaInstance?.tokenTiendaNube
		if(mobile)
			render pasoSiguiente
		else
			render(view: pasoSiguiente, model:modelPasoSiguiente)
	}

	def accesoDashboard(){

		def cuentaInstance = accessRulesService.getCurrentUser()?.cuenta
		cuentaService.activarCuenta(cuentaInstance)
		redirect(controller:"dashboard", action:"index")
	}
	def linkMP(Long cuentaId){
		redirect(url: generarFacturaInscripcion(accessRulesService.getCurrentUser().cuenta.id).linkPago)
	}

	def generarFacturaInscripcion(Long cuentaId){
		def cuentaInstance = Cuenta.get(cuentaId)
		println cuentaId
		Servicio servicioInstance = obtenerSmAlta(cuentaInstance.apps.collect{it.app.nombre}.any{it == "Rappi"})

		FacturaCuenta facturaCuenta = FacturaCuenta.findByCuenta(cuentaInstance) // Una cuenta recién registrada no puede tener más de una factura, así que agarramos esa.
		if(!facturaCuenta)
			facturaCuenta = facturaCuentaService.generarPorItemsServicio([new ItemServicioEspecial().with{
						servicio = servicioInstance
						cuota = 1
						totalCuotas = 1
						cuenta = cuentaInstance
						responsable = "alejandro@calim.com.ar"
						precio = servicioInstance.precio
						fechaAlta = new LocalDate()
						save(flush:true, failOnError:true)
					}])

		return facturaCuenta
	}

	@Secured(['ROLE_ADMIN'])
	def borrarContactosGoogleAntiguos(){
		try{
			googleAPIService.borrarContactosAntiguos(TokenGoogle.findByUsuario("Cuenta Contactos 1").refreshToken) //actualmente se borran 2000 contactos 
			println "CONTACTOS ANTIGUOS BORRADOS CORRECTAMENTE"
		}
		catch(e){
			println "Ocurrio un error borrando los contactos antiguos"
		}
		
		render "aa"
	}

	def crearContactoGoogle(String nombre, String apellido, String telefono, String email, String vendedor){

		try {	
				def vend = Vendedor.findByNombre(vendedor)
				def token = vend?.tokenGoogle
				if(!token)
					token = TokenGoogle.findByUsuario("Cuenta Contactos " + vendedor)
				googleAPIService.crearContacto(token.refreshToken, nombre, apellido, telefono, email)
			}
			catch(java.lang.NoSuchMethodError e) {
				println "\nError guardando contacto de Google en Cuenta Contactos " + vendedor
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				try{
					googleAPIService.crearContacto(TokenGoogle.findByUsuario("Cuenta Contactos 2").refreshToken, nombre, apellido, telefono, email)
				}catch(ex){
					println "Error guardando contacto de Google en Cuenta Backup"
				}
			}
			catch(Exception e) {
				println "\nError guardando contacto de Google en Cuenta Contactos " + vendedor
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				try{
					googleAPIService.crearContacto(TokenGoogle.findByUsuario("Cuenta Contactos 2").refreshToken, nombre, apellido, telefono, email)
				}catch(ex){
					println "Error guardando contacto de Google en Cuenta Backup"
				}
			}
			catch(e) {
				println "\nError guardando contacto de Google en Cuenta Contactos " + vendedor
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				try{
					googleAPIService.crearContacto(TokenGoogle.findByUsuario("Cuenta Contactos 2").refreshToken, nombre, apellido, telefono, email)
				}catch(ex){
					println "Error guardando contacto de Google en Cuenta Backup"
				}
			}
			return
		}

	private calcularImporteMonotributo(Cuenta cuenta){
		return cuenta.relacionDependencia ? new Double(168.97) : new Double(1955.68)
	}

	def appGetImportes(){
		def cuentaInstance = accessRulesService.getCurrentUser()?.cuenta
		Boolean cuentaRappi = cuentaInstance.apps.collect{it.app.nombre}.any{it == "Rappi"}
		def importeCalim = obtenerSmAlta(cuentaRappi)?.precio
		def returnArray = [:]
		returnArray['relacionDependencia'] = 168.97
		returnArray['noRelacionDependencia'] = 1955.68
		returnArray['cuentaRappi'] = cuentaRappi
		returnArray['costoInscripcion'] = importeCalim

		render returnArray as JSON
	}

  def showDatosRefactor(String cuit){
		def command
		boolean hayError = false
		def cuentaId =  accessRulesService.getCurrentUser()?.cuenta.id
		if(cuentaId){
			try{
				cuentaService.guardarStepRegistro(cuentaId,params.action)
			}
			catch(e){
				log.error("Error actualizando step de cuenta")
				cuentaService.guardarStepRegistro(cuentaId,params.action)
			}
		}

		try {
			def usuario = accessRulesService.getCurrentUser()
			cuentaService.actualizarCuit(usuario.cuenta.id, cuit)
			command = afipService.llenarCommandRegistro(cuit)
		}
		catch(java.lang.AssertionError e){
			String mensaje = e.message.substring(0,e.message.indexOf('..')+1) + "\nDentro de las próximas 48 horas un asesor te contactará para ayudarte a solucionarlo."
			flash.error = mensaje
			//Hago el substring porque el mensaje de la excepción es '(el mensaje que mandé desde el service, terminado en .).Expression(La linea que falló)' y sólo me interesa mostrar el mensaje original
			hayError = true
			throw new Exception("Error inesperado")
		}
		catch(Exception e) {
			log.error(e.message)
			if (e.localizedMessage.contains('No existe')){
				flash.error = "El cuit ingresado no existe."
				throw new Exception("Cuit inexistente")
			}
			else{
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				flash.error="Ocurrió un error intentando recuperar los datos de la AFIP."
				throw new Exception("Error del sistema")
			}
			hayError = true
		}
		return command
	}

	def appGetDatosCuit(String cuit) {
		def command
		String errorMsg
		boolean hayError = false
		def returnArray = [:]
		
		try {
			def usuario = accessRulesService.getCurrentUser()
			cuentaService.actualizarCuit(usuario.cuenta.id, cuit)
			command = afipService.llenarCommandRegistro(cuit)

		}
		catch(java.lang.AssertionError e){
			String mensaje = e.message.substring(0,e.message.indexOf('..')+1) + "\nDentro de las próximas 48 horas un asesor te contactará para ayudarte a solucionarlo."
			errorMsg = mensaje
			//Hago el substring porque el mensaje de la excepción es '(el mensaje que mandé desde el service, terminado en .).Expression(La linea que falló)' y sólo me interesa mostrar el mensaje original
			hayError = true
		}
		catch(Exception e) {
			log.error(e.message)
			if (e.localizedMessage.contains('No existe')){
				returnArray['error'] = "El cuit ingresado no existe."
				// TODO: Acá bloqueamos la cuenta y lo redirigimos a otra pantalla
			}
			else{
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				returnArray['error'] = "Ocurrió un error intentando recuperar los datos de la AFIP."
			}
			hayError = true
		}

		if (hayError){
			render returnArray as JSON
			return
		}

		returnArray['cuit'] = command.cuit;
		returnArray['nombre'] = command.nombre;
		returnArray['apellido'] = command.apellido;
		returnArray['razonSocial'] = command.razonSocial;
		returnArray['tipo'] = command.tipo;
		returnArray['localidad'] = command.localidad;
		returnArray['domicilio'] = command.domicilio;
		returnArray['tipoIva'] = command.tipoIva;
		returnArray['actividad'] = command.actividad;
		returnArray['impuestos'] = command.impuestos;
		returnArray['categoria'] = command.categoria;
		returnArray['error'] = null;

		render returnArray as JSON

	}

	def confirmarCUIT(String cuit){
		def errorMsg
		try {
			def usuario = accessRulesService.getCurrentUser()
			afipService.guardarResponseEnCuenta(cuit, usuario.cuenta.id)

			def cuenta = cuentaService.getCuentaByEmail(usuario.username)

			String nombreUsuario = ""
			if(cuenta!=null){
				nombreUsuario = (cuenta.nombreApellido.split(' '))[0]
			}

			String urlNotificaciones = usuarioService.getLinkDesactivarNotificaciones(usuario)

			//def body = message(code: 'calim.register.email.bienvenido.body', args: [nombreUsuario, urlNotificaciones])
			//String asunto = message(code: 'calim.register.email.bienvenido.subject')
		
			NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Email Bienvenido")
			String bodyMail = plantilla.llenarVariablesBody([nombreUsuario,urlNotificaciones])

			notificacionService.enviarEmail(usuario.username, plantilla.asuntoEmail, bodyMail, 'bienvenido', null, plantilla.tituloApp, plantilla.textoApp)

			//Se programa email para enviar en una hora

			//def body2 = message(code: 'calim.nosVamosAComunicarConVos.email.body', args: [nombreUsuario, urlNotificaciones])
			//String asunto2 = message(code: 'calim.nosVamosAComunicarConVos).email.subject')


			String mensajeHtml = "Email: " + usuario.username + "<br/>CUIT: " + cuit + '<br/><br/><br>/<br/>'
			try {
				def parseoAfip = afipService.llenarCommandRegistro(cuit)
				mensajeHtml += "Dump de datos obtenidos de la AFIP:<br/><br/><br/>" + "<br/>" + 'Actividad:' + parseoAfip.actividad + "<br/>" + 'Apellido:' + parseoAfip.apellido + "<br/>" + 'Categoria:' + parseoAfip.categoria + "<br/>" + 'Cuit:' + parseoAfip.cuit + "<br/>" + 'Domicilio:' + parseoAfip.domicilio + "<br/>" + 'Impuestos:' + parseoAfip.impuestos + "<br/>" + 'Localidad:' + parseoAfip.localidad + "<br/>" + 'Nombre:' + parseoAfip.nombre + "<br/>" + 'Razón Social:' + parseoAfip.razonSocial + "<br/>" + 'Tipo:' + parseoAfip.tipo + "<br/>" + 'Tipo Iva:' + parseoAfip.tipoIva   
			}
			catch(java.lang.AssertionError e){
				mensajeHtml += "Ocurrió un error obteniendo el parseo de datos de la AFIP."
			}
			catch(Exception e) {
				mensajeHtml += "Ocurrió un error obteniendo el parseo de datos de la AFIP."
			}
			// notificacionService.enviarEmailInterno("info@calim.com.ar", "Usuario CALIM con CUIT", mensajeHtml, 'verificacionCUIT')
		}
		catch(Exception e) {
			log.error(e.message)
			errorMsg = "Ocurrió un error guardando los datos de la AFIP en la cuenta."
			flash.error = errorMsg
		   
			return false
		}
		
		return true
		
	}


	def verifyRegistration(RegisterCommand command) {
		
		String token = params.t

		def registrationCode = token ? RegistrationCode.findByToken(token) : null
		if (!registrationCode) {
			flash.error = message(code: 'spring.security.ui.register.badCode')
			redirect uri: SpringSecurityUtils.securityConfig.successHandler.defaultTargetUrl
			return
		}
		/*if (!request.post) {
			println "3"
			return [token: token, command: new RegisterCommand()]
		}*/

		command.username = registrationCode.username?.toLowerCase()

		/*command.validate()

		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.register.passwordRepeat.invalid', default:'Hay un error en algun campo del registro')
			return [token: token, command: command]
		}*/

		String salt = saltSource instanceof NullSaltSource ? null : registrationCode.email?.toLowerCase()
		RegistrationCode.withTransaction { status ->
			def user = User.findByUsername(registrationCode.username?.toLowerCase())
			user.accountLocked = false
			user.save()
			registrationCode.delete()
		}

		springSecurityService.reauthenticate(command.username)

		redirect(controller:"dashboard",action:"index")

		/*def conf = SpringSecurityUtils.securityConfig
		String postResetUrl = conf.ui.register.postResetUrl ?: conf.successHandler.defaultTargetUrl
		redirect uri: postResetUrl*/
	}

	def forgotPassword() {

		if (!request.post) {
			// show the form
			return
		}

		String username = params.username?.toLowerCase()
		if (!username) {
			flash.error = message(code: 'zifras.security.forgotPassword.username.missing', default:'Ingrese su email')
			redirect action: 'forgotPassword'
			return
		}

		def user = User.findByUsername(username)
		if (!user) {
			flash.error = message(code: 'zifras.security.forgotPassword.user.notFound', default:'No hay usuarios para ese email')
			redirect action: 'forgotPassword'
			return
		}

		def registrationCode = new RegistrationCode(username: username)
		registrationCode.save(flush: true)

		String url = generateLink('resetPassword', [t: registrationCode.token])

		def conf = SpringSecurityUtils.securityConfig

		//def body = message(code: 'calim.forgotPassword.email.body', args: [url])
		//String asunto = message(code: 'calim.forgotPassword.email.subject')

		NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Email ForgotPassword")

		notificacionService.enviarEmail(user.username, plantilla.asuntoEmail, plantilla.llenarVariablesBody([url]), 'forgotPassword', null, plantilla.tituloApp, plantilla.textoApp)

		String mensajeHtml = "Email: " + user.username + "<br/>"
		// notificacionService.enviarEmailInterno("info@calim.com.ar", "Usuario CALIM pidió cambio de pass", mensajeHtml, 'forgotPasswordInterno')

		[emailSent: true]
	}


	def ajaxExisteUsuario(String email){
		render usuarioService.existeUsuario(email).toString()
	}

	def resetPassword(ResetPasswordCommand command) {

		String token = params.t

		def registrationCode = token ? RegistrationCode.findByToken(token) : null
		if (!registrationCode) {
			flash.error = message(code: 'spring.security.ui.resetPassword.badCode')
			redirect uri: SpringSecurityUtils.securityConfig.successHandler.defaultTargetUrl
			return
		}

		if (!request.post) {
			return [token: token, command: new ResetPasswordCommand()]
		}

		command.username = registrationCode.username?.toLowerCase()
		command.validate()

		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.register.passwordRepeat.invalid', default:'Los passwords no coinciden o tienen menos de 8 caracteres o mas de 64')
			return [token: token, command: command]
		}

		String salt = saltSource instanceof NullSaltSource ? null : registrationCode.username?.toLowerCase()
		RegistrationCode.withTransaction { status ->
			def user = User.findByUsername(registrationCode.username?.toLowerCase())
			user.passwordExpired = false
			user.password = command.password//springSecurityService.encodePassword(command.password, registrationCode.username)
			user.save()
			registrationCode.delete()
		}

		springSecurityService.reauthenticate registrationCode.username?.toLowerCase()

		flash.message = message(code: 'spring.security.ui.resetPassword.success')

		def conf = SpringSecurityUtils.securityConfig
		String postResetUrl = conf.ui.register.postResetUrl ?: conf.successHandler.defaultTargetUrl
		redirect uri: postResetUrl
	}

	def forgotPasswordApp(String username) {
		def returnArray = [:]

		if (!request.post) {
			return
		}

		if (!username) {
			returnArray['error'] = "Ingrese su email."
			render returnArray as JSON		
			return
		}

		def user = User.findByUsername(username)
		if (!user) {
			returnArray['error'] = 'No hay usuarios para ese email'
			render returnArray as JSON
			return
		}

		def registrationCode = new RegistrationCode(username: username)
		registrationCode.save(flush: true)

		String url = generateLink('resetPassword', [t: registrationCode.token])

		def conf = SpringSecurityUtils.securityConfig
		//pide el cambio via app, el link abre el server y la vista redirecciona segun de donde se abra

		//def body = message(code: 'calim.forgotPassword.email.body', args: [url])
		//String asunto = message(code: 'calim.forgotPassword.email.subject')

		NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Email ForgotPassword")
		String bodyMail = plantilla.llenarVariablesBody([url])
		
		notificacionService.enviarEmail(user.username, plantilla.asuntoEmail, bodyMail, 'forgotPassword', null, plantilla.tituloApp, plantilla.textoApp)

		String mensajeHtml = "Email: " + user.username + "<br/>"
		// notificacionService.enviarEmailInterno("info@calim.com.ar", "Usuario CALIM pidió cambio de pass via APP", mensajeHtml, 'forgotPasswordInterno')

		returnArray['mensaje'] = "Email enviado exitosamente"
		returnArray['error'] = null

		render returnArray as JSON

	}

	def resetPasswordApp(ResetPasswordCommand command) {
		def returnArray = [:]

		String token = params.t

		def registrationCode = token ? RegistrationCode.findByToken(token) : null
		if (!registrationCode) {
			returnArray['error'] = "Error en el cambio de password, vuelva a intentarlo"
			render returnArray as JSON
			return
		}

		if (!request.post) {
			return
		}

		command.username = registrationCode.username
		command.validate()

		if (command.hasErrors()) {
			returnArray['error'] = "Los passwords no coinciden o tienen menos de 8 caracteres o mas de 64"
			render returnArray as JSON
			return 
		}

		String salt = saltSource instanceof NullSaltSource ? null : registrationCode.username
		RegistrationCode.withTransaction { status ->
			def user = User.findByUsername(registrationCode.username)
			user.passwordExpired = false
			user.password = command.password
			user.save()
			registrationCode.delete()
		}

		returnArray['mensaje'] = "Su contraseña fue cambiada con exito"
		returnArray['error'] = null

		render returnArray as JSON
	}

	def ajaxGetApps(){
		render App.getAll() as JSON
	}

	public String corregirTelefono(String telefono){
		//println telefono

		telefono=telefono.replaceAll(/\D+/, '')
		//println "Se deja sólo números"
		//println telefono
		//Se saca el 54 si existe
		telefono=telefono.replaceFirst(/^54/, '')
		//println "Se quita el 54 si existe"
		//println telefono
		//Si sólo tiene 8 números, no posee código de área y seguramente es de capital
		if(telefono.size()==8){
			telefono= '11' + telefono
			//println "El número contenía 8 digitos y se agrega por defecto el 11 de capital"
			//println telefono
		}else{
			//Si tiene más de 10 dígitos, se intenta quitar el 9 de cel internacional
			//y el 0 de código de área
			if(telefono.size()>10){
				//println "Tiene más de 10 dígitos"
				//println "Se quita 9 adelante si lo tiene"
				telefono=telefono.replaceFirst(/^9/, '')
				//println telefono
				//println "Se quita 0 adelante si lo tiene"
				telefono=telefono.replaceFirst(/^0/, '')
				//println telefono
			}

			if(telefono.size()==10){
				//println "Tiene justo 10 digitos, si empieza con 15 reemplazo a 11"
				telefono=telefono.replaceFirst(/^15/, '11')
				//println telefono
			}

			if(telefono.size()==12){
				//Tiene un 15 demás que suele estar entre el código de área y el bloque de números
				//el código de área puede ser de 2, 3 o 4 dígitos, y el bloque que le sigue
				//tiene que sumar 10 dígitos en total junto con el código de área (8, 7 o 6 respectivamente)
				//println "Tiene 12 dígitos, se busca el 15 para quitarlo"
				def partes = telefono.split('15', 2)
				def unir = false
				if(partes.size()==2){
					if((partes[0].size()==2) && (partes[1].size()==8) ){
						unir = true
						//println "Se encuentra codigo de 2 digitos y bloque de 8"
						//println partes[0]
						//println partes[1]
					}

					if((partes[0].size()==3) && (partes[1].size()==7) ){
						unir = true
						//println "Se encuentra codigo de 3 digitos y bloque de 7"
						//println partes[0]
						//println partes[1]
					}

					if((partes[0].size()==4) && (partes[1].size()==6) ){
						unir = true
						//println "Se encuentra codigo de 4 digitos y bloque de 6"
						//println partes[0]
						//println partes[1]
					}

					if(unir){
						telefono = partes[0] + partes[1]
						//println "Se une el codigo de area con el bloque"
						//println telefono
					}
				}
			}
		}
		//Se agrega adelante el 54 de arg y 9 de celular
		//println "Se agrega el 54 de arg y el 9 de celular"
		telefono = '+549' + telefono
		//println telefono
		return telefono
	}

	//Esto corrige la base de datos con las consultas anteriores
	def corregirConsultas(){
		def salida = [:]
		def consultas = ConsultaWeb.findAllByTelefonoIngresado(null)
		consultas.each{
			it.telefonoIngresado = it.telefono
			it.telefono = corregirTelefono(it.telefono)
			it.save(flush:true)
			}

		render salida as JSON
	}

	def nuevaConsulta(String nombreapellido, String nombre, String apellido, String telefono, String email, String etiqueta, String urlorigen, String getparameters){
		def salida = [:]
		
		//*******************************************************************
		//Depura algunos ataques de spam
		if(
			(email.contains("fastcheckcreditscores.com"))||
			(email.contains("mailtoyougo.xyz"))||
			(email.contains("jonjamail.com"))||
			(email.contains("mail.ru"))||
			(email.contains("s.u.perman77.7ex")) ){
			salida['error'] = "Email contiene nombres prohibidos"
			println salida['error']
			render salida as JSON
			return
		}

		//Si el email contiene más de cuatro puntos, lo consideramos spam
		if(email.count(".")>4){
			salida['error'] = "Email contiene mas de 4 puntos"
			println salida['error']
			render salida as JSON
			return 
		}

		//Elimina aquellos que ponen http en el nombre o apellido
		if(nombreapellido?.contains("http")||
			nombreapellido?.contains("Http")||
			telefono?.contains("Http")||
			telefono?.contains("http")){
			salida['error'] = "El nombre o teléfono contiene http"
			println salida['error']
			render salida as JSON
			return 
		}

		//El nombre no puede ser numérico
		if(nombreapellido?.isNumber() || nombre?.isNumber() || apellido?.isNumber()){
			salida['error'] = "El nombre contiene números"
			println salida['error']
			render salida as JSON
			return
		}

		//Se corrige el teléfono
		def telefonoIngresado = telefono
		telefono = corregirTelefono(telefono)

		//Se separa el nombre y apellido
		if(nombreapellido != null){
			apellido = nombreapellido?.split(" ")[-1]
			nombre = nombreapellido - (" " + apellido)
			apellido = nombre == apellido ? " " : apellido
		}

		//Se pasa a CamelCase el nombre y apellido, y a lowercase el email
		nombre = nombre?.toLowerCase()?.capitalize()
		apellido = apellido?.toLowerCase()?.capitalize()
		email = email?.toLowerCase()

		//Se genera el string de tituloDeal
		String tituloDeal = "Consulta Web"
		if(etiqueta != null && etiqueta != "null" && etiqueta != ""){
			tituloDeal += (" " + etiqueta)
		}
		//*******************************************************************

		try {
			if (email.contains("calim")) // Si es un mail autogenerado para calim, me aseguro de que no tenga tildes ni nada raro
				email = email.replaceAll("[^\\x00-\\x7F]", "");
		}
		catch(Exception e) {
			println "No se pudo escapear el mail $email\n"
		}

		//Se toma un vendedor para asignar
		def vendedorAsignado = vendedorService.getVendedorAAsignar()

		//Se guarda el contacto en la base de datos
		def consultaWeb = new ConsultaWeb(nombre, apellido, telefono, telefonoIngresado, email, etiqueta, vendedorAsignado.nombre, urlorigen, getparameters, null, null)
		consultaWeb.save(flush:true)
		def consutlaWebId = consultaWeb.id
		
		//Se crea el contacto en Google en un thread aparte para no demorar
		RequestContextHolder.setRequestAttributes(RequestContextHolder.getRequestAttributes(), true) //esto es para que el thread reciba los atributos del controller y que no rompa
		Thread.start {
			com.zifras.notificacion.Email.withTransaction{ session ->
				crearContactoGoogle(nombre, apellido, telefono, email, vendedorAsignado.nombre)
			}
		}
		
		//Se crea el contacto y el deal en Bitrix en un thread aparte para no demorar
		Thread.start {
			def bitrixClientId
			def bitrixDealId

			bitrixClientId = bitrixService.crearContactoBitrix(nombre,apellido,telefono,email,"No definido",tituloDeal,etiqueta, telefonoIngresado)
			if (! bitrixClientId)
				bitrixClientId = bitrixService.crearContactoBitrix(nombre,apellido,telefono,null,"No definido",tituloDeal,etiqueta, telefonoIngresado) // vuelvo a intentar sin mail
			if (bitrixClientId){
				bitrixDealId = bitrixService.crearNegociacionBitrix(bitrixClientId, tituloDeal,vendedorAsignado.email,"general")
			}
			
			com.zifras.notificacion.Email.withTransaction{ session ->
				def consultaWeb2 = ConsultaWeb.get(consutlaWebId)
				consultaWeb2.bitrixClientId = bitrixClientId
				consultaWeb2.bitrixDealId = bitrixDealId
				consultaWeb2.save(flush:true)
			}
		}

		//Se prepara la salida
		salida['nombre'] = nombre
		salida['apellido'] = apellido
		salida['telefono'] = telefono
		salida['email'] = email
		salida['error'] = ''

		render salida as JSON
	}

	@Secured(['permitAll'])
	def tiendaNube(){
		String client_code = params.code
		if (client_code){
			String salida_controller = "dashboard"
			String salida_action = "index"
			def salida_params = [:]

			String calim_id = "1870"
			String calim_secret = "ocV3zwIO1CJezCFU6mcPpFSdEu97ivaDFfqk5O8F4gjnESWI"
			String client_token
			String client_id

			boolean hayError = false
			def httpconection = new HTTPBuilder('https://www.tiendanube.com/apps/authorize/token')
			httpconection.request( groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON ) { req ->
				body = [
					client_id: calim_id,
					client_secret: calim_secret,
					grant_type: "authorization_code",
					code: client_code
				]
				response.failure = { resp, json ->
					log.error("Error con API TiendaNube al obtener token")
					println "Respuesta $json \n"
					hayError = true
				}
				response.success = { estado, respuesta ->
					client_token = respuesta.access_token
					client_id = respuesta.user_id
				}
			}
			if (! hayError){
				httpconection = new HTTPBuilder("https://api.tiendanube.com/v1/${client_id}/store")
				httpconection.request( groovyx.net.http.Method.GET, groovyx.net.http.ContentType.JSON ) { req ->
					headers.'Authentication' = "bearer $client_token"
					headers.'User-Agent' = 'CALIM Digital SA (https://calim.com.ar)'
					response.failure = { resp, json ->
						log.error("Error con API TiendaNube al obtener cliente")
						println "\nRespuesta $json \n"
						hayError = true
					}
					response.success = { estado, respuesta ->
						Tenants.withId(2) {
							// Busco una cuenta con este mail. Si la encuentro, le actualizo el token (dentro del .with{}) y la guardo. 
							// Si no la encuentro, creo una nueva con la información traida de la API, y llamo al service que crea el usuario y manda mail para password.
							// Hechas estas cosas, se reloguea con ese usuario y se redirige al dashboard.
							if (! cuentaService.getCuentaByEmailOCuit(respuesta.email,respuesta.business_id)?.with{tokenTiendaNube = client_token;save(flush:true, failOnError:true)}){
								Cuenta nueva = new Cuenta().with{
									fechaAlta = new LocalDateTime()
									tokenTiendaNube = client_token
									email = respuesta.email
									cuit = respuesta.business_id ?: email
									inscriptoAfip = true
									descripcionActividad = respuesta.description.es
									detalle = "Registro por TiendaNube"
									razonSocial = respuesta.business_name
									nombreApellido = respuesta.name.es
									telefono = whatsapp = corregirTelefono(respuesta.phone)
									/*Datos que siempre fueron hardcoded*/
									it.estado = Estado.findByNombre('Sin verificar')
									contador = Contador.findByNombreApellido('Alejandro Pavoni')
									regimenIibb = RegimenIibb.get(15)
									condicionIva = CondicionIva.findByNombre("Sin inscribir")
									/**/
									save(flush:true, failOnError:true)
								}
								usuarioService.crearUsuarioParaCuenta(nueva)
								RegisterCommand command = new RegisterCommand().with{
									nombre = nueva.nombreApellido.split()[0]
									apellido = nueva.nombreApellido - (nombre + " ")
									username = nueva.email
									celular = nueva.telefono
									return it
								}
								String bitrix_id = bitrixService.guardarEnBitrix(command, nueva, "Registro TiendaNube",null)
								/*Simulo que el cliente acaba de ingresar su cuit en el registro manual, para reutilizar la lógica que decide si la respuesta 
									apropiada es el showerror o el showdatos y muestra la información correspondiente.*/

								nueva.with{
									println "email"
									println email
									println "cuit"
									println cuit
								}
								if (nueva.with{email == cuit}){
									cuentaService.actualizarProvincia(nueva.id, Provincia.findByNombre("CABA").id.toString())
									println "\n-\nEntró arriba\n\n"
									nueva.with{
										it.estado = Estado.findByNombre("Activo")
										registroConErrorAFIP = true
										save(flush:true)
									}
								}else{
									println "\n-\nEntró abajo\n\n"
									salida_controller = "registrar"
									salida_action = "pasosRegistro"
									salida_params = [volver:false, pasoActual:'ingresoCUIT', cuit:nueva.cuit]
								}
							}
							if(cuentaService.getCuentaByEmail(respuesta.email))
								springSecurityService.reauthenticate(respuesta.email)
							else
								springSecurityService.reauthenticate(cuentaService.getCuentaByCuit(respuesta.business_id)?.email)
						}
					}
				}
			}
			redirect(controller:salida_controller, action:salida_action, params:salida_params)
		}else{
			redirect(url:"https://tiendanube.com/apps/1870/authorize")
		}
	}


	protected String generateLink(String action, linkParams) {
		return grailsApplication.config.getProperty('grails.serverURL') + createLink(controller: 'registrar', action: action,
				params: linkParams)
	}

	/*protected String evaluate(s, binding) {
		new SimpleTemplateEngine().createTemplate(s).make(binding)
	}*/

	static final passwordValidator = { String password, command ->
		if (command.username && command.username.equals(password)) {
			return 'command.password.error.username'
		}

		if (!checkPasswordMinLength(password, command) ||
			!checkPasswordMaxLength(password, command) ||
			!checkPasswordRegex(password, command)) {
			return 'command.password.error.strength'
		}
	}

	static boolean checkPasswordMinLength(String password, command) {
		def conf = SpringSecurityUtils.securityConfig

		int minLength = conf.ui.password.minLength instanceof Number ? conf.ui.password.minLength : 8

		password && password.length() >= minLength
	}

	static boolean checkPasswordMaxLength(String password, command) {
		def conf = SpringSecurityUtils.securityConfig

		int maxLength = conf.ui.password.maxLength instanceof Number ? conf.ui.password.maxLength : 64

		password && password.length() <= maxLength
	}

	static boolean checkPasswordRegex(String password, command) {
		def conf = SpringSecurityUtils.securityConfig

		String passValidationRegex = conf.ui.password.validationRegex ?:
				'^.*(?=.*\\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&]).*$'

		password && password.matches(passValidationRegex)
	}

	static final password2Validator = { value, command ->
		if (command.password != command.password2) {
			return 'command.password2.error.mismatch'
		}
	}

	public generarNegociacionesNoAtendidas(){
		def fechaInf = LocalDateTime.parse("2021-04-22T21:38:24")
		def fechaSup = LocalDateTime.parse("2021-04-22T23:32:28")
		//def consultas = ConsultaWeb.findAll{it.nombre == "Alejandro"}
		//println consultas.collect{it.apellido}
		def cons = ConsultaWeb.getAll().findAll{it.fechaHora.isAfter(fechaInf) && it.fechaHora.isBefore(fechaSup)}
		cons.each{
			def bitrixClientId
			def negociacionId
			bitrixClientId = bitrixService.crearContactoBitrix(it.nombre,it.apellido,it.telefono,it.email,"No definido","Consulta Web")
			if (! bitrixClientId)
				bitrixClientId = bitrixService.crearContactoBitrix(it.nombre,it.apellido,it.telefono,null,"No definido","Consulta Web") // vuelvo a intentar sin mail
			if (bitrixClientId){
				negociacionId = bitrixService.crearNegociacionBitrix(bitrixClientId, "Consulta Web",null,"general")
			}
			println "Creada negociacion con id " + negociacionId
		}
		render "Listo"
	}

	public generarContactosGoogleFaltantes(String nombreVendedor, Integer cantDias){
		def hoy = new LocalDateTime()
		def sum = 0
		def consultas = ConsultaWeb.createCriteria().list(){
			le('fechaHora',hoy)
			ge('fechaHora',hoy.minusDays(cantDias))
			eq('vendedorAsignado',nombreVendedor)
		}
		println "Cantidad de consultas: "+ consultas.size()
		consultas.each{
			try{
				googleAPIService.crearContacto(TokenGoogle.findByUsuario("Cuenta Contactos "+nombreVendedor).refreshToken, it.nombre, it.apellido, it.telefono, it.email)
				sum++
			}
			catch(e){
				println "Error generando contacto faltante"
			}
		}
		render sum + " Contactos creados"
	}

	def crearContactosSMSEGoogle(){
		def hoy = new LocalDateTime()
		def cuentas = Cuenta.getAll()
		String nombre,apellido
		def cuentasSE = cuentas.findAll{it.facturasCuenta?.any{f -> f.itemEspecial && f.pagada}}
		def cuentasSM = cuentas.findAll{it.facturasCuenta?.any{f -> f.mensual && f.pagada}}

		cuentasSE.each{
			try{
				nombre = it.nombreApellido?.split(" ")[0]
			}
			catch(e){
				nombre = " "
			}
			try{
				apellido = it.nombreApellido?.substring(nombre.size() + 1)
			}
			catch(e){
				apellido = " "
			}
			try {
				googleAPIService.crearContacto(TokenGoogle.findByUsuario("Cuenta Contactos SE").refreshToken, nombre, apellido, it.whatsapp ?: it.telefono, it.email)
				//googleAPIService.crearContacto(TokenGoogle.findByUsuario("Agustin").refreshToken, nombre, apellido, telefono, email)
			}
			catch(java.lang.NoSuchMethodError e) {
				println "\nError guardando contacto de Google"
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
			catch(Exception e) {
				println "\nError guardando contacto de Google"
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
			catch(e) {
				println "\nError guardando contacto de Google"
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
		}

		cuentasSM.each{
			try{
				nombre = it.nombreApellido?.split(" ")[0]
			}
			catch(e){
				nombre = " "
			}
			try{
				apellido = it.nombreApellido?.substring(nombre.size() + 1)
			}
			catch(e){
				apellido = " "
			}
			try {
				googleAPIService.crearContacto(TokenGoogle.findByUsuario("Cuenta Contactos SM").refreshToken, nombre, apellido, it.whatsapp ?: it.telefono, it.email)
				//googleAPIService.crearContacto(TokenGoogle.findByUsuario("Agustin").refreshToken, nombre, apellido, telefono, email)
			}
			catch(java.lang.NoSuchMethodError e) {
				println "\nError guardando contacto de Google"
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
			catch(Exception e) {
				println "\nError guardando contacto de Google"
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
			catch(e) {
				println "\nError guardando contacto de Google"
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
		}
		render "Contactos creados correctamente"
	}

	public getVendedorNecesitoAyuda(Boolean ayuda){
		def resultado = [:]
		def cuenta = accessRulesService.getCurrentUser()?.cuenta
		if (cuenta && (cuenta.trabajaConApp() || cuenta.primeraFacturaSMPaga)){
			String textoApp = cuenta.trabajaConApp() ? "20trabajo%20con%20app%21" : ""
			resultado["wsp"] = "https://api.whatsapp.com/send?phone=5491151093337&text=Hola%21%$textoApp%20Necesito%20ayuda."
		}
		else
			resultado["wsp"] = vendedorService.getVendedorNecesitoAyuda(ayuda)
		render resultado as JSON
	}

	public necesitoAyudaWeb(){
		String url = vendedorService.getVendedorNecesitoAyuda(true)
		redirect(url:url)
	}

	public necesitoAyudaInstagram(){
		String url = vendedorService.getVendedorNecesitoAyuda(true, true)
		redirect(url:url)
	}

	def testy(){
		editarNegociacion('45585','["fields":["CATEGORY_ID":"5"]]')
		render "aa"
	}

	private Servicio obtenerSmAlta(Boolean cuentaRappi){
		String codigo = cuentaRappi ? "SE17" : "SE18" // Servicio Especial 'Alta Afip + IIBB'
		return Servicio.findAllByCodigoAndActivo(codigo,true).max{it.subcodigo}
	}

}
