package com.zifras.cuenta

import grails.validation.Validateable

class RegimenIibbCommand implements Validateable {
	Long regimenIibbId
	Long version
	
	String nombre
	
	static constraints = {
		regimenIibbId nullable:true
		version nullable:true
		
		nombre nullable:false
	}
}
