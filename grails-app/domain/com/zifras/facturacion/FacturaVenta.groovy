package com.zifras.facturacion

import com.zifras.cuenta.Cuenta
import com.zifras.PaisCodigo
import com.zifras.PaisCuit
import com.zifras.importacion.LogImportacion

import org.joda.time.LocalDate
import grails.gorm.MultiTenant
class FacturaVenta implements MultiTenant<FacturaVenta> {
	Integer tenantId
	LocalDate fecha
	Long numero
	PuntoVenta puntoVenta
	TipoComprobante tipoComprobante

	//Esto es porque aparece en AFIP
	Boolean ventaTabaco=false

	Boolean monedaExtranjera=false
	Double tipoDeCambio

	//Producto, Servicio, Producto y servicio
	TipoConcepto concepto

	//Esto es cuando el concepto es Servicio o Producto y servicio
	LocalDate periodoFacturadoDesde
	LocalDate periodoFacturadoHasta
	LocalDate periodoFacturadoVencimientoPago

	Persona cliente

	Double netoNoGravado=0
	Double exento=0
	Double neto
	Double netoGravado=0
	Double netoGravado27=0
	Double netoGravado21=0
	Double netoGravado10=0
	Double netoGravado5=0
	Double netoGravado2=0
	Double netoGravado0=0

	Double importeOtrosTributos=0

	Double iva
	Double iva27=0
	Double iva21=0
	Double iva10=0
	Double iva5=0
	Double iva2=0
	Double iva0=0

	Double total

	Boolean importado = false
	Boolean bienImportado

	Moneda moneda
	Double cotizacionMoneda
	PaisCuit cuitPais
	PaisCodigo codigoPais
	String tipoCuitPais
	Idioma idioma

	String cae
	LocalDate vencimientoCae

	LocalDate fechaInicioServicios
	LocalDate fechaFinServicios
	LocalDate fechaVencimientoPagoServicio

	String nombreArchivo

	String cbuEmisor

	// Esto le da bola a si es signo negativo

	public Integer getMultiplicador() { (this.tipoComprobante.multiplicador) }

	public Double getTotalReal(){ total * multiplicador }

	public Double getNetoReal(){ neto * multiplicador }

	public String getCodigoComprobante(){ return this.tipoComprobante.codigoAfip }

	//Falta modelar Per/Ret de ganancias, IVA, IIBB, impuestos internos, impuestos municipales

	static belongsTo = [cuenta:Cuenta, logImportacion:LogImportacion]

	//Acá falta ver que hacer con la condicion de venta de tarjeta de credito/debito que tiene más items dentro
	static hasMany = [condicionesVenta: CondicionVenta, comprobantesAsociados: ComprobanteAsociado, itemsFactura: ItemFactura]

	static mapping = {
		itemsFactura cascade: "all-delete-orphan"
		fecha index: 'facVenta_fecha_index'
		cuenta index: 'facVenta_cuenta_index'
		fecha index: 'facVenta_fechaCuenta_index'
		cuenta index: 'facVenta_fechaCuenta_index'
	}

	static constraints = {
		fecha nullable:false
		numero nullable:false
		puntoVenta nullable:false
		tipoComprobante nullable:false
		ventaTabaco nullable:false
		monedaExtranjera nullable:false
		moneda  nullable:true
		tipoDeCambio nullable:true
		concepto  nullable:false
		periodoFacturadoDesde nullable:true
		periodoFacturadoHasta nullable:true
		periodoFacturadoVencimientoPago nullable:true
		cliente nullable:false

		netoNoGravado nullable:false
		exento nullable:false
		neto nullable:true
		netoGravado nullable:false
		netoGravado27 nullable:false
		netoGravado21 nullable:false
		netoGravado10 nullable:false
		netoGravado5 nullable:false
		netoGravado2 nullable:false
		netoGravado0 nullable:false

		importeOtrosTributos nullable:false

		logImportacion nullable:true

		iva  nullable:false
		iva27 nullable:false
		iva21 nullable:false
		iva10 nullable:false
		iva5 nullable:false
		iva2 nullable:false
		iva0 nullable:false

		total nullable:false

		importado nullable:true
		bienImportado nullable:true

		cuitPais nullable:true
		codigoPais nullable:true
		idioma nullable:true
		tipoCuitPais nullable:true
		cotizacionMoneda nullable:true

		cae nullable:true
		vencimientoCae nullable:true

		fechaInicioServicios nullable:true
		fechaFinServicios nullable:true
		fechaVencimientoPagoServicio nullable:true

		nombreArchivo nullable:true
		numero(unique: ['puntoVenta', 'cuenta', 'tipoComprobante'])

		cbuEmisor nullable:true
	}

	Boolean esFacturaCancelada(){
		return comprobantesAsociados.any{it.nombre.contains("Nota de Crédito")}
	}

	Boolean esNotaDeCredito(){
		return this.tipoComprobante.nombre.contains("Nota de Crédito")
	}

	Boolean esDeExportacion(){
		return this.tipoComprobante.letra == "E"
	}

	Double getmontoLiquidable(){
		if (tipoComprobante.letra == 'E')
			return 0
		else if (tipoComprobante.letra == 'C')
			return getTotalReal()
		else
			return getNetoReal()
	}
}