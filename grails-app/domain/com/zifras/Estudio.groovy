package com.zifras

class Estudio {

	String nombre
	Integer diaFacturacionMensual
	String mercadoPagoPublicKeySandbox
	String mercadoPagoAccessTokenSandbox
	String mercadoPagoPublicKeyProduccion
	String mercadoPagoAccessTokenProduccion
	String appVersion
	Boolean usarFirefox
	Long chromedriversAbiertos
	Long chromedriversCerrados
	String refreshTokenBitrix

	static constraints = {
		nombre blank: false, unique: true
		diaFacturacionMensual nullable:true
		mercadoPagoPublicKeySandbox nullable:true
		mercadoPagoAccessTokenSandbox nullable:true
		mercadoPagoPublicKeyProduccion nullable:true
		mercadoPagoAccessTokenProduccion nullable:true
		appVersion nullable:true
		usarFirefox nullable:true
		chromedriversAbiertos nullable:true
		chromedriversCerrados nullable:true
		refreshTokenBitrix nullable:true
	}

	Integer tenantId() {
		id
	}
	
	public String toString() {
		return nombre
	}
}
