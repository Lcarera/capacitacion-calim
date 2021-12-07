package com.zifras.liquidacion

import com.zifras.Estado

import grails.gorm.MultiTenant
class TipoGastoDeduccionGanancia implements MultiTenant<TipoGastoDeduccionGanancia> {
	Integer tenantId
	String nombre
	Estado estado
	
    static constraints = {
		nombre nullable:false
		estado nullable:false
    }
}
