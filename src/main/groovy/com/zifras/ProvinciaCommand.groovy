package com.zifras

import grails.validation.Validateable

class ProvinciaCommand implements Validateable {
	Long provinciaId
	Long version
	
	String nombre
	
	static constraints = {
		provinciaId nullable:true
		version nullable:true
		
		nombre nullable:false
	}
}
