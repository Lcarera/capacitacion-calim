package com.zifras.facturacion

import com.zifras.afip.AfipService

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
// import grails.validation.ValidationException
// import org.springframework.dao.DataIntegrityViolationException

@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class PuntoVentaController {
	def afipService
	def puntoVentaService
	
	def index() {
		redirect(action: "list", params: params)
	}

	def list() {
	}

	@Secured(['ROLE_USER', 'ROLE_RIDER_PY', 'ROLE_CUENTA', 'ROLE_SM', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def obtenerDeAfip(Long cuentaId){
		render afipService.getPuntosDeVenta(cuentaId)
	}

	@Secured(['ROLE_USER', 'ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetPuntosVenta(Long cuentaId){
		def puntosVenta = puntoVentaService.listPuntoVenta(cuentaId)
		render puntosVenta as JSON
	}
	
	def ajaxGetPuntoVenta(Long id) {
		def puntoVenta = puntoVentaService.getPuntoVenta(id)
		render puntoVenta as JSON
	}
}
