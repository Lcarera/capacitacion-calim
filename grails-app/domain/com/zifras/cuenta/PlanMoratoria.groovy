package com.zifras.cuenta

import org.joda.time.LocalDate
import org.joda.time.Months

import com.zifras.Estado
import com.zifras.servicio.ItemServicioEspecial

class PlanMoratoria {
	LocalDate inicio
	LocalDate fin

	Estado estado

	ItemServicioEspecial servicioEspecial

	static hasMany = [cuotas:CuotaMoratoria]

	static belongsTo = [cuenta:Cuenta]

	def getCantidadDeCuotas(){
		return cuotas.size()
	}
	def getImporteTotal(){
		return cuotas.sum{it.importe}
	}
	def getCuotasVencidas(){
		int cuotas = Months.monthsBetween(inicio, LocalDate.now()).getMonths()
		return cuotas >= 0 ? cuotas : 0
	}

	def vencido(){
		return getCuotasVencidas() >= getCantidadDeCuotas()
	}

	def cuotaAPagar(){
		return cuotas[this.getCuotasVencidas()]
	}

}