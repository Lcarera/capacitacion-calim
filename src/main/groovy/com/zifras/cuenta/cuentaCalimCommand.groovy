package com.zifras.cuenta

import org.joda.time.LocalDate

import grails.validation.Validateable

class CuentaCalimCommand implements Validateable {
	String nombre
	String email
	String telefono
	Long bitrixId
	Double total
	Integer cuotas
	LocalDate primerPago
	boolean mercadoLibre
	String comentarioServicio

	static constraints = {
		nombre blank: false, nullable: false
		email blank: false, nullable: false, email:true
		telefono nullable:true
		cuotas nullable: true
		bitrixId nullable: true
		primerPago nullable: true
		mercadoLibre nullable: true
		comentarioServicio nullable:true
	}
}
