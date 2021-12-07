package com.zifras.liquidacion

import com.zifras.cuenta.Pariente
import com.zifras.liquidacion.LiquidacionGanancia

import grails.gorm.MultiTenant
class ParienteGanancia implements MultiTenant<ParienteGanancia> {
	Integer tenantId
	Pariente pariente
	Double base
	//Cantidad de meses con los que se debe prorratear
	Double meses
	Double valor
	
	static belongsTo = [liquidacion:LiquidacionGanancia]
	
    static constraints = {
		pariente nullable:false
		base nullable:false
		meses nullable:false
		valor nullable:false
    }
}
