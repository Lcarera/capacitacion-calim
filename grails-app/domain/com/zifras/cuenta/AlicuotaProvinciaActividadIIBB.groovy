package com.zifras.cuenta

import org.joda.time.LocalDateTime
import org.joda.time.LocalDate
import com.zifras.Provincia
import com.zifras.cuenta.Actividad

class AlicuotaProvinciaActividadIIBB {
	LocalDate fecha
	Provincia provincia
	Double valor
	Double baseImponibleDesde
	Double baseImponibleHasta

	//Esto es utilizado para poder aplicar la lógica impuesta por ARBA en 2021
	//true => contribuyente inscripto en 2021, se toma lo facturado los 2 primeros meses para saber alícuota
	//false => contribuyente inscripto antes del 2021, se toma lo facturado en el año 2020
	Boolean inscriptoArba2021 = false
	
	String ultimoModificador
	LocalDateTime ultimaModificacion

	static belongsTo = [actividad:Actividad]

	public boolean netoAplica(Double neto){
		def desde = baseImponibleDesde ?: new Double (0)
		return (desde <= neto && (!baseImponibleHasta || neto <= baseImponibleHasta))
	}
	
    static constraints = {
		fecha nullable:false
		provincia nullable:false
		actividad nullable:false
		valor nullable:false
		baseImponibleDesde nullable:true
		baseImponibleHasta nullable:true
		
		ultimoModificador nullable:true
		ultimaModificacion nullable:true
		inscriptoArba2021 nullable:true
    }
}
