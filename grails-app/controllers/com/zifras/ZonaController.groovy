package com.zifras

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.zifras.ZonaService
import com.zifras.ZonaCommand

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM','ROLE_SE', 'ROLE_COBRANZA', 'ROLE_VENTAS' ,'IS_AUTHENTICATED_FULLY'])
class ZonaController {
	def zonaService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}
	
	def create() {
		def command = zonaService.createZonaCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[zonaInstance: command]
	}

	def save(ZonaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.Zona.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [zonaInstance: command])
			return
		}
		
		def zonaInstance
		
		try {
			zonaInstance = zonaService.saveZona(command)
		}catch (e){
			flash.error	= message(code: 'zifras.Zona.save.error', default: 'Error al intentar salvar la zona')
			render(view: "create", model: [zonaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.Zona.label', default: 'Zona'), zonaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def zonaInstance = zonaService.getZona(id)
		if (!zonaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.Zona.label', default: 'Zona'), id])
			redirect(action: "list")
			return
		}

		[zonaInstance: zonaInstance]
	}

	def edit(Long id) {
		def zonaInstance = zonaService.getZonaCommand(id)
		if (!zonaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.Zona.label', default: 'Zona'), id])
			redirect(action: "list")
			return
		}

		[zonaInstance: zonaInstance]
	}

	def update(ZonaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [zonaInstance: command])
			return
		}
		
		def zonaInstance
		
		try {
			zonaInstance = zonaService.updateZona(command)
		}
		catch (ValidationException e){
			zonaInstance.errors = e.errors
			render(view: "edit", model: [zonaInstance: zonaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [zonaInstance: zonaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.Zona.label', default: 'Zona'), zonaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def zonaInstance = zonaService.getZona(id)
		if (!zonaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.Zona.label', default: 'Zona'), id])
			redirect(action: "list")
			return
		}
		String nombre = zonaInstance.nombre

		try {
			zonaService.deleteZona(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.Zona.label', default: 'Zona'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.Zona.label', default: 'Zona'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	def ajaxGetZonas(String filter){
		def zonas = zonaService.listZona(filter)
		render zonas as JSON
	}
	
	def ajaxGetZona(Long id) {
		def zona = zonaService.getZona(id)
		render zona as JSON
	}
}
