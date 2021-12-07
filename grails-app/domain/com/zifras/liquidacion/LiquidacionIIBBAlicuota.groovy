package com.zifras.liquidacion

import com.zifras.cuenta.Actividad

import grails.gorm.MultiTenant
class LiquidacionIIBBAlicuota implements MultiTenant<LiquidacionIIBBAlicuota> {
	Integer tenantId
	Actividad actividad
	Double baseImponible
	Double impuesto
	
	Double alicuota
	Double porcentaje

	static belongsTo = [liquidacion:LiquidacionIIBB]
	
    static constraints = {
    	actividad nullable:true
    }
}
