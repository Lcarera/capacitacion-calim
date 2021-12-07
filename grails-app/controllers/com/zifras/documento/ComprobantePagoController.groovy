package com.zifras.documento

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.springframework.web.multipart.MultipartFile
import org.springframework.dao.DataIntegrityViolationException
import grails.converters.JSON
import com.zifras.documento.ComprobantePagoCommand
import com.zifras.AccessRulesService

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_COBRANZA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class ComprobantePagoController{
	def comprobantePagoService
	AccessRulesService accessRulesService

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def index() {
		redirect(action: "list", params: params)
	}

	def list(){}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_COBRANZA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def create() {
		def command = comprobantePagoService.createComprobantePagoCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		[comprobantePagoInstance: command]
	}
	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_COBRANZA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def edit(Long id) {
		def comprobantePagoInstance = comprobantePagoService.getComprobantePagoCommand(id)
		if (!comprobantePagoInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.ComprobantePago.label', default: 'Comprobante de Pago'), id])
			redirect(action: "list")
			return
		}

		[comprobantePagoInstance: comprobantePagoInstance]
	}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_COBRANZA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def save(ComprobantePagoCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.documento.ComprobantePagoCommand.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [comprobantePagoInstance: command])
			return
		}
		
		def comprobantePagoInstance
		
		try {
			def archivo = request.getFile('archivo')
			comprobantePagoInstance = comprobantePagoService.saveComprobantePago(command, archivo)
		}catch (e){
			flash.error	= message(code: 'zifras.documento.ComprobantePago.save.error', default: 'Error al intentar salvar el Comprobante de Pago')
			render(view: "create", model: [comprobantePagoInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.documento.ComprobantePago.label', default: 'ComprobantePago'), comprobantePagoInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	@Secured(['ROLE_ADMIN', 'ROLE_LECTURA', 'ROLE_COBRANZA', 'IS_AUTHENTICATED_FULLY'])
	def update(ComprobantePagoCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [comprobantePagoInstance: command])
			return
		}
		
		def comprobantePagoInstance
		
		try {
			def archivo = request.getFile('archivo')
			comprobantePagoInstance = comprobantePagoService.updateComprobantePago(command, archivo)
		}
		catch (ValidationException e){
			comprobantePagoInstance.errors = e.errors
			render(view: "edit", model: [comprobantePagoInstance: comprobantePagoInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [comprobantePagoInstance: comprobantePagoInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.documento.ComprobantePago.label', default: 'Comprobante de Pago'), comprobantePagoInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def comprobantePagoInstance = ComprobantePago.get(id)
		if (!comprobantePagoInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.ComprobantePago.label', default: 'Comprobante de Pago'), id])
			redirect(action: "list")
			return
		}
		String descripcion = comprobantePagoInstance.descripcion

		try {
			comprobantePagoService.deleteComprobantePago(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.documento.ComprobantePago.label', default: 'Comprobante de Pago'), descripcion], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.documento.ComprobantePago.label', default: 'Comprobante de Pago'), descripcion], encodeAs:'none')
			redirect(action: "list")
		}
	}
	

	def ajaxGetComprobantesPago(String filter){
		def comprobantesPago = comprobantePagoService.listComprobantesPago(filter,null)
		render comprobantesPago as JSON
	}

	def ajaxImportar(){
		String nombreArchivo = "-"
		try {
			def archivo = params.'archivo[]'
			nombreArchivo = archivo.originalFilename
			render comprobantePagoService.importar(archivo) as JSON
		}
		catch(java.lang.AssertionError e){
			def respuesta = [:]
			respuesta['nombreArchivo'] = nombreArchivo
			respuesta['cuenta'] = '-'
			respuesta['periodo'] = '-'
			respuesta['tipo'] = '-'
			render respuesta as JSON
		}
		catch(Exception e) {
			def respuesta = [:]
			respuesta['nombreArchivo'] = nombreArchivo
			respuesta['cuenta'] = '-'
			respuesta['periodo'] = '-'
			respuesta['tipo'] = '-'
			render respuesta as JSON
		}
	}

	def download(Long id){
		try {
			def file = comprobantePagoService.getFile(id);
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
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				flash.error="Ocurrió un error inesperado descargando el archivo."
			}
	   		redirect(action: "list")
		}
	}

}