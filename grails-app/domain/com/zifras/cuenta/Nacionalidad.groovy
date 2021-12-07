package com.zifras.cuenta

class Nacionalidad{
	
	String nombre
	String codigoAfip

	static constraints = {
		codigoAfip nullable:true
	}
}