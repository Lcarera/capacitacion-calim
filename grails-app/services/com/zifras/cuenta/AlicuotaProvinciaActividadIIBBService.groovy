package com.zifras.cuenta


import com.zifras.Provincia
import com.zifras.AccessRulesService
import grails.validation.ValidationException
import grails.transaction.Transactional
import org.joda.time.LocalDate

@Transactional
class AlicuotaProvinciaActividadIIBBService {
	AccessRulesService accessRulesService
	
	def createAlicuotaProvinciaActividadIIBBCommand(){
		def command = new AlicuotaProvinciaActividadIIBBCommand()
		return command
	}
	
	def listAlicuotaProvinciaActividadIIBB() {
		return AlicuotaProvinciaActividadIIBB.list(sort:'nombre')
	}
	
	def getAlicuotaProvinciaActividadIIBB(Long id){
		def alicuotaProvinciaActividadIIBBInstance = AlicuotaProvinciaActividadIIBB.get(id)
	}
	
	def getAlicuotaProvinciaActividadIIBBCommand(Long id){
		def alicuotaProvinciaActividadIIBBInstance = AlicuotaProvinciaActividadIIBB.get(id)
		
		if(alicuotaProvinciaActividadIIBBInstance!=null){
			def command = new AlicuotaProvinciaActividadIIBBCommand()
			
			command.alicuotaProvinciaActividadIIBBId = alicuotaProvinciaActividadIIBBInstance.id
			command.provinciaId = alicuotaProvinciaActividadIIBBInstance.provincia.id
			command.actividadId = alicuotaProvinciaActividadIIBBInstance.actividad.id
			command.valor = alicuotaProvinciaActividadIIBBInstance.valor
			command.baseImponibleDesde = alicuotaProvinciaActividadIIBBInstance.baseImponibleDesde
			command.baseImponibleHasta = alicuotaProvinciaActividadIIBBInstance.baseImponibleHasta
			command.ano = new Integer(alicuotaProvinciaActividadIIBBInstance.fecha.toString("YYYY"))

			return command
		} else {
			return null
		}
	}
	
	def getAlicuotasProvinciaActividadIIBB(Long ano) {
		def lista = AlicuotaProvinciaActividadIIBB.findAllByFecha(new LocalDate(ano + '-01' + '-01'))
		return lista?: [] //Si no encontró nada devuelve una lista vacía
	}
	
	def deleteAlicuotaProvinciaActividadIIBB(Long id){
		def alicuotaProvinciaActividadIIBBInstance = AlicuotaProvinciaActividadIIBB.get(id)
		alicuotaProvinciaActividadIIBBInstance.delete(flush:true)
	}
	
	def saveAlicuotaProvinciaActividadIIBB(AlicuotaProvinciaActividadIIBBCommand command){
		def alicuotaProvinciaActividadIIBBInstance = new AlicuotaProvinciaActividadIIBB()
		
		alicuotaProvinciaActividadIIBBInstance.provincia = Provincia.get(command.provinciaId)
		alicuotaProvinciaActividadIIBBInstance.actividad = Actividad.get(command.actividadId)
		alicuotaProvinciaActividadIIBBInstance.valor = command.valor
		alicuotaProvinciaActividadIIBBInstance.baseImponibleHasta = command.baseImponibleHasta
		alicuotaProvinciaActividadIIBBInstance.baseImponibleDesde = command.baseImponibleDesde
		alicuotaProvinciaActividadIIBBInstance.fecha = new LocalDate(command.ano + '-01' + '-01')
		
		alicuotaProvinciaActividadIIBBInstance.save(flush:true, failOnError:true)
		
		return alicuotaProvinciaActividadIIBBInstance
	}
	
	def updateAlicuotaProvinciaActividadIIBB(AlicuotaProvinciaActividadIIBBCommand command){
		def alicuotaProvinciaActividadIIBBInstance = AlicuotaProvinciaActividadIIBB.get(command.alicuotaProvinciaActividadIIBBId)
		
		if (command.version != null) {
			if (alicuotaProvinciaActividadIIBBInstance.version > command.version) {
				AlicuotaProvinciaActividadIIBBCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["Alicuota"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la Alicuota")
				throw new ValidationException("Error de versión", AlicuotaProvinciaActividadIIBBCommand.errors)
			}
		}

		alicuotaProvinciaActividadIIBBInstance.provincia = Provincia.get(command.provinciaId)
		alicuotaProvinciaActividadIIBBInstance.actividad = Actividad.get(command.actividadId)
		alicuotaProvinciaActividadIIBBInstance.valor = command.valor
		alicuotaProvinciaActividadIIBBInstance.baseImponibleHasta = command.baseImponibleHasta
		alicuotaProvinciaActividadIIBBInstance.baseImponibleDesde = command.baseImponibleDesde
		alicuotaProvinciaActividadIIBBInstance.fecha = new LocalDate(command.ano + '-01' + '-01')

		return alicuotaProvinciaActividadIIBBInstance.save(flush:true, failOnError:true)
	}	
}

