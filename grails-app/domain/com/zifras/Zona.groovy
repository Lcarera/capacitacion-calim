package com.zifras

import grails.gorm.MultiTenant
class Zona implements MultiTenant<Zona> {
	Integer tenantId
	String nombre
	
    static constraints = {
		nombre nullable:false
    }
	
	public String toString() {
		return nombre
	}
}
