package com.zifras.ticket

import com.zifras.ticket.MensajeCommand

import grails.plugin.springsecurity.annotation.Secured
import grails.converters.JSON

import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class MensajeController {
	def mensajeService

	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
		// TODO: Vista
	}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def create() {
		def command = mensajeService.createMensajeCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[mensajeInstance: command]
	}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def save(MensajeCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.ticket.Mensaje.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [mensajeInstance: command])
			return
		}
		
		def mensajeInstance
		
		try {
			mensajeInstance = mensajeService.saveMensaje(command)
		}catch (e){
			flash.error	= message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
			render(view: "create", model: [mensajeInstance: command])
			return
		}
		
		flash.message = "Su mensaje fue enviado exitosamente."
		redirect(controller:"dashboard",action: "index")
	}

	def show(Long id) {
		def mensajeInstance = mensajeService.getMensaje(id)
		if (!mensajeInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.ticket.Mensaje.label', default: 'Mensaje'), id])
			redirect(action: "list")
			return
		}

		[mensajeInstance: mensajeInstance]
	}

	def delete(Long id) {
		def mensajeInstance = mensajeService.getMensaje(id)
		if (!mensajeInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.Mensaje.label', default: 'Mensaje'), id])
			redirect(action: "list")
			return
		}
		String asunto = mensajeInstance.asunto

		try {
			mensajeService.deleteMensaje(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.Mensaje.label', default: 'Mensaje'), asunto], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.Mensaje.label', default: 'Mensaje'), asunto], encodeAs:'none')
			redirect(action: "list")
		}
	}

	def ajaxGetMensajes(String filter){
		def mensajes = mensajeService.listMensajes(filter)
		render mensajes as JSON
	}
}
