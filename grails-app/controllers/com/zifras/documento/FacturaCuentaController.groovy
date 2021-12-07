package com.zifras.documento

import com.zifras.afip.AfipService

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import yakworks.reports.ReportFormat
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.joda.time.LocalDate
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.web.multipart.MultipartFile
import grails.util.Environment
import grails.gorm.multitenancy.Tenants
import java.util.GregorianCalendar
import java.util.Calendar
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS', 'ROLE_COBRANZA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class FacturaCuentaController {
	def afipService
	def facturaCuentaService

	def index() {
		redirect(action: "list", params: params)
	}

	def facturaChris(){
		facturaCuentaService.generarPorItemsServicio([com.zifras.cuenta.Cuenta.get(472970).servicioActivo])
		redirect(action:'list')
	}

	def create() {
		def command = facturaCuentaService.createFacturaCuentaCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[facturaCuentaInstance: command]
	}

	def save(FacturaCuentaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.documento.FacturaCuentaCommand.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [facturaCuentaInstance: command])
			return
		}
		
		def facturaCuentaInstance
		
		try {
			def archivo = request.getFile('archivo')
			facturaCuentaInstance = facturaCuentaService.saveFacturaCuenta(command,archivo)
		}catch (e){
			log.error(e.message)
			flash.error	= message(code: 'zifras.documento.FacturaCuenta.save.error', default: 'Error al intentar salvar la Factura')
			render(view: "create", model: [facturaCuentaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.documento.FacturaCuenta.label', default: 'Factura'), facturaCuentaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	@Secured(['permitAll'])
	def bajarPdf(Long id){
		Tenants.withId(2) {
			String format = ReportFormat.get(response.format)?:ReportFormat.PDF
			def factura = FacturaCuenta.get(id)
			def dataList = []
			def parametros = [:]

			Double subtotal = 0
			parametros = cargaDatosPdf(parametros, id)
			factura.items.each {
				def precio = factura.mensual ? it.getPrecio(it.fechaAlta) : it.precio
				def neto = precio / 1.21
			  	FacturaCuentaItemReport item = new FacturaCuentaItemReport()
			  	item.codigo = it.servicio.codigo
			  	item.descripcion = it.servicio.nombre
			  	item.cantidad = "1"
			  	item.unidad = "-"
			  	item.neto = currencyFormat(neto)
			  	item.precioUnitario = currencyFormat(neto)
			  	item.iva = "21%"
			  	item.total = currencyFormat(precio)

			 	subtotal += neto
			  	dataList.push(item)
			}

			def pathImagenes

			if (Environment.current == Environment.PRODUCTION)
	        	pathImagenes = servletContext.getRealPath("/assets") + '/'
	        else
				pathImagenes = java.nio.file.FileSystems.default.getPath("grails-app/assets/images").toAbsolutePath().toString() + '/'

			parametros['imagenesPath'] = pathImagenes

			parametros['subtotal'] = '$ ' + currencyFormat(subtotal)

			Map rptModel = [format:format, data:dataList, "ReportTitle":"Controller Report"]
			rptModel = rptModel + parametros

			if(factura.cuenta.condicionIva?.nombre == "Responsable inscripto")
				render(view:"facturaCuentaA.jrxml", model:rptModel)
			else
				render(view:"facturaCuenta.jrxml", model:rptModel)
		}
	}

	@Secured(['ROLE_CUENTA'])
	def cargaDatosPdf(parametros, Long id){

		def factura = FacturaCuenta.get(id)
		def diaFinalizacionMes = factura.mensual ? calcularDiaFinalizacionMes(factura.movimiento.fechaHora) : 0

		parametros['facturaONota'] = factura.notaCredito ? "Nota de Crédito" : "Factura"
		parametros['numero'] = factura.notaCredito?.numero ?: factura.numero ?: "-"
		parametros['fecha'] = factura.notaCredito ? factura.notaCredito.fechaHora.toString("dd/MM/YYYY") : factura.fechaHora.toString("dd/MM/YYYY")
		parametros['letraFactura'] = factura.cuenta.condicionIva?.nombre == "Monotributista" ? "B" : "A"  //VER COMO SE DETERMINA 
		parametros['letraCodigo'] = "A" //VER COMO SE DETERMINA
		parametros['razonSocialCliente'] = factura.cuenta.with{razonSocial != email ? razonSocial : nombreApellido} ?: "No especificada"
		parametros['domicilioCliente'] = factura.cuenta.domicilioFiscal?.toString() ?: "No especificado"
		parametros['cuitCliente'] = factura.cuenta.cuit
		parametros['cuitCalim'] = "30716783916" 
		parametros['razonSocialCalim'] = "Calim Digital SA" 
		parametros['domicilioCalim'] = "Bartolomé Mitre 3517 Piso:6 Depto:A CABA" 
		parametros['ingresosBrutosCalim'] = "CM 30716783916"
		parametros['condicionIvaCalim'] = "IVA Inscripto" 
		parametros['inicioActividadesCalim'] = "02/2020" 
		parametros['puntoVenta'] = "00003"

		parametros['periodoDesde'] = factura.mensual ? factura.movimiento.fechaHora.toString("01/MM/YYYY") : factura.movimiento.fechaHora.toString("dd/MM/YYYY")
		parametros['periodoHasta'] = factura.mensual ? factura.movimiento.fechaHora.toString(diaFinalizacionMes+"/MM/YYYY") : factura.movimiento.fechaHora.toString("dd/MM/YYYY")

		parametros['ivaValor'] = "21%"
		parametros['iva21'] = '$ ' + currencyFormat(factura.importe - factura.importe / 1.21)
		parametros['importeOtrosTributos'] = '$0'
		parametros['importeTotal'] = '$ ' + currencyFormat(factura.importe)

		parametros['cae'] = factura.notaCredito?.cae ? factura.notaCredito?.cae : (factura.cae ?: "-")
		parametros['vencimientoCae'] = factura.notaCredito?.vencimientoCae ?: factura.vencimientoCae?.toString("dd/MM/YYYY") ?: "-"
		return parametros
	}

	private calcularDiaFinalizacionMes(LocalDateTime fecha){
		def date = new LocalDate(fecha.toString().split('T')[0])
		def dia = new Integer(date.toString("dd"))
		def mes = new Integer(date.toString("MM"))
		def ano = new Integer(date.toString("yyyy"))
		Calendar calendar = GregorianCalendar.instance
		calendar.set(ano, mes-1, dia)
		println calendar.getActualMaximum(GregorianCalendar.DAY_OF_MONTH)
		return calendar.getActualMaximum(GregorianCalendar.DAY_OF_MONTH)

	}
	@Secured(['ROLE_CUENTA'])
	def currencyFormat(formatear){

		String patternCurrency = '###,###,##0.00'
		String patternCurrency2 = '###,###,##0.000'
		String pattern = '###,###,###.###'
		DecimalFormat decimalCurencyFormat = new DecimalFormat(patternCurrency)
		DecimalFormat decimalCurencyFormat2 = new DecimalFormat(patternCurrency2)
		DecimalFormat decimalFormat = new DecimalFormat(pattern)
		
		DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
		otherSymbols.setDecimalSeparator(',' as char)
		otherSymbols.setGroupingSeparator('.' as char)
		decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)
		decimalFormat.setDecimalFormatSymbols(otherSymbols)

		return decimalCurencyFormat.format(formatear)
	}
	def updateCae(Long facturaId, String vencimiento, String numero, String cae){
		try {
			facturaCuentaService.updateCae(facturaId,org.joda.time.format.DateTimeFormat.forPattern("dd/MM/yyyy").parseLocalDate(vencimiento),numero,cae)
			flash.message = "CAE Actualizado"
		}
		catch(e) {
			log.error(e.message)
			flash.error = "No pudo guardarse el CAE"
		}
		redirect(action:"show", id:facturaId)
	}

	def list() {
		def hoy = new LocalDate()//.minusMonths(1)
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}

	@Secured(['ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
	def listUsuario() {
	}
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_COBRANZA', 'ROLE_VENTAS','ROLE_SE','ROLE_SM','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def show(Long id, String path) {
		def facturaCuentaInstance = facturaCuentaService.getFacturaCuenta(id)
		if (!facturaCuentaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.FacturaCuenta.label', default: 'Factura'), id])
			redirect(action: "list")
			return
		}

		[facturaCuentaInstance: facturaCuentaInstance, path:path]
	}

	def edit(Long id) {
		redirect(action:'show', params:['id':id,'path':'documentos'])
	}

	def solicitarCae(Long id) {
		try {
			afipService.solicitarCaeCalim(id)
			flash.message = "CAE obtenido correctamente"
		}
		catch(java.lang.AssertionError e) {
			flash.error = e.message.split("finerror")[0]
		}
		redirect(action:'show', id:id)
	}

	def update(FacturaCuentaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [facturaCuentaInstance: command])
			return
		}
		
		def facturaCuentaInstance
		
		try {
			def archivo = request.getFile('archivo')
			facturaCuentaInstance = facturaCuentaService.updateFacturaCuenta(command,archivo)
		}
		catch (ValidationException e){
			facturaCuentaInstance.errors = e.errors
			render(view: "edit", model: [facturaCuentaInstance: facturaCuentaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [facturaCuentaInstance: facturaCuentaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.documento.FacturaCuenta.label', default: 'Factura'), facturaCuentaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def facturaCuentaInstance = facturaCuentaService.getFacturaCuenta(id)
		if (!facturaCuentaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.FacturaCuenta.label', default: 'Factura'), id])
			redirect(action: "list")
			return
		}
		String descripcion = facturaCuentaInstance.descripcion

		try {
			facturaCuentaService.deleteFacturaCuenta(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.documento.FacturaCuenta.label', default: 'Factura'), descripcion], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.documento.FacturaCuenta.label', default: 'Factura'), descripcion], encodeAs:'none')
			redirect(action: "list")
		}
	}

	def listSolicitudesPago(){
			def hoy = new LocalDate()//.minusMonths(1)
			def ano = hoy.toString("YYYY")
			def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes, hoy:hoy]
	}
	
	def ajaxGetFacturasCuenta(String filter, String mes, String ano){
		def facturaCuentas = facturaCuentaService.listFacturaCuenta(filter,null, mes, ano)
		render facturaCuentas as JSON
	}

	def ajaxGetSolicitudesPago(String filter, String mes, String ano){
		def solicitudes = facturaCuentaService.listSolicitudesPago(filter, mes, ano)
		render solicitudes as JSON
	}
	
	def ajaxGetFacturasCuentasPorCuenta(String filter, Long cuentaId){
		def facturaCuentas = facturaCuentaService.listFacturaCuenta(filter, cuentaId)
		render facturaCuentas as JSON
	}

	def ajaxGetFacturaCuenta(Long id) {
		def facturaCuenta = facturaCuentaService.getFacturaCuenta(id)
		render facturaCuenta as JSON
	}
	
}
