package com.zifras.facturacion

import static com.zifras.Auxiliar.formatear
import com.zifras.AccessRulesService
import com.zifras.Estudio
import com.zifras.afip.AfipService
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.Nacionalidad
import com.zifras.app.App
import com.zifras.PaisCodigo
import com.zifras.PaisCuit

import grails.transaction.Transactional
import grails.validation.ValidationException
import grails.web.mapping.LinkGenerator
import groovy.json.JsonSlurper
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

@Transactional
class FacturaVentaService {
	def grailsApplication
	AccessRulesService accessRulesService
    LinkGenerator grailsLinkGenerator
	AfipService afipService

	def createFacturaVentaCommand(){
		def command = new FacturaVentaCommand()
		command.neto=0
		command.total=0
		command.iva=0
		command.ivaDefaultId = AlicuotaIva.findByValor(21).id //Para que el combo no inicialice vacío
		return command
	}
	
	def listFacturaVenta(String mes, String ano, Long cuentaId) {
		def cuentaInstance = Cuenta.get(cuentaId)
		def fechaMin = new LocalDate(ano + '-' + mes + '-01')
		def fechaMax = fechaMin.plusMonths(1)
		def lista = FacturaVenta.createCriteria().list() {
				and{
					eq('cuenta', cuentaInstance)
					ge('fecha', fechaMin)
					lt('fecha', fechaMax)
				}
			}
		
		return lista
	}
	
	def listAllFacturaVenta(Long cuentaId){
		def cuentaInstance = Cuenta.get(cuentaId)
		def lista = FacturaVenta.createCriteria().list() {
				and{
					eq('cuenta', cuentaInstance)
				}
			}

		return lista
	}
	
	def getFacturaVenta(Long id){
		def facturaVentaInstance = FacturaVenta.get(id)
	}

	def getFile(Long id){
		def usuario = accessRulesService.getCurrentUser()
		def instance = FacturaVenta.get(id)
		if (!instance?.nombreArchivo)
			throw new Exception("no existe")
		if ((usuario.hasRole("ROLE_CUENTA") || usuario.hasRole("ROLE_RIDER_PY"))&& (usuario.cuenta?.id != instance?.cuenta?.id))
			throw new Exception("permisos")
		String nombre = instance.nombreArchivo
		String cuentaPath = instance.cuenta.getPath()
		
		def file = new File(System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/facturasVenta/" + nombre)

		return file
	}
	
	def listConceptos(String filter) {
		def lista
		if(filter!=null){
			lista = TipoConcepto.createCriteria().list() {
				and{
					ilike('nombre', '%' + filter + '%') 
					order('nombre', 'asc')
				}
			}
		}else{
			lista = TipoConcepto.list(sort:'nombre')
		}
		
		return lista
	}
	
	def listUnidadesMedida(String filter){
		def lista
		if(filter!=null){
			lista = UnidadMedida.createCriteria().list() {
				and{
					ilike('nombre', '%' + filter + '%')
					order('nombre', 'asc')
				}
			}
		}else{
			lista = UnidadMedida.list(sort:'nombre')
		}
		
		return lista
	}
	
	def getUnidadMedida(Long unidadId){
		def unidad = UnidadMedida.get(unidadId)
		return unidad
	}
	
	def getConcepto(Long id){
		def conceptoInstance = TipoConcepto.get(id)
	}
	
	def listAlicuotas(String filter) {
		def lista
		if(filter!=null){
			lista = AlicuotaIva.createCriteria().list() {
				and{
					ilike('caption', '%' + filter + '%') 
					order('caption', 'asc')
				}
			}
		}else{
			lista = AlicuotaIva.list(sort:'caption')
		}
		
		return lista
	}
	
	def getAlicuota(Long id){
		def alicuotaInstance = AlicuotaIva.get(id)
	}
	
	def getFacturaVentaCommand(Long id){
		def facturaVentaInstance = FacturaVenta.get(id)
		
		if(facturaVentaInstance!=null){
			def command = copiarDatos(facturaVentaInstance, new FacturaVentaCommand(), false)
			command.ivaDefaultId = AlicuotaIva.findByValor(21).id

			return command
		} else {
			return null
		}
	}
	
	def getFacturaVentaList() {
		lista = FacturaVenta.list();
	}
	
	def deleteFacturaVenta(Long id){
		def facturaVentaInstance = FacturaVenta.get(id)
		facturaVentaInstance.delete(flush:true, failOnError:true)
	}
	
	def saveFacturaVenta(FacturaVentaCommand command){
		FacturaVenta facturaVentaInstance = new FacturaVenta()
		Cuenta cuenta = Cuenta.get(command.cuentaId)
		PuntoVenta puntoVenta = PuntoVenta.findByCuentaAndNumero(cuenta,command.puntoVenta)
		if (!puntoVenta){
			puntoVenta = new PuntoVenta()
			puntoVenta.cuenta = cuenta
			puntoVenta.numero = command.puntoVenta
			puntoVenta.save(flush:true)
		}
		facturaVentaInstance.puntoVenta = puntoVenta
		facturaVentaInstance = copiarDatos(command, facturaVentaInstance)
		Proforma.get(command.proformaId)?.with{
			ultimaSubida = new LocalDateTime()
			factura = facturaVentaInstance
			estado = Proforma.Estados.VERIFICADA
			save(flush:true)
		}
		if(TipoComprobante.get(command.tipoId)?.nombre == "Factura de Exportación E")
			return afipService.obtenerCaeFacturaExportacion(facturaVentaInstance)
		else
			return afipService.obtenerCaeFactura(facturaVentaInstance)
	}

	def cancelarFactura(Long facturaId, Long cuentaId){
		Boolean factE = false
		def facturaACancelar = FacturaVenta.get(facturaId);
		if(!facturaACancelar){
			throw new Exception("No existe la factura a cancelar");
		}

		if(facturaACancelar.cuenta.id != cuentaId)
			throw new Exception("Unauthorized");			

		def tipo = facturaACancelar.tipoComprobante.nombre
		if(!tipo.contains("Factura"))
			throw new Exception("No es una factura");			

		if(facturaACancelar.esFacturaCancelada())
			throw new Exception("La factura ya se encuentra cancelada")

		def notaDeCredito = new FacturaVenta()
		def tipoNC
		switch(tipo){
			case "Factura A":
				tipoNC = "Nota de Crédito A"
				break;
			case "Factura B":
				tipoNC = "Nota de Crédito B"
				break;
			case "Factura C":
				tipoNC = "Nota de Crédito C"
				break;
			case "Factura de Exportación E":
				tipoNC = "Nota de Crédito por Operaciones con el Exterior E"
				factE = true
				break;
			case "Factura M":
				tipoNC = "Nota de Crédito M"
				break;
		}

		notaDeCredito.tipoComprobante = TipoComprobante.findByNombre(tipoNC)
		notaDeCredito.cuenta = facturaACancelar.cuenta

		notaDeCredito.puntoVenta = facturaACancelar.puntoVenta

		notaDeCredito.numero = new Long(afipService.getProximoNumero(notaDeCredito.puntoVenta.numero,notaDeCredito.tipoComprobante.id))
				
		notaDeCredito.fecha = new LocalDate()

		notaDeCredito.fechaInicioServicios = facturaACancelar.fechaInicioServicios
		notaDeCredito.fechaFinServicios = facturaACancelar.fechaFinServicios
		notaDeCredito.fechaVencimientoPagoServicio = new LocalDate()

		notaDeCredito.cliente = facturaACancelar.cliente
		notaDeCredito.concepto = facturaACancelar.concepto


		notaDeCredito.netoGravado = facturaACancelar.netoGravado
		notaDeCredito.netoGravado0 = facturaACancelar.netoGravado0
		notaDeCredito.iva0 = facturaACancelar.iva0
		notaDeCredito.iva = facturaACancelar.iva
		notaDeCredito.neto = facturaACancelar.neto
		notaDeCredito.total = facturaACancelar.total

		notaDeCredito.bienImportado = true
		
		def comprobanteAsoc = new ComprobanteAsociado()
		comprobanteAsoc.nombre = facturaACancelar.tipoComprobante.nombre
		comprobanteAsoc.comprobanteId = facturaACancelar.id
		comprobanteAsoc.save(flush:true, failOnError:true)

		notaDeCredito.addToComprobantesAsociados(comprobanteAsoc)

		notaDeCredito.save(flush:true, failOnError:true)

		facturaACancelar.itemsFactura.each{
			def item = new ItemFactura()
			ConceptoFacturaVenta concepto = ConceptoFacturaVenta.findByNombreAndCuenta(it.concepto.nombre,notaDeCredito.cuenta)
			
			item.concepto = concepto
			item.cantidad = it.cantidad
			item.alicuota = it.alicuota
			item.precioUnitario = it.precioUnitario
			item.facturaVenta = notaDeCredito
			
			item.save(flush:true, failOnError:true)

			notaDeCredito.addToItemsFactura(item)
		}
		
		notaDeCredito.save(flush:true, failOnError:true)

		def ndcAsoc = new ComprobanteAsociado()
		ndcAsoc.nombre = notaDeCredito.tipoComprobante.nombre
		ndcAsoc.comprobanteId = notaDeCredito.id
		ndcAsoc.save(flush:true, failOnError:true)

		facturaACancelar.addToComprobantesAsociados(ndcAsoc)
		facturaACancelar.save(flush:true, failOnError:true)

		if(factE){
			notaDeCredito.cuitPais = facturaACancelar.cuitPais
			notaDeCredito.codigoPais = facturaACancelar.codigoPais
			notaDeCredito.idioma = facturaACancelar.idioma
			notaDeCredito.tipoCuitPais = facturaACancelar.tipoCuitPais
			notaDeCredito.moneda = facturaACancelar.moneda
			afipService.obtenerCaeFacturaExportacion(notaDeCredito)
		}
		else
			afipService.obtenerCaeFactura(notaDeCredito)

		return notaDeCredito

	}

	def saveFacturaVentaApp(Double monto, Long appId, Long cuentaId, Double monto2, LocalDate fechaInicio, LocalDate fechaFin){
		def facturaVentaInstance = new FacturaVenta()
		Cuenta cuenta = Cuenta.get(cuentaId)

		App appAFacturar = App.get(appId)
		boolean esRappi = appAFacturar.nombre == "Rappi"

		facturaVentaInstance.cuenta = cuenta
		facturaVentaInstance.tipoComprobante = TipoComprobante.findByNombre("Factura C")

		def puntoVentaNumero = afipService.getPuntosDeVenta(cuentaId)?.first()
		PuntoVenta puntoVenta = PuntoVenta.findByCuentaAndNumero(cuenta,puntoVentaNumero)
		if (!puntoVenta){
			puntoVenta = new PuntoVenta()
			puntoVenta.cuenta = cuenta
			puntoVenta.numero = puntoVentaNumero
			puntoVenta.save(flush:true,failOnError:true)
		}
		facturaVentaInstance.puntoVenta = puntoVenta

		facturaVentaInstance.numero = new Long(afipService.getProximoNumero(puntoVenta.numero,facturaVentaInstance.tipoComprobante.id))

		facturaVentaInstance.fecha = new LocalDate()
		facturaVentaInstance.neto = 0
		facturaVentaInstance.iva = new Double(0)
		facturaVentaInstance.total = 0
		
		
		facturaVentaInstance.fechaInicioServicios = fechaInicio
		facturaVentaInstance.fechaFinServicios = fechaFin

		facturaVentaInstance.fechaVencimientoPagoServicio = new LocalDate()

		facturaVentaInstance.cliente = appAFacturar.persona

		facturaVentaInstance.concepto = TipoConcepto.findByNombre("Servicio")

		def itemFactura = new ItemFactura()
		itemFactura.precioUnitario = monto
		itemFactura.cantidad = 1
		itemFactura.alicuota = AlicuotaIva.findByCaption("0%")

		String nombreServicio = "Servicio Logístico" + (esRappi ? " delivery Rappi" : '')

		ConceptoFacturaVenta concepto = ConceptoFacturaVenta.findByNombreAndCuenta(nombreServicio,cuenta)
		if (!concepto) {
			concepto = new ConceptoFacturaVenta()
			concepto.nombre = nombreServicio
			concepto.cuenta = cuenta
			concepto.save(flush:true, failOnError:true)
		}
		itemFactura.concepto = concepto
		if (monto){
			facturaVentaInstance.addToItemsFactura(itemFactura)

			facturaVentaInstance.netoGravado+=itemFactura.neto
			facturaVentaInstance.netoGravado0+=itemFactura.neto
			facturaVentaInstance.iva0+=itemFactura.iva
			facturaVentaInstance.neto += monto
			facturaVentaInstance.total += monto
		}

		if (!esRappi && monto2){
			itemFactura = new ItemFactura()
			itemFactura.precioUnitario = monto2
			itemFactura.cantidad = 1
			itemFactura.alicuota = AlicuotaIva.findByCaption("0%")

			nombreServicio = "Exhibición de material publicitario"

			concepto = ConceptoFacturaVenta.findByNombreAndCuenta(nombreServicio,cuenta)
			if (!concepto) {
				concepto = new ConceptoFacturaVenta()
				concepto.nombre = nombreServicio
				concepto.cuenta = cuenta
				concepto.save(flush:true, failOnError:true)
			}
			itemFactura.concepto = concepto
			facturaVentaInstance.addToItemsFactura(itemFactura)

			facturaVentaInstance.netoGravado+=itemFactura.neto
			facturaVentaInstance.netoGravado0+=itemFactura.neto
			facturaVentaInstance.iva0+=itemFactura.iva
			facturaVentaInstance.neto += monto2
			facturaVentaInstance.total += monto2
		} 

		facturaVentaInstance.bienImportado=true

		facturaVentaInstance.save(flush:true, failOnError:true)
		
		afipService.obtenerCaeFactura(facturaVentaInstance)

		return facturaVentaInstance
	}

	def getPuntoVentaApp(Cuenta cuenta){
		PuntoVenta puntoVenta = PuntoVenta.findByCuentaAndNumero(cuenta,7)
		if (!puntoVenta){
			puntoVenta = new PuntoVenta()
			puntoVenta.cuenta=cuenta
			puntoVenta.numero=7
			puntoVenta.save(flush:true)
		}
		return puntoVenta
	}
	
	def updateFacturaVenta(FacturaVentaCommand command){
		def facturaVentaInstance = FacturaVenta.get(command.facturaVentaId)
		
		if (command.version != null) {
			if (facturaVentaInstance.version > command.version) {
				FacturaVentaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["FacturaVenta"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la factura")
				throw new ValidationException("Error de versión", FacturaVentaCommand.errors)
			}
		}
		
		//Pongo los totales de la sumatoria en 0, para que el conteo se realice correctamente en la función:
			facturaVentaInstance.netoNoGravado=0
			facturaVentaInstance.exento=0
			facturaVentaInstance.netoGravado=0
			facturaVentaInstance.netoGravado27=0
			facturaVentaInstance.netoGravado21=0
			facturaVentaInstance.netoGravado10=0
			facturaVentaInstance.netoGravado5=0
			facturaVentaInstance.netoGravado2=0
			facturaVentaInstance.netoGravado0=0
			facturaVentaInstance.importeOtrosTributos=0
			facturaVentaInstance.iva27=0
			facturaVentaInstance.iva21=0
			facturaVentaInstance.iva10=0
			facturaVentaInstance.iva5=0
			facturaVentaInstance.iva2=0
			facturaVentaInstance.iva0=0
		facturaVentaInstance.itemsFactura.clear() //Si existían items antes, los borro 
		return copiarDatos(command, facturaVentaInstance)
	}
	
	def getCantidadFacturaVentasTotales(){
		return FacturaVenta.count()
	}

	def listItems(Long facturaId){
		return FacturaVenta.get(facturaId).itemsFactura
	}

	def copiarDatos (origen, destino, Boolean origenCommand=true){
			
			def cuit
		//Datos planos:
			destino.fecha = origen.fecha
			destino.numero = origen.numero
			destino.neto = origen.neto
			destino.iva = origen.iva
			destino.total = origen.total
			destino.fechaInicioServicios = origen.fechaInicioServicios
			destino.fechaFinServicios = origen.fechaFinServicios
			destino.fechaVencimientoPagoServicio = origen.fechaVencimientoPagoServicio
		//Datos con ID
			if (origenCommand) {
				destino.cuenta = Cuenta.get(origen.cuentaId)
				destino.cliente = Persona.get(origen.clienteId)
				destino.tipoComprobante = TipoComprobante.get(origen.tipoId)
				destino.concepto = TipoConcepto.get(origen.conceptoId)
				// destino.puntoVenta = PuntoVenta.get(origen.puntoVentaId)
				destino.bienImportado=true
				cuit = Cuenta.get(origen.cuentaId).cuit
			}else{
				destino.cuentaId = origen.cuenta.id
				destino.clienteId = origen.cliente.id
				destino.tipoId = origen.tipoComprobante.id
				destino.conceptoId = origen.concepto.id
				// destino.puntoVentaId = origen.puntoVenta.id
				destino.facturaVentaId = origen.id
				destino.version = origen.version
				cuit = origen.cuenta.cuit
			}
			def tipoComprobante = TipoComprobante.get(origen.tipoId)
			if(tipoComprobante.letra == "E"){
				destino.cuitPais = PaisCuit.get(origen.paisCuitId)
				destino.codigoPais = PaisCodigo.get(origen.paisCodigoId)
				destino.tipoCuitPais = origen.tipoCuitPais
				destino.idioma = Idioma.get(origen.idiomaId)
				def moneda = Moneda.get(origen.monedaId)
				destino.moneda = moneda
				destino.cotizacionMoneda = afipService.obtenerCotizacionMoneda("<Mon_id>"+moneda.codigoAfip+"</Mon_id>", cuit.toString())
			}
			if(["201","211"].contains(tipoComprobante.codigoAfip))
				destino.cbuEmisor = origen.cbuEmisor
				
		//JSON de Items
			if (origenCommand && origen.itemsFactura)
				new JsonSlurper().parseText(origen.itemsFactura).each{
					ItemFactura item = new ItemFactura()
						item.precioUnitario = new Double (it.precioUnitario.replaceAll(",","."))
						item.cantidad = new Long(it.cantidad)
						item.alicuota = AlicuotaIva.get(it.ivaId)
						ConceptoFacturaVenta concepto = ConceptoFacturaVenta.findByNombreAndCuenta(it.detalle,destino.cuenta)
						if (!concepto) {
							concepto = new ConceptoFacturaVenta()
							concepto.nombre = it.detalle
							concepto.cuenta = destino.cuenta
							concepto.save(flush:true, failOnError:true)
						}
						item.concepto = concepto
					destino.addToItemsFactura(item)

					//Se hacen las sumatorias de los subtotales en cada categoría de IVA. Se asume que estas vienen en 0 porque se inicializan en el domain (si es edit, antes de llamar a la función se las debe reiniciar)
					switch(item.alicuota.caption){
						case "0%":
							destino.netoGravado+=item.neto
							destino.netoGravado0+=item.neto
							destino.iva0+=item.iva
							break;
						case "10.5%":
							destino.netoGravado+=item.neto
							destino.netoGravado10+=item.neto
							destino.iva10+=item.iva
							break;
						case "2.5%":
							destino.netoGravado+=item.neto
							destino.netoGravado2+=item.neto
							destino.iva2+=item.iva
							break;
						case "21%":
							destino.netoGravado+=item.neto
							destino.netoGravado21+=item.neto
							destino.iva21+=item.iva
							break;
						case "27%":
							destino.netoGravado+=item.neto
							destino.netoGravado27+=item.neto
							destino.iva27+=item.iva
							break;
						case "5%":
							destino.netoGravado+=item.neto
							destino.netoGravado5+=item.neto
							destino.iva5+=item.iva
							break;
						case "Exento":
							destino.exento+=item.neto
							break;
						case "No gravado":
							destino.netoNoGravado+=item.neto
							break;
					}
				}

		if (origenCommand)
			destino.save(flush:true, failOnError:true)
		
		return destino
	}

	def listIdiomas() {
		return Idioma.list()
	}

	def listMonedas() {
		return Moneda.list()
	}

	def listPaises() {
		return PaisCodigo.list()
	}

	def listCuitPaises(){
		return PaisCuit.list()
	}

	def obtenerFacturacionAnual(Long cuentaId, Integer ano){
		def salida = []
		Double monto
		def facturas = FacturaVenta.createCriteria().list() {
				and{
					eq('cuenta', Cuenta.get(cuentaId))
					ge('fecha', new LocalDate(ano,1,1))
					lt('fecha', new LocalDate((ano+1),1,1))
				}
			}
		for(mes in 1..12) {
			def mensuales = facturas.findAll{it.fecha.monthOfYear == mes}
			monto = mensuales?.sum{it.totalReal} ?: 0
			def item = [:]
			item.mes = mes.toString().padLeft(2,'0')
			item.cantidad = mensuales.size()
			item.ventaTotal = formatear(monto)
			String link = grailsLinkGenerator.link(controller: 'facturaVenta', action: 'list', absolute: false, params:[ano: ano, mes: item.mes, cuentaId: cuentaId])
			item.link = "<a href='$link' target='_blank'>Ver lista</a>"
			salida << item
		}
		return salida
	}
}