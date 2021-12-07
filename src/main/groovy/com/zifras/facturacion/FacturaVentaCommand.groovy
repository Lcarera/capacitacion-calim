package com.zifras.facturacion
import org.joda.time.LocalDate
import grails.validation.Validateable

class FacturaVentaCommand implements Validateable {

	Long facturaVentaId
	Long version

	Long cuentaId
	LocalDate fecha	
	Long clienteId
	Long tipoId
	Long conceptoId
	Long puntoVenta
	Long numero
	String itemsFactura

	Double neto
	Double netoNoGravado = 0
	Double exento = 0
	Double iva
	Double total

	LocalDate fechaInicioServicios
	LocalDate fechaFinServicios
	LocalDate fechaVencimientoPagoServicio

	Long paisCodigoId
	Long paisCuitId
	Long monedaId
	Long idiomaId
	String tipoCuitPais

	Long ivaDefaultId //Para que el cbo se inicialice en 21%
	Long proformaId // PedidosYa

	String cbuEmisor

    static constraints = {
    	facturaVentaId nullable:true
    	version nullable:true
    	ivaDefaultId nullable:true
    	fechaInicioServicios nullable:true
    	fechaFinServicios nullable:true
    	fechaVencimientoPagoServicio nullable:true
    	proformaId nullable:true
    	paisCodigoId nullable:true
    	paisCuitId nullable:true
    	monedaId nullable:true
    	idiomaId nullable:true
    	tipoCuitPais nullable:true
    	cbuEmisor nullable:true
    }
}
