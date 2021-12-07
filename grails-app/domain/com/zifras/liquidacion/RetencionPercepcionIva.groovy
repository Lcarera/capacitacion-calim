package com.zifras.liquidacion
import com.zifras.cuenta.Cuenta
import org.joda.time.LocalDate
import com.zifras.importacion.LogImportacion
import com.zifras.Provincia

import grails.gorm.MultiTenant
class RetencionPercepcionIva implements MultiTenant<RetencionPercepcionIva> {
    Integer tenantId
	String codigo
	String cuit
	LocalDate fecha
	String comprobante
	String facturaParteA
	String facturaParteB
	Double monto
    Double montoBase
	String tipo
    String origen 
    Provincia provincia
    String cbu
    String tipoCuenta
    String tipoComprobante
    String letraComprobante
	
	static belongsTo = [cuenta:Cuenta, logImportacion:LogImportacion]

    static constraints = {
        comprobante nullable:true, unique: ['cuenta','cuit','monto']
        facturaParteA nullable:true, unique: ['cuenta', 'facturaParteB','cuit','monto']
        facturaParteB nullable:true
        cbu nullable:true
        tipoCuenta nullable:true
        codigo nullable:true
        montoBase nullable:true
        tipoComprobante nullable:true
        letraComprobante nullable:true
        logImportacion nullable:true
        origen nullable:true
        provincia nullable:true
    }
}
