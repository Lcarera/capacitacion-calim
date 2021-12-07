package com.zifras.liquidacion

import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;

import com.zifras.Estado;
import com.zifras.liquidacion.GastoDeduccionGanancia
import com.zifras.liquidacion.PatrimonioGanancia
import com.zifras.cuenta.Cuenta

import java.text.DecimalFormat
import java.text.DecimalFormatSymbols

import grails.gorm.MultiTenant
class LiquidacionGanancia implements MultiTenant<LiquidacionGanancia> {
	Integer tenantId
	LocalDate fecha
	
	Double netoVenta
	Double netoCompra
	
	Double totalIngresos
	Double existenciaInicial
	Double existenciaFinal
	Double ingresosBrutos
	Double totalGastosDeducciones
	
	//El costo de la mercadería vendida es:
	//Existencia inicial + Compras (netos) - Existencia Final
	Double costoMercaderiaVendida
	//Costo total es:
	//Costo de mercadería vendida + Gastos y deducciones
	Double costoTotal
	//La renta imponible es:
	//Total de ingresos - Costos totales
	Double rentaImponible
	
	Double baseGNI
	Double mesesGNI
	Double gananciaNoImponible
	
	Double baseDE
	Double mesesDE
	Double deduccionEspecial
	
	//El subtotal de ganancia imponible es:
	//Sumatoria de Ganancia no imponible + Deducciones Parientes + Deduccion especial
	Double subtotalGananciaImponible
	
	//La ganancia imponible es:
	//Renta imponible - subtotal ganancia imponible
	Double gananciaImponible
	
	Double retencion
	Double percepcion
	Double anticipos
	Double impuestoDebitoCredito
	
	Double impuestoDeterminado
	
	//El impuesto es:
	//Impuesto determinado - ret/per - anticipos
	Double impuesto
	
	Estado estado
	
	String ultimoModificador
	LocalDateTime ultimaModificacion
	
	Double sumatoriaPatrimonioInicial
	Double sumatoriaPatrimonioFinal
	Double totalPatrimonio
	Double consumido
	
	String nota
	
	static belongsTo = [cuenta:Cuenta]
	static hasMany = [gastosDeducciones: GastoDeduccionGanancia, deduccionesParientes: ParienteGanancia, patrimonios:PatrimonioGanancia]
		
    static constraints = {
		fecha nullable:false, unique: 'cuenta'
		
		netoVenta nullable:true
		netoCompra nullable:true
		
		totalIngresos nullable:true
		existenciaInicial nullable:true
		existenciaFinal nullable:true
		ingresosBrutos nullable:true
		totalGastosDeducciones nullable:true
		
		costoMercaderiaVendida nullable:true
		
		costoTotal nullable:true
		
		rentaImponible nullable:true
		
		baseGNI nullable:true
		mesesGNI nullable:true
		gananciaNoImponible nullable:true
		
		baseDE nullable:true
		mesesDE nullable:true
		deduccionEspecial nullable:true
		
		subtotalGananciaImponible nullable:true
		
		gananciaImponible nullable:true
		
		retencion nullable:true
		percepcion nullable:true
		anticipos nullable:true
		impuestoDebitoCredito nullable:true

		
		impuestoDeterminado nullable:true
		
		impuesto nullable:true
		
		sumatoriaPatrimonioInicial nullable:true
		sumatoriaPatrimonioFinal nullable:true
		consumido nullable:true
		totalPatrimonio nullable:true
		
		estado nullable:false
		
		ultimoModificador nullable:false
		ultimaModificacion nullable:true
		
		nota nullable:true, maxSize:2048
    }
	
	static mapping = {
		gastosDeducciones cascade: 'all-delete-orphan'
		deduccionesParientes cascade: 'all-delete-orphan'
		patrimonios cascade: 'all-delete-orphan'
		fecha index: 'liqIva_fecha_index'
		fecha indexColumn: [name: "liqGanancia_unicos_index", unique: true]
		cuenta indexColumn: [name: "liqGanancia_unicos_index", unique: true]
	}
	
	String toString(){
		String patternCurrency = '###,###,###.00'
		DecimalFormat decimalCurencyFormat = new DecimalFormat(patternCurrency)
		DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
		otherSymbols.setDecimalSeparator(',' as char)
		otherSymbols.setGroupingSeparator('.' as char)
		decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)
		
		if(cuenta!=null)
			return cuenta.razonSocial + " " + cuenta.cuit + " " + fecha.toString('dd/MM/yyyy') + " \$" + decimalCurencyFormat.format(impuesto)
		else
			return fecha + " \$" + decimalCurencyFormat.format(impuesto)
	}
}
