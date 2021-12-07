package com.zifras.documento
import com.zifras.cuenta.Cuenta
import org.joda.time.LocalDate
import grails.gorm.MultiTenant
import com.zifras.cuenta.Local

class ArchivoConvenio implements MultiTenant<ArchivoConvenio> {

	Integer tenantId	
	LocalDate fecha
	String nombreArchivo
	String nombreOriginal

	static belongsTo = [cuenta:Cuenta]

	static constraints = {
		fecha nullable:false
		nombreArchivo nullable:false
		nombreOriginal nullable:true
	}
}