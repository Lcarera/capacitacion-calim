package com.zifras.liquidacion

import com.zifras.cuenta.Local
import com.zifras.liquidacion.LiquidacionIIBB

import grails.gorm.MultiTenant
class LiquidacionIIBBLocal implements MultiTenant<LiquidacionIIBBLocal> {
	Integer tenantId
	Local local
	Double porcentajeLocal
	Double saldoDdjj

	static belongsTo = [liquidacionIIBB:LiquidacionIIBB]
    static constraints = {
		local nullable:false
		porcentajeLocal nullable:false
		
		saldoDdjj nullable:false
    }
}
