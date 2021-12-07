package com.zifras.servicio

import com.zifras.AccessRulesService
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.joda.time.LocalDate

@Secured(['ROLE_ADMIN', 'ROLE_COBRANZA','ROLE_VENTAS','ROLE_SM','ROLE_SE','IS_AUTHENTICATED_FULLY'])
class ServicioController {
	def servicioService

	def index() {
		redirect(action:'list')
	}

	def actualizar(){
		def servViejo
		LocalDate hoy = new LocalDate()
		println "Actualizando servicios..."
		Servicio.findAllByMensualAndSubcodigo(true, "2020_09").each{ serv ->
			println "... ${serv.codigo} - ${serv.nombre}"
			Servicio nuevoServicio = Servicio.findByCodigoAndSubcodigo(serv.codigo, "2021_03")
			serv.items.findAll{it.vigente}.each{
				println "...... Cuenta ${it.cuenta}"
				servViejo = it
				try {
					servViejo.with{
						def fechaVieja = fechaBaja
						fechaBaja = hoy
						save(flush:false)
						new ItemServicioMensual(
							vendedor: vendedor,
							responsable: responsable,
							servicio: nuevoServicio,
							cuenta: cuenta,
							descuento: descuento,
							fechaAlta: hoy,
							debitoAutomatico: debitoAutomatico,
							fechaBaja: fechaVieja
						).save(flush:false)
					println ".........Ok."
					}
				}
				catch(Exception e) {
					println ".........Error."
				}
			}
		}
		println "Fin de la actualización."
		servViejo.save(flush:true)
	}
	@Secured(['ROLE_ADMIN', 'ROLE_COBRANZA', 'IS_AUTHENTICATED_FULLY'])
	def list() {}

	@Secured(['ROLE_ADMIN', 'ROLE_COBRANZA', 'IS_AUTHENTICATED_FULLY'])
	def cobranza(String id, String filtrar,String mes, String ano) {
		if (!id)
			id = "mensual"
		LocalDate fecha = (mes && ano) ? new LocalDate(ano + "-" + mes + "-01") : new LocalDate().minusMonths(1).withDayOfMonth(1)
		[tipo:id, filtro: filtrar, mes: fecha.toString("MM"), mesString: fecha.toString("MMMM",new java.util.Locale('ES')).capitalize(), ano: fecha.toString("yyyy")]
	}

	def cobranzaEspecial(){
		LocalDate fecha = new LocalDate().minusMonths(1).withDayOfMonth(1)

		render(view:'cobranza', model:[tipo:'especial',filtro:null,mes:fecha.toString("MM"), mesString: fecha.toString("MMMM",new java.util.Locale('ES')).capitalize(), ano: fecha.toString("yyyy")])
	}

	def recordatorio1(){
		Integer diasDesdeFactura = new Integer(new LocalDate().toString('dd')) - 10
		servicioService.enviarRecordatoriosMensuales(1,diasDesdeFactura)
		flash.message = "Se enviaron los recordatorios"
		redirect(controller:'facturaCuenta', action:'list')
	}

	def create() { [servicioInstance: servicioService.createServicioCommand()] }

	def edit(Long id) {
		def servicioInstance = servicioService.getServicioCommand(id)
		if (!servicioInstance) {
			flash.error = "No se encontró servicio con ID $id"
			redirect(action: "list")
			return
		}
		[servicioInstance: servicioInstance]
	}

	def save(ServicioCommand command) { saveUpdate(command,true) }

	def delete(Long id) {
		try {
			String nombre = servicioService.deleteServicio(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.servicio.Servicio.label', default: 'Servicio'), nombre], encodeAs:'none')
			redirect(action: "list")
			return
		}
        catch(java.lang.AssertionError e){
        	flash.error = e.message.split("finerror")[0]
			redirect(controller:'cuenta', action:'listAbonos')
			return
        }
		catch (e) {
			flash.error = "El servicio no pudo ser eliminado"
			redirect(action: "edit", id: id)
			return
		}
	}

	def update(ServicioCommand command) { saveUpdate(command,false) }

	private saveUpdate(ServicioCommand command, Boolean hacerSave) {
		try {
			assert !command.hasErrors() : "Los siguientes campos contienen errores: " + command.errors.allErrors.collect { it.field } + "finerror"

			if (hacerSave) {
				def servicioInstance = servicioService.saveServicio(command)
				flash.message = "Servicio $servicioInstance creado."
			}
			else {
				def servicioInstance = servicioService.updateServicio(command)
				flash.message = "Servicio $servicioInstance actualizado."
			}
			redirect(action: "list")
			return
		}
		catch (ValidationException e) {
			command.errors = e.errores
			flash.error = "Los siguientes campos contienen errores: " + e.errors.allErrors.collect { it.field }
		}
		catch(java.lang.AssertionError e){
			flash.error = e.message.split("finerror")[0]
		}
		catch (e) {
			log.error(e.message)
			flash.error = "Error al intentar ${hacerSave ? 'guardar' : 'actualizar'} el servicio."
		}
		render(view: "${hacerSave ? 'create' : 'edit'}", model: [servicioInstance: command])
	}

	def ajaxGetServiciosEspeciales() { render servicioService.listServiciosEspeciales() as JSON }

	def ajaxGetServiciosMensuales() { render servicioService.listServiciosMensuales() as JSON }

	def ajaxGetServiciosPorId() { render servicioService.getServicios(params.'ids[]') as JSON }

	def ajaxGetList() { render servicioService.listServicios() as JSON }

	def ajaxGetListCobranza(String filtro, String mes, String ano, Boolean mensual) { render servicioService.listCobranza(filtro, new LocalDate(ano + "-" + mes + "-01"), mensual) as JSON }

	def ajaxGetEspecialesDeCuenta(Long cuentaId) { render servicioService.listEspecialesCuenta(cuentaId) as JSON }

	def ajaxGetMensualesDeCuenta(Long cuentaId) { render servicioService.listMensualesCuenta(cuentaId) as JSON }

	def ajaxAdherirEspecial(Double importe, Integer cuotas, String comentarioServicio, String fecha, Long cuentaId) {
		def servicios = JSON.parse(params.servicios)
		def salida = [:]
		try {
			servicioService.adherirEspecial(servicios,importe, cuotas, comentarioServicio, fecha, cuentaId)	
		}
		catch(Exception e) {
			log.error(e.message)
			salida['error'] = "Ocurrió un error adhiriendo el servicio."
		}
		
		render salida as JSON
	}

	def ajaxAdherirMensual(Long servicioId, Double descuento , Long cuentaId, int periodos, Boolean debitoAutomatico, String fechaAlta) {
		def salida = [:]
		try {
			servicioService.adherirMensual(servicioId, descuento , cuentaId, periodos, debitoAutomatico, fechaAlta)?.with{
				salida['linkPago'] = it
			}
		}
		catch(Exception e) {
			log.error(e.message)
			salida['error'] = "Ocurrió un error adhiriendo el servicio."
		}
		catch(java.lang.AssertionError e){
			salida['error'] = e.message.split("finerror")[0]
		}
		
		render salida as JSON
	}

	def deleteItemServicio(Long id){
		try {
			def cuentaId = servicioService.deleteItemServicio(id)
			flash.message = "Servicio eliminado de la cuenta"
			redirect(controller:'cuenta', action:'servicios', id:cuentaId)
		}
		catch(e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error = "No pudo desasociarse el servicio"
			redirect(controller:'cuenta', action:'listAbonos')
		}
		
	}

	def actualizarSubcodigos(){
		render servicioService.actualizarSubcodigos("2021_03","2021_09") as JSON
	}

	def adelantar(Long id){
		try {
			def factura = servicioService.adelantarCuotaEspecial(id)
			flash.message = "Factura generada, se envió al cliente por mail."
			redirect(controller:'facturaCuenta', action:'show', id:factura.id)
		}
		catch(Exception e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error = "Error generando factura."
			redirect(controller:'cuenta', action:'show')
		}
	}
}
