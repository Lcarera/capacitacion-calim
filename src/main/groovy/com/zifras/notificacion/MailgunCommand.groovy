package com.zifras.notificacion

import grails.validation.Validateable

class MailgunCommand implements Validateable {
	String mailgunId
	String event
	String recipient
	String domain
	String ip
	String country
	String region
	String city
	String userAgent
	String deviceType
	String clientType
	String clientName
	String clientOs
	String campaignId
	String campaignName
	String tag
	String mailingList
	String customVariables
	String timestamp
	String token
	String signature
	
	static constraints = {
		mailgunId nullable:true
		event nullable:true
		recipient nullable:true
		domain nullable:true
		ip nullable:true
		country nullable:true
		region nullable:true
		city nullable:true
		userAgent nullable:true
		deviceType nullable:true
		clientType nullable:true
		clientName nullable:true
		clientOs nullable:true
		campaignId nullable:true
		campaignName nullable:true
		tag nullable:true
		mailingList nullable:true
		customVariables nullable:true
		timestamp nullable:true
		token nullable:true
		signature nullable:true
	}
}
