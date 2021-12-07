package com.zifras

import grails.plugin.springsecurity.SpringSecurityUtils
import com.zifras.Estudio
import org.joda.time.LocalDateTime
import com.zifras.UserTrack

class FirstInterceptor {
	def springSecurityService
	def usuarioService
	
	public FirstInterceptor() {
		matchAll()
	}

    boolean before() {
		String ipAddress = ""
		ipAddress = request.getHeader("Client-IP")
		String email = "no-user"
		String estudio = "no-estudio"
		def urlsNoLogueables = ['/notificacion/mailgunDeliveredEvent','/notificacion/mailgunOpensEvent','/notificacion/mailgunClicksEvent']
		def actionsSinVerificar = ['pasosRegistro','pagarMovimientosMail', 'confirmarCUIT','accesoDashboard','appGetDatosCuit','appGetImportes','guardarTokenPush']

		if (ipAddress == null)
			ipAddress = request.getHeader("X-Forwarded-For")
		
		if (ipAddress == null)
			ipAddress = request.getRemoteAddr()
			
		String userAgent = request.getHeader("User-Agent")

		def tieneAjax = request.forwardURI.toString().contains('ajax')
		def tieneAssets = request.forwardURI.toString().contains('/zifras/assets')
		
		if(springSecurityService.principal.getClass() == grails.plugin.springsecurity.rest.oauth.OauthUser ){
			def mail = springSecurityService.principal.userProfile.getEmail()
			if(usuarioService.existeUsuario(mail))
				springSecurityService.reauthenticate(mail)
		}

		if((!tieneAjax)&&(!tieneAssets)){

		//if(!tieneAssets){
			def ahora = new LocalDateTime()
			def parametros = "["
			params.each{
				if((it.key != 'password')&&(it.key != 'password2')){
					parametros += it.key + ":" + it.value + ","
				}
			}
			//Le quita la última "," luego de la impresión del mapa al string
			parametros = parametros.getAt(0..parametros.length()-2)
			parametros += "]"
			
			if(springSecurityService.currentUser!=null){
				def userInstance = springSecurityService.currentUser
				email = springSecurityService.currentUser.username
				def estudio2 = Estudio.get(userInstance.userTenantId)
				if(estudio2!=null)
					estudio = estudio2.nombre

				def userTrack = new UserTrack()
				userTrack.fechaHora = ahora
				userTrack.controller = params.controller
				userTrack.action = params.action
				userTrack.params = parametros.take(2047)
				userTrack.ip = ipAddress
				userTrack.user = userInstance
				userTrack.url = request.forwardURI
				userTrack.cuenta = userInstance.cuenta
				userTrack.save(flush:true)

				if(params.controller!='logout'){
					if(userInstance.hasRole("ROLE_CUENTA")){

			            if(userInstance.cuentaSinVerificar()){
			            	if(!(
			            		(['start','registrar','notificacion'].contains(params.controller))&&
			            		(actionsSinVerificar.contains(params.action))
			            	)){
			            		log.info(ahora.toString("dd/MM/YYYY HH:mm:ss") + " " + estudio + " user:" + email + " request:" + request.forwardURI + " ip:" + ipAddress + " params: $parametros")
								println ahora.toString("dd/MM/YYYY HH:mm:ss") + " " + estudio + " user:" + email + " request:" + request.forwardURI + " ip:" + ipAddress + " params: $parametros"
								
								def loginGoogleApp = (params.controller=='auth' && params.action == 'successApp')
								def appGetCuenta = (params.controller=='cuenta' && params.action == 'appGetCuenta')

								if(!loginGoogleApp && !appGetCuenta){
									if(userInstance.cuenta.actionRegistro == "showDatos"){
										redirect(controller:"start", action:"showDatos")
										return
									}
				        			redirect(controller:"registrar", action: "pasosRegistro")
				        			return 
				            	}
			                	return true
			            	}
			            }
			        }
				}				
			}
			if(!urlsNoLogueables.contains(request.forwardURI) ){
				log.info(ahora.toString("dd/MM/YYYY HH:mm:ss") + " " + estudio + " user:" + email + " request:" + request.forwardURI + " ip:" + ipAddress + " params: $parametros")
				println  ahora.toString("dd/MM/YYYY HH:mm:ss") + " " + estudio + " user:" + email + " request:" + request.forwardURI + " ip:" + ipAddress + " params: $parametros"
			}
		}
		//println request
		//println "Pasa por aca" 
		true
	}

    boolean after() { true }

    void afterView() {
        // no-op
    }
}
