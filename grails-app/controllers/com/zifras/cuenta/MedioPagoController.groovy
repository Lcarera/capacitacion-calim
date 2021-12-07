package com.zifras.cuenta
import com.zifras.AccessRulesService
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException
import grails.converters.JSON

@Secured(['ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class MedioPagoController{
	
	def medioPagoService

	def index(){
		redirect(action: "list", params: params)
	}
	@Secured(['ROLE_ADMIN'])
	def list(){

	}

	def show(Long id){

	}

	def edit(Long id){
		def medioPagoInstance = medioPagoService.getMedioPagoCommand(id)
		if (!medioPagoInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.medioPago.label', default: 'Medio Pago'), id])
			redirect(action: "list")
			return
		}
		[medioPagoInstance:medioPagoInstance]
	}

	def create(){
		def command = medioPagoService.createMedioPagoCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		[clienteProveedorInstance: command]
	}

	def save(MedioPagoCommand command){
		if(command.hasErrors()){
			flash.error = message(code: 'zifras.ticket.Mensaje.command.hasErrors', default:'Algun atributo del medio de pago esta mal')
			render(view: "create", model: [medioPagoInstance: command])
			return
		}
		try{
			def medioPagoInstance = medioPagoService.saveMedioPago(command)
		}
		catch(e){
			flash.error	= e.message ?: message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
			render(view: "create", model: [medioPagoInstance: medioPagoInstance])
			return
		}
		flash.message = "FAQ creada exitosamente"
		redirect(action:"list")
	}

	def update(MedioPagoCommand command){
		if(command.hasErrors()){
			flash.error = message(code: 'zifras.ticket.Mensaje.command.hasErrors', default:'Algun atributo del medio de pago esta mal')
			return
		}
		def medioPagoInstance
		try{
			medioPagoInstance = medioPagoService.updateMedioPago(command)
		}
		catch(e){
			flash.error	= e.message ?: message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
			render(view: "edit", model: [medioPagoInstance: command])
			return
		}
		flash.message = "Medio de Pago modificado exitosamente."
		redirect(action:"list")
	}

	def delete(Long id){
		def medioPagoInstance = medioPagoService.getMedioPagoCommand(id)
		if(!medioPagoInstance){
			flash.error = message(code: 'zifras.ticket.hasErrors', default:'El medio de pago con el id enviado no existe')
			return
		}
		try{
			medioPagoService.deleteMedioPago(id)
			flash.message = "FAQ eliminada exitosamente."
		}
		catch(e){
			flash.error	= e.message ?: message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
		}
		redirect(action:"list")
	}

	def ajaxGetMediosPago(){
		def medios = medioPagoService.listMediosPago()
		render medios as JSON
	}
}