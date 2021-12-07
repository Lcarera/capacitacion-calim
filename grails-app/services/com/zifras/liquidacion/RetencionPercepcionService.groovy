package com.zifras.liquidacion

import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import com.zifras.cuenta.Cuenta
import org.joda.time.LocalDate
import com.zifras.Provincia
import grails.transaction.Transactional

@Transactional
class RetencionPercepcionService {
	AccessRulesService accessRulesService
	
	def createRetencionPercepcionCommand(){
		def command = new RetencionPercepcionCommand()
		command.tipo="retencion"
		return command
	}
	
	def listRetencionPercepcion(String mes, String ano, Long cuentaId, boolean iva, Provincia provincia = null) {
		def cuentaInstance = Cuenta.get(cuentaId)
		def fechaMin = new LocalDate(ano + '-' + mes + '-01')
		return listRetencionPercepcion(fechaMin,cuentaInstance,iva,provincia)
	}
	
	def listRetencionPercepcion(LocalDate fechaMin, Cuenta cuentaInstance, boolean iva, Provincia provincia = null) {
		def fechaMax = fechaMin.plusMonths(1)
		return (iva ? RetencionPercepcionIva : RetencionPercepcionIIBB).createCriteria().list() {
				and{
					eq('cuenta', cuentaInstance)
					ge('fecha', fechaMin)
					lt('fecha', fechaMax)
					if (provincia)
						eq('provincia', provincia)
				}
			}
	}

	def calcularRetencionPercepcionSumatoria(Long cuentaId, String mes, String ano, boolean iva, Provincia provincia = null){
		Double percepcionesSumatoria = 0
		Double retencionesSumatoria = 0
		Double bancariasSumatoria = 0
		listRetencionPercepcion(mes, ano, cuentaId, iva, provincia).each{
			if (it.tipo == "percepcion")
				percepcionesSumatoria += it.monto
			else if (it.tipo == "retencion")
				retencionesSumatoria += it.monto
			else
				bancariasSumatoria += it.monto
		}
		def lista = []
		lista.push(retencionesSumatoria)
		lista.push(bancariasSumatoria)
		lista.push(percepcionesSumatoria)
		return lista
	}
	
	def getRetencionPercepcion(Long id, boolean iva){
		return iva ? RetencionPercepcionIva.get(id) : RetencionPercepcionIIBB.get(id)
	}
	
	def getRetencionPercepcionCommand(Long id, boolean iva){
		def retencionPercepcionInstance = getRetencionPercepcion(id, iva)
		
		if (retencionPercepcionInstance)
			return pasarDatos(retencionPercepcionInstance, createRetencionPercepcionCommand())
		else
			return null
	}
	
	def deleteRetencionPercepcion(Long id, boolean iva){
		def retencionPercepcionInstance = getRetencionPercepcion(id, iva)
		if (iva){
			def log = retencionPercepcionInstance.logImportacion
			retencionPercepcionInstance.cuenta.removeFromRetPerIva(retencionPercepcionInstance).save(flush:false, failOnError:true)
			if (log)
				log.removeFromRetPerIva(retencionPercepcionInstance).save(flush:false, failOnError:true)
		}else{
			def log = retencionPercepcionInstance.logImportacion
			retencionPercepcionInstance.cuenta.removeFromRetPerIIBB(retencionPercepcionInstance).save(flush:false, failOnError:true)
			if (log)
				log.removeFromRetPerIIBB(retencionPercepcionInstance).save(flush:false, failOnError:true)
		}
	}
	
	def saveRetencionPercepcion(RetencionPercepcionCommand command, boolean iva){
		// MENOR: Combo de provincia para RetPer
		return pasarDatos(command, ((iva) ? new RetencionPercepcionIva() : new RetencionPercepcionIIBB())).save(flush:true, failOnError:true)
	}
	
	def updateRetencionPercepcion(RetencionPercepcionCommand command, boolean iva){
		def retencionPercepcionInstance = getRetencionPercepcion(command.retencionPercepcionId, iva)
		
		if (command.version != null) {
			if (retencionPercepcionInstance.version > command.version) {
				RetencionPercepcionCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["FacturaCompra"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la factura")
				throw new ValidationException("Error de versión", RetencionPercepcionCommand.errors)
			}
		}
		
		
		return pasarDatos(command, retencionPercepcionInstance).save(flush:true, failOnError:true)
	}

	def limpiarMes(LocalDate mes, Long cuentaId){
		limpiarMes(mes, Cuenta.get(cuentaId))
	}

	def limpiarMes(LocalDate mes, Cuenta cuenta){
		listRetencionPercepcion(mes, cuenta, false)*.delete(flush:true)
	}

	def pasarDatos(origen,destino){
		//Datos complejos:
			// MENOR: Pasar la provincia al command y viceversa
			if (destino instanceof RetencionPercepcionCommand){
				destino.cuentaId = origen.cuenta.id
				destino.retencionPercepcionId = origen.id
				destino.version = origen.version
				destino.importado = (origen.origen != "manual")
			}else{
				destino.cuenta = Cuenta.get(origen.cuentaId)
				destino.origen = "manual"
			}
		//Datos simples:
			destino.codigo = origen.codigo
			destino.cuit = origen.cuit
			destino.fecha = origen.fecha
			destino.comprobante = origen.comprobante
			destino.facturaParteA = origen.facturaParteA
			destino.facturaParteB = origen.facturaParteB
			destino.monto = origen.monto
		    destino.montoBase = origen.montoBase
		    destino.tipo = origen.tipo
		    destino.cbu = origen.cbu
		    destino.tipoCuenta = origen.tipoCuenta
		    destino.tipoComprobante = origen.tipoComprobante
		    destino.letraComprobante = origen.letraComprobante
		return destino
	}
}