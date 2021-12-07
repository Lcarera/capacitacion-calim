package com.zifras.ventas

import org.joda.time.LocalDate

class VendedorDiaExtra{
	
	LocalDate fecha
	Vendedor vendedor
	String detalle

	static constraints = {
		fecha nullable:false
		vendedor nullable:true
		detalle nullable:true
	}
}