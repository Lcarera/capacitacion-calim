package com.zifras.facturacion

import com.zifras.cuenta.Cuenta

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

class Proforma{

	LocalDate fecha
	Double importe
	Cuenta cuenta
	Long riderId
	String cuit
	Estados estado
	FacturaVenta factura
	LocalDateTime ultimaSubida
	String nombreArchivo

	public enum Estados{
		NUEVA(0), NOTIFICADA(1), ERROR(2), VERIFICADA(3)
		Estados(int value) {
			this.value = value
		}
		private final int value
		int getValue() {
			value
		}

		public String toString(){
			return name().toLowerCase().capitalize()
		}
	}
		
	static constraints = {
		factura nullable:true
		nombreArchivo nullable:true
		ultimaSubida nullable:true
	}

	public Integer numeroSemana(){

	}

}



