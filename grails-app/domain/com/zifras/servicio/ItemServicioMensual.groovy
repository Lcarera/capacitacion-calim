package com.zifras.servicio

import com.zifras.documento.FacturaCuenta

import org.joda.time.LocalDate
class ItemServicioMensual extends ItemServicio {
	Double descuento
	LocalDate fechaBaja
	Boolean debitoAutomatico

	static hasMany = [facturas:FacturaCuenta]

	public boolean getMesFacturado() { getMesFacturado(new LocalDate()) }

	public boolean getMesFacturado(String mes, String ano) { getMesFacturado(new LocalDate(ano + "-" + mes + "-01")) }

	public boolean getMesFacturado(LocalDate mesBuscado) { !! getFacturaDeMes(mesBuscado) }

	public FacturaCuenta getFacturaDeMes(LocalDate mesBuscado){
		LocalDate mesCorriente = mesBuscado.withDayOfMonth(com.zifras.Estudio.get(2).diaFacturacionMensual).plusDays(5)
		LocalDate mesAnterior = mesCorriente.minusMonths(1)
		return facturas.find{ it.fechaHora.toLocalDate().with{ it > mesAnterior && it <= mesCorriente } }
	}

	public boolean getMesPagado(LocalDate mesBuscado) { getFacturaDeMes(mesBuscado)?.pagada }

	public boolean getVigente(){ periodoAplica(new LocalDate()) }

	public boolean periodoAplica(LocalDate fecha){
		if (fechaBaja)
			return fechaAlta <= fecha && fechaBaja > fecha
		else
			return fechaAlta <= fecha
	}

	public Double getPrecio(){
		return (servicio.precio * (1 - descuento / 100)).round(2)
	}

	public Double getPrecio(LocalDate fechaAlta){
		return (servicio.getPrecio(fechaAlta) * (1 - descuento / 100)).round(2)
	}

	static constraints = {
		fechaBaja nullable:true
		debitoAutomatico nullable:true
	}
}
