package com.zifras.facturacion

import com.zifras.facturacion.FacturaCompraCommand
import com.zifras.AccessRulesService
import com.zifras.Estudio
import grails.validation.ValidationException
import com.zifras.cuenta.Cuenta
import org.joda.time.LocalDate
import grails.transaction.Transactional

@Transactional
class FacturaCompraService {
	AccessRulesService accessRulesService
	
	def createFacturaCompraCommand(){
		def command = new FacturaCompraCommand()
		return command
	}
	
	def listFacturaCompra(String mes, String ano, Long cuentaId) {
		def cuentaInstance = Cuenta.get(cuentaId)
		def fechaMin = new LocalDate(ano + '-' + mes + '-01')
		def fechaMax = fechaMin.plusMonths(1)
		def lista = FacturaCompra.createCriteria().list() {
				and{
					eq('cuenta', cuentaInstance)
					ge('fecha', fechaMin)
					lt('fecha', fechaMax)
				}
			}
		
		return lista
	}
	
	def getFacturaCompra(Long id){
		def facturaCompraInstance = FacturaCompra.get(id)
	}
	
	def getFacturaCompraCommand(Long id){
		def facturaCompraInstance = FacturaCompra.get(id)
		
		if(facturaCompraInstance!=null){
			def command = new FacturaCompraCommand()
			
			command.facturaCompraId = facturaCompraInstance.id
			command.version = facturaCompraInstance.version
			command.tipoId = facturaCompraInstance.tipoComprobante.id
			command.fecha = facturaCompraInstance.fecha
			command.puntoVenta = facturaCompraInstance.puntoVenta
			command.numero = facturaCompraInstance.numero
			command.proveedorId = facturaCompraInstance.proveedor.id
			command.cuentaId = facturaCompraInstance.cuenta.id
			command.netoGravado = facturaCompraInstance.netoGravado
			command.netoGravado21 = facturaCompraInstance.netoGravado21
			command.netoGravado27 = facturaCompraInstance.netoGravado27
			command.netoGravado10 = facturaCompraInstance.netoGravado10
			command.netoNoGravado = facturaCompraInstance.netoNoGravado
			command.exento = facturaCompraInstance.exento
			command.iva = facturaCompraInstance.iva
			command.iva21 = facturaCompraInstance.iva21
			command.iva27 = facturaCompraInstance.iva27
			command.iva10 = facturaCompraInstance.iva10
			command.total = facturaCompraInstance.total
			
			return command
		} else {
			return null
		}
	}
	
	def getFacturaCompraList() {
		lista = FacturaCompra.list();
	}
	
	def deleteFacturaCompra(Long id){
		def facturaCompraInstance = FacturaCompra.get(id)
		facturaCompraInstance.delete(flush:true)
	}
	
	def saveFacturaCompra(FacturaCompraCommand command){
		def facturaCompraInstance = new FacturaCompra()

		return GuardarFacturaCompraCommandEnInstance(command, facturaCompraInstance)
	}
	
	def updateFacturaCompra(FacturaCompraCommand command){
		def facturaCompraInstance = FacturaCompra.get(command.facturaCompraId)
		
		if (command.version != null) {
			if (facturaCompraInstance.version > command.version) {
				FacturaCompraCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["FacturaCompra"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la factura")
				throw new ValidationException("Error de versión", FacturaCompraCommand.errors)
			}
		}
		
		
		return GuardarFacturaCompraCommandEnInstance(command, facturaCompraInstance)
	}
	
	def getCantidadFacturaComprasTotales(){
		return FacturaCompra.count()
	}

	def GuardarFacturaCompraCommandEnInstance (FacturaCompraCommand command, FacturaCompra instance){
		instance.tipoComprobante = TipoComprobante.get(command.tipoId)
		instance.fecha = command.fecha
		instance.puntoVenta = command.puntoVenta
		instance.numero = command.numero
		instance.proveedor = Persona.get(command.proveedorId)
		instance.cuenta = Cuenta.get(command.cuentaId)
		instance.netoGravado = verificarNullNumero(command.netoGravado)
		instance.netoGravado21=verificarNullNumero(command.netoGravado21)
		instance.netoGravado27=verificarNullNumero(command.netoGravado27)
		instance.netoGravado10=verificarNullNumero(command.netoGravado10)
		instance.netoNoGravado = verificarNullNumero(command.netoNoGravado)
		instance.exento = verificarNullNumero(command.exento)
		instance.iva = verificarNullNumero(command.iva)
		instance.iva21 = verificarNullNumero(command.iva21)
		instance.iva27 = verificarNullNumero(command.iva27)
		instance.iva10 = verificarNullNumero(command.iva10)
		instance.total = verificarNullNumero(command.total)
		instance.percepcionImportada = 0
		instance.bienImportado = true

		instance.save(flush:true)
		
		return instance
	}

	def verificarNullNumero(Double numero){
		if (numero)
			return numero
		else
			return 0
	}
}