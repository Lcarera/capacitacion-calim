package com.zifras.documento

import com.zifras.AccessRulesService
import com.zifras.BitrixService
import com.zifras.Contador
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.GoogleAPIService
import com.zifras.TokenGoogle
import com.zifras.User
import com.zifras.UsuarioService
import com.zifras.afip.AfipService
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.cuenta.Local
import com.zifras.cuenta.MovimientoCuenta
import com.zifras.mercadopago.*
import com.zifras.notificacion.NotificacionService
import com.zifras.notificacion.NotificacionTemplate
import com.zifras.security.RegistrarController
import com.zifras.servicio.ItemServicioEspecial

import grails.config.Config
import grails.transaction.Transactional
import grails.validation.ValidationException
import grails.web.mapping.LinkGenerator
import groovy.json.JsonSlurper
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import org.springframework.context.MessageSource
import org.springframework.context.i18n.LocaleContextHolder
import org.springframework.web.multipart.MultipartFile
import static grails.gorm.multitenancy.Tenants.*

import com.mercadopago.MercadoPago
import com.mercadopago.resources.Preference
import com.mercadopago.resources.datastructures.preference.BackUrls
import com.mercadopago.resources.datastructures.preference.Item
import com.mercadopago.resources.datastructures.preference.Payer

@Transactional
class PagoCuentaService {
	AccessRulesService accessRulesService
	def bitrixService
	AfipService afipService
	def cuentaService
	def facturaCuentaService
	def googleAPIService
	LinkGenerator grailsLinkGenerator
	MessageSource messageSource
	def movimientoCuentaService
	def notificacionService
	static def grailsApplication

	def createPagoCuentaCommand(){
		def command = new PagoCuentaCommand()
		LocalDateTime ahora = LocalDateTime.now()
		command.horaPago = ahora.toString("HH:mm")
		return command
	}

	def savePagoCuenta(PagoCuentaCommand command, MultipartFile archivo){
		def pagoCuentaInstance = new PagoCuenta()

		pagoCuentaInstance.cuenta = Cuenta.get(command.cuentaId)
		pagoCuentaInstance.estado = Estado.get(command.estadoId)
		pagoCuentaInstance.descripcion = command.descripcion
		pagoCuentaInstance.importe = command.importe
		String hora = "T" + command.horaPago + LocalDateTime.now().toString(":ss.SSS")
		pagoCuentaInstance.fechaPago = new LocalDateTime(command.fechaPago.toString("YYYY-MM-dd") + hora)

		if(!archivo.isEmpty()){
			pagoCuentaInstance.nombreArchivo = archivo.originalFilename

			String cuentaPath = pagoCuentaInstance.cuenta.getPath()
			String pathFC = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/pagoCuentas/"

			File carpeta = new File(pathFC)
			if(!carpeta.exists())
				carpeta.mkdirs()

			String fullPath = pathFC + pagoCuentaInstance.nombreArchivo
			int versionArchivo = 0
			while((new File(fullPath)).exists()){
				versionArchivo++
				fullPath = pathFC + pagoCuentaInstance.nombreArchivo + " (" + versionArchivo.toString() + ")"
			}
			if (versionArchivo>0)
				pagoCuentaInstance.nombreArchivo += " (" + versionArchivo.toString() + ")"
			archivo.transferTo(new File(fullPath))
		}

		pagoCuentaInstance.save(flush:true, failOnError:true)

		movimientoCuentaService.saveMovimientoCuentaPago(pagoCuentaInstance)

		return pagoCuentaInstance
	}

	def getFile(Long id){
		def usuario = accessRulesService.getCurrentUser()
		def pagoCuentaInstance = PagoCuenta.get(id)
		if (!pagoCuentaInstance)
			throw new Exception("no existe")
		if (usuario.hasRole("ROLE_CUENTA") && (usuario.cuenta?.id != pagoCuentaInstance?.cuenta?.id))
			throw new Exception("permisos")
		String nombre = pagoCuentaInstance.nombreArchivo
		String cuentaPath = pagoCuentaInstance.cuenta.getPath()

		def file = new File(System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/pagoCuentas/" + nombre)

		return file
	}

	def listPagoCuenta(String filter,Long cuentaId) {
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		lista = PagoCuenta.createCriteria().list() {
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}
			if(filter!=null)
				ilike('descripcion', '%' + filter + '%')

			order('fechaPago', 'asc')
		}
		return lista
	}

	def getPagoCuenta(Long id){
		def pagoCuentaInstance = PagoCuenta.get(id)
	}

	def getPagoCuentaCommand(Long id){
		def pagoCuentaInstance = PagoCuenta.get(id)

		if(pagoCuentaInstance!=null){
			def command = new PagoCuentaCommand()

			command.pagoCuentaId = pagoCuentaInstance.id
			command.version = pagoCuentaInstance.version
			command.cuentaId = pagoCuentaInstance.cuenta.id
			command.estadoId = pagoCuentaInstance.estado.id
			command.descripcion = pagoCuentaInstance.descripcion
			command.importe = pagoCuentaInstance.importe
			command.fechaPago = new LocalDate(pagoCuentaInstance.fechaPago.toString("YYYY-MM-dd"))
			command.horaPago = pagoCuentaInstance.fechaPago.toString("HH:mm")
			command.nombreArchivo = pagoCuentaInstance.nombreArchivo

			return command
		} else {
			return null
		}
	}

	def getPagoCuentaList() {
		lista = PagoCuenta.list()
	}

	def deletePagoCuenta(Long id){
		def pagoCuentaInstance = PagoCuenta.get(id)

		movimientoCuentaService.deleteMovimientoCuentaPago(pagoCuentaInstance)

		String nombre = pagoCuentaInstance.nombreArchivo
		String cuentaPath = pagoCuentaInstance.cuenta.path
		String ruta = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/pagoCuentas/" + nombre
		(new File(ruta)).delete()

		pagoCuentaInstance.delete(flush:true, failOnError:true)
	}

	def updatePagoCuenta(PagoCuentaCommand command, MultipartFile archivo){
		def pagoCuentaInstance = PagoCuenta.get(command.pagoCuentaId)

		if (command.version != null) {
			if (pagoCuentaInstance.version > command.version) {
				PagoCuentaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["PagoCuenta"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el pagoCuenta")
				throw new ValidationException("Error de versión", PagoCuentaCommand.errors)
			}
		}

		pagoCuentaInstance.cuenta = Cuenta.get(command.cuentaId)
		pagoCuentaInstance.estado = Estado.get(command.estadoId)
		pagoCuentaInstance.descripcion = command.descripcion
		pagoCuentaInstance.importe = command.importe
		String hora = "T" + command.horaPago + LocalDateTime.now().toString(":ss.SSS")
		pagoCuentaInstance.fechaPago = new LocalDateTime(command.fechaPago.toString("YYYY-MM-dd") + hora)

		if(!archivo.isEmpty()){
			String cuentaPath = pagoCuentaInstance.cuenta.getPath()
			String pathFC = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/pagoCuentas/"

			//Borra archivo viejo:
			String fullPathABorrar = pathFC + pagoCuentaInstance.nombreArchivo
			File archivoABorrar = new File(fullPathABorrar)
			archivoABorrar.delete()

			//Cargar archivo nuevo:
			pagoCuentaInstance.nombreArchivo = archivo.originalFilename

			File carpeta = new File(pathFC)
			if(!carpeta.exists())
				carpeta.mkdirs()

			String fullPath = pathFC + pagoCuentaInstance.nombreArchivo
			int versionArchivo = 0
			while((new File(fullPath)).exists()){
				versionArchivo++
				fullPath = pathFC + pagoCuentaInstance.nombreArchivo + " (" + versionArchivo.toString() + ")"
			}
			if (versionArchivo>0)
				pagoCuentaInstance.nombreArchivo += " (" + versionArchivo.toString() + ")"
			archivo.transferTo(new File(fullPath))
		}

		pagoCuentaInstance.save(flush:true, failOnError:true)

		movimientoCuentaService.saveMovimientoCuentaPago(pagoCuentaInstance)

		return pagoCuentaInstance
	}

	def getCantidadPagoCuentasTotales(){
		return PagoCuenta.count()
	}

	def obtenerDatosQr(Long localId){
		withId(1) {
			Local local = Local.get(localId)
			if (!local)
				return null
			return FacturaCuenta.findAllByLocal(local)?.find{! it.pagada}?.with{
				def respuesta = [:]
				respuesta['importe'] = importe
				respuesta['detalle'] = "Mensualidad"
				PagoCuenta pagoNuevo = new PagoCuenta().with{
					cuenta = local.cuenta
					fechaPago = new LocalDateTime()
					importe = respuesta['importe']
					estado = Estado.findByNombre('Emitido')
					save(flush:true, failOnError:true)
				}
				respuesta['id'] = pagoNuevo.id
				movimiento.with{
					pago = pagoNuevo
					save(flush:true, failOnError:true)
				}
				return respuesta
			}
		}
	}

	def pagarMovimientos(movimientos, User usuario = null, Cuenta cuenta = null,Boolean mobile=false){
		PagoCuenta pago = new PagoCuenta()
		pago.cuenta = usuario?.cuenta ?: (cuenta ?: accessRulesService.getCurrentUser().cuenta)
		pago.fechaPago = new LocalDateTime()
		pago.importe = 0
		pago.estado = Estado.findByNombre('Emitido')

		pago.save(flush:true, failOnError:true)
		String externalReference = ''

		def items = []
		movimientos.each{
			MovimientoCuenta movimiento = it instanceof MovimientoCuenta ? it : MovimientoCuenta.get(it)
			movimiento.pago = pago
			pago.importe += movimiento.importe

			movimiento.save(flush:true, failOnError:true)

			Item item = new Item()
			item.setId(it.toString())
				.setTitle(movimiento.tipo)
				.setDescription(movimiento.descripcionMP)
				.setQuantity(1)
				.setCurrencyId("ARS")
				.setUnitPrice((float) movimiento.importe)
			items.push(item)

			if(movimiento.factura != null)
				externalReference += movimiento.tituloMP //la funcion tituloMP anda solo para los mov con factura (SM O SE)
		}

		String accessTokenMP = Estudio.get(pago.tenantId).mercadoPagoAccessTokenProduccion

		MercadoPago.SDK.setAccessToken(accessTokenMP)
		Payer payer = new Payer()
		payer.setEmail(pago.cuenta.email ?: (pago.tenantId == 1 ? 'cabuqui@gmail.com' : ''))
		Preference preference = new Preference()
		preference.setPayer(payer)

		String urlDashboard
		if(mobile){
			urlDashboard = "calimapp://calimapp.com.ar/"
		}else{
			urlDashboard = grailsApplication.config.getProperty('grails.serverURL') + grailsLinkGenerator.link(controller: 'dashboard', absolute: false)
		}			

		BackUrls backUrls = new BackUrls(
			urlDashboard,
			urlDashboard,
			urlDashboard)
		preference.setBackUrls(backUrls)
		String accion = 'notificacionMP'
		if(pago.tenantId == 1)
			accion += 'Pavoni'
		else{
			preference.setExternalReference(externalReference)
		}
		preference.setNotificationUrl("https://app.calim.com.ar" + grailsLinkGenerator.link(controller: 'pagoCuenta', action: accion, absolute: false, params:['pagoId': pago.id]))

		items.each{
			preference.appendItem(it)
		}
		preference.save()
		pago.with{
			preferenceId = preference.id
			linkMercadoPago = preference.initPoint
			save(flush:true, failOnError:true)
		}
		return preference.initPoint
	}

	def generarLinkPago(idMovimientosString, User usuario) {
		grailsLinkGenerator.link(controller: 'notificacion', action: 'pagarMovimientosMail',  params:['p1': usuario.id,'p2': idMovimientosString,'p3': usuario.cuenta.id], absolute: true)
	}

	def generarLinkPagoPavoni(idMovimientosString, Long cuentaId) {
		grailsLinkGenerator.link(controller: 'notificacion', action: 'pagarMovimientosMailPavoni',  params:['p1': cuentaId,'p2': idMovimientosString,'p3': cuentaId], absolute: true)
	}

	public static void cancelarPreferencia(String preferenceId, Integer tenantId){
		def httpconection = new groovyx.net.http.HTTPBuilder('https://api.mercadopago.com/checkout/preferences/' + preferenceId + '?access_token=' + Estudio.get(tenantId).mercadoPagoAccessTokenProduccion);
		httpconection.request( groovyx.net.http.Method.PUT, groovyx.net.http.ContentType.JSON ) { req ->
		    body = [expires:true,expiration_date_to: new LocalDateTime().minusHours(3).toString() + "-03:00"]
		    response.failure = { resp ->
		        log.error("No se pudo cancelar una preference de MercadoPago con ID $preferenceId \nHTTPStatus ${resp.status}")
		    }
		}
	}

	def cancelarSaldo(User usuario = null){
		if (!usuario)
			usuario = accessRulesService.getCurrentUser()
		return pagarMovimientos(usuario.cuenta.movimientos.findAll {! it.pagado}, usuario)
	}

	def recibirNotificacionMP(String pagoId, String paymentID, Integer tenantId, Boolean intentarHardcoded){
		withId(tenantId) {
			// Si el token es rechazado, va a causar un java.io.IOException y el controller llamará a la misma función con parámetro en true.
			String token = intentarHardcoded ? "APP_USR-5790526799129112-083020-fd130a4efb0c37e9af7ec1a56e43eb27-42553970" : Estudio.get(tenantId).mercadoPagoAccessTokenProduccion
			def baseUrl = new URL('https://api.mercadopago.com/v1/payments/' + paymentID + '?access_token=' + token)
			HttpURLConnection connection = (HttpURLConnection) baseUrl.openConnection()
			connection.addRequestProperty("Accept", "application/json")
			connection.with {
				doOutput = true
				requestMethod = 'GET'

				def respuesta = new JsonSlurper().parseText(content.text)
				def notificacionGuardada = guardarRespuestaMP(respuesta, paymentID)

				PagoCuenta pago = PagoCuenta.get(pagoId)
				if (pago){
					if (notificacionGuardada){
						try {
							pago.addToNotificaciones(notificacionGuardada).save(flush:true, failOnError:true)
						}
						catch(Exception e) {
							log.error("\nNo se pudo guardar notificaciónmp dentro del pago: " + e.message)
							// println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
							return
						}
						
						if (tenantId == 1){
							String emailNotif = notificacionGuardada?.payer?.email
							MovimientoCuenta.findAllByPago(pago)?.find{it.factura != null}?.factura?.local?.with{
								email = emailNotif
								save(flush:true, failOnError:false)
							}
						}
						else{
							try {
								Long mpId = notificacionGuardada?.myId
								MovimientoCuenta.findAllByPago(pago)?.each{ mov -> //.find{it.factura != null}?   se guarda el id solo para los mov de servicios????????
									mov.movimientoMPId = mpId
	 								mov.save(flush:true, failOnError:false)
								}
							}
							catch(Exception e) {
								log.error("\nNo se pudo guardar notificaciónmp dentro de los movimientos: " + e.message)
								println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
							}
						}
					}
					if (respuesta.status == "approved" && pago.estado.nombre != "Pagado")
						confirmarMercadoPago(pago)
					else if (respuesta.status == "refunded" && pago.estado.nombre != "Reembolsado"){
						if(pago.estado.nombre != "Pagado")
							confirmarMercadoPago(pago)
						reembolsarMercadoPago(pago)
					}
				}else{
					String mensaje = "Entró una notificación con ID ${paymentID} pero no encontramos el pago ${pagoId}"
					log.error(mensaje)
					println "\n"*3 + mensaje + "\n"*3
				}
			}
		}
	}

	def confirmarMercadoPago(PagoCuenta pago){
		String responsableServicio = ""
		boolean avisarAResponsable = false
		String nombre

		String urlCuentaShow = grailsApplication.config.getProperty('grails.serverURL') + grailsLinkGenerator.link(controller: 'cuenta', action: 'show', id: pago.cuenta.id, absolute: false)
		String mensajeInternoHtml = 'Usuario: <a href="' + urlCuentaShow + '">' + pago.cuenta.email + " CUIT " + pago.cuenta.cuit + "</a><br/><br/>Movimientos pagados:<br/>"
		MovimientoCuenta.findAllByPago(pago).each{
			mensajeInternoHtml += "- " + it.tipo + ": "
			mensajeInternoHtml += it.factura?.descripcion ?: (it.declaracion?.descripcion ?: 'Sin detalle')
			if (it.factura){
				try {
					afipService.solicitarCaeCalim(it.factura)
					mensajeInternoHtml += "  {facturado}"
					notificacionService.notificarUsuarioNuevaFactura(it.cuenta.email,it.cuenta.nombreApellido,it.factura.id)
				}
				catch (java.lang.AssertionError e){
					// println "\nError EXTERNO facturando"
					// println e.message
					// println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
					mensajeInternoHtml += "  {NO facturado (error con AFIP)}"
				}
				catch (Exception e){
					println "\nError INTERNO facturando"
					println e.message
					println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
					mensajeInternoHtml += "  {NO facturado (error interno)}"
				}
			}else
				mensajeInternoHtml += "  {NO facturado}"
			mensajeInternoHtml += "<br/>"
			// Verifico si es apto para avisar internamente a vendedor: Debe ser un SE o el PRIMER pago de un SM
			if (it.factura){
				nombre = it.cuenta.nombreApellido.split(' ')[0]
				if(it.cuenta.bitrixId == null){
					try{
						def clientId = bitrixService.crearContactoBitrix(it.cuenta.nombre, it.cuenta.apellido, it.cuenta.telefono, it.cuenta.email , it.cuenta.id.toString(),"generacionTask", "", "")
						cuentaService.actualizarBitrixId(it.cuenta.id,clientId)
					}catch(e){
						log.error(e.message)
						log.error("Ocurrio un error generando Cliente en Bitrix para cuenta: " + it.cuenta.id)
					}
				}
				if (it.factura.esPrimerSM()){
						FacturaCuenta nuevaFactura = it.factura
						avisarAResponsable = true
						if (!responsableServicio)
							responsableServicio = it.factura.itemMensual.with{vendedor?.email ?: responsable}
						notificacionService.enviarEmailInterno("admin@calim.com.ar", "Primer SM Pagado", "La cuenta <a href='https://app.calim.com.ar/cuenta/show/${it.cuenta.id}'>${it.cuenta}</a> pagó el SM ${it.factura.itemMensual}<br/>Responsable: $responsableServicio")
						it.cuenta.with{
							if (! etiqueta){
								primeraFacturaSMPaga = nuevaFactura
								etiqueta = "Amarillo"
								estado = Estado.findByNombre("Activo")
							}
							if (! contador)
								contador = Contador.findByNombreApellido('Alejandro Pavoni')
							save(flush:true)
						}
						try{
							googleAPIService.crearContacto(TokenGoogle.findByUsuario("Cuenta Contactos SM").refreshToken, nombre, it.cuenta.nombreApellido.substring(nombre.size() + 1), it.cuenta.whatsapp ?: it.cuenta.telefono, it.cuenta.email)
						}
						catch(java.lang.NoSuchMethodError e) {
							println "Error guardando contacto google en cuenta SM"
						}
						catch(Exception e) {
							println "Error guardando contacto google en cuenta SM"
						}
						catch(e){
							println "Error guardando contacto google en cuenta SM"
						}

						try{
							bitrixService.generarTaskTramite(it.cuenta.bitrixId, it.factura.descripcion, it.factura.itemMensual.comentario, it.cuenta.id, responsableServicio, "alejandro@calim.com.ar")
						}
						catch(e){
							def timeout = 3
							while(timeout > 0){
								try{
									Thread.sleep(2000)
									bitrixService.generarTaskTramite(it.cuenta.bitrixId, it.factura.descripcion, it.factura.itemMensual.comentario, it.cuenta.id, responsableServicio, "alejandro@calim.com.ar")
									break
								}
								catch(exep){
									timeout--
									println "Reintento de generación Task trámite"	
								}
							}
							if(timeout == 0){
								try{
									notificacionService.notificarErrorTaskTramite(it.cuenta.id,it.factura.descripcion,responsableServicio)
								}
								catch(ex){
									log.error("Ocurrio un error notificando error sobre task tramite cuenta " + it.cuenta.id)
								}
							}
						}

						try{
							bitrixService.crearNegociacionBitrix(it.cuenta.bitrixId,"Nuevo cliente SM",null,"presentacionSM")
						}
						catch(e){
							try{
								notificacionService.notificarErrorDealCobranza(it.cuenta.id,"Nuevo Cliente SM")
							}
							catch(ex){
								log.error("Ocurrio un error notificando error sobre deal Nuevo Cliente SM cuenta " + it.cuenta.id)
							}
						}

				} else if (it.factura.itemEspecial){
					if (!responsableServicio){
						responsableServicio = it.factura.with{vendedor?.email ?: responsable}
						avisarAResponsable = true
					}

					if(it.cuenta.serviciosEspecialesPagados() == 0){
						try{
							googleAPIService.crearContacto(TokenGoogle.findByUsuario("Cuenta Contactos SE").refreshToken, nombre, it.cuenta.nombreApellido.substring(nombre.size() + 1), it.cuenta.whatsapp ?: it.cuenta.telefono, it.cuenta.email)
						}
						catch(java.lang.NoSuchMethodError e) {
							println "Error guardando contacto google en cuenta SE"
						}
						catch(Exception e) {
							println "Error guardando contacto google en cuenta SE"
						}
						catch(e){
							println "Error guardando contacto google en cuenta SE"
						}
					}

					try{
						bitrixService.generarTaskTramite(it.cuenta.bitrixId, it.factura.descripcion, it.factura.itemEspecial.comentario, it.cuenta.id, responsableServicio, "bettina@calim.com.ar")
					}
					catch(e){
						log.error(e.message)
						println "Error generando task tramite SE"
						def timeout = 3
						while(timeout > 0){
							try{
								Thread.sleep(2000)
								bitrixService.generarTaskTramite(it.cuenta.bitrixId, it.factura.descripcion, it.factura.itemEspecial.comentario, it.cuenta.id, responsableServicio, "bettina@calim.com.ar")
								break
							}
							catch(exep){
								timeout--
								println "Reintento de generación Task trámite"	
							}
						}
						if(timeout == 0){
							try{
								notificacionService.notificarErrorTaskTramite(it.cuenta.id,it.factura.descripcion,responsableServicio)
							}
							catch(ex){
								log.error("Ocurrio un error notificando error sobre task tramite cuenta " + it.cuenta.id)
							}
						}
					}

					try{
						cuentaService.adquisicionDeServicio(it.cuenta.id, it.factura.descripcion)
					}catch(e){
						log.error("Ocurrio un error realizando la accion en cuenta "+ it.cuenta.id +" tras recibir pago del servicio")
					}
				}

				if (it.factura.cuenta.trabajaConApp() && it.factura.responsable == null){
					def usuario = User.findByCuenta(it.cuenta)
					String urlNotificaciones = UsuarioService.getLinkDesactivarNotificaciones(usuario)
					NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Instrucciones Clave Fiscal Trabajador App")
					String bodyMail = plantilla.llenarVariablesBody([nombre,urlNotificaciones])
					notificacionService.enviarEmail(usuario.username, plantilla.asuntoEmail, bodyMail, 'instrucciones', null, plantilla.tituloApp, plantilla.textoApp)
					notificacionService.enviarEmailInterno("info@calim.com.ar", "Nuevo Alta Delivery", mensajeInternoHtml, 'altaNuevaDelivery')
					if(it.factura.cuenta.actionRegistro == "registroEnCurso"){
						try{
							bitrixService.editarNegociacion(it.factura.cuenta.bitrixDealId,["fields":["STAGE_ID":"C5:1"]])
						}
						catch(e){
							log.error("Error actualizando stage de Deal a Pago")
						}
					}
				}
			}
		}
		mensajeInternoHtml += "<br/>Total: \$" + pago.importe.toString().replace(".",",")
		if (avisarAResponsable)
			mensajeInternoHtml += "<br/>Responsable: $responsableServicio"
		pago.estado = Estado.findByNombre('Pagado')
		if (pago.notificaciones && pago.notificaciones.first().date_approved)
			pago.fechaPago = new LocalDateTime(pago.notificaciones.first().date_approved[0..22])
		else
			pago.fechaPago = new LocalDateTime() // Nunca debería darse el caso de que llegue acá, pero por las dudas lo contemplamos
		pago.save(flush:true, failOnError:true)
		movimientoCuentaService.saveMovimientoCuentaPago(pago)
		String direccionMail = (pago.tenantId == 2) ? "admin@calim.com.ar" : "epavoni2000@gmail.com"
		String subjectMail = (pago.tenantId == 2) ? "Pago CALIM" : "pago ESTUDIO"
		notificacionService.enviarEmailInterno(direccionMail, subjectMail, mensajeInternoHtml, 'pagoConfirmado')
		if (avisarAResponsable&&responsableServicio)
			notificacionService.enviarEmailInterno(responsableServicio, subjectMail, mensajeInternoHtml, 'pagoConfirmadoVendedores')
	}

	def reembolsarMercadoPago(PagoCuenta pago){
		pago.estado = Estado.findByNombre('Reembolsado')
		pago.save(flush:true)
		// movimientoCuentaService.saveMovimientoCuentaPago(pago)
		try{
			pago.facturas?.each{
				facturaCuentaService.cancelarFactura(it.id)
				notificacionService.notificarUsuarioNuevaFactura(it.cuenta.email,it.cuenta.nombreApellido,it.id)
			}
		}catch(e){
			println "Error generando nota de credito por reembolso para pago ID:" + pago.id
		}
		String mensajeInternoHtml = "El cliente ${pago.cuenta} obtuvo un reembolso de \$${pago.importe} en el pago con el ID ${pago.id}. Para más información <a href'" + grailsLinkGenerator.link(controller: 'cuenta', action:'show', id:pago.cuenta.id, absolute: true) + "'>acceda al show de la cuenta</a>."
		notificacionService.enviarEmailInterno("admin@calim.com.ar", "Reembolso de pago", mensajeInternoHtml, 'reembolso')
	}

	def cancelar(Long pagoId){
		return PagoCuenta.get(pagoId).with{
		estado = Estado.findByNombre("Cancelado")
			movimientoPositivo.delete(flush:true, failOnError:true)
			movimientoCuentaService.calcularSaldo(cuenta.id)
			return cuenta.id
		}
	}

	def savePagoCuentaManual(movimientos, String texto = null){
		if (! texto)
			texto = "Débito automático"
		def movimientosInstances = movimientos.collect{it instanceof MovimientoCuenta ? it : MovimientoCuenta.get(it)}
		Estado estadoPagado = Estado.findByNombre('Emitido')
		PagoCuenta pagoInstance = new PagoCuenta().with{
			fechaPago = new LocalDateTime()
			importe = movimientosInstances.sum{it.importe}
			estado = estadoPagado
			descripcion = texto
			cuenta = movimientosInstances[0].cuenta
			save(flush:true, failOnError:true)
		}
		movimientosInstances*.with{
			pago = pagoInstance
			save(flush:true, failOnError:true)
		}
		// movimientoCuentaService.saveMovimientoCuentaPago(pagoInstance)
		confirmarMercadoPago(pagoInstance)
	}

	/*
		Devuelve una lista de strings, que vendrían a ser el log de lo que pasó con esta reconstrucción
	*/
	def reconstruirMP(Long notificacionId){
		def salida = []
		def respuestaMP
		try {
			String token = "APP_USR-5790526799129112-083020-fd130a4efb0c37e9af7ec1a56e43eb27-42553970"
			def baseUrl = new URL('https://api.mercadopago.com/v1/payments/' + notificacionId + '?access_token=' + token)
			HttpURLConnection connection = (HttpURLConnection) baseUrl.openConnection()
			connection.addRequestProperty("Accept", "application/json")
			connection.with {
				doOutput = true
				requestMethod = 'GET'

				respuestaMP = new JsonSlurper().parseText(content.text)
			}	
		}
		catch(java.io.IOException e) {
			String token =  Estudio.get(2).mercadoPagoAccessTokenProduccion
			def baseUrl = new URL('https://api.mercadopago.com/v1/payments/' + notificacionId + '?access_token=' + token)
			HttpURLConnection connection = (HttpURLConnection) baseUrl.openConnection()
			connection.addRequestProperty("Accept", "application/json")
			connection.with {
				doOutput = true
				requestMethod = 'GET'

				respuestaMP = new JsonSlurper().parseText(content.text)
			}	
		}
		PagoCuenta pago = PagoCuenta.get(respuestaMP.notification_url.split("pagoId=")[1])
		def notifGuardada = guardarRespuestaMP(respuestaMP, notificacionId)
		if (notifGuardada){
			salida << "La notificación no estaba guardada o estaba desactualizada."
			pago.addToNotificaciones(notifGuardada)
			pago.save(flush:true)
		}else{
			if (pago.notificaciones.find{it.myId == notificacionId})
				salida << "La notificación estaba bien guardada."
			else
				salida << "La notificación estaba asociada a un pago incorrecto (${PaymentMP.findByMyId(new Long(notificacionId))?.pagoCuenta?.id})"
		}

		if (respuestaMP.status == "approved"){
			if (pago.estado.nombre != "Pagado"){
				salida << "Marcamos el pago como acreditado."
				confirmarMercadoPago(pago)
			}
			else
				salida << "El pago ya estaba acreditado en el sistema."
		}
		else if (respuestaMP.status == "refunded" && pago.estado.nombre != "Reembolsado"){
			if (pago.estado.nombre != "Pagado"){
				salida << "Marcamos el pago como acreditado."
				confirmarMercadoPago(pago)
			}
			salida << "Marcamos el pago como reembolsado."
			reembolsarMercadoPago(pago)
		}
		else
			salida << "La notificación no está ni acreditada ni reembolsada."

		pago.movimientos.each{
			it.movimientoMPId = notificacionId
			it.save(flush:true)
		}

		return salida
	}

	private guardarRespuestaMP(respuesta, id){
		try {
			PaymentMP.findAllByMyId(new Long(id))?.each{
				assert it.status != respuesta.status // Repetimos pagos con ID solamente si el status es distinto
			}
			PaymentMP payment = new PaymentMP()
			payment.fechaNotificacion = new LocalDate()

			payment.call_for_authorize_id = respuesta.call_for_authorize_id
			payment.callback_url = respuesta.callback_url
			payment.coupon_code = respuesta.coupon_code
			payment.currency_id = respuesta.currency_id
			payment.date_approved = respuesta.date_approved
			payment.date_created = respuesta.date_created
			payment.date_last_updated = respuesta.date_last_updated
			payment.description = respuesta.description
			payment.external_reference = respuesta.external_reference
			payment.issuer_id = respuesta.issuer_id
			payment.metadata = respuesta.metadata
			payment.money_release_date = respuesta.money_release_date
			payment.notification_url = respuesta.notification_url
			payment.operation_type = respuesta.operation_type
			payment.payment_method_id = respuesta.payment_method_id
			payment.payment_type_id = respuesta.payment_type_id
			payment.statement_descriptor = respuesta.statement_descriptor
			payment.status = respuesta.status
			payment.status_detail = respuesta.status_detail
			payment.token = respuesta.token

			payment.binary_mode = respuesta.binary_mode ?: false
			payment.capture = respuesta.capture ?: false
			payment.captured = respuesta.captured ?: false
			payment.live_mode = respuesta.live_mode ?: false

			payment.campaign_id = respuesta.campaign_id
			payment.collector_id = respuesta.collector_id
			payment.differential_pricing_id = respuesta.differential_pricing_id
			payment.installments = respuesta.installments

			payment.application_fee = respuesta.application_fee
			payment.coupon_amount = respuesta.coupon_amount
			payment.myId = new Long(id)
			payment.transaction_amount = respuesta.transaction_amount
			payment.transaction_amount_refunded = respuesta.transaction_amount_refunded

			payment.payer = parsearPayer(respuesta.payer)

			if (respuesta.additional_info){
				AdditionalInfoMP info = new AdditionalInfoMP()

				info.ip_address = respuesta.additional_info.ip_address

				info.payer = parsearPayer(respuesta.additional_info.payer)

				if (respuesta.additional_info.shipments){
					ShipmentsMP envio = new ShipmentsMP()
					envio.receiver_address = parsearDireccion(respuesta.additional_info.shipments.receiver_address)
					info.shipments = envio
				}

				if (respuesta.additional_info.barcode){
					BarcodeMP codigoBarras = new BarcodeMP()

					codigoBarras.type = respuesta.additional_info.barcode.type
					codigoBarras.content = respuesta.additional_info.barcode.content
					codigoBarras.width = respuesta.additional_info.barcode.width
					codigoBarras.height = respuesta.additional_info.barcode.height

					info.barcode = codigoBarras
				}

				if (respuesta.additional_info.items)
					respuesta.additional_info.items.each{
						ItemMP itemMp = new ItemMP()

						itemMp.category_id = it.category_id
						itemMp.description = it.description
						itemMp.myId = it.id
						itemMp.picture_url = it.picture_url
						itemMp.title = it.title

						itemMp.quantity = it.quantity

						itemMp.unit_price = new Float(it.unit_price)

						info.addToItems(itemMp)
					}

				payment.additional_info = info
			}

			if (respuesta.card){
				CardMP tarjeta = new CardMP()

				tarjeta.date_created = respuesta.card.date_created
				tarjeta.date_last_updated = respuesta.card.date_last_updated
				tarjeta.first_six_digits = respuesta.card.first_six_digits
				tarjeta.last_four_digits = respuesta.card.last_four_digits

				tarjeta.expiration_month = respuesta.card.expiration_month
				tarjeta.expiration_year = respuesta.card.expiration_year
				if (respuesta.card.id)
					tarjeta.myId = new Long(respuesta.card.id)

				if (respuesta.card.cardholder){
					CardholderMP cardholder = new CardholderMP()
					cardholder.name = respuesta.card.cardholder.name
					cardholder.identification = parsearIdentification(respuesta.card.cardholder.identification)
					tarjeta.cardholder = cardholder
				}

				payment.card = tarjeta
			}

			if (respuesta.fee_details)
				respuesta.fee_details.each{
					FeeDetailsMP fee_details = new FeeDetailsMP()

					fee_details.type = it.type
					fee_details.fee_payer = it.fee_payer

					fee_details.amount = it.amount

					payment.addToFee_details(fee_details)
				}

			if (respuesta.order){
				OrderMP order = new OrderMP()

				order.type = respuesta.order.type
				order.myId = new Long(respuesta.order.id)

				payment.order = order
			}

			if (respuesta.transaction_details){
				TransactionDetailsMP transaction_details = new TransactionDetailsMP()

				transaction_details.external_resource_url = respuesta.transaction_details.external_resource_url
				transaction_details.financial_institution = respuesta.transaction_details.financial_institution
				transaction_details.payment_method_reference_id = respuesta.transaction_details.payment_method_reference_id

				transaction_details.installment_amount = respuesta.transaction_details.installment_amount
				transaction_details.net_received_amount = respuesta.transaction_details.net_received_amount
				transaction_details.overpaid_amount = respuesta.transaction_details.overpaid_amount
				transaction_details.total_paid_amount = respuesta.transaction_details.total_paid_amount

				payment.transaction_details = transaction_details
			}

			if (respuesta.refunds)
				respuesta.refunds.each{
					RefundMP refund = new RefundMP()

					refund.metadata = it.metadata
					refund.unique_sequence_number = it.unique_sequence_number
					refund.date_created = it.date_created

					refund.myId = it.id
					refund.payment_id = it.payment_id

					refund.amount = it.amount

					if (it.source){
						SourceMP source = new SourceMP()
						source.myId = it.source.id
						source.name = it.source.name
						source.type = it.source.type

						refund.source = source
					}

					payment.addToRefunds(refund)
				}

			return payment.save(flush:true, failOnError:true)
		}
		catch(java.lang.AssertionError e){
			println "Ya estaba guardada la respuesta de MP con ID ${id}."
		}
		catch(Exception e) {
			log.error("\nError guardando la respuesta de MP con ID ${id}.\n\n" + e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		return null
	}

	private parsearDireccion(jsonDireccion){
		if (! jsonDireccion)
			return null

		AddressMP direccion = new AddressMP()

		direccion.apartment = jsonDireccion.apartment
		direccion.floor = jsonDireccion.floor
		direccion.street_name = jsonDireccion.street_name
		direccion.zip_code = jsonDireccion.zip_code

		direccion.street_number = jsonDireccion.street_number

		return direccion
	}

	private parsearPayer(jsonPayer){
		if (jsonPayer){
			PayerMP payer = new PayerMP()

			payer.email = jsonPayer.email
			payer.entity_type = jsonPayer.entity_type
			payer.first_name = jsonPayer.first_name
			payer.myId = jsonPayer.id
			payer.last_name = jsonPayer.last_name
			payer.registration_date = jsonPayer.registration_date
			payer.type = jsonPayer.type

			payer.address = parsearDireccion(jsonPayer.address)

			payer.identification = parsearIdentification(jsonPayer.identification)

			if (jsonPayer.phone){
				PhoneMP telefono = new PhoneMP()

				telefono.area_code = jsonPayer.phone.area_code
				telefono.number = jsonPayer.phone.number
				telefono.extension = jsonPayer.phone.extension

				payer.phone = telefono
			}
			return payer
		}else
			return null
	}

	private parsearIdentification(jsonIdentification){
		if (jsonIdentification){
			IdentificationMP identificacion = new IdentificationMP()

			identificacion.type = jsonIdentification.type
			identificacion.number = jsonIdentification.number

			return identificacion
		}else
			return null
	}
}
