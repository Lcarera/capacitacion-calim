package com.zifras.documento

import grails.validation.Validateable
import org.joda.time.LocalDate

class ReciboSueldoCommand implements Validateable{
	Long reciboSueldoId
	Long version

	LocalDate fecha
	Long cuentaId
	String nombreArchivo
	Long localId
	
	static constraints = {
		reciboSueldoId nullable:true
		version nullable:true

		nombreArchivo nullable:true
		fecha nullable:true
		cuentaId nullable:false
		localId nullable:false
	}	
}
