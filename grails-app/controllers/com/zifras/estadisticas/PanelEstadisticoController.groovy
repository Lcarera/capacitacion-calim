package com.zifras.estadisticas

import com.zifras.AccessRulesService
import com.zifras.Estado
import com.zifras.importacion.LogMercadoPago

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_VENTAS','ROLE_SM','ROLE_COBRANZA', 'IS_AUTHENTICATED_FULLY'])
class PanelEstadisticoController {
	def panelEstadisticoService
	AccessRulesService accessRulesService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def panel() {
		def fecha = new LocalDate()
		def resultadosServiciosEspeciales
		def resultadosServiciosMensuales 
		def vendedores
		def resultadosRegistros = [:]
		def resultadosTiendaNube = [:]
		def resultadosApp = [:]
		def resultadosDelivery = [:]
		def resultadosRegistrosTiendaNube
		def resultadosRegistrosDelivery
		def resultadosContactos
		def cantidadDeUsuariosConApp
		def cantidadDeUsuariosTiendaNube
		def cantidadDeUsuariosDelivery
		def cantidadDeUsuariosActivos
		def periodoAnual = panelEstadisticoService.periodoAnual(fecha)

		resultadosServiciosEspeciales = datosServiciosEspeciales() as JSON
		resultadosServiciosMensuales = datosServiciosMensuales() as JSON
		vendedores = vendedoresCalim()
		resultadosRegistros = datosRegistro() as JSON
		resultadosRegistrosTiendaNube = datosRegistroTiendaNube() as JSON
		resultadosRegistrosDelivery = datosRegistroDelivery() as JSON
		resultadosContactos = datosContactos() as JSON
		cantidadDeUsuariosConApp = cantidadUsuariosApp()
		cantidadDeUsuariosTiendaNube = cantidadUsuariosTiendaNube()
		cantidadDeUsuariosDelivery = cantidadUsuariosDelivery()
		cantidadDeUsuariosActivos = cantidadUsuariosActivos()

		/*resultadosApp = datosApp() as JSON
		resultadosTiendaNube = datosTiendaNube()
		resultadosDelivery = datosDelivery()*/

		[
		datosServiciosMensuales:resultadosServiciosMensuales, 
		periodoAnual:periodoAnual, 
		datosServiciosEspeciales:resultadosServiciosEspeciales, 
		vendedores:vendedores, 
		nombresVendedores:vendedores.collect{it.nombre},
		datosRegistro:resultadosRegistros,
		datosRegistroTiendaNube: resultadosRegistrosTiendaNube,
		datosRegistroDelivery: resultadosRegistrosDelivery,
		datosContactos: resultadosContactos,
		cantidadUsuariosConApp:cantidadDeUsuariosConApp,
		cantidadUsuariosTiendaNube:cantidadDeUsuariosTiendaNube,
		cantidadUsuariosDelivery:cantidadDeUsuariosDelivery,
		cantidadUsuariosActivos: cantidadDeUsuariosActivos
		]
	}

	def consultasWeb(String dia, String mes, String ano) {
		def fecha
		if(mes)
			fecha = new LocalDate(ano +"-"+mes+"-"+dia)
		else {
			fecha = new LocalDate()
			ano = fecha.toString("YYYY")
			mes = fecha.toString("MM")
			dia = fecha.toString("dd")
		}
		
		def consultasMensuales = datosConsultasWebMensuales(fecha) as JSON
		def consultasDiarias = datosConsultasWebDiarias(fecha) as JSON //TODO borrar el minusdays
		[ano: ano,
		 mes: mes,
		 dia: dia,
		 consultasMensuales: consultasMensuales,
		 consultasDiarias: consultasDiarias,
		 periodoAnual: panelEstadisticoService.periodoAnual(fecha)
		]
	}
	
	def datosServiciosEspeciales() {
		def resultado = panelEstadisticoService.datosServicios(new LocalDate(),false)
		return resultado
	}

	def datosServiciosMensuales() {
		def resultado = panelEstadisticoService.datosServicios(new LocalDate(),true)
		return resultado
	}

	def datosRegistro() {
		def resultado = panelEstadisticoService.datosRegistro(new LocalDate(),"general")
		return resultado
	}

	def datosRegistroTiendaNube() {
		def resultado = panelEstadisticoService.datosRegistro(new LocalDate(), "tiendaNube")
		return resultado
	}

	def datosRegistroDelivery() {
		def resultado = panelEstadisticoService.datosRegistro(new LocalDate(), "delivery")
		return resultado
	}

	def datosContactos() {
		def resultado = panelEstadisticoService.datosContactos(new LocalDate())
		return resultado
	}

	private datosConsultasWebMensuales(LocalDate hoy){
		return panelEstadisticoService.datosConsultasWeb(true,hoy)
	}

	private datosConsultasWebDiarias(LocalDate hoy){
		return panelEstadisticoService.datosConsultasWeb(false,hoy)
	}

	def vendedoresCalim(){
		return panelEstadisticoService.vendedoresCalim()
	}

	def cantidadUsuariosTiendaNube() {
		def resultado = panelEstadisticoService.cantidadUsuariosTiendaNube()
		return resultado
	}

	def cantidadUsuariosApp(){
		def resultado = panelEstadisticoService.cantidadUsuariosConApp()
		return resultado
	}

	def cantidadUsuariosDelivery(){
		def resultado = panelEstadisticoService.cantidadUsuariosDelivery()
		return resultado
	}

	def cantidadUsuariosActivos(){
		def resultado = panelEstadisticoService.cantidadUsuariosActivos()
		return resultado
	}

	def cancelarLog(Long id){
		LogMercadoPago log = LogMercadoPago.get(id)
		log.estado = Estado.findByNombre("Expirado")
		log.save(flush:true)
		redirect(action:'gerencia', params:[mes:log.fecha.toString("MM"), ano:log.fecha.toString("yyyy")])
	}

	def gerencia(String mes, String ano, Boolean forzarViewDatos){
		LocalDate fecha = mes && ano ? new LocalDate(ano + '-' + mes + '-01') : new LocalDate().withDayOfMonth(1).minusMonths(1)
		LogMercadoPago log = LogMercadoPago.findByFechaAndEstado(fecha, Estado.findByNombre('Activo')) ?: (forzarViewDatos ? new LogMercadoPago() : null)
		[mes:fecha.toString("MM"), ano:fecha.toString("yyyy"), log: log]
	}

	def clientes(Integer id){
		if (!id)
			id = 11
		[cantMeses:id]
	}

	def ajaxGetListGerencia(String mes, String ano){
		render panelEstadisticoService.listadoGerencia(new LocalDate(ano + '-' + mes + '-01')) as JSON
	}

	def ajaxGetDatosVendedor(String mes, String ano){
		def mail = accessRulesService.getCurrentUser()?.username
		render panelEstadisticoService.datosVendedor(mail, new LocalDate(ano + '-' + mes + '-01')) as JSON
	}

	def ajaxGetPeriodoAnual(){
		def hoy = new LocalDate()
		def periodo = panelEstadisticoService.periodoAnual(hoy)

		render periodo as JSON
	}

	def ajaxGetConsultasWeb(String mes, String ano){
		render panelEstadisticoService.listConsultasWeb(new LocalDate(ano + '-' + mes + '-01')) as JSON
	}

	def ajaxGetBajasMensuales(Integer cantMeses){
		render panelEstadisticoService.bajasMensuales(cantMeses) as JSON
	}

	def ajaxGetClientesMensuales(Integer cantMeses){
		render panelEstadisticoService.clientesMensuales(cantMeses) as JSON
	}
}