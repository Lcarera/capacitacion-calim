package com.zifras.liquidacion

import grails.validation.Validateable

class LiquidacionIvaMasivaCommand implements Validateable {
	String mes
	String ano
	
	Double porcentajeSaldoDdjj
	Double porcentajeDebitoFiscal
	
	String cuentasIds
	Boolean pisarRetPer = false
	
	static constraints = {
		mes nullable:false
		ano nullable:false
		
		porcentajeSaldoDdjj nullable:false
		porcentajeDebitoFiscal nullable:false
		
		cuentasIds nullable:false
	}
}
