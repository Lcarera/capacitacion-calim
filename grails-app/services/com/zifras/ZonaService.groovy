package com.zifras

import com.zifras.ZonaCommand
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional

@Transactional
class ZonaService {
	AccessRulesService accessRulesService
	
	def createZonaCommand(){
		def command = new ZonaCommand()
		return command
	}
	
	def listZona(String filter) {
		def lista
		if(filter!=null){
			lista = Zona.createCriteria().list() {
				and{
					ilike('nombre', '%' + filter + '%')
					order('nombre', 'asc')
				}
			}
		}else{
			lista = Zona.list(sort:'nombre')
		}
		
		return lista
	}
	
	def getZona(Long id){
		def zonaInstance = Zona.get(id)
	}
	
	def getZonaCommand(Long id){
		def zonaInstance = Zona.get(id)
		
		if(zonaInstance!=null){
			def command = new ZonaCommand()
			
			command.zonaId = zonaInstance.id
			command.version = zonaInstance.version
			command.nombre = zonaInstance.nombre
			
			return command
		} else {
			return null
		}
	}
	
	def getZonaList() {
		lista = Zona.list();
	}
	
	def deleteZona(Long id){
		def zonaInstance = Zona.get(id)
		zonaInstance.delete(flush:true)
	}
	
	def saveZona(ZonaCommand command){
		def zonaInstance = new Zona()
		
		zonaInstance.nombre = command.nombre
		zonaInstance.save(flush:true)
		
		return zonaInstance
	}
	
	def updateZona(ZonaCommand command){
		def zonaInstance = Zona.get(command.zonaId)
		
		if (command.version != null) {
			if (zonaInstance.version > command.version) {
				ZonaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["Zona"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la zona")
				throw new ValidationException("Error de versión", ZonaCommand.errors)
			}
		}
		
		zonaInstance.nombre = command.nombre
		zonaInstance.save(flush:true)
		
		return zonaInstance
	}
	
	def getCantidadZonasTotales(){
		return Zona.count()
	}
}