package com.zifras.mercadopago

class TransactionDetailsMP{
  private static final long serialVersionUID = 1
	
  String financial_institution
  Float net_received_amount
  Float total_paid_amount
  Float installment_amount
  Float overpaid_amount
  String external_resource_url
  String payment_method_reference_id
  
	static constraints = {
    financial_institution nullable:true
    net_received_amount nullable:true
    total_paid_amount nullable:true
    installment_amount nullable:true
    overpaid_amount nullable:true
    external_resource_url nullable:true
    payment_method_reference_id nullable:true
  }
}