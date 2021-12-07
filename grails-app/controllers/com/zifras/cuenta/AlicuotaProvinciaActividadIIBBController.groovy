package com.zifras.cuenta

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException
import org.joda.time.LocalDate

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class AlicuotaProvinciaActividadIIBBController {
	def alicuotaProvinciaActividadIIBBService

    def index() {
		redirect(action: "list", params: params)
	}

	def list() {
		[ano: (new LocalDate ()).toString("YYYY")]
	}
	
	def create() {
		def command = alicuotaProvinciaActividadIIBBService.createAlicuotaProvinciaActividadIIBBCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[alicuotaProvinciaActividadIIBBInstance: command]
	}

	def save(AlicuotaProvinciaActividadIIBBCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.cuenta.AlicuotaProvinciaActividadIIBB.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [alicuotaProvinciaActividadIIBBInstance: command])
			return
		}
		
		def alicuotaProvinciaActividadIIBBInstance
		
		try {
			alicuotaProvinciaActividadIIBBInstance = alicuotaProvinciaActividadIIBBService.saveAlicuotaProvinciaActividadIIBB(command)
		}catch (e){
			flash.error	= message(code: 'zifras.cuenta.AlicuotaProvinciaActividadIIBB.save.error', default: 'Error al intentar salvar la Alicuota')
			render(view: "create", model: [alicuotaProvinciaActividadIIBBInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.cuenta.CondicionIva.label', default: 'Condicion IVA'), alicuotaProvinciaActividadIIBBInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def alicuotaProvinciaActividadIIBBInstance = alicuotaProvinciaActividadIIBBService.getAlicuotaProvinciaActividadIIBB(id)
		if (!alicuotaProvinciaActividadIIBBInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.CondicionIva.label', default: 'Condicion IVA'), id])
			redirect(action: "list")
			return
		}

		[alicuotaProvinciaActividadIIBBInstance: alicuotaProvinciaActividadIIBBInstance]
	}

	def edit(Long id) {
		def alicuotaProvinciaActividadIIBBInstance = alicuotaProvinciaActividadIIBBService.getAlicuotaProvinciaActividadIIBBCommand(id)
		if (!alicuotaProvinciaActividadIIBBInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.CondicionIva.label', default: 'Condicion IVA'), id])
			redirect(action: "list")
			return
		}

		[alicuotaProvinciaActividadIIBBInstance: alicuotaProvinciaActividadIIBBInstance]
	}

	def update(AlicuotaProvinciaActividadIIBBCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [alicuotaProvinciaActividadIIBBInstance: command])
			return
		}
		
		def alicuotaProvinciaActividadIIBBInstance
		
		try {
			alicuotaProvinciaActividadIIBBInstance = alicuotaProvinciaActividadIIBBService.updateAlicuotaProvinciaActividadIIBB(command)
		}
		catch (ValidationException e){
			alicuotaProvinciaActividadIIBBInstance.errors = e.errors
			render(view: "edit", model: [alicuotaProvinciaActividadIIBBInstance: alicuotaProvinciaActividadIIBBInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [alicuotaProvinciaActividadIIBBInstance: alicuotaProvinciaActividadIIBBInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.cuenta.AlicuotaProvinciaActividadIIBB.label', default: 'Alicuota Provincia Actividad IIBB'), alicuotaProvinciaActividadIIBBInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def alicuotaProvinciaActividadIIBBInstance = alicuotaProvinciaActividadIIBBService.getAlicuotaProvinciaActividadIIBB(id)
		if (!alicuotaProvinciaActividadIIBBInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.AlicuotaProvinciaActividadIIBB.label', default: 'Alicuota Provincia Actividad IIBB'), id])
			redirect(action: "list")
			return
		}

		try {
			alicuotaProvinciaActividadIIBBService.deleteAlicuotaProvinciaActividadIIBB(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.cuenta.AlicuotaProvinciaActividadIIBB.label', default: 'Alicuota Provincia Actividad IIBB')], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.cuenta.AlicuotaProvinciaActividadIIBB.label', default: 'Alicuota Provincia Actividad IIBB')], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	def ajaxGetAlicuotasProvinciaActividadIIBB(Long ano){
		render alicuotaProvinciaActividadIIBBService.getAlicuotasProvinciaActividadIIBB(ano) as JSON
	}
}
