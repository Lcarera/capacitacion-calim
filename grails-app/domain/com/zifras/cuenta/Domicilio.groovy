package com.zifras.cuenta

import com.zifras.cuenta.Cuenta
import com.zifras.Estado
import com.zifras.Provincia
import com.zifras.Zona

import grails.gorm.MultiTenant
class Domicilio implements MultiTenant<Domicilio> {
	Integer tenantId
	
	String codigoPostal
	String direccion
	Provincia provincia
	String localidad
	String pisoDpto
	Boolean fiscal = true

    static constraints = {
		codigoPostal nullable:true
		direccion nullable:false
		provincia nullable:false
		localidad nullable:true
		pisoDpto nullable:true
		fiscal nullable:false
    }
	
	public String toString() {
		String piso = pisoDpto ? " $pisoDpto " : ""
		return direccion + "$piso (" + [codigoPostal, provincia.nombre, localidad].findAll{!!it}.join(" - ") + ")"
	}
}
