package com.zifras.cuenta

import com.zifras.cuenta.CondicionIvaCommand
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional

@Transactional
class CondicionIvaService {
	AccessRulesService accessRulesService
	
	def createCondicionIvaCommand(){
		def command = new CondicionIvaCommand()
		return command
	}
	
	def listCondicionIva() {
		return CondicionIva.list(sort:'nombre')
	}
	
	def getCondicionIva(Long id){
		def condicionIvaInstance = CondicionIva.get(id)
	}
	
	def getCondicionIvaCommand(Long id){
		def condicionIvaInstance = CondicionIva.get(id)
		
		if(condicionIvaInstance!=null){
			def command = new CondicionIvaCommand()
			command.condicionIvaId = condicionIvaInstance.id
			command.version = condicionIvaInstance.version
			command.nombre = condicionIvaInstance.nombre
			
			return command
		} else {
			return null
		}
	}
	
	def getCondicionIvaList() {
		def lista = CondicionIva.list();
	}
	
	def deleteCondicionIva(Long id){
		def condicionIvaInstance = CondicionIva.get(id)
		condicionIvaInstance.delete(flush:true)
	}
	
	def saveCondicionIva(CondicionIvaCommand command){
		def condicionIvaInstance = new CondicionIva()
		
		condicionIvaInstance.nombre = command.nombre
		
		condicionIvaInstance.save(flush:true)
		
		return condicionIvaInstance
	}
	
	def updateCondicionIva(CondicionIvaCommand command){
		def condicionIvaInstance = CondicionIva.get(command.condicionIvaId)
		
		if (command.version != null) {
			if (condicionIvaInstance.version > command.version) {
				CondicionIvaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["CondicionIva"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la Condición de IVA")
				throw new ValidationException("Error de versión", CondicionIvaCommand.errors)
			}
		}
		
		condicionIvaInstance.nombre = command.nombre
		condicionIvaInstance.save(flush:true)
		
		return condicionIvaInstance
	}
	
	def getCantidadCondicionIvasTotales(){
		return CondicionIva.count()
	}
}

