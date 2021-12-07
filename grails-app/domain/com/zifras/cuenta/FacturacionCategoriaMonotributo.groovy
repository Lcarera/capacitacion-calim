package com.zifras.cuenta

class FacturacionCategoriaMonotributo {
	Integer ano
	String nombre
	Double importeAnual
	Double maximoAutorizar
	Double cuotaMensualServicios
	Double cuotaMensualMuebles
	
	static constraints = {
		nombre nullable:false
		importeAnual nullable:false
		ano nullable:false
		maximoAutorizar nullable:true
		cuotaMensualServicios nullable:true
		cuotaMensualMuebles nullable:true
	}
	
	public String toString() {
		return nombre
	}

}