package com.zifras

import com.zifras.EstadoCommand
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import grails.transaction.Transactional

@Transactional
class EstadoService {
	AccessRulesService accessRulesService
	
	def createEstadoCommand(){
		def command = new EstadoCommand()
		return command
	}
	
	def listEstado() {
		return Estado.list(sort:'nombre')
	}
	
	def getEstado(Long id){
		def estadoInstance = Estado.get(id)
	}
	
	def getEstadoCommand(Long id){
		def estadoInstance = Estado.get(id)
		
		if(estadoInstance!=null){
			def command = new EstadoCommand()
			
			command.nombre = estadoInstance.nombre
			
			return command
		} else {
			return null
		}
	}
	
	def getEstadoList() {
		def lista = Estado.list();
	}
	
	def getEstadosLiquidacionIva(){
		def estados = Estado.createCriteria().list(sort: "nombre", order: "asc") {
				or{
					eq('nombre', 'Liquidado')
					eq('nombre', 'Sin liquidar')
					eq('nombre', 'Sin verificar')
					eq('nombre', 'Per/Ret ingresado')
					eq('nombre', 'Liquidado A')
					eq('nombre', 'Liquidado A2')
					eq('nombre', 'Autorizada')
					eq('nombre', 'Presentada')
					eq('nombre', 'Notificado')
				}
			}
	}
	
	def getEstadosLiquidacionIIBB(){
		def estados = Estado.createCriteria().list(sort: "nombre", order: "asc") {
				or{
					eq('nombre', 'Liquidado')
					eq('nombre', 'Sin liquidar')
					eq('nombre', 'Sin verificar')
					eq('nombre', 'Per/Ret ingresado')
					eq('nombre', 'Liquidado A')
					eq('nombre', 'Automatico')
					eq('nombre', 'Autorizada')
					eq('nombre', 'Presentada')
					eq('nombre', 'Notificado')
				}
			}
	}
	
	def getEstadosLiquidacionGanancia(){
		def estados = Estado.createCriteria().list(sort: "nombre", order: "asc") {
				or{
					eq('nombre', 'Liquidado')
					eq('nombre', 'Sin liquidar')
					eq('nombre', 'Sin verificar')
					eq('nombre', 'Per/Ret ingresado')
				}
			}
	}
	
	def getEstadosLocales(){
		def estados = Estado.createCriteria().list(sort: "nombre", order: "asc") {
				or{
					eq('nombre', 'Activo')
					eq('nombre', 'Borrado')
				}
			}
	}
	
	def getEstadosAlicuotasIIBB(){
		def estados = Estado.createCriteria().list(sort: "nombre", order: "asc") {
				or{
					eq('nombre', 'Activo')
					eq('nombre', 'Borrado')
				}
			}
	}

	def getEstadosVEP(String filter){
		def estados = Estado.createCriteria().list(sort: "nombre", order: "asc") {
				if(filter!=null){
						ilike('nombre', '%' + filter + '%')
				}
				or{
					eq('nombre', 'Pagado')
					eq('nombre', 'Expirado')
					eq('nombre', 'En Banelco')
					eq('nombre', 'En Link')
					eq('nombre', 'Emitido')
				}
			}
	}

	def getEstadosPagoCuenta(String filter){
		def estados = Estado.createCriteria().list(sort: "nombre", order: "asc") {
				if(filter!=null){
						ilike('nombre', '%' + filter + '%')
				}
				or{
					eq('nombre', 'Pagado')
					eq('nombre', 'Emitido')
				}
			}
	}
	
	def deleteEstado(Long id){
		def estadoInstance = Estado.get(id)
		estadoInstance.delete(flush:true)
	}
	
	def saveEstado(EstadoCommand command){
		def estadoInstance = new Estado()
		
		estadoInstance.nombre = command.nombre
		
		estadoInstance.save(flush:true)
		
		return estadoInstance
	}
	
	def updateEstado(EstadoCommand command){
		def estadoInstance = Estado.get(command.estadoId)
		
		if (command.version != null) {
			if (estadoInstance.version > command.version) {
				EstadoCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["Estado"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la estado")
				throw new ValidationException("Error de versión", EstadoCommand.errors)
			}
		}
		
		estadoInstance.nombre = command.nombre
		estadoInstance.save(flush:true)
		
		return estadoInstance
	}
	
	def getCantidadEstadosTotales(){
		return Estado.count()
	}
	
	def getEstadosTipoClave(){
		def estados = Estado.createCriteria().list(sort: "nombre", order: "asc") {
				or{
					eq('nombre', 'Activo')
					eq('nombre', 'Inactivo')
				}
			}
	}

	def getDeclaracionJuradaEstados(){
		return Estado.createCriteria().list(sort: "nombre", order: "asc") {
			or{
				eq('nombre', 'Pendiente')
				eq('nombre', 'Presentada')
			}
		}
	}
}