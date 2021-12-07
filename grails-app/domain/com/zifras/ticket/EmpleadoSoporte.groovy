package com.zifras.ticket
import com.zifras.ventas.Horario

class EmpleadoSoporte {
	String nombre
	String email
	String celular
	String cuentaGoogle
	Horario horario
	Boolean vacaciones = false
	Boolean deshabilitado = false

	static constraints = {
		nombre nullable:false
		email nullable:false
		celular nullable:true
		cuentaGoogle nullable:true
		vacaciones nullable:true
		horario nullable:true
		deshabilitado nullable:true
    }

    def deTurno(Integer hora, String diaHoy){
   		if(hora>=21 || hora<=8)
   			hora = 10
   		if(this.horario != null)
   			return this.horario[diaHoy].horaDisponible(hora)
   		return false
   	}

}