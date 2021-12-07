package com.zifras.mercadopago

class BarcodeMP{
	private static final long serialVersionUID = 1

	String type
	  /*Values
		UCC/EAN 128:  Encodes data using the Code 128 symbology
		Code128C:  High-density alphanumeric code
		Code39:  Media density code*/
	String content
	Integer width
	Integer height

	static constraints = {
		type nullable:true
		content nullable:true
		width nullable:true
		height nullable:true
  }
}