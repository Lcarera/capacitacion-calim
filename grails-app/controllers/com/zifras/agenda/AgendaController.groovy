package com.zifras.agenda
import grails.plugin.springsecurity.annotation.Secured;
import grails.validation.ValidationException
import org.springframework.dao.DataIntegrityViolationException
import org.joda.time.LocalDateTime
import org.joda.time.LocalTime
import org.joda.time.LocalDate
import com.zifras.AccessRulesService
import grails.converters.JSON
import com.zifras.cuenta.ClienteProveedor
import com.zifras.cuenta.ClienteProveedorCommand
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.afip.AfipService
import com.zifras.selenium.SeleniumService
import com.zifras.BitrixService
import com.zifras.documento.Comprobante
import com.zifras.ventas.Vendedor
import com.zifras.ventas.Horario
import com.zifras.ventas.Turno
import com.zifras.facturacion.Proforma
import com.zifras.facturacion.FacturaVenta
import com.zifras.cuenta.Cuenta
import com.zifras.servicio.Servicio
import com.zifras.servicio.ServicioService
import com.zifras.notificacion.NotificacionService
import com.zifras.Contador
import com.zifras.ventas.VendedorService
import com.zifras.ticket.EmpleadoSoporte
import com.zifras.documento.PagoCuentaService
import com.zifras.documento.PagoCuenta
import java.time.DayOfWeek
import com.zifras.notificacion.ConsultaWeb
import com.zifras.debito.DebitoAutomaticoService

@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class AgendaController {
	def agendaService
	AccessRulesService accessRulesService
	def afipService
	def bitrixService
	def cuentaService
	def debitoAutomaticoService
	def notificacionService
	def pagoCuentaService
	def seleniumService
	def servicioService
	def vendedorService
	
	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def index() {
		redirect(action: "list", params: params)
	}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def clientes() {
		def cuenta = accessRulesService.getCurrentUser().cuenta?.id
		[cuentaId: cuenta]
	}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def proveedores() {
		def cuenta = accessRulesService.getCurrentUser().cuenta?.id
		[cuentaId: cuenta]
	}

	@Secured(['ROLE_USER','ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def clientesProveedoresBack(Long id) {	
		[cuentaId: id]
	}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetClientesOProveedoresList(Long cuentaId, String tipo){
		def clientes = agendaService.getClienteOProveedorPorCuenta(cuentaId,tipo)
		render clientes as JSON
	}
	
	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def edit(Long id, String tipo) {
		def clienteProveedorInstance = agendaService.getClienteProveedorCommand(id)
		if (!clienteProveedorInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.ClienteProveedor.label', default: 'ClienteProveedor'), id])
			redirect(action: tipo)
			return
		}

		[clienteProveedorInstance: clienteProveedorInstance, tipo: tipo]
	}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def testy() {
		debitoAutomaticoService.generarTxt("asa")
		render "aaa"
	}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def testy2() {
		Double precio = 2130
		Integer entera = precio
		Integer decimal = (precio - entera) * 100
		println String.format("%013d%02d",entera,decimal)
		String ds = "sdsdsodksodk \n sdsdac \n sasc"
		println ds
		render "Aa"
	}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def testy3() {
		def s = "FEXGetPARAM_UMed"
		println afipService.dispararServiceWsfex(s,"20282509009")
		render "ss"
	}

	@Secured(['ROLE_ADMIN', 'ROLE_LECTURA', 'ROLE_SM', 'ROLE_SE', 'IS_AUTHENTICATED_FULLY'])
	def editBackoffice(Long id, String tipo, Long cuentaId) {
		def clienteProveedorInstance = agendaService.getClienteProveedorCommand(id)
		if (!clienteProveedorInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.ClienteProveedor.label', default: 'ClienteProveedor'), id])
			redirect(action: "list")
			return
		}

		[clienteProveedorInstance: clienteProveedorInstance, tipo: tipo, cuentaId: cuentaId]
	}
	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_SM', 'ROLE_SE', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def update(ClienteProveedorCommand command, Boolean mobile) {
			def returnArray = [:]
			if (command.hasErrors()) {
				
				if(mobile){
					returnArray['error'] = true
					returnArray['mensaje'] = "Error en algun atributo"
					render returnArray as JSON
				}else{
					render(view: "edit", model: [clienteProveedorInstance: command])
				}
				return
			}
			def clienteProveedorInstance
			clienteProveedorInstance = agendaService.updateClienteProveedor(command)
			
			if(mobile){
				returnArray['error'] = false
				returnArray['mensaje'] = "OK"
				render returnArray as JSON
				return
			}else{
				flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.documento.clienteProveedor.label',default:'Cliente/Proveedor'), clienteProveedorInstance.persona.razonSocial], encodeAs:'none')
		
				redirect(action:"list")
				return
			}


		}
	@Secured(['ROLE_ADMIN', 'ROLE_LECTURA', 'ROLE_SM', 'ROLE_SE', 'IS_AUTHENTICATED_FULLY'])
	def updateBackoffice(ClienteProveedorCommand command) {
		if (command.hasErrors()) {
			flash.error = "Campos inválidos: " + command.errors.allErrors.collect{it.field}.join(", ") 
			render(view: "editBackoffice", model: [clienteProveedorInstance:command])
			return
		}
		def clienteProveedorInstance
		clienteProveedorInstance = agendaService.updateClienteProveedor(command)
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.documento.clienteProveedor.label',default:'Cliente/Proveedor'), clienteProveedorInstance.persona.razonSocial], encodeAs:'none')
		redirect(action:"list")
		}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def create(String path) {
		def command = agendaService.createProveedorCommand()
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		def cuentaId = accessRulesService.getCurrentUser()?.cuenta.id
		[clienteProveedorInstance: command, cuentaId:cuentaId, path:path]
	}

	@Secured(['ROLE_ADMIN', 'ROLE_LECTURA', 'ROLE_SM', 'ROLE_SE', 'IS_AUTHENTICATED_FULLY'])
	def createBackoffice(Long id) {
		def command = agendaService.createProveedorCommand()
		println(id)
		
		if (command.hasErrors()) {
			flash.error = message(code: command.errors.allErrors.get(0).code, args: command.errors.allErrors.get(0).arguments)
			redirect(action: "list")
		}
		
		[clienteProveedorInstance: command, cuentaId:id]
	}

	@Secured(['ROLE_USER','ROLE_CUENTA', 'ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def save(ClienteProveedorCommand commandClienteProveedor, Long id, String path, Boolean mobile) {
		def returnArray = [:]
		if (commandClienteProveedor.hasErrors() || (!commandClienteProveedor.cliente && !commandClienteProveedor.proveedor)) {
			flash.error = "Los siguientes campos contienen errores: " + commandClienteProveedor.errors.allErrors.collect{it.field}
			if(mobile){
				returnArray['error'] = true
				returnArray['mensaje'] = "Error en algun atributo" + commandClienteProveedor.errors.allErrors.collect{it.field}
				render returnArray as JSON
			}else{
				render(view: "create", model: [clienteProveedorInstance: commandClienteProveedor, cuentaId:id, path:path])
			}
			return
		}
		
		def proveedorInstance
		
		try {
			proveedorInstance = agendaService.saveProveedor(commandClienteProveedor,id)
		}catch (e){
			if(mobile){
				returnArray['error'] = true
				returnArray['mensaje'] = "Error creando el cliente. " + e.message
				render returnArray as JSON
				return
			}
			flash.error	= e.message ?: message(code: 'zifras.ticket.Mensaje.save.error', default: 'Error al intentar enviar el mensaje')
			render(view: "create", model: [clienteProveedorInstance: commandClienteProveedor, cuentaId:id])
			return
		}	

		if(mobile){
			returnArray['error'] = false
			returnArray['mensaje'] = "OK"
			render returnArray as JSON
			return
		}

		if(proveedorInstance.proveedor){
			flash.message = "Proveedor creado exitosamente."
		}
		else{
			flash.message = "Cliente creado exitosamente."  //POR QUE CUANDO GUARDO DESDE BACKOFFICE NO HAY MSJES???
		}
		if(path!='factura'){
			if(accessRulesService.getCurrentUser()?.cuenta?.tenantId==2)
				redirect(controller:"agenda",action: "list")
			else
				redirect(controller:"agenda",action: "clientesProveedoresBack",params:['id':id])
		}
		else
			render "" //vuelve al create de factura automaticamente
	}

	@Secured(['ROLE_USER','ROLE_CUENTA','ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def delete(Long id, Boolean esCliente, Boolean mobile) {
		def returnArray = [:];
		def clienteProveedorInstance = agendaService.getClienteProveedor(id)
		println clienteProveedorInstance
		if (!clienteProveedorInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.clienteProveedor.label', default: 'Cliente/Proveedor'), clienteProveedorInstance.persona.razonSocial])
			if(mobile){
				returnArray['error'] = true
				render returnArray as JSON
				return
			}
			else
				redirect(action: "list")
			
			return
		}

		try {
			agendaService.deleteClienteProveedor(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.documento.clienteProveedor.label', default: 'Cliente/Proveedor'),clienteProveedorInstance.persona.razonSocial], encodeAs:'none')
			if(mobile){
				returnArray['error'] = false
				render returnArray as JSON
				return
			}
			else
				redirect(action:"list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.documento.clienteProveedor.label', default: 'Cliente/Proveedor'), clienteProveedorInstance.persona.razonSocial], encodeAs:'none')
			if(mobile){
				returnArray['error'] = true
				render returnArray as JSON
				return
			}
			else
				redirect(controller:"agenda", action: "list")
		}
	}

	@Secured(['ROLE_USER','ROLE_CUENTA','ROLE_ADMIN', 'ROLE_SM', 'ROLE_SE', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def deleteBackoffice(Long id, Long cuentaId) {
		def clienteProveedorInstance = agendaService.getClienteProveedor(id)
		if (!clienteProveedorInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.documento.clienteProveedor.label', default: 'Cliente/Proveedor'), clienteProveedorInstance.persona.razonSocial])
			redirect(action: "list")
			return
		}

		try {
			agendaService.deleteClienteProveedor(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.documento.clienteProveedor.label', default: 'Cliente/Proveedor'),clienteProveedorInstance.persona.razonSocial], encodeAs:'none')
			redirect(action:"clientesProveedoresBack" , params:[id:cuentaId])
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.documento.clienteProveedor.label', default: 'Cliente/Proveedor'), clienteProveedorInstance.persona.razonSocial], encodeAs:'none')
			redirect(controller:"agenda", action: "list")
		}
	}
	@Secured(['ROLE_ADMIN','ROLE_CUENTA', 'ROLE_LECTURA', 'ROLE_SM', 'ROLE_SE', 'IS_AUTHENTICATED_FULLY'])
	def list() {
		def cuentaId = accessRulesService.getCurrentUser()?.cuenta?.id
		if(cuentaId){
			render(view: "clientesProveedoresUsuario", model:['cuentaId': cuentaId])
		}
		else{
			if (accessRulesService.getCurrentUser()?.esCalim)
				render(view: "listCalimAgenda")
			else
				render(view: "listPavoniAgenda")
		}
	}

	def ajaxGetDatosPersona (String cuit){
		def command
        def returnArray = [:]
        Boolean hayError = false
        
        try {
            command = afipService.llenarCommandRegistro(cuit)
		}
		catch(Exception e) {
            log.error(e.message)
            if (e.localizedMessage.contains('No existe')){
                returnArray['error'] = "El cuit ingresado no existe."
                // TODO: Acá bloqueamos la cuenta y lo redirigimos a otra pantalla ;;;; NO HAY QUE HACER ESTO, TIENE QUE CORREGIRLO
            }
            else{
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
                returnArray['error'] = "Ocurrió un error intentando recuperar los datos de la AFIP."
            }
            hayError = true
        }

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

    def ajaxGetDatosClienteProveedor(String cuit){
    	def returnArray = [:]

    	try{
    		returnArray = afipService.obtenerDatosProveedor(cuit)
    	}
    	catch(Exception e){
    		log.error(e.message)
    		returnArray['error'] = "Ocurrió un error intentando recuperar los datos de la AFIP"
    	}

    	render returnArray as JSON
    }

}
