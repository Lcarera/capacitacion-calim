package com.zifras.liquidacion

import com.zifras.liquidacion.TipoGastoDeduccionGanancia
import com.zifras.liquidacion.LiquidacionGanancia

import grails.gorm.MultiTenant
class GastoDeduccionGanancia implements MultiTenant<GastoDeduccionGanancia> {
	Integer tenantId
	TipoGastoDeduccionGanancia tipo
	Double valor
	
	static belongsTo = [liquidacion:LiquidacionGanancia]
	
    static constraints = {
		tipo nullable:false
		valor nullable:false
    }
}
