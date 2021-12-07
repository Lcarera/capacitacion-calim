package com.zifras.documento

import grails.plugin.springsecurity.annotation.Secured;
import org.springframework.web.multipart.MultipartFile
import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException
import org.joda.time.LocalDate;

import grails.converters.JSON

import com.zifras.Localidad
import com.zifras.Provincia;
import com.zifras.cuenta.CondicionIva
import com.zifras.cuenta.RegimenIibb
import com.zifras.cuenta.Cuenta
import com.zifras.Estado
import com.zifras.AccessRulesService

@Secured(['ROLE_CUENTA', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class DeclaracionJuradaUsuarioController {
	def declaracionJuradaService
	AccessRulesService accessRulesService

	def index() {
		redirect(action: "list", params: params)
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

	def list() {
		def cuenta = accessRulesService.getCurrentUser().cuenta?.id
		[cuentaId: cuenta]
	}
	
}
