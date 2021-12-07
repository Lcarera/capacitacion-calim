package com.zifras

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON
import com.zifras.EstadoService

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM','ROLE_COBRANZA', 'IS_AUTHENTICATED_FULLY'])
class EstadoController {
	def estadoService
	
    def index() { }
	
	def ajaxGetEstados(){
		def estados = estadoService.listEstado()
		render estados as JSON
	}
	
	def ajaxGetVepEstados(String filter){
		def estados = estadoService.getEstadosVEP(filter)
		render estados as JSON
	}

	def ajaxGetpagoCuentaEstados(String filter){
		def estados = estadoService.getEstadosPagoCuenta(filter)
		render estados as JSON
	}

	def ajaxGetLiquidacionIvaEstados(){
		def estados = estadoService.getEstadosLiquidacionIva()
		render estados as JSON
	}
	
	def ajaxGetLiquidacionIIBBEstados(){
		def estados = estadoService.getEstadosLiquidacionIIBB()
		render estados as JSON
	}
	
	def ajaxGetLiquidacionGananciaEstados(){
		def estados = estadoService.getEstadosLiquidacionGanancia()
		render estados as JSON
	}
	
	def ajaxGetLocales(){
		def estados = estadoService.getEstadosLocales()
		render estados as JSON
	}
	
	def ajaxGetAlicuotasIIBB(){
		def estados = estadoService.getEstadosAlicuotasIIBB()
		render estados as JSON
	}
	
	def ajaxGetTiposClave(){
		render estadoService.getEstadosTipoClave() as JSON
	}
	
	def ajaxGetEstado(Long id) {
		def estado = estadoService.getEstado(id)
		render estado as JSON
	}
	
	def ajaxGetDeclaracionJuradaEstados(){
		render estadoService.getDeclaracionJuradaEstados() as JSON
	}
}
