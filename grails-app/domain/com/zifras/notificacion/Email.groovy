package com.zifras.notificacion

import org.joda.time.LocalDateTime
import com.zifras.cuenta.Cuenta

class Email {
	String emailTo
	String subject
	String html
	Cuenta cuenta
	String tag
	
	String tituloNotificacionApp
	String textoNotificacionApp
	Boolean notificacionLeida = false

	String mailgunId
	String mailgunStatus
	
	Boolean open
	Boolean click
	Boolean delivered

	Boolean programado
	
	LocalDateTime fechaHora
	
	static hasMany = [notificaciones: MailgunNotification]
	
    static constraints = {
		emailTo nullable:true
		subject nullable:true
		html nullable:true, maxSize:6000
		tag nullable:true
		cuenta nullable:true
		mailgunId nullable:true
		mailgunStatus nullable:true

		tituloNotificacionApp nullable:true
		textoNotificacionApp nullable:true

		notificacionLeida nullable:true
				
		open nullable:true
		click nullable:true
		delivered nullable:true

		programado nullable:true
		
		fechaHora nullable:true
    }

    static mapping = {
		notificaciones cascade: "all-delete-orphan"
	}
}
