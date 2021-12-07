package com.zifras.cuenta

import org.joda.time.LocalDateTime;

import com.zifras.Provincia
import com.zifras.Estado

import grails.gorm.MultiTenant
class AlicuotaIIBB implements MultiTenant<AlicuotaIIBB> {
	Integer tenantId
	Provincia provincia
	Double valor
	Double porcentaje
	
	String ultimoModificador
	LocalDateTime ultimaModificacion
	
	Estado estado
	
	static belongsTo = [cuenta:Cuenta]
	
    static constraints = {
		provincia nullable:false
		valor nullable:false
		porcentaje nullable:false
		
		ultimoModificador nullable:true
		ultimaModificacion nullable:true
		
		estado nullable:false
    }
}
