package com.zifras.cuenta

class RegimenIibb {
	String nombre
	
    static constraints = {
		nombre nullable:false
    }
	
	public String toString() {
		return nombre
	}
}
