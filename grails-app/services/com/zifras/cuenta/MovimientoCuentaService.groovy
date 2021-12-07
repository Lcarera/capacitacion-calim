package com.zifras.cuenta

import com.zifras.AccessRulesService
import com.zifras.Estudio
import com.zifras.documento.DeclaracionJurada
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.PagoCuenta

import grails.config.Config
import grails.transaction.Transactional
import grails.validation.ValidationException
import groovy.json.JsonSlurper
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import org.springframework.web.multipart.MultipartFile

@Transactional
class MovimientoCuentaService {
	AccessRulesService accessRulesService
	def grailsApplication

	def saveMovimientoCuentaPago(PagoCuenta pagoCuentaInstance){
		def movimientoCuentaInstance = new MovimientoCuenta()

		def movimientoMPId = MovimientoCuenta.findByPago(pagoCuentaInstance)?.movimientoMPId

		movimientoCuentaInstance.pago = pagoCuentaInstance
		movimientoCuentaInstance.cuenta = pagoCuentaInstance.cuenta
		movimientoCuentaInstance.importe = pagoCuentaInstance.importe
		movimientoCuentaInstance.descripcion = pagoCuentaInstance.descripcion
		movimientoCuentaInstance.fechaHora = pagoCuentaInstance.fechaPago

		movimientoCuentaInstance.saldo = movimientoCuentaInstance.saldoAnterior = 0 

		if (movimientoMPId)
			movimientoCuentaInstance.movimientoMPId = movimientoMPId

		movimientoCuentaInstance.save(flush:true)

		calcularSaldo(movimientoCuentaInstance.cuenta.id,movimientoCuentaInstance.fechaHora)
	}

	def saveMovimientoCuentaFactura(FacturaCuenta facturaCuentaInstance){
		def movimientoCuentaInstance = new MovimientoCuenta()

		movimientoCuentaInstance.factura = facturaCuentaInstance
		movimientoCuentaInstance.cuenta = facturaCuentaInstance.cuenta
		movimientoCuentaInstance.importe = facturaCuentaInstance.importe
		movimientoCuentaInstance.descripcion = facturaCuentaInstance.descripcion
		movimientoCuentaInstance.fechaHora = new LocalDateTime().minusHours(3)
		movimientoCuentaInstance.positivo = false

		movimientoCuentaInstance.saldo = movimientoCuentaInstance.saldoAnterior = 0 

		movimientoCuentaInstance.save(flush:true)

		calcularSaldo(movimientoCuentaInstance.cuenta.id ,movimientoCuentaInstance.fechaHora)
		return movimientoCuentaInstance
	}

	def saveMovimientoCuentaDDJJ(DeclaracionJurada ddjjInstance, Double importeInput){
		def movimientoCuentaInstance = MovimientoCuenta.findByDeclaracion(ddjjInstance)
		if (movimientoCuentaInstance){
			println "Ya existía un movimiento previo para la declaración '$ddjjInstance' con ID ${ddjjInstance.id}"
			return
		}
		movimientoCuentaInstance = new MovimientoCuenta().with{
			declaracion = ddjjInstance
			cuenta = ddjjInstance.cuenta
			importe = importeInput
			descripcion = ddjjInstance.descripcion
			fechaHora = new LocalDateTime().minusHours(3)
			positivo = false
			saldo = saldoAnterior = 0 
			save(flush:true)
		}

		calcularSaldo(movimientoCuentaInstance.cuenta.id ,movimientoCuentaInstance.fechaHora)
	}

	def deleteMovimientoCuentaPago(PagoCuenta pagoCuentaInstance){
		deleteMovimientoCuenta(MovimientoCuenta.findByPago(pagoCuentaInstance)?.id)
	}

	def deleteMovimientoCuentaFactura(FacturaCuenta facturaCuentaInstance){
		deleteMovimientoCuenta(MovimientoCuenta.findByFactura(facturaCuentaInstance)?.id)
	}

	def deleteMovimientoCuentaDDJJ(DeclaracionJurada ddjjInstance){
		deleteMovimientoCuenta(MovimientoCuenta.findByDeclaracion(ddjjInstance)?.id)
	}

	def listmovimientoCuenta(Long cuentaId, LocalDateTime fechaHora=null) {
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		lista = MovimientoCuenta.createCriteria().list() {
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}
			if(fechaHora!=null){
				ge('fechaHora',fechaHora)
			}

			order('fechaHora', 'desc')
		}
		return lista
	}

	def ultimoMovimientoCuenta(Long cuentaId, LocalDateTime fechaHora=null) {
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		lista = MovimientoCuenta.createCriteria().list() {
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}
			if(fechaHora!=null){
				lt('fechaHora',fechaHora)
			}

			maxResults(1)
			order('fechaHora', 'desc')
		}
		if(lista.size()>0)
			return lista.get(0)
		else
			return null
	}

	def calcularSaldo(Long cuentaId,LocalDateTime fechaHora=null){
		def movimientos = listmovimientoCuenta(cuentaId,fechaHora).reverse()
		Cuenta cuenta = Cuenta.get(cuentaId)
		def movimientosTotales = cuenta.movimientos?.size() ?: 0
		def movimientosCantidad = movimientos?.size() ?: 0

		movimientos.eachWithIndex{ mov , i ->
			if(i==0){
				if(movimientosTotales==movimientosCantidad){
					mov.saldo = mov.importeConSigno
					mov.saldoAnterior = 0
				}else{
					mov.saldoAnterior = ultimoMovimientoCuenta(cuentaId,fechaHora)?.saldo ?: 0
					mov.saldo = mov.saldoAnterior + mov.importeConSigno
				}
			}else{
				mov.saldoAnterior = movimientos.get(i-1).saldo
				mov.saldo = mov.saldoAnterior + mov.importeConSigno
			}
			cuenta.saldo = mov.saldo
			mov.save(flush:true)
		}
		cuenta.save(flush:true)
	}

	def getMovimientoCuenta(Long id){
		def movimientoCuentaInstance = MovimientoCuenta.get(id)
	}

	def getmovimientoCuentaList() {
		lista = MovimientoCuenta.list();
	}

	def deleteMovimientoCuenta(Long id){
		MovimientoCuenta movimiento = MovimientoCuenta.get(id)
		if (movimiento){
			Long cuentaId = movimiento.cuenta.id
			movimiento.delete(flush:true)
			calcularSaldo(cuentaId)
		}
	}

	def getCantidadmovimientoCuentasTotales(){
		return MovimientoCuenta.count()
	}

}
