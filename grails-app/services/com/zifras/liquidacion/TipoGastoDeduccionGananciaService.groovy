package com.zifras.liquidacion

import com.zifras.liquidacion.TipoGastoDeduccionGananciaCommand
import com.zifras.Estado
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional

@Transactional
class TipoGastoDeduccionGananciaService {
	AccessRulesService accessRulesService
	
	def createTipoGastoDeduccionGananciaCommand(){
		def command = new TipoGastoDeduccionGananciaCommand()
		return command
	}
	
	def listTipoGastoDeduccionGanancia(String filter) {
		def lista
		def estadoActivo = Estado.findByNombre('Activo')
		if(filter!=null){
			lista = TipoGastoDeduccionGanancia.createCriteria().list() {
				and{
					eq('estado', estadoActivo)
					ilike('nombre', '%' + filter + '%')
					order('nombre', 'asc')
				}
			}
		}else{
			lista = TipoGastoDeduccionGanancia.list(sort:'nombre')
		}
		
		return lista
	}
	
	def getTipoGastoDeduccionGanancia(Long id){
		def tipoGastoDeduccionGananciaInstance = TipoGastoDeduccionGanancia.get(id)
	}
	
	def getTipoGastoDeduccionGananciaCommand(Long id){
		def tipoGastoDeduccionGananciaInstance = TipoGastoDeduccionGanancia.get(id)
		
		if(tipoGastoDeduccionGananciaInstance!=null){
			def command = new TipoGastoDeduccionGananciaCommand()
			
			command.tipoGastoDeduccionGananciaId = tipoGastoDeduccionGananciaInstance.id
			command.version = tipoGastoDeduccionGananciaInstance.version
			command.nombre = tipoGastoDeduccionGananciaInstance.nombre
			
			return command
		} else {
			return null
		}
	}
	
	def getTipoGastoDeduccionGananciaList() {
		lista = TipoGastoDeduccionGanancia.list();
	}
	
	def deleteTipoGastoDeduccionGanancia(Long id){
		def tipoGastoDeduccionGananciaInstance = TipoGastoDeduccionGanancia.get(id)
		tipoGastoDeduccionGananciaInstance.delete(flush:true)
	}
	
	def saveTipoGastoDeduccionGanancia(TipoGastoDeduccionGananciaCommand command){
		def tipoGastoDeduccionGananciaInstance = new TipoGastoDeduccionGanancia()
		
		tipoGastoDeduccionGananciaInstance.nombre = command.nombre
		tipoGastoDeduccionGananciaInstance.estado = Estado.findByNombre('Activo')
		tipoGastoDeduccionGananciaInstance.save(flush:true)
		
		return tipoGastoDeduccionGananciaInstance
	}
	
	def updateTipoGastoDeduccionGanancia(TipoGastoDeduccionGananciaCommand command){
		def tipoGastoDeduccionGananciaInstance = TipoGastoDeduccionGanancia.get(command.tipoGastoDeduccionGananciaId)
		
		if (command.version != null) {
			if (tipoGastoDeduccionGananciaInstance.version > command.version) {
				TipoGastoDeduccionGananciaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["TipoGastoDeduccionGanancia"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la Gasto/Deduccion de Ganancia")
				throw new ValidationException("Error de versión", TipoGastoDeduccionGananciaCommand.errors)
			}
		}
		
		tipoGastoDeduccionGananciaInstance.nombre = command.nombre
		tipoGastoDeduccionGananciaInstance.save(flush:true)
		
		return tipoGastoDeduccionGananciaInstance
	}
	
	def getCantidadTipoGastoDeduccionGananciasTotales(){
		return TipoGastoDeduccionGanancia.count()
	}
}
