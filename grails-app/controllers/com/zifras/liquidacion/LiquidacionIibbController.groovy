package com.zifras.liquidacion

import grails.plugin.springsecurity.annotation.Secured;

import com.zifras.liquidacion.LiquidacionIIBBService
import com.zifras.liquidacion.LiquidacionIIBBCommand
import com.zifras.liquidacion.LiquidacionIIBB
import com.zifras.cuenta.CuentaService

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

import grails.converters.JSON

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import com.zifras.AccessRulesService



import com.zifras.AccessRulesService;
import com.zifras.Estado

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class LiquidacionIibbController {
	def liquidacionIIBBService
	def cuentaService
	AccessRulesService accessRulesService
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def index() {
		redirect(action: "list", params: params)
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def list() {
		def hoy = new LocalDate().minusMonths(1)
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def listSinAlicuota() {
		def hoy = new LocalDate().minusMonths(1)
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def listRetencionSircreb() {
		def hoy = new LocalDate()
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def listNota() {
		def hoy = new LocalDate()
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def listLiquidacionMasiva() {
		def hoy = new LocalDate().minusMonths(1)
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def listLiquidacionNotificacion() {
		def hoy = (new LocalDate()).minusMonths(1)
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def create(LiquidacionIIBBCommand command) {
		def liquidacionIIBBInstance = liquidacionIIBBService.createLiquidacionIIBBCommand(command)
		
		[liquidacionIIBBInstance: liquidacionIIBBInstance]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def save(LiquidacionIIBBCommand command) {
		if (command.hasErrors()) {
			flash.error = "Campos inválidos: " + command.errors.allErrors.collect{it.field}.join(", ")
			render(view: "create", model: [liquidacionIIBBInstance: command])
			return
		}
		
		def liquidacionIIBBInstance
		
		try {
			liquidacionIIBBInstance = liquidacionIIBBService.saveLiquidacionIIBB(command)
		}catch (e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error	= message(code: 'zifras.liquidacion.LiquidacionIIBB.save.error', default: 'Error al intentar salvar la liquidación')
			render(view: "create", model: [liquidacionIIBBInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.liquidacion.LiquidacionIIBB.label', default: 'LiquidacionIIBB'), liquidacionIIBBInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def show(Long id) {
		def liquidacionIIBBInstance = liquidacionIIBBService.getLiquidacionIIBB(id)
		if (!liquidacionIIBBInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.LiquidacionIIBB.label', default: 'LiquidacionIIBB'), id])
			redirect(action: "list")
			return
		}

		[liquidacionIIBBInstance: liquidacionIIBBInstance, fechaHoy: new LocalDate().toString("dd/MM/YYYY")]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def edit(Long id) {
		def liquidacionIIBBInstance = liquidacionIIBBService.getLiquidacionIIBBCommand(id)
		if (!liquidacionIIBBInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.LiquidacionIIBB.label', default: 'LiquidacionIIBB'), id])
			redirect(action: "list")
			return
		}
		def usuario = accessRulesService.getCurrentUser().username
		
		if(!["cgzechner@gmail.com","epavoni2000@gmail.com","franco@calim.com.ar"].contains(usuario)){

			if (liquidacionIIBBInstance.estadoId == 162875) {
				flash.error = "No puede editarse una liquidacion ya autorizada."
				redirect(action: "show", id: id)
				return
			}
			if (liquidacionIIBBInstance.estadoId == 162874) {
				flash.error = "No puede editarse una liquidacion ya presentada."
				redirect(action: "show", id: id)
				return
			}
		}
		[liquidacionIIBBInstance: liquidacionIIBBInstance]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def update(LiquidacionIIBBCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [liquidacionIIBBInstance: command])
			return
		}
		
		def liquidacionIIBBInstance
		
		try {
			liquidacionIIBBInstance = liquidacionIIBBService.updateLiquidacionIIBB(command)
		}
		catch (ValidationException e){
			liquidacionIIBBInstance.errors = e.errors
			render(view: "edit", model: [liquidacionIIBBInstance: liquidacionIIBBInstance])
			return
		}
		catch (e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error = e.toString()
			render(view: "edit", model: [liquidacionIIBBInstance: liquidacionIIBBInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.liquidacion.LiquidacionIIBB.label', default: 'LiquidacionIIBB'), liquidacionIIBBInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def liquidacionAutomatica(String mes, String ano, Long cuentaId) {
		try {
			liquidacionIIBBService.liquidacionAutomatica(mes,ano,cuentaId)
			flash.message = "Liquidaciones recalculadas para el ${mes}/$ano"
		}
		catch(Exception e) {
			log.error(e.message)
			flash.error = "Ocurrió un error generando las liquidaciones."
		}
		
		redirect(controller:'cuenta', action: "show", id:cuentaId)
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def delete(Long id) {
		def liquidacionIIBBInstance = liquidacionIIBBService.getLiquidacionIIBB(id)
		if (!liquidacionIIBBInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.LiquidacionIIBB.label', default: 'LiquidacionIIBB'), id])
			redirect(action: "list")
			return
		}
		String nombre = liquidacionIIBBInstance.cuenta.razonSocial

		try {
			liquidacionIIBBService.deleteLiquidacionIIBB(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.liquidacion.LiquidacionIIBB.label', default: 'LiquidacionIIBB'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.liquidacion.LiquidacionIIBB.label', default: 'LiquidacionIIBB'), nombre], encodeAs:'none')
			redirect(action: "show", id: id)
		}
	}
	
	//Llamar a esta funcion con el mes de liquidacion a borrar
	//Por ejemplo 2019-03-01
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def deleteRepetidos(String mes) {
	def fecha = new LocalDate(mes)
		try {
			def cantidadBorrados = liquidacionIIBBService.deleteLiquidacionIIBBRepetidas(fecha)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.liquidacion.LiquidacionIIBB.label', default: 'LiquidacionIIBB'), cantidadBorrados], encodeAs:'none')
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.liquidacion.LiquidacionIIBB.label', default: 'LiquidacionIIBB'), ''], encodeAs:'none')
		}
		
		redirect(action: "list")
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_SE','ROLE_VENTAS','ROLE_COBRANZA','ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLiquidacionesIibbList(String mes, String ano){
		def liquidaciones = liquidacionIIBBService.getLiquidacionIIBBList(mes, ano)
		render liquidaciones as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'ROLE_LECTURA','ROLE_VENTAS','ROLE_SE','ROLE_COBRANZA','ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLiquidacionesIibbCuentaList(Long cuentaId, String ano){
		def liquidaciones = liquidacionIIBBService.getLiquidacionesPorCuenta(cuentaId, ano)
		render liquidaciones as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxModificarRetencionSircreb(LiquidacionIIBBCommand command){
		def liquidacion = liquidacionIIBBService.updateRetencionSircreb(command)
		render liquidacion as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxModificarNota(LiquidacionIIBBCommand command){
		def liquidacion = liquidacionIIBBService.updateNota(command)
		render liquidacion as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetAlicuotas(LiquidacionIIBBCommand command){
		def liquidacion = liquidacionIIBBService.getLiquidacionIIBBAlicuotas(command)
		render liquidacion as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxLiquidacionMasiva(LiquidacionIvaMasivaCommand command){
		def liquidaciones = liquidacionIIBBService.liquidacionMasiva(command)
		render liquidaciones as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxLiquidacionAutomaticaMasiva(LiquidacionIvaMasivaCommand command){
		def liquidaciones =  []
		command.cuentasIds.split(",").each{
			liquidaciones += liquidacionIIBBService.liquidacionAutomatica(command.mes, command.ano, new Long(it))
		}
		render liquidaciones as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxEnviarNotificaciones(LiquidacionIvaMasivaCommand command){
		def liquidaciones = liquidacionIIBBService.enviarNotificaciones(command)
		render liquidaciones as JSON
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def ajaxDelete(Long id) {
		def liquidacionIIBBInstance = liquidacionIIBBService.getLiquidacionIIBB(id)
		if (!liquidacionIIBBInstance) {
			return
		}

		try {
			liquidacionIIBBService.deleteLiquidacionIIBB(id)
		}
		catch (e) {
		}
		render new LiquidacionIIBBCommand() as JSON
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLiquidacionesSinAlicuota(Integer mes, Integer ano) {
		render liquidacionIIBBService.listSinAlicuota(new LocalDate(ano,mes,1)) as JSON
	}
}
