package com.zifras.cuenta

import com.zifras.cuenta.ActividadCommand
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional

@Transactional
class ActividadService {
	AccessRulesService accessRulesService
	
	def createActividadCommand(){
		def command = new ActividadCommand()
		return command
	}
	
	def listActividad() {
		return Actividad.list(sort:'codigo')
	}
	
	def getActividad(Long id){
		def actividadInstance = Actividad.get(id)
	}
	
	def getActividadCommand(Long id){
		def actividadInstance = Actividad.get(id)
		
		if(actividadInstance!=null){
			def command = new ActividadCommand()
			command.actividadId = actividadInstance.id
			command.version = actividadInstance.version
			command.nombre = actividadInstance.nombre
			command.codigo = actividadInstance.codigo
			command.codigoAfip = actividadInstance.codigoAfip
			command.codigoNaes = actividadInstance.codigoNaes
			command.codigoCuacm = actividadInstance.codigoCuacm

			command.descripcionAfip = actividadInstance.descripcionAfip
			command.descripcionNaes = actividadInstance.descripcionNaes
			command.descripcionCuacm = actividadInstance.descripcionCuacm

			command.utilidadMaxima = actividadInstance.utilidadMaxima
			command.utilidadMinima = actividadInstance.utilidadMinima
			
			return command
		} else {
			return null
		}
	}
	
	def getActividadList() {
		def lista = Actividad.list(sort:'codigo')
	}
	
	def deleteActividad(Long id){
		def actividadInstance = Actividad.get(id)
		actividadInstance.delete(flush:true)
	}
	
	def saveActividad(ActividadCommand command){
		def actividadInstance = new Actividad()
		
		actividadInstance.nombre = command.nombre
		actividadInstance.codigo = command.codigo
		actividadInstance.codigoAfip = command.codigoAfip
		actividadInstance.codigoNaes = command.codigoNaes
		actividadInstance.codigoCuacm = command.codigoCuacm
		
		actividadInstance.descripcionAfip = command.descripcionAfip
		actividadInstance.descripcionNaes = command.descripcionNaes
		actividadInstance.descripcionCuacm = command.descripcionCuacm
		
		actividadInstance.utilidadMaxima = command.utilidadMaxima
		actividadInstance.utilidadMinima = command.utilidadMinima
		
		actividadInstance.save(flush:true)
		
		return actividadInstance
	}
	
	def updateActividad(ActividadCommand command){
		def actividadInstance = Actividad.get(command.actividadId)
		
		if (command.version != null) {
			if (actividadInstance.version > command.version) {
				ActividadCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["Actividad"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la Condición de IVA")
				throw new ValidationException("Error de versión", ActividadCommand.errors)
			}
		}
		
		actividadInstance.nombre = command.nombre
		actividadInstance.codigo = command.codigo

		actividadInstance.codigoAfip = command.codigoAfip
		actividadInstance.codigoNaes = command.codigoNaes
		actividadInstance.codigoCuacm = command.codigoCuacm
		
		actividadInstance.descripcionAfip = command.descripcionAfip
		actividadInstance.descripcionNaes = command.descripcionNaes
		actividadInstance.descripcionCuacm = command.descripcionCuacm
		
		actividadInstance.utilidadMaxima = command.utilidadMaxima
		actividadInstance.utilidadMinima = command.utilidadMinima
		actividadInstance.save(flush:true)
		
		return actividadInstance
	}
	
	def getCantidadActividadsTotales(){
		return Actividad.count()
	}
}

