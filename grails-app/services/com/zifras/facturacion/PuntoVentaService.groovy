package com.zifras.facturacion

import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional
import com.zifras.cuenta.Cuenta

@Transactional
class PuntoVentaService {
	AccessRulesService accessRulesService
	
	/*def createPuntoVentaCommand(){
		def command = new PuntoVentaCommand()
		return command
	}*/
	
	def listPuntoVenta(Long cuentaId) {
		return Cuenta.get(cuentaId)?.puntosDeVenta?.sort{it.numero}
	}
	
	def getPuntoVenta(Long id){
		def puntoVentaInstance = PuntoVenta.get(id)
	}
	
	/*def getPuntoVentaCommand(Long id){
		def puntoVentaInstance = PuntoVenta.get(id)
		
		if(puntoVentaInstance!=null){
			def command = new PuntoVentaCommand()
			
			command.puntoVentaId = puntoVentaInstance.id
			command.version = puntoVentaInstance.version
			command.nombre = puntoVentaInstance.nombre
			command.codigoAfip = puntoVentaInstance.codigoAfip
			
			return command
		} else {
			return null
		}
	}*/
	
	def getPuntoVentaList() {
		lista = PuntoVenta.list();
	}
	
	/*def deletePuntoVenta(Long id){
		def puntoVentaInstance = PuntoVenta.get(id)
		puntoVentaInstance.delete(flush:true)
	}
	
	def savePuntoVenta(PuntoVentaCommand command){
		def puntoVentaInstance = new PuntoVenta()
		
		puntoVentaInstance.nombre = command.nombre
		puntoVentaInstance.codigoAfip = command.codigoAfip
		puntoVentaInstance.save(flush:true)
		
		return puntoVentaInstance
	}
	
	def updatePuntoVenta(PuntoVentaCommand command){
		def puntoVentaInstance = PuntoVenta.get(command.puntoVentaId)
		
		if (command.version != null) {
			if (puntoVentaInstance.version > command.version) {
				PuntoVentaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["PuntoVenta"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el tipo de comprobante")
				throw new ValidationException("Error de versión", PuntoVentaCommand.errors)
			}
		}
		
		puntoVentaInstance.nombre = command.nombre
		puntoVentaInstance.codigoAfip = command.codigoAfip
		puntoVentaInstance.save(flush:true)
		
		return puntoVentaInstance
	}*/
	
	def getCantidadPuntoVentasTotales(){
		return PuntoVenta.count()
	}
}

