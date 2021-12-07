package com.zifras

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityUtils
import org.joda.time.LocalDate

import com.zifras.UsuarioService
import com.zifras.UsuarioCommand
import grails.validation.ValidationException

import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class UsuarioController {
	def usuarioService
	def springSecurityService	
    
    def index() {
		redirect(action: "list", params: params)
	}

	def list() {
		[conCuenta: false]
	}

	def listCuentas(){
		render(view: "list", model: [conCuenta: true])
	}
	
	def create() {
		def command = usuarioService.createUsuarioCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[usuarioInstance: command]
	}

	def save(UsuarioCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.Usuario.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [usuarioInstance: command])
			return
		}
		
		def usuarioInstance
		
		try {
			usuarioInstance = usuarioService.saveUsuario(command)
		}catch (e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error	= message(code: 'zifras.Usuario.save.error', default: 'Error al intentar salvar el usuario')
			render(view: "create", model: [usuarioInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.Usuario.label', default: 'Usuario'), usuarioInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS', 'IS_AUTHENTICATED_FULLY'])
	def show(Long id, String mes, String ano) {
		def usuarioInstance = usuarioService.getUsuario(id)
		def fecha = mes && ano ? new LocalDate(ano + '-' + mes + '-01') : new LocalDate().withDayOfMonth(1).minusMonths(1)
		if (!usuarioInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.Usuario.label', default: 'Usuario'), id])
			redirect(action: "list")
			return
		}

		[usuarioInstance: usuarioInstance,mes:fecha.toString("MM"), ano:fecha.toString("yyyy"),usuarioId:usuarioInstance.id]
	}

	@Secured(['ROLE_CUENTA','ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxUpdatePassword(Long userId, String password, String password2, String  passwordViejo) {
		def resultado = [:]
		try {
			usuarioService.changePassword(userId, password, password2, passwordViejo)
		}
		catch (e){
			switch(e.message){
				case 'larga':
					resultado['error'] = "La nueva contraseña debe tener menos de 64 caracteres."
					break
				case 'corta':
					resultado['error'] = "La nueva contraseña debe tener 8 o más caracteres."
					break
				case 'nuevas':
					resultado['error'] = "Las contraseñas ingresadas no coinciden."
					break
				case 'regex':
					resultado['error'] = "La contraseña ingresada contiene caracteres inválidos."
					break
				case 'permiso':
					resultado['error'] = "Sólo puedes modificar la contraseña de tu propia cuenta."
					break
				case 'vieja':
					resultado['error'] = "La contraseña actual es incorrecta."
					break
				default:
					resultado['error'] = "Ocurrió un error al cambiar la contraseña."
					break
			}
		}
		render resultado as JSON
	}

	def edit(Long id) {
		def usuarioInstance = usuarioService.getUsuarioCommand(id)
		if (!usuarioInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.Usuario.label', default: 'Usuario'), id])
			redirect(action: "list")
			return
		}

		[usuarioInstance: usuarioInstance]
	}

	def update(UsuarioCommand command) {
		if (command.hasErrors()) {
			render(view: "edit", model: [usuarioInstance: command])
			return
		}
		
		def usuarioInstance
		
		try {
			usuarioInstance = usuarioService.updateUsuario(command)
		}
		catch (ValidationException e){
			usuarioInstance.errors = e.errors
			render(view: "edit", model: [usuarioInstance: usuarioInstance])
			return
		}
		catch (e) {
			flash.error = e.toString()
			render(view: "edit", model: [usuarioInstance: usuarioInstance])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.Usuario.label', default: 'Usuario'), usuarioInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}
	
	def delete(Long id) {
		def usuarioInstance = usuarioService.getUsuario(id)
		if (!usuarioInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.Usuario.label', default: 'Usuario'), id])
			redirect(action: "list")
			return
		}
		String nombre = usuarioInstance.username

		try {
			usuarioService.deleteUsuario(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.Usuario.label', default: 'Usuario'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.Usuario.label', default: 'Usuario'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
	}

	@Secured(['ROLE_ADMIN', 'ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
	def cambiarTenant(){
		usuarioService.cambiarTenant()
		redirect(controller: 'logout', action: "index")
	}

	def ajaxBloquearDesbloquear(Long id){
		render usuarioService.bloquearDesbloquear(id) as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetUsuarios(Boolean conCuenta){
		def usuarios = usuarioService.listUsuario(conCuenta)
		render usuarios as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetAdmins(){
		render usuarioService.listAdmins() as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetUsuario(Long id) {
		def usuario = usuarioService.getUsuario(id)
		render usuario as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetRolesBackoffice(){
		def roles = usuarioService.listRolesBackoffice()
		render roles as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetRoles(){
		def roles = usuarioService.listRoles()
		render roles as JSON
	}
	
	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetRol(Long id) {
		def rol = usuarioService.getRol(id)
		render rol as JSON
	}

	def resetPassword(Long id) {
		String mensaje = 'Su contraseña ha sido reiniciada por un administrador. <br/><br/> Para generar una nueva, haga click aqui: '
		String asunto = 'Calim: Reseteo de contraseña'
		usuarioService.enviarMailReseteoPassword(id)
		redirect(action: "show", params: ['id': id])
	}
}
