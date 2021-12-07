package com.zifras.facturacion

import grails.gorm.MultiTenant
class UnidadMedida implements MultiTenant<UnidadMedida> {
	Integer tenantId
	String nombre
	Long medidaAfipId
	
    static constraints = {
    	nombre nullable:true
		medidaAfipId nullable:true
    }
}
