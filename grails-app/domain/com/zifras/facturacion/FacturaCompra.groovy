package com.zifras.facturacion
import org.joda.time.LocalDate
import com.zifras.importacion.LogImportacion
import com.zifras.cuenta.Cuenta

import grails.gorm.MultiTenant
class FacturaCompra implements MultiTenant<FacturaCompra> {
	Integer tenantId
	LocalDate fecha
	TipoComprobante tipoComprobante
	Long puntoVenta
	Long numero
	Persona proveedor
	Double netoGravado21 = 0
	Double netoGravado27 = 0
	Double netoGravado10 = 0
	Double netoGravado2 = 0
	Double netoGravado5 = 0
	Double netoGravado 
	Double netoNoGravado = 0
	Double exento = 0
	Double iva 
	Double iva21 = 0
	Double iva27 = 0
	Double iva10 = 0
	Double iva2 = 0
	Double iva5 = 0
	Double total
	Double percepcionImportada  = 0
	Boolean importado = false
	Boolean bienImportado

	static belongsTo = [cuenta:Cuenta, logImportacion:LogImportacion]
	
	static mapping = {
		fecha index: 'facCompra_fecha_index'
		cuenta index: 'facCompra_cuenta_index'
		fecha index: 'facCompra_fechaCuenta_index'
		cuenta index: 'facCompra_fechaCuenta_index'
	}

	static constraints = {
		iva21 nullable:true
		iva10 nullable:true
		iva27 nullable:true
		iva2 nullable:true
		iva5 nullable:true
		netoGravado21 nullable:true
		netoGravado10 nullable:true
		netoGravado27 nullable:true
		netoGravado2 nullable:true
		netoGravado5 nullable:true
		bienImportado nullable:true
		exento nullable:true
		importado nullable:true
		logImportacion nullable:true
		percepcionImportada nullable:true
		numero(unique: ['puntoVenta', 'proveedor', 'tipoComprobante', 'cuenta'])
	}

	public Integer getMultiplicador() { (this.tipoComprobante.multiplicador) }

	public Double getTotalReal(){ total * multiplicador }

	public Double getNetoReal(){ netoGravado * multiplicador }

	Double getmontoLiquidable(){
		if (tipoComprobante.letra == 'E')
			return 0
		else if (tipoComprobante.letra == 'C')
			return getTotalReal()
		else
			return getNetoReal()
	}
}
