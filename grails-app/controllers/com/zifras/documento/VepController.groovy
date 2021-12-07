package com.zifras.documento

import com.zifras.cuenta.Cuenta
import com.zifras.selenium.SeleniumService

import grails.converters.JSON
import com.zifras.AccessRulesService
import grails.plugin.springsecurity.annotation.Secured;
import grails.validation.ValidationException
import org.joda.time.LocalDate;
import org.springframework.dao.DataIntegrityViolationException


@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class VepController {
	def vepService
	def seleniumService
	AccessRulesService accessRulesService

	def index() {
		redirect(action: "list", params: params)
	}

	def create() {
		/*def command = vepService.createVepCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[vepInstance: command]*/
		redirect(action:'panel')
	}

	def subirPorLiquidacion(Long cuentaId, boolean esIva, Long liqId){
		try {
			vepService.savePorLiquidacion(liqId, esIva, request.getFile('archivo'))
			flash.message = "VEP adjuntado exitosamente, se envió un mail al cliente."
		}
		catch(Exception e) {
			flash.error = "No pudo subirse el VEP a la declaración."
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		redirect(controller:'cuenta', action:"show", id:cuentaId)
	}

	def createVolanteSimplificado(Long cuentaId) {
		def command = vepService.createVepCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[vepInstance: command, cuentaId:cuentaId]
	}

	def save(VepCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.vep.VepCommand.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [vepInstance: command])
			return
		}
		
		def vepInstance
		
		try {
			def archivo = request.getFile('archivo')
			vepInstance = vepService.saveVep(command,archivo,false)
		}catch (e){
			flash.error	= message(code: 'zifras.vep.Vep.save.error', default: 'Error al intentar salvar el VEP')
			render(view: "create", model: [vepInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.vep.Vep.label', default: 'Vep'), vepInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	def saveVolanteSimplificado(VepCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.vep.VepCommand.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [vepInstance: command])
			return
		}
		
		def vepInstance
		
		try {
			def archivo = request.getFile('archivo')
			vepInstance = vepService.saveVep(command,archivo,true)
		}catch (e){
			flash.error	= message(code: 'zifras.vep.Vep.save.error', default: 'Error al intentar salvar el VEP')
			render(view: "createVolanteSimplificado", model: [vepInstance: command, cuentaId: command.cuentaId])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.vep.Vep.label', default: 'Vep'), vepInstance.toString()], encodeAs:'none')
		redirect(controller:"cuenta", action: "show", params:['id':command.cuentaId])
	}

	def list() {
	}

	def panel() {
		LocalDate hoy = new LocalDate().minusMonths(1)
		Cuenta primeraCuenta = Cuenta.first()
		[ano: hoy.toString("YYYY"), mes:hoy.toString("MM"), cuentaId: primeraCuenta.id]
	}

	def show(Long id) {
		def vepInstance = vepService.getVep(id)
		if (!vepInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.vep.Vep.label', default: 'Vep'), id])
			redirect(action: "list")
			return
		}

		[vepInstance: vepInstance]
	}

	def edit(Long id) {
		def vepInstance = vepService.getVepCommand(id)
		if (!vepInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.vep.Vep.label', default: 'Vep'), id])
			redirect(action: "list")
			return
		}

		[vepInstance: vepInstance]
	}

	def editVolanteSimplificado(Long id) {
		def vepInstance = vepService.getVepCommand(id)
		if (!vepInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.vep.Vep.label', default: 'Vep'), id])
			redirect(action: "list")
			return
		}

		[vepInstance: vepInstance, cuentaId:vepInstance.cuentaId]
	}

	def update(VepCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [vepInstance: command])
			return
		}
		
		def vepInstance
		
		try {
			def archivo = request.getFile('archivo')
			vepInstance = vepService.updateVep(command,archivo,false)
		}
		catch (ValidationException e){
			vepInstance.errors = e.errors
			render(view: "edit", model: [vepInstance: vepInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [vepInstance: vepInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.vep.Vep.label', default: 'Vep'), vepInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def updateVolanteSimplificado(VepCommand command) {
		if (command.hasErrors()) {
			render(view: "editVolanteSimplificado", model: [vepInstance: command])
			return
		}
		
		def vepInstance
		
		try {
			def archivo = request.getFile('archivo')
			vepInstance = vepService.updateVep(command,archivo,true)
		}
		catch (ValidationException e){
			vepInstance.errors = e.errors
			render(view: "editVolanteSimplificado", model: [vepInstance: vepInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "editVolanteSimplificado", model: [vepInstance: vepInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.vep.Vep.label', default: 'Vep'), vepInstance.toString()], encodeAs:'none')
		redirect(controller:"cuenta" ,action: "show", params:[id:command.cuentaId])
	}
	def delete(Long id, Long cuentaId) {
		def vepInstance = vepService.getVep(id)
		if (!vepInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.vep.Vep.label', default: 'Vep'), id])
			redirect(action: "list")
			return
		}
		def tipo = vepInstance.tipo.nombre
		
		String display = tipo == "Simplificado" ? vepInstance.descripcion : vepInstance.numero

		try {
			vepService.deleteVep(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.vep.Vep.label', default: 'Vep'), display], encodeAs:'none')
			if(tipo == "Simplificado")
				redirect(controller:"cuenta", action:"show", params:[id: cuentaId])
			else
				redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.vep.Vep.label', default: 'Vep'), display], encodeAs:'none')
			redirect(action: "list")
		}
	}

	@Secured(['ROLE_CUENTA', 'ROLE_USER', 'ROLE_SM', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def download(Long id){
		try {
			def file = vepService.getFile(id);
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
			else if(e.message=="vencido"){
				try {
					Long nuevoId = 1212
					redirect(action:'download', id:nuevoId)
				}
				catch(java.lang.AssertionError e2) {
					vepService.notificarVepVencido(id, e.message.split("finerror")[0])
					render(view:'/notificacion/desactivarNotificaciones', model:[mensaje:'El VEP que intestaste descargar está vencido, ¡pero no te preocupes! Dentro de las próximas 24 horas hábiles te generaremos uno nuevo o nos pondremos en contacto.'])
				}
				return
			}
			else{
				flash.error="Ocurrió un error inesperado descargando el archivo."
				println "Error:"
				println e
				println ""
			}
			if(accessRulesService.getCurrentUser()?.hasRole("ROLE_CUENTA"))
				redirect(controller: "dashboard")
			else
				redirect(action:"panel")
		}
	}

	def ajaxImportar(){
		String nombreArchivo = "-"
		try {
			def archivo = params.'archivo[]'
			nombreArchivo = archivo.originalFilename
			render vepService.importar(archivo) as JSON
		}
		catch(java.lang.AssertionError e){
			def respuesta = [:]
			respuesta['nombreArchivo'] = nombreArchivo
			respuesta['cuenta'] = e.message.substring(0,e.message.indexOf('..')+1)
			respuesta['descripcion'] = '-'
			respuesta['periodo'] = '-'
			respuesta['fechaEmision'] = '-'

			render respuesta as JSON
		}
		catch(Exception e) {
			def respuesta = [:]
			respuesta['nombreArchivo'] = nombreArchivo
			respuesta['cuenta'] = 'Error al importar el archivo'
			respuesta['numeroLocal'] = '-'
			respuesta['periodo'] = '-'
			respuesta['fechaEmision'] = '-'

			render respuesta as JSON
		}
	}

	
	def ajaxGetVeps(String filter){
		def veps = vepService.listVep(filter,null)
		render veps as JSON
	}

	@Secured(['permitAll'])
	def ajaxGetVolantesSimplificado(Long cuentaId){
		def veps = vepService.listVolantes(cuentaId)
		render veps as JSON
	}
	
	@Secured(['permitAll'])
	def ajaxGetVepsPorCuenta(String filter, Long cuentaId){
		def veps = vepService.listVep(filter, cuentaId)
		render veps as JSON
	}
	
	@Secured(['permitAll'])
	def ajaxGetVepsPorCuentaNoPagos(Long cuentaId){
		def veps = vepService.listVepNoPagados(cuentaId)
		render veps as JSON
	}

	def ajaxGetVep(Long id) {
		def vep = vepService.getVep(id)
		render vep as JSON
	}

	def ajaxGenerarMatriz(String mes, String ano){
		render vepService.generarMatrizImportaciones(mes,ano) as JSON
	}
	
}
