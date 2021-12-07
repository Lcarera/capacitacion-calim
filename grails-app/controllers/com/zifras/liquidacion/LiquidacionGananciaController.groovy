package com.zifras.liquidacion

import grails.plugin.springsecurity.annotation.Secured;

import com.zifras.liquidacion.LiquidacionGananciaService
import com.zifras.liquidacion.LiquidacionGananciaCommand
import com.zifras.liquidacion.LiquidacionGanancia
import com.zifras.cuenta.CuentaService

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

import grails.converters.JSON

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

import com.zifras.AccessRulesService
import com.zifras.Estado

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class LiquidacionGananciaController {
	def liquidacionGananciaService
	def cuentaService
	AccessRulesService accessRulesService
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def index() {
		redirect(action: "list", params: params)
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def list() {
		def hoy = new LocalDate()
		def anoPasado = hoy.minusYears(1)
		
		def ano = anoPasado.toString("YYYY")
		[ano: ano]
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def listRetencionPercepcionAnticipo() {
		def hoy = new LocalDate()
		def anoPasado = hoy.minusYears(1)
		
		def ano = anoPasado.toString("YYYY")
		[ano: ano]
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def listNota() {
		def hoy = new LocalDate()
		def anoPasado = hoy.minusYears(1)
		
		def ano = anoPasado.toString("YYYY")
		[ano: ano]
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def create(LiquidacionGananciaCommand command) {
		def liquidacionGananciaInstance = liquidacionGananciaService.createLiquidacionGananciaCommand(command)
		
		[liquidacionGananciaInstance: liquidacionGananciaInstance]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def save(LiquidacionGananciaCommand command) {
		if (command.hasErrors()) {
			flash.error = "Los siguientes campos contienen errores: " + command.errors.allErrors.collect{it.field}
			render(view: "create", model: [liquidacionGananciaInstance: command])
			return
		}
		try {
			def liquidacionGananciaInstance = liquidacionGananciaService.saveLiquidacionGanancia(command)
			flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.liquidacion.LiquidacionGanancia.label', default: 'LiquidacionGanancia'), liquidacionGananciaInstance.toString()], encodeAs:'none')
			redirect(action: "list")
			return
		}catch (ValidationException e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			command.errors = e.errors
			flash.error = "Los siguientes campos contienen errores: " + e.errors.allErrors.collect{it.field}
		}
		catch (e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error	= message(code: 'zifras.liquidacion.LiquidacionGanancia.save.error', default: 'Error al intentar salvar la liquidación')
		}
		render(view: "create", model: [liquidacionGananciaInstance: command])
	}

	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'ROLE_CUENTA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def show(Long id) {
		def liquidacionGananciaInstance = liquidacionGananciaService.getLiquidacionGanancia(id)
		if (!liquidacionGananciaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.LiquidacionGanancia.label', default: 'LiquidacionGanancia'), id])
			redirect(action: "list")
			return
		}

		[liquidacionGananciaInstance: liquidacionGananciaInstance, fechaHoy: new LocalDate().toString("dd/MM/YYYY")]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def edit(Long id) {
		def liquidacionGananciaInstance = liquidacionGananciaService.getLiquidacionGananciaCommand(id)
		if (!liquidacionGananciaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.LiquidacionGanancia.label', default: 'LiquidacionGanancia'), id])
			redirect(action: "list")
			return
		}

		[liquidacionGananciaInstance: liquidacionGananciaInstance]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def update(LiquidacionGananciaCommand command) {
		if (command.hasErrors()) {
			flash.error = "Los siguientes campos contienen errores: " + command.errors.allErrors.collect{it.field}
			render(view: "edit", model: [liquidacionGananciaInstance: command])
			return
		}
		try {
			def liquidacionGananciaInstance = liquidacionGananciaService.updateLiquidacionGanancia(command)
			flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.liquidacion.LiquidacionGanancia.label', default: 'LiquidacionGanancia'), liquidacionGananciaInstance.toString()], encodeAs:'none')
			redirect(action: "list")
			return
		}catch (ValidationException e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			command.errors = e.errors
			flash.error = "Los siguientes campos contienen errores: " + e.errors.allErrors.collect{it.field}
		}
		catch (e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error	= message(code: 'zifras.liquidacion.LiquidacionGanancia.save.error', default: 'Error al intentar salvar la liquidación')
		}
		render(view: "edit", model: [liquidacionGananciaInstance: command])
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def delete(Long id) {
		def liquidacionGananciaInstance = liquidacionGananciaService.getLiquidacionGanancia(id)
		if (!liquidacionGananciaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.LiquidacionGanancia.label', default: 'LiquidacionGanancia'), id])
			redirect(action: "list")
			return
		}
		String nombre = liquidacionGananciaInstance.cuenta.razonSocial

		try {
			liquidacionGananciaService.deleteLiquidacionGanancia(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.liquidacion.LiquidacionGanancia.label', default: 'LiquidacionGanancia'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.liquidacion.LiquidacionGanancia.label', default: 'LiquidacionGanancia'), nombre], encodeAs:'none')
			redirect(action: "show", id: id)
		}
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_SE','ROLE_VENTAS','ROLE_COBRANZA','ROLE_CUENTA','ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLiquidacionesGananciaList(String ano){
		def liquidaciones = liquidacionGananciaService.getLiquidacionGananciaList(ano)
		render liquidaciones as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_SE','ROLE_VENTAS','ROLE_COBRANZA','ROLE_CUENTA','ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLiquidacionesGananciaCuentaList(Long cuentaId){
		def liquidaciones = liquidacionGananciaService.getLiquidacionesPorCuenta(cuentaId)
		render liquidaciones as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_SE','ROLE_VENTAS','ROLE_COBRANZA','ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetDeduccionesParientesList(Long cuentaId, String ano){
		def deduccionesParientesList = liquidacionGananciaService.getDeduccionesParientesList(cuentaId, ano)
		render deduccionesParientesList as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_SE','ROLE_VENTAS','ROLE_COBRANZA','ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetGastosDeduccionesList(Long cuentaId, String ano){
		def gastosDeduccionesList = liquidacionGananciaService.getGastosDeduccionesList(cuentaId, ano)
		render gastosDeduccionesList as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetPatrimoniosList(Long cuentaId, String ano){
		def patrimoniosList = liquidacionGananciaService.getPatrimoniosList(cuentaId, ano)
		render patrimoniosList as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxModificarRetencionPercepcionAnticipo(LiquidacionGananciaCommand command){
		def liquidacion = liquidacionGananciaService.updateRetencionPercepcionAnticipo(command)
		render liquidacion as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxModificarNota(LiquidacionGananciaCommand command){
		def liquidacion = liquidacionGananciaService.updateNota(command)
		render liquidacion as JSON
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def ajaxDelete(Long id) {
		def liquidacionGananciaInstance = liquidacionGananciaService.getLiquidacionGanancia(id)
		if (!liquidacionGananciaInstance) {
			return
		}

		try {
			liquidacionGananciaService.deleteLiquidacionGanancia(id)
		}
		catch (e) {
		}
		render new LiquidacionGananciaCommand() as JSON
	}
}