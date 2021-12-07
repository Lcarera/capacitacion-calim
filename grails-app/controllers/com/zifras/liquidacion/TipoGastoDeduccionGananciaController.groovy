package com.zifras.liquidacion

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.zifras.liquidacion.TipoGastoDeduccionGananciaService
import com.zifras.liquidacion.TipoGastoDeduccionGananciaCommand

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class GastoDeduccionGananciaController {
	def tipoGastoDeduccionGananciaService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}
	
	def create() {
		def command = tipoGastoDeduccionGananciaService.createTipoGastoDeduccionGananciaCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[tipoGastoDeduccionGananciaInstance: command]
	}

	def save(TipoGastoDeduccionGananciaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.TipoGastoDeduccionGanancia.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [tipoGastoDeduccionGananciaInstance: command])
			return
		}
		
		def tipoGastoDeduccionGananciaInstance
		
		try {
			tipoGastoDeduccionGananciaInstance = tipoGastoDeduccionGananciaService.saveTipoGastoDeduccionGanancia(command)
		}catch (e){
			flash.error	= message(code: 'zifras.GastoDeduccionGanancia.save.error', default: 'Error al intentar salvar el tipo de Gasto/Deduccion de Ganancia')
			render(view: "create", model: [tipoGastoDeduccionGananciaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.TipoGastoDeduccionGanancia.label', default: 'Tipo'), tipoGastoDeduccionGananciaInstance.nombre], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def tipoGastoDeduccionGananciaInstance = tipoGastoDeduccionGananciaService.getTipoGastoDeduccionGanancia(id)
		if (!tipoGastoDeduccionGananciaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.TipoGastoDeduccionGanancia.label', default: 'Tipo'), id])
			redirect(action: "list")
			return
		}

		[tipoGastoDeduccionGananciaInstance: tipoGastoDeduccionGananciaInstance]
	}

	def edit(Long id) {
		def tipoGastoDeduccionGananciaInstance = tipoGastoDeduccionGananciaService.getTipoGastoDeduccionGananciaCommand(id)
		if (!tipoGastoDeduccionGananciaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.TipoGastoDeduccionGanancia.label', default: 'Tipo'), id])
			redirect(action: "list")
			return
		}

		[tipoGastoDeduccionGananciaInstance: tipoGastoDeduccionGananciaInstance]
	}

	def update(TipoGastoDeduccionGananciaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [tipoGastoDeduccionGananciaInstance: command])
			return
		}
		
		def tipoGastoDeduccionGananciaInstance
		
		try {
			tipoGastoDeduccionGananciaInstance = tipoGastoDeduccionGananciaService.updateTipoGastoDeduccionGanancia(command)
		}
		catch (ValidationException e){
			tipoGastoDeduccionGananciaInstance.errors = e.errors
			render(view: "edit", model: [tipoGastoDeduccionGananciaInstance: tipoGastoDeduccionGananciaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [tipoGastoDeduccionGananciaInstance: tipoGastoDeduccionGananciaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.TipoGastoDeduccionGanancia.label', default: 'Tipo'), tipoGastoDeduccionGananciaInstance.nombre], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def tipoGastoDeduccionGananciaInstance = tipoGastoDeduccionGananciaService.getTipoGastoDeduccionGanancia(id)
		if (!tipoGastoDeduccionGananciaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.TipoGastoDeduccionGanancia.label', default: 'Tipo'), id])
			redirect(action: "list")
			return
		}
		String nombre = tipoGastoDeduccionGananciaInstance.nombre

		try {
			tipoGastoDeduccionGananciaService.deleteTipoGastoDeduccionGanancia(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.TipoGastoDeduccionGanancia.label', default: 'Tipo'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.TipoGastoDeduccionGanancia.label', default: 'Tipo'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetTipoGastoDeduccionGanancias(String filter){
		def tipoGastoDeduccionGanancias = tipoGastoDeduccionGananciaService.listTipoGastoDeduccionGanancia(filter)
		render tipoGastoDeduccionGanancias as JSON
	}
	
	def ajaxGetTipoGastoDeduccionGanancia(Long id) {
		def tipoGastoDeduccionGanancia = tipoGastoDeduccionGananciaService.getTipoGastoDeduccionGanancia(id)
		render tipoGastoDeduccionGanancia as JSON
	}
}
