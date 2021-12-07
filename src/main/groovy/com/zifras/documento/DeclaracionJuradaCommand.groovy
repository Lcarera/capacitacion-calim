package com.zifras.documento

import grails.validation.Validateable
import org.joda.time.LocalDate

class DeclaracionJuradaCommand implements Validateable{
	Long declaracionJuradaId
	Long version

	Long liquidacionId
	LocalDate fecha
	String descripcion
	Long cuentaId
	String nombreArchivo
	Long estadoId
	
	static constraints = {
		declaracionJuradaId nullable:true
		version nullable:true

		liquidacionId nullable:true
		nombreArchivo nullable:true
		fecha nullable:true
		descripcion nullable:true
		cuentaId nullable:false
		estadoId nullable:true
	}	
}
