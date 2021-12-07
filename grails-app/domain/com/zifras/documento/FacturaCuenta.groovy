package com.zifras.documento

import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.Local
import com.zifras.cuenta.MovimientoCuenta
import com.zifras.servicio.ItemServicioMensual
import com.zifras.servicio.ItemServicioEspecial

import grails.gorm.MultiTenant
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
class FacturaCuenta implements MultiTenant<FacturaCuenta> {
	Integer tenantId
	LocalDateTime fechaHora
	String descripcion
	String nombreArchivo
	Double importe
	Integer cantidadAvisos
	String linkPago

	String cae
	String numero
	LocalDate vencimientoCae

	Boolean debitoAutomatico
	Local local

	NotaCreditoCuenta notaCredito

	boolean getPagada(){
		return this.movimiento?.with{pagado && ! reembolsado}
	}

	boolean getReembolsada(){
		return this.movimiento?.reembolsado
	}

	public boolean esPrimerSM(){
		if (!itemMensual)
			return false;
		if (! cuenta.primeraFacturaSMPaga)
			return true
		return id == cuenta.primeraFacturaSMPaga.id
	}

	public String getResponsable(){
		return itemMensual ? itemMensual.responsable : itemEspecial?.responsable
	}

	public getVendedor(){ itemMensual ? itemMensual.vendedor : itemEspecial?.vendedor }


	MovimientoCuenta getMovimiento(){
		return MovimientoCuenta.findByFactura(this)
	}

	public LocalDate getFechaNotificacion(){
		return pagada ? movimiento?.pago?.fechaNotificacion : null
	}
	public LocalDateTime getFechaPago(){
		return this.movimiento?.pago?.fechaPago
	}
	public ItemServicioEspecial getItemEspecial(){
		return ItemServicioEspecial.findByFactura(this)
	}
	def getItemsEspeciales(){
		return ItemServicioEspecial.findAllByFactura(this)
	}

	def getItems(){itemMensual ? [itemMensual] : itemsEspeciales}

	def getMensual(){itemMensual ? true : false}

	static belongsTo = [cuenta:Cuenta, itemMensual: ItemServicioMensual]
	
	static constraints = {
		descripcion nullable:true
		itemMensual nullable:true
		cantidadAvisos nullable:true
		cae nullable:true
		linkPago nullable:true
		vencimientoCae nullable:true
		numero nullable:true
		debitoAutomatico nullable:true
		local nullable:true
		notaCredito nullable:true
	}

	public String toString() {
		return "#$id - $descripcion (Total \$$importe)"
	}
}
