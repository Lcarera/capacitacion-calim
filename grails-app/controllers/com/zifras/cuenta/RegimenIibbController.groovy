package com.zifras.cuenta

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.zifras.cuenta.RegimenIibbService
import com.zifras.cuenta.RegimenIibbCommand
import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM','ROLE_SE', 'ROLE_COBRANZA', 'ROLE_VENTAS', 'IS_AUTHENTICATED_FULLY'])
class RegimenIibbController {
	def regimenIibbService
	
    def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}
	
	def create() {
		def command = regimenIibbService.createRegimenIibbCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[regimenIibbInstance: command]
	}

	def save(RegimenIibbCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.cuenta.RegimenIibb.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [regimenIibbInstance: command])
			return
		}
		
		def regimenIibbInstance
		
		try {
			regimenIibbInstance = regimenIibbService.saveRegimenIibb(command)
		}catch (e){
			flash.error	= message(code: 'zifras.cuenta.RegimenIibb.save.error', default: 'Error al intentar salvar el regimen')
			render(view: "create", model: [regimenIibbInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.cuenta.RegimenIibb.label', default: 'Regimen IIBB'), regimenIibbInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def regimenIibbInstance = regimenIibbService.getRegimenIibb(id)
		if (!regimenIibbInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.RegimenIibb.label', default: 'Regimen IIBB'), id])
			redirect(action: "list")
			return
		}

		[regimenIibbInstance: regimenIibbInstance]
	}

	def edit(Long id) {
		def regimenIibbInstance = regimenIibbService.getRegimenIibbCommand(id)
		if (!regimenIibbInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.RegimenIibb.label', default: 'Regimen IIBB'), id])
			redirect(action: "list")
			return
		}

		[regimenIibbInstance: regimenIibbInstance]
	}

	def update(RegimenIibbCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [regimenIibbInstance: command])
			return
		}
		
		def regimenIibbInstance
		
		try {
			regimenIibbInstance = regimenIibbService.updateRegimenIibb(command)
		}
		catch (ValidationException e){
			regimenIibbInstance.errors = e.errors
			render(view: "edit", model: [regimenIibbInstance: regimenIibbInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [regimenIibbInstance: regimenIibbInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.cuenta.RegimenIibb.label', default: 'Regimen IIBB'), regimenIibbInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def regimenIibbInstance = regimenIibbService.getRegimenIibb(id)
		if (!regimenIibbInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.RegimenIibb.label', default: 'Regimen IIBB'), id])
			redirect(action: "list")
			return
		}
		String nombre = regimenIibbInstance.nombre

		try {
			regimenIibbService.deleteRegimenIibb(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.cuenta.RegimenIibb.label', default: 'Regimen IIBB'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.cuenta.RegimenIibb.label', default: 'Regimen IIBB'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	def ajaxGetRegimenesIIBB(){
		def regimenesIibb = regimenIibbService.listRegimenIibb()
		render regimenesIibb as JSON
	}
	
	def ajaxGetRegimenIIBB(Long id) {
		def regimenIibb = regimenIibbService.getRegimenIibb(id)
		render regimenIibb as JSON
	}
}
