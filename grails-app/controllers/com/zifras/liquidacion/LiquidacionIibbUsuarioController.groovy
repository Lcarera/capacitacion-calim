package com.zifras.liquidacion

import grails.plugin.springsecurity.annotation.Secured;

import com.zifras.liquidacion.LiquidacionIIBBService
import com.zifras.liquidacion.LiquidacionIIBBCommand
import com.zifras.liquidacion.LiquidacionIIBB
import com.zifras.cuenta.CuentaService

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

import grails.converters.JSON

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import com.zifras.AccessRulesService
import com.zifras.Provincia

import com.zifras.AccessRulesService;
import com.zifras.Estado

@Secured(['ROLE_CUENTA', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class LiquidacionIibbUsuarioController {
	def liquidacionIIBBService
	AccessRulesService accessRulesService
	
	def index() {
		redirect(action: "show", params: params)
	}

	def show(String mes, String ano) {
		def liquidacionIIBBInstance
		def usuario = accessRulesService.getCurrentUser()
		def cuentaId = usuario.cuenta?.id
		def liquidacionesBuscadas = liquidacionIIBBService.getLiquidacionesIIBBPorCuentaYFecha(cuentaId, ano, mes) //El service trae la lista de liquidaciones
		def sumaTotal = liquidacionIIBBService.obtenerSumaTotal(liquidacionesBuscadas)
		[liquidacionesBuscadas: liquidacionesBuscadas, ano:ano, mes:mes, sumaTotal:sumaTotal, userId: usuario?.id, cuentaId: cuentaId]
	}

	def presentarMes(String mes, String ano){ // En realidad es Autorizar
		try {
			liquidacionIIBBService.autorizarMes(accessRulesService.getCurrentUser().cuenta?.id, mes, ano)	
		}
		catch(Exception e) {
			flash.error = (e.message == "estado") ? "Alguna de las liquidaciones no estaba lista para autorizar." : "Ocurrió un error autorizando las liquidaciones."
			redirect(controller:"dashboard",action:"index")
			return
		}
		flash.message = "Las liquidaciones se han autorizado correctamente."
		redirect(controller:"dashboard",action:"index")
	}

	@Secured(['ROLE_CUENTA', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLiquidacionUnificada(String mes, String ano){
		def returnArray = [:]
		def cuentaId = accessRulesService.getCurrentUser().cuenta?.id
		def liquidacionesBuscadas = liquidacionIIBBService.getLiquidacionesIIBBPorCuentaYFecha(cuentaId, ano, mes) //El service trae la lista de liquidaciones
		def sumaTotal = liquidacionIIBBService.obtenerSumaTotal(liquidacionesBuscadas)
		returnArray["liquidaciones"] = liquidacionesBuscadas
		returnArray["sumaTotal"] = sumaTotal;
		render returnArray as JSON
	}

	@Secured(['ROLE_CUENTA', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLiquidacion(Long id){
		render liquidacionIIBBService.getLiquidacionIIBB(id) as JSON
	}
	@Secured(['ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLiquidacionesUnificadas(Long cuentaId, String ano){
		render liquidacionIIBBService.getLiquidacionesUnificadas(cuentaId, ano) as JSON
	}
}
