package com.zifras.liquidacion

import com.zifras.liquidacion.TipoPatrimonioGananciaCommand
import com.zifras.Estado
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional

@Transactional
class TipoPatrimonioGananciaService {
	AccessRulesService accessRulesService
	
	def createTipoPatrimonioGananciaCommand(){
		def command = new TipoPatrimonioGananciaCommand()
		return command
	}
	
	def listTipoPatrimonioGanancia(String filter) {
		def lista
		def estadoActivo = Estado.findByNombre('Activo')
		if(filter!=null){
			lista = TipoPatrimonioGanancia.createCriteria().list() {
				and{
					eq('estado', estadoActivo)
					ilike('nombre', '%' + filter + '%')
					order('nombre', 'asc')
				}
			}
		}else{
			lista = TipoPatrimonioGanancia.list(sort:'nombre')
		}
		
		return lista
	}
	
	def getTipoPatrimonioGanancia(Long id){
		def tipoPatrimonioGananciaInstance = TipoPatrimonioGanancia.get(id)
	}
	
	def getTipoPatrimonioGananciaCommand(Long id){
		def tipoPatrimonioGananciaInstance = TipoPatrimonioGanancia.get(id)
		
		if(tipoPatrimonioGananciaInstance!=null){
			def command = new TipoPatrimonioGananciaCommand()
			
			command.tipoPatrimonioGananciaId = tipoPatrimonioGananciaInstance.id
			command.version = tipoPatrimonioGananciaInstance.version
			command.nombre = tipoPatrimonioGananciaInstance.nombre
			
			return command
		} else {
			return null
		}
	}
	
	def getTipoPatrimonioGananciaList() {
		lista = TipoPatrimonioGanancia.list();
	}
	
	def deleteTipoPatrimonioGanancia(Long id){
		def tipoPatrimonioGananciaInstance = TipoPatrimonioGanancia.get(id)
		tipoPatrimonioGananciaInstance.delete(flush:true)
	}
	
	def saveTipoPatrimonioGanancia(TipoPatrimonioGananciaCommand command){
		def tipoPatrimonioGananciaInstance = new TipoPatrimonioGanancia()
		
		tipoPatrimonioGananciaInstance.nombre = command.nombre
		tipoPatrimonioGananciaInstance.estado = Estado.findByNombre('Activo')
		tipoPatrimonioGananciaInstance.save(flush:true)
		
		return tipoPatrimonioGananciaInstance
	}
	
	def updateTipoPatrimonioGanancia(TipoPatrimonioGananciaCommand command){
		def tipoPatrimonioGananciaInstance = TipoPatrimonioGanancia.get(command.tipoPatrimonioGananciaId)
		
		if (command.version != null) {
			if (tipoPatrimonioGananciaInstance.version > command.version) {
				TipoPatrimonioGananciaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["TipoPatrimonioGanancia"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el tipo de patrimonio de Ganancia")
				throw new ValidationException("Error de versión", TipoPatrimonioGananciaCommand.errors)
			}
		}
		
		tipoPatrimonioGananciaInstance.nombre = command.nombre
		tipoPatrimonioGananciaInstance.save(flush:true)
		
		return tipoPatrimonioGananciaInstance
	}
	
	def getCantidadTipoPatrimonioGananciasTotales(){
		return TipoPatrimonioGanancia.count()
	}
}
