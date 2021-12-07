package com.zifras.servicio

import com.zifras.facturacion.AlicuotaIva

import org.joda.time.LocalDate
import grails.gorm.MultiTenant
class PrecioServicio implements MultiTenant<PrecioServicio> {
	Integer tenantId
	LocalDate fecha
	Double precio // Es el precio FINAL
	AlicuotaIva alicuota

	static belongsTo = [servicio:Servicio]

	public Double getPrecioNeto(){
		Double porcentaje = alicuota.valor / 100
		return precio / (1 + porcentaje)
	}
}
