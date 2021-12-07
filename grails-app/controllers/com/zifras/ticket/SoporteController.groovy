package com.zifras.ticket

import com.zifras.AccessRulesService
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException
import grails.converters.JSON

import com.zifras.cuenta.Cuenta
import com.zifras.Contador

@Secured(['ROLE_USER', 'ROLE_LECTURA', 'ROLE_RIDER_PY', 'ROLE_ADMIN', 'ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
class SoporteController {
	def accessRulesService
	def soporteService

	def index(){
		def cuenta = accessRulesService.getCurrentUser()?.cuenta
		def soporteContable = EmpleadoSoporte.findByNombre("Alejandro") // luego hay que hacer un sistema de rotacion como el de los vendedores
		def faqsCuenta = soporteService.elementosFaqCuenta(cuenta.id)
		def wppSoporte = soporteContable?.celular ?: "5491162230855"
		def cantidadFaqs = faqsCuenta.size()
		def categoriasFaq = soporteService.categoriasFaq

		[cuenta:cuenta, empleadoSoporte:soporteContable, soporteWpp:wppSoporte ,faqs:faqsCuenta, cantidadFaqs:cantidadFaqs, categoriasFaq:categoriasFaq]
	}

	def listApp(){
		def cuenta = accessRulesService.getCurrentUser()?.cuenta
		def faqsCuenta = soporteService.elementosFaqCuenta(cuenta.id)
		
		render faqsCuenta as JSON		
	}

}
