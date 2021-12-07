package com.zifras.facturacion
import org.joda.time.LocalDate
import grails.validation.Validateable

class PersonaCommand implements Validateable {
	Long personaId
	Long version
	String razonSocial
	String cuit
	String tipoDocumento
	String domicilio

    static constraints = {
    	tipoDocumento nullable:true
    	personaId nullable:true
    	version  nullable:true
    }
}
