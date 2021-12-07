package com.zifras.ticket

import grails.gorm.MultiTenant
import org.joda.time.LocalDateTime

import com.zifras.cuenta.Cuenta

class Mensaje implements MultiTenant<Mensaje> {
	Integer tenantId

	String asunto
	String mensaje
	LocalDateTime fechaHora

	static belongsTo = [remitente: Cuenta]
	
	static constraints = {
		mensaje maxSize:2048
	}

	public String toString() {
		return 
	}

}
