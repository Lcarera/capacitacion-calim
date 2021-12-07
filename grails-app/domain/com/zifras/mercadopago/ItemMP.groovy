package com.zifras.mercadopago

class ItemMP{
  private static final long serialVersionUID = 1
  String myId
  String title
  String description
  String picture_url
  String category_id
  Integer quantity
  Float unit_price

  static belongsTo = [additional_info:AdditionalInfoMP]

	static constraints = {
    myId nullable:true
    title nullable:true
    description nullable:true
    picture_url nullable:true
    category_id nullable:true
    quantity nullable:true
    unit_price nullable:true
  }
}