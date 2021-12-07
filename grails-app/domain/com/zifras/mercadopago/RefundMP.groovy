package com.zifras.mercadopago

class RefundMP{
  private static final long serialVersionUID = 1

  Integer myId
  Integer payment_id
  Float amount
  String metadata
  SourceMP source
  String date_created
  String unique_sequence_number

  static belongsTo = [paymentMP:PaymentMP]

	static constraints = {
    myId nullable:true
    payment_id nullable:true
    amount nullable:true
    metadata nullable:true, maxSize:4096
    source nullable:true
    date_created nullable:true
    unique_sequence_number nullable:true
  }
}