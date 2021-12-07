package com.zifras.cuenta

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.zifras.AccessRulesService

import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_CUENTA', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class MiCuentaController {
	def cuentaService
	def facturaCuentaService
	def movimientoCuentaService
	AccessRulesService accessRulesService

    def index() {
		redirect(action: "show", params: params)
	}

	def show() {
		def saldo = accessRulesService.getCurrentUser()?.cuenta?.saldo ?: 0.0

		[saldo:saldo]
	}

	def ajaxGetMovimientosList(Long cuentaId){
		def currentUser = accessRulesService.getCurrentUser()
		def movimientos = []
		if(cuentaId || currentUser.cuenta!=null){
			movimientos = movimientoCuentaService.listmovimientoCuenta(cuentaId ?: currentUser.cuenta.id)
		}

		render movimientos as JSON
	}

	def ajaxGetFacturasList(){
		def currentUser = accessRulesService.getCurrentUser()
		def facturas = []
		if(currentUser.cuenta!=null)
			facturas = cuentaService.listFacturasCuenta(currentUser.cuenta.id)
			
		render facturas as JSON
	}

	def ajaxGetFacturasPorCuenta(Long id){
		def facturas = []
		facturas = cuentaService.listFacturasCuenta(id)
			
		render facturas as JSON
	}

	def downloadFactura(Long id){
		try {
			def file = facturaCuentaService.getFile(id);
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
	   		redirect(action: "show")
		}
	}
}
