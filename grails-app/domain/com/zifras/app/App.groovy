package com.zifras.app

import com.zifras.cuenta.Cuenta
import grails.gorm.MultiTenant
import com.zifras.cuenta.Domicilio
import com.zifras.facturacion.Persona

class App implements MultiTenant<App> {

	Integer tenantId
	
	Persona persona
	String nombre
	String logo

	static constraints = {
		nombre nullable:false
		logo nullable:true
		persona nullable:true
	}

	static hasMany = [cuentas:ItemApp]

	public String toString(){
		return this.nombre
	}

	static mapping = {
        sort id:"asc"
    }
}