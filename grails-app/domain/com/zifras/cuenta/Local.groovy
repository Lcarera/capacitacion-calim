package com.zifras.cuenta

import com.zifras.Estado
import com.zifras.Localidad
import com.zifras.Provincia
import com.zifras.Zona
import com.zifras.documento.ReciboSueldo
import com.zifras.documento.Vep

import org.joda.time.LocalDate

import grails.gorm.MultiTenant
class Local implements MultiTenant<Local> {
	Integer tenantId
	Integer numeroLocal
	String direccion
	String email
	String urlQrCode
	Provincia provincia
	Localidad localidad
	Zona zona
	Double porcentaje
	Double porcentajeIIBB
	String telefono
	Estado estado
	Integer cantidadEmpleados
	
	static belongsTo = [cuenta:Cuenta]

	static hasMany = [veps: Vep, recibosSueldo:ReciboSueldo]

    static constraints = {
    	numeroLocal nullable:true
		direccion nullable:true
		email nullable:true
		urlQrCode nullable:true
		provincia nullable:false
		localidad nullable:false
		zona nullable:true
		porcentaje nullable:true
		cantidadEmpleados nullable:true
		telefono nullable:true
		porcentajeIIBB nullable:true
		estado nullable:false
    }
	
	public String toString() {
		String salida = ""
		if(zona!=null)
			salida = direccion + ' (' + provincia.nombre + '-' + localidad.nombre + '-' + zona.nombre + ')'
		else
			salida = direccion + ' (' + provincia.nombre + '-' + localidad.nombre + ')'
			
		return salida
	}

	public vepsDeMes(LocalDate fecha){ veps?.findAll{it.fechaEmision >= fecha && it.fechaEmision < fecha.plusMonths(1)} }

	public boolean poseeEmpleados(){ !!cantidadEmpleados }


	public int cantidadRecibosCargados(LocalDate periodo){
		return recibosSueldo?.findAll{it.fechaEmision >= periodo && it.fechaEmision < periodo.plusMonths(1)}?.size() ?: 0
	}
}
