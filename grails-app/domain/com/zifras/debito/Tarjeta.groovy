package com.zifras.debito

class Tarjeta{
	
	String numero
	boolean credito = true
	boolean visa


	public getMastercard(){
		return !this.visa
	}

	public getDebito(){
		return !this.credito
	}

	public getNumeroOculto(){
		return "************" + numero.substring(numero.length() - 4,numero.length())
	}
}