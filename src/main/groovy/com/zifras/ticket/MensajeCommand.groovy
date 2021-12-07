package com.zifras.ticket

import grails.validation.Validateable;

class MensajeCommand implements Validateable{
	Long mensajeId
	Long version

	String asunto
	String mensaje
	
	static constraints = {
		mensajeId nullable:true
		version nullable:true
	}	
}
