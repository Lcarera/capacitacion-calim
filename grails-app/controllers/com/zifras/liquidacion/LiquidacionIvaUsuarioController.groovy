package com.zifras.liquidacion
import com.zifras.cuenta.Cuenta

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import com.zifras.AccessRulesService

@Secured(['ROLE_CUENTA', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class LiquidacionIvaUsuarioController {
	def liquidacionIvaService
	AccessRulesService accessRulesService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def show(Long id) {
		def liquidacionIvaInstance = liquidacionIvaService.getLiquidacionIva(id)
		if (!liquidacionIvaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacionIva.label', default: 'liquidacionIva'), id])
			redirect(action: "list")
			return
		}
		def usuario = accessRulesService.getCurrentUser()
		[liquidacionIvaInstance: liquidacionIvaInstance, userId: usuario?.id]
	}

	def mostrar(Long cuentaId, String ano, String mes){
		def liquidacionIvaInstance = liquidacionIvaService.getLiquidacionIvaPorCuentaFecha(cuentaId,ano,mes)

		render(view:"show",model:[liquidacionIvaInstance: liquidacionIvaInstance])
		return
	}

	def presentar(Long id) { // En realidad es Autorizar
		liquidacionIvaService.presentar(id);
		flash.message = "La liquidación se autorizó correctamente."
		redirect(controller:"dashboard",action:"index")
	}

	def ajaxGetLiquidacion(Long id){
		render liquidacionIvaService.getLiquidacionIva(id) as JSON
	}
}
