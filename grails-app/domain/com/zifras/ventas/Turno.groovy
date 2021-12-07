package com.zifras.ventas

class Turno{

	Integer entrada 
	Integer salida

	def horaDisponible(Integer hora){
		return hora >= this.entrada && hora < this.salida
	}	

	def setEntrada(Integer ent){
		this.entrada = ent
	}

	def setSalida(Integer sal){
		this.salida = sal
	}

	public String toString(){
		return entrada + " - " + salida + " hs"
	}
}