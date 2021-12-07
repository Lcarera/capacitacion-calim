package com.zifras

import grails.validation.Validateable

class UsuarioCommand implements Validateable {
	Long usuarioId
	Long version
	Integer userTenantId

	String username
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	
	Long cuentaId
	Long roleId
	
	static constraints = {
		version nullable:true
		usuarioId nullable:true
		username nullable:false
		enabled nullable:true
		accountExpired nullable:true
		accountLocked nullable:true
		passwordExpired nullable:true
		
		roleId nullable:true
		cuentaId nullable:true
	}
}
