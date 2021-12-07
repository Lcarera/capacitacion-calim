package com.zifras.descuento

import com.zifras.User
import com.zifras.cuenta.Cuenta

import grails.transaction.Transactional
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormat

@Transactional
class DescuentoService {
	
	def listCodigos() {
		return CodigoDescuento.list(sort:'fechaGenerado')
	}

	def borrarCodigos(String listaIds){
		listaIds.split(',').each{
			CodigoDescuento.get(it)?.delete(flush:true)
		}
	}

	def generarCodigos(CodigoDescuentoCommand command){
		User vendedor = command.vendedorId ? User.get(command.vendedorId) : null
		LocalDate expiracion =  LocalDate.parse(command.fechaExpiracion, DateTimeFormat.forPattern("dd/MM/YYYY"))
		LocalDateTime hoy = new LocalDateTime()
		for(cont in 1..command.cantidad) {
			CodigoDescuento codigo = new CodigoDescuento()
			codigo.fechaExpiracion = expiracion
			codigo.fechaGenerado = hoy
			codigo.codigo = org.apache.commons.lang.RandomStringUtils.random(8, true, true).toUpperCase().replaceAll("O","0").replaceAll("I","L")
			codigo.vendedor = vendedor
			codigo.descuento = new Double(command.descuento)
			codigo.detalle = command.detalle
			try {
				codigo.save(flush:true, failOnError:true)	
			}
			catch(grails.validation.ValidationException e) {
				cont--
			}
		}
	}
}

