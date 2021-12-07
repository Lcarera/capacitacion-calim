package com.zifras.debito

import org.joda.time.LocalDate

import com.zifras.Estado
import com.zifras.cuenta.Cuenta
import com.zifras.documento.FacturaCuenta

class DebitoAutomatico {
	
	String numeroTarjeta
	Estado estado
	LocalDate fechaCreacion
	FacturaCuenta factura
	Double importe
	Cuenta cuenta
	Boolean primerDebito
	String tipo
	String detalleCobro


	static constraints = {
		numeroTarjeta nullable:false
		estado nullable:false
		fechaCreacion nullable:false
		factura nullable:false
		importe nullable:false
		cuenta nullable:false
		primerDebito nullable:false
		tipo nullable:false
		detalleCobro nullable:true
	}

}