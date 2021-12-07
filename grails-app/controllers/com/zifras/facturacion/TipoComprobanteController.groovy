package com.zifras.facturacion

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class TipoComprobanteController {
	def tipoComprobanteService

	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}

	def create() {
		def command = tipoComprobanteService.createTipoComprobanteCommand()

		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}

		[tipoComprobanteInstance: command]
	}

	def save(TipoComprobanteCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.TipoComprobante.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [tipoComprobanteInstance: command])
			return
		}

		def tipoComprobanteInstance

		try {
			tipoComprobanteInstance = tipoComprobanteService.saveTipoComprobante(command)
		}catch (e){
			flash.error	= message(code: 'zifras.PatrimonioGanancia.save.error', default: 'Error al intentar salvar el tipo de factura')
			render(view: "create", model: [tipoComprobanteInstance: command])
			return
		}

		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.TipoComprobante.label', default: 'Tipo'), tipoComprobanteInstance.nombre], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def tipoComprobanteInstance = tipoComprobanteService.getTipoComprobante(id)
		if (!tipoComprobanteInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.TipoComprobante.label', default: 'Tipo'), id])
			redirect(action: "list")
			return
		}

		[tipoComprobanteInstance: tipoComprobanteInstance]
	}

	def edit(Long id) {
		def tipoComprobanteInstance = tipoComprobanteService.getTipoComprobanteCommand(id)
		if (!tipoComprobanteInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.TipoComprobante.label', default: 'Tipo'), id])
			redirect(action: "list")
			return
		}

		[tipoComprobanteInstance: tipoComprobanteInstance]
	}

	def update(TipoComprobanteCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [tipoComprobanteInstance: command])
			return
		}

		def tipoComprobanteInstance

		try {
			tipoComprobanteInstance = tipoComprobanteService.updateTipoComprobante(command)
		}
		catch (ValidationException e){
			tipoComprobanteInstance.errors = e.errors
			render(view: "edit", model: [tipoComprobanteInstance: tipoComprobanteInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [tipoComprobanteInstance: tipoComprobanteInstance])
			return
		}

		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.TipoComprobante.label', default: 'Tipo'), tipoComprobanteInstance.nombre], encodeAs:'none')
		redirect(action: "list")
	}

	def delete(Long id) {
		def tipoComprobanteInstance = tipoComprobanteService.getTipoComprobante(id)
		if (!tipoComprobanteInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.TipoComprobante.label', default: 'Tipo'), id])
			redirect(action: "list")
			return
		}
		String nombre = tipoComprobanteInstance.nombre

		try {
			tipoComprobanteService.deleteTipoComprobante(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.TipoComprobante.label', default: 'Tipo'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.TipoComprobante.label', default: 'Tipo'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}

	@Secured(['ROLE_USER', 'ROLE_CUENTA', 'ROLE_SM','ROLE_SE','ROLE_RIDER_PY', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetTiposComprobante(Long cuentaId){
		render tipoComprobanteService.listTipoComprobante(cuentaId) as JSON
	}

	def ajaxGetTipoComprobante(Long id) {
		def tipoComprobante = tipoComprobanteService.getTipoComprobante(id)
		render tipoComprobante as JSON
	}
}
