package com.zifras.cuenta

import com.zifras.Provincia
import com.zifras.cuenta.Actividad
import com.zifras.Estado
import com.zifras.facturacion.PuntoVenta
import org.joda.time.LocalDateTime
import org.joda.time.LocalDate

import grails.gorm.MultiTenant
class PorcentajeActividadIIBB implements MultiTenant<PorcentajeActividadIIBB> {
	Integer tenantId
	Double porcentaje
	Actividad actividad
	PuntoVenta puntoVenta
	Long orden
	Boolean monotributo = false
	LocalDate periodo

	String ultimoModificador
	LocalDateTime ultimaModificacion

	Estado estado
	
	static belongsTo = [cuenta:Cuenta]

    static constraints = {
		porcentaje nullable:false
		actividad nullable:true
		puntoVenta nullable:true

		ultimoModificador nullable:true
		ultimaModificacion nullable:true

		orden nullable:true
		monotributo nullable:true
		periodo nullable:true

		estado nullable:false
    }

    public String toString(){
    	return "${this.actividad.nombre} - ${this.porcentaje}%"
    }
}
