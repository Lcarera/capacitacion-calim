package com.zifras.documento

import com.zifras.Estado
import com.zifras.Localidad
import com.zifras.Provincia

import com.zifras.cuenta.CondicionIva
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.RegimenIibb

import com.zifras.mercadopago.NotifMPError

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured;
import grails.validation.ValidationException
import org.joda.time.LocalDate;
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_LECTURA', 'ROLE_COBRANZA', 'IS_AUTHENTICATED_FULLY'])
class PagoCuentaController {
	def pagoCuentaService

	def noconectados(){
		def salida = []
		PagoCuenta.findAllByEstado(Estado.findByNombre("Pagado")).sort{it.cuenta}.each{ pago ->
			def movNoPositivos = pago.movimientos - [pago.movimientoPositivo]
			if (!movNoPositivos){
				salida << "Pago ${pago.id} por \$${com.zifras.inicializacion.JsonInicializacion.formatear(pago.importe)} de la cuenta <a href='/cuenta/show/${pago.cuenta.id}#cuentaCorriente'>${pago.cuenta}</a>"
			}
		}
		render salida.join("<br>")
	}

	def index() {
		redirect(action: "list", params: params)
	}

	def buscarFechas(Boolean id){
		render PagoCuenta.list().findAll{ it.notificaciones && (id || fechaAprov(it)) && it.fechaPago.toString("dd/MM/YYYY") != fechaAprov(it)?.toString("dd/MM/YYYY")}.collect{["Pago ID ${it.id}", it.cuenta.toString(), "<a href='/cuenta/show/${it.cuenta.id}#cuentaCorriente'>Ir a cuenta</a>", it.estado.nombre, "\$${it.importe}", "Fecha Pago vieja: " + it.fechaPago?.toString("dd/MM/YYYY"), "Fecha Aprobación: " + fechaAprov(it)?.toString("dd/MM/YYYY")].join("<br/>")}.join("<br/>"*2)
	}

	private LocalDate fechaAprov(PagoCuenta pago){
		return pago.notificaciones.find{it.date_approved}?.with{new LocalDate(date_approved.split("T")[0])}
	}

	def cancelar(Long id){
		try {
			def cuentaId = pagoCuentaService.cancelar(id)
			flash.message = "Pago cancelado exitosamente."
			redirect(controller:'cuenta', action:'show', id:cuentaId)
		}
		catch(Exception e) {
			flash.error = "Ocurrió un error cancelando el pago seleccionado."
			redirect(controller:'cuenta', action:'list')
		}
	}

	def create() {/*
		def command = pagoCuentaService.createPagoCuentaCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[pagoCuentaInstance: command]
	*/
		flash.error = "Marque como pagados los movimientos desde la cuenta corriente del cliente."
		redirect(controller:'cuenta', action:'list')
	}

	def save(PagoCuentaCommand command) {
		if (command.hasErrors()) {
			flash.error = command.errors.allErrors.each {
        		flash.error = it
    		}
			//flash.error = message(code: 'zifras.pagoCuenta.PagoCuentaCommand.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [pagoCuentaInstance: command])
			return
		}
		
		def pagoCuentaInstance
		
		try {
			def archivo = request.getFile('archivo')
			pagoCuentaInstance = pagoCuentaService.savePagoCuenta(command,archivo)
		}catch (e){
			flash.error	= message(code: 'zifras.pagoCuenta.PagoCuenta.save.error', default: 'Error al intentar salvar el Pago')
			render(view: "create", model: [pagoCuentaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.pagoCuenta.PagoCuenta.label', default: 'PagoCuenta'), pagoCuentaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def list() {
	}

	def show(Long id) {
		def pagoCuentaInstance = pagoCuentaService.getPagoCuenta(id)
		if (!pagoCuentaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.pagoCuenta.PagoCuenta.label', default: 'PagoCuenta'), id])
			redirect(action: "list")
			return
		}

		[pagoCuentaInstance: pagoCuentaInstance]
	}

	def edit(Long id) {
		def pagoCuentaInstance = pagoCuentaService.getPagoCuentaCommand(id)
		if (!pagoCuentaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.pagoCuenta.PagoCuenta.label', default: 'PagoCuenta'), id])
			redirect(action: "list")
			return
		}

		[pagoCuentaInstance: pagoCuentaInstance]
	}

	def update(PagoCuentaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [pagoCuentaInstance: command])
			return
		}
		
		def pagoCuentaInstance
		
		try {
			def archivo = request.getFile('archivo')
			pagoCuentaInstance = pagoCuentaService.updatePagoCuenta(command,archivo)
		}
		catch (ValidationException e){
			pagoCuentaInstance.errors = e.errors
			render(view: "edit", model: [pagoCuentaInstance: pagoCuentaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [pagoCuentaInstance: pagoCuentaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.pagoCuenta.PagoCuenta.label', default: 'PagoCuenta'), pagoCuentaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def pagoCuentaInstance = pagoCuentaService.getPagoCuenta(id)
		if (!pagoCuentaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.pagoCuenta.PagoCuenta.label', default: 'PagoCuenta'), id])
			redirect(action: "list")
			return
		}
		String numero = pagoCuentaInstance.id

		try {
			pagoCuentaService.deletePagoCuenta(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.pagoCuenta.PagoCuenta.label', default: 'PagoCuenta'), numero], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.pagoCuenta.PagoCuenta.label', default: 'PagoCuenta'), numero], encodeAs:'none')
			redirect(action: "list")
		}
	}

	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def pagarAMano(Long id){
		PagoCuenta pago = PagoCuenta.get(id)
		pagoCuentaService.confirmarMercadoPago(pago)
		flash.message = "Pago acreditado manualmente, con envío de mails"
		redirect(controller: 'cuenta', action: 'show', id:pago.cuenta.id)
	}
	
	def download(Long id){
		try {
			def file = pagoCuentaService.getFile(id);
			response.setContentType("APPLICATION/OCTET-STREAM")
	        response.setHeader("Content-Disposition", "Attachment;Filename=\"${file.getName()}\"")
	                
	        def fileInputStream = new FileInputStream(file)
	        def outputStream = response.getOutputStream()
	        byte[] buffer = new byte[4096];
	        int len;
	        while ((len = fileInputStream.read(buffer)) > 0) {
	            outputStream.write(buffer, 0, len);
	        }

	        outputStream.flush()
	        outputStream.close()
	        fileInputStream.close()
		}
		catch(Exception e) {
			if (e.message=="no existe")
				flash.error="No se pudo encontrar el archivo solicitado."
			else if(e.message=="permisos")
				flash.error="No posee permiso para acceder a este archivo."
			else{
				flash.error="Ocurrió un error inesperado descargando el archivo."
				println "Error:"
				println e
				println ""
			}
	   		redirect(action: "list")
		}
	}
	
	@Secured(['ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
	def pagarMovimientos(String movimientos){
		try {
			redirect(url: pagoCuentaService.pagarMovimientos(movimientos.split(',')))
		}
		catch(Exception e) {
			flash.error = "Ocurrió un error generando el botón de pago."
			redirect(controller: 'miCuenta')
		}	
	}

	@Secured(['ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
	def pagarMovimientosApp(String movimientos){
		try {
			render pagoCuentaService.pagarMovimientos(movimientos.split(','))
		}
		catch(Exception e) {
			render "Ocurrió un error generando el botón de pago."
		}	
	}
	
	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def createManual(String cuentaId, String movimientos){
		try {
			pagoCuentaService.savePagoCuentaManual(movimientos.split(','))
			flash.message = "Movimientos cancelados"
		}
		catch(Exception e) {
			log.error(e.message)
			flash.error = "Ocurrió un error generando el botón de pago."
		}
		redirect(controller: 'cuenta', action:'show', id:cuentaId)
	}
	
	@Secured(['ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
	def cancelarSaldo (){
		try {
			redirect(url: pagoCuentaService.cancelarSaldo())
		}
		catch(Exception e) {
			flash.error = "Ocurrió un error generando el botón de pago."
			redirect(controller: "dashboard")
		}
	}

	@Secured(['ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
	def cancelarSaldoApp (){
		try {
			render pagoCuentaService.cancelarSaldo()
		}
		catch(Exception e) {
			render "Ocurrió un error generando el botón de pago."
		}
	}

	/*@Secured(['permitAll'])
	def mercadoPagoQR(Long id){ // Es la ID del local
		println "\nMe llegó algo\n\n"
		println params
		println "\n"
		def respuesta
		try {
			def pago = pagoCuentaService.obtenerDatosQr(id)
			if (pago){
				String token = com.zifras.Estudio.get(1).mercadoPagoAccessTokenProduccion
				respuesta = [
						collector_id: token.split("-")[-1],
						items:[
							title: pago['detalle'],	
							currency_id: "ARS",	
							description: pago['detalle'],
							quantity: "1.0",
							unit_price: pago['importe']
						],
						external_reference: pago['id'],
						notification_url: createLink(action:'notificacionMPPavoni', params:[pagoId:pago['id']], absolute:true)
					]
				respond(respuesta, status: 200)
			}
			else{
				respuesta = [error:[type:"Al dia", message:"No se detectaron pagos pendientes"]]
				respond(respuesta, status: 400)
			}
		}
		catch(Exception e) {
			respuesta = [error:[type:"Error", message:"No se pudo generar el pago"]]
			respond(respuesta, status: 400)	
		}
		render respuesta as JSON
	}*/

	@Secured(['permitAll'])
	def notificacionMP(){
		def idNotif
		if (params.topic != "merchant_order"){
			try {
				idNotif = params.id
				if (idNotif == null || idNotif == '' || ! idNotif) // Lo pregunto de muchas formas distintas porque a veces esto se comporta raro y tira null igual
					idNotif = params.data.id
				try {
					pagoCuentaService.recibirNotificacionMP(params.pagoId, idNotif , 2, false)
				}
				catch(java.io.IOException e) {
					println "\nRecibimos una notificación sobre el MercadoPago viejo...\n"
					pagoCuentaService.recibirNotificacionMP(params.pagoId, idNotif , 2, true)
				}
			}
			catch(Exception e) {
				println """

						ErrnotfMp4

						"""
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				try {
					new NotifMPError().with{
						if (idNotif && idNotif != null && idNotif != '')
							mpId = new Long (idNotif)
						fechaHora = new org.joda.time.LocalDateTime()
						if (params.pagoId && params.pagoId != null && params.pagoId != '')
							pagoCuentaId = new Long (params.pagoId)
						paramsString = params.collect{it.key + ": " + it.value}.join(", ")
						mensajeError = e.message
						save(flush:true)
					}
				}
				catch(Exception errordesave) {
				}
			}
		}
		respond([:], status: 200)
		render "OK"
	}

	def reconstruir(Long id){
		String salida
		try {
			salida = pagoCuentaService.reconstruirMP(id)	
		}
		catch(Exception e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		render salida
	}

	@Secured(['permitAll'])
	def notificacionMPPavoni(){
		try {
			if (params.topic == "payment")
				pagoCuentaService.recibirNotificacionMP(params.pagoId, params.id , 1, false)
			else if (params.type == "payment")
				pagoCuentaService.recibirNotificacionMP(params.pagoId,params.data?.id , 1, false)
		}
		catch(Exception e) {
			println """


					Error en notificación MercadoPago: ${e}


					"""
		}
		respond([:], status: 200)
		render "OK"
	}


	def ajaxGetPagoCuentas(String filter){
		def pagoCuentas = pagoCuentaService.listPagoCuenta(filter,null)
		render pagoCuentas as JSON
	}
	
	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetPagoCuentasPorCuenta(String filter, Long cuentaId){
		def pagoCuentas = pagoCuentaService.listPagoCuenta(filter, cuentaId)
		render pagoCuentas as JSON
	}
	
	def ajaxGetPagoCuenta(Long id) {
		def pagoCuenta = pagoCuentaService.getPagoCuenta(id)
		render pagoCuenta as JSON
	}
}
