package com.zifras.mercadopago

class AdditionalInfoMP{
  private static final long serialVersionUID = 1

  String ip_address
  PayerMP payer
  ShipmentsMP shipments
  BarcodeMP barcode

  static hasMany = [items: ItemMP]

  static constraints = {
    ip_address nullable:true
	payer nullable:true
	shipments nullable:true
	barcode nullable:true
  }
}