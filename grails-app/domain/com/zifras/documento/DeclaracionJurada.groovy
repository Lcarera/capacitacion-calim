package com.zifras.documento

import com.zifras.Estado
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.MovimientoCuenta
import com.zifras.liquidacion.LiquidacionGanancia
import com.zifras.liquidacion.LiquidacionIIBB
import com.zifras.liquidacion.LiquidacionIva

import org.joda.time.LocalDate
import grails.gorm.MultiTenant
class DeclaracionJurada implements MultiTenant<DeclaracionJurada> {
	Integer tenantId
	LocalDate fecha
	String descripcion
	String nombreArchivo
	String nombreOriginal

	LiquidacionIva liquidacionIva
	LiquidacionIIBB liquidacionIibb
	LiquidacionGanancia liquidacionGanancia

	ComprobantePago comprobantePago

	Vep vep

	Estado estado

	static belongsTo = [cuenta:Cuenta]
	
	static constraints = {
		fecha nullable:false
		descripcion nullable:true
		nombreArchivo nullable:false
		nombreOriginal nullable:false
		
		liquidacionIva nullable:true
		liquidacionIibb nullable:true
		liquidacionGanancia nullable:true

		comprobantePago nullable:true

		estado nullable:true

		vep nullable:true
	}
	
	public String toString() {
		return descripcion
	}

	public def getLiquidacion(){
		return liquidacionIva ?: (liquidacionIibb ?: liquidacionGanancia)
	}

	public MovimientoCuenta getMovimiento() { MovimientoCuenta.findByDeclaracion(this) }

	public boolean getPagada() { getMovimiento()?.pagado }
}
