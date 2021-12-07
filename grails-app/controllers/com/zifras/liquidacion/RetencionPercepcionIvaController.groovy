package com.zifras.liquidacion
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import com.zifras.AccessRulesService

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM','IS_AUTHENTICATED_FULLY'])
class RetencionPercepcionIvaController {
	def retencionPercepcionService
	def cuentaService
	AccessRulesService accessRulesService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
		def hoy = new LocalDate()
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		def cuenta = cuentaService.getPrimeraCuentaId()

		[ano: ano, mes: mes, cuentaId: cuenta]
	}
		
	def create() {
		def command = retencionPercepcionService.createRetencionPercepcionCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[retencionPercepcionInstance: command]
	}

	def save(RetencionPercepcionCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.RetencionPercepcion.command.hasErrors', default:'Algún atributo está mal')
			render(view: "create", model: [retencionPercepcionInstance: command])
			return
		}
		
		def retencionPercepcionInstance
		
		try {
			retencionPercepcionInstance = retencionPercepcionService.saveRetencionPercepcion(command, true)
		}catch (e){
			flash.error	= message(code: 'zifras.RetencionPercepcion.save.error', default: 'Error al intentar salvar la Retención/Percepción')
			render(view: "create", model: [retencionPercepcionInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), retencionPercepcionInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def retencionPercepcionInstance = retencionPercepcionService.getRetencionPercepcion(id, true)
		if (!retencionPercepcionInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), id])
			redirect(action: "list")
			return
		}

		[retencionPercepcionInstance: retencionPercepcionInstance]
	}

	def edit(Long id) {
		def retencionPercepcionInstance = retencionPercepcionService.getRetencionPercepcionCommand(id, true)
		if (!retencionPercepcionInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), id])
			redirect(action: "list")
			return
		}
		if (retencionPercepcionInstance.importado) {
			flash.error = "No puede editarse una retención/percepción importada."
			redirect(action: "list")
			return
		}

		[retencionPercepcionInstance: retencionPercepcionInstance]
	}

	def update(RetencionPercepcionCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [retencionPercepcionInstance: command])
			return
		}
		
		def retencionPercepcionInstance
		
		try {
			retencionPercepcionInstance = retencionPercepcionService.updateRetencionPercepcion(command, true)
		}
		catch (ValidationException e){
			command.errors = e.errors
			render(view: "edit", model: [retencionPercepcionInstance: command])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [retencionPercepcionInstance: command])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), retencionPercepcionInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def retencionPercepcionInstance = retencionPercepcionService.getRetencionPercepcion(id, true)
		if (!retencionPercepcionInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), id])
			redirect(action: "list")
			return
		}

		try {
			retencionPercepcionService.deleteRetencionPercepcion(id, true)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), id], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), id], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	def ajaxGetRetencionesPercepciones(String mes, String ano, Long cuentaId){
		render retencionPercepcionService.listRetencionPercepcion(mes, ano, cuentaId, true) as JSON
	}
	
	def ajaxGetRetencionPercepcion(Long id) {
		render retencionPercepcionService.getRetencionPercepcion(id, true) as JSON
	}

	def ajaxCalcularRetencionPercepcionSumatoria(String ano, String mes, Long cuentaId){
		render retencionPercepcionService.calcularRetencionPercepcionSumatoria(cuentaId, mes, ano, true) as JSON
	}
}
