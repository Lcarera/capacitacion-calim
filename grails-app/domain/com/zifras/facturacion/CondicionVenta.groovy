package com.zifras.facturacion

import com.zifras.cuenta.Cuenta

import grails.gorm.MultiTenant
class CondicionVenta implements MultiTenant<CondicionVenta> {
	Integer tenantId
	Long numero
	String nombre

	static constraints = {
    	numero nullable:true
    	nombre nullable:false
	}
}
