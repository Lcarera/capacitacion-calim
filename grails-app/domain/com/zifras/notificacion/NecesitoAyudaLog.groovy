package com.zifras.notificacion

import com.zifras.ventas.Vendedor
import org.joda.time.LocalDateTime

class NecesitoAyudaLog {
	
	LocalDateTime fechaHora
	Vendedor vendedor
	Boolean instagram

	static constraints = {
		fechaHora nullable:false
		vendedor nullable:false
		instagram nullable:true
	}
}