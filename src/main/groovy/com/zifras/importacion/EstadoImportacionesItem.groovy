package com.zifras.importacion

class EstadoImportacionesItem {

	Long clienteId
	Long cantidadFacturasCompra = 0
	Long cantidadFacturasVenta = 0
	Long cantidadRetencionesIva = 0
	Long cantidadPercepcionesIva = 0
	Long cantidadRetencionesIibb = 0
	Long cantidadPercepcionesIibb = 0
	Long cantidadBancarias = 0
	String fecha
	String archivos = ''

	boolean retencionesIva = false
	boolean percepcionesIva = false
	boolean retencionesIibb = false
	boolean percepcionesIibb = false
	boolean bancarias = false

	boolean compra = false
	boolean venta = false
}
