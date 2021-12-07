package com.zifras

import grails.gorm.MultiTenant
class Contador implements MultiTenant<Contador> {
	Integer tenantId
	String nombreApellido
	String cuit
	String matricula
	String email
	String whatsapp
	String foto
	
    static constraints = {
		matricula nullable:true
		email nullable:true
		foto nullable:true
		whatsapp nullable:true
    }
	
	public String toString() {
		return nombreApellido
	}
}
