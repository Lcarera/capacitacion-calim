package com.zifras.mercadopago
import org.joda.time.LocalDateTime

class NotifMPError{
	Long mpId
	LocalDateTime fechaHora
	Long pagoCuentaId
	String paramsString
	String mensajeError

    static constraints = {
		pagoCuentaId nullable:true
		paramsString nullable:true
		mpId nullable:true, unique:true
		mensajeError nullable:true
    }
}