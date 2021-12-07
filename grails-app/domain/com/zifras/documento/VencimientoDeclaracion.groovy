package com.zifras.documento

import org.joda.time.LocalDate

class VencimientoDeclaracion{
	String tipoImpuesto /*Valores = [IIBB;IVA;Convenio]*/
	Integer mesPeriodo
	LocalDate fechaVencimiento
	Integer terminacion1
	Integer terminacion2
	Integer terminacion3

	public boolean cuitAplica(String cuit){
		def ultimoDigito = new Integer (cuit[-1])
		return (ultimoDigito == this.terminacion1 || ultimoDigito == this.terminacion2 || ultimoDigito == this.terminacion3)
	}

	static constraints = {
    	terminacion3 nullable:true
    }
}
