package com.zifras.mercadopago

class ShipmentsMP{
  private static final long serialVersionUID = 1
  AddressMP receiver_address

	static constraints = {
		receiver_address nullable: true
  }
}