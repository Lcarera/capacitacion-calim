package com.zifras.facturacion
import org.joda.time.LocalDate
import grails.validation.Validateable

class FacturaCompraCommand implements Validateable {

	LocalDate fecha;
	Long tipoId;
	Long facturaCompraId
	Long version
	Long puntoVenta;
	Long numero;
	Long cuentaId
	Long proveedorId;
	Double netoGravado21
	Double netoGravado27
	Double netoGravado10
	Double netoGravado
	Double netoNoGravado
	Double exento
	Double iva
	Double iva21
	Double iva27
	Double iva10
	Double total

    static constraints = {
    	iva21 nullable:true;
    	iva10 nullable:true;
    	iva27 nullable:true;
    	iva21 nullable:true;
    	iva10 nullable:true;
    	iva27 nullable:true;
    	netoGravado27 nullable:true;
    	netoGravado21 nullable:true;
    	netoGravado10 nullable:true;
    	version nullable:true;
    	netoNoGravado nullable:true
    	facturaCompraId nullable:true;
    	exento nullable:true;
    }
}
