package com.zifras.cuenta

import grails.validation.Validateable

class ActividadCommand implements Validateable {
	Long actividadId
	Long version
	
	String nombre
	String codigo
	String codigoAfip
	String codigoNaes
	String codigoCuacm

	String descripcionAfip
	String descripcionNaes
	String descripcionCuacm

	Double utilidadMaxima
	Double utilidadMinima
	
	static constraints = {
		actividadId nullable:true
		version nullable:true
		
		nombre nullable:false
		codigo nullable:false
		codigoAfip nullable:true
		codigoNaes nullable:true
		codigoCuacm nullable:true

		descripcionAfip nullable:true
		descripcionNaes nullable:true
		descripcionCuacm nullable:true
		
		utilidadMaxima nullable:true
		utilidadMinima nullable:true
	}
}
