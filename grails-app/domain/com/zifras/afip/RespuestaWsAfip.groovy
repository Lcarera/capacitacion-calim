package com.zifras.afip

import groovy.util.XmlSlurper
import org.joda.time.LocalDateTime

class RespuestaWsAfip {
	String xml
	String service

	String cuit
	LocalDateTime fechaHora
	
	static constraints = {
		xml maxSize:102400
	}

	public getParseoPersona(){
		return (new XmlSlurper().parseText(xml)).Body.getPersonaResponse.personaReturn
	}

	public boolean getExpirada(){
		return this.fechaHora < new LocalDateTime().minusDays(1)
	}
}
