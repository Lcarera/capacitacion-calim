package com.zifras.start

import grails.plugin.springsecurity.annotation.Secured
import com.zifras.AccessRulesService
import com.zifras.User
import com.zifras.Role
import com.zifras.UserRole
import com.zifras.security.RegisterCommand
import com.zifras.afip.AfipService
import com.zifras.notificacion.NotificacionService
import com.zifras.notificacion.NotificacionTemplate
import com.zifras.cuenta.CuentaService
import com.zifras.security.RegistrarController
import org.joda.time.LocalDateTime
import grails.converters.JSON
import com.zifras.Estudio

@Secured(['ROLE_USER', 'ROLE_LECTURA', 'ROLE_ADMIN', 'ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
class StartController {
    AccessRulesService accessRulesService
    def afipService
    def notificacionService
    def cuentaService
    def usuarioService
    
    @Secured(['IS_AUTHENTICATED_FULLY'])
    def index() {
        User userInstance = accessRulesService.getCurrentUser()
        
        if(userInstance.hasRole("ROLE_CUENTA")){
            redirect(controller:"dashboard", action: "index")
            return
        }else if (userInstance.hasRole("ROLE_RIDER_PY")){
            redirect(controller:"pedidosYa", action: "rider")
            return
        }else if (userInstance.hasRole("ROLE_ADMIN_PY")){
            redirect(controller:"pedidosYa", action: "admin")
            return
        }
        redirect(controller:"cuenta", action: "list")
    }

    /*def ingresarCUIT(){
        [command: new RegisterCommand()]
    }*/

    def showDatos(String cuit, String telefono){
        def command
        String mailHTML
        boolean hayError = false
        def cuentaId =  accessRulesService.getCurrentUser()?.cuenta.id
        if(cuentaId)
            cuentaService.guardarStepRegistro(cuentaId,params.action)

        try {
            def usuario = accessRulesService.getCurrentUser()
            mailHTML = "Email: " + usuario.username + "<br/>" + "Nombre-Apellido: " + usuario.cuenta?.nombreApellido + "<br/>" + "CUIT: " + cuit + "<br/>" + "Teléfono: " + telefono + '<br/><br/><br/><br/>'
            if(telefono)
                cuentaService.actualizarTelefono(usuario.cuenta.id, telefono)
            cuentaService.actualizarCuit(usuario.cuenta.id, cuit)
            command = afipService.llenarCommandRegistro(cuit)

            mailHTML += "Dump de datos obtenidos de la AFIP:<br/><br/><br/>" + "<br/>" + 'Actividad:' + command.actividad + "<br/>" + 'Apellido:' + command.apellido + "<br/>" + 'Categoria:' + command.categoria + "<br/>" + 'Cuit:' + command.cuit + "<br/>" + 'Domicilio:' + command.domicilio + "<br/>" + 'Impuestos:' + command.impuestos + "<br/>" + 'Localidad:' + command.localidad + "<br/>" + 'Nombre:' + command.nombre + "<br/>" + 'Razón Social:' + command.razonSocial + "<br/>" + 'Tipo:' + command.tipo + "<br/>" + 'Tipo Iva:' + command.tipoIva
        }
        catch(java.lang.AssertionError e){
            String mensaje = e.message.substring(0,e.message.indexOf('..')+1) + "\nDentro de las próximas 48 horas un asesor te contactará para ayudarte a solucionarlo."
            flash.error = mensaje
            mailHTML += "Error de CUIT: " + mensaje + "<br/>"  + "<br/>" + "DUMP XML:" + "<br/>"  + "<br/>" + afipService.getResponseXML(cuit)
            //Hago el substring porque el mensaje de la excepción es '(el mensaje que mandé desde el service, terminado en .).Expression(La linea que falló)' y sólo me interesa mostrar el mensaje original
            hayError = true
        }
        catch(Exception e) {
            log.error(e.message)
            if (e.localizedMessage.contains('No existe')){
                flash.error = "El cuit ingresado no existe."
                mailHTML += "<br/><br/>El cuit ingresado no existe."
                // TODO: Acá bloqueamos la cuenta y lo redirigimos a otra pantalla
            }
            else{
                log.error(e.message)
                println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
                flash.error="Ocurrió un error intentando recuperar los datos de la AFIP."
                mailHTML += "<br/><br/>Error de sistema intentando obtener los datos del CUIT:<br/>${e.message}"
            }
            hayError = true
        }

        // notificacionService.enviarEmailInterno("info@calim.com.ar", "Usuario CALIM ingresó CUIT", mailHTML, 'ingresoCUIT')
        if (hayError){
            redirect(controller:'registrar', action:'ingresoCUIT')
            return
        }

        [datos:command]
    }

    def appGetDatosCuit(String cuit, String telefono) {
        def command
        String errorMsg
        String mailHTML
        boolean hayError = false
        def returnArray = [:]
        
        try {
            def usuario = accessRulesService.getCurrentUser()
            mailHTML = "Email: " + usuario.username + "<br/>" + "Nombre-Apellido: " + usuario.cuenta?.nombreApellido + "<br/>" + "CUIT: " + cuit + "<br/>" + "Teléfono: " + telefono + '<br/><br/><br/><br/>'
            cuentaService.actualizarTelefono(usuario.cuenta.id, telefono)
            cuentaService.actualizarCuit(usuario.cuenta.id, cuit)
            command = afipService.llenarCommandRegistro(cuit)

            mailHTML += "Dump de datos obtenidos de la AFIP:<br/><br/><br/>" + "<br/>" + 'Actividad:' + command.actividad + "<br/>" + 'Apellido:' + command.apellido + "<br/>" + 'Categoria:' + command.categoria + "<br/>" + 'Cuit:' + command.cuit + "<br/>" + 'Domicilio:' + command.domicilio + "<br/>" + 'Impuestos:' + command.impuestos + "<br/>" + 'Localidad:' + command.localidad + "<br/>" + 'Nombre:' + command.nombre + "<br/>" + 'Razón Social:' + command.razonSocial + "<br/>" + 'Tipo:' + command.tipo + "<br/>" + 'Tipo Iva:' + command.tipoIva
        }
        catch(java.lang.AssertionError e){
            String mensaje = e.message.substring(0,e.message.indexOf('..')+1) + "\nDentro de las próximas 48 horas un asesor te contactará para ayudarte a solucionarlo."
            errorMsg = mensaje
            mailHTML += "Error de CUIT: " + mensaje + "<br/>"  + "<br/>" + "DUMP XML:" + "<br/>"  + "<br/>" + afipService.getResponseXML(cuit)
            //Hago el substring porque el mensaje de la excepción es '(el mensaje que mandé desde el service, terminado en .).Expression(La linea que falló)' y sólo me interesa mostrar el mensaje original
            hayError = true
        }
        catch(Exception e) {
            log.error(e.message)
            if (e.localizedMessage.contains('No existe')){
                returnArray['error'] = "El cuit ingresado no existe."
                mailHTML += "<br/><br/>El cuit ingresado no existe."
                // TODO: Acá bloqueamos la cuenta y lo redirigimos a otra pantalla
            }
            else{
                log.error(e.message)
                println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
                returnArray['error'] = "Ocurrió un error intentando recuperar los datos de la AFIP."
                mailHTML += "<br/><br/>Error de sistema intentando obtener los datos del CUIT."
            }
            hayError = true
        }

        // notificacionService.enviarEmailInterno("info@calim.com.ar", "Usuario CALIM ingresó CUIT via APP", mailHTML, 'ingresoCUIT')
        if (hayError){
            render returnArray as JSON
            return
        }

        returnArray['cuit'] = command.cuit;
        returnArray['nombre'] = command.nombre;
        returnArray['apellido'] = command.apellido;
        returnArray['razonSocial'] = command.razonSocial;
        returnArray['tipo'] = command.tipo;
        returnArray['localidad'] = command.localidad;
        returnArray['domicilio'] = command.domicilio;
        returnArray['tipoIva'] = command.tipoIva;
        returnArray['actividad'] = command.actividad;
        returnArray['impuestos'] = command.impuestos;
        returnArray['categoria'] = command.categoria;
        returnArray['error'] = null;

        render returnArray as JSON

    }

    def confirmarCUIT(String cuit, Boolean mobile){
    	def errorMsg
        try {
            def usuario = accessRulesService.getCurrentUser()
            afipService.guardarResponseEnCuenta(cuit, usuario.cuenta.id)

            def cuenta = cuentaService.getCuentaByEmail(usuario.username)

            String nombreUsuario = ""
            if(cuenta!=null){
                nombreUsuario = (cuenta.nombreApellido.split(' '))[0]
            }

            String urlNotificaciones = usuarioService.getLinkDesactivarNotificaciones(usuario)

            //def body = message(code: 'calim.register.email.bienvenido.body', args: [nombreUsuario, urlNotificaciones])
            //String asunto = message(code: 'calim.register.email.bienvenido.subject')
        
            NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Email Bienvenido")
            String bodyMail = plantilla.llenarVariablesBody([nombreUsuario,urlNotificaciones])

            notificacionService.enviarEmail(usuario.username, plantilla.asuntoEmail, bodyMail, 'bienvenido', null, plantilla.tituloApp, plantilla.textoApp)

            //Se programa email para enviar en una hora
            //def body2 = message(code: 'calim.nosVamosAComunicarConVos.email.body', args: [nombreUsuario, urlNotificaciones])
            //String asunto2 = message(code: 'calim.nosVamosAComunicarConVos.email.subject')


            String mensajeHtml = "Email: " + usuario.username + "<br/>CUIT: " + cuit + '<br/><br/><br>/<br/>'
            try {
                def parseoAfip = afipService.llenarCommandRegistro(cuit)
                mensajeHtml += "Dump de datos obtenidos de la AFIP:<br/><br/><br/>" + "<br/>" + 'Actividad:' + parseoAfip.actividad + "<br/>" + 'Apellido:' + parseoAfip.apellido + "<br/>" + 'Categoria:' + parseoAfip.categoria + "<br/>" + 'Cuit:' + parseoAfip.cuit + "<br/>" + 'Domicilio:' + parseoAfip.domicilio + "<br/>" + 'Impuestos:' + parseoAfip.impuestos + "<br/>" + 'Localidad:' + parseoAfip.localidad + "<br/>" + 'Nombre:' + parseoAfip.nombre + "<br/>" + 'Razón Social:' + parseoAfip.razonSocial + "<br/>" + 'Tipo:' + parseoAfip.tipo + "<br/>" + 'Tipo Iva:' + parseoAfip.tipoIva   
            }
            catch(java.lang.AssertionError e){
                mensajeHtml += "Ocurrió un error obteniendo el parseo de datos de la AFIP."
            }
            catch(Exception e) {
                mensajeHtml += "Ocurrió un error obteniendo el parseo de datos de la AFIP."
            }
            // notificacionService.enviarEmailInterno("info@calim.com.ar", "Usuario CALIM con CUIT", mensajeHtml, 'verificacionCUIT')
        }
        catch(Exception e) {
        	log.error(e.message)
        	errorMsg = "Ocurrió un error guardando los datos de la AFIP en la cuenta."
            flash.error = errorMsg
            if(mobile)
                render errorMsg
            else
                redirect(controller:'registrar', action:'ingresoCUIT')

            return
        }
        
        if(mobile)
            render "OK"
        else
	           	redirect(controller: 'registrar', action:'pasosRegistro',params:[pasoActual:"confirmacionCUIT"])
        return
    }

    @Secured(['permitAll'])
    def coincideVersionApp(String version){
        def estudioCalim = Estudio.findByNombre('Calim')
        def versionActual = estudioCalim?.appVersion
        def returnArray = [:]

        if(version.toString() != versionActual.toString()) {
            returnArray['marketLinkAndroid'] = grailsApplication.config.getProperty('marketLinkAndroid') 
            returnArray['marketLinkIos'] = grailsApplication.config.getProperty('marketLinkIos')
            returnArray['mensaje'] = "Actualice la aplicacion para continuar"
            returnArray['ok'] = false
        } else {
            returnArray['ok'] = true
        }

        render returnArray as JSON
    }
}
