package com.zifras

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.zifras.LocalidadService
import com.zifras.LocalidadCommand
import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM','ROLE_SE', 'ROLE_COBRANZA', 'ROLE_VENTAS', 'IS_AUTHENTICATED_FULLY'])
class LocalidadController {
	def localidadService
	
    def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}
	
	def create() {
		def command = localidadService.createLocalidadCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[localidadInstance: command]
	}

	def save(LocalidadCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.Localidad.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [localidadInstance: command])
			return
		}
		
		def localidadInstance
		
		try {
			localidadInstance = localidadService.saveLocalidad(command)
		}catch (e){
			flash.error	= message(code: 'zifras.Localidad.save.error', default: 'Error al intentar salvar la localidad')
			render(view: "create", model: [localidadInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.Localidad.label', default: 'Localidad'), localidadInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def localidadInstance = localidadService.getLocalidad(id)
		if (!localidadInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.Localidad.label', default: 'Localidad'), id])
			redirect(action: "list")
			return
		}

		[localidadInstance: localidadInstance]
	}

	def edit(Long id) {
		def localidadInstance = localidadService.getLocalidadCommand(id)
		if (!localidadInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.Localidad.label', default: 'Localidad'), id])
			redirect(action: "list")
			return
		}

		[localidadInstance: localidadInstance]
	}

	def update(LocalidadCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [localidadInstance: command])
			return
		}
		
		def localidadInstance
		
		try {
			localidadInstance = localidadService.updateLocalidad(command)
		}
		catch (ValidationException e){
			localidadInstance.errors = e.errors
			render(view: "edit", model: [localidadInstance: localidadInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [localidadInstance: localidadInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.Localidad.label', default: 'Localidad'), localidadInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def localidadInstance = localidadService.getLocalidad(id)
		if (!localidadInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.Localidad.label', default: 'Localidad'), id])
			redirect(action: "list")
			return
		}
		String nombre = localidadInstance.nombre

		try {
			localidadService.deleteLocalidad(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.Localidad.label', default: 'Localidad'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.Localidad.label', default: 'Localidad'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	def ajaxGetLocalidades(Long provinciaId, String filter){
		def localidades = localidadService.listLocalidad(provinciaId, filter)
		render localidades as JSON
	}
	
	def ajaxGetLocalidad(Long id) {
		def localidad = localidadService.getLocalidad(id)
		render localidad as JSON
	}
}
