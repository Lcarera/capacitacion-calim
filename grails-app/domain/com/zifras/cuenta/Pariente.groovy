package com.zifras.cuenta

import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

import com.zifras.Estado;
import com.zifras.cuenta.Cuenta

import grails.gorm.MultiTenant
class Pariente implements MultiTenant<Pariente> {
	Integer tenantId
	Long tipoId
	String nombre
	String apellido
	String cuil
	LocalDate fechaNacimiento
	LocalDate fechaCasamiento
	
	String ultimoModificador
	LocalDateTime ultimaModificacion
	
	Estado estado
	
	static belongsTo = [cuenta:Cuenta]
	
    static constraints = {
		tipoId nullable:true
		nombre nullable:true
		apellido nullable:true
		cuil nullable:false
		fechaNacimiento nullable:true
		fechaCasamiento nullable:true
		
		ultimoModificador nullable:true
		ultimaModificacion nullable:true
		
		estado nullable:false
    }

    public String toString() {
    	def tipoPariente = "Conyuge"
    	if(tipoId==1)
    		tipoPariente = "Hijo/a"

    	def fecha = ""
    	if(fechaNacimiento!=null)
    		fecha = fechaNacimiento.toString("dd/MM/YYYY")
    	else
    		fecha = fechaCasamiento.toString("dd/MM/YYYY")

    	return cuil + ' - ' + tipoPariente + ' - ' + nombre + ' ' + apellido + ' - ' + fecha
	}
}
