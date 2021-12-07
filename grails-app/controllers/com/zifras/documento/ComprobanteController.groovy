package com.zifras.documento

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.springframework.web.multipart.MultipartFile
import org.springframework.dao.DataIntegrityViolationException
import grails.converters.JSON
import com.zifras.AccessRulesService
import com.zifras.importacion.ImportacionService


@Secured(['ROLE_CUENTA','ROLE_USER', 'ROLE_ADMIN','ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class ComprobanteController{
	def comprobanteService
	def importacionService
	AccessRulesService accessRulesService

	def list(){
		def cuentaId = accessRulesService.getCurrentUser()?.cuenta.id
		[cuentaId:cuentaId]
	}

	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def eliminar(Long id){
		def cuentaId = comprobanteService.eliminar(id)
		flash.message = "El comprobante se ha eliminado."
		redirect(controller:'cuenta', action:'show', id:cuentaId)
	}

	def show(Long comprobanteId){
		def comprobanteInstance = comprobanteService.getVep(id)
		if (!comprobanteInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.Comprobante.label', default: 'Comprobante'), id])
			redirect(controller:"cuenta",action: "list",)
			return
		}

		[comprobanteInstance: comprobanteInstance]
	}

	def descargarComprobante(Long id){
		try {
			def file = comprobanteService.getFile(id);
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


	def listApp() {
		def cuenta = accessRulesService.getCurrentUser()?.cuenta
		def comprobantes = comprobanteService.listComprobantes(cuenta.id)
		render comprobantes as JSON
		return
	}

	def ajaxImportarComprobante(){
		String nombreArchivo = "-"
		
			def archivo = params.'comprobante[]'
			nombreArchivo = archivo.originalFilename
			render importacionService.importacionComprobante(params.tipoComprobante.toUpperCase(),new Long(params.cuentaId),archivo) as JSON
	}

	def ajaxGetTiposComprobante(){
		def tipos = comprobanteService.listTiposComprobante()
		def rta = []
		tipos.each{
			def item = [:]
			item['nombre'] = it.toString()
			rta.push(item)
		}
		render rta as JSON
	}

	def ajaxGetComprobantesPorCuenta(Long cuentaId){
		def comprobantes = comprobanteService.listComprobantes(cuentaId)
		render comprobantes as JSON
	}
}