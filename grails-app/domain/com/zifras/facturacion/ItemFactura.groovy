package com.zifras.facturacion

import com.zifras.cuenta.Cuenta
import com.zifras.facturacion.UnidadMedida
import com.zifras.facturacion.ConceptoFacturaVenta

import grails.gorm.MultiTenant
class ItemFactura implements MultiTenant<ItemFactura> {
	Integer tenantId
	ConceptoFacturaVenta concepto
	Long cantidad	
	Double precioUnitario
	AlicuotaIva alicuota

	public Double getNeto(){
		return this.cantidad * this.precioUnitario
	}

	public Double getIva(){
		return this.neto * this.alicuota.valor / 100
	}

	public String getIvaPorcentaje(){
		return "% " + this.alicuota.valor
	}

	public Double getTotal(){
		return this.neto + this.iva
	}

	public String getConceptoNombre(){
		return this.concepto.nombre
	}

	static belongsTo = [facturaVenta:FacturaVenta]

	static constraints = {}
}
