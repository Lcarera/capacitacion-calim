package com.zifras.documento

import com.zifras.cuenta.Cuenta
import com.zifras.liquidacion.LiquidacionGanancia
import com.zifras.liquidacion.LiquidacionIIBB
import com.zifras.liquidacion.LiquidacionIva
import com.zifras.documento.DeclaracionJurada

import org.joda.time.LocalDate

import grails.gorm.MultiTenant
class ComprobantePago implements MultiTenant<ComprobantePago> {

	Integer tenantId
	LocalDate fecha
	String descripcion
	String nombreArchivo
	String nombreOriginal
	Double importe

	static belongsTo = [declaracion:DeclaracionJurada]
	
	static constraints = {
		fecha nullable:false
		descripcion nullable:true
		nombreArchivo nullable:false
		nombreOriginal nullable:false
		importe nullable:false

	}
	
	public String toString() {
		return descripcion
	}

	public def getLiquidacion(){
		return declaracion.liquidacion
	}
}
