package com.zifras.notificacion

import org.joda.time.LocalDateTime

class ConsultaWeb {
	String nombre
	String apellido
	String telefonoIngresado
	String telefono
	String email
	LocalDateTime fechaHora
	String tag
	String vendedorAsignado
	String urlOrigen
	String getParameters
	String bitrixClientId
	String bitrixDealId

	ConsultaWeb(){}
	ConsultaWeb(nom, ap, tel, tel2, mail, etiqueta, vendedor, url, getParams, clientId, dealId){
		nombre = nom
		apellido = ap
		telefono = tel
		telefonoIngresado = tel2
		email = mail
		fechaHora = new LocalDateTime()
		tag = etiqueta
		vendedorAsignado = vendedor
		urlOrigen = url
		getParameters = getParams
		bitrixClientId = clientId
		bitrixDealId = dealId
	}
	static constraints = {
		tag nullable:true
		vendedorAsignado nullable:true
		urlOrigen nullable:true
		getParameters nullable:true
		bitrixClientId nullable:true
		bitrixDealId nullable:true
		telefonoIngresado nullable:true
	}
}
