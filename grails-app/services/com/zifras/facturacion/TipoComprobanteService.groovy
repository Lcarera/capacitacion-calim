package com.zifras.facturacion

import com.zifras.AccessRulesService
import com.zifras.Estudio
import com.zifras.cuenta.Cuenta

import grails.transaction.Transactional
import grails.validation.ValidationException

@Transactional
class TipoComprobanteService {
	AccessRulesService accessRulesService

	def createTipoComprobanteCommand(){
		def command = new TipoComprobanteCommand()
		return command
	}

	def listTipoComprobante(Long cuentaId) {
		def lista = TipoComprobante.list(sort:'nombre')
		Cuenta cuenta = Cuenta.get(cuentaId)
		if (cuenta){
			String condIva = cuenta.condicionIva.nombre
			if (condIva == "Responsable inscripto")
				lista.removeAll{! it.responsableInscripto}
			else if (condIva == "Monotributista")
				lista.removeAll{! it.monotributista}
			lista.removeAll{it.nombre.contains("Nota de Débito")}
			lista.removeAll{it.nombre.contains("Nota de Crédito")}
			lista.removeAll{it.nombre.contains("Recibo")}
		}
		return lista
	}

	def getTipoComprobante(Long id){
		def tipoComprobanteInstance = TipoComprobante.get(id)
	}

	def getTipoComprobanteCommand(Long id){
		def tipoComprobanteInstance = TipoComprobante.get(id)

		if(tipoComprobanteInstance!=null){
			def command = new TipoComprobanteCommand()

			command.tipoComprobanteId = tipoComprobanteInstance.id
			command.version = tipoComprobanteInstance.version
			command.nombre = tipoComprobanteInstance.nombre
			command.codigoAfip = tipoComprobanteInstance.codigoAfip

			return command
		} else {
			return null
		}
	}

	def getTipoComprobanteList() {
		lista = TipoComprobante.list();
	}

	def deleteTipoComprobante(Long id){
		def tipoComprobanteInstance = TipoComprobante.get(id)
		tipoComprobanteInstance.delete(flush:true)
	}

	def saveTipoComprobante(TipoComprobanteCommand command){
		def tipoComprobanteInstance = new TipoComprobante()

		tipoComprobanteInstance.nombre = command.nombre
		tipoComprobanteInstance.codigoAfip = command.codigoAfip
		tipoComprobanteInstance.save(flush:true)

		return tipoComprobanteInstance
	}

	def updateTipoComprobante(TipoComprobanteCommand command){
		def tipoComprobanteInstance = TipoComprobante.get(command.tipoComprobanteId)

		if (command.version != null) {
			if (tipoComprobanteInstance.version > command.version) {
				TipoComprobanteCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["TipoComprobante"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el tipo de comprobante")
				throw new ValidationException("Error de versión", TipoComprobanteCommand.errors)
			}
		}

		tipoComprobanteInstance.nombre = command.nombre
		tipoComprobanteInstance.codigoAfip = command.codigoAfip
		tipoComprobanteInstance.save(flush:true)

		return tipoComprobanteInstance
	}

	def getCantidadTipoComprobantesTotales(){
		return TipoComprobante.count()
	}
}

