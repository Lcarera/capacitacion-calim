package com.zifras.documento
import com.zifras.cuenta.Cuenta
import org.joda.time.LocalDate
import grails.gorm.MultiTenant
import com.zifras.cuenta.Local

class ReciboSueldo implements MultiTenant<ReciboSueldo> {

	Integer tenantId	
	LocalDate fechaEmision
	String nombreArchivo
	String nombreOriginal

	static belongsTo = [cuenta:Cuenta, local:Local]

	static constraints = {
		fechaEmision nullable:false
		nombreArchivo nullable:false
		nombreOriginal nullable:true
	}

	
}