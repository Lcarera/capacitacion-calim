package com.zifras.ventas

class Horario{

	Turno lunes 
	Turno martes
	Turno miercoles
	Turno jueves
	Turno viernes 

	static mapping = {
        lunes cascade: 'save-update'
        martes cascade: 'save-update'
        miercoles cascade: 'save-update'
        jueves cascade: 'save-update'
        viernes cascade: 'save-update'
    }

	def setHorario(String dia, String ent, String sal){
		Integer entrada = new Integer(ent)
		Integer salida = new Integer(sal)
		if(entrada > salida)
			throw new Exception("La hora de entrada no puede ser mayor a la de salida")
		if(this[dia] == null)
			this[dia] = new Turno()
		this[dia].setEntrada(entrada)
		this[dia].setSalida(salida)
		this[dia].save(failOnError:true)
	}
}