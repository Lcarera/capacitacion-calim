package com.zifras.facturacion

import grails.plugin.springsecurity.annotation.Secured;
import com.zifras.afip.AfipService
import grails.converters.JSON

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class PersonaController {
	def personaService
	def afipService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}

	def provinciar(){
		Persona persona
		Persona.findAllByProvinciaIsNull().each{
			persona = it
			if (persona.cuit.length() == 8)
				try {
					def datosAfip = afipService.obtenerDatosProveedor(persona.cuit)
					persona.domicilio = datosAfip.domicilio
					persona.provincia = datosAfip.provincia
					persona.save(flush:false, failOnError:true)
					println "Ok: $persona"
				}
				catch(Exception e) {
					println "Error: $persona {${e.message}}"
				}
		}
		persona.save(flush:true, failOnError:true)
	}
	
	def create() {
		def command = personaService.createPersonaCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[personaInstance: command]
	}
	def save(PersonaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.Persona.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [personaInstance: command])
			return
		}
		
		def personaInstance
		
		try {
			personaInstance = personaService.savePersona(command)
		}catch (e){
			flash.error	= message(code: 'zifras.Persona.save.error', default: 'Error al intentar salvar el proveedor')
			render(view: "create", model: [personaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.Persona.label', default: 'Cliente/Proveedor'), personaInstance.razonSocial], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def personaInstance = personaService.getPersona(id)
		if (!personaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.Persona.label', default: 'Cliente/Proveedor'), id])
			redirect(action: "list")
			return
		}

		[personaInstance: personaInstance]
	}

	def edit(Long id) {
		def personaInstance = personaService.getPersonaCommand(id)
		if (!personaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.Persona.label', default: 'Cliente/Proveedor'), id])
			redirect(action: "list")
			return
		}

		[personaInstance: personaInstance]
	}

	def update(PersonaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [personaInstance: command])
			return
		}
		
		def personaInstance
		
		try {
			personaInstance = personaService.updatePersona(command)
		}
		catch (ValidationException e){
			personaInstance.errors = e.errors
			render(view: "edit", model: [personaInstance: personaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [personaInstance: personaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.Persona.label', default: 'Cliente/Proveedor'), personaInstance.razonSocial], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def personaInstance = personaService.getPersona(id)
		if (!personaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.Persona.label', default: 'Cliente/Proveedor'), id])
			redirect(action: "list")
			return
		}
		def razonSocial = personaInstance.razonSocial

		try {
			personaService.deletePersona(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.Persona.label', default: 'Cliente/Proveedor'), razonSocial], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.Persona.label', default: 'Cliente/Proveedor'), razonSocial], encodeAs:'none')
			redirect(action: "list")
		}
	}

	@Secured(['ROLE_USER', 'ROLE_CUENTA', 'ROLE_RIDER_PY', 'ROLE_SE', 'ROLE_SM','ROLE_COBRANZA', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetClientesPorCuenta(Long id){
		render personaService.listClientesCuenta(id) as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_CUENTA', 'ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_RIDER_PY', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetProveedoresPorCuenta(Long id){
		render personaService.listProveedoresCuenta(id) as JSON
	}
	
	def ajaxGetPersona(Long id) {
		def persona = personaService.getPersona(id)
		render persona as JSON
	}
}
