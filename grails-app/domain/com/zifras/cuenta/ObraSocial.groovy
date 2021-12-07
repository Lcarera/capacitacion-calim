package com.zifras.cuenta

class ObraSocial{
	
	String nombre
	String codigo
	String sigla

	static constraints = {
		sigla nullable:true
	}

	public String toString(){
		return this.sigla ?: this.nombre
	}
}