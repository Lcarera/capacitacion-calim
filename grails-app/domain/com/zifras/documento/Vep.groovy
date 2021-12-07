package com.zifras.documento

import com.zifras.Estado
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.Local

import grails.gorm.MultiTenant
import org.joda.time.LocalDate

class Vep implements MultiTenant<Vep> {

	Integer tenantId
	Estado estado	
	Long numero
	Double importe
	String descripcion
	LocalDate fechaPago
	LocalDate fechaEmision
	LocalDate vencimiento
	String nombreArchivo
	TipoVep tipo

	static belongsTo = [cuenta:Cuenta, local: Local]

	static constraints = {
		fechaPago nullable:true
		nombreArchivo nullable:false
		numero nullable:true
		importe nullable:true
		descripcion nullable:true
		local nullable:true
		vencimiento nullable:true
	}
	
	public Vep plus(Vep other) {
        new Vep(importe: this.importe + other.importe)
    }

    public LocalDate getVencimiento(){
        if (vencimiento)
        	return vencimiento
        else if (tipo.nombre == "IVA")
            return fechaEmision.plusMonths(1)
        else if (tipo.nombre == "IIBB")
            return fechaEmision.plusDays(7)
        else if (tipo.nombre == "Simplificado")
            return getVencimientoSimplificado()
        else
            return fechaEmision.plusDays(1)
    }

    public String getPeriodo(){ // Para la función se considera que el mes de la fecha de emisión del VEP es en realidad el número de cuota.
    	Integer mes2 = new Integer(fechaEmision.toString("MM")) * 2
    	def poner0 = {x -> x.toString().with{ x > 9 ? it : "0" + it}}
    	return "${poner0 (mes2-1)} - ${poner0 mes2}"
    }

    public LocalDate getVencimientoSimplificado(){ // Para la función se considera que el mes de la fecha de emisión del VEP es en realidad el número de cuota.
    	def provincia = cuenta.getProvincia()
    	Integer cuota = 0
    	if (provincia?.nombre == "CABA")
    		cuota = fechaEmision.getMonthOfYear()
    	else if (provincia?.nombre == "Entre Ríos"){
    		def mesFinal = fechaEmision.getMonthOfYear() * 4
    		def mesActual = new LocalDate().getMonthOfYear()
    		if (mesActual <= mesFinal && mesActual>= mesFinal-3)
    			cuota = mesActual
    		else
    			cuota = mesFinal
    	}
    	def vencimiento = VencimientoVep.findByProvinciaAndAnoAndNumeroCuotaAndTerminacion(provincia, fechaEmision.getYearOfEra(), cuota , new Integer(cuenta.cuit[-1]))
    	return vencimiento?.with{
    		LocalDate salida = new LocalDate(ano + "-" + numeroCuota + "-" + diaVencimiento)
    		if (provincia.nombre == "CABA")
    			salida = salida.plusMonths(numeroCuota + 1)
    		return salida
    	}
    }

    public getAnio(){
    	return this.fechaEmision("AAAA")
    }

	public String toString() {
		if(numero==null)
			return descripcion + ' - ' + cuenta.cuit
		return numero + ' - ' + cuenta.cuit	
	}

}
