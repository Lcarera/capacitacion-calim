package com.zifras.cuenta

import grails.transaction.Transactional
import grails.validation.ValidationException

@Transactional
class MedioPagoService {

	def createMedioPagoCommand(){
		return new MedioPagoCommand()
	}

	def saveMedioPago(MedioPagoCommand command){
		return pasarDatos(command, new MedioPago()).save(flush:true, failOnError:true)
	}

	def updateMedioPago(MedioPagoCommand command){
		MedioPago.get(command.medioPagoId)?.with{
			if (version > command.version){
				MedioPagoCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["MedioPago"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el Elemento FAQ")
				throw new ValidationException("Error de versión", MedioPagoCommand.errors)
			}
			return pasarDatos(command, it).save(flush:true, failOnError:true)
		}
	}

	def deleteMedioPago(Long id){
		MedioPago.get(id)?.delete(flush:true, failOnError:true)
	}

	def listMediosPago(){
		return MedioPago.getAll()
	}

	def getMedioPago(Long id){
		return MedioPago.get(id)
	}
	
	def getMedioPagoCommand(Long id){
		return MedioPago.get(id)?.with{pasarDatos(it, new MedioPagoCommand())}
	}

	// def listElementoFaq(String filter) {}

	private pasarDatos(origen, destino){
		destino.with{
			nombre = origen.nombre
			afip = origen.afip
			agip = origen.agip
			arba = origen.arba
			if (destino instanceof MedioPagoCommand){
				medioPagoId = origen.id
				version = origen.version
			}
		}
		return destino
	}
		
}
