package com.zifras

import grails.validation.Validateable

class LocalidadCommand implements Validateable {
	Long provinciaId
	Long localidadId
	Long version
	
	String nombre
	
	static constraints = {
		provinciaId nullable:false
		localidadId nullable:true
		version nullable:true
		
		nombre nullable:false
	}
}
