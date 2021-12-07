package com.zifras.cuenta

import com.zifras.Estudio
import org.joda.time.LocalDate;

import grails.validation.Validateable

class ConfiguracionCommand implements Validateable {
	Long cuentaId
	Long version

	Long medioPagoId
	String cbu
	
	Boolean recibirNotificaciones
	Boolean recibirNotificacionVep
	Boolean recibirNotificacionDeclaracionJurada
	Boolean recibirNotificacionFacturaCuenta

	Double maximoAutorizarIva
	Double maximoAutorizarIIBB

	static constraints = {
		cuentaId nullable:true
		version nullable:true

		medioPagoId nullable:true
		cbu nullable:true
		recibirNotificaciones nullable:true
		recibirNotificacionVep nullable:true
		recibirNotificacionDeclaracionJurada nullable:true
		recibirNotificacionFacturaCuenta nullable:true
		maximoAutorizarIva nullable:true
		maximoAutorizarIIBB nullable:true
	}
	
}
