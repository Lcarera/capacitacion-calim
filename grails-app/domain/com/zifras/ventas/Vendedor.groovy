package com.zifras.ventas
import com.zifras.TokenGoogle

class Vendedor {
	String nombre
	String email
	String celular
	String cuentaGoogle
	Boolean turnoManana 
	Boolean turnoTarde
	Boolean vacaciones = false
	Horario horario
	Boolean deshabilitado = false
	Long bitrixId
	TokenGoogle tokenGoogle

    static constraints = {
		nombre nullable:false
		email nullable:false
		celular nullable:true
		cuentaGoogle nullable:true
		turnoManana nullable:true
		turnoTarde nullable:true
		vacaciones nullable:true
		horario nullable:true
		deshabilitado nullable:true
		bitrixId nullable:true
		tokenGoogle nullable:true
    }

   	def deTurno(Integer hora, String diaHoy){
   		if(hora>=21 || hora<=8)
   			hora = 10
   		if(this.horario != null)
   			return this.horario[diaHoy].horaDisponible(hora)
   		return false
   	}
}
