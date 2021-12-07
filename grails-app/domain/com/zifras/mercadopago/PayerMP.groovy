package com.zifras.mercadopago

class PayerMP{
  private static final long serialVersionUID = 1
	
  String entity_type
  /*Values
    individual:  Payer is individual
    association:  Payer is an association*/
  String type
  /*Values
      customer:   Payer is a Customer and belongs to the collector
      registered:   The account corresponds to a MercadoPago registered user
      guest:   The payer doesn't have an account*/
  String myId
  String email
  IdentificationMP identification
  PhoneMP phone
  String first_name
  String last_name

  //Datos de AdditionalInfoMP:
  AddressMP address
  String registration_date
  
	static constraints = {
    entity_type nullable:true
    type nullable:true
    myId nullable:true
    email nullable:true
    identification nullable:true
    phone nullable:true
    first_name nullable:true
    last_name nullable:true
    address nullable:true
    registration_date nullable:true
  }
}