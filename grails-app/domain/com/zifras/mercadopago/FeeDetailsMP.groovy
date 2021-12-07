package com.zifras.mercadopago

class FeeDetailsMP{
  private static final long serialVersionUID = 1
	
  String type
  /*Values
      mercadopago_fee:  Cost for using MercadoPago
      coupon_fee:  Discount given by a coupon
      financing_fee:  Cost of financing
      shipping_fee:  Shipping cost
      application_fee:  Marketplace comision for the service
      discount_fee:  Discount given by the seller through cost absorption*/
  String fee_payer
  /*Values
    collector:  The seller absorbs the cost
    payer:  The buyer absorbs the cost*/
  Float amount

  static belongsTo = [paymentMP:PaymentMP]
  
	static constraints = {
    type nullable:true
    fee_payer nullable:true
    amount nullable:true
  }
}