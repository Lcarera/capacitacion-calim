package com.zifras.facturacion

import grails.gorm.MultiTenant
class ComprobanteAsociado implements MultiTenant<ComprobanteAsociado> {
	
	Integer tenantId
	Long comprobanteId
	String nombre

    static constraints = {
    	nombre nullable:true
    	comprobanteId nullable:true
    }
}
