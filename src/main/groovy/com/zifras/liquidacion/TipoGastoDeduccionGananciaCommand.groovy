package com.zifras.liquidacion

import grails.validation.Validateable

class TipoGastoDeduccionGananciaCommand implements Validateable {
	Long tipoGastoDeduccionGananciaId
	Long version
	
	String nombre
	
	static constraints = {
		tipoGastoDeduccionGananciaId nullable:true
		version nullable:true
		
		nombre nullable:false
	}
}
