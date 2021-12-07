package com.zifras.facturacion

class AlicuotaIva {
	Double valor
	String caption
	Integer codigoAfip
	
    static constraints = {
		codigoAfip nullable:true
    }
}
