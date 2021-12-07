package com.zifras.importacion

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import com.zifras.cuenta.Cuenta
import com.zifras.Estado
import com.zifras.Provincia
import com.zifras.liquidacion.RetencionPercepcionIva
import com.zifras.liquidacion.RetencionPercepcionIIBB
import com.zifras.facturacion.FacturaCompra
import com.zifras.facturacion.FacturaVenta

import grails.gorm.MultiTenant
class LogImportacion implements MultiTenant<LogImportacion> {
	Integer tenantId
	LocalDate fecha //Corresponde al mes y año de la importación
	
	String detalle
	String nombreArchivo
	Long total = 0
	Long cantidadOk = 0
	Long cantidadMal = 0
	Long cantidadIgnoradas = 0
	Long nuevasPersonas = 0
	Long nuevosTiposComprobantes = 0

	boolean compra = false
	boolean venta = false

	boolean retencion = false
	boolean percepcion = false
	boolean bancaria = false
	boolean retPerEsIva = false
	Provincia provincia

	Estado estado
	
	LocalDateTime fechaHora //Corresponde a la fecha y hora en la que se importó
	String responsable
	
	static belongsTo = [cuenta:Cuenta]

	static hasMany = [facturasCompra: FacturaCompra, facturasVenta: FacturaVenta, retPerIva: RetencionPercepcionIva, retPerIIBB: RetencionPercepcionIIBB]

    static constraints = {
    	detalle nullable:true
    	provincia nullable:true
    }
	
	static mapping = {
		fecha index: 'Log_Fecha_Index'
		facturasCompra cascade: "all-delete-orphan"
		facturasVenta cascade: "all-delete-orphan"
		retPerIva cascade: "all-delete-orphan"
		retPerIIBB cascade: "all-delete-orphan"
	}

	String getTipo(){
		if (compra)
			return "Compras"
		if (venta)
			return "Ventas"

		if (retencion)
			if (retPerEsIva)
				return "Retenciones IVA"
			else
				return "Retenciones IIBB"
		if (percepcion)
			if (retPerEsIva)
				return "Percepciones IVA"
			else
				return "Percepciones IIBB"
		if (bancaria)
			return "Ret. Banc. IIBB"

		return "-"
	}
}
