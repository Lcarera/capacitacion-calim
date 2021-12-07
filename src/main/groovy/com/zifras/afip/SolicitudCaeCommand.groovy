package com.zifras.afip

class SolicitudCaeCommand {
	def cuitEmisor
	def docTipoComprador
	def cuitComprador
	def cbteTipo
	def puntoVenta
	def numeroComprobante
	def fecha
	def total
	def netoNoGravado
	def neto /*Ver restricciones en la página 17*/
	def exento /*Ver restricciones en la página 17*/
	def totalIva /*Suma de los importes del array de IVA, ojo monotributista*/
	def concepto
	Integer tipoExportacion
	String permisoExistente
	String codigoPais
	String cuitPais
	String itemsExportacion
	String razonSocialComprador
	String domicilioComprador
	String codigoMoneda
	def cotizacionMoneda
	String codigoIdioma
	String fechaInicioServicios = ""
	String fechaFinServicios = ""
	String fechaVencimientoPagoServicio = ""
	String arrayAlicuotas = ""
	String comprobanteAsociado = ""
	String opcionales = ""

	Long facturaId

	String cae
	org.joda.time.LocalDate vencimiento

	static constraints = {
		tipoExportacion nullable:true
		permisoExistente nullable:true
		codigoPais nullable:true
		cuitPais nullable:true
		razonSocialComprador nullable:true
		itemsExportacion nullable:true
		domicilioComprador nullable:true
		codigoMoneda nullable:true
		cotizacionMoneda nullable:true
		codigoIdioma nullable:true
	}
}
