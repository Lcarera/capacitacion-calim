package com.zifras.security

import grails.validation.Validateable

class ResetPasswordCommand implements Validateable {
	String username
	String password
	String password2

	static constraints = {
		password blank: false, minSize: 8, maxSize: 64
		password2 blank: false, minSize: 8, maxSize: 64, validator: {value, command ->
			if (value) {
					if (value != command.password) {
							return 'sismagro.register.passwordRepeat.invalid'
					}
			}
		}
	}
}
