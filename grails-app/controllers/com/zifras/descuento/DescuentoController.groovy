package com.zifras.descuento

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import org.joda.time.LocalDate

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class DescuentoController {
	def descuentoService

    def index() {
		redirect(action: "codigos", params: params)
	}

	def codigos() {
		[fechaExpiracionDefault: new LocalDate().plusMonths(1).toString("dd/MM/YYYY")]
	}

	def ajaxGenerarCodigos(CodigoDescuentoCommand command){
		def resultado = [:]
		try {
			descuentoService.generarCodigos(command)
			resultado['estado'] = 'ok'
		}
		catch(Exception e) {
			resultado['estado'] = 'error'
		}
		render resultado as JSON
	}

	def ajaxGetCodigos(){
		render descuentoService.listCodigos() as JSON
	}

	def ajaxBorrarCodigos(String idsCodigos){
		try {
			render descuentoService.borrarCodigos(idsCodigos) as JSON	
		}
		catch(Exception e) {
			def salida = [:]
			salida['error'] = "No se pudieron borrar los códigos seleccionados"
			render salida as JSON
		}
	}
}
