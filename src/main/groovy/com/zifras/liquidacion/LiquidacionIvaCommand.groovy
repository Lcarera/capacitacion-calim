package com.zifras.liquidacion

import org.joda.time.LocalDate
import com.zifras.Estado
import grails.validation.Validateable

class LiquidacionIvaCommand implements Validateable {
	Long liquidacionIvaId
	Long version

	String mes
	String ano

	LocalDate fechaVencimiento

	Double porcentajeDebitoCredito

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

	Double netoVenta
	Double netoVenta21
	Double netoVenta10
	Double netoVenta27
	Double netoVenta2
	Double netoVenta5

	Double netoNoGravadoVenta
	Double exentoVenta

	Double debitoFiscal
	Double debitoFiscal21
	Double debitoFiscal10
	Double debitoFiscal27
	Double debitoFiscal2
	Double debitoFiscal5

	Double totalVenta
	Double totalVenta21
	Double totalVenta10
	Double totalVenta27
	Double totalVenta2
	Double totalVenta5

	Double totalNoGravadoVenta
	Double totalExentoVenta

	Double netoCompra
	Double netoCompra21
	Double netoCompra10
	Double netoCompra27
	Double netoCompra2
	Double netoCompra5

	Double netoNoGravadoCompra
	Double exentoCompra

	Double creditoFiscal
	Double creditoFiscal21
	Double creditoFiscal10
	Double creditoFiscal27
	Double creditoFiscal2
	Double creditoFiscal5

	Double totalCompra
	Double totalCompra21
	Double totalCompra10
	Double totalCompra27
	Double totalCompra2
	Double totalCompra5

	Double totalNoGravadoCompra
	Double totalExentoCompra

	Double debitoMenosCredito
	Double saldoTecnicoAFavorPeriodoAnterior
	Double saldoTecnicoAFavor
	Double saldoLibreDisponibilidadPeriodoAnterior
	Double saldoLibreDisponibilidad
	Double retencion
	Double percepcion

	Double saldoDdjj

	String nota

	Long estadoId

	Long cuentaId

	Double facturasASumatoria = 0
	Double facturasA21Sumatoria = 0
	Double facturasA10Sumatoria = 0
	Double facturasA27Sumatoria = 0
	Double facturasA2Sumatoria = 0
	Double facturasA5Sumatoria = 0

	Double noGravadoFacturasASumatoria = 0
	Double exentoFacturasASumatoria = 0

	Double otrasFacturasSumatoria = 0
	Double otrasFacturas21Sumatoria = 0
	Double otrasFacturas10Sumatoria = 0
	Double otrasFacturas27Sumatoria = 0
	Double otrasFacturas2Sumatoria = 0
	Double otrasFacturas5Sumatoria = 0

	Double noGravadoOtrasFacturasSumatoria = 0
	Double exentoOtrasFacturasSumatoria = 0

	Double netoVentaSumatoria = 0
	Double netoVenta21Sumatoria = 0
	Double netoVenta10Sumatoria = 0
	Double netoVenta27Sumatoria = 0
	Double netoVenta2Sumatoria = 0
	Double netoVenta5Sumatoria = 0
	Double netoVenta0Sumatoria = 0

	Double netoNoGravadoVentaSumatoria = 0
	Double exentoVentaSumatoria = 0

	Double debitoFiscalSumatoria = 0
	Double debitoFiscal21Sumatoria = 0
	Double debitoFiscal10Sumatoria = 0
	Double debitoFiscal27Sumatoria = 0
	Double debitoFiscal2Sumatoria = 0
	Double debitoFiscal5Sumatoria = 0
	Double debitoFiscal0Sumatoria = 0

	Double totalVentaSumatoria = 0
	Double totalVenta21Sumatoria = 0
	Double totalVenta10Sumatoria = 0
	Double totalVenta27Sumatoria = 0
	Double totalVenta2Sumatoria = 0
	Double totalVenta5Sumatoria = 0

	Double totalNoGravadoVentaSumatoria = 0
	Double totalExentoVentaSumatoria = 0

	//Datos que están en venta pero no en compra:
	Double importeOtrosTributosVentaSumatoria = 0

	Double netoCompraSumatoria = 0
	Double netoCompra21Sumatoria = 0
	Double netoCompra10Sumatoria = 0
	Double netoCompra27Sumatoria = 0
	Double netoCompra2Sumatoria = 0
	Double netoCompra5Sumatoria = 0

	Double netoNoGravadoCompraSumatoria = 0
	Double exentoCompraSumatoria = 0

	Double creditoFiscalSumatoria = 0
	Double creditoFiscal21Sumatoria = 0
	Double creditoFiscal10Sumatoria = 0
	Double creditoFiscal27Sumatoria = 0
	Double creditoFiscal2Sumatoria = 0
	Double creditoFiscal5Sumatoria = 0

	Double totalCompraSumatoria = 0
	Double totalCompra21Sumatoria = 0
	Double totalCompra10Sumatoria = 0
	Double totalCompra27Sumatoria = 0
	Double totalCompra2Sumatoria = 0
	Double totalCompra5Sumatoria = 0

	Double totalNoGravadoCompraSumatoria = 0
	Double totalExentoCompraSumatoria = 0

	Double percepcionImportadaSumatoria = 0
	Double retencionImportadaSumatoria = 0

	Boolean pisarDatos
	Boolean facturasCompraImportadas = false
	Boolean facturasVentaImportadas = false

	static constraints = {
		liquidacionIvaId nullable:true
		version nullable:true

		mes nullable:false
		ano nullable:false
		porcentajeDebitoCredito nullable:true

		fechaVencimiento nullable:true

		netoVenta nullable:true
		netoVenta21 nullable:true
		netoVenta10 nullable:true
		netoVenta27 nullable:true
		netoVenta2 nullable:true
		netoVenta5 nullable:true

		netoNoGravadoVenta nullable:true
		exentoVenta nullable:true

		debitoFiscal nullable:true
		debitoFiscal21 nullable:true
		debitoFiscal10 nullable:true
		debitoFiscal27 nullable:true
		debitoFiscal2 nullable:true
		debitoFiscal5 nullable:true

		totalVenta nullable:true
		totalVenta21 nullable:true
		totalVenta10 nullable:true
		totalVenta27 nullable:true
		totalVenta2 nullable:true
		totalVenta5 nullable:true

		totalNoGravadoVenta nullable:true
		totalExentoVenta nullable:true

		netoCompra nullable:true
		netoCompra21 nullable:true
		netoCompra10 nullable:true
		netoCompra27 nullable:true
		netoCompra2 nullable:true
		netoCompra5 nullable:true

		netoNoGravadoCompra nullable:true
		exentoCompra nullable:true

		creditoFiscal nullable:true
		creditoFiscal21 nullable:true
		creditoFiscal10 nullable:true
		creditoFiscal27 nullable:true
		creditoFiscal2 nullable:true
		creditoFiscal5 nullable:true

		totalCompra nullable:true
		totalCompra21 nullable:true
		totalCompra10 nullable:true
		totalCompra27 nullable:true
		totalCompra2 nullable:true
		totalCompra5 nullable:true

		totalNoGravadoCompra nullable:true
		totalExentoCompra nullable:true

		percepcionImportadaSumatoria nullable:true
		retencionImportadaSumatoria nullable:true

		debitoMenosCredito nullable:true
		saldoTecnicoAFavorPeriodoAnterior nullable:true
		saldoTecnicoAFavor nullable:true

		saldoLibreDisponibilidadPeriodoAnterior nullable:true
		saldoLibreDisponibilidad nullable:true
		retencion nullable:true
		percepcion nullable:true

		saldoDdjj nullable:true

		nota nullable:true

		estadoId nullable:true

		cuentaId nullable:false

		netoVentaSumatoria nullable:true
		netoVenta21Sumatoria nullable:true
		netoVenta10Sumatoria nullable:true
		netoVenta27Sumatoria nullable:true
		netoVenta2Sumatoria nullable:true
		netoVenta5Sumatoria nullable:true
		netoVenta0Sumatoria nullable:true

		netoNoGravadoVentaSumatoria nullable:true
		exentoVentaSumatoria nullable:true

		debitoFiscalSumatoria nullable:true
		debitoFiscal21Sumatoria nullable:true
		debitoFiscal10Sumatoria nullable:true
		debitoFiscal27Sumatoria nullable:true
		debitoFiscal2Sumatoria nullable:true
		debitoFiscal5Sumatoria nullable:true
		debitoFiscal0Sumatoria nullable:true

		totalVentaSumatoria nullable:true
		totalVenta21Sumatoria nullable:true
		totalVenta10Sumatoria nullable:true
		totalVenta27Sumatoria nullable:true
		totalVenta2Sumatoria nullable:true
		totalVenta5Sumatoria nullable:true

		totalNoGravadoVentaSumatoria nullable:true
		totalExentoVentaSumatoria nullable:true

		//Datos que están en venta pero no en compra:
		importeOtrosTributosVentaSumatoria nullable:true

		netoCompraSumatoria nullable:true
		netoCompra21Sumatoria nullable:true
		netoCompra10Sumatoria nullable:true
		netoCompra27Sumatoria nullable:true
		netoCompra2Sumatoria nullable:true
		netoCompra5Sumatoria nullable:true

		netoNoGravadoCompraSumatoria nullable:true
		exentoCompraSumatoria nullable:true

		creditoFiscalSumatoria nullable:true
		creditoFiscal21Sumatoria nullable:true
		creditoFiscal10Sumatoria nullable:true
		creditoFiscal27Sumatoria nullable:true
		creditoFiscal2Sumatoria nullable:true
		creditoFiscal5Sumatoria nullable:true

		totalCompraSumatoria nullable:true
		totalCompra21Sumatoria nullable:true
		totalCompra10Sumatoria nullable:true
		totalCompra27Sumatoria nullable:true
		totalCompra2Sumatoria nullable:true
		totalCompra5Sumatoria nullable:true

		totalNoGravadoCompraSumatoria nullable:true
		totalExentoCompraSumatoria nullable:true

		pisarDatos nullable:true

		facturasVentaImportadas nullable:true
		facturasCompraImportadas nullable:true

	}
}
