package com.zifras.documento

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.springframework.web.multipart.MultipartFile
import org.springframework.dao.DataIntegrityViolationException
import org.joda.time.LocalDate
import grails.converters.JSON

import com.zifras.Localidad
import com.zifras.Provincia;
import com.zifras.cuenta.CondicionIva
import com.zifras.cuenta.RegimenIibb
import com.zifras.cuenta.Cuenta
import com.zifras.Estado

@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class DeclaracionJuradaController {
	def declaracionJuradaService

	def index() {
		redirect(action: "list", params: params)
	}

	def create() {
		/*def command = declaracionJuradaService.createDeclaracionJuradaCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[declaracionJuradaInstance: command]*/
		flash.message = "Presente la liquidación desde el listado dentro de la cuenta."
		redirect(controller:'cuenta', action:'list')
	}

	def download(Long id){
		try {
			def file = declaracionJuradaService.getFile(id);
			response.setContentType("APPLICATION/OCTET-STREAM")
	        response.setHeader("Content-Disposition", "Attachment;Filename=\"${file.getName()}\"")
	                
	        def fileInputStream = new FileInputStream(file)
	        def outputStream = response.getOutputStream()
	        byte[] buffer = new byte[4096];
	        int len;
	        while ((len = fileInputStream.read(buffer)) > 0) {
	            outputStream.write(buffer, 0, len);
	        }

	        outputStream.flush()
	        outputStream.close()
	        fileInputStream.close()
		}
		catch(Exception e) {
			if (e.message=="no existe")
				flash.error="No se pudo encontrar el archivo solicitado."
			else if(e.message=="permisos")
				flash.error="No posee permiso para acceder a este archivo."
			else{
				flash.error="Ocurrió un error inesperado descargando el archivo."
				println "Error:"
				println e
				println ""
			}
	   		redirect(action: "list")
		}
	}

	def save(DeclaracionJuradaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.documento.DeclaracionJuradaCommand.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [declaracionJuradaInstance: command])
			return
		}
		
		def declaracionJuradaInstance
		
		try {
			def archivo = request.getFile('archivo')
			declaracionJuradaInstance = declaracionJuradaService.saveDeclaracionJurada(command, archivo)
		}catch (e){
			flash.error	= message(code: 'zifras.documento.DeclaracionJurada.save.error', default: 'Error al intentar salvar la Declaracion Jurada')
			render(view: "create", model: [declaracionJuradaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.documento.DeclaracionJurada.label', default: 'Declaracion Jurada'), declaracionJuradaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def savePorLiquidacionIva(DeclaracionJuradaCommand command, boolean volverCuentaShow) {
		try {
			assert ! command.hasErrors()
			declaracionJuradaService.saveDeclaracionJuradaPorLiquidacionIva(command, request.getFile('archivo'))
			flash.message = "Liquidación presentada correctamente."
		}catch(java.lang.AssertionError e){
			flash.error = "La declaración jurada contene atributos inválidos"
        }catch (e){
			flash.error	= message(code: 'zifras.documento.DeclaracionJurada.save.error', default: 'Error al intentar salvar la Declaracion Jurada')
		}
		if (volverCuentaShow)
			redirect(controller:'cuenta', action: "show", params:['id':command.cuentaId])
		else
			redirect(controller:'liquidacionIva', action: "show", params:['id':command.liquidacionId])
	}

	def savePorLiquidacionIibb(DeclaracionJuradaCommand command, boolean volverCuentaShow) {
		try {
			assert ! command.hasErrors()
			declaracionJuradaService.saveDeclaracionJuradaPorLiquidacionIibb(command, request.getFile('archivo'))
			flash.message = "Liquidación presentada correctamente."
		}catch(java.lang.AssertionError e){
			flash.error = "La declaración jurada contene atributos inválidos"
        }catch (e){
			flash.error	= message(code: 'zifras.documento.DeclaracionJurada.save.error', default: 'Error al intentar salvar la Declaracion Jurada')
		}

		if (volverCuentaShow)
			redirect(controller:'cuenta', action: "show", params:['id':command.cuentaId])
		else
			redirect(controller:'liquidacionIibb', action: "show", params:['id':command.liquidacionId])
	}

	def savePorLiquidacionGanancia(DeclaracionJuradaCommand command) {
		try {
			assert ! command.hasErrors()
			declaracionJuradaService.saveDeclaracionJuradaPorLiquidacionIibb(command, request.getFile('archivo'))
			flash.message = "Liquidación presentada correctamente."
		}catch(java.lang.AssertionError e){
			flash.error = "La declaración jurada contene atributos inválidos"
        }catch (e){
			flash.error	= message(code: 'zifras.documento.DeclaracionJurada.save.error', default: 'Error al intentar salvar la Declaracion Jurada')
		}

		redirect(controller:'liquidacionGanancia', action: "show", params:['id':command.liquidacionId])
	}

	def list() {
	}

	def show(Long id) {
		def declaracionJuradaInstance = declaracionJuradaService.getDeclaracionJurada(id)
		if (!declaracionJuradaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.DeclaracionJurada.label', default: 'Declaracion Jurada'), id])
			redirect(action: "list")
			return
		}

		[declaracionJuradaInstance: declaracionJuradaInstance]
	}

	def edit(Long id) {
		def declaracionJuradaInstance = declaracionJuradaService.getDeclaracionJuradaCommand(id)
		if (!declaracionJuradaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.DeclaracionJurada.label', default: 'Declaracion Jurada'), id])
			redirect(action: "list")
			return
		}

		[declaracionJuradaInstance: declaracionJuradaInstance]
	}

	def update(DeclaracionJuradaCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [declaracionJuradaInstance: command])
			return
		}
		
		def declaracionJuradaInstance
		
		try {
			def archivo = request.getFile('archivo')
			declaracionJuradaInstance = declaracionJuradaService.updateDeclaracionJurada(command, archivo)
		}
		catch (ValidationException e){
			declaracionJuradaInstance.errors = e.errors
			render(view: "edit", model: [declaracionJuradaInstance: declaracionJuradaInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [declaracionJuradaInstance: declaracionJuradaInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.documento.DeclaracionJurada.label', default: 'Declaracion Jurada'), declaracionJuradaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def declaracionJuradaInstance = declaracionJuradaService.getDeclaracionJurada(id)
		if (!declaracionJuradaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.DeclaracionJurada.label', default: 'Declaracion Jurada'), id])
			redirect(action: "list")
			return
		}
		String descripcion = declaracionJuradaInstance.descripcion

		try {
			declaracionJuradaService.deleteDeclaracionJurada(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.documento.DeclaracionJurada.label', default: 'Declaracion Jurada'), descripcion], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.documento.DeclaracionJurada.label', default: 'Declaracion Jurada'), descripcion], encodeAs:'none')
			redirect(action: "list")
		}
	}
	
	def ajaxGetDeclaracionesJuradas(String filter){
		def declaracionJuradas = declaracionJuradaService.listDeclaracionJurada(filter,null)
		render declaracionJuradas as JSON
	}
	def ajaxGetDeclaracionesJuradasPresentadasPorCuenta(){
		def declaracionesJuradas = declaracionJuradaService.listDeclaracionesJuradasPresentadasPorCuenta(params.cuentaId)
		render declaracionesJuradas as JSON
	}
	def ajaxGetDeclaracionesJuradasPresentadasPorCuentaEdit(){
		def declaracionesJuradas = declaracionJuradaService.listDeclaracionesJuradasPresentadasPorCuentaEdit(params.cuentaId)
		render declaracionesJuradas as JSON
	}
	
	def ajaxGetDeclaracionJuradaListIIBB(String mes, String ano){
		render declaracionJuradaService.getDeclaracionJuradaListIIBB(ano,mes) as JSON
	}

	@Secured(['permitAll'])
	def ajaxGetDeclaracionesJuradasPorCuenta(String filter, Long cuentaId){
		def declaracionJuradas = declaracionJuradaService.listDeclaracionJurada(filter, cuentaId)
		render declaracionJuradas as JSON
	}

	def ajaxGetDeclaracionJurada(Long id) {
		def declaracionJurada = declaracionJuradaService.getDeclaracionJurada(id)
		render declaracionJurada as JSON
	}

	def ajaxImportar(){
		String nombreArchivo = "-"
		try {
			def archivo = params.'archivo[]'
			nombreArchivo = archivo.originalFilename
			render declaracionJuradaService.importar(archivo) as JSON
		}
		catch(java.lang.AssertionError e){
			def respuesta = [:]
			respuesta['estado'] = e.message.substring(0,e.message.indexOf('..')+1)
			respuesta['nombreArchivo'] = nombreArchivo
			respuesta['cuenta'] = '-'
			respuesta['periodo'] = '-'
			respuesta['tipo'] = '-'
			render respuesta as JSON
		}
		catch(Exception e) {
			def respuesta = [:]
			respuesta['estado'] = "Ocurrió un error importando el archivo."
			respuesta['nombreArchivo'] = nombreArchivo
			respuesta['cuenta'] = '-'
			respuesta['periodo'] = '-'
			respuesta['tipo'] = '-'
			render respuesta as JSON
		}
	}
}
