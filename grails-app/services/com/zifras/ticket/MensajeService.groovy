package com.zifras.ticket

import grails.transaction.Transactional
import grails.plugin.springsecurity.SpringSecurityUtils
import org.joda.time.LocalDateTime

import com.zifras.AccessRulesService

import com.zifras.ticket.MensajeCommand

import grails.validation.ValidationException
import groovy.json.JsonSlurper


@Transactional
class MensajeService {
	def mailService
	AccessRulesService accessRulesService

	def createMensajeCommand(){
		return new MensajeCommand()
	}

	def saveMensaje(MensajeCommand command){
		def mensajeInstance = new Mensaje()
		
		mensajeInstance.remitente = accessRulesService.getCurrentUser().cuenta
		mensajeInstance.asunto = command.asunto
		mensajeInstance.mensaje = command.mensaje
		mensajeInstance.fechaHora = new LocalDateTime()
		mensajeInstance.save(flush:true, failOnError:true)

/*
		mailService.sendMail {
			to 'epavoni2000@gmail.com'
			from SpringSecurityUtils.securityConfig.ui.register.emailFrom
			subject "Nuevo mensaje de ${mensajeInstance.remitente.toString()}"
			html """Asunto: '${mensajeInstance.asunto}' <br/><br/> Mensaje: ${mensajeInstance.mensaje}"""
		}

		//Mail de debug a Chris, borrar cuando se verifique que funciona:
		mailService.sendMail {
			to 'cgzechner@gmail.com'
			from SpringSecurityUtils.securityConfig.ui.register.emailFrom
			subject "Nuevo mensaje de ${mensajeInstance.remitente.toString()}"
			html """Asunto: '${mensajeInstance.asunto}' <br/><br/> Mensaje: ${mensajeInstance.mensaje}"""
		}
*/

		return mensajeInstance
	}

	def deleteMensaje(Long id){
		def mensajeInstance = Mensaje.get(id)
		mensajeInstance.delete(flush:true)
	}
	
	def getMensaje(Long id){
		return Mensaje.get(id)
	}

	def listMensajes(String filter) {
		def lista
		if(filter!=null){
			lista = Mensaje.createCriteria().list() {
				and{
					ilike('mensaje', '%' + filter + '%')
					order('mensaje', 'asc')
				}
			}
		}else{
			lista = Mensaje.list(sort:'fechaHora')
		}
		
		return lista
	}
		
}
