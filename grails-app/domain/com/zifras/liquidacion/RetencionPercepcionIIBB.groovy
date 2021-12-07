package com.zifras.liquidacion
import com.zifras.cuenta.Cuenta
import org.joda.time.LocalDate
import com.zifras.importacion.LogImportacion
import com.zifras.Provincia

import grails.gorm.MultiTenant
class RetencionPercepcionIIBB implements MultiTenant<RetencionPercepcionIIBB> {
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

    public String getCuitConGuiones(){
        String cui = this.cuit.replaceAll("-","")
        return cui[0..1] + "-" + cui[2..9] + "-" + cui[-1]
    }

    public String getTipoComprobanteExport(){
        if (this.tipoComprobante && !["X","O"].contains(this.tipoComprobante))
            return this.tipoComprobante
        return "F"
    }

    public String getLetraComprobanteExport(){
        if (this.letraComprobante && !["X","O"].contains(this.letraComprobante))
            return this.letraComprobante
        return "B"
    }
	
	static belongsTo = [cuenta:Cuenta, logImportacion:LogImportacion]

    static constraints = {
        cuenta nullable:false, unique: ['comprobante','cbu','cuit','monto','fecha']
    	comprobante nullable:true
        facturaParteA nullable:true
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
