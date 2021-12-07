package com.zifras

import grails.validation.Validateable

class ZonaCommand implements Validateable {
	Long zonaId
	Long version
	
	String nombre
	
	static constraints = {
		zonaId nullable:true
		version nullable:true
		
		nombre nullable:false
	}
}
