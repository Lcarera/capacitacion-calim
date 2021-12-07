package com.zifras.facturacion

import com.zifras.Provincia
import com.zifras.cuenta.CondicionIva

import grails.gorm.MultiTenant
class Persona implements MultiTenant<Persona> {
	Integer tenantId
	String razonSocial
	String cuit
	String tipoDocumento
	String domicilio
	CondicionIva condicionIva
	Provincia provincia

	public String getTipoDocumentoAfip(){
		switch(this.tipoDocumento){
			case "CUIT":
				return "80"
			case "CUIL":
				return "86"
			case "CDI":
				return "87"
			case "CI Extranjera":
				return "91"
			case "en trámite":
				return "92"
			case "Pasaporte":
				return "92"
			case "DNI":
				return "96"
			default:
				return "99"
		}
	}

	static mapping = {
		cuit index: 'persona_cuit_index'
	}
	
    static constraints = {
		razonSocial nullable:false
		cuit nullable:false, unique: 'tenantId'
		tipoDocumento nullable:false
		domicilio nullable:true
		provincia nullable:true
		condicionIva nullable:true
    }

	public String toString() {
		return cuit + ' - ' + razonSocial
	}
}
