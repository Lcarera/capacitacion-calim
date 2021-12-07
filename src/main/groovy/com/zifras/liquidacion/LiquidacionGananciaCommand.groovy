package com.zifras.liquidacion

import org.joda.time.LocalDate
import com.zifras.Estado
import grails.validation.Validateable

class LiquidacionGananciaCommand implements Validateable {
	Long liquidacionGananciaId
	Long version
	
	String ano
	
	Double netoVenta
	Double netoCompra
	Double netoCompraSumatoria
	
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
	
	Double baseConyuge
	Double baseHijo
	
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
	
	Double sumatoriaPatrimonioInicial
	Double sumatoriaPatrimonioFinal
	Double totalPatrimonio
	Double consumido
	
	String nota
	
	String gastosDeducciones
	String deduccionesParientes
	String patrimonios
	
	Long estadoId
	
	String cuenta
	Long cuentaId
	
	static constraints = {
		liquidacionGananciaId nullable:true
		version nullable:true
		
		ano nullable:false
		
		netoVenta nullable:true
		netoCompra nullable:true
		netoCompraSumatoria nullable:true
		
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
		
		baseConyuge nullable:true
		baseHijo nullable:true
		
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
		
		nota nullable:true
		
		gastosDeducciones nullable:true
		deduccionesParientes nullable:true
		patrimonios nullable:true
		
		estadoId nullable:true
		
		cuenta nullable:true
		cuentaId nullable:false
	}
}
