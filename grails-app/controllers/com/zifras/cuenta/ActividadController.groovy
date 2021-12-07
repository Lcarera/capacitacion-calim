package com.zifras.cuenta

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.zifras.cuenta.ActividadService
import com.zifras.cuenta.ActividadCommand

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class ActividadController {
	def actividadService

    def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}
	
	def create() {
		def command = actividadService.createActividadCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[actividadInstance: command]
	}

	def save(ActividadCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.cuenta.Actividad.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [actividadInstance: command])
			return
		}
		
		def actividadInstance
		
		try {
			actividadInstance = actividadService.saveActividad(command)
		}catch (e){
			flash.error	= message(code: 'zifras.cuenta.Actividad.save.error', default: 'Error al intentar salvar la actividad')
			render(view: "create", model: [actividadInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.cuenta.Actividad.label', default: 'Actividad'), actividadInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def actividadInstance = actividadService.getActividad(id)
		if (!actividadInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Actividad.label', default: 'Actividad'), id])
			redirect(action: "list")
			return
		}

		[actividadInstance: actividadInstance]
	}

	def edit(Long id) {
		def actividadInstance = actividadService.getActividadCommand(id)
		if (!actividadInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Actividad.label', default: 'Actividad'), id])
			redirect(action: "list")
			return
		}

		[actividadInstance: actividadInstance]
	}

	def update(ActividadCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [actividadInstance: command])
			return
		}
		
		def actividadInstance
		
		try {
			actividadInstance = actividadService.updateActividad(command)
		}
		catch (ValidationException e){
			actividadInstance.errors = e.errors
			render(view: "edit", model: [actividadInstance: actividadInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [actividadInstance: actividadInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.cuenta.Actividad.label', default: 'Actividad'), actividadInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def actividadInstance = actividadService.getActividad(id)
		if (!actividadInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Actividad.label', default: 'Actividad'), id])
			redirect(action: "list")
			return
		}
		String nombre = actividadInstance.nombre

		try {
			actividadService.deleteActividad(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.cuenta.Actividad.label', default: 'Actividad'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.cuenta.Actividad.label', default: 'Actividad'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	def ajaxGetActividades(){
		def actividades = actividadService.listActividad()
		render actividades as JSON
	}
	
	def ajaxGetActividad(Long id) {
		def actividad = actividadService.getActividad(id)
		render actividad as JSON
	}
}
