package com.zifras.documento

import com.zifras.Estado
import com.zifras.cuenta.Cuenta
import com.zifras.mercadopago.PaymentMP
import com.zifras.cuenta.MovimientoCuenta

import grails.gorm.MultiTenant
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

class PagoCuenta implements MultiTenant<PagoCuenta> {

	Integer tenantId
	Estado estado	
	Double importe
	String descripcion
	LocalDateTime fechaPago
	LocalDate getFechaNotificacion(){ notificaciones ? notificaciones.first().fechaNotificacion : null }
	String nombreArchivo
	String linkMercadoPago

	String preferenceId

	static hasMany = [notificaciones: PaymentMP]

	static belongsTo = [cuenta:Cuenta]

	def cancelar(){
		if (this.estado.nombre != "Expirado")
			if (this.preferenceId){
				def idBuscar = this.id
				PagoCuenta.withNewSession {session ->
					PagoCuenta.get(idBuscar).with{
						estado = Estado.findByNombre("Expirado")
						save(flush:true)
					}
				}
				PagoCuentaService.cancelarPreferencia(this.preferenceId, tenantId)
			}
			else
				log.error("Se quiso dar de baja el pago $id pero no tenía guardado el ID de la preferencia.")
	}

	def getMovimientos(){ MovimientoCuenta.findAllByPago(this) }

	def getFacturas() {movimientos?.findAll{it.factura}?.collect{it.factura}?.unique{it.id}}

	MovimientoCuenta getMovimientoPositivo(){ this.movimientos.find{it.positivo} }

	def getDescripcionMovimientos(){
		def movimientos = MovimientoCuenta.findByPago(this)
		def descripciones = movimientos.collect{it.descripcion}
		descripciones = descripciones?.toString().replace('[','').replace(']','').replace(';',',')
		def descripcion

		if(descripciones!=null && descripciones!="null" && descripciones.length() < 240)
			descripcion = descripciones ? "Pago de " + descripciones : "-"
		else
			descripcion = "Pago de deuda"

		return descripcion
	}

	String getCodigosMp(){
		return notificaciones?.collect{it.myId}?.join(", ")
	}

	boolean tieneLaNotificacion(Long notif){ notificaciones?.find{it.myId == notif} }

	String getMailMP(){
		return notificaciones?.find{it.payer?.email}?.payer?.email ?: ""
	}

	String getNombreMP(){
		return notificaciones?.find{it.payer}?.payer?.with{
			String nombre = first_name ?: ""
			String apellido = last_name ?: ""
			return (nombre + " " + apellido).trim()
		} ?: ""
	}

	static constraints = {
		fechaPago nullable:false
		descripcion nullable:true
		nombreArchivo nullable:true
		preferenceId nullable:true
		linkMercadoPago nullable:true
	}
}
