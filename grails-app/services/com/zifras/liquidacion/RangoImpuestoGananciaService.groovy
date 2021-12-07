package com.zifras.liquidacion

import com.zifras.liquidacion.RangoImpuestoGananciaCommand
import grails.validation.ValidationException
import grails.transaction.Transactional
import org.joda.time.LocalDate

@Transactional
class RangoImpuestoGananciaService {
	def createRangoImpuestoGananciaCommand(){
		def command = new RangoImpuestoGananciaCommand()
		
		def hoy = new LocalDate()
		command.ano = hoy.toString("YYYY")
		return command
	}
	
	def listRangoImpuestoGanancia(String ano) {
		def lista
		def fecha = new LocalDate(ano + '-01-01')
		
		if(ano!=null){
			lista = RangoImpuestoGanancia.createCriteria().list() {
				and{
					eq('fecha', fecha)
					order('porcentaje', 'asc')
				}
			}
		}else{
			lista = RangoImpuestoGanancia.list(sort:'fecha')
		}
		
		return lista
	}
	
	def getRangoImpuestoGanancia(Long id){
		def rangoImpuestoGananciaInstance = RangoImpuestoGanancia.get(id)
	}
	
	def getRangoImpuestoGananciaCommand(Long id){
		def rangoImpuestoGananciaInstance = RangoImpuestoGanancia.get(id)
		
		if(rangoImpuestoGananciaInstance!=null){
			def command = new RangoImpuestoGananciaCommand()
			
			command.rangoImpuestoGananciaId = rangoImpuestoGananciaInstance.id
			command.version = rangoImpuestoGananciaInstance.version
			
			command.ano = rangoImpuestoGananciaInstance.fecha.toString("YYYY")
			
			command.desde = rangoImpuestoGananciaInstance.desde
			command.hasta = rangoImpuestoGananciaInstance.hasta
			
			command.fijo = rangoImpuestoGananciaInstance.fijo
			command.porcentaje = rangoImpuestoGananciaInstance.porcentaje
			
			return command
		} else {
			return null
		}
	}
	
	def getRangoImpuestoGananciaList() {
		def lista = RangoImpuestoGanancia.list();
	}
	
	def deleteRangoImpuestoGanancia(Long id){
		def rangoImpuestoGananciaInstance = RangoImpuestoGanancia.get(id)
		rangoImpuestoGananciaInstance.delete(flush:true)
	}
	
	def saveRangoImpuestoGanancia(RangoImpuestoGananciaCommand command){
		def rangoImpuestoGananciaInstance = new RangoImpuestoGanancia()
		
		rangoImpuestoGananciaInstance.fecha = new LocalDate(command.ano + '-01-01')
		
		rangoImpuestoGananciaInstance.desde = command.desde
		rangoImpuestoGananciaInstance.hasta = command.hasta
		
		rangoImpuestoGananciaInstance.fijo = command.fijo
		rangoImpuestoGananciaInstance.porcentaje = command.porcentaje
		
		rangoImpuestoGananciaInstance.save(flush:true)
		
		return rangoImpuestoGananciaInstance
	}
	
	def updateRangoImpuestoGanancia(RangoImpuestoGananciaCommand command){
		def rangoImpuestoGananciaInstance = RangoImpuestoGanancia.get(command.rangoImpuestoGananciaId)
		
		if (command.version != null) {
			if (rangoImpuestoGananciaInstance.version > command.version) {
				RangoImpuestoGananciaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["RangoImpuestoGanancia"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el Rango")
				throw new ValidationException("Error de versión", RangoImpuestoGananciaCommand.errors)
			}
		}
		
		rangoImpuestoGananciaInstance.fecha = new LocalDate(command.ano + '-01-01')
		
		rangoImpuestoGananciaInstance.desde = command.desde
		rangoImpuestoGananciaInstance.hasta = command.hasta
		
		rangoImpuestoGananciaInstance.fijo = command.fijo
		rangoImpuestoGananciaInstance.porcentaje = command.porcentaje
		
		rangoImpuestoGananciaInstance.save(flush:true)
		
		return rangoImpuestoGananciaInstance
	}
	
	def getCantidadRangoImpuestoGananciasTotales(){
		return RangoImpuestoGanancia.count()
	}
}
