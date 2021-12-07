package com.zifras

import org.joda.time.LocalDateTime
import com.zifras.User
import com.zifras.cuenta.Cuenta

class UserTrack {
	LocalDateTime fechaHora
	User user
	String ip
	String action
	String controller
	String url
	String params
	Cuenta cuenta
	
    static constraints = {
		fechaHora nullable:false
		user nullable:true
		ip nullable:true
		action nullable:true
		controller nullable:true
		url nullable:true
		params maxSize:2048, nullable:true
		cuenta nullable:true 
    }
}
