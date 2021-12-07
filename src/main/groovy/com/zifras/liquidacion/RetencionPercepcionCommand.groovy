package com.zifras.liquidacion
import org.joda.time.LocalDate
import grails.validation.Validateable

class RetencionPercepcionCommand implements Validateable {
	String codigo
	String cuit
	LocalDate fecha
	String comprobante
	String facturaParteA
	String facturaParteB
	Double monto
    Double montoBase
    String tipo
    String cbu
    String tipoCuenta
    String tipoComprobante
    String letraComprobante

    Long cuentaId
    Long retencionPercepcionId
    Long version

    boolean importado = false

    static constraints = {
    	comprobante nullable:true
        facturaParteA nullable:true
        facturaParteB nullable:true
        version nullable:true
        retencionPercepcionId nullable:true
        cbu nullable:true
        tipoCuenta nullable:true
        codigo nullable:true
        montoBase nullable:true
        tipoComprobante nullable:true
        letraComprobante nullable:true
    }
}
