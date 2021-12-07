package com.zifras.cuenta

import com.zifras.cuenta.RegimenIibbCommand
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional

@Transactional
class RegimenIibbService {
	AccessRulesService accessRulesService
	
	def createRegimenIibbCommand(){
		def command = new RegimenIibbCommand()
		return command
	}
	
	def listRegimenIibb() {
		return RegimenIibb.list(sort:'nombre')
	}
	
	def getRegimenIibb(Long id){
		def regimenIibbInstance = RegimenIibb.get(id)
	}
	
	def getRegimenIibbCommand(Long id){
		def regimenIibbInstance = RegimenIibb.get(id)
		
		if(regimenIibbInstance!=null){
			def command = new RegimenIibbCommand()
			command.regimenIibbId = regimenIibbInstance.id
			command.version = regimenIibbInstance.version
			command.nombre = regimenIibbInstance.nombre
			
			return command
		} else {
			return null
		}
	}
	
	def getRegimenIibbList() {
		def lista = RegimenIibb.list();
	}
	
	def deleteRegimenIibb(Long id){
		def regimenIibbInstance = RegimenIibb.get(id)
		regimenIibbInstance.delete(flush:true)
	}
	
	def saveRegimenIibb(RegimenIibbCommand command){
		def regimenIibbInstance = new RegimenIibb()
		
		regimenIibbInstance.nombre = command.nombre
		
		regimenIibbInstance.save(flush:true)
		
		return regimenIibbInstance
	}
	
	def updateRegimenIibb(RegimenIibbCommand command){
		def regimenIibbInstance = RegimenIibb.get(command.regimenIibbId)
		
		if (command.version != null) {
			if (regimenIibbInstance.version > command.version) {
				RegimenIibbCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["RegimenIibb"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la Condición de IVA")
				throw new ValidationException("Error de versión", RegimenIibbCommand.errors)
			}
		}
		
		regimenIibbInstance.nombre = command.nombre
		regimenIibbInstance.save(flush:true)
		
		return regimenIibbInstance
	}
	
	def getCantidadRegimenIibbsTotales(){
		return RegimenIibb.count()
	}
}

