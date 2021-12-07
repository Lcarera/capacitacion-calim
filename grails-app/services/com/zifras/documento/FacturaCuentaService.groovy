package com.zifras.documento

import com.zifras.AccessRulesService
import com.zifras.afip.AfipService
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.Localidad
import com.zifras.Provincia
import com.zifras.User
import com.zifras.UsuarioService
import com.zifras.cuenta.Cuenta
import com.zifras.notificacion.NotificacionService
import com.zifras.notificacion.NotificacionTemplate
import com.zifras.cuenta.Local

import grails.config.Config
import grails.transaction.Transactional
import grails.validation.ValidationException
import groovy.json.JsonSlurper
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.LocalTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import org.springframework.context.MessageSource
import org.springframework.context.i18n.LocaleContextHolder
import org.springframework.web.multipart.MultipartFile

@Transactional
class FacturaCuentaService {
	AccessRulesService accessRulesService
	AfipService afipService
	MessageSource messageSource
	def grailsApplication
	def movimientoCuentaService
	def notificacionService
	def pagoCuentaService
	def usuarioService

	def createFacturaCuentaCommand(){
		def command = new FacturaCuentaCommand()
		LocalDateTime ahora = LocalDateTime.now()
		command.hora = ahora.toString("HH:mm")
		command.fecha = new LocalDate()
		return command
	}

	def saveFacturaCuenta(FacturaCuentaCommand command, MultipartFile archivo){
		def facturaCuentaInstance = new FacturaCuenta()

		facturaCuentaInstance.cuenta = Cuenta.get(command.cuentaId)

		String horaFinal = "T" + command.hora + LocalDateTime.now().toString(":ss.SSS")
		facturaCuentaInstance.fechaHora = new LocalDateTime(command.fecha.toString("YYYY-MM-dd") + horaFinal);
		facturaCuentaInstance.descripcion = command.descripcion
		facturaCuentaInstance.importe = command.importe
		facturaCuentaInstance.nombreArchivo = archivo.originalFilename
		facturaCuentaInstance.local = Local.get(command.localId)

		String cuentaPath = facturaCuentaInstance.cuenta.getPath()
		String pathFC = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/facturasCalim/"

		File carpeta = new File(pathFC)
		if(!carpeta.exists())
			carpeta.mkdirs()

		String fullPath = pathFC + facturaCuentaInstance.nombreArchivo
		int versionArchivo = 0
		while((new File(fullPath)).exists()){
			versionArchivo++
			fullPath = pathFC + facturaCuentaInstance.nombreArchivo + " (" + versionArchivo.toString() + ")"
		}
		if (versionArchivo>0)
			facturaCuentaInstance.nombreArchivo += " (" + versionArchivo.toString() + ")"
		archivo.transferTo(new File(fullPath))

		facturaCuentaInstance.save(flush:true)
		generarMovimientoConMail(facturaCuentaInstance)

		return facturaCuentaInstance
	}

	def updateCae(Long facturaId, LocalDate vencimiento, String numeroInput, String caeInput){
		FacturaCuenta.get(facturaId)?.with{
			vencimientoCae = vencimiento
			numero = numeroInput
			cae = caeInput
			save(flush:true, failOnError:true)
		}
	}

	def generarMovimientoConMail(FacturaCuenta factura){
		def movimiento = movimientoCuentaService.saveMovimientoCuentaFactura(factura)

			String patternCurrency = '###,###,##0.00'
			DecimalFormat decimalCurencyFormat = new DecimalFormat(patternCurrency)
			DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
			otherSymbols.setDecimalSeparator(',' as char)
			otherSymbols.setGroupingSeparator('.' as char)
			decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)
			String importeString = "\$ " + decimalCurencyFormat.format(factura.importe)
			String mailDireccion
			String bodyMail
			NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Factura Cuenta")
			if(factura.tenantId == 2){
				User usuario = User.findByCuenta(factura.cuenta)
				mailDireccion = usuario.username
				factura.linkPago = pagoCuentaService.generarLinkPago(movimiento.id, usuario)
				//body = messageSource.getMessage('calim.email.body.facturaCuenta', [factura.cuenta.nombreApellido.split()[0], importeString, factura.linkPago, usuarioService.getLinkDesactivarNotificaciones(usuario)] as Object[], '', LocaleContextHolder.locale)
				bodyMail = plantilla.llenarVariablesBody([factura.cuenta.nombreApellido.split()[0],importeString,factura.linkPago,usuarioService.getLinkDesactivarNotificaciones(usuario)])
			}else{
				factura.linkPago = pagoCuentaService.generarLinkPagoPavoni(movimiento.id, factura.cuenta.id)
				//body = messageSource.getMessage('calim.email.body.facturaCuenta', [factura.cuenta.nombreApellido.split()[0], importeString, factura.linkPago, ""] as Object[], '', LocaleContextHolder.locale)
				bodyMail = plantilla.llenarVariablesBody([factura.cuenta.nombreApellido.split()[0],importeString,factura.linkPago,""])

				if(factura.local!=null)
					mailDireccion = factura.local.email ?: 'cabuqui@gmail.com'
				else
					mailDireccion = factura.cuenta.email ?: 'cabuqui@gmail.com'
			}
			factura.save(flush:true)
			//String asunto = messageSource.getMessage('calim.email.subject.facturaCuenta', [] as Object[], '', LocaleContextHolder.locale)
			notificacionService.enviarEmail(mailDireccion, plantilla.asuntoEmail, bodyMail, 'notificacionFactura', null, plantilla.tituloApp, plantilla.textoApp)
	}

	def listFacturaCuenta(String filter,Long cuentaId, String mes=null, String ano=null) {
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		LocalDateTime fechaDesde = new LocalDateTime()
		LocalDateTime fechaHasta = new LocalDateTime()

		if((ano!=null)&&(mes!=null)){
			fechaDesde = new LocalDateTime(ano + '-' + mes + '-01T00:00:00')
			fechaHasta = fechaDesde.plusMonths(1)
		}

		lista = FacturaCuenta.createCriteria().list() {
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}
			if(filter!=null)
				ilike('descripcion', '%' + filter + '%')

			if((ano!=null)&&(mes!=null)){
				ge('fechaHora', fechaDesde)
				lt('fechaHora', fechaHasta)
			}

			order('descripcion', 'asc')
		}
		return lista
	}

	def getFacturaCuenta(Long id){
		def facturaCuentaInstance = FacturaCuenta.get(id)
	}

	def getFacturaCuentaCommand(Long id){
		def facturaCuentaInstance = FacturaCuenta.get(id)

		if(facturaCuentaInstance!=null){
			def command = new FacturaCuentaCommand()

			command.facturaCuentaId = facturaCuentaInstance.id
			command.version = facturaCuentaInstance.version
			command.cuentaId = facturaCuentaInstance.cuenta.id
			command.fecha = new LocalDate(facturaCuentaInstance.fechaHora.toString("YYYY-MM-dd"))
			command.hora = facturaCuentaInstance.fechaHora.toString("HH:mm")
			command.descripcion = facturaCuentaInstance.descripcion
			command.importe = facturaCuentaInstance.importe
			command.nombreArchivo = facturaCuentaInstance.nombreArchivo

			return command
		} else {
			return null
		}
	}

	def getFacturaCuentaList() {
		lista = FacturaCuenta.list();
	}

	def deleteFacturaCuenta(Long id){
		def facturaCuentaInstance = FacturaCuenta.get(id)

		movimientoCuentaService.deleteMovimientoCuentaFactura(facturaCuentaInstance)

		com.zifras.servicio.ItemServicioEspecial.findAllByFactura(facturaCuentaInstance)*.delete(flush:true)

		String nombre = facturaCuentaInstance.nombreArchivo
		if (nombre){
			String cuentaPath = facturaCuentaInstance.cuenta.path
			String ruta = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/facturasCalim/" + nombre
			(new File(ruta)).delete()
		}

		facturaCuentaInstance.delete(flush:true)
	}

	def updateFacturaCuenta(FacturaCuentaCommand command, MultipartFile archivo){
		def facturaCuentaInstance = FacturaCuenta.get(command.facturaCuentaId)

		if (command.version != null) {
			if (facturaCuentaInstance.version > command.version) {
				FacturaCuentaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["FacturaCuenta"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el Declaracion Jurada")
				throw new ValidationException("Error de versión", FacturaCuentaCommand.errors)
			}
		}

		facturaCuentaInstance.cuenta = Cuenta.get(command.cuentaId)
		String horaFinal = "T" + command.hora + LocalDateTime.now().toString(":ss.SSS")
		facturaCuentaInstance.fechaHora = new LocalDateTime(command.fecha.toString("YYYY-MM-dd") + horaFinal);
		facturaCuentaInstance.descripcion = command.descripcion
		facturaCuentaInstance.importe = command.importe

		if(!archivo.isEmpty()){
			String cuentaPath = facturaCuentaInstance.cuenta.getPath()
			String pathFC = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/facturasCalim/"

			//Borra archivo viejo:
			String fullPathABorrar = pathFC + facturaCuentaInstance.nombreArchivo
			File archivoABorrar = new File(fullPathABorrar)
			archivoABorrar.delete()

			//Cargar archivo nuevo:
			facturaCuentaInstance.nombreArchivo = archivo.originalFilename

			File carpeta = new File(pathFC)
			if(!carpeta.exists())
				carpeta.mkdirs()

			String fullPath = pathFC + facturaCuentaInstance.nombreArchivo
			int versionArchivo = 0
			while((new File(fullPath)).exists()){
				versionArchivo++
				fullPath = pathFC + facturaCuentaInstance.nombreArchivo + " (" + versionArchivo.toString() + ")"
			}
			if (versionArchivo>0)
				facturaCuentaInstance.nombreArchivo += " (" + versionArchivo.toString() + ")"
			archivo.transferTo(new File(fullPath))
		}

		facturaCuentaInstance.save(flush:true)

		return facturaCuentaInstance
	}

	def getCantidadFacturaCuentasTotales(){
		return FacturaCuenta.count()
	}

	def getFile(Long id){
		def usuario = accessRulesService.getCurrentUser()
		def facturaCuentaInstance = FacturaCuenta.get(id)
		if (!facturaCuentaInstance)
			throw new Exception("no existe")
		if (usuario.hasRole("ROLE_CUENTA") && (usuario.cuenta?.id != facturaCuentaInstance?.cuenta?.id))
			throw new Exception("permisos")
		String nombre = facturaCuentaInstance.nombreArchivo
		String cuentaPath = facturaCuentaInstance.cuenta.getPath()

		def file = new File(System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/facturasCalim/" + nombre)

		return file
	}

	def generarPorItemsServicio(listaItems, Boolean enviarEmail = true){
		FacturaCuenta facturaCuentaInstance = new FacturaCuenta().with{
			fechaHora = new LocalDateTime()
			descripcion = listaItems.collect{it.servicio.detalleFactura}.join(" ; ")
			importe = listaItems.sum{it.precio}
			cuenta = listaItems[0].cuenta // Ya sé que todos tienen la misma cuenta, así que la de cualquiera me sirve, y también sé que siempre va a haber un primero
			nombreArchivo = ''
			save(flush:true)
		}
		listaItems.each{
			it.with{
				if (servicio.mensual){
					addToFacturas(facturaCuentaInstance)
					if(facturaCuentaInstance?.cuenta?.tarjetaDebitoAutomatico)
						facturaCuentaInstance.debitoAutomatico = true
					else
						facturaCuentaInstance.debitoAutomatico = false
				}
				else{
					factura = facturaCuentaInstance
					facturaCuentaInstance.debitoAutomatico = false
				}
				facturaCuentaInstance.save(flush:true)
				save(flush:true)
			}
		}
		if(enviarEmail)
			generarMovimientoConMail(facturaCuentaInstance)
		else
			movimientoCuentaService.saveMovimientoCuentaFactura(facturaCuentaInstance)
			
		return facturaCuentaInstance
	}

	def facturarItemMensualAdelantado(item, LocalDate fecha, boolean pagaMesCorriente){
		FacturaCuenta facturaCuentaInstance = new FacturaCuenta().with{
			fechaHora = fecha.toLocalDateTime(new LocalTime())
			descripcion = item.servicio.getDetalleFactura({pagaMesCorriente ? fecha.minusMonths(1) : fecha}.call())
			importe = item.precio
			cuenta = item.cuenta
			nombreArchivo = ''
			save(flush:true)
		}
		item.with{
			addToFacturas(facturaCuentaInstance)
			save(flush:true)
		}
		if(!item.debitoAutomatico)
			generarMovimientoConMail(facturaCuentaInstance)
		else
			movimientoCuentaService.saveMovimientoCuentaFactura(facturaCuentaInstance)

		return facturaCuentaInstance
	}

	def listSolicitudesPago(String filter, String mes=null, String ano=null){
		LocalDateTime fechaDesde = new LocalDateTime()
		LocalDateTime fechaHasta = new LocalDateTime()
		def lista
		if((ano!=null)&&(mes!=null)){
			fechaDesde = new LocalDateTime(ano + '-' + mes + '-01T00:00:00')
			fechaHasta = fechaDesde.plusMonths(1)
		}

		lista = FacturaCuenta.createCriteria().list() {
			if(filter!=null)
				ilike('descripcion', '%' + filter + '%')

			order('descripcion', 'asc')
		}
		def filtradasFechaHora = []
		def filtradasFechaPago = []

		if((ano!=null)&&(mes!=null)){
			filtradasFechaHora = lista.findAll{
				it.fechaHora?.isBefore(fechaHasta) && it.fechaHora?.isAfter(fechaDesde)
			}
			filtradasFechaPago = lista.findAll{
				it.pagada && it.fechaPago?.isBefore(fechaHasta) && it.fechaPago?.isAfter(fechaDesde)
			}
		}
		
		def listaDif = filtradasFechaHora - filtradasFechaPago 
		def listaFinal = listaDif + filtradasFechaPago

		listaFinal = listaFinal.findAll{
			it.itemMensual == null || primerServicioMensual(it,fechaHasta)
		}
		
		return listaFinal
	}

	def primerServicioMensual(FacturaCuenta factura,LocalDateTime fechaHasta){
		def serviciosMensualesCuenta = factura.cuenta.facturasCuenta.findAll{it.itemMensual != null && it.fechaHora?.isBefore(fechaHasta)}

		return serviciosMensualesCuenta.size() == 1
	}

	def cancelarFactura(Long facturaId){
		def facturaACancelar = FacturaCuenta.get(facturaId);
		
		if(!facturaACancelar){
			throw new Exception("No existe la factura a cancelar");
		}			

		if(facturaACancelar.notaCredito)
			throw new Exception("La factura ya se encuentra reembolsada, Nota de Crédito CAE: " + facturaACancelar.notaCredito.cae)

		return afipService.solicitarCaeCalim(facturaACancelar)
	}

}
