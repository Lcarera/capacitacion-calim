package com.zifras.documento
import org.joda.time.LocalDate
import com.zifras.cuenta.Cuenta

class Comprobante {
	Tipo tipo
	String nombreArchivo
	LocalDate fecha

	static belongsTo = [cuenta:Cuenta]

	public enum Tipo{
		CONSTANCIA_MONOTRIBUTO(0)
		Tipo(int value) {
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

}	