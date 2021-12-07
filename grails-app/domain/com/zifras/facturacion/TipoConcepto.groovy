package com.zifras.facturacion

import grails.gorm.MultiTenant
class TipoConcepto implements MultiTenant<TipoConcepto> {
	Integer tenantId
	String nombre
    static constraints = {
    	nombre nullable:true
    }
}
