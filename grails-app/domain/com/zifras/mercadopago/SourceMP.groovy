package com.zifras.mercadopago

class SourceMP{
  private static final long serialVersionUID = 1
  String myId
  String name
  String type
  /*Values
      collector:  The collector issued the refund
      operator:  The refund was made by an account's operator
      admin:  The refund was made by a MercadoPago administrator
      bpp:  The refund was made by the MercadoPago's Buyer Protection Program*/

	static constraints = {
    myId nullable:true
    name nullable:true
    type nullable:true
  }
}