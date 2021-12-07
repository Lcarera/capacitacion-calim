package com.zifras.documento

import grails.validation.Validateable
import org.joda.time.LocalDate

class ComprobantePagoCommand implements Validateable{
	Long comprobantePagoId
	Long version

	LocalDate fecha
	String descripcion
	Long cuentaId
	String nombreArchivo
	Double importe
	Long declaracionId
	
	static constraints = {
		comprobantePagoId nullable:true
		version nullable:true

		nombreArchivo nullable:true
		fecha nullable:true
		descripcion nullable:true
		cuentaId nullable:false
		importe nullable:false
	}	
}
