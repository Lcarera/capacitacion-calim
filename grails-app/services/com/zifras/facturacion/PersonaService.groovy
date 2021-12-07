package com.zifras.facturacion

import com.zifras.AccessRulesService
import com.zifras.Estudio
import com.zifras.cuenta.ClienteProveedor
import com.zifras.cuenta.Cuenta

import grails.transaction.Transactional
import grails.validation.ValidationException

@Transactional
class PersonaService {
	AccessRulesService accessRulesService

	def createPersonaCommand(){
		def command = new PersonaCommand()
		return command
	}

	def listPersona(String filter) {
		def lista
		if(filter!=null){
			lista = Persona.createCriteria().list() {
				order('cuit', 'asc')
				and{
					or{
						ilike('cuit', '%' + filter + '%')
						ilike('razonSocial', '%' + filter + '%')
					}
				}
			}
		}else{
			lista = Persona.list(sort:'cuit')
		}

		return lista
	}

	def getPersona(Long id){
		def personaInstance = Persona.get(id)
	}

	def getPersonaCommand(Long id){
		def personaInstance = Persona.get(id)

		if(personaInstance!=null){
			def command = new PersonaCommand()

			command.personaId = personaInstance.id
			command.version = personaInstance.version
			command.razonSocial = personaInstance.razonSocial
			command.cuit = personaInstance.cuit
			command.tipoDocumento = personaInstance.tipoDocumento

			return command
		} else {
			return null
		}
	}

	def getPersonaList() {
		lista = Persona.list();
	}

	def deletePersona(Long id){
		// TODO: Refactor Persona: Eliminar las relaciones con Cuenta
		def personaInstance = Persona.get(id)
		personaInstance.delete(flush:true)
	}

	def savePersona(PersonaCommand command){
		def personaInstance = new Persona()
 
		personaInstance.razonSocial = command.razonSocial  
		personaInstance.cuit = command.cuit  
		personaInstance.tipoDocumento = command.tipoDocumento

		personaInstance.save(flush:true)

		return personaInstance
	}

	def updatePersona(PersonaCommand command){
		def personaInstance = Persona.get(command.personaId)

		if (command.version != null) {
			if (personaInstance.version > command.version) {
				PersonaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["Persona"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el proveedor")
				throw new ValidationException("Error de versión", PersonaCommand.errors)
			}
		}

		personaInstance.razonSocial = command.razonSocial  
		personaInstance.cuit = command.cuit  
		personaInstance.tipoDocumento = command.tipoDocumento

		personaInstance.save(flush:true)

		return personaInstance
	}

	def getCantidadPersonasTotales(){
		return Persona.count()
	}

	def listClientesCuenta(Long cuentaId){
		def lista = []
		Cuenta cuentaInstance = Cuenta.get(cuentaId)
		cuentaInstance?.clientesProveedores.findAll {it.cliente == true}.each{
			lista.push(it.persona)
		}
		def consumidorFinal = Persona.findByRazonSocial("Consumidor Final")
		if (cuentaInstance && ! lista.contains(consumidorFinal)){
			lista << consumidorFinal
			new ClienteProveedor().with{
				cliente = true
				persona = consumidorFinal
				cuenta = cuentaInstance
				save(flush:true)
			}
		}
		return lista
	}

	def listProveedoresCuenta(Long cuentaId){
		def lista = []
		Cuenta.get(cuentaId)?.clientesProveedores.findAll {it.proveedor == true}.each{
			lista.push(it.persona)
		}
		return lista
	}
}