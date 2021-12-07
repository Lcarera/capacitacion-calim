package com.zifras.liquidacion

import grails.validation.Validateable

class LiquidacionIvaAutomaticaCommand implements Validateable {
	String mes
	String ano
	
	Long cunetaId
	
	static constraints = {
		mes nullable:false
		ano nullable:false
		
		cunetaId nullable:false
	}
}
