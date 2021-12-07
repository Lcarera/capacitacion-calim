package com.zifras

class TokenGoogle {

	String usuario
	String refreshToken

    static constraints = {
		usuario nullable:false
		refreshToken nullable:false
    }

}