package com.zifras.servicio

import com.zifras.documento.FacturaCuenta

import org.joda.time.LocalDate
class ItemServicioEspecial extends ItemServicio {
	Integer cuota = 1
	Integer totalCuotas = 1
	Double precio
	FacturaCuenta factura

	public String getEstado(){
		if (factura)
			if (factura.pagada)
				return "Pagado"
			else{
				if (factura.reembolsada)
					return "Reembolsado"
				else
					return "Facturado"
			}
		return "Pendiente"
	}

	public String getCuotaString(){ "$cuota/$totalCuotas" }

	public Boolean servicioMoratoriaPago(){
		return ((["SE01","SE02"].contains(this.servicio.codigo)) && (this.estado == "Pagado"))
	}
	
	public getFechaEmisionFactura(){
		return this.factura?.fechaHora
	}

	static constraints = {
		factura nullable:true
	}
}
