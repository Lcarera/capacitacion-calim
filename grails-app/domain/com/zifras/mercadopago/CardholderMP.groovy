package com.zifras.mercadopago

class CardholderMP{
  private static final long serialVersionUID = 1
  String name
  IdentificationMP identification

	static constraints = {
		name nullable:true
		identification nullable:true
  }
}