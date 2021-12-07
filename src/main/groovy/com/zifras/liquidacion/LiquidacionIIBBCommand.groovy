package com.zifras.liquidacion

import org.joda.time.LocalDate
import com.zifras.Estado
import grails.validation.Validateable


class LiquidacionIIBBCommand implements Validateable {
	Long liquidacionIIBBId
	Long version
	
	Long provinciaId
	
	String mes
	String ano

	LocalDate fechaVencimiento
	
	Double netoTotal
	Double porcentajeProvincia
	
	Double neto
	Double impuesto
	
	Double retencion
	Double percepcion
	Double sircreb
	
	Double saldoAFavorPeriodoAnterior
	Double saldoAFavor
	
	Double saldoDdjj
	
	String nota
	
	Long estadoId
	
	Long cuentaId
	
	String alicuotas

	Double retencionSumatoria = 0
	Double bancariaSumatoria = 0
	Double percepcionSumatoria = 0
	
	static constraints = {
		liquidacionIIBBId nullable:true
		version nullable:true
		
		provinciaId nullable:false
		
		mes nullable:false
		ano nullable:false

		fechaVencimiento nullable:true
		
		netoTotal nullable:false
		porcentajeProvincia nullable:false
		
		neto nullable:false
		impuesto nullable:false
		
		retencion nullable:true
		percepcion nullable:true
		sircreb nullable:true
		
		saldoAFavorPeriodoAnterior nullable:true
		saldoAFavor nullable:true
		
		saldoDdjj nullable:false
		
		nota nullable:true
		
		estadoId nullable:true
		
		cuentaId nullable:false
		
		alicuotas nullable:true
	}
}
