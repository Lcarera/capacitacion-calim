package com.zifras.cuenta

import com.zifras.Provincia
import com.zifras.cuenta.Actividad
import com.zifras.Estado
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

import grails.gorm.MultiTenant
class PorcentajeProvinciaIIBB implements MultiTenant<PorcentajeProvinciaIIBB> {
	Integer tenantId
	Double porcentaje
	Provincia provincia
	
	String ultimoModificador
	LocalDateTime ultimaModificacion
	LocalDate periodoCreacion

	Estado estado
	
	static belongsTo = [cuenta:Cuenta]

    static constraints = {
		porcentaje nullable:false
		provincia nullable:true
		
		ultimoModificador nullable:true
		ultimaModificacion nullable:true
		periodoCreacion nullable:true

		estado nullable:false
    }

    public String toString(){
    	return "${this.provincia.nombre} - ${this.porcentaje}%"
    }
}
