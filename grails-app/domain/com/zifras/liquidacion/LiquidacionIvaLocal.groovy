package com.zifras.liquidacion

import com.zifras.cuenta.Local
import com.zifras.liquidacion.LiquidacionIva

import grails.gorm.MultiTenant
class LiquidacionIvaLocal implements MultiTenant<LiquidacionIvaLocal> {
	Integer tenantId
	Local local
	Double porcentajeLocal
	Double saldoDdjj

	static belongsTo = [liquidacionIva:LiquidacionIva]
    static constraints = {
		local nullable:false
		porcentajeLocal nullable:false
		
		saldoDdjj nullable:false
    }
}
