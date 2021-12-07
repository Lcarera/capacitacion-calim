package com.zifras.mercadopago

class CardMP{
  private static final long serialVersionUID = 1

  Integer myId
  String last_four_digits
  String first_six_digits
  Integer expiration_year
  Integer expiration_month
  String date_created
  String date_last_updated
  CardholderMP cardholder

	static constraints = {
    myId nullable:true
    last_four_digits nullable:true
    first_six_digits nullable:true
    expiration_year nullable:true
    expiration_month nullable:true
    date_created nullable:true
    date_last_updated nullable:true
    cardholder nullable:true
  }
}