package com.zifras.cuenta

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.zifras.cuenta.CondicionIvaService
import com.zifras.cuenta.CondicionIvaCommand

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class CondicionIvaController {
	def condicionIvaService

    def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}
	
	def create() {
		def command = condicionIvaService.createCondicionIvaCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[condicionIvaInstance: command]
	}

	def save(CondicionIvaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.cuenta.CondicionIva.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [condicionIvaInstance: command])
			return
		}
		
		def condicionIvaInstance
		
		try {
			condicionIvaInstance = condicionIvaService.saveCondicionIva(command)
		}catch (e){
			flash.error	= message(code: 'zifras.cuenta.CondicionIva.save.error', default: 'Error al intentar salvar la condición IVA')
			render(view: "create", model: [condicionIvaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.cuenta.CondicionIva.label', default: 'Condicion IVA'), condicionIvaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def condicionIvaInstance = condicionIvaService.getCondicionIva(id)
		if (!condicionIvaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.CondicionIva.label', default: 'Condicion IVA'), id])
			redirect(action: "list")
			return
		}

		[condicionIvaInstance: condicionIvaInstance]
	}

	def edit(Long id) {
		def condicionIvaInstance = condicionIvaService.getCondicionIvaCommand(id)
		if (!condicionIvaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.CondicionIva.label', default: 'Condicion IVA'), id])
			redirect(action: "list")
			return
		}

		[condicionIvaInstance: condicionIvaInstance]
	}

	def update(CondicionIvaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [condicionIvaInstance: command])
			return
		}
		
		def condicionIvaInstance
		
		try {
			condicionIvaInstance = condicionIvaService.updateCondicionIva(command)
		}
		catch (ValidationException e){
			condicionIvaInstance.errors = e.errors
			render(view: "edit", model: [condicionIvaInstance: condicionIvaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [condicionIvaInstance: condicionIvaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.cuenta.CondicionIva.label', default: 'Condicion IVA'), condicionIvaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def condicionIvaInstance = condicionIvaService.getCondicionIva(id)
		if (!condicionIvaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.CondicionIva.label', default: 'Condicion IVA'), id])
			redirect(action: "list")
			return
		}
		String nombre = condicionIvaInstance.nombre

		try {
			condicionIvaService.deleteCondicionIva(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.cuenta.CondicionIva.label', default: 'Condicion IVA'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.cuenta.CondicionIva.label', default: 'Condicion IVA'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	def ajaxGetCondicionesIVA(){
		def condicionesIva = condicionIvaService.listCondicionIva()
		render condicionesIva as JSON
	}
	
	def ajaxGetCondicionIVA(Long id) {
		def condicionIva = condicionIvaService.getCondicionIva(id)
		render condicionIva as JSON
	}
}
