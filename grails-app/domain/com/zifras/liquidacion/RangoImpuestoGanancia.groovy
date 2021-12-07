package com.zifras.liquidacion

import org.joda.time.LocalDate;

import grails.gorm.MultiTenant
class RangoImpuestoGanancia implements MultiTenant<RangoImpuestoGanancia> {
	Integer tenantId
	LocalDate fecha
	
	Double desde
	Double hasta
	
	Double fijo
	Double porcentaje
	
    static constraints = {
		fecha nullable:false
		desde nullable:false
		hasta nullable:true
		fijo nullable:false
		porcentaje nullable:false
    }
	
	public String toString() {
		return desde + ' - ' + hasta + ' - ' + porcentaje
	}
}
