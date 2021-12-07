package com.zifras.cuenta

import com.zifras.cuenta.Impuesto
import grails.gorm.MultiTenant
import org.joda.time.LocalDate
import com.zifras.cuenta.Cuenta

class CantidadImpuesto implements MultiTenant<CantidadImpuesto> {
	Integer tenantId
	Impuesto impuesto
	LocalDate periodo
	boolean monotributo = false

	static belongsTo = [cuenta:Cuenta]
	
	static constraints = {
		impuesto nullable:false
		periodo nullable:false

		cuenta nullable:false
	}
	
	public String toString() {
		return nombre
	}
}
