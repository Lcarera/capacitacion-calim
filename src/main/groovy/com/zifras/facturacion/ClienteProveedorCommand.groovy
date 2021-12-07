
package com.zifras.cuenta
import grails.validation.Validateable;

class ClienteProveedorCommand implements Validateable{
	
	Long clienteProveedorId
	Long version
	
	String razonSocial
	String cuit
	String tipoDocumento
	String domicilio
	
	boolean proveedor
	boolean cliente
	String email
	String alias
	String nota

	Long condicionIvaId
	Long provinciaId

	static constraints = {
		clienteProveedorId nullable:true
		version nullable:true
		cliente nullable:true
		proveedor nullable:true
		alias nullable:true
		domicilio nullable:true
		tipoDocumento nullable:true
		nota nullable:true
		email nullable:true
		condicionIvaId nullable:true
		provinciaId nullable:true
	}	


}