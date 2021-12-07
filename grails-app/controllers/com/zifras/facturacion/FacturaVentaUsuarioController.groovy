package com.zifras.facturacion

import com.zifras.AccessRulesService
import com.zifras.afip.AfipService
import com.zifras.app.App
import com.zifras.cuenta.ClienteProveedor
import com.zifras.cuenta.CondicionIva

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.util.Environment
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import org.joda.time.LocalDate
import org.joda.time.format.DateTimeFormat
import yakworks.reports.ReportFormat

@Secured(['ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
class FacturaVentaUsuarioController {
	AccessRulesService accessRulesService
	AfipService afipService
	def facturaVentaService
	
	def index() {
		redirect(action: "list", params: params)
	}

	@Secured(['ROLE_CUENTA', 'ROLE_RIDER_PY', 'IS_AUTHENTICATED_FULLY'])
	def list() {
		def hoy = new LocalDate()
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		def cuenta = accessRulesService.getCurrentUser().cuenta
		[ano: ano, mes: mes, cuentaId: cuenta?.id, condicionIva:cuenta?.condicionIva?.nombre]
	}

	@Secured(['ROLE_CUENTA', 'ROLE_RIDER_PY', 'IS_AUTHENTICATED_FULLY'])
	def create(Long proformaId, Boolean otros){
		def cuenta = accessRulesService.getCurrentUser().cuenta
		if (cuenta.with{cuit == email || ! claveFiscal}){
			redirect(controller:'dashboard', action:'index', params:[errores:'clave'])
			return
		}
		Long cuentaId = cuenta?.id
		if(!otros && cuenta.trabajaConApp()){ 
			def apps = []
			apps << App.findByNombre("Rappi")
			apps << App.findByNombre("PedidosYa")
			apps << App.findByNombre("Otro")
			render(view:"createFacturaVentaApp", model:[apps:apps])
			return
		}
		def servicioId = TipoConcepto.findByNombre("Servicio").id
		def productoId = TipoConcepto.findByNombre("Producto").id

		def facturaId = cuenta.condicionIva.nombre == "Monotributista" ? TipoComprobante.findByNombre("Factura C").id : TipoComprobante.findByNombre("Factura A").id

		def command = facturaVentaService.createFacturaVentaCommand()
		def puntosVenta = afipService.getPuntosDeVenta(cuenta.id)
		def limiteVentaProducto = 29119 //Valor maximo de venta de un producto para que no pasen de Monotributo a Autonomo

		if(! cuenta.condicionIva || cuenta.condicionIva.nombre == "Sin inscribir"){
			flash.error = "Su cuenta aún no tiene configurada la facturación electrónica. Comunicate con nosotros en la sección de soporte."
			redirect(controller:'soporte')
		}else if (puntosVenta.size() == 0 ){
			flash.error = "Su punto de venta se está generando en AFIP. Por favor vuelva a intentar en 24 horas."
			redirect(controller:'dashboard', action:'index')
		}
		else{
			Proforma proforma = Proforma.get(proformaId)
			LocalDate hoy = new LocalDate()
			def pedidosYaId = proforma ? 346859 : null
			if (proforma && !cuenta.clientesProveedores?.find{it.persona.id == pedidosYaId})
				new ClienteProveedor(persona: Persona.get(pedidosYaId),cuenta: cuenta, cliente: true).save(flush:true)
			[
				facturaVentaInstance: command,
				hoy: hoy,
				fecMinServ: hoy.minusDays(10).toString("dd/MM/yyyy"),
				fecMaxServ: hoy.plusDays(10).toString("dd/MM/yyyy"),
				fecMinProd: hoy.minusDays(5).toString("dd/MM/yyyy"),
				fecMaxProd: hoy.plusDays(5).toString("dd/MM/yyyy"),
				yearMaxFinServ: hoy.plusYears(2).toString("yyyy"),
				cuentaId: cuentaId,
				esMonotributista:! cuenta.aplicaIva,
				iva0: AlicuotaIva.findByCaption("0%").id,
				puntosVenta:puntosVenta,
				facturaId:facturaId,
				servicioId:servicioId,
				productoId:productoId,
				limiteVentaProducto:limiteVentaProducto,
				proforma:proforma,
				pedidosYaId: pedidosYaId
			]

		}
	}

	@Secured(['ROLE_CUENTA', 'ROLE_RIDER_PY', 'IS_AUTHENTICATED_FULLY'])
	def save(FacturaVentaCommand command, Boolean mobile){
		def returnArray = [:]
		def mensaje
		
		if (command.hasErrors()) {
			if(!command.puntoVenta)
				mensaje = 'No se puede crear factura sin punto de venta'
			else
				mensaje = "Campos inválidos: " + command.errors.allErrors.collect{it.field}.join(", ")


			if(mobile){
				returnArray['error'] = true
				returnArray['mensaje'] = mensaje
				render returnArray as JSON
			}else{
				flash.error = message(code: 'zifras.FacturaVenta.command.hasErrors', default:mensaje)
				redirect(action:'create')
			}	
			return
		}
		try {
			def facturaVentaInstance = facturaVentaService.saveFacturaVenta(command)
			
			if(mobile){
				returnArray['error'] = false
				returnArray['mensaje'] = 'OK'
				render returnArray as JSON
			}else{
				flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.FacturaVenta.label', default: 'FacturaVenta'), facturaVentaInstance.toString()], encodeAs:'none')
				redirect(action: "list")
			}			
			return
		}catch (e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			mensaje = 'Error al intentar salvar la Factura'
			if(mobile){
				returnArray['error'] = true
				returnArray['mensaje'] = mensaje
			}else{
				flash.error = message(code: 'zifras.FacturaVenta.save.error', default: mensaje)
			}
		}catch(java.lang.AssertionError e){
			mensaje = e.message.split("finerror")[0]
			if(mobile){
				returnArray['error'] = true
				returnArray['mensaje'] = mensaje
			}else{
				flash.error = mensaje
			}
		}
		if(mobile){
			render returnArray as JSON
			return
		}else{
			redirect(action:'create', params: [puntoVenta: command.puntoVenta])
		}
	}

	def cancelarFactura(Long facturaId, Boolean mobile){ //Emitiendo una nota de credito
		def returnArray = [:]
		def mensaje
		
		try {
			def cuentaId = accessRulesService.getCurrentUser().cuenta.id
			def facturaVentaInstance = facturaVentaService.cancelarFactura(facturaId, cuentaId)
			
			if(mobile){
				returnArray['error'] = false
				returnArray['mensaje'] = 'OK'
				render returnArray as JSON
			}else{
				flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.FacturaVenta.label', default: 'FacturaVenta'), facturaVentaInstance.toString()], encodeAs:'none')
				redirect(action: "list")
			}			
			return
		}catch (e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			mensaje = e.message
			if(mobile){
				returnArray['error'] = true
				returnArray['mensaje'] = mensaje
			}else{
				flash.error = message(code: 'zifras.FacturaVenta.save.error', default: mensaje)
			}
		}catch(java.lang.AssertionError e){
			mensaje = e.message.split("finerror")[0]
			if(mobile){
				returnArray['error'] = true
				returnArray['mensaje'] = mensaje
			}else{
				flash.error = mensaje
			}
		}

		if(mobile){
			render returnArray as JSON
			return
		}else{
			redirect(action:'list')
		}
	}


	def facturarApp(Long appId, Double monto, Boolean mobile, Double monto2, String fecha){
		LocalDate fechaInicio = new LocalDate()
		LocalDate fechaFin = new LocalDate()
		if (fecha){
			DateTimeFormat.forPattern("dd/MM/yyyy").with{
				def fechas = fecha.split(" - ")
				fechaInicio = parseLocalDate(fechas[0])
				fechaFin = parseLocalDate(fechas[1])
			}
		}
		try{
			def cuentaId = accessRulesService.getCurrentUser().cuenta.id
			def facturaVentaInstance = facturaVentaService.saveFacturaVentaApp(monto, appId, cuentaId, monto2, fechaInicio, fechaFin)
			if(mobile)
				render "OK"
			else
				redirect(action:"bajarPdf", id:facturaVentaInstance.id)
			return
		}catch(e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			if(mobile)
				render "Ocurrio un error"
			else
				flash.error = message(code: 'zifras.FacturaVenta.save.error', default: 'Error al intentar salvar la Factura')
		}
		catch(java.lang.AssertionError e){
			String mensaje = e.message.split("finerror")[0]
			if(mobile)
				render mensaje
			else
				flash.error = mensaje
		}
		if(mobile)
			return

		redirect(action:'create')
	}

	@Secured(['ROLE_USER', 'ROLE_CUENTA', 'ROLE_RIDER_PY', 'ROLE_ADMIN', 'ROLE_ADMIN_PY', 'IS_AUTHENTICATED_FULLY'])
	def bajarPdf(Long id){
		String format = ReportFormat.get(response.format)?:ReportFormat.PDF
		def factura = FacturaVenta.get(id)
		if (factura.nombreArchivo){
			try {
				def file = facturaVentaService.getFile(id);
				response.setContentType("APPLICATION/OCTET-STREAM")
				response.setHeader("Content-Disposition", "Attachment;Filename=\"${file.getName()}\"")
						
				def fileInputStream = new FileInputStream(file)
				def outputStream = response.getOutputStream()
				byte[] buffer = new byte[4096];
				int len;
				while ((len = fileInputStream.read(buffer)) > 0) {
					outputStream.write(buffer, 0, len);
				}

				outputStream.flush()
				outputStream.close()
				fileInputStream.close()
			}
			catch(Exception e) {
				if (e.message=="no existe")
					flash.error="No se pudo encontrar el archivo solicitado."
				else if(e.message=="permisos")
					flash.error="No posee permiso para acceder a este archivo."
				else{
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
					flash.error="Ocurrió un error inesperado descargando el archivo."
				}
			}
			redirect(action: "list")
		}else{
			def dataList = []
			def parametros = [:]

			Double subtotal = 0
			parametros = cargaDatosPdf(parametros, id)
			factura.itemsFactura.each {
			  FacturaVentaItemReport item = new FacturaVentaItemReport()
			  item.cantidad = it.cantidad.toString()
			  item.conceptoNombre = it.conceptoNombre
			  item.neto = currencyFormat(it.neto)
			  item.precioUnitario = currencyFormat(it.precioUnitario)
			  item.codigo = "-"
			  item.unidad = "-"
			  item.iva = it.ivaPorcentaje
			  item.total = currencyFormat(it.total)

			  subtotal += it.neto
			  dataList.push(item)
			}

			def pathImagenes

			if (Environment.current == Environment.PRODUCTION)
				pathImagenes = servletContext.getRealPath("/assets") + '/'
			else
				pathImagenes = java.nio.file.FileSystems.default.getPath("grails-app/assets/images").toAbsolutePath().toString() + '/'

			parametros['imagenesPath'] = pathImagenes

			parametros['subtotal'] = '$ ' + currencyFormat(subtotal)

			Map rptModel = [format:format, data:dataList, "ReportTitle":"Controller Report"]
			rptModel = rptModel + parametros

			if(factura.esDeExportacion())
				render(view:"facturaVentaExportacion.jrxml", model:rptModel)
			else
				if(factura.tipoComprobante.letra == "A")
					render(view:"facturaVentaA.jrxml", model:rptModel)
				else
					if(factura.tipoComprobante.codigoAfip == "211"){
						render(view:"facturaVentaFCE.jrxml", model:rptModel)
					}
					else
						render(view:"facturaVenta.jrxml", model:rptModel)
		}
	}

	@Secured(['ROLE_USER', 'ROLE_CUENTA', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def cargaDatosPdf(parametros, Long id){

		def factura = FacturaVenta.get(id)
		parametros['facturaONota'] = factura.tipoComprobante.nombre?.contains("Nota de Crédito") ? "Nota de Crédito" : "FACTURA"
		parametros['numero'] = String.format("%05d",factura.numero)
		parametros['fecha'] = factura.fecha.toString("dd/MM/YYYY")
		parametros['letraFactura'] = factura.tipoComprobante.letra ?: "-"
		parametros['letraCodigo'] = factura.tipoComprobante.codigoAfip ?: "-"
		parametros['razonSocialCliente'] = factura.cliente ? factura.cliente.razonSocial : factura.app.razonSocial
		parametros['domicilioCliente'] = factura.cliente ? (factura.cliente.domicilio ?: "No especificado") : (factura.app.domicilioFiscal ? factura.app.domicilioFiscal.toString() : "Domicilio no especificado")
		parametros['cuitCliente'] = factura.cliente ? factura.cliente.cuit : factura.app.cuit
		parametros['cuitCuenta'] = factura.cuenta.cuit
		parametros['razonSocialCuenta'] = factura.cuenta.with{razonSocial != email ? razonSocial : nombreApellido}
		parametros['domicilioCuenta'] = factura.cuenta.domicilioFiscal ? factura.cuenta.domicilioFiscal.toString() : "Domicilio no especificado"
		parametros['ingresosBrutosCuenta'] = factura.cuenta.regimenIibb?.nombre ?: "No especificado"
		parametros['condicionIvaCuenta'] = factura.cuenta.condicionIva?.nombre ?: "No especificado"
		parametros['inicioActividadesCuenta'] = factura.cuenta.with{periodoMonotributo ?: periodoAutonomo}?.toString("dd/MM/YYYY") ?: "-"
		parametros['puntoVenta'] = String.format("%05d",factura.puntoVenta.numero)
		parametros['iva27'] = '$ ' + factura.iva27
		parametros['iva21'] = '$ ' + factura.iva21
		parametros['iva10'] = '$ ' + factura.iva10
		parametros['iva5'] = '$ ' + factura.iva5
		parametros['iva2'] = '$ ' + factura.iva2
		parametros['iva0'] = '$ ' + factura.iva0
		parametros['cbuEmisor'] = factura.cbuEmisor

		if(factura.esDeExportacion()){
			parametros['facturaONota'] = "Factura de Exportación"
			parametros['moneda'] = factura.moneda.nombre
			parametros['paisDestino'] = factura.codigoPais.pais
			parametros['cotizacionMoneda'] = factura.cotizacionMoneda.toString()
			parametros['cuitPais'] = factura.cuitPais[factura.tipoCuitPais] + " (" + factura.cuitPais.pais + " " + factura.tipoCuitPais + ")"
		}

		def cliente = factura.cliente
		try{
			if (!cliente.condicionIva){
				cliente.condicionIva = CondicionIva.get(afipService.obtenerDatosProveedor(cliente.cuit).condicionIvaId)
				cliente.save(flush:true)
			}
		}
		catch(Exception e) {
			log.error("No se pudo guardar la condición iva del cliente $cliente al pasar a pdf una factura de ${factura.cuenta}")
			println e.message
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		parametros['condicionIvaCliente'] = cliente?.condicionIva?.nombre ?: "No especificado"

		parametros['periodoDesde'] = factura.fechaInicioServicios?.toString("dd/MM/YYYY") ?: "-"
		parametros['periodoHasta'] = factura.fechaFinServicios?.toString("dd/MM/YYYY") ?: "-"
		parametros['vencimientoServicios'] = factura.fechaVencimientoPagoServicio?.toString("dd/MM/YYYY") ?: "-"

		parametros['ivaValor'] = factura.iva.toString()
		parametros['importeOtrosTributos'] = '$ ' + currencyFormat(factura.importeOtrosTributos)
		parametros['importeTotal'] = '$ ' + currencyFormat(factura.total)

		parametros['cae'] = factura.cae ?: "-"
		parametros['vencimientoCae'] = factura.vencimientoCae?.toString("dd/MM/YYYY") ?: "-"
		return parametros
	}

	@Secured(['ROLE_CUENTA','ROLE_RIDER_PY', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetProximoNumero(Long puntoVenta, Long tipoComprobanteId){
		render afipService.getProximoNumero(puntoVenta,tipoComprobanteId)
	}

	def currencyFormat(formatear){

		String patternCurrency = '###,###,##0.00'
		String patternCurrency2 = '###,###,##0.000'
		String pattern = '###,###,###.###'
		DecimalFormat decimalCurencyFormat = new DecimalFormat(patternCurrency)
		DecimalFormat decimalCurencyFormat2 = new DecimalFormat(patternCurrency2)
		DecimalFormat decimalFormat = new DecimalFormat(pattern)
		
		DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
		otherSymbols.setDecimalSeparator(',' as char)
		otherSymbols.setGroupingSeparator('.' as char)
		decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)
		decimalFormat.setDecimalFormatSymbols(otherSymbols)

		return decimalCurencyFormat.format(formatear)
	}
}
