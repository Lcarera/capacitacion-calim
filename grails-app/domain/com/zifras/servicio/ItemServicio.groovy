package com.zifras.servicio

import com.zifras.cuenta.Cuenta
import com.zifras.ventas.Vendedor

import grails.gorm.MultiTenant
import org.joda.time.LocalDate
class ItemServicio implements MultiTenant<ItemServicio> {
	// Extiende a ItemServicioEspecial e ItemServicioMensual
	Integer tenantId
	LocalDate fechaAlta
	String comentario

	String responsable // Para cuando el responsable no es un vendedor
	public String getResponsable(){
		return vendedor?.nombre ?: this.responsable
	}
	Vendedor vendedor

	static belongsTo = [cuenta:Cuenta, servicio: Servicio]

	static constraints = {
		responsable nullable:true
		vendedor nullable:true
		comentario nullable:true
	}

	public String toString() { servicio.toString() }
}
