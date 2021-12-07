package com.zifras.documento

import org.joda.time.LocalDate;
import grails.validation.Validateable;

class PagoCuentaCommand implements Validateable{
	
	Long pagoCuentaId
	Long version

	Long estadoId	
	Long cuentaId
	Double importe
	String descripcion
	LocalDate fechaPago
	String horaPago
	String nombreArchivo
	
	static constraints = {
		pagoCuentaId nullable:true
		version nullable:true
		nombreArchivo nullable:true
		descripcion nullable:true
	}	
}
