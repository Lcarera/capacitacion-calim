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

@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
class FacturaVentaController {
	def facturaVentaService
	def cuentaService
	AccessRulesService accessRulesService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def list(String ano, String mes, String cuentaId) {
		def hoy = new LocalDate()
		
		def cuenta = cuentaId ?: cuentaService.getPrimeraCuentaId()

		[ano: ano ?: hoy.toString("YYYY"), mes: mes ?: hoy.toString("MM"), cuentaId: cuenta]
	}
	
	def create() {
		def command = facturaVentaService.createFacturaVentaCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[facturaVentaInstance: command]
	}
	def save(FacturaVentaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.FacturaVenta.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [facturaVentaInstance: command])
			return
		}
		
		def facturaVentaInstance
		
		try {
			facturaVentaInstance = facturaVentaService.saveFacturaVenta(command)
			flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.FacturaVenta.label', default: 'FacturaVenta'), facturaVentaInstance.toString()], encodeAs:'none')
			redirect(action: "list")
			return
		}catch (e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error	= message(code: 'zifras.FacturaVenta.save.error', default: 'Error al intentar salvar la Factura')
		}catch (java.lang.AssertionError e){
        	flash.error = e.message.split("finerror")[0] // El error se logea en el service
        }
		render(view: "create", model: [facturaVentaInstance: command])
	}

	def show(Long id) {
		def facturaVentaInstance = facturaVentaService.getFacturaVenta(id)
		if (!facturaVentaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.FacturaVenta.label', default: 'FacturaVenta'), id])
			redirect(action: "list")
			return
		}

		[facturaVentaInstance: facturaVentaInstance]
	}

	def edit(Long id) {
		def facturaVentaInstance = facturaVentaService.getFacturaVentaCommand(id)
		if (!facturaVentaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.FacturaVenta.label', default: 'FacturaVenta'), id])
			redirect(action: "list")
			return
		}

		[facturaVentaInstance: facturaVentaInstance]
	}

	def update(FacturaVentaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [facturaVentaInstance: command])
			return
		}
		
		def facturaVentaInstance
		
		try {
			facturaVentaInstance = facturaVentaService.updateFacturaVenta(command)
		}
		catch (ValidationException e){
			facturaVentaInstance.errors = e.errors
			render(view: "edit", model: [facturaVentaInstance: facturaVentaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [facturaVentaInstance: facturaVentaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.FacturaVenta.label', default: 'FacturaVenta'), facturaVentaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def facturaVentaInstance = facturaVentaService.getFacturaVenta(id)
		if (!facturaVentaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.FacturaVenta.label', default: 'FacturaVenta'), id])
			redirect(action: "list")
			return
		}
		def numero = facturaVentaInstance.numero

		try {
			facturaVentaService.deleteFacturaVenta(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.FacturaVenta.label', default: 'FacturaVenta'), numero], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.FacturaVenta.label', default: 'FacturaVenta'), numero], encodeAs:'none')
			redirect(action: "list")
		}
	}

	@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_CUENTA','ROLE_ADMIN_PY','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
	def ajaxGetFacturasVenta(String mes, String ano, Long cuentaId){
		def facturasVenta = facturaVentaService.listFacturaVenta(mes, ano, cuentaId)
		render facturasVenta as JSON
	}
	
	@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_CUENTA','ROLE_ADMIN_PY','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
	def ajaxGetAllFacturasVenta(Long cuentaId){
		def facturasVenta = facturaVentaService.listAllFacturaVenta(cuentaId)
		render facturasVenta as JSON
	}

	def ajaxGetFacturaVenta(Long id) {
		def facturaVenta = facturaVentaService.getFacturaVenta(id)
		render facturaVenta as JSON
	}

	@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_CUENTA','ROLE_ADMIN_PY','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
	def ajaxGetConceptos(String filter){
		def conceptos = facturaVentaService.listConceptos(filter)
		render conceptos as JSON
	}
	
	def ajaxGetConcepto(Long id) {
		def concepto = facturaVentaService.getConcepto(id)
		render concepto as JSON
	}

	@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_CUENTA','ROLE_RIDER_PY','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
	def ajaxGetAlicuotas(String filter){
		def alicuotas = facturaVentaService.listAlicuotas(filter)
		render alicuotas as JSON
	}

	@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_CUENTA','ROLE_RIDER_PY','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
	def ajaxGetAlicuota(Long id) {
		def alicuota = facturaVentaService.getAlicuota(id)
		render alicuota as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_CUENTA', 'ROLE_SM','ROLE_SE','ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetListItems(Long facturaId){
		def items = facturaVentaService.listItems(facturaId)
		render items as JSON
	}

	@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_CUENTA','ROLE_RIDER_PY','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
	def ajaxGetIdiomas(){
		def idiomas = facturaVentaService.listIdiomas()
		render idiomas as JSON
	}

	@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_CUENTA','ROLE_RIDER_PY','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
	def ajaxGetMonedas(){
		def monedas = facturaVentaService.listMonedas()
		render monedas as JSON
	}
	@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_CUENTA','ROLE_RIDER_PY','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
	def ajaxGetCodigosPaises(){
		def paises = facturaVentaService.listPaises()
		render paises as JSON
	}
	@Secured(['ROLE_USER','ROLE_ADMIN','ROLE_CUENTA','ROLE_RIDER_PY','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuitPaises(){
		def cuitPaises = facturaVentaService.listCuitPaises()
		render cuitPaises as JSON
	}

	def ajaxGetUnidadMedida(Long unidadId){
		def unidad = facturaVentaService.getUnidadMedida(unidadId)
		render unidad as JSON
	}
	
	def ajaxGetUnidadesMedida(String filter){
		def unidades = facturaVentaService.listUnidadesMedida(filter)
		render unidades as JSON
	}

	def bajarCiti(String mes, String ano, Long cuentaId){
		try {
			File archivo = new File("temp")
			archivo << facturaVentaService.listFacturaVenta(mes, ano, cuentaId).collect{[it.fecha,it.neto,it.iva,it.total].join(" , ")}.join("\n")

			response.setContentType("application/octet-stream")
			response.setHeader("Content-disposition", "filename=CitiVentas${ano}${mes}")
			response.outputStream << archivo.bytes
			archivo.delete()
		}
		catch(Exception e) {
			flash.error = "No pudieron descargarse las facturas."
			redirect(action:'list', params: [ano: ano, mes: mes, cuentaId: cuentaId])
		}
	}

	def ajaxObtenerFacturacionAnual(Long cuentaId, Integer ano){ 
		render facturaVentaService.obtenerFacturacionAnual(cuentaId, ano) as JSON
	}
}
