package com.zifras.cuenta

class CondicionIva {
	String nombre

    static constraints = {
		nombre nullable:false
    }
	
	public String toString() {
		return nombre
	}
}
