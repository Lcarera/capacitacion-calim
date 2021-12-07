package com.zifras.documento

import org.joda.time.LocalDate;
import grails.validation.Validateable;

class VepCommand implements Validateable{
	
	Long vepId
	Long version

	Long estadoId	
	Long numero
	Long cuentaId
	Double importe
	String descripcion
	LocalDate fechaPago
	LocalDate fechaEmision
	String horaPago
	String nombreArchivo //Para el edit
	
	static constraints = {
		vepId nullable:true
		version nullable:true
		nombreArchivo nullable:true
		horaPago nullable:true
		numero nullable:true
		fechaEmision nullable:true
		fechaPago nullable:true
	}	

}
