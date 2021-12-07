package com.zifras.mercadopago

class PhoneMP{
 	private static final long serialVersionUID = 1
	String area_code
	String number
	String extension

	static constraints = {
		area_code nullable:true
		number nullable:true
		extension nullable:true
	}
}