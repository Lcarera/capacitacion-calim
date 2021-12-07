package com.zifras.cuenta

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON
import org.joda.time.LocalDate

import com.zifras.AccessRulesService

import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_ADMIN','IS_AUTHENTICATED_FULLY'])
class MoratoriaController{
	
	def moratoriaService
	def cuentaService

	def index() {
		redirect(action: "list", params: params)
	}

	def list(){

	}

	def show(Long id){
		def cuenta = Cuenta.get(id)
		def planMoratoriaInstance = cuenta.planesMoratoria.first()
		[planMoratoriaInstance:planMoratoriaInstance]
	}

	def create(Long cuentaId){
		def mobile = false
		def cuentaInstance = cuentaService.getCuenta(cuentaId)
		if(!cuentaInstance){
			flash.error = message(code:'default.not.found.message',args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), cuentaId])
			redirect(action:'list')
			return
		}
		[cuentaId:cuentaId] 
	}

	def save(PlanMoratoriaCommand commandPlanMoratoria) {
		def returnArray = [:]
		def mobile = false
		if (commandPlanMoratoria.hasErrors()) {
			flash.error = message(code: 'zifras.ticket.Mensaje.command.hasErrors', default:'Algun atributo del plan esta mal')
			render(view: "create", model: [planMoratoriaInstance: commandPlanMoratoria, cuentaId:commandPlanMoratoria.cuentaId])
			return
		}
		
		def planMoratoriaInstance
		
		try{
			planMoratoriaInstance = moratoriaService.savePlanMoratoria(commandPlanMoratoria)
		}catch (e){
			if(mobile){
				returnArray['error'] = true
				returnArray['mensaje'] = "Error creando el cliente"
				render returnArray as JSON
				return
			}
			flash.error	= e.message ?: message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
			render(view: "create", model: [planMoratoriaInstance: commandPlanMoratoria, cuentaId:commandPlanMoratoria.cuentaId])
			return
		}	

		if(mobile){
			returnArray['error'] = false
			returnArray['mensaje'] = "OK"
			render returnArray as JSON
			return
		}

		flash.message = "Plan Moratoria creado exitosamente."
		redirect(action:"list")
	}

	def edit(Long id){
		def planMoratoriaInstance = moratoriaService.getPlanMoratoriaCommand(id)

		if (!planMoratoriaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.PlanMoratoria.label', default: 'Plan Moratoria'), id])
			redirect(action: tipo)
			return
		}

		[planMoratoriaInstance:planMoratoriaInstance]
	}

	def ajaxGetCuentasMoratoria(String filter){
		def cuentas = moratoriaService.listCuentasMoratoria(filter)
		render cuentas as JSON
	}

	def ajaxGetServiciosMoratoriaCuenta(Long cuentaId){
		def servicios = moratoriaService.listServiciosMoratoriaCuenta(cuentaId)
		render servicios as JSON
	}

	def ajaxGetCuotasMoratoria(Long planMoratoriaId){
		def cuotas = moratoriaService.listCuotasPlan(planMoratoriaId)
		render cuotas as JSON
	}
}
	