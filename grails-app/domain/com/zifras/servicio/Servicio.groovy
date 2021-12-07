package com.zifras.servicio

import org.joda.time.LocalDate
import grails.gorm.MultiTenant
class Servicio implements MultiTenant<Servicio> {
	Integer tenantId
	String codigo
	String subcodigo
	String nombre
	boolean mensual
	boolean activo = true

	static hasMany = [precios: PrecioServicio, items: ItemServicio]

	public String toString() {
		String base = "$codigo sub- $nombre"
		String sub = subcodigo ? '(' + subcodigo + ') ' : ''
		return base.replace('sub',sub)
	}

	public String getDetalleFactura() { getDetalleFactura(new LocalDate().minusMonths(1)) }

	public String getDetalleFactura(LocalDate mes) {
		String texto = "$codigo - $nombre"
		if (mensual)
			texto += " (" + mes.toString("MM/yyyy") + ")"
		return texto
	}

	static constraints = {
		subcodigo nullable:true
	}

	public PrecioServicio getPrecioServicio() { getPrecioServicio(new LocalDate()) }

	public PrecioServicio getPrecioServicio(LocalDate fechaBuscada) { this.precios?.findAll{it.fecha <= fechaBuscada}?.max{it.fecha} }

	public Double getPrecio(){ getPrecio(new LocalDate()) }

	public Double getPrecio(LocalDate fechaBuscada){ getPrecioServicio(fechaBuscada)?.precio ?: 0 }

	public Double getPrecioNeto(){ getPrecioNeto(new LocalDate()) }

	public Double getPrecioNeto(LocalDate fechaBuscada){ getPrecioServicio(fechaBuscada)?.precioNeto ?: 0}
}
