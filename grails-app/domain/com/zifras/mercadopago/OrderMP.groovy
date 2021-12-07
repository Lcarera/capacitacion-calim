package com.zifras.mercadopago

class OrderMP{
  private static final long serialVersionUID = 1
	
  String type
  /*Values
      mercadolibre: The order is from MercadoLibre
      mercadopago: It is a MercadoPago merchant_order*/
  Long myId
  
	static constraints = {
    type nullable:true
    myId nullable:true
  }
}