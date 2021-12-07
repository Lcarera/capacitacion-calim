package com.zifras.cuenta
import com.zifras.cuenta.ConfiguracionCommand

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.zifras.AccessRulesService

import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_CUENTA', 'ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class ConfiguracionController {
	def cuentaService
	AccessRulesService accessRulesService

    def index() {
		redirect(action: "show", params: params)
	}

	def show() {
		def cuenta = accessRulesService.getCurrentUser().cuenta
		[cuentaInstance: cuenta]
	}

	def update(ConfiguracionCommand command){
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.cuenta.Configuracion.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "show", model: [cuentaInstance: command])
			return
		}
		
		def cuentaInstance
		
		try {
			cuentaInstance = cuentaService.updateConfiguracionCuenta(command)
		}catch (e){
			flash.error	= message(code: 'zifras.cuenta.Cuenta.save.error', default: 'Error al intentar salvar la configuracion')
			render(view: "show", model: [cuentaInstance: command])
			return
		}

		flash.message = "Configuracion actualizada con exito"
		redirect(action: "show")
	}
}