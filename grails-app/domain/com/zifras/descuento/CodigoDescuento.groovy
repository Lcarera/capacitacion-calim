package com.zifras.descuento

import com.zifras.User
import com.zifras.cuenta.Cuenta

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

class CodigoDescuento {
	String codigo
	LocalDate fechaExpiracion
	LocalDateTime fechaGenerado

	LocalDate fechaActivacion
	Cuenta beneficiado
	User vendedor

	Double descuento
	String detalle

	public boolean getRedimido(){
		return this.beneficiado ? true : false
	}
	
	static constraints = {
		codigo nullable:false, unique:true
		beneficiado nullable:true
		fechaActivacion nullable:true
		vendedor nullable:true
		descuento nullable:true
		detalle nullable:true
	}

	public Double obtenerDescuentoServicio(String codigoServicio){
		if(this.detalle == "MercadoLibre" && codigoServicio == "SE09")
			return 30
		return descuento
	}

}
