package com.zifras

import grails.converters.JSON
import grails.util.Environment
import org.grails.web.json.JSONObject
import groovyx.net.http.HTTPBuilder
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.springframework.context.i18n.LocaleContextHolder
import grails.gorm.multitenancy.Tenants
import grails.plugin.springsecurity.annotation.Secured
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.ventas.Vendedor
import com.zifras.notificacion.ConsultaWeb
import com.zifras.ventas.VendedorService
import grails.transaction.Transactional
import static grails.gorm.multitenancy.Tenants.*

@Secured(['permitAll'])
@Transactional
class BitrixService{
	static vendedorService
	def cuentaService
	public accessTokenBitrix() {	
		def salida
		def accessToken
		def refreshToken = com.zifras.Estudio.get(2).refreshTokenBitrix
		new HTTPBuilder('https://calim.bitrix24.com/oauth/token/?grant_type=refresh_token&client_id=local.5f6b8291cf2471.69621837&client_secret=iTldm4WdjRKFeq5IGi66MIe78FvsPCdj9Oa6Ihw3wJB6VBkEvn&refresh_token='+refreshToken+'&scope=granted_permission&redirect_uri=app_URL').request(groovyx.net.http.Method.GET, groovyx.net.http.ContentType.JSON) { req ->
			response.failure = { resp, reader ->
				log.error("Hubo un error obteniendo el Access Token")
			}
			response.success = { resp, reader ->
				accessToken = reader.access_token
			}
		}
		return accessToken
	}

	public actualizarRefreshToken(){
		def estudioCalim = com.zifras.Estudio.get(2)
		def refreshToken = estudioCalim.refreshTokenBitrix
		def nuevoRefreshToken
		new HTTPBuilder('https://calim.bitrix24.com/oauth/token/?grant_type=refresh_token&client_id=local.5f6b8291cf2471.69621837&client_secret=iTldm4WdjRKFeq5IGi66MIe78FvsPCdj9Oa6Ihw3wJB6VBkEvn&refresh_token='+refreshToken+'&scope=granted_permission&redirect_uri=app_URL').request(groovyx.net.http.Method.GET, groovyx.net.http.ContentType.JSON) { req ->
			response.failure = { resp, reader ->
				log.error("Hubo un error obteniendo el Refresh Token")
			}
			response.success = { resp, reader ->
				nuevoRefreshToken = reader.refresh_token
			}
		}
		estudioCalim.refreshTokenBitrix = nuevoRefreshToken
		estudioCalim.save(flush:true, failOnError:true)
	}

	public getContactoBitrix(idContacto) {	
		if (!idContacto)
			return null
		def salida
		def ide
		def accessToken = accessTokenBitrix()
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.contact.get?auth='+accessToken+'&id='+idContacto).request(groovyx.net.http.Method.GET, groovyx.net.http.ContentType.JSON) { req ->
			response.failure = { resp, reader ->
				log.error("Hubo un error obteniendo el Contacto")
			}
			response.success = { resp, reader ->
				salida = reader
				ide = reader.result['ID']
			}
		}
		return ide
	}

	public getNegociacion(idNegociacion) {	
		def salida = [:]
		def accessToken = accessTokenBitrix()
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.deal.get?auth='+accessToken+'&id='+idNegociacion).request(groovyx.net.http.Method.GET, groovyx.net.http.ContentType.JSON) { req ->
			response.failure = { resp, reader ->
				throw new Exception("Error obteniendo negociacion")
			}
			response.success = { resp, reader ->
				salida['dealTitle'] = reader.result['TITLE']
				salida['dealId'] = reader.result['ID']
				salida['contactId'] = reader.result['CONTACT_ID']
				salida['stageId'] = reader.result['STAGE_ID']
				salida['assignedById'] = reader.result['ASSIGNED_BY_ID']
			}
		}
		return salida
	}

	public getProductosNegociacion(idNegociacion) {	
		def salida = [:]
		def accessToken = accessTokenBitrix()
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.deal.productrows.get?auth='+accessToken+'&id='+idNegociacion).request(groovyx.net.http.Method.GET, groovyx.net.http.ContentType.JSON) { req ->
			response.failure = { resp, reader ->
				log.error("Hubo un error obteniendo los productos de la negociacion")
			}
			response.success = { resp, reader ->
				println reader
			}
		}
		return salida
	}

	public getUserIdBitrix(String emailVendedor) {	
		def salida
		def accessToken = accessTokenBitrix()
		new HTTPBuilder('https://calim.bitrix24.com/rest/user.get.json?EMAIL='+emailVendedor+'&auth='+accessToken).request(groovyx.net.http.Method.GET, groovyx.net.http.ContentType.JSON) { req ->
			response.failure = { resp, reader ->
				log.error("Hubo un error obteniendo el Access Token")
			}
			response.success = { resp, reader ->
				salida = reader
			}
		}
	
		def bitrixUserId = salida.result["ID"].toString().replace('[','').replace(']','')
		
		return bitrixUserId
	}

	public getContactFields() {	
		def salida
		def accessToken = accessTokenBitrix()
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.contact.fields?'+'&auth='+accessToken).request(groovyx.net.http.Method.GET, groovyx.net.http.ContentType.JSON) { req ->
			response.failure = { resp, reader ->
				log.error("Hubo un error obteniendo los fields")
			}
			response.success = { resp, reader ->
				salida = reader
			}
		}
		println salida
		return 
	}

	public borrarNegociacion(idNegociacion){
		def accessToken = accessTokenBitrix()
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.deal.delete?auth='+accessToken+'&id='+idNegociacion).request(groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON) { req ->
			headers.'Content-Type' = 'application/json'
			response.failure = { resp, json ->
					println "Hubo un error borrando negociacion"
					println "HTTPStatus ${resp.status}"
					println "${json}"
			}
			response.success = { resp ->
				println "Negociacion borrada"
			}
		}
	}

	public editarContacto(String idContacto, datos){
		if (!idContacto)
			return null
		def respuesta
		def accessToken = accessTokenBitrix()
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.contact.update?auth='+accessToken+'&id='+idContacto).request(groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON) { req ->
			headers.'Content-Type' = 'application/json'
			body = datos
			response.failure = { resp, json ->
				log.error("Hubo un error actualizando el contacto\nHTTPStatus ${resp.status}\n\n ${json}")
			}
			response.success = { resp, json ->
				respuesta = json
			}
		}
		return respuesta
	}

	public editarNegociacion(idNegociacion, datos){
		if (!idNegociacion)
			return null
		def respuesta
		def accessToken = accessTokenBitrix()
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.deal.update?auth='+accessToken+'&id='+idNegociacion).request(groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON) { req ->
			headers.'Content-Type' = 'application/json'
			body = datos
			response.failure = { resp, json ->
				log.error("Hubo un error actualizando la negociacion\nHTTPStatus ${resp.status}\n\n ${json}")
			}
			response.success = { resp, json ->
				println "Negociacion modificada."
				respuesta = json
			}
		}
		return respuesta
	}

	 public generarTaskAltaMonotributo(Long bitrixId, Long cuentaId){

	 	def cuenta = Cuenta.get(cuentaId)
		def accessToken = accessTokenBitrix()
		def contacto = "C_" + bitrixId
		def respuesta
		LocalDateTime fech = new LocalDateTime().plusDays(2).plusHours(3) //por hora del servidor y bitrix

		new HTTPBuilder('https://calim.bitrix24.com/rest/tasks.task.add?auth='+accessToken).request(groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON){ req ->
			headers.'Content-Type' = 'application/json'
			body = ["fields":
						["TITLE":"Alta Monotributo Delivery",
						"RESPONSIBLE_ID":"25",
						"DEADLINE":fech.toString(),
						"UF_CRM_TASK":[contacto]
						]
					]
			response.failure = { resp, json ->
				log.error("Hubo un error generando el task de alta monotributo\nHTTPStatus ${resp.status}\n\n ${json}")
			}
			response.success = { resp, json ->
				println json
				respuesta = json
				cuentaService.actualizarBitrixTaskId(cuentaId,new Long(json.result.task.id))
			}
		}
	}

	def guardarBitrixIdVendedores(){
		def vendedores = Vendedor.getAll().findAll{!it.deshabilitado}
		vendedores.each{
			def id = new Long(getUserIdBitrix(it.email))
			it.bitrixId = id
			it.save(flush:true,failOnError:true)
			println "Guardado id de "+it.nombre
		}
	}

	def generarTaskTramite(Long bitrixId, String descripcionServicio, String comentario, Long cuentaId, String responsableServicio, String responsableTask){
		if(Environment.current != Environment.PRODUCTION){
			println "Se crearia task en Bitrix pero no estas en produccion"
			return
		}
		if(descripcionServicio){
			String codigo = descripcionServicio.split(" - ")[0]
			if(codigo == "SE17" || codigo == "SE18")
				return
		}else{
			descripcionServicio == "-"
		}
		def cuenta = Cuenta.get(cuentaId)
		def accessToken = accessTokenBitrix()
		def contacto = "C_" + bitrixId
		def respuesta
		comentario = comentario ?: "-" 

		LocalDateTime fech = new LocalDateTime().plusDays(2).plusHours(3)
		def diaHoy = new LocalDate().getDayOfWeek()
		if(diaHoy == 5 || diaHoy == 4)
			fech = fech.plusDays(2)
		if(diaHoy == 6)
			fech = fech.plusDays(1)

		def vendedor = Vendedor.findByEmail(responsableServicio)
		def createdById = vendedor?.bitrixId ?: getUserIdBitrix(responsableServicio)
		def responsibleId = getUserIdBitrix(responsableTask)

		new HTTPBuilder('https://calim.bitrix24.com/rest/tasks.task.add?auth='+accessToken).request(groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON){ req ->
			headers.'Content-Type' = 'application/json'
			body = ["fields":
						["TITLE":descripcionServicio,
						"RESPONSIBLE_ID":responsibleId,
						"DESCRIPTION":comentario,
						"CREATED_BY":createdById,
						"DEADLINE":fech.toString(),
						"UF_CRM_TASK":[contacto]
						]
					]
			response.failure = { resp, json ->
				log.error("Hubo un error generando el task tramite de Servicio" + descripcionServicio +"\nHTTPStatus ${resp.status}\n\n ${json}")
				throw new Exception("Error generando task")
			}
			response.success = { resp, json ->
				respuesta = json
				cuentaService.actualizarBitrixTaskId(cuentaId,new Long(json.result.task.id))
			}
		}
	}

	public generarContactosFaltantes(){
		def fechaInf = LocalDateTime.parse("2021-05-22T23:54:00")
		def fechaSup = LocalDateTime.parse("2021-05-26T14:19:28")
		def consultas = ConsultaWeb.getAll().findAll{it.fechaHora.isAfter(fechaInf) && it.fechaHora.isBefore(fechaSup)}
		consultas.each{
			def bitrixClientId
			def negociacionId
			try{
				bitrixClientId = crearContactoBitrix(it.nombre,it.apellido,it.telefono,it.email,"No definido","Regeneracion contacto")
				if (! bitrixClientId)
					bitrixClientId = bitrixService.crearContactoBitrix(it.nombre,it.apellido,it.telefono,null,"No definido","Consulta Web") // vuelvo a intentar sin mail
				println "Contacto creado, id: " + bitrixClientId
				if(bitrixClientId)
					negociacionId = crearNegociacionBitrix(bitrixClientId,"Consulta Web "+it.tag,"vendedor@calim.com.ar","general")
				println "Negociacion creada, id: " + negociacionId
			}
			catch(e){
				println "Error creando negociacion Bitrix"
			}
		}
	}

	public editarTask(idTask,datos){
		if (!idTask)
			return null
		def respuesta
		def accessToken = accessTokenBitrix()
		new HTTPBuilder('https://calim.bitrix24.com/rest/tasks.task.update?auth='+accessToken+'&id='+idTask).request(groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON) { req ->
			headers.'Content-Type' = 'application/json'
			body = datos
			response.failure = { resp, json ->
				log.error("Hubo un error actualizando la negociacion\nHTTPStatus ${resp.status}\n\n ${json}")
				println resp
				println json
			}
			response.success = { resp, json ->
				respuesta = json
			}
		}
		return respuesta
	}

	def agregarProductosDeal(Long dealId, Long bitrixId, servicios, String responsable){
		if (!bitrixId)
			return null
		def respuesta
		def deal 
		def vendedor = Vendedor.findByEmail(responsable)
		if(responsable){
			try{
				deal = getNegociacion(dealId)
				if(deal['stageId'] == "WON" || deal['stageId'] == "LOSE" || vendedor?.bitrixId != deal["assignedById"])
					dealId = crearNegociacionBitrix(deal['contactId'],"Venta servicio",responsable,"general")
			}
			catch(e){
				dealId = crearNegociacionBitrix(bitrixId,"Venta servicio",responsable,"general")
			}
		}
		def accessToken = accessTokenBitrix()
		def productosId = []
		def data = [:]
		def productos = getProductList()
		servicios.each{serv->
			productos.each{
				if(it['NAME'].split(" - ")[0] == serv.codigo && it['PRICE'] == serv.precio +'0')
					serv.id = it['ID']
			}
			if(!serv.id)
				serv.id = crearProducto(serv.codigo + " - " + serv.nombre, serv.precio)
		}
		def datos = [:]
		datos['rows'] = []
		for(int i=0;i<servicios.size();i++){
			datos['rows'] << ['PRODUCT_ID':servicios[i].id,'QUANTITY':1,'PRICE':servicios[i].precio]
		}
		
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.deal.productrows.set?auth='+accessToken+'&id='+dealId).request(groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON) { req ->
			headers.'Content-Type' = 'application/json'
			body = datos
			response.failure = { resp, json ->
				log.error("Hubo un error agregando producto a la negociacion\nHTTPStatus ${resp.status}\n\n ${json}")
			}
			response.success = { resp, json ->
				respuesta = json
				try{
					editarNegociacion(dealId,["fields":["STAGE_ID":"6"]]) 
				}catch(e){
					log.error("Hubo un error moviendo la negociacion de stage a 'Se envio boton de pago'")
				}
			}
		}
		return respuesta
	}

	public getProductList(){
		def accessToken = accessTokenBitrix()
		def respuesta
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.product.list?auth='+accessToken).request(groovyx.net.http.Method.GET, groovyx.net.http.ContentType.JSON){ req ->
			headers.'Content-Type' = 'application/json'
			response.failure = { resp, json ->
				log.error("Hubo un error actualizando el contacto\nHTTPStatus ${resp.status}\n\n ${json}")
			}
			response.success = { resp, json ->
				respuesta = json.result
			}
		}
		return respuesta
	}

	public crearContactoBitrix(String nombre, String apellido, String celular, String email ,String clienteCalimId, String path, String tag = "", String celularIngresado = "") {	
		def accessToken = accessTokenBitrix()
		def celWpp = ""
		if(celular)
			celWpp = celular.replace("+","")
		def clienteId
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.contact.add?auth='+accessToken).request(groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON) { req ->
			headers.'Content-Type' = 'application/json'
			body = [
				"fields" : 
					[
					"NAME":nombre,
					"LAST_NAME":apellido,
					"EMAIL":[["VALUE":email]],
					"PHONE":[["VALUE":celular]],
					"SOURCE_DESCRIPTION":path,
					"UF_CRM_1611603905329":"https://api.whatsapp.com/send?phone="+celWpp,
					"COMMENTS":"ID Calim: "+clienteCalimId,
					"UF_CRM_1623162794588": tag,
					"UF_CRM_1627570053": celularIngresado
					]
			]
			response.failure = { resp, json ->
				log.error("Hubo un error creando contacto\nHTTPStatus ${resp.status}\n\n ${json}")
			}
			response.success = { resp, json ->
				println "\nContacto creado en Bitrix."
				clienteId = json.result
			}
		}

		return clienteId
	}

	public getResponsableAAsignar(){
		def	vendedor = vendedorService.getVendedorAAsignar()
		return vendedor.bitrixId
	}

	public crearProducto(String nombreProducto, Double precioProducto){
		def salida
		def accessToken = accessTokenBitrix()
		def datos = [
					"fields" : 
						[
						"NAME":nombreProducto,
						"PRICE":precioProducto
						]
				]
		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.product.add?auth='+accessToken).request(groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON) { req ->
			headers.'Content-Type' = 'application/json'
			body = datos
			response.failure = { resp, json ->
				log.error("Hubo un error creando el producto\nHTTPStatus ${resp.status}\n\n ${json}")
			}
			response.success = { resp, json ->
				println "\nProducto creado en Bitrix."
				salida = json
			}
		}
		return salida.result
	}

	public getData(String categoria, String emailVendedor){
		def data = [:]
		switch(categoria) {
			case "general":
				if(!emailVendedor)
					data["userId"] = getResponsableAAsignar()
				else
					data["userId"] = Vendedor.findByEmail(emailVendedor)?.bitrixId ?: getUserIdBitrix(emailVendedor)
				data["categoryId"] = 0
				break
			case "delivery":
				data["userId"] = getUserIdBitrix("alejandro@calim.com.ar")
				data["categoryId"] = 5
				break
			case "presentacionSM":
				data["userId"] = getUserIdBitrix("samanta@calim.com.ar")
				data["categoryId"] = 11
				break
			case "avisoCobranza":
				data["userId"] = getUserIdBitrix("samanta@calim.com.ar")
				data["categoryId"] = 9
				break
			default:
				data["userId"] = getResponsableAAsignar()
				data["categoryId"] = 0
		}
		return data
	}

	public crearNegociacionBitrix(clienteId, nombreNegociacion, String emailVendedor, String categoria) {	
		if(Environment.current != Environment.PRODUCTION){
			println "Se crearia negociacion en Bitrix pero no estas en produccion"
			return
		}
		def accessToken = accessTokenBitrix()
		def salida
		def negociacionId
		def bodyNeg

		def data = getData(categoria,emailVendedor)

		bodyNeg = [
				"fields" : 
					[
					"TITLE":nombreNegociacion,
					"CONTACT_ID":clienteId,
					"ASSIGNED_BY_ID": data["userId"],
					"CATEGORY_ID": data["categoryId"]
					]
			]

		new HTTPBuilder('https://calim.bitrix24.com/rest/crm.deal.add?auth='+accessToken).request(groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON) { req ->
			headers.'Content-Type' = 'application/json'
			body = bodyNeg
			response.failure = { resp, json ->
				log.error("Hubo un error creando negociacion\nHTTPStatus ${resp.status}\n\n ${json}")
			}
			response.success = { resp, json ->
				println "\nNegociacion creada en Bitrix."
				editarContacto(clienteId.toString(),["fields":["ASSIGNED_BY_ID": data["userId"]]])
				salida = json
				negociacionId = json.result
			}
		}
		return negociacionId
	}

	public guardarEnBitrix(command, cuentaRegistrada, origen, String emailVendedor){
		def respuesta = [:]
		//if (! grails.util.Environment.isDevelopmentMode()){
		 if (true){
			try {
				// Creo el CLIENTE y guardo su ID
				respuesta['bitrixClientId'] = crearContactoBitrix(command.nombre, command.apellido, command.celular, command.username, cuentaRegistrada.id.toString(), origen)
				editarContacto(respuesta['bitrixClientId'].toString(),["fields":["UF_CRM_1600954073": cuentaRegistrada.id.toString(), "UF_CRM_1607718625" : "https://app.calim.com.ar/cuenta/show/"+cuentaRegistrada.id.toString()]])
				Tenants.withId(2) {
					Cuenta.withTransaction{ session ->
						cuentaRegistrada?.with{
							bitrixId = respuesta['bitrixClientId']
							save(flush:true)
						}
					}
				}
				if(origen != "Registro Normal"){
					respuesta['negociacionId'] = crearNegociacionBitrix(respuesta['bitrixClientId'], origen, emailVendedor,"general")
					cuentaService.actualizarBitrixDealId(cuentaRegistrada.id, respuesta['negociacionId'])
				}
			}
			catch(Exception e) {
				log.error("Hubo un error con Bitrix durante un registro.")
				println e.message
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
		}
		return respuesta
	}

}
