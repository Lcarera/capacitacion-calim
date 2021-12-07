package com.zifras

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.zifras.ProvinciaService
import com.zifras.ProvinciaCommand
import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER','ROLE_CUENTA','ROLE_SM','ROLE_SE', 'ROLE_COBRANZA', 'ROLE_VENTAS', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class ProvinciaController {
	def provinciaService
	
    def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}
	
	def create() {
		def command = provinciaService.createProvinciaCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[provinciaInstance: command]
	}

	def save(ProvinciaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.Provincia.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [provinciaInstance: command])
			return
		}
		
		def provinciaInstance
		
		try {
			provinciaInstance = provinciaService.saveProvincia(command)
		}catch (e){
			flash.error	= message(code: 'zifras.Provincia.save.error', default: 'Error al intentar salvar la provincia')
			render(view: "create", model: [provinciaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.Provincia.label', default: 'Provincia'), provinciaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def provinciaInstance = provinciaService.getProvincia(id)
		if (!provinciaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.Provincia.label', default: 'Provincia'), id])
			redirect(action: "list")
			return
		}

		[provinciaInstance: provinciaInstance]
	}

	def edit(Long id) {
		def provinciaInstance = provinciaService.getProvinciaCommand(id)
		if (!provinciaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.Provincia.label', default: 'Provincia'), id])
			redirect(action: "list")
			return
		}

		[provinciaInstance: provinciaInstance]
	}

	def update(ProvinciaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [provinciaInstance: command])
			return
		}
		
		def provinciaInstance
		
		try {
			provinciaInstance = provinciaService.updateProvincia(command)
		}
		catch (ValidationException e){
			provinciaInstance.errors = e.errors
			render(view: "edit", model: [provinciaInstance: provinciaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [provinciaInstance: provinciaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.Provincia.label', default: 'Provincia'), provinciaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def provinciaInstance = provinciaService.getProvincia(id)
		if (!provinciaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.Provincia.label', default: 'Provincia'), id])
			redirect(action: "list")
			return
		}
		String nombre = provinciaInstance.nombre

		try {
			provinciaService.deleteProvincia(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.Provincia.label', default: 'Provincia'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.Provincia.label', default: 'Provincia'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	def ajaxGetProvincias(){
		def provincias = provinciaService.listProvincia()
		render provincias as JSON
	}
	
	def ajaxGetProvincia(Long id) {
		def provincia = provinciaService.getProvincia(id)
		render provincia as JSON
	}
}
