package com.zifras.liquidacion

import com.zifras.AccessRulesService
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.liquidacion.LiquidacionIIBBService
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured;
import grails.validation.ValidationException
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class RetencionPercepcionIIBBController {
	def retencionPercepcionService
	def cuentaService
	AccessRulesService accessRulesService
	LiquidacionIIBBService liquidacionIIBBService

	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
		def hoy = new LocalDate()
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		def cuenta = cuentaService.getPrimeraCuentaId()

		[ano: ano, mes: mes, cuentaId: cuenta]
	}
		
	def create() {
		def command = retencionPercepcionService.createRetencionPercepcionCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[retencionPercepcionInstance: command]
	}

	def save(RetencionPercepcionCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.RetencionPercepcion.command.hasErrors', default:'Algún atributo está mal')
			render(view: "create", model: [retencionPercepcionInstance: command])
			return
		}
		
		def retencionPercepcionInstance
		
		try {
			retencionPercepcionInstance = retencionPercepcionService.saveRetencionPercepcion(command, false)
		}catch (e){
			flash.error	= message(code: 'zifras.RetencionPercepcion.save.error', default: 'Error al intentar salvar la Retención/Percepción')
			render(view: "create", model: [retencionPercepcionInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), retencionPercepcionInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def show(Long id) {
		def retencionPercepcionInstance = retencionPercepcionService.getRetencionPercepcion(id, false)
		if (!retencionPercepcionInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), id])
			redirect(action: "list")
			return
		}

		[retencionPercepcionInstance: retencionPercepcionInstance]
	}

	def edit(Long id) {
		def retencionPercepcionInstance = retencionPercepcionService.getRetencionPercepcionCommand(id, false)
		if (!retencionPercepcionInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), id])
			redirect(action: "list")
			return
		}
		if (retencionPercepcionInstance.importado) {
			flash.error = "No puede editarse una retención/percepción importada."
			redirect(action: "list")
			return
		}

		[retencionPercepcionInstance: retencionPercepcionInstance]
	}

	def update(RetencionPercepcionCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [retencionPercepcionInstance: command])
			return
		}
		
		def retencionPercepcionInstance
		
		try {
			retencionPercepcionInstance = retencionPercepcionService.updateRetencionPercepcion(command, false)
		}
		catch (ValidationException e){
			command.errors = e.errors
			render(view: "edit", model: [retencionPercepcionInstance: command])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [retencionPercepcionInstance: command])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), retencionPercepcionInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def retencionPercepcionInstance = retencionPercepcionService.getRetencionPercepcion(id, false)
		if (!retencionPercepcionInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), id])
			redirect(action: "list")
			return
		}

		try {
			retencionPercepcionService.deleteRetencionPercepcion(id, false)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), id], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.RetencionPercepcion.label', default: 'RetencionPercepcion'), id], encodeAs:'none')
			redirect(action: "list")
		}
	}

	def limpiarMes(Integer mes, Integer ano, Long cuentaId){
		try {
			retencionPercepcionService.limpiarMes(new LocalDate(ano,mes,1), cuentaId)
			flash.message = "Deducciones eliminadas para el $mes/$ano"
			try {
				liquidacionIIBBService.liquidacionAutomatica(mes.toString(),ano.toString(),cuentaId)
			}
			catch(Exception e) {
				flash.error = "Error reliquidando para el $mes/$ano"
			}
		}
		catch(Exception e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error = "Error eliminando deducciones para el $mes/$ano"
		}
		
		redirect(controller:'cuenta', action:'show', id: cuentaId)
	}
	
	def ajaxGetRetencionesPercepciones(String mes, String ano, Long cuentaId){
		render retencionPercepcionService.listRetencionPercepcion(mes, ano, cuentaId, false) as JSON
	}
	
	def ajaxGetRetencionPercepcion(Long id) {
		render retencionPercepcionService.getRetencionPercepcion(id, false) as JSON
	}

	def ajaxCalcularRetencionPercepcionSumatoria(String ano, String mes, Long cuentaId){
		render retencionPercepcionService.calcularRetencionPercepcionSumatoria(cuentaId, mes, ano, false) as JSON
	}
}
