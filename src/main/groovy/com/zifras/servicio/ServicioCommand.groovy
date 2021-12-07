package com.zifras.servicio

import grails.validation.Validateable

class ServicioCommand implements Validateable {
	Long servicioId
	Long version

	String nombre
	String codigo
	String subcodigo
	Double precio = 0
	boolean mensual = false
	Long alicuotaId

	static constraints = {
		servicioId nullable:true
		version nullable:true

		subcodigo nullable:true
		precio min: new Double(1)
	}
}
