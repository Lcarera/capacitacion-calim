package com.zifras.documento

import org.joda.time.LocalDate;
import grails.validation.Validateable;

class FacturaCuentaCommand implements Validateable{
	Long facturaCuentaId
	Long version

	LocalDate fecha
	String descripcion
	Long cuentaId
	Long localId
	Double importe
	String nombreArchivo
	String hora
	
	static constraints = {
		facturaCuentaId nullable:true
		version nullable:true
		localId nullable:true
		nombreArchivo nullable:true

		fecha nullable:true
		hora nullable:true
		descripcion nullable:true
		cuentaId nullable:false
		importe nullable:false
	}	
}
