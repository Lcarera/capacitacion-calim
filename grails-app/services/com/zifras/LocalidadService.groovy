package com.zifras

import com.zifras.LocalidadCommand
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional

@Transactional
class LocalidadService {
	AccessRulesService accessRulesService
	
	def createLocalidadCommand(){
		def command = new LocalidadCommand()
		return command
	}
	
	def listLocalidad(Long provinciaId=null, String filter=null) {
		def lista
		def provincia = Provincia.get(provinciaId)
		if(provincia!=null){
			if(filter!=null){
				lista = Localidad.createCriteria().list() {
					and{
						ilike('nombre', '%' + filter + '%')
						order('nombre', 'asc')
						eq('provincia', provincia)
					}
				}
			}else{
				lista = Localidad.createCriteria().list() {
					and{
						order('nombre', 'asc')
						eq('provincia', provincia)
					}
				}
			}
		}else{
			if(filter!=null){
				lista = Localidad.createCriteria().list() {
					and{
						ilike('nombre', '%' + filter + '%')
						order('nombre', 'asc')
					}
				}
			}else{
				lista = Localidad.list(sort:'nombre')
			}
		}
		
		return lista
	}
	
	def getLocalidad(Long id){
		def localidadInstance = Localidad.get(id)
	}
	
	def getLocalidadCommand(Long id){
		def localidadInstance = Localidad.get(id)
		
		if(localidadInstance!=null){
			def command = new LocalidadCommand()
			
			command.provinciaId = localidadInstance.provincia.id
			command.localidadId = localidadInstance.id
			command.version = localidadInstance.version
			command.nombre = localidadInstance.nombre
			
			return command
		} else {
			return null
		}
	}
	
	def getLocalidadList() {
		def lista = Localidad.list();
	}
	
	def deleteLocalidad(Long id){
		def localidadInstance = Localidad.get(id)
		localidadInstance.delete(flush:true)
	}
	
	def saveLocalidad(LocalidadCommand command){
		def localidadInstance = new Localidad()
		
		def provincia = Provincia.get(command.provinciaId)
		localidadInstance.nombre = command.nombre
		localidadInstance.provincia = provincia
		
		localidadInstance.save(flush:true)
		
		return localidadInstance
	}
	
	def updateLocalidad(LocalidadCommand command){
		def localidadInstance = Localidad.get(command.localidadId)
		
		if (command.version != null) {
			if (localidadInstance.version > command.version) {
				LocalidadCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["Localidad"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la localidad")
				throw new ValidationException("Error de versión", LocalidadCommand.errors)
			}
		}
		
		localidadInstance.nombre = command.nombre
		localidadInstance.save(flush:true)
		
		return localidadInstance
	}
	
	def getCantidadLocalidadsTotales(){
		return Localidad.count()
	}
}