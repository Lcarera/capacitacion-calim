package com.zifras.mercadopago

import com.zifras.documento.PagoCuenta
import org.joda.time.LocalDate

class PaymentMP{
	private static final long serialVersionUID = 1

	Long myId
	LocalDate fechaNotificacion
	String date_created
	String date_approved
	String date_last_updated
	String money_release_date
	Integer collector_id
	String operation_type
	/*Values
		regular_payment:  Typification by default of a purchase being paid using MercadoPago
		money_transfer:  Funds transfer between two users
		recurring_payment:  Automatic recurring payment due to an active user subscription
		account_fund:  Money income in the user's account
		payment_addition:  Addition of money to an existing payment, done in MercadoPago's site
		cellphone_recharge:  Recharge of a user's cellphone account
		pos_payment:  Payment done through a Point Of Sale*/
	PayerMP payer
	boolean binary_mode
	boolean live_mode
	OrderMP order
	String external_reference
	String description
	String metadata
	String currency_id
	/*Values
		ARS: Argentine peso
		BRL: Brazilian real
		VEF: Venezuelan strong bolivar
		CLP: Chilean peso
		MXN: Mexican peso
		COP: Colombian peso
		PEN: Peruvian sol
		UYU: Uruguayan peso*/
	Float transaction_amount
	Float transaction_amount_refunded
	Float coupon_amount
	Integer campaign_id
	String coupon_code
	TransactionDetailsMP transaction_details
	Integer differential_pricing_id
	Float application_fee
	String status
	/*Values
		pending:  The user has not yet completed the payment process
		approved:  The payment has been approved and accredited
		authorized:  The payment has been authorized but not captured yet
		in_process:  Payment is being reviewed
		in_mediation:  Users have initiated a dispute
		rejected:  Payment was rejected. The user may retry payment.
		cancelled:  Payment was cancelled by one of the parties or because time for payment has expired
		refunded:  Payment was refunded to the user
		charged_back:  Was made a chargeback in the buyer’s credit card*/
	String status_detail
	boolean capture
	boolean captured
	String call_for_authorize_id
	String payment_method_id
	String issuer_id
	String payment_type_id
	/*Values
		account_money:  Money in the MercadoPago account
		ticket:  Printed ticket
		bank_transfer:  Wire transfer
		atm:  Payment by ATM
		credit_card:  Payment by credit card
		debit_card:  Payment by debit card
		prepaid_card:  Payment by prepaid card*/
	String token
	CardMP card
	String statement_descriptor
	Integer installments
	String notification_url
	String callback_url
	AdditionalInfoMP additional_info

  static hasMany = [refunds: RefundMP, fee_details: FeeDetailsMP]
  static belongsTo = [pagoCuenta:PagoCuenta]

	static constraints = {
		metadata nullable:true, maxSize:4096
		date_created nullable:true
		fechaNotificacion nullable:true
		date_approved nullable:true
		date_last_updated nullable:true
		money_release_date nullable:true
		collector_id nullable:true
		operation_type nullable:true
		payer nullable:true
		binary_mode nullable:true
		live_mode nullable:true
		order nullable:true
		external_reference nullable:true
		description nullable:true
		currency_id nullable:true
		transaction_amount nullable:true
		transaction_amount_refunded nullable:true
		coupon_amount nullable:true
		campaign_id nullable:true
		coupon_code nullable:true
		transaction_details  nullable:true
		differential_pricing_id nullable:true
		application_fee nullable:true
		status nullable:true
		status_detail nullable:true
		capture nullable:true
		captured nullable:true
		call_for_authorize_id nullable:true
		payment_method_id nullable:true
		issuer_id nullable:true
		payment_type_id nullable:true
		token nullable:true
		card nullable:true
		statement_descriptor nullable:true
		installments nullable:true
		notification_url nullable:true
		callback_url nullable:true
		additional_info nullable:true
		pagoCuenta nullable:true
  }
}