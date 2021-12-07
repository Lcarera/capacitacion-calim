package com.zifras.impuestos

import grails.plugin.springsecurity.annotation.Secured;

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class AlicuotasIibbController {

    def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}
}
