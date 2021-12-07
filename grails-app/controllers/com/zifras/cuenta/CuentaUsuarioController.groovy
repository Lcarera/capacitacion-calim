package com.zifras.cuenta

import grails.plugin.springsecurity.annotation.Secured

import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException
import org.joda.time.LocalDate
import com.zifras.AccessRulesService

import grails.converters.JSON

import com.zifras.ticket.EmpleadoSoporte
import com.zifras.Contador
import com.zifras.Localidad
import com.zifras.Provincia
import com.zifras.Estado
import com.zifras.UsuarioService

@Secured(['ROLE_CUENTA','ROLE_USER', 'ROLE_RIDER_PY', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class CuentaUsuarioController {
	def cuentaService
	def usuarioService
	AccessRulesService accessRulesService
	
    def index() {
		redirect(action: "show")
	}

	def ajaxUpdate(CuentaCommand command) {
		def resultado = [:]
		if (command.hasErrors())
			resultado['error'] = "Algún dato ingresado es inválido."
		else{
			try {
				cuentaService.updateCuentaUsuario(command)
			}
			catch (e) {
				resultado['error'] = "Ocurrió un error guardando los cambios."
			}
		}
		
		render resultado as JSON
	}
	
	def show() {
		def cuentaInstance = accessRulesService.getCurrentUser().cuenta
		def apps = cuentaService.getAllApps()
		def appsCuenta = cuentaInstance.appsDondeTrabaja()
		def soporte = EmpleadoSoporte.findByNombre("Alejandro") //lo asignamos con un round robin
		if (!cuentaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), "-"])
			redirect(controller:"dashboard",action: "index")
			return
		}
		
		[cuentaInstance: cuentaInstance, apps:apps,appsCuenta:appsCuenta, empleadoSoporte:soporte, stepRegistro:cuentaInstance.actionRegistro]
	}

	def ajaxUpdateMediosPago(Long medioPagoIvaId, Long medioPagoIibbId){
		def cuentaInstance = accessRulesService.getCurrentUser().cuenta
		def resultado = [:]
		try{
			cuentaService.updateMediosPago(medioPagoIvaId,medioPagoIibbId, cuentaInstance.id)
			resultado['mensaje'] = "OK"
			resultado['error'] = false
		}
		catch(e) {
			resultado['error'] = true
		}
		render resultado as JSON
		return
	}

	def appUpdateTarjeta(String numeroTarjeta, Boolean tarjetaCredito){
		def cuentaInstance = accessRulesService.getCurrentUser().cuenta
		def resultado = [:]
		try{
			cuentaService.updateTarjetaDebitoAutomatico(cuentaInstance.id, numeroTarjeta, tarjetaCredito)
			resultado['mensaje'] = "OK"
			resultado['error'] = false
		}
		catch(e) {
			resultado['error'] = true
		}
		render resultado as JSON
		return
	}

}