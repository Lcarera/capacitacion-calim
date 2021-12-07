package com.zifras.cuenta

import org.joda.time.LocalDate
import com.zifras.Auxiliar
class DeudaCCMA {
	LocalDate fecha // de consulta
	Double deuda
	Double aFavor
	Double mesCorriente
	Boolean ultimos3MesesPagos
	static belongsTo = [cuenta:Cuenta]

	static constraints = {
		ultimos3MesesPagos nullable:true
	}

	public String getFechaString(){
		return fecha.toString("dd/MM/yyyy")
	}

	public String getDeudaString(){
		return '$' + Auxiliar.formatear(deuda)
	}

	public String getFavorString(){
		return '$' + Auxiliar.formatear(aFavor)
	}

	public String getMesCorrienteString(){
		return '$' + Auxiliar.formatear(mesCorriente)
	}
}