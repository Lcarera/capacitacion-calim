package com.zifras

import grails.gorm.MultiTenant
class Localidad implements MultiTenant<Localidad> {
	Integer tenantId
	String nombre
	
	static belongsTo = [provincia:Provincia]

    static constraints = {
		nombre nullable:false
    }
	
	public String toString() {
		return nombre
	}
}
