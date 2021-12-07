package com.zifras.ticket

import grails.validation.Validateable;

class CategoriaFaqCommand implements Validateable{
	Long categoriaId
	Long version

	String nombre
	Long peso

	static constraints = {
		categoriaId nullable:true
		version nullable:true
	}	
}
