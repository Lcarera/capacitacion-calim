package com.zifras.ticket

import grails.transaction.Transactional
import grails.validation.ValidationException

@Transactional
class ElementoFaqService {

	def createElementoFaqCommand(){
		return new ElementoFaqCommand()
	}

	def saveElementoFaq(ElementoFaqCommand command){
		return pasarDatos(command, new ElementoFaq()).save(flush:true, failOnError:true)
	}

	def updateElementoFaq(ElementoFaqCommand command){
		ElementoFaq.get(command.elementoId)?.with{
			if (version > command.version){
				ElementoFaqCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["ElementoFaq"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el Elemento FAQ")
				throw new ValidationException("Error de versión", ElementoFaqCommand.errors)
			}
			return pasarDatos(command, it).save(flush:true, failOnError:true)
		}
	}

	def deleteElementoFaq(Long id){
		ElementoFaq.get(id)?.delete(flush:true, failOnError:true)
	}

	def listElementos(){
		return ElementoFaq.getAll()
	}

	def listCategorias(){
		return CategoriaFaq.getAll()
	}

	def getElementoFaq(Long id){
		return ElementoFaq.get(id)
	}
	
	def getElementoFaqCommand(Long id){
		return ElementoFaq.get(id)?.with{pasarDatos(it, new ElementoFaqCommand())}
	}

	def getCategoriaFaqCommand(Long id){
		def categoriaInstance = CategoriaFaq.get(id)
		def command = new CategoriaFaqCommand()
		if(categoriaInstance!=null){
			command.categoriaId = categoriaInstance.id
			command.version = categoriaInstance.version
			command.nombre = categoriaInstance.nombre
			command.peso = categoriaInstance.peso
			return command
		}
		else{
			return null
		}
	}

	def saveCategoria(String nombre, String peso){
		def categoria = new CategoriaFaq()

		categoria.nombre = nombre
		categoria.peso = new Long(peso)

		categoria.save(flush:true,failOnError:true)

		return categoria
	}

	def deleteCategoria(Long id){
		CategoriaFaq.get(id)?.delete(flush:true, failOnError:true)
	}

	def updateCategoria(CategoriaFaqCommand command){
		CategoriaFaq.get(command.categoriaId)?.with{
			if (version > command.version){
				CategoriaFaqCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["CategoriaFaq"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la Categoria FAQ")
				throw new ValidationException("Error de versión", CategoriaFaqCommand.errors)
			}
			it.nombre = command.nombre
			it.peso = command.peso
			it.save(flush:true, failOnError:true)
			return it
		}
	}

	// def listElementoFaq(String filter) {}

	private pasarDatos(origen, destino){
		destino.with{
			titulo = origen.titulo
			contenidoHtml = origen.contenidoHtml
			try{
			categoria = CategoriaFaq.get(origen.categoriaFaqId)
			}
			catch(e){
			categoriaFaqId = origen.categoria?.id
			}
			peso = origen.peso
			monotributista = origen.monotributista
			respInscripto = origen.respInscripto
			regimenSimplificado = origen.regimenSimplificado
			convenio = origen.convenio
			local = origen.local
			if (destino instanceof ElementoFaqCommand){
				elementoId = origen.id
				version = origen.version
			}
		}
		return destino
	}
		
}
