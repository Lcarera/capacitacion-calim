package com.zifras

class Provincia {
	String nombre
	String codigoRPB
	Integer codigoAfip

	static hasMany = [localidades:Localidad]

    static constraints = {
		nombre nullable:false
		codigoRPB nullable:true
		codigoAfip nullable:true
    }

	static mapping = {
		localidades cascade: "all-delete-orphan"
	}

	public String toString() { toString(false) }

	public String toString(Boolean conCodigo) { conCodigo ? "$codigoRPB - $nombre" : nombre }

	public String provinciaCeroPorCiento(){
		if(nombre=="CABA")
			return "Buenos Aires"
		return "CABA"
	}
}
