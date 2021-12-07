package com.zifras.documento
import com.zifras.cuenta.Cuenta
// import com.zifras.cuenta.CuentaService

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON
import com.zifras.Estado

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import com.zifras.AccessRulesService

@Secured(['ROLE_CUENTA', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class VepUsuarioController {
	AccessRulesService accessRulesService
	def vepService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
		def cuenta = accessRulesService.getCurrentUser().cuenta?.id
		[cuentaId: cuenta,filtrarPorNoPagados:false]
	}

	def listNoPagos() {
		def cuenta = accessRulesService.getCurrentUser().cuenta?.id
		render(view: "list", model: [cuentaId: cuenta, filtrarPorNoPagados:true])
	}
}