package com.zifras.facturacion

class ImportacionItem {

	Long clienteId
	Long cantidadFacturasCompra = 0
	Long cantidadFacturasVenta = 0
	String fecha
	String archivos = ''
	boolean compra = false
	boolean venta = false
}
