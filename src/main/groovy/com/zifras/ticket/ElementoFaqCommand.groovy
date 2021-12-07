package com.zifras.ticket

import grails.validation.Validateable;

class ElementoFaqCommand implements Validateable{
	Long elementoId
	Long version

	String titulo
	String contenidoHtml
	Long peso
	Long categoriaFaqId
	boolean monotributista
	boolean respInscripto
	boolean regimenSimplificado
	boolean convenio
	boolean local
	
	static constraints = {
		elementoId nullable:true
		version nullable:true
	}	
}
