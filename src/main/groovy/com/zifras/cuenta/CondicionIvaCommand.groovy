package com.zifras.cuenta

import grails.validation.Validateable

class CondicionIvaCommand implements Validateable {
	Long condicionIvaId
	Long version
	
	String nombre
	
	static constraints = {
		condicionIvaId nullable:true
		version nullable:true
		
		nombre nullable:false
	}
}
