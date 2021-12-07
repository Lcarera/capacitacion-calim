package com.zifras.cuenta

class Categoria {
	String nombre
	
	static constraints = {
		nombre nullable:false
	}
	
	public String toString() {
		return nombre
	}
}
