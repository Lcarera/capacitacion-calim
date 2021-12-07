package com.zifras.cuenta

import org.joda.time.LocalDate;
import grails.validation.Validateable


class PlanMoratoriaCommand implements Validateable{

	Long planMoratoriaId
	Long version

	LocalDate inicio

	Long estadoId
	Long cantidadCuotas

	Long servicioEspecialId

	Long cuentaId

	String cuotas

	static constraints = {
		planMoratoriaId nullable:true
		version nullable:true
		inicio nullable:false
		estadoId nullable:true
		cantidadCuotas nullable:true
		servicioEspecialId nullable:false
		cuentaId nullable:false
		cuotas nullable:false
	}

}