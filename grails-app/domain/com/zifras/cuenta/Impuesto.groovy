package com.zifras.cuenta

class Impuesto {
	String nombre
	
	static constraints = {
		nombre nullable:false
	}
	
	public String toString() {
		return nombre
	}
}
