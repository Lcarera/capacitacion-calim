package com.zifras.importacion

import com.zifras.documento.PagoCuenta
class DetalleErroneoMP {
	Long notificacionId
	String mailPagante
	String fechaHora
	String descripcion
	String estado
	Double monto

	String tipoError
	String logDisparo
	PagoCuenta pago
	Double montoSistema
	String estadoSistema

	static belongsTo = [log:LogMercadoPago]

	static constraints = {
		montoSistema nullable:true
		logDisparo nullable:true
		estadoSistema nullable:true
		pago nullable:true
		mailPagante nullable:true
	}
}
