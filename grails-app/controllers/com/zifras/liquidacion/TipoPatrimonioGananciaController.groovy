package com.zifras.liquidacion

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.zifras.liquidacion.TipoPatrimonioGananciaService
import com.zifras.liquidacion.TipoPatrimonioGananciaCommand

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class TipoPatrimonioGananciaController {
	def tipoPatrimonioGananciaService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}
	
	def create() {
		def command = tipoPatrimonioGananciaService.createTipoPatrimonioGananciaCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[tipoPatrimonioGananciaInstance: command]
	}

	def save(TipoPatrimonioGananciaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.TipoPatrimonioGanancia.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [tipoPatrimonioGananciaInstance: command])
			return
		}
		
		def tipoPatrimonioGananciaInstance
		
		try {
			tipoPatrimonioGananciaInstance = tipoPatrimonioGananciaService.saveTipoPatrimonioGanancia(command)
		}catch (e){
			flash.error	= message(code: 'zifras.PatrimonioGanancia.save.error', default: 'Error al intentar salvar el tipo de patrimonio de Ganancia')
			render(view: "create", model: [tipoPatrimonioGananciaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.TipoPatrimonioGanancia.label', default: 'Tipo'), tipoPatrimonioGananciaInstance.nombre], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def tipoPatrimonioGananciaInstance = tipoPatrimonioGananciaService.getTipoPatrimonioGanancia(id)
		if (!tipoPatrimonioGananciaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.TipoPatrimonioGanancia.label', default: 'Tipo'), id])
			redirect(action: "list")
			return
		}

		[tipoPatrimonioGananciaInstance: tipoPatrimonioGananciaInstance]
	}

	def edit(Long id) {
		def tipoPatrimonioGananciaInstance = tipoPatrimonioGananciaService.getTipoPatrimonioGananciaCommand(id)
		if (!tipoPatrimonioGananciaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.TipoPatrimonioGanancia.label', default: 'Tipo'), id])
			redirect(action: "list")
			return
		}

		[tipoPatrimonioGananciaInstance: tipoPatrimonioGananciaInstance]
	}

	def update(TipoPatrimonioGananciaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [tipoPatrimonioGananciaInstance: command])
			return
		}
		
		def tipoPatrimonioGananciaInstance
		
		try {
			tipoPatrimonioGananciaInstance = tipoPatrimonioGananciaService.updateTipoPatrimonioGanancia(command)
		}
		catch (ValidationException e){
			tipoPatrimonioGananciaInstance.errors = e.errors
			render(view: "edit", model: [tipoPatrimonioGananciaInstance: tipoPatrimonioGananciaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [tipoPatrimonioGananciaInstance: tipoPatrimonioGananciaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.TipoPatrimonioGanancia.label', default: 'Tipo'), tipoPatrimonioGananciaInstance.nombre], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def tipoPatrimonioGananciaInstance = tipoPatrimonioGananciaService.getTipoPatrimonioGanancia(id)
		if (!tipoPatrimonioGananciaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.TipoPatrimonioGanancia.label', default: 'Tipo'), id])
			redirect(action: "list")
			return
		}
		String nombre = tipoPatrimonioGananciaInstance.nombre

		try {
			tipoPatrimonioGananciaService.deleteTipoPatrimonioGanancia(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.TipoPatrimonioGanancia.label', default: 'Tipo'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.TipoPatrimonioGanancia.label', default: 'Tipo'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	def ajaxGetTipoPatrimonioGanancias(String filter){
		def tipoPatrimonioGanancias = tipoPatrimonioGananciaService.listTipoPatrimonioGanancia(filter)
		render tipoPatrimonioGanancias as JSON
	}
	
	def ajaxGetTipoPatrimonioGanancia(Long id) {
		def tipoPatrimonioGanancia = tipoPatrimonioGananciaService.getTipoPatrimonioGanancia(id)
		render tipoPatrimonioGanancia as JSON
	}
}
