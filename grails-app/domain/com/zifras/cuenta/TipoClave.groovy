package com.zifras.cuenta

class TipoClave {
	String nombre
	
	static constraints = {
		nombre nullable:false
	}
	
	public String toString() {
		return nombre
	}
}
