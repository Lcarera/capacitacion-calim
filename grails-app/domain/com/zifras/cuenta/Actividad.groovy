package com.zifras.cuenta

import com.zifras.cuenta.AlicuotaProvinciaActividadIIBB

class Actividad {
	String nombre
	
	String codigo
	String codigoAfip
	String codigoNaes
	String codigoCuacm

	String descripcionAfip
	String descripcionNaes
	String descripcionCuacm
	
	Double utilidadMaxima
	Double utilidadMinima

	static hasMany = [alicuotasActividadIIBB:AlicuotaProvinciaActividadIIBB]
	
	static constraints = {
		nombre nullable:false
		
		codigo nullable:false, unique:true
		codigoAfip nullable:true
		codigoNaes nullable:true
		codigoCuacm nullable:true

		descripcionAfip nullable:true
		descripcionNaes nullable:true
		descripcionCuacm nullable:true

		utilidadMaxima nullable:true
		utilidadMinima nullable:true
	}
	
	public String toString() {
		return "(" + codigo + ") " + nombre
	}
}
