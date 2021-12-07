package com.zifras.afip

import org.joda.time.LocalDateTime

class TokenAfip {

	String xml
	String token
	String sign
	String service
	String expiracion
    static constraints = {
		xml maxSize:204800, nullable:true
		token maxSize:204800, nullable:true
		expiracion nullable:true
		service nullable:true
		sign nullable:true
    }
    public boolean getExpirado(){
    	LocalDateTime fechaExpiracion = new LocalDateTime(expiracion.subSequence(0, expiracion.length() - 6))
    	return (new LocalDateTime() >= fechaExpiracion)
    }
}
