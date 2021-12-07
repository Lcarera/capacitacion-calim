package com.zifras

import grails.validation.Validateable

class EstadoCommand implements Validateable {
	Long estadoId
	Long version
	
	String nombre
	
	static constraints = {
		estadoId nullable:true
		version nullable:true
		
		nombre nullable:false
	}
}
