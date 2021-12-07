package com.zifras.security
import grails.plugin.springsecurity.SpringSecurityUtils
import com.zifras.User
import grails.validation.Validateable

class RegisterCommand implements Validateable {

	String cuit
	String nombre
	String apellido
	String razonSocial
	String tipo
	String localidad
	String domicilio
	String tipoIva

	String celular

	String actividad
	String categoria

	String impuestos
	
	String username
	String password
	String password2

	Long idExistente

	def grailsApplication

	static constraints = {
		username blank: false, email:true, validator: { value, command ->
			if (value) {
				def User = command.grailsApplication.getDomainClass(
					SpringSecurityUtils.securityConfig.userLookup.userDomainClassName).clazz
				if (User.findByUsername(value)) {
					return 'registerCommand.username.unique'
				}
			}
		}
		password blank: false, minSize: 8, maxSize: 64
		password2 blank: false, minSize: 8, maxSize: 64, validator: {value, command ->
			if (value) {
					if (value != command.password) {
							return 'sismagro.register.passwordRepeat.invalid'
					}
			}
		}
		cuit nullable:true
		nombre nullable:true
		apellido nullable:true
		razonSocial nullable:true
		tipo nullable:true
		localidad nullable:true
		domicilio nullable:true
		tipoIva nullable:true

		actividad nullable:true
		categoria nullable:true
		idExistente nullable:true

		impuestos nullable:true
		celular nullable:true
	}
}