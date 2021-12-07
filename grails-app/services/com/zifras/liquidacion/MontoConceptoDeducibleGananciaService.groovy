package com.zifras.liquidacion

import com.zifras.liquidacion.MontoConceptoDeducibleGananciaCommand
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional
import org.joda.time.LocalDate

@Transactional
class MontoConceptoDeducibleGananciaService {
	AccessRulesService accessRulesService
	
	def createMontoConceptoDeducibleGananciaCommand(){
		def command = new MontoConceptoDeducibleGananciaCommand()
		command.ano = (new LocalDate()).toString("YYYY")
		command.concepto = 0
		return command
	}
	
	def listMontoConceptoDeducibleGanancia(String ano) {
		def lista
		def fecha = new LocalDate(ano + '-01-01')
		
		if(ano!=null){
			lista = MontoConceptoDeducibleGanancia.createCriteria().list() {
				and{
					eq('fecha', fecha)
					order('concepto', 'asc')
				}
			}
		}else{
			lista = MontoConceptoDeducibleGanancia.list(sort:'fecha')
		}
		
		return lista
	}
	
	def getMontoConceptoDeducibleGanancia(Long id){
		def montoConceptoDeducibleGananciaInstance = MontoConceptoDeducibleGanancia.get(id)
	}
	
	def getMontoConceptoDeducibleGananciaCommand(Long id){
		def montoConceptoDeducibleGananciaInstance = MontoConceptoDeducibleGanancia.get(id)
		
		if(montoConceptoDeducibleGananciaInstance!=null){
			def command = new MontoConceptoDeducibleGananciaCommand()
			
			command.montoConceptoDeducibleGananciaId = montoConceptoDeducibleGananciaInstance.id
			command.version = montoConceptoDeducibleGananciaInstance.version
			command.ano = montoConceptoDeducibleGananciaInstance.fecha.toString("YYYY")
			command.concepto = montoConceptoDeducibleGananciaInstance.concepto
			command.valor = montoConceptoDeducibleGananciaInstance.valor
			
			return command
		} else {
			return null
		}
	}
	
	def getMontoConceptoDeducibleGananciaList() {
		def lista = MontoConceptoDeducibleGanancia.list();
	}
	
	def deleteMontoConceptoDeducibleGanancia(Long id){
		def montoConceptoDeducibleGananciaInstance = MontoConceptoDeducibleGanancia.get(id)
		montoConceptoDeducibleGananciaInstance.delete(flush:true)
	}
	
	def saveMontoConceptoDeducibleGanancia(MontoConceptoDeducibleGananciaCommand command){
		def montoConceptoDeducibleGananciaInstance 
		def fecha = new LocalDate(command.ano + '-01-01')
		Long concepto = command.concepto
		montoConceptoDeducibleGananciaInstance = MontoConceptoDeducibleGanancia.findByFechaAndConcepto(fecha, concepto)
		
		if(montoConceptoDeducibleGananciaInstance==null)
			montoConceptoDeducibleGananciaInstance = new MontoConceptoDeducibleGanancia()
		
		montoConceptoDeducibleGananciaInstance.fecha = new LocalDate(command.ano + '-01-01')
		montoConceptoDeducibleGananciaInstance.concepto = command.concepto
		montoConceptoDeducibleGananciaInstance.valor = command.valor
		montoConceptoDeducibleGananciaInstance.save(flush:true)
		
		return montoConceptoDeducibleGananciaInstance
	}
	
	def updateMontoConceptoDeducibleGanancia(MontoConceptoDeducibleGananciaCommand command){
		def montoConceptoDeducibleGananciaInstance = MontoConceptoDeducibleGanancia.get(command.montoConceptoDeducibleGananciaId)
		
		if (command.version != null) {
			if (montoConceptoDeducibleGananciaInstance.version > command.version) {
				MontoConceptoDeducibleGananciaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["MontoConceptoDeducibleGanancia"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el monto del concepto")
				throw new ValidationException("Error de version", MontoConceptoDeducibleGananciaCommand.errors)
			}
		}
		
		montoConceptoDeducibleGananciaInstance.fecha = new LocalDate(command.ano + '-01-01')
		montoConceptoDeducibleGananciaInstance.concepto = command.concepto
		montoConceptoDeducibleGananciaInstance.valor = command.valor
		montoConceptoDeducibleGananciaInstance.save(flush:true)
		
		return montoConceptoDeducibleGananciaInstance
	}
	
	def getCantidadMontoConceptoDeducibleGananciaTotales(){
		return MontoConceptoDeducibleGanancia.count()
	}
}
