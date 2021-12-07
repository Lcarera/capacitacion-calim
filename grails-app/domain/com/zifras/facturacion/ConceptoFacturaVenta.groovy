package com.zifras.facturacion
import com.zifras.cuenta.Cuenta

import grails.gorm.MultiTenant
class ConceptoFacturaVenta implements MultiTenant<ConceptoFacturaVenta> {
	Integer tenantId
	String nombre
	
	static belongsTo = [cuenta:Cuenta]
	
    static constraints = {
		nombre maxSize:512
    }
}
