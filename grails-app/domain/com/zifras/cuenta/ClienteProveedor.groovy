package com.zifras.cuenta
import com.zifras.facturacion.Persona

import grails.gorm.MultiTenant
class ClienteProveedor implements MultiTenant<ClienteProveedor> {
	Integer tenantId
	Persona persona

	boolean proveedor = false
	boolean cliente = false
	String email
	String alias
	String nota

	static belongsTo = [cuenta:Cuenta]
	
    static constraints = {
		persona nullable:false, unique: 'cuenta'
		alias nullable:true
		nota nullable:true
		email nullable:true
    }
}
