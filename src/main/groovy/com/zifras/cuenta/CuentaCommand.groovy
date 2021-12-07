package com.zifras.cuenta

import com.zifras.Estudio
import org.joda.time.LocalDate;

import grails.validation.Validateable

class CuentaCommand implements Validateable {
	Long cuentaId
	Long version
	Integer tenantId
	
	LocalDate fechaContratoSocial
	String cuit
	String razonSocial
	
	String nombreApellido
	String cuitAdministrador
	String cuitRepresentante
	String cuitGeneradorVep
	String telefono
	String email
	String wechat
	String whatsapp
	String numeroSicol
	String detalle
	
	String tipoDocumento
	String documento
	String profesion
	String appCalimDescargada
	String rangoFacturacion
	Boolean inscriptoAfip
	Boolean relacionDependencia

	String apps 

	Long actividadId
	Long condicionIvaId
	Long regimenIibbId
	
	Long estadoId
	
	Long estadoActivoId
	Long provinciaCabaId
	Long localidadCabaId
	Long actividadDefaultId
	Long convenioMultilateralId
	
	String locales
	String alicuotasIIBB
	String alicuotasIIBBBorradas
	String porcentajesProvinciaIIBB
	String porcentajesProvinciaIIBBBorradas
	String porcentajesActividadIIBB
	String porcentajesActividadIIBBBorradas
	String parientes
	String parientesBorrados

	Long tipoClaveId
	Long estadoClaveId
	Long tipoPersonaId
	Long mesCierre
	String impuestos
	Long impuestoMonotributoId
	Long categoriaMonotributoId
	String periodoMonotributo
	Long impuestoAutonomoId
	Long categoriaAutonomoId
	String periodoAutonomo
	String domicilioFiscalCodigoPostal
	String domicilioFiscalDireccion
	String domicilioFiscalLocalidad
	String domicilioFiscalPisoDpto
	Long domicilioFiscalProvinciaId

	Long medioPagoId
	Long medioPagoIvaId
	Long medioPagoIibbId
	String cbu
	Long tarjetaDebitoAutomaticoId
	String numeroTarjeta
	String claveFiscal
	String claveArba
	String claveAgip
	String claveVeps

	static constraints = {
		cuentaId nullable:true
		version nullable:true
		
		fechaContratoSocial nullable:true
		cuit nullable:false
		razonSocial nullable:true
		
		nombreApellido nullable:true
		cuitAdministrador nullable:true
		cuitRepresentante nullable:true
		cuitGeneradorVep nullable:true
		telefono nullable:true
		email nullable:true, validator: { String val, CuentaCommand obj ->
            if (obj.tenantId.toString() == Estudio.findByNombre("Calim").id.toString() && (! val))
                return ['Las cuentas de Calim deben poseer email']
        }
		wechat nullable:true
		whatsapp nullable:true
		numeroSicol nullable:true
		detalle nullable:true
		
		tipoDocumento nullable:true
		documento nullable:true
		profesion nullable:true
		appCalimDescargada nullable:true
		rangoFacturacion nullable:true
		inscriptoAfip nullable:true
		relacionDependencia nullable:true

		actividadId nullable:true
		condicionIvaId nullable:true
		regimenIibbId nullable:true
		
		alicuotasIIBB nullable:true
		porcentajesProvinciaIIBB nullable:true
		porcentajesActividadIIBB nullable:true
		
		estadoId nullable:true
		
		locales nullable:true
		parientes nullable:true
		
		apps nullable:true

		estadoActivoId nullable:true
		provinciaCabaId nullable:true
		localidadCabaId nullable:true
		actividadDefaultId nullable:true
		convenioMultilateralId nullable:true
		alicuotasIIBBBorradas nullable:true
		porcentajesProvinciaIIBBBorradas nullable:true
		porcentajesActividadIIBBBorradas nullable:true
		parientesBorrados nullable:true

		tipoClaveId nullable:true
		estadoClaveId nullable:true
		tipoPersonaId nullable:true
		mesCierre nullable:true
		impuestos nullable:true
		impuestoMonotributoId nullable:true
		periodoMonotributo nullable:true
		impuestoAutonomoId nullable:true
		periodoAutonomo nullable:true
		domicilioFiscalCodigoPostal nullable:true
		domicilioFiscalDireccion nullable:true
		domicilioFiscalPisoDpto nullable:true
		domicilioFiscalLocalidad nullable:true
		domicilioFiscalProvinciaId nullable:true
		categoriaMonotributoId nullable:true
		categoriaAutonomoId nullable:true
		medioPagoId nullable:true
		medioPagoIvaId nullable:true
		medioPagoIibbId nullable:true
		cbu nullable:true
		tarjetaDebitoAutomaticoId nullable:true
	 	numeroTarjeta nullable:true
		claveFiscal nullable:true
		claveVeps nullable:true
		claveArba nullable:true
		claveAgip nullable:true
	}
}
