package com.zifras.facturacion
import com.zifras.cuenta.Cuenta
// import com.zifras.cuenta.CuentaService

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import com.zifras.AccessRulesService

// import grails.validation.ValidationException

// import org.springframework.dao.DataIntegrityViolationException

/*import static org.springframework.http.HttpStatus.*
import static org.springframework.http.HttpMethod.*
import grails.rest.**/

@Secured(['ROLE_CUENTA', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class FacturaCompraUsuarioController {
	def facturaCompraService
	AccessRulesService accessRulesService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
		def hoy = new LocalDate()
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		def cuenta = accessRulesService.getCurrentUser().cuenta?.id
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
		redirect(controller:"facturaVentaUsuario", action: "list")
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
	
	def ajaxGetFacturasCompra(String mes, String ano, Long cuentaId){
		def facturasCompra = facturaCompraService.listFacturaCompra(mes, ano, cuentaId)
		render facturasCompra as JSON
	}
	
	def ajaxGetFacturaCompra(Long id) {
		def facturaCompra = facturaCompraService.getFacturaCompra(id)
		render facturaCompra as JSON
	}
}
