package com.zifras.liquidacion

import com.zifras.Estado
import com.zifras.Provincia
import com.zifras.cuenta.AlicuotaIIBB
import com.zifras.cuenta.Cuenta
import com.zifras.documento.DeclaracionJurada

import grails.gorm.MultiTenant
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
class LiquidacionIIBB implements MultiTenant<LiquidacionIIBB> {
	Integer tenantId
	Provincia provincia
	LocalDate fecha
	LocalDate fechaVencimiento

	Double netoTotal
	Double porcentajeProvincia

	Double neto
	Double impuesto

	Double sircreb
	Double retencion
	Double percepcion
	Double saldoAFavorPeriodoAnterior
	Double saldoAFavor

	Double saldoDdjj

	Estado estado

	Double porcentajeSaldoDdjj

	String ultimoModificador
	LocalDateTime ultimaModificacion

	String nota

	Boolean notificado = false
	LocalDateTime fechaHoraNotificacion

	Boolean nuevaProvincia = false
	Boolean saldoNoIdentificadoInsuficiente = false
	Boolean masFacturadoQueVendido = false
	Double diferenciaNetoCalculado

	Boolean alicuotaGeneral; // Si esto es true, no encontramos la alicuota para la actividad en la provincia, así que usamos la general.

	public String getEstadoUsuario(){
		if("Notificado" == this.estado?.nombre)
			return "Liquidado"
		else if(["Sin liquidar","Sin verificar","Per/Ret ingresado","Sircreb/Ret ingresado","Nota ingresada","Liquidado","Liquidado A","Liquidado A2","Automatico"].contains(this.estado?.nombre))
			return "Sin liquidar"
		else
			return this.estado?.nombre ?: "Sin liquidar"
	}

	public DeclaracionJurada getDeclaracion(){ this.id ? DeclaracionJurada.findByLiquidacionIibb(this) : null }

	public boolean getPagada() { getDeclaracion()?.pagada }

	static belongsTo = [cuenta:Cuenta]
	static hasMany = [alicuotas:LiquidacionIIBBAlicuota, liquidacionlocales: LiquidacionIIBBLocal]

	static constraints = {
		provincia nullable:false
		fecha nullable:false, unique: ['cuenta', 'provincia']
		fechaVencimiento nullable:true
		porcentajeProvincia nullable:false
		netoTotal nullable:false
		neto nullable:false
		impuesto nullable:false
		retencion nullable:false
		percepcion nullable:false
		saldoAFavorPeriodoAnterior nullable:false
		saldoAFavor nullable:false
		saldoDdjj nullable:false
		estado nullable:false

		porcentajeSaldoDdjj nullable:true

		ultimoModificador nullable:false
		ultimaModificacion nullable:true

		nota nullable:true

		notificado nullable:true
		fechaHoraNotificacion nullable:true
		nuevaProvincia nullable:true
		saldoNoIdentificadoInsuficiente nullable:true
		masFacturadoQueVendido nullable:true
		diferenciaNetoCalculado nullable:true
		alicuotaGeneral nullable:true
	}

	static mapping = {
		alicuotas cascade: 'all-delete-orphan'
		liquidacionlocales cascade: 'all-delete-orphan'
		fecha index: 'liqIibb_fecha_index'
		fecha indexColumn: [name: "liqIibb_unicos_index", unique: true]
		cuenta indexColumn: [name: "liqIibb_unicos_index", unique: true]
		provincia indexColumn: [name: "liqIibb_unicos_index", unique: true]
	}

	String toString(){
		String patternCurrency = '###,###,###.00'
		DecimalFormat decimalCurencyFormat = new DecimalFormat(patternCurrency)
		DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
		otherSymbols.setDecimalSeparator(',' as char)
		otherSymbols.setGroupingSeparator('.' as char)
		decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)

		if(cuenta!=null)
			return cuenta.razonSocial + " " + cuenta.cuit + " " + fecha.toString('dd/MM/yyyy') + " " + provincia.nombre + " \$" + decimalCurencyFormat.format(saldoDdjj)
		else
			return fecha + " \$" + decimalCurencyFormat.format(saldoDdjj)
	}
}
