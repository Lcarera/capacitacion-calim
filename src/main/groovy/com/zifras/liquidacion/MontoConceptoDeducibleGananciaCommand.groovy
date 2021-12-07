package com.zifras.liquidacion

import grails.validation.Validateable

class MontoConceptoDeducibleGananciaCommand implements Validateable {
	Long montoConceptoDeducibleGananciaId
	Long version
	
	String ano
	Long concepto
	Double valor
	
	static constraints = {
		montoConceptoDeducibleGananciaId nullable:true
		version nullable:true
		
		ano nullable:false
		concepto nullable:false
		valor nullable:false
	}
}
