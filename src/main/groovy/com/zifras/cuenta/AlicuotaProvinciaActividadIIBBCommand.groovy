package com.zifras.cuenta

import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import grails.validation.Validateable

class AlicuotaProvinciaActividadIIBBCommand implements Validateable {
	Long alicuotaProvinciaActividadIIBBId
	Long version

	Integer ano
	Long provinciaId
	Long actividadId
	Double valor
	Double baseImponibleDesde
	Double baseImponibleHasta
	
	String ultimoModificador
	LocalDateTime ultimaModificacion
	
	
    static constraints = {
    	alicuotaProvinciaActividadIIBBId nullable:true
    	version nullable:true

		ano nullable:false
		provinciaId nullable:false
		actividadId nullable:false
		valor nullable:false
		baseImponibleDesde nullable:true
		baseImponibleHasta nullable:true

		ultimoModificador nullable:true
		ultimaModificacion nullable:true
    }
    
}
