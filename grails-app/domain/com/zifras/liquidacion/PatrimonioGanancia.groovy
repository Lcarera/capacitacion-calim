package com.zifras.liquidacion

import com.zifras.liquidacion.TipoPatrimonioGanancia
import com.zifras.liquidacion.LiquidacionGanancia

import grails.gorm.MultiTenant
class PatrimonioGanancia implements MultiTenant<PatrimonioGanancia> {
	Integer tenantId
	TipoPatrimonioGanancia tipo
	Double valorInicial
	Double valorCierre
	
	String detalleInicial
	String detalleCierre
	
	static belongsTo = [liquidacion:LiquidacionGanancia]

    static constraints = {
		tipo nullable:false
		valorInicial nullable:true
		valorCierre nullable:true
		detalleInicial nullable:true
		detalleCierre nullable:true
    }
}
