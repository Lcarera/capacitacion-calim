package com.zifras.mercadopago

class IdentificationMP{
 	private static final long serialVersionUID = 1
	
	String type
	String number
	static constraints = {
		type nullable:true
		number nullable:true
	}
}