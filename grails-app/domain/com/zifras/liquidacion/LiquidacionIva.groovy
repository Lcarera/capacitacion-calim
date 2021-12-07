package com.zifras.liquidacion

import com.zifras.Estado
import com.zifras.cuenta.Cuenta
import com.zifras.documento.DeclaracionJurada

import grails.gorm.MultiTenant
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
class LiquidacionIva implements MultiTenant<LiquidacionIva> {
	Integer tenantId
	LocalDate fecha
	LocalDate fechaVencimiento

	Double porcentajeDebitoCredito = 0

	Double facturasA = 0
	Double facturasA21 = 0
	Double facturasA10 = 0
	Double facturasA27 = 0
	Double facturasA2 = 0
	Double facturasA5 = 0

	Double noGravadoFacturasA = 0
	Double exentoFacturasA = 0

	Double otrasFacturas = 0
	Double otrasFacturas21 = 0
	Double otrasFacturas10 = 0
	Double otrasFacturas27 = 0
	Double otrasFacturas2 = 0
	Double otrasFacturas5 = 0

	Double noGravadoOtrasFacturas = 0
	Double exentoOtrasFacturas = 0

	Double netoVenta = 0
	Double netoVenta21 = 0
	Double netoVenta10 = 0
	Double netoVenta27 = 0
	Double netoVenta2 = 0
	Double netoVenta5 = 0

	Double netoNoGravadoVenta = 0
	Double exentoVenta = 0

	Double debitoFiscal = 0
	Double debitoFiscal21 = 0
	Double debitoFiscal10 = 0
	Double debitoFiscal27 = 0
	Double debitoFiscal2 = 0
	Double debitoFiscal5 = 0

	Double totalVenta = 0
	Double totalVenta21 = 0
	Double totalVenta10 = 0
	Double totalVenta27 = 0
	Double totalVenta2 = 0
	Double totalVenta5 = 0

	Double totalNoGravadoVenta = 0
	Double totalExentoVenta = 0

	Double netoCompra = 0
	Double netoCompra21 = 0
	Double netoCompra10 = 0
	Double netoCompra27 = 0
	Double netoCompra2 = 0
	Double netoCompra5 = 0

	Double netoNoGravadoCompra = 0
	Double exentoCompra = 0

	Double creditoFiscal = 0
	Double creditoFiscal10 = 0
	Double creditoFiscal21 = 0
	Double creditoFiscal27 = 0
	Double creditoFiscal2 = 0
	Double creditoFiscal5 = 0

	Double totalCompra = 0
	Double totalCompra21 = 0
	Double totalCompra10 = 0
	Double totalCompra27 = 0
	Double totalCompra2 = 0
	Double totalCompra5 = 0

	Double totalNoGravadoCompra = 0
	Double totalExentoCompra = 0

	Double debitoMenosCredito = 0 //creditoFiscal - debitoFiscal
	Double saldoTecnicoAFavorPeriodoAnterior
	Double saldoTecnicoAFavor = 0 //creditoMenosDebito
	Double saldoLibreDisponibilidadPeriodoAnterior
	Double saldoLibreDisponibilidad = 0
	Double retencion = 0
	Double percepcion = 0

	Double saldoDdjj = 0

	Estado estado

	Double porcentajeSaldoDdjj
	Double porcentajeDebitoFiscalDdjj

	Boolean facturasVentaImportadas = false
	Boolean facturasCompraImportadas = false
	Boolean percepcionesImportadas = false
	Boolean retencionesImportadas = false
	Boolean retencionesBancariasImportadas = false
	Boolean importacionPosterior = false

	String ultimoModificador
	LocalDateTime ultimaModificacion

	String nota

	Boolean notificado = false
	LocalDateTime fechaHoraNotificacion

	public String getEstadoUsuario(){
		if("Notificado" == this.estado?.nombre)
			return "Liquidado"
		else if(["Sin liquidar","Sin verificar","Per/Ret ingresado","Sircreb/Ret ingresado","Nota ingresada","Liquidado","Liquidado A","Liquidado A2","Automatico"].contains(this.estado?.nombre))
			return "Sin liquidar"
		else
			return this.estado?.nombre ?: "Sin liquidar"
	}

	public DeclaracionJurada getDeclaracion(){ this.id ? DeclaracionJurada.findByLiquidacionIva(this) : null }

	public boolean getPagada() { getDeclaracion()?.pagada }

	static hasMany = [liquidacionlocales: LiquidacionIvaLocal]
	static belongsTo = [cuenta:Cuenta]

    static constraints = {
		fecha nullable:false, unique: 'cuenta'
		fechaVencimiento nullable:true
		porcentajeDebitoCredito nullable:false

		netoVenta nullable:false

		netoVenta21 nullable:true
		netoVenta10 nullable:true
		netoVenta27 nullable:true
		netoVenta2 nullable:true
		netoVenta5 nullable:true

		netoNoGravadoVenta nullable:true
		exentoVenta nullable:true

		debitoFiscal nullable:false

		debitoFiscal21 nullable:true
		debitoFiscal10 nullable:true
		debitoFiscal27 nullable:true
		debitoFiscal2 nullable:true
		debitoFiscal5 nullable:true

		totalVenta nullable:false
		totalVenta21 nullable:true
		totalVenta10 nullable:true
		totalVenta27 nullable:true
		totalVenta2 nullable:true
		totalVenta5 nullable:true

		totalNoGravadoVenta nullable:true
		totalExentoVenta nullable:true

		netoCompra nullable:false
		netoCompra21 nullable:true
		netoCompra10 nullable:true
		netoCompra27 nullable:true
		netoCompra2 nullable:true
		netoCompra5 nullable:true

		netoNoGravadoCompra nullable:true
		exentoCompra nullable:true

		creditoFiscal nullable:false
		creditoFiscal21 nullable:true
		creditoFiscal10 nullable:true
		creditoFiscal27 nullable:true
		creditoFiscal2 nullable:true
		creditoFiscal5 nullable:true

		totalCompra nullable:false
		totalCompra21 nullable:true
		totalCompra10 nullable:true
		totalCompra27 nullable:true
		totalCompra2 nullable:true
		totalCompra5 nullable:true

		totalNoGravadoCompra nullable:true
		totalExentoCompra nullable:true

		debitoMenosCredito nullable:false
		saldoTecnicoAFavorPeriodoAnterior nullable:true
		saldoTecnicoAFavor nullable:true
		saldoLibreDisponibilidadPeriodoAnterior nullable:true
		saldoLibreDisponibilidad nullable:true
		retencion nullable:true
		percepcion nullable:true

		saldoDdjj nullable:false

		estado nullable:false

		porcentajeSaldoDdjj nullable:true
		porcentajeDebitoFiscalDdjj nullable:true

		facturasVentaImportadas nullable:true
		facturasCompraImportadas nullable:true
		percepcionesImportadas nullable:true
		retencionesImportadas nullable:true
		retencionesBancariasImportadas nullable:true
		importacionPosterior nullable:true

		ultimoModificador nullable:true
		ultimaModificacion nullable:true

		nota nullable:true, maxSize:2048

		notificado nullable:true
		fechaHoraNotificacion nullable:true

		exentoFacturasA nullable:true
		exentoOtrasFacturas nullable:true
		facturasA nullable:true
		facturasA10 nullable:true
		facturasA2 nullable:true
		facturasA21 nullable:true
		facturasA27 nullable:true
		facturasA5 nullable:true
		noGravadoFacturasA nullable:true
		noGravadoOtrasFacturas nullable:true
		otrasFacturas nullable:true
		otrasFacturas10 nullable:true
		otrasFacturas2 nullable:true
		otrasFacturas21 nullable:true
		otrasFacturas27 nullable:true
		otrasFacturas5 nullable:true
    }

	static mapping = {
		liquidacionlocales cascade: 'all-delete-orphan'
		fecha index: 'liqIva_fecha_index'
		fecha indexColumn: [name: "liqIva_unicos_index", unique: true]
		cuenta indexColumn: [name: "liqIva_unicos_index", unique: true]
	}

	String toString(){
		String patternCurrency = '###,###,###.00'
		DecimalFormat decimalCurencyFormat = new DecimalFormat(patternCurrency)
		DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
		otherSymbols.setDecimalSeparator(',' as char)
		otherSymbols.setGroupingSeparator('.' as char)
		decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)

		if(cuenta!=null)
			return cuenta.razonSocial + " " + fecha.toString('dd/MM/yyyy') + " \$" + decimalCurencyFormat.format(saldoDdjj)
		else
			return fecha + " \$" + decimalCurencyFormat.format(saldoDdjj)
	}
}
