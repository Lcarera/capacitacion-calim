package com.zifras.facturacion

import grails.validation.Validateable

class TipoComprobanteCommand implements Validateable {
	Long tipoComprobanteId
	Long version
	String nombre
	String codigoAfip
	
    static constraints = {
    	codigoAfip nullable:true
    	tipoComprobanteId nullable:true
    	version nullable:true
    }
}