package com.zifras.liquidacion

import com.zifras.liquidacion.MontoConceptoDeducibleGananciaService
import com.zifras.liquidacion.MontoConceptoDeducibleGananciaCommand

import grails.plugin.springsecurity.annotation.Secured
import grails.converters.JSON
import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException
import org.joda.time.LocalDate


@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class MontoConceptoDeducibleGananciaController {
	def montoConceptoDeducibleGananciaService
	
    def index() {
		redirect(action: "list", params: params)
	}

	def list() {
		def hoy = new LocalDate()
		def anoPasado = hoy.minusYears(1)
		
		def ano = anoPasado.toString("YYYY")
		
		[ano: ano]
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def create() {
		def montoConceptoDeducibleGananciaInstance = montoConceptoDeducibleGananciaService.createMontoConceptoDeducibleGananciaCommand()
		
		[montoConceptoDeducibleGananciaInstance: montoConceptoDeducibleGananciaInstance]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def save(MontoConceptoDeducibleGananciaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.liquidacion.MontoConceptoDeducibleGanancia.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [montoConceptoDeducibleGananciaInstance: command])
			return
		}
		
		def montoConceptoDeducibleGananciaInstance
		
		try {
			montoConceptoDeducibleGananciaInstance = montoConceptoDeducibleGananciaService.saveMontoConceptoDeducibleGanancia(command)
		}catch (e){
			flash.error	= message(code: 'zifras.liquidacion.MontoConceptoDeducibleGanancia.save.error', default: 'Error al intentar salvar el monto')
			render(view: "create", model: [montoConceptoDeducibleGananciaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.liquidacion.MontoConceptoDeducibleGanancia.label', default: 'MontoConceptoDeducibleGanancia'), montoConceptoDeducibleGananciaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def edit(Long id) {
		def montoConceptoDeducibleGananciaInstance = montoConceptoDeducibleGananciaService.getMontoConceptoDeducibleGananciaCommand(id)
		if (!montoConceptoDeducibleGananciaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.MontoConceptoDeducibleGanancia.label', default: 'MontoConceptoDeducibleGanancia'), id])
			redirect(action: "list")
			return
		}

		[montoConceptoDeducibleGananciaInstance: montoConceptoDeducibleGananciaInstance]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def update(MontoConceptoDeducibleGananciaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [montoConceptoDeducibleGananciaInstance: command])
			return
		}
		
		def montoConceptoDeducibleGananciaInstance
		
		try {
			montoConceptoDeducibleGananciaInstance = montoConceptoDeducibleGananciaService.updateMontoConceptoDeducibleGanancia(command)
		}
		catch (ValidationException e){
			montoConceptoDeducibleGananciaInstance.errors = e.errors
			render(view: "edit", model: [montoConceptoDeducibleGananciaInstance: montoConceptoDeducibleGananciaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [montoConceptoDeducibleGananciaInstance: montoConceptoDeducibleGananciaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.liquidacion.MontoConceptoDeducibleGanancia.label', default: 'Rango'), montoConceptoDeducibleGananciaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def delete(Long id) {
		def montoConceptoDeducibleGananciaInstance = montoConceptoDeducibleGananciaService.getMontoConceptoDeducibleGanancia(id)
		if (!montoConceptoDeducibleGananciaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.MontoConceptoDeducibleGanancia.label', default: 'Monto'), id])
			redirect(action: "list")
			return
		}
		String nombre = montoConceptoDeducibleGananciaInstance.toString()

		try {
			montoConceptoDeducibleGananciaService.deleteMontoConceptoDeducibleGanancia(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.liquidacion.MontoConceptoDeducibleGanancia.label', default: 'Monto'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.liquidacion.MontoConceptoDeducibleGanancia.label', default: 'Monto'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetMontoConceptoDeducibleGananciaList(String ano){
		def montos = montoConceptoDeducibleGananciaService.listMontoConceptoDeducibleGanancia(ano)
		render montos as JSON
	}
}
