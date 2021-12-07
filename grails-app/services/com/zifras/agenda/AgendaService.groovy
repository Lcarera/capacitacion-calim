package com.zifras.agenda

import com.zifras.AccessRulesService
import com.zifras.afip.AfipService
import com.zifras.cuenta.ClienteProveedor
import com.zifras.cuenta.ClienteProveedorCommand
import com.zifras.cuenta.CondicionIva
import com.zifras.cuenta.Cuenta
import com.zifras.facturacion.Persona
import com.zifras.facturacion.PersonaCommand
import com.zifras.Provincia

import grails.plugin.springsecurity.SpringSecurityUtils
import grails.transaction.Transactional
import grails.validation.ValidationException
import groovy.json.JsonSlurper
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.springframework.context.i18n.LocaleContextHolder
import org.springframework.context.MessageSource

@Transactional
class AgendaService{
	def afipService
	def accessRulesService

	def createProveedorCommand(){
		return new ClienteProveedorCommand()
	}

	def getClienteOProveedorPorCuenta(Long cuentaId, String tipo){
		def cuenta = Cuenta.get(cuentaId)
		def cliOprov = ClienteProveedor.createCriteria().list(){
			and{
				eq('cuenta', cuenta)
				eq(tipo, true)
			}
		}
		return cliOprov

	}

	def updateClienteProveedor(ClienteProveedorCommand command){
		def clienteProveedorInstance= ClienteProveedor.get(command.clienteProveedorId)
		def personaInstance = clienteProveedorInstance.persona
		if (command.version != null) {
			if (clienteProveedorInstance.version > command.version) {
				ClienteProveedorCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["ClienteProveedor"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el Declaracion Jurada")
				throw new ValidationException("Error de versión", ClienteProveedorCommand.errors)
			}
		}
		personaInstance.razonSocial = command.razonSocial
		personaInstance.cuit = command.cuit
		personaInstance.domicilio = command.domicilio
		personaInstance.tipoDocumento = "CUIT"
		personaInstance.condicionIva = CondicionIva.get(command.condicionIvaId)
		personaInstance.save(flush:true, failOnError:true)

		clienteProveedorInstance.persona = personaInstance

		clienteProveedorInstance.email = command.email
		clienteProveedorInstance.alias = command.alias
		clienteProveedorInstance.nota = command.nota
		clienteProveedorInstance.cliente = command.cliente
		clienteProveedorInstance.proveedor = command.proveedor

		clienteProveedorInstance.save(flush:true, failOnError:true)

		return clienteProveedorInstance
	}

	def getClienteProveedorCommand(Long id){
			def clienteProveedorInstance = ClienteProveedor.get(id)

			if(clienteProveedorInstance!=null){
				def command = new ClienteProveedorCommand()
				def personaInstance = clienteProveedorInstance.persona

				command.razonSocial = personaInstance.razonSocial
				command.cuit = personaInstance.cuit
				command.tipoDocumento = personaInstance.tipoDocumento
				command.domicilio = personaInstance.domicilio 
				command.condicionIvaId = personaInstance.condicionIva?.id

				command.clienteProveedorId = id
				command.email = clienteProveedorInstance.email
				command.alias = clienteProveedorInstance.alias
				command.nota = clienteProveedorInstance.nota
				command.proveedor = clienteProveedorInstance.proveedor
				command.cliente = clienteProveedorInstance.cliente

				return command
			} else {
				return null
			}
		}


	def saveProveedor(ClienteProveedorCommand command, Long id){
		def proveedorInstance = new ClienteProveedor()
		def personaInstance = Persona.findByCuit(command.cuit)
		def cuenta = Cuenta.get(id)
		if(! personaInstance){
			personaInstance = new Persona()
			personaInstance.razonSocial = command.razonSocial
			personaInstance.cuit = command.cuit
			personaInstance.tipoDocumento = command.tipoDocumento ?: "CUIT"
			personaInstance.domicilio = command.domicilio
			personaInstance.condicionIva = CondicionIva.get(command.condicionIvaId)
			try {
				if(command.provinciaId != null)
					personaInstance.provincia = Provincia.get(command.provinciaId)
				else
					personaInstance.provincia = afipService.obtenerDatosProveedor(personaInstance.cuit).provincia
			}
			catch(Exception e) {
				log.error("No pudo guardarse provincia en proveedor")
				println e.message
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
			personaInstance.save(flush:true, failOnError:true)
		}
		def provExiste = ClienteProveedor.findByPersonaAndCuenta(personaInstance,cuenta)
		if(provExiste){
			if(provExiste.cliente != command.cliente || provExiste.proveedor != command.proveedor){
				provExiste.cliente = command.cliente
				provExiste.proveedor = command.proveedor
				provExiste.save(flush:true,failOnError:true)
			}
			throw new Exception("Ya existe en esta cuenta")
			return
		}
		proveedorInstance.persona = personaInstance
		proveedorInstance.email = command.email == "undefined" ? null : command.email
		proveedorInstance.alias = command.alias
		proveedorInstance.nota = command.nota
		proveedorInstance.proveedor = command.proveedor
		proveedorInstance.cliente = command.cliente
		proveedorInstance.cuenta = cuenta
		proveedorInstance.save(flush:true, failOnError:true)

		return proveedorInstance
	}

	def deleteClienteProveedor(Long id){
		def clienteProveedorInstance = ClienteProveedor.get(id)

		clienteProveedorInstance.delete(flush:true)

}
	def getClienteProveedor(Long id){
		def clienteProveedorInstance = ClienteProveedor.get(id)

		return clienteProveedorInstance
	}	


}