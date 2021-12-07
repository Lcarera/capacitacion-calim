package com.zifras.cuenta

class MedioPago{
	String nombre;
	boolean afip;
	boolean agip;
	boolean arba;
	MedioPago(String nombre, boolean afip, boolean agip, boolean arba){
		this.nombre = nombre;
		this.afip = afip;
		this.agip = agip;
		this.arba = arba;
	}
}