package com.zifras.notificacion
import grails.validation.Validateable

class NotificacionTemplateCommand implements Validateable{

	Long notificacionTemplateId
	Long version

	String nombre
	String asuntoEmail
	String cuerpoEmail
	String tituloApp
	String textoApp

	 static constraints = {
	 	notificacionTemplateId nullable:true
	 	version nullable:true
	 	nombre nullable:false
	 	asuntoEmail nullable:true
	 	cuerpoEmail nullable:true
	 	tituloApp nullable:true
	 	textoApp nullable:true
	}
}