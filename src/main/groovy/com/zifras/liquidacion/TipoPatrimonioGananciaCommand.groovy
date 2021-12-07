package com.zifras.liquidacion

import grails.validation.Validateable

class TipoPatrimonioGananciaCommand implements Validateable {
	Long tipoPatrimonioGananciaId
	Long version
	
	String nombre
	
	static constraints = {
		tipoPatrimonioGananciaId nullable:true
		version nullable:true
		
		nombre nullable:false
	}
}
