package com.zifras.facturacion

import com.zifras.cuenta.Cuenta

import grails.gorm.MultiTenant
class PuntoVenta implements MultiTenant<PuntoVenta> {
	Integer tenantId
	Long numero
	String domicilio
	String localidad

	static belongsTo = [cuenta:Cuenta]

    static constraints = {
    	numero nullable:false, unique:'cuenta'
    	domicilio nullable:true
    	localidad nullable:true
	}

	public String toString(){
		return String.format("%05d", this.numero)
	}
}
