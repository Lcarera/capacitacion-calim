package com.zifras.descuento

import grails.validation.Validateable

class CodigoDescuentoCommand implements Validateable {
	Long cantidad
	Long vendedorId
	String fechaExpiracion
	Double descuento
	String detalle = ""

	static constraints = {
		cantidad nullable:false
		vendedorId nullable:true
		fechaExpiracion nullable:false
		descuento nullable:true
		detalle nullable:true
	}
}
