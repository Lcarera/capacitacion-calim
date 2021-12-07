package com.zifras.ventas

import com.zifras.AccessRulesService
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured(["ROLE_ADMIN","ROLE_VENTAS","ROLE_CUENTA"])
class VendedorController{
	def vendedorService
	AccessRulesService accessRulesService

	def list(){} 
	def show(){}

	def crearFechasDiasExtra(){
		vendedorService.definirFechasFinDeSemana()
		vendedorService.definirFechasFeriado()
		render "Fechas de dias extra creadas"
	}

	def generarHorarios(){
		try{
			vendedorService.generarHorarios()
		}
		catch(e){
			render "Ocurrio un error"
		}
		render "Horarios creados correctamente"
	}
	@Secured(["ROLE_ADMIN","ROLE_VENTAS","ROLE_SM","ROLE_SE","ROLE_COBRANZA","ROLE_CUENTA"])
	def ajaxGetVendedores(){
		render vendedorService.listVendedoresActivos() as JSON
	}
	@Secured(["ROLE_ADMIN","ROLE_VENTAS","ROLE_SM","ROLE_SE","ROLE_COBRANZA","ROLE_CUENTA"])
	def ajaxGetHorariosVendedores(){
		render vendedorService.listHorariosVendedores() as JSON
	}
	def ajaxGetListaDiasExtra(){
		render vendedorService.listDiasExtra() as JSON
	}
	def ajaxAsignarDiaExtra(Long id){
		def resultado = [:]
		try{
			def vendedorEmail = accessRulesService.getCurrentUser()?.username
			resultado['ok'] = vendedorService.vendedorTrabajaDiaExtra(vendedorEmail, id)
		}
		catch(e){
			resultado['error'] = e.message
		}

		render resultado as JSON
	}
	
	def ajaxCrearVendedor(){
		def resultado = [:]
		try{
			resultado['ok'] = vendedorService.crearVendedor(params.nombre, params.email, params.celular, params.cuentaGoogle)
		}
		catch(e){
			resultado['error'] = e.message
		}

		render resultado as JSON
	}

	def ajaxEditarVendedor(){
		def resultado = [:]
		try{
			resultado['ok'] = vendedorService.editarVendedor(params.vendedorId, params.nombre, params.email, params.celular, params.cuentaGoogle, new Boolean(params.vacaciones))
		}
		catch(e){
			resultado['error'] = e.message
		}

		render resultado as JSON
	}

	def ajaxDeshabilitarVendedor(){
		def resultado = [:]
		try{
			resultado['ok'] = vendedorService.deshabilitarVendedor(params.id)
		}
		catch(e){
			resultado['error'] = e.message
		}

		render resultado as JSON
	}

	def ajaxEditarHorario(){
		def resultado = [:]
		try{
			resultado['ok'] = vendedorService.editarHorario(params)
		}
		catch(e){
			resultado['error'] = e.message
		}

		render resultado as JSON

	}

}