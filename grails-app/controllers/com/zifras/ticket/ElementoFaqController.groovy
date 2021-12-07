package com.zifras.ticket
import com.zifras.AccessRulesService
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException
import grails.converters.JSON

@Secured(['ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class ElementoFaqController{
	
	def elementoFaqService

	def index(){
		redirect(action: "list", params: params)
	}
	@Secured(['ROLE_ADMIN'])
	def list(){

	}

	def show(Long id){

	}

	def edit(Long id){
		def elementoFaqInstance = elementoFaqService.getElementoFaqCommand(id)
		if (!elementoFaqInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.ELementoFaq.label', default: 'FAQ'), id])
			redirect(action: "list")
			return
		}
		[elementoFaqInstance:elementoFaqInstance]
	}

	def create(){
		def command = elementoFaqService.createElementoFaqCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		[clienteProveedorInstance: command]
	}

	def save(ElementoFaqCommand command){
		if(command.hasErrors()){
			flash.error = message(code: 'zifras.ticket.Mensaje.command.hasErrors', default:'Algun atributo del elemento FAQ esta mal')
			render(view: "create", model: [elementoFaqInstance: command])
			return
		}
		try{
			def elementoFaqInstance = elementoFaqService.saveElementoFaq(command)
		}
		catch(e){
			flash.error	= e.message ?: message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
			render(view: "create", model: [elementoFaqInstance: elementoFaqInstance])
			return
		}
		flash.message = "FAQ creada exitosamente"
		redirect(action:"list")
	}

	def update(ElementoFaqCommand command){
		if(command.hasErrors()){
			flash.error = message(code: 'zifras.ticket.Mensaje.command.hasErrors', default:'Algun atributo del elemento FAQ esta mal')
			return
		}
		def elementoFaqInstance
		try{
			elementoFaqInstance = elementoFaqService.updateElementoFaq(command)
		}
		catch(e){
			flash.error	= e.message ?: message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
			render(view: "edit", model: [elementoFaqInstance: command])
			return
		}
		flash.message = "FAQ modificada exitosamente."
		redirect(action:"list")
	}

	def delete(Long id){
		def elementoFaqInstance = elementoFaqService.getElementoFaqCommand(id)
		if(!elementoFaqInstance){
			flash.error = message(code: 'zifras.ticket.hasErrors', default:'La FAQ con el id enviado no existe')
			return
		}
		try{
			elementoFaqService.deleteElementoFaq(id)
			flash.message = "FAQ eliminada exitosamente."
		}
		catch(e){
			flash.error	= e.message ?: message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
		}
		redirect(action:"list")
	}

	def editarCategoria(Long id){
		def categoriaFaqInstance = elementoFaqService.getCategoriaFaqCommand(id)
		if (!categoriaFaqInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.CategoriaFaq.label', default: 'Categoría FAQ'), id])
			redirect(action: "list")
			return
		}
		[categoriaFaqInstance:categoriaFaqInstance]
	}

	def saveCategoria(){
		def categoria
		try{
			categoria = elementoFaqService.saveCategoria(params.nombreCategoria, params.pesoCategoria)
			flash.message = "Categoría FAQ creada exitosamente."
		}
		catch(e){
			flash.error = e.message ?: "No se pudo crear la categoria"

		}
		redirect(action:"list")
	}	

	def updateCategoria(CategoriaFaqCommand command){
		if(command.hasErrors()){
			flash.error = message(code: 'zifras.ticket.Mensaje.command.hasErrors', default:'Algun atributo de la Categoria FAQ esta mal')
			render(view: "editarCategoria", model: [categoriaFaqInstance: command])
			return
		}
		def categoriaFaqInstance
		try{
			categoriaFaqInstance = elementoFaqService.updateCategoria(command)
		}
		catch(e){
			flash.error	= e.message ?: message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
			render(view: "editarCategoria", model: [categoriaFaqInstance: command])
			return
		}
		flash.message = "Categoria FAQ modificada exitosamente."
		redirect(action:"list")
	}

	def deleteCategoria(Long id){
		def categoriaFaqInstance = elementoFaqService.getCategoriaFaqCommand(id)
		if(!categoriaFaqInstance){
			flash.error = message(code: 'zifras.ticket.hasErrors', default:'La Categoria FAQ con el id enviado no existe')
			return
		}
		try{
			elementoFaqService.deleteCategoria(id)
			flash.message = "Categoria FAQ eliminada exitosamente."
		}
		catch(e){
			flash.error	= e.message ?: message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
		}
		redirect(action:"list")
	}

	def ajaxGetElementos(){
		render elementoFaqService.listElementos() as JSON
	}

	def ajaxGetCategoriasFaq(){
		render elementoFaqService.listCategorias() as JSON
	}
}