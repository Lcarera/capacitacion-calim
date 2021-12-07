package com.zifras.facturacion
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import com.zifras.AccessRulesService

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

/*import static org.springframework.http.HttpStatus.*
import static org.springframework.http.HttpMethod.*
import grails.rest.**/

@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
class FacturaCompraController {
	def facturaCompraService
	def cuentaService
	AccessRulesService accessRulesService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
		def hoy = new LocalDate()

		def ano = params.ano ?: hoy.toString("YYYY")
		def mes = params.mes ?: hoy.toString("MM")
		def cuenta = params.cuentaId ?: cuentaService.getPrimeraCuentaId()

		[ano: ano, mes: mes, cuentaId: cuenta]
	}
	
	def create(Long cuentaId) {
		def command = facturaCompraService.createFacturaCompraCommand()
		command.cuentaId = cuentaId
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[facturaCompraInstance: command]
	}
	def save(FacturaCompraCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.FacturaCompra.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [facturaCompraInstance: command])
			return
		}
		
		def facturaCompraInstance
		
		try {
			facturaCompraInstance = facturaCompraService.saveFacturaCompra(command)
		}catch (e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error	= message(code: 'zifras.FacturaCompra.save.error', default: 'Error al intentar salvar la Factura')
			render(view: "create", model: [facturaCompraInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.FacturaCompra.label', default: 'FacturaCompra'), facturaCompraInstance.toString()], encodeAs:'none')
		redirect(action: "list", params:['cuentaId':facturaCompraInstance?.cuenta?.id])
	}

	def show(Long id) {
		def facturaCompraInstance = facturaCompraService.getFacturaCompra(id)
		if (!facturaCompraInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.FacturaCompra.label', default: 'FacturaCompra'), id])
			redirect(action: "list")
			return
		}

		[facturaCompraInstance: facturaCompraInstance]
	}

	def edit(Long id) {
		def facturaCompraInstance = facturaCompraService.getFacturaCompraCommand(id)
		if (!facturaCompraInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.FacturaCompra.label', default: 'FacturaCompra'), id])
			redirect(action: "list")
			return
		}

		[facturaCompraInstance: facturaCompraInstance]
	}

	def update(FacturaCompraCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [facturaCompraInstance: command])
			return
		}
		
		def facturaCompraInstance
		
		try {
			facturaCompraInstance = facturaCompraService.updateFacturaCompra(command)
		}
		catch (ValidationException e){
			facturaCompraInstance.errors = e.errors
			render(view: "edit", model: [facturaCompraInstance: facturaCompraInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [facturaCompraInstance: facturaCompraInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.FacturaCompra.label', default: 'FacturaCompra'), facturaCompraInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def facturaCompraInstance = facturaCompraService.getFacturaCompra(id)
		if (!facturaCompraInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.FacturaCompra.label', default: 'FacturaCompra'), id])
			redirect(action: "list")
			return
		}
		def numero = facturaCompraInstance.numero

		try {
			facturaCompraService.deleteFacturaCompra(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.FacturaCompra.label', default: 'FacturaCompra'), numero], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.FacturaCompra.label', default: 'FacturaCompra'), numero], encodeAs:'none')
			redirect(action: "list")
		}
	}

	@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_CUENTA','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
	def ajaxGetFacturasCompra(String mes, String ano, Long cuentaId){
		def facturasCompra = facturaCompraService.listFacturaCompra(mes, ano, cuentaId)
		render facturasCompra as JSON
	}
	
	def ajaxGetFacturaCompra(Long id) {
		def facturaCompra = facturaCompraService.getFacturaCompra(id)
		render facturaCompra as JSON
	}

	def bajarCiti(String mes, String ano, Long cuentaId){
		try {
			File archivo = new File("temp")
			archivo << facturaCompraService.listFacturaCompra(mes, ano, cuentaId).collect{[it.fecha,it.netoGravado,it.iva,it.total].join(" , ")}.join("\n")

			response.setContentType("application/octet-stream")
			response.setHeader("Content-disposition", "filename=CitiCompras${ano}${mes}")
			response.outputStream << archivo.bytes
			archivo.delete()
		}
		catch(Exception e) {
			flash.error = "No pudieron descargarse las facturas."
			redirect(action:'list', params: [ano: ano, mes: mes, cuentaId: cuentaId])
		}
	}
}
