package com.zifras.documento
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.springframework.web.multipart.MultipartFile
import org.springframework.dao.DataIntegrityViolationException
import org.joda.time.LocalDate
import grails.converters.JSON

import com.zifras.cuenta.Cuenta
import com.zifras.documento.ReciboSueldoService
import com.zifras.cuenta.Local



class ReciboSueldoController{

	def reciboSueldoService

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def index() {
		redirect(action: "list", params: params)
	}
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def list() {
		LocalDate hoy = new LocalDate().minusMonths(1)
		Cuenta primeraCuenta = Cuenta.first()
		[ano:hoy.toString("YYYY"), mes:hoy.toString("MM"), cuentaId: primeraCuenta.id]
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def show(Long id, Integer cantRecibos, String ano, String mes) {
		def localInstance = Local.get(id)
		if (!localInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Local.label', default: 'Local'), id])
			redirect(action: "list")
			return
		}
		LocalDate periodo = new LocalDate(ano + "-" + mes + "-01")
		def recibosDelMes = reciboSueldoService.recibosCargados(localInstance,periodo)
		[localInstance: localInstance, cantidadRecibosCargados: cantRecibos, ano:ano, mes:mes, recibosDelMes:recibosDelMes]
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def delete(Long id){
		def localInstance = Local.get(id)
		if (!localInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.ReciboSueldo.label', default: 'Recibo Sueldo')])
			redirect(action: "list")
			return
		}
		try {
			reciboSueldoService.deleteRecibosDelLocal(localInstance)
			flash.message = message(code: 'default.deletedMany.message', args: [message(code: 'zifras.documento.ReciboSueldo.label', default: 'Recibos de Sueldo')], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.documento.ReciboSueldo.label', default: 'Recibo Sueldo')], encodeAs:'none')
			redirect(action: "list")
		}
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLocales(String mes, String ano){
		def respuesta = reciboSueldoService.generarLocales(mes, ano)
		render respuesta as JSON
	}

	def save(ReciboSueldoCommand command){
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.documento.ReciboSueldoCommand.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [reciboSueldoInstance: command])
			return
		}
		
		def declaracionJuradaInstance
		
		try {
			def archivo = request.getFile('archivo')
			reciboSueldoInstance = reciboSueldoService.saveReciboSueldo(command, archivo)
		}catch (e){
			flash.error	= message(code: 'zifras.documento.ReciboSueldo.save.error', default: 'Error al intentar salvar el Recibo de Sueldo')
			render(view: "create", model: [reciboSueldoInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.documento.ReciboSueldo.label', default: 'Recibo de Sueldo'), reciboSueldoInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxImportar(){
		String nombreArchivo = "-"
		try {
			def archivo = params.'archivo[]'
			nombreArchivo = archivo.originalFilename
			render reciboSueldoService.importar(archivo) as JSON
		}
		catch(java.lang.AssertionError e){
			def respuesta = [:]
			respuesta['nombreArchivo'] = nombreArchivo
			respuesta['cuenta'] = e.message.substring(0,e.message.indexOf('..')+1)
			respuesta['numeroLocal'] = '-'
			respuesta['periodo'] = '-'
			respuesta['idEmpleado'] = '-'

			render respuesta as JSON
		}
		catch(Exception e) {
			def respuesta = [:]
			respuesta['nombreArchivo'] = nombreArchivo
			respuesta['cuenta'] = 'Error al importar el archivo'
			respuesta['numeroLocal'] = '-'
			respuesta['periodo'] = '-'
			respuesta['idEmpleado'] = '-'

			render respuesta as JSON
		}
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def download(Long id){
		try {
			def file = reciboSueldoService.getFile(id);
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