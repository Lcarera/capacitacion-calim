package com.zifras.liquidacion

import grails.plugin.springsecurity.annotation.Secured;

import com.zifras.liquidacion.LiquidacionIvaService
import com.zifras.liquidacion.LiquidacionIvaCommand
import com.zifras.liquidacion.LiquidacionIvaMasivaCommand
import com.zifras.liquidacion.LiquidacionIva
import com.zifras.notificacion.NotificacionService
import com.zifras.cuenta.CuentaService

import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

import grails.converters.JSON

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import com.zifras.AccessRulesService

import com.zifras.AccessRulesService;
import com.zifras.Estado

@Secured(['ROLE_USER','ROLE_CUENTA' ,'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class LiquidacionIvaController {
	NotificacionService notificacionService
	def liquidacionIvaService
	def cuentaService
	AccessRulesService accessRulesService
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def index() {
		redirect(action: "list", params: params)
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def list() {
		def hoy = new LocalDate().minusMonths(1)
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def listRetencionPercepcion() {
		def hoy = new LocalDate()
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def listNota() {
		def hoy = new LocalDate()
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def listLiquidacionMasiva() {
		def hoy = new LocalDate().minusMonths(1)
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def listLiquidacionNotificacion() {
		def hoy = new LocalDate()
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[ano: ano, mes: mes]
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def create(LiquidacionIvaCommand command) {
		def liquidacionIvaInstance = liquidacionIvaService.createLiquidacionIvaCommand(command)
		
		[liquidacionIvaInstance: liquidacionIvaInstance]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def save(LiquidacionIvaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.liquidacion.LiquidacionIva.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [liquidacionIvaInstance: command])
			return
		}
		
		def liquidacionIvaInstance 
		
		try {
			liquidacionIvaInstance = liquidacionIvaService.saveLiquidacionIva(command)
		}catch (e){
			flash.error	= message(code: 'zifras.liquidacion.LiquidacionIva.save.error', default: 'Error al intentar salvar la liquidación')
			render(view: "create", model: [liquidacionIvaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.liquidacion.LiquidacionIva.label', default: 'LiquidacionIva'), liquidacionIvaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def show(Long id) {
		def liquidacionIvaInstance = liquidacionIvaService.getLiquidacionIva(id)
		if (!liquidacionIvaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.LiquidacionIva.label', default: 'LiquidacionIva'), id])
			redirect(action: "list")
			return
		}

		[liquidacionIvaInstance: liquidacionIvaInstance, fechaHoy: new LocalDate().toString("dd/MM/YYYY")]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def edit(Long id) {
		def liquidacionIvaInstance = liquidacionIvaService.getLiquidacionIvaCommand(id)
		if (!liquidacionIvaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.LiquidacionIva.label', default: 'LiquidacionIva'), id])
			redirect(action: "list")
			return
		}

		def usuario = accessRulesService.getCurrentUser().username
		
		if(!["cgzechner@gmail.com","epavoni2000@gmail.com","franco@calim.com.ar"].contains(usuario)){
			if (liquidacionIvaInstance.estadoId == 162875) {
				flash.error = "No puede editarse una liquidacion ya autorizada."
				redirect(action: "show", id: id)
				return
			}
			if (liquidacionIvaInstance.estadoId == 162874) {
				flash.error = "No puede editarse una liquidacion ya presentada."
				redirect(action: "show", id: id)
				return
			}
		}
		[liquidacionIvaInstance: liquidacionIvaInstance]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def update(LiquidacionIvaCommand command) {
		if (command.hasErrors()) {
			flash.error = "Los siguientes campos contienen errores: " + command.errors.allErrors.collect{it.field}
			render(view: "edit", model: [liquidacionIvaInstance: command])
			return
		}
		
		def liquidacionIvaInstance
		
		try {
			liquidacionIvaInstance = liquidacionIvaService.updateLiquidacionIva(command)
		}
		catch (ValidationException e){
			command.errors = e.errors
			flash.error = "Los siguientes campos contienen errores: " + e.errors.allErrors.collect{it.field}
			render(view: "edit", model: [liquidacionIvaInstance: command])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [liquidacionIvaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.liquidacion.LiquidacionIva.label', default: 'LiquidacionIva'), liquidacionIvaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def delete(Long id) {
		def liquidacionIvaInstance = liquidacionIvaService.getLiquidacionIva(id)
		if (!liquidacionIvaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.liquidacion.LiquidacionIva.label', default: 'LiquidacionIva'), id])
			redirect(action: "list")
			return
		}
		String nombre = liquidacionIvaInstance.cuenta.razonSocial

		try {
			liquidacionIvaService.deleteLiquidacionIva(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.liquidacion.LiquidacionIva.label', default: 'LiquidacionIva'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.liquidacion.LiquidacionIva.label', default: 'LiquidacionIva'), nombre], encodeAs:'none')
			redirect(action: "show", id: id)
		}
	}
	
	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def deleteMesLiquidacionIva(String mes, String ano) {
		
		try {
			def cantidad = liquidacionIvaService.deleteMesLiquidacionIva(mes, ano)
			flash.message = message(code: 'zifras.liquidacion.LiquidacionIva.delete.mes.success', default: 'Se borraron {2} liquidaciones del período {0}/{1}', args: [mes, ano, cantidad], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'zifras.liquidacion.LiquidacionIva.delete.mes.error', default: 'Hubo un error al borrar las liquidaciones del período {0}/{1}', args: [mes, ano], encodeAs:'none')
			redirect(action: "list")
		}
		
		redirect(action: "list")
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_SE','ROLE_VENTAS','ROLE_COBRANZA','ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLiquidacionesIvaList(String mes, String ano){
		def liquidaciones = liquidacionIvaService.getLiquidacionIvaList(mes, ano)
		render liquidaciones as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_SE','ROLE_VENTAS','ROLE_COBRANZA','ROLE_CUENTA','ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLiquidacionesIvaCuentaList(Long cuentaId, String ano){
		def liquidaciones = liquidacionIvaService.getLiquidacionesPorCuenta(cuentaId, ano)
		render liquidaciones as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxModificarRetencionPercepcion(LiquidacionIvaCommand command){
		def liquidacion = liquidacionIvaService.updateRetencionPercepcion(command)
		render liquidacion as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxModificarNota(LiquidacionIvaCommand command){
		def liquidacion = liquidacionIvaService.updateNota(command)
		render liquidacion as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxLiquidacionMasiva(LiquidacionIvaMasivaCommand command){
		def liquidaciones = liquidacionIvaService.liquidacionMasiva(command)
		render liquidaciones as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxLiquidacionMasiva2(LiquidacionIvaMasivaCommand command){
		def liquidaciones = liquidacionIvaService.liquidacionMasiva2(command)
		render liquidaciones as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxEnviarNotificaciones(LiquidacionIvaMasivaCommand command){
		def liquidaciones = liquidacionIvaService.enviarNotificaciones(command)
		render liquidaciones as JSON
	}

	@Secured(['ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def ajaxDelete(Long id) {
		def liquidacionIvaInstance = liquidacionIvaService.getLiquidacionIva(id)
		if (!liquidacionIvaInstance) {
			return
		}

		try {
			liquidacionIvaService.deleteLiquidacionIva(id)
		}
		catch (e) {
		}
		render new LiquidacionIvaCommand() as JSON
	}
}