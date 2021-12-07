package com.zifras.liquidacion

import grails.validation.Validateable

class RangoImpuestoGananciaCommand implements Validateable {
	Long rangoImpuestoGananciaId
	Long version
	
	String ano
	
	Double desde
	Double hasta
	
	Double fijo
	Double porcentaje
	
	static constraints = {
		rangoImpuestoGananciaId nullable:true
		version nullable:true
		
		ano nullable:false
		
		desde nullable:false
		hasta nullable:true
		
		fijo nullable:false
		porcentaje nullable:false
	}
}
