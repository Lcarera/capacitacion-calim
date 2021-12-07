package com.zifras.importacion

import com.zifras.AccessRulesService
import com.zifras.Estado
import com.zifras.cuenta.Cuenta
import com.zifras.facturacion.Proforma

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured;
import grails.validation.ValidationException
import java.io.File
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class ImportacionController {
	def importacionService
	AccessRulesService accessRulesService

	def index() {
		redirect(action: "panel", params: params)
	}

	def list() {
	}

	def panel() {
		LocalDate hoy = new LocalDate()
		Cuenta primeraCuenta = Cuenta.first()
		[ano: hoy.toString("YYYY"), mes:hoy.toString("MM"), cuentaId: primeraCuenta.id]
	}


	def importacionMasivaFacturasPorCuenta(Long cuentaIdModal, String compraString){
		boolean compra = (compraString=="true")

		def resultado
		try {
			resultado = importacionService.importacionMasivaFacturas(params.'files[]', cuentaIdModal, compra, true)
		}
		catch(Exception e) {
			flash.error = (e.message == "cuenta") ? "La cuenta es inválida." : "Ocurrió un error al importar las facturas de " + (compra ? "compra" : "venta") + "."
			redirect(controller: ((compra) ? "facturaCompra" : "facturaVenta"), action: "list")
		}
		render(view: "resultados", model: [command: resultado, facturas:true])
	}

	def importacionMasivaFacturas(Long cuentaId){
		def resultado
		try {
			resultado = importacionService.importacionMasivaFacturas(params.'files[]', cuentaId, null, true)
		}
		catch(Exception e) {
			flash.error = "Ocurrió un error al importar las facturas."
			redirect(action: "panel")
		}

		render(view: "resultados", model: [command: resultado, facturas:true])
	}

	def importacionMasivaRetPer(Long cuentaIdModal){
		def resultado
		try {
			resultado = importacionService.importacionMasivaRetPer(params.'files[]', cuentaIdModal)
		}
		catch(Exception e) {
			flash.error = (e.message == "cuenta") ? "La cuenta es inválida." : "Ocurrió un error al importar las retenciones o percepciones."
			redirect(action: "panel")
		}

		render(view: "resultados", model: [command: resultado, facturas:false])
	}

	def importacionMasivaDebitoAutomatico(){
		def resultado
		try {
			resultado = importacionService.importacionMasivaDebitoAutomatico(params.'files[]')
		}
		catch(Exception e) {
			flash.error = "Ocurrió un error al importar los débitos."
			redirect(action: "panel")
		}

		render(view: "resultados", model: [command: resultado, facturas:true])
	}

	@Secured(['ROLE_ADMIN_PY'])
	def importacionProformas(){
		def resultado = [:]
			resultado['data'] = importacionService.importacionProformas(params.'file', params.fechaInicio)
			resultado['ok'] = "Las proformas se importaron correctamente!"

		render resultado as JSON
	}

	@Secured(['ROLE_ADMIN_PY'])
	def importacionRiders(){
		def salida = [:]
		try {
			def errores = importacionService.importarCuentasRider(params.'file')
			if (errores.size() == 0)
				salida['ok'] = "Todo ok"
			else
				salida['errores'] = errores
		}
		catch(Exception e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			salida['error'] = "No pudo imporse el archivo debido a un error."
		}
		render salida as JSON
	}
	def importarObrasSociales(){
		render (view:"importarObrasSociales")
	}
	def importacionObrasSociales(){
		def resultado = [:]
			try{
				resultado['data'] = importacionService.importacionObrasSociales(params.'file')
			 	render "Las obras se importaron correctamente!"
			}
			catch(e){
				render "Error"
			}
	}

	def importacionActividades(){
		def resultado
		try {
			resultado = importacionService.importacionActividades(params.'files[]')
		}
		catch(Exception e) {
			flash.error = e.message
			redirect(controller:"actividad", action: "list")
		}
		redirect(controller:"actividad", action: "list")
	}

	def importacionAlicuotas(){
		def resultado
		try {
			resultado = importacionService.importacionAlicuotas(params.'files[]')
		}
		catch(Exception e) {
			flash.error = e.message
			redirect(controller:"alicuotaProvinciaActividadIIBB", action: "list")
		}
		redirect(controller:"alicuotaProvinciaActividadIIBB", action: "list")
	}

	def ajaxGetLogGerencia(Long id){
		render importacionService.getLogGerencia(id) as JSON
	}

	def ajaxGerenciaMP(String mes, String ano){
		LogMercadoPago salida
		String mensajeError
		LocalDate fecha = new LocalDate(ano + '-' + mes + '-01')
		try {
			salida = importacionService.importarDumpMP(fecha, request.getFile('archivo'))
		}
		catch(Exception e) {
			mensajeError = "No pudo imporse el archivo debido a un error."
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		catch(java.lang.AssertionError e){
			mensajeError = e.message.split("finerror")[0]
		}
		if (mensajeError)
			salida = new LogMercadoPago(estado: Estado.findByNombre("Error"),fecha: fecha,fechaHora: new LocalDateTime(),responsable: accessRulesService.currentUser.username,mensajeError: mensajeError).save(flush:true, failOnError:true)
		render salida as JSON 
	}

	@Secured(['ROLE_RIDER_PY', 'IS_AUTHENTICATED_FULLY'])
	def pdfPedidosYa(Long proformaId){
		def salida = [:]
		def archivo = request.getFile('archivo')
		try {
			importacionService.parsearPdfPedidosYa(archivo, proformaId)
			salida['ok'] = "ok"
		}
		catch(Exception e) {
			salida['error'] = "Ocurrió un error inesperado importando el archivo. Por favor, comuníquese con soporte."
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")	
		}
		catch(java.lang.AssertionError e){
			salida['error'] = e.message.split("finerror")[0]
		}
		if (salida.error)
			importacionService.guardarArchivo(Proforma.get(proformaId), archivo).with{
				ultimaSubida = new LocalDateTime()
				estado = Proforma.Estados.ERROR
				save(flush:true)
			}
		render salida as JSON
	}

	def ajusteConvenio(Integer convenioMes, Integer convenioAno, Long cuentaId){ 
		LocalDate fecha = new LocalDate(convenioAno,convenioMes,1)
		try {
			importacionService.ajusteConvenio(request.getFile('convenioArchivo'), fecha, cuentaId)
			flash.message = "Liquidación ajustada por archivo"
		}
		catch(Exception e) {
			flash.error = "Error subiendo archivo"
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		catch(java.lang.AssertionError e){
			flash.error = e.message.split("finerror")[0]
		}
		redirect(controller:'cuenta',action:'show',id:cuentaId)
	}

	def ajaxImportar(Boolean retenciones, Long cuentaId){
		if (retenciones)
			render importacionService.importacionMasivaRetPer(params.'files[]', cuentaId) as JSON
		else
			render importacionService.importacionMasivaFacturas(params.'files[]', cuentaId, null, true) as JSON
	}

	def ajaxImportarDebitos(){
		render importacionService.importacionMasivaDebitoAutomatico(params.'files[]') as JSON
	}

	def ajaxImportarVeps(){
		render importacionService.importacionMasivaVeps(params.'files[]') as JSON
	}

	def ajaxImportarGeneral(Long cuentaId){
		// TODO: Implementar
		render importacionService.importarRetPerFactura(params.'files[]', cuentaId) as JSON
	}

	@Secured(['ROLE_CUENTA'])
	def ajaxImportarFrenteDni(){
		render importacionService.importacionFoto("fotoFrenteDni",request.getFile('fotoFrenteDni[]')) as JSON
	}

	@Secured(['ROLE_CUENTA'])
	def ajaxImportarDorsoDni(){
		render importacionService.importacionFoto("fotoDorsoDni",request.getFile('fotoDorsoDni[]')) as JSON
	}

	@Secured(['ROLE_CUENTA'])
	def ajaxImportarSelfie(){
		render importacionService.importacionFoto("fotoSelfie",request.getFile('fotoSelfie[]')) as JSON
	}

	def ajaxGetImportacionesFactura(String filter) {
		def importacionesFactura = importacionService.listImportacionesFactura(filter)
		render importacionesFactura as JSON
	}

	def ajaxGetListaImportaciones(String ano, String mes){
		def lista = importacionService.generarListImportaciones(ano, mes)
		render lista as JSON
	}
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE','ROLE_COBRANZA','ROLE_VENTAS','IS_AUTHENTICATED_FULLY'])
	def ajaxGetListaImportacionesPorCuenta(Long cuentaId, String ano){
		def lista = importacionService.generarListImportacionesPorCuenta(cuentaId, ano)
		render lista as JSON
	}

	def ajaxDeleteLogs(String logsId){
		render importacionService.deleteLogs(logsId) as JSON
	}
}
