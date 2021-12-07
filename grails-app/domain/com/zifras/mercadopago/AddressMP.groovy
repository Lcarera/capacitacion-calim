package com.zifras.mercadopago

class AddressMP{
  private static final long serialVersionUID = 1
	
  String zip_code
  String street_name
  Integer street_number
  // Datos de ShipmentMP:
  String floor
  String apartment

	static constraints = {
    zip_code nullable:true
    street_name nullable:true
    street_number nullable:true
    floor nullable:true
    apartment nullable:true
  }
}