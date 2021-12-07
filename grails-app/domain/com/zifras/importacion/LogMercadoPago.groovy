package com.zifras.importacion

import com.zifras.Estado

import grails.gorm.MultiTenant
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
class LogMercadoPago implements MultiTenant<LogMercadoPago> {
	Integer tenantId
	LocalDate fecha //Corresponde al mes y año de la importación
	Estado estado
	Long correctos = 0
	Long ignorados = 0
	Long faltantes = 0
	Long incorrectos = 0
	Long total = 0
	Double sumatoriaAcreditados = 0
	String getSumatoriaString(){
		String patternCurrency = '###,###,##0.00'
		DecimalFormat decimalCurencyFormat = new DecimalFormat(patternCurrency)
		DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
		otherSymbols.setDecimalSeparator(',' as char)
		otherSymbols.setGroupingSeparator('.' as char)
		decimalCurencyFormat.setGroupingUsed(true)
		decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)
		return decimalCurencyFormat.format(sumatoriaAcreditados)
	}
	String mensajeError

	String getDetalle(){ "Total: $total \nCorrectos: $correctos \nIncorrectos: $incorrectos \nIgnorados: $ignorados \nNo estaban: $faltantes \nMonto Total Acreditado: \$$sumatoriaString" }

	LocalDateTime fechaHora //Corresponde a la fecha y hora en la que se importó
	String responsable

	static hasMany = [fallos: DetalleErroneoMP]
    static constraints = {
    	mensajeError nullable:true
    }

	/*static mapping = {
		fecha index: 'Log_Fecha_Index'
	}*/
}
