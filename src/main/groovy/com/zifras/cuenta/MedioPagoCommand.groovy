package com.zifras.cuenta
import grails.validation.Validateable;

class MedioPagoCommand implements Validateable{
	
	Long medioPagoId
	Long version

	String nombre
	boolean afip
	boolean agip
	boolean arba

	static constraints = {
		medioPagoId nullable:true
		version nullable:true
	}	
}