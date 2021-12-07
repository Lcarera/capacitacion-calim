package com.zifras.facturacion

class TipoComprobante{
	String nombre
	String letra
	boolean monotributista = false
	boolean responsableInscripto = true
	String codigoAfip
    static constraints = {
    	codigoAfip nullable:true, unique:true
    	nombre nullable:false, unique:true
    }
    public Integer getMultiplicador(){ this.nombre.contains("Nota de Cr") ? -1 : 1 }
}
