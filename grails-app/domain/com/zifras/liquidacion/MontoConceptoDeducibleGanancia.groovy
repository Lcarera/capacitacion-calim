package com.zifras.liquidacion

import org.joda.time.LocalDate
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols

import grails.gorm.MultiTenant
class MontoConceptoDeducibleGanancia implements MultiTenant<MontoConceptoDeducibleGanancia> {
	Integer tenantId
	LocalDate fecha
	Long concepto
	Double valor

    static constraints = {
		fecha nullable:false
		concepto nullable:false
		valor nullable:false
    }
	
	String toString(){
		String patternCurrency = '###,###,###.00'
		DecimalFormat decimalCurencyFormat = new DecimalFormat(patternCurrency)
		DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
		otherSymbols.setDecimalSeparator(',' as char)
		otherSymbols.setGroupingSeparator('.' as char)
		decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)
		
		String conceptoNombre = ""
		switch(concepto){
			case 0:
				conceptoNombre = "Conyugue"
				break;
			case 1:
				conceptoNombre = "Hijo/a"
				break;
			case 2:
				conceptoNombre = "Ganancia no imponible"
				break;
			case 3:
				conceptoNombre = "Deduccion especial"
				break;
		}
		return fecha.toString("YYYY") + " " + conceptoNombre + " \$" + decimalCurencyFormat.format(valor)
	}
}
