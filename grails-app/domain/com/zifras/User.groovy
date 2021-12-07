package com.zifras

import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.Role
import com.zifras.UserRole
import com.zifras.cuenta.Cuenta
import com.zifras.ventas.Vendedor

import grails.compiler.GrailsCompileStatic
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@GrailsCompileStatic
@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User {
	
	private static final long serialVersionUID = 1

	String username
	String password
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	Cuenta cuenta

	Boolean redSocial = false
	String fotoUrl
	
	Integer userTenantId // 0: Nuevo // 1: Zifras // 2: Calim
	
	static hasMany = [oAuthIDs: OAuthID]

	static constraints = {
		username blank: false, unique: true, email:true
		password blank: false
		cuenta nullable:true
		redSocial nullable:true
		fotoUrl nullable:true
	}
	
	static mapping = {
		table 'users'
		cuenta index: 'users_cuenta_index'
		password column: '`password`'
	}

	public boolean cuentaSinVerificar(){	this.cuenta.estado.nombre == 'Sin verificar'	}

	public boolean getEsCalim(){
		return this.userTenantId.toString() == Estudio.findByNombre("Calim").id.toString()
}

	Set<Role> getAuthorities() {
        (UserRole.findAllByUser(this) as List<UserRole>)*.role as Set<Role>
    }
	
	public boolean hasRole(String roleBuscado){
		def role = Role.findByAuthority(roleBuscado)
		def userRole = UserRole.findByUserAndRole(this, role)
		return userRole ? true : false
	}

   	public Integer miTenantId() {
		return userTenantId;
	}

	public boolean tieneCuenta(){
		if(cuenta!=null)
			return true

		return false
	}

	public Vendedor getVendedor(){ Vendedor.findByEmail(username) }
}
