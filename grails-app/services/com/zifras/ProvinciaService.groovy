package com.zifras

import com.zifras.ProvinciaCommand
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional

@Transactional
class ProvinciaService {
	AccessRulesService accessRulesService
	
	def createProvinciaCommand(){
		def command = new ProvinciaCommand()
		return command
	}
	
	def listProvincia() {
		return Provincia.list(sort:'nombre')
	}
	
	def getProvincia(Long id){
		def provinciaInstance = Provincia.get(id)
	}
	
	def getProvinciaCommand(Long id){
		def provinciaInstance = Provincia.get(id)
		
		if(provinciaInstance!=null){
			def command = new ProvinciaCommand()
			
			command.provinciaId = provinciaInstance.id
			command.version = provinciaInstance.version
			command.nombre = provinciaInstance.nombre
			
			return command
		} else {
			return null
		}
	}
	
	def getProvinciaList() {
		def lista = Provincia.list();
	}
	
	def deleteProvincia(Long id){
		def provinciaInstance = Provincia.get(id)
		provinciaInstance.delete(flush:true)
	}
	
	def saveProvincia(ProvinciaCommand command){
		def provinciaInstance = new Provincia()
		
		provinciaInstance.nombre = command.nombre
		provinciaInstance.save(flush:true)
		
		return provinciaInstance
	}
	
	def updateProvincia(ProvinciaCommand command){
		def provinciaInstance = Provincia.get(command.provinciaId)
		
		if (command.version != null) {
			if (provinciaInstance.version > command.version) {
				ProvinciaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["Provincia"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la provincia")
				throw new ValidationException("Error de versión", ProvinciaCommand.errors)
			}
		}
		
		provinciaInstance.nombre = command.nombre
		provinciaInstance.save(flush:true)
		
		return provinciaInstance
	}
	
	def getCantidadProvinciasTotales(){
		return Provincia.count()
	}
}