package com.zifras.liquidacion

import com.zifras.liquidacion.RangoImpuestoGananciaService
import com.zifras.liquidacion.RangoImpuestoGananciaCommand

import grails.plugin.springsecurity.annotation.Secured
import grails.converters.JSON
import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException
import org.joda.time.LocalDate


@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class RangoImpuestoGananciaController {
	def rangoImpuestoGananciaService

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
		def rangoImpuestoGananciaInstance = rangoImpuestoGananciaService.createRangoImpuestoGananciaCommand()
		
		[rangoImpuestoGananciaInstance: rangoImpuestoGananciaInstance]
	}

	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def save(RangoImpuestoGananciaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.liquidacion.RangoImpuestoGanancia.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [rangoImpuestoGananciaInstance: command])
			return
		}
		
		def rangoImpuestoGananciaInstance
		
		try {
			rangoImpuestoGananciaInstance = rangoImpuestoGananciaService.saveRangoImpuestoGanancia(command)
		}catch (e){
			flash.error	= message(code: 'zifras.liquidacion.RangoImpuestoGanancia.save.error', default: 'Error al intentar salvar el rango')
			render(view: "create", model: [rangoImpuestoGananciaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.liquidacion.RangoImpuestoGanancia.label', default: 'RangoImpuestoGanancia'), rangoImpuestoGananciaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def edit(Long id) {
		def rangoImpuestoGananciaInstance = rangoImpuestoGananciaService.getRangoImpuestoGananciaCommand(id)
		if (!rangoImpuestoGananciaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.RangoImpuestoGanancia.label', default: 'RangoImpuestoGanancia'), id])
			redirect(action: "list")
			return
		}

		[rangoImpuestoGananciaInstance: rangoImpuestoGananciaInstance]
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def update(RangoImpuestoGananciaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [rangoImpuestoGananciaInstance: command])
			return
		}
		
		def rangoImpuestoGananciaInstance
		
		try {
			rangoImpuestoGananciaInstance = rangoImpuestoGananciaService.updateRangoImpuestoGanancia(command)
		}
		catch (ValidationException e){
			rangoImpuestoGananciaInstance.errors = e.errors
			render(view: "edit", model: [rangoImpuestoGananciaInstance: rangoImpuestoGananciaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [rangoImpuestoGananciaInstance: rangoImpuestoGananciaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.liquidacion.RangoImpuestoGanancia.label', default: 'Rango'), rangoImpuestoGananciaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def delete(Long id) {
		def rangoImpuestoGananciaInstance = rangoImpuestoGananciaService.getRangoImpuestoGanancia(id)
		if (!rangoImpuestoGananciaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.RangoImpuestoGanancia.label', default: 'Rango'), id])
			redirect(action: "list")
			return
		}
		String nombre = rangoImpuestoGananciaInstance.toString()

		try {
			rangoImpuestoGananciaService.deleteRangoImpuestoGanancia(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.liquidacion.RangoImpuestoGanancia.label', default: 'Rango'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.liquidacion.RangoImpuestoGanancia.label', default: 'Rango'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetRangoImpuestoGananciaList(String ano){
		def rangos = rangoImpuestoGananciaService.listRangoImpuestoGanancia(ano)
		render rangos as JSON
	}
}
