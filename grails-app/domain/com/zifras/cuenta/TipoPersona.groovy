package com.zifras.cuenta

class TipoPersona {
	String nombre
	
	static constraints = {
		nombre nullable:false
	}
	
	public String toString() {
		return nombre
	}
}
