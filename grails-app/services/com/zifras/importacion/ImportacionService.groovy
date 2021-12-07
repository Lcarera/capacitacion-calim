package com.zifras.importacion

import com.zifras.AccessRulesService
import com.zifras.BitrixService
import com.zifras.Contador
import com.zifras.Estado
import com.zifras.Provincia
import com.zifras.Role
import com.zifras.User
import com.zifras.UserRole
import com.zifras.UsuarioService

import com.zifras.afip.AfipService
import com.zifras.app.App
import com.zifras.app.ItemApp

import com.zifras.cuenta.Actividad
import com.zifras.cuenta.AlicuotaProvinciaActividadIIBB
import com.zifras.cuenta.ClienteProveedor
import com.zifras.cuenta.CondicionIva
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.cuenta.Local
import com.zifras.cuenta.MovimientoCuenta
import com.zifras.cuenta.ObraSocial
import com.zifras.cuenta.RegimenIibb

import com.zifras.debito.DebitoAutomaticoService

import com.zifras.documento.Comprobante
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.PagoCuenta
import com.zifras.documento.PagoCuentaService
import com.zifras.documento.TipoVep
import com.zifras.documento.Vep
import com.zifras.documento.VepService
import com.zifras.documento.ArchivoConvenio

import com.zifras.facturacion.FacturaCompra
import com.zifras.facturacion.FacturaVenta
import com.zifras.facturacion.Persona
import com.zifras.facturacion.Proforma
import com.zifras.facturacion.PuntoVenta
import com.zifras.facturacion.TipoComprobante
import com.zifras.facturacion.TipoConcepto

import com.zifras.liquidacion.LiquidacionIIBB
import com.zifras.liquidacion.LiquidacionIIBBService
import com.zifras.liquidacion.LiquidacionIva
import com.zifras.liquidacion.LiquidacionIvaCommand
import com.zifras.liquidacion.LiquidacionIvaService
import com.zifras.liquidacion.RetencionPercepcionIIBB
import com.zifras.liquidacion.RetencionPercepcionIva

import com.zifras.notificacion.NotificacionService
import com.zifras.notificacion.NotificacionTemplate

import com.zifras.pedidosYa.PedidosYaService

import com.zifras.servicio.ServicioService

import static com.zifras.inicializacion.JsonInicializacion.formatear

import grails.transaction.Transactional
import grails.validation.ValidationException
import java.io.File
import java.util.Calendar
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.ss.usermodel.Cell
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.LocalTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import static org.apache.poi.ss.usermodel.Cell.*

@Transactional
class ImportacionService {
	AccessRulesService accessRulesService
	def afipService
	def bitrixService
	def cuentaService
	def debitoAutomaticoService
	def grailsApplication
	def liquidacionIIBBService
	def liquidacionIvaService
	def notificacionService
	def pagoCuentaService
	def pedidosYaService
	def servicioService
	def vepService

	def listImportacionesFactura(String filter) {
		def lista
		if(filter!=null){
			lista = LogImportacion.createCriteria().list() {
				and{
					ilike('cuenta', '%' + filter + '%')
					order('cuenta', 'asc')
				}
			}
		}else{
			lista = LogImportacion.list(sort:'cuenta')
		}

		return lista
	}

	private obtenerExcel(archivo, Boolean errorEsAssertion){
		InputStream targetStream
		String nombre
		try {
			targetStream = archivo.getInputStream()
			nombre = archivo.getOriginalFilename()
		}
		catch(Exception e) {
			targetStream = new FileInputStream(archivo);
			nombre = archivo.name
		}
		
		switch (nombre.substring(nombre.lastIndexOf(".") + 1,
				nombre.length())) {
			case "xls":
				println "Detectamos que es la versión de excel vieja."
				return new HSSFWorkbook(targetStream).getSheetAt(0)
			case "xlsx":
				println "Detectamos que es la versión de excel nueva."
				return new XSSFWorkbook(targetStream).getSheetAt(0)
			default:
				if (errorEsAssertion)
					assert false : "El archivo ingresado no es un Excel.finerror"
				else
					throw new Exception("formato")
		}
	}

	def importacionMasivaFacturas(archivos, Long cuentaId, Boolean compraString, Boolean liquidarAutomaticamente){
		//Se definen los estados que se usarán a lo largo de la función:
			Estado estadoActivo = Estado.findByNombre('Activo')
			// Estado estadoSinLiquidar = Estado.findByNombre('Sin liquidar')
			// def estadosLiquidados = [ Estado.findByNombre('Liquidado'), Estado.findByNombre('Liquidado A') , Estado.findByNombre('Liquidado A2')]
			Estado estadoError = Estado.findByNombre("Error")
			Persona personaConsumidorFinal = Persona.findByRazonSocial("Consumidor Final")

		if (!(archivos instanceof Collection)){ //Como se detectó un sólo elemento, se lo convierte en un array consigo mismo como única posición
			println "Recibimos un sólo archivo y lo pasamos a array."
			def elemento = archivos
			archivos = null
			archivos = []
			archivos << elemento
		}
		def listaLogs = []
		def cuentasActivas
		Cuenta cuenta
		def tiposComprobantes = TipoComprobante.list()
		if (cuentaId)
			cuenta = Cuenta.get(cuentaId)
		else
			cuentasActivas = Cuenta.findAllByEstado(estadoActivo)
		if (compraString != null && (!cuenta || cuenta.estado.id != estadoActivo.id))
			throw new Exception("cuenta")
		TipoComprobante facturaC = TipoComprobante.findByNombre('Factura C')
		def responsable = (accessRulesService.currentUser?.username ?: "-")
		TipoConcepto conceptoProducto = TipoConcepto.findByNombre("Producto")
		DateTimeFormatter formatter = DateTimeFormat.forPattern("dd/MM/yyyy");
		def cantArchivos = archivos.size()
		def archivoActual = 1
		archivos.each{
			String nombreArchivo
			try {
				nombreArchivo = it.getOriginalFilename()
			}
			catch(Exception e) {
				nombreArchivo = it.name
			}
			
			LocalDate fechaFacturaRepetida = new LocalDate().withDayOfMonth(1).minusMonths(1)
			println """
			Procesando archivo ${archivoActual} de ${cantArchivos}."""

			try {
				def nombre = nombreArchivo.split()
				println "Nombre del archivo: " + nombreArchivo
				boolean compra = (compraString != null)? compraString : (nombre[2]=="Recibidos")
				println "Detectamos que es una factura de ${compra ? 'compra' : 'venta'}."
				if (!cuentaId)
					cuenta = cuentasActivas.find { it.cuit == (nombre[5]).split("\\.")[0] }
				println "Detectamos que pertenece a la cuenta " + cuenta.toString()
				if (cuenta){
					try {
						//Algoritmo de importación:
							def sheet = obtenerExcel(it,false)

							def fecha
							String tipo
							String[] tipoParte
							TipoComprobante tipoComprobante
							def puntoVenta
							def numero
							def tipoDocumento
							def cuit
							def razonSocial
							def netoGravado
							def multiplicadorMoneda
							def netoNoGravado
							def exento
							def iva
							def total
							def factura
							Persona persona

							def facturas = []

							LogImportacion logImportaciones = new LogImportacion()
							logImportaciones.nombreArchivo = nombreArchivo
							logImportaciones.detalle = null
							logImportaciones.fechaHora = new LocalDateTime()
							logImportaciones.responsable = responsable
							logImportaciones.estado = estadoActivo
							logImportaciones.fecha = new LocalDate()
							boolean cambiarFecha = true //Antes la condición era si fecha==null, pero eso ya no funciona
							if (compra)
								logImportaciones.compra = true
							else
								logImportaciones.venta = true
							logImportaciones.cuenta = cuenta
							logImportaciones.save(flush:true)

							int numeroFila = 0
							def puntosDeVenta = cuenta.puntosDeVenta
							for (fila in sheet.rowIterator()) {
								if (numeroFila >= 2){
									if (fila.getCell(0))
										fecha = fila.getCell(0).getStringCellValue()
									else{
										println "Se ignoró el registro ${numeroFila} porque el campo 'fecha' está vacío."
										continue
									}

									if (fila.getCell(1))
										tipo = fila.getCell(1).getStringCellValue()
									else{
										println "Se ignoró el registro ${numeroFila} porque el campo 'tipo' está vacío."
										continue
									}

									cuit = fila.getCell(7) ? ((Long) fila.getCell(7).getNumericCellValue()).toString() : ""

									try {
										tipoDocumento = fila.getCell(6)?.getStringCellValue() ?: ""
									}
									catch(Exception e) { // Porque a veces para consumidor final viene 99
										tipoDocumento = ""
										cuit = ""
									}

									razonSocial = fila.getCell(8)? fila.getCell(8).getStringCellValue() : '-'

									multiplicadorMoneda = fila.getCell(9)? fila.getCell(9).getNumericCellValue() : new Double(1.0)

									netoGravado = (fila.getCell(11)? fila.getCell(11).getNumericCellValue() : new Double(0.0)) * multiplicadorMoneda

									puntoVenta = fila.getCell(2)? fila.getCell(2).getNumericCellValue() : new Double(0.0)

									numero = fila.getCell(3)? fila.getCell(3).getNumericCellValue() : new Double(0.0)

									netoNoGravado = (fila.getCell(12)? fila.getCell(12).getNumericCellValue() : new Double(0.0)) * multiplicadorMoneda

									exento = (fila.getCell(13)? fila.getCell(13).getNumericCellValue() : new Double(0.0)) * multiplicadorMoneda

									iva = (fila.getCell(14)? fila.getCell(14).getNumericCellValue() : new Double(0.0)) * multiplicadorMoneda

									total = (fila.getCell(15)? fila.getCell(15).getNumericCellValue() : new Double(0.0)) * multiplicadorMoneda

									if (cuit){
										persona = Persona.findByCuit(cuit)
										if (persona == null){
											persona = new Persona()
											persona.tipoDocumento = tipoDocumento?: "DNI"
											persona.razonSocial = razonSocial
											persona.cuit = cuit
											if (cuenta.regimenIibb.nombre != "Convenio Multilateral") // Para no savear dos veces seguidas
												persona.save(flush:true, failOnError:true)
										}
										if (cuenta.regimenIibb.nombre == "Convenio Multilateral" && ! persona.provincia){
											try {
												def datosAfip = afipService.obtenerDatosProveedor(persona.cuit)
												persona.domicilio = datosAfip.domicilio
												persona.condicionIva = CondicionIva.get(datosAfip.condicionIvaId)
												persona.provincia = datosAfip.provincia
											}
											catch(Exception errorProvincia) {
												log.error("No pudo guardarse provincia en proveedor (${cuit})")
												println errorProvincia.message
												// println errorProvincia.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
											}
											persona.save(flush:true, failOnError:true)
										}
									}
									else
										persona = personaConsumidorFinal

									tipoParte = tipo.split(" - ")
									tipoComprobante = tiposComprobantes.find{it.codigoAfip == tipoParte[0]}
									if (tipoComprobante==null){
										tipoComprobante = new TipoComprobante()
										tipoComprobante.nombre=tipoParte[1]
										tipoComprobante.letra=tipoComprobante.nombre[-1]
										tipoComprobante.codigoAfip=tipoParte[0]
										tipoComprobante.save(flush:true, failOnError:true)
										logImportaciones.nuevosTiposComprobantes++
										tiposComprobantes << tipoComprobante
									}

									if (compra)
										factura = new FacturaCompra()
									else{
										factura = new FacturaVenta()
										def puntoVentaNro=puntoVenta
										puntoVenta = null // Para limpiarlo, porque cambia el tipo de dato
										puntoVenta = puntosDeVenta.find{it.numero == puntoVentaNro}
										if (! puntoVenta){
											puntoVenta = new PuntoVenta(numero:puntoVentaNro, cuenta:cuenta).save(flush:true)
											puntosDeVenta << puntoVenta
										}
									}
									factura.fecha = formatter.parseLocalDate(fecha)

									factura.tipoComprobante=tipoComprobante

									factura.puntoVenta=puntoVenta
									factura.numero=numero
									factura.netoNoGravado=netoNoGravado
									factura.netoGravado=netoGravado
									if(!compra)
										factura.neto = netoGravado+netoNoGravado+exento
									else{
										factura.percepcionImportada = (new Double(total - netoGravado - netoNoGravado - exento - iva)).round(2)
										if(factura.percepcionImportada < 0)
											factura.percepcionImportada = 0
									}

									factura.exento=exento
									factura.total=total
									factura.iva=iva
									factura.cuenta=cuenta

									if( factura.tipoComprobante == facturaC ){
										factura.iva21=0
										factura.iva10=0
										factura.iva27=0
										factura.netoGravado21=0
										factura.netoGravado10=0
										factura.netoGravado27=0
										factura.netoNoGravado=total
										factura.bienImportado=true
									}else if ((netoGravado > 0) && (iva==0)){
										//Se trata de una factura B
										factura.iva21=0
										factura.iva10=0
										factura.iva27=0
										factura.netoGravado21=0
										factura.netoGravado10=0
										factura.netoGravado27=0
										//El netoGravado en el caso de factura B viene lleno, pero el IVA viene en 0
										//para no generar una inconsistencia en el cálculo del IVA, se deja el netoGravado=0
										//y se incrementa el netoNoGravado con el netoGravado
										factura.netoNoGravado+=netoGravado
										factura.bienImportado=true
									}else if (((netoGravado*0.21 - 1) <= iva) && (iva <= (netoGravado*0.21 + 1))){
										//Se trata de una factura A con IVA al 21% (con un margen de error de +- $1
										factura.iva21=iva
										factura.iva10=0
										factura.iva27=0
										factura.netoGravado21=netoGravado
										factura.netoGravado10=0
										factura.netoGravado27=0
										factura.bienImportado=true
									}else if (((netoGravado*0.105 - 1) <= iva) && (iva <= (netoGravado*0.105 + 1))){
										//Se trata de una factura A con IVA al 10,5% (con un margen de error de +- $1
										factura.iva21=0
										factura.iva10=iva
										factura.iva27=0
										factura.netoGravado21=0
										factura.netoGravado10=	netoGravado
										factura.netoGravado27=0
										factura.bienImportado=true
									}else if (((netoGravado*0.27 - 1) <= iva) && (iva <= (netoGravado*0.27 + 1))){
										//Se trata de una factura A con IVA al 27% (con un margen de error de +- $1
										factura.iva21=0
										factura.iva10=0
										factura.iva27=iva
										factura.netoGravado21=0
										factura.netoGravado10=0
										factura.netoGravado27=netoGravado
										factura.bienImportado=true
									}else if (((netoGravado*0.105 - 1) < iva) && (iva < (netoGravado*0.21 + 1))){
										//Se trata de una factura A con combinacion de IVA al 10,5% y IVA al 21%
										def iva10temp = 0
										def iva21temp = 0
										def ivaTotalTemp = 0
										def neto10temp = 0
										def neto21temp = 0

										neto10temp = ((2*netoGravado)-(iva/0.105)).round(2)
										neto21temp = netoGravado - neto10temp

										iva10temp = (neto10temp * 0.105).round(2)
										iva21temp = (neto21temp * 0.21).round(2)

										ivaTotalTemp = iva10temp + iva21temp

										if(((iva - 1) <= ivaTotalTemp) && (ivaTotalTemp <= (iva + 1))){
											//La suma del IVA21 e IVA10 calculados es igual al IVA original +-1 pesos
											factura.iva21=iva21temp
											factura.iva10=iva10temp
											factura.iva27=0
											factura.netoGravado21=neto21temp
											factura.netoGravado10=neto10temp
											factura.netoGravado27=0
											factura.bienImportado=true
										}else{
											//El calculo da mal, entonces hace lo mismo que al no ser ninguno de los casos anteriores
											println "Detectamos una factura mal en el registro ${numeroFila}."
											factura.iva21=iva
											factura.iva10=0
											factura.iva27=0
											factura.netoGravado21=netoGravado
											factura.netoGravado27=0
											factura.netoGravado10=0
											factura.bienImportado=false
											logImportaciones.cantidadMal++
										}
									}else if (((netoGravado*0.21 - 1) < iva) && (iva < (netoGravado*0.27 + 1))){
										//Se trata de una factura con combinacion de IVA al 27% e IVA al 21%

										def neto27temp = (iva - 0.21*netoGravado) / 0.06
										def neto21temp = netoGravado - neto27temp

										def iva27temp = neto27temp * 0.27
										def iva21temp = neto21temp * 0.21

										def ivaTotalTemp = iva27temp + iva21temp

										if(((iva - 1) <= ivaTotalTemp) && (ivaTotalTemp <= (iva + 1))){
											//La suma del IVA21 e IVA10 calculados es igual al IVA original +-1 pesos
											factura.iva21=iva21temp
											factura.iva10=0
											factura.iva27=iva27temp
											factura.netoGravado21=neto21temp
											factura.netoGravado10=0
											factura.netoGravado27=neto27temp
											factura.bienImportado=true
										}else{
											//El calculo da mal, entonces hace lo mismo que al no ser ninguno de los casos anteriores
											println "Detectamos una factura mal en el registro ${numeroFila}."
											factura.iva21=iva
											factura.iva10=0
											factura.iva27=0
											factura.netoGravado21=netoGravado
											factura.netoGravado27=0
											factura.netoGravado10=0
											factura.bienImportado=false
											logImportaciones.cantidadMal++
										}
									}else{
										//No es ninguno de los casos anteriores
										println "Detectamos una factura mal en el registro ${numeroFila}."
										factura.iva21=iva
										factura.iva10=0
										factura.iva27=0
										factura.netoGravado21=netoGravado
										factura.netoGravado27=0
										factura.netoGravado10=0
										factura.bienImportado=false
										logImportaciones.cantidadMal++
									}

									//if (((netoGravado+netoNoGravado+iva+exento - 1) <= total) && (total <= (netoGravado+netoNoGravado+iva+exento + 1))) {
										//factura.bienImportado=false
										//logImportaciones.cantidadFacturasMal++
									//} 


									ClienteProveedor clienteProveedor = cuenta.clientesProveedores.find{it.persona == persona}
									if (!clienteProveedor){
										clienteProveedor = new ClienteProveedor(persona:persona)
										cuenta.addToClientesProveedores(clienteProveedor).save(flush:true)
									}

									if (clienteProveedor.proveedor!=true && compra) { //Por si antes era un cliente, entonces no tendría true.
										clienteProveedor.proveedor=true
										logImportaciones.nuevasPersonas++
										clienteProveedor.save(flush: true, failOnError:true) 
									}
									if (clienteProveedor.cliente!=true && !compra) { //Por si antes era un proveedor, entonces no tendría true.
										clienteProveedor.cliente=true
										logImportaciones.nuevasPersonas++
										clienteProveedor.save(flush: true, failOnError:true) 
									}

									if(compra)
										factura.proveedor = persona
									else{
										factura.cliente = persona
										//Datos not-null de FacturaVenta que no están incluidos en el excel
										factura.ventaTabaco=false
										factura.monedaExtranjera=false
										factura.concepto= conceptoProducto
										factura.netoGravado0 = 0
										factura.iva0 = 0
										factura.importeOtrosTributos = 0
									}

									if (factura.bienImportado)
										logImportaciones.cantidadOk++

									//estas no importa si es de compra o venta, las inicializa en 0
									factura.netoGravado5 = 0
									factura.netoGravado2 = 0
									factura.iva5 = 0
									factura.iva2 = 0

									factura.importado = true
									factura.logImportacion = logImportaciones
									try {
										factura.save(flush: false, failOnError:true) 
										facturas.push(factura)
									}
									catch(Exception e) {
										logImportaciones.cantidadIgnoradas++
										if (factura.bienImportado)
											logImportaciones.cantidadOk--
										println "Ignoramos una factura repetida en el registro $numeroFila"
									}

									if(cambiarFecha){
										logImportaciones.fecha= factura.fecha.withDayOfMonth(1)
										fechaFacturaRepetida = logImportaciones.fecha
										cambiarFecha = false
									}
									if (logImportaciones.detalle==null) {
										if (compra)
											logImportaciones.detalle = ("Se importaron correctamente las compras del periodo de " + logImportaciones.fecha.toString("MMMM") + " para la cuenta " + cuenta.toString())
										else
											logImportaciones.detalle = ("Se importaron correctamente las ventas del periodo de " + logImportaciones.fecha.toString("MMMM") + " para la cuenta " + cuenta.toString())
									}
								}
								numeroFila++
							}
							println """Terminamos de parsear el archivo."""
							/*if (cuenta.condicionIva.nombre == "Responsable inscripto"){
								println "La cuenta pertenece a un responsable inscripto, así que asignaremos las facturas a su liquidación de IVA."
								LiquidacionIva liquidacion = LiquidacionIva.findByCuentaAndFecha(cuenta, logImportaciones.fecha)
								if (liquidacion==null){
									LiquidacionIvaCommand liqCommand = new LiquidacionIvaCommand()
									liqCommand.nota = 'Facturas importadas'
									liqCommand.cuentaId = cuenta.id
									liqCommand.ano = logImportaciones.fecha.toString("YYYY")
									liqCommand.mes = logImportaciones.fecha.toString("MM")
									liquidacion = liquidacionIvaService.updateNota(liqCommand)
									liquidacion.estado = globalEstadoSinLiquidar
								}
								if (! globalEstadosLiquidados.find {(it.id == liquidacion.estado.id)})
									if (compra)
										liquidacion.facturasCompraImportadas = true
									else
										liquidacion.facturasVentaImportadas = true
								else
									liquidacion.importacionPosterior = true
								liquidacion.save(flush:false, failOnError:true)
							}*/

							if (facturas){
								println "Se terminaron todas las operaciones del archivo, se realizan los saves."
								/*facturas.each{
									if (compra)
										logImportaciones.addToFacturasCompra(it)
									else
										logImportaciones.addToFacturasVenta(it)
								}*/
							}else{
								// println "El archivo está vacío, pero lo guardamos igual."
								// logImportaciones.estado = estadoError
								logImportaciones.fecha = fechaFacturaRepetida
								logImportaciones.detalle = "No se detectaron facturas nuevas"
							}
							logImportaciones.total = logImportaciones.cantidadOk + logImportaciones.cantidadMal
							cuenta.addToLogs(logImportaciones).save(flush:false, failOnError: true)
							logImportaciones.save(flush:true, failOnError:true)
							if(cuenta.tenantId == 2 && liquidarAutomaticamente){
								println "Se liquida automáticamente."
								liquidacionIvaService.liquidacionAutomatica(logImportaciones.fecha.toString("MM"), logImportaciones.fecha.toString("YYYY"), cuenta.id)
								liquidacionIIBBService.liquidacionAutomatica(logImportaciones.fecha.toString("MM"), logImportaciones.fecha.toString("YYYY"), cuenta.id)
							}
							listaLogs.push(logImportaciones)
							println ""
							archivoActual++
					}
					catch(Exception e) {
						println """Error en el archivo ${archivoActual}:


						""" + e + "\n" + e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n") + """


						"""
						archivoActual++
						LogImportacion fallado = new LogImportacion()
						fallado.nombreArchivo = nombreArchivo
						fallado.compra = compra
						fallado.venta = !compra
						fallado.detalle= "La importación falló por un error de archivo."
						fallado.estado = estadoError
						listaLogs.push(fallado)
					}
				}else
					throw new Exception("No cuenta")
			}
			catch(Exception e) {
				println "Error en el archivo ${archivoActual}: no se detectó cuenta."
				archivoActual++
				LogImportacion fallado = new LogImportacion()
				fallado.nombreArchivo = nombreArchivo
				fallado.detalle= "Cuenta no encontrada o nombre de archivo inválido."
				fallado.estado = estadoError
				listaLogs.push(fallado)
			}
		}
		return listaLogs
	}

	def importacionMasivaVeps(archivo, LocalDate vencimientoReal = null){
		def salida = [:]
		salida['periodo'] = ''
		salida['cuenta'] = ''
		salida['local'] = ''
		salida['descripcion'] = ''
		salida['tipo'] = ''
		salida['archivo'] = ''
		salida['estado'] = 'Error'
		try {
			salida['archivo'] = archivo.getOriginalFilename()
			def nombreParte = salida['archivo'].split("_")
			LocalDate fecha = new LocalDate(salida['archivo'][0..3] + "-" + salida['archivo'][4..5] + "-01")
			salida['periodo'] = fecha.toString("dd/MM/yyyy")
			
			String cuitCuenta
			String vepNro
			String descripcionSimpl
			TipoVep tipoVep
			if (salida['archivo'].contains("syh")){
				tipoVep = TipoVep.findByNombre("Seguridad e Higiene")
				cuitCuenta = nombreParte[2]
			}
			else if (salida['archivo'].contains("suss")){
				tipoVep = TipoVep.findByNombre("931")
				cuitCuenta = nombreParte[2]
				vepNro = nombreParte[4].split("\\.")[0]
			}
			else if (salida['archivo'].contains("monot")){
				tipoVep = TipoVep.findByNombre("Monotributo")
				cuitCuenta = nombreParte[3].split()[0]
			}
			else if (salida['archivo'].contains("sicol") || salida['archivo'].contains("iibb")){
				tipoVep = TipoVep.findByNombre("IIBB")
				cuitCuenta = nombreParte[2].split("\\.")[0].trim()
			}
			else if (salida['archivo'].contains("iva")){
				tipoVep = TipoVep.findByNombre("IVA")
				cuitCuenta = nombreParte[5]
				vepNro = nombreParte[7].split("\\.")[0]
			}
			else if (salida['archivo'].contains("aut")){
				tipoVep = TipoVep.findByNombre("Autonomo")
				cuitCuenta = nombreParte[5]
				vepNro = nombreParte[7].split("\\.")[0]
			}
			else if(salida['archivo'].contains("BOLETAS-SELECCIONADAS") || salida['archivo'].contains("simplificado")){
				tipoVep = TipoVep.findByNombre("Simplificado")
				cuitCuenta = nombreParte[1]
				vepNro = vepService.getNumeroCuota(fecha)
				descripcionSimpl = "Volante de Pago Monotributista Simplificado"
				salida['descripcion'] = descripcionSimpl
			}
			else if(salida['archivo'].contains("unificado")){
				tipoVep = TipoVep.findByNombre("Unificado")
				cuitCuenta = nombreParte[1]
				// vepNro = vepService.getNumeroCuota(fecha)
				salida['descripcion'] = "Volante de Pago Monotributista Unificado"
			}
			salida['tipo'] = tipoVep.nombre // Si es null va a romper, lo cual es la idea.
			Cuenta cuentaLeida = Cuenta.findByCuit(cuitCuenta)

			salida['cuenta'] = cuentaLeida.toString()
			Local localLeido
			if(cuentaLeida.tenantId == 1){
				localLeido = cuentaLeida?.with{
					Local localVacio
					localesActivos?.each{
						Local localActual = it
						if (! Vep.findByLocalAndFechaEmisionAndTipo(localActual, fecha, tipoVep))
							localVacio = localActual
					}
					return localVacio
				}
				assert localLeido
				salida['local'] = localLeido.toString()
			}
			else{
				if(tipoVep.nombre == "Simplificado")
					assert cuentaLeida.regimenIibb?.nombre?.contains("Simplificado") : "La cuenta no pertenece al regimen Monotributo Simplificado"
				else if(tipoVep.nombre == "Unificado")
					assert cuentaLeida.regimenIibb?.nombre == "Unificado" : "La cuenta no pertenece al regimen Monotributo Unificado"
				// assert !Vep.findByCuentaAndFechaEmisionAndTipo(cuentaLeida,fecha,tipoVep) : "Ya existe un volante para este periodo en la cuenta"
			}

			//Guardado de archivo:
			String cuentaPath = cuentaLeida.getPath()
			String pathFC = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/veps/"

			File carpeta = new File(pathFC)
			if(!carpeta.exists())
				carpeta.mkdirs()

			String fullPath = pathFC + salida['archivo']
			int versionArchivo = 0
			while((new File(fullPath)).exists()){
				versionArchivo++
				fullPath = pathFC + salida['archivo'] + " (" + versionArchivo.toString() + ")"
			}
			if (versionArchivo>0)
				salida['archivo'] += " (" + versionArchivo.toString() + ")"
			archivo.transferTo(new File(fullPath))


			def vep = new Vep().with{
				vencimiento = vencimientoReal
				estado = Estado.findByNombre('Activo')
				if (vepNro)
					numero = new Long(vepNro)
				fechaEmision = fecha
				tipo = tipoVep
				nombreArchivo = salida['archivo']
				cuenta = cuentaLeida
				if(localLeido)
					local = localLeido
				else{
					importe = 0 //SE PODRIA DEFINIR EL IMPORTE BIMESTRAL DE MONO SIMPLIFICADO, LO DESCONOZCO ACTUALMENTE
					descripcion = descripcionSimpl
				}
				
				save(flush:true,failOnError:true)
			}
			if (["IVA","IIBB","Intereses"].contains(vep.tipo.nombre)){
				if (vep.tipo.nombre == "IVA"){
					def liquidacion = LiquidacionIva.findByFechaAndCuenta(vep.fechaEmision.withDayOfMonth(1), vep.cuenta)
					if (liquidacion){
						def declaracion = liquidacion.declaracion
						println "declaracion: ${declaracion}"
						vep.importe = liquidacion.saldoDdjj
						vep.save(flush:true)
						if (declaracion){
							declaracion.vep = vep
							declaracion.save(flush:true)
						}
					}
				}
				else if (vep.tipo.nombre == "IIBB"){
					Double importe = 0
					LiquidacionIIBB.findAllByFechaAndCuenta(vep.fechaEmision.withDayOfMonth(1), vep.cuenta)?.each{
						importe += it.saldoDdjj
						def declaracion = it.declaracion
						if (declaracion){
							declaracion.vep = vep
							declaracion.save(flush:true)
						}
					}
					vep.importe = importe
					vep.save(flush:true)
				}
				vepService.enviarMailPago(vep)
			}
			else if(tipoVep.nombre == "Simplificado"){
				notificacionService.notificarUsuarioVolanteSimplificado(cuentaLeida.email, cuentaLeida.nombreApellido, vep.vencimiento, "https://app.calim.com.ar/vep/download/${vep.id}")
				salida['periodo'] = vep.periodo
			}
			else if(tipoVep.nombre == "Unificado"){
				LocalDate fechaFinUnif = new LocalDate().withDayOfMonth(20)
				notificacionService.notificarUsuarioVolanteSimplificado(cuentaLeida.email, cuentaLeida.nombreApellido, fechaFinUnif, "https://app.calim.com.ar/vep/download/${vep.id}", true)
				salida['periodo'] = fechaFinUnif
			}
			salida['estado'] = "Ok"
		}
		catch(java.lang.AssertionError e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		catch(e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		return salida
	}

	def importacionMasivaDebitoAutomatico(archivo){

		
		def resultado = []

		Estado pagado = Estado.findByNombre("Pagado")
		/* Declaración de variables */
		def fila, servicio
		Long idFactura, idCliente
		String descripcionMovimiento, codigoMovimiento
		Double importe
		/* Obtengo las listas de facturas en los que buscaré */
		def limiteInferior = new LocalDateTime().minusMonths(1).withDayOfMonth(10)
		def limiteSuperior = new LocalDateTime().withDayOfMonth(11)
		def facturas = FacturaCuenta.createCriteria().list() {
			ge('fechaHora', limiteInferior)
			lt('fechaHora', limiteSuperior)
		}
		/* Empiezo a recorrer el archivo */
		def rows = obtenerExcel(archivo,true).rowIterator()
		//fila = rows.next () // Salteamos la primera línea con los nombres de columnas
		while (rows.hasNext()){
			fila = rows.next()
			
			idFactura = (Long) (fila.getCell(1).getNumericCellValue())
			idCliente = (Long) (fila.getCell(3).getNumericCellValue())
			descripcionMovimiento = fila.getCell(5).getStringCellValue()
			codigoMovimiento = fila.getCell(4).getStringCellValue()
			FacturaCuenta facturaAPagar
			def cuenta
			facturaAPagar = facturas.find{it.id == idFactura}
			cuenta = Cuenta.get(idCliente)
			if(facturaAPagar && cuenta){ 
				if(codigoMovimiento == "000"){	//codigo para transacciones aceptadas
					pagoCuentaService.savePagoCuentaManual([facturaAPagar.movimiento], "Débito automático")
					debitoAutomaticoService.procesarDebitoAutomatico(idFactura,true,descripcionMovimiento)
				}
				else{
					debitoAutomaticoService.procesarDebitoAutomatico(idFactura,false,descripcionMovimiento)
				}
			}else
				log.error("El id de factura o cliente recibido no existe")

			def salida = [:]
			salida['cuenta'] = fila.getCell(3).getNumericCellValue()
			salida['factura'] = fila.getCell(1).getNumericCellValue()
			salida['importe'] = fila.getCell(2).getNumericCellValue()
			salida['pagado'] = fila.getCell(4).getStringCellValue() == "000"
			salida['detalleCobro'] = descripcionMovimiento

		resultado << salida
		}
		return resultado
		}

	def importacionProformas(archivo, String fechaInicio){
		LocalDate fechaSeleccionada = DateTimeFormat.forPattern("dd/MM/yyyy").parseLocalDate(fechaInicio)
		def resultado = [:]
		resultado['fallidos'] = []
		resultado['exitos'] = []
		/* Declaración de variables */
		def fila, servicio
		Long idRider
		Double importe

		/* Empiezo a recorrer el archivo */
		def rows = obtenerExcel(archivo,true).rowIterator()
		Boolean error
		//fila = rows.next () // Salteamos la primera línea con los nombres de columnas
		while (rows.hasNext()){
			error = false
			fila = rows.next()

			try{
				idRider = (Long) (fila.getCell(0).getNumericCellValue())
			}
			catch(e){
				if(fila.getCell(0) != null)
					idRider = new Long((fila.getCell(0).getStringCellValue()))
				else
					error = true
			}
			try{
				importe = (Double) (fila.getCell(1).getNumericCellValue())
			}
			catch(e){
				if(fila.getCell(1) != null)
					importe = new Double((fila.getCell(1).getStringCellValue()))
				else
					error = true
			}

			if(!error){
				def cuenta = Cuenta.findByRiderId(idRider)
				def fecha = pedidosYaService.primerDiaSemana(fechaSeleccionada) 

				Proforma proforma = Proforma.findByRiderIdAndFecha(idRider,fecha)
				def item = [:]
				if(proforma != null && proforma.estado != Proforma.Estados.VERIFICADA){
					if(proforma.importe != importe){
						proforma.importe = importe
						proforma.estado = Proforma.Estados.NUEVA
					}
				}
				else{
					proforma = new Proforma()
					proforma.riderId = idRider
					proforma.importe = importe
					proforma.cuenta = cuenta
					proforma.estado = Proforma.Estados.NUEVA
					proforma.cuit = cuenta?.cuit
					proforma.fecha = fecha
				}
				try{
					proforma.save(flush:true, failOnError:true)
					item['cuit'] = proforma.cuit
					item['estado'] = proforma.estado.toString()
					resultado['exitos'] << item
				}
				catch(e){
					item['error'] = "El rider todavía no posee cuenta Calim"
					resultado['fallidos'] << item
				}
				item['riderId'] = idRider
				item['importe'] = '$ ' + formatear(proforma.importe)
			}
		}
		return resultado
	}

	def importacionObrasSociales(archivo){
		def resultado = [:]
		resultado['fallidos'] = []
		resultado['exitos'] = []
		/* Declaración de variables */
		def fila, servicio
		String idRnos
		String nombre
		String sigla

		/* Empiezo a recorrer el archivo */
		def rows = obtenerExcel(archivo,true).rowIterator()
		def error
		fila = rows.next()
		fila = rows.next()
		fila = rows.next()
		//fila = rows.next () // Salteamos la primera línea con los nombres de columnas
		while (rows.hasNext()){

			error = false
			fila = rows.next()
			
			try{
				idRnos = ((Integer) (fila.getCell(0).getNumericCellValue())).toString()
				nombre = fila.getCell(1).getStringCellValue()
				sigla =  fila.getCell(2).getStringCellValue()
			}
			catch(e){
				error = true
				println e
			}
			println error
			if(!error){
				ObraSocial obra = ObraSocial.findByCodigo(idRnos)
				if(!obra){
					obra = new ObraSocial()
					obra.codigo = idRnos
					obra.nombre = nombre
					if(sigla=="                  ") //bug del excel
						sigla = null
					else{
						if(sigla[0]==" ")
							sigla = sigla.substring(1)
					}
					obra.sigla = sigla
					try{
						obra.save(flush:true, failOnError:true)
					}
					catch(e){
						println "Error"
					}
				}
			}
		}
		return resultado
	}

	def importacionActividades(archivos){
		if (!(archivos instanceof Collection)){ //Como se detectó un sólo elemento, se lo convierte en un array consigo mismo como única posición
			def elemento = archivos
			archivos = null
			archivos = []
			archivos << elemento
		}
		def cantArchivos = archivos.size()
		def archivoActual = 1
		archivos.each{
			println """
			Procesando archivo ${archivoActual} de ${cantArchivos}."""

			try {
				String inputFilename = it.getOriginalFilename()
				println "Nombre del archivo: " + inputFilename
				def sheet
				def sheet2
				def sheet3
				switch (inputFilename.substring(inputFilename.lastIndexOf(".") + 1, inputFilename.length())) {
					case "xls":
						sheet = new HSSFWorkbook(it.getInputStream()).getSheetAt(0)
						sheet2 = new HSSFWorkbook(it.getInputStream()).getSheetAt(1)
						sheet3 = new HSSFWorkbook(it.getInputStream()).getSheetAt(2)
						println "Detectamos que es la versión de excel vieja."
						break;
					case "xlsx":
						sheet = new XSSFWorkbook(it.getInputStream()).getSheetAt(0)
						sheet2 = new XSSFWorkbook(it.getInputStream()).getSheetAt(1)
						sheet3 = new XSSFWorkbook(it.getInputStream()).getSheetAt(2)
						println "Detectamos que es la versión de excel nueva."
						break;
					default:
						throw new Exception("formato")
				}

				Integer codigoAfip
				Integer codigoCuacm
				Integer codigoNaes
				String codigoAfipString
				String codigoCuacmString
				String codigoNaesString
				String descripcionAfip
				String descripcionCuacm
				String descripcionNaes

				def actividades = []
				int numeroFila = 0

				for (fila in sheet3.rowIterator()) {
					if (numeroFila >= 2){
						codigoNaes = fila.getCell(0).getNumericCellValue()
						descripcionNaes = fila.getCell(1).getStringCellValue()

						codigoAfip = fila.getCell(2).getNumericCellValue()
						descripcionAfip = fila.getCell(3).getStringCellValue()

						codigoNaesString = codigoNaes.toString()
						while(codigoNaesString.length()!=6){
							codigoNaesString = '0' + codigoNaesString
						}

						codigoAfipString = codigoAfip.toString()
						while(codigoAfipString.length()!=6){
							codigoAfipString = '0' + codigoAfipString
						}

						println codigoNaesString
						println descripcionNaes

						println codigoAfipString
						println descripcionAfip
					}

					def actividad = Actividad.findByCodigo(codigoNaesString)
					if(actividad==null){
						actividad = new Actividad()
						actividad.codigo = codigoNaesString
					}

					actividad.nombre = descripcionNaes
					actividad.codigoNaes = codigoNaesString
					actividad.codigoAfip = codigoAfipString
					actividad.descripcionAfip = descripcionAfip
					actividad.descripcionNaes = descripcionNaes
					actividad.save(flush:true)

					numeroFila++
				}

				numeroFila = 0

				for (fila in sheet2.rowIterator()) {
					if (numeroFila >= 2){
						codigoNaes = fila.getCell(0).getNumericCellValue()
						descripcionNaes = fila.getCell(1).getStringCellValue()

						codigoCuacm = fila.getCell(2).getNumericCellValue()
						descripcionCuacm = fila.getCell(3).getStringCellValue()

						codigoNaesString = codigoNaes.toString()
						while(codigoNaesString.length()!=6){
							codigoNaesString = '0' + codigoNaesString
						}

						codigoCuacmString = codigoCuacm.toString()
						while(codigoCuacmString.length()!=6){
							codigoCuacmString = '0' + codigoCuacmString
						}

						println codigoNaesString
						println descripcionNaes

						println codigoCuacmString
						println descripcionCuacm
					}

					def actividad = Actividad.findByCodigoNaes(codigoNaesString)
					if(actividad==null){
						actividad = new Actividad()
						actividad.codigo = codigoNaesString
						actividad.codigoNaes = codigoNaesString
						actividad.descripcionNaes = descripcionNaes
						actividad.nombre = descripcionNaes
					}

					actividad.codigoCuacm = codigoCuacmString
					actividad.descripcionCuacm = descripcionCuacm
					actividad.save(flush:true)

					numeroFila++
				}

				println """Terminamos de parsear el archivo."""
			} catch(Exception e) {
				println "Error en el archivo ${archivoActual}"
				archivoActual++
			}
		}
		return
	}

	def importacionAlicuotas(archivos){
		if (!(archivos instanceof Collection)){ //Como se detectó un sólo elemento, se lo convierte en un array consigo mismo como única posición
			def elemento = archivos
			archivos = null
			archivos = []
			archivos << elemento
		}
		def cantArchivos = archivos.size()
		def archivoActual = 1
		archivos.each{
			println """
			Procesando archivo ${archivoActual} de ${cantArchivos}."""

			try {
				String inputFilename = it.getOriginalFilename()
				println "Nombre del archivo: " + inputFilename

				def provincia
				if(inputFilename=='alicuotas bs as 2019.xlsx'){
					provincia = Provincia.findByNombre('Buenos Aires')

					def sheet1
					def sheet2
					def sheet3
					def sheet4
					def sheet5

					switch (inputFilename.substring(inputFilename.lastIndexOf(".") + 1, inputFilename.length())) {
						case "xls":
							sheet1 = new HSSFWorkbook(it.getInputStream()).getSheetAt(0)
							sheet2 = new HSSFWorkbook(it.getInputStream()).getSheetAt(1)
							sheet3 = new HSSFWorkbook(it.getInputStream()).getSheetAt(2)
							sheet4 = new HSSFWorkbook(it.getInputStream()).getSheetAt(3)
							sheet5 = new HSSFWorkbook(it.getInputStream()).getSheetAt(4)
							println "Detectamos que es la versión de excel vieja."
							break;
						case "xlsx":
							sheet1 = new XSSFWorkbook(it.getInputStream()).getSheetAt(0)
							sheet2 = new XSSFWorkbook(it.getInputStream()).getSheetAt(1)
							sheet3 = new XSSFWorkbook(it.getInputStream()).getSheetAt(2)
							sheet4 = new XSSFWorkbook(it.getInputStream()).getSheetAt(3)
							sheet5 = new XSSFWorkbook(it.getInputStream()).getSheetAt(4)
							println "Detectamos que es la versión de excel nueva."
							break;
						default:
							throw new Exception("formato")
					}

					Integer codigoAfip
					String codigoAfipString
					Double valor1
					Double valor2
					Double valor3

					int numeroFila = 0

					println 'Pagina 1:'
					for (fila in sheet1.rowIterator()) {
						if (numeroFila >= 1){
							codigoAfip = fila.getCell(0).getNumericCellValue()
							valor1 = fila.getCell(2).getNumericCellValue()
							valor2 = fila.getCell(3).getNumericCellValue()
							valor3 = fila.getCell(4).getNumericCellValue()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
								alicuota1.fecha = new LocalDate('2019-01-01')
								alicuota1.provincia = provincia
								alicuota1.valor = (valor1 * 100).round(2)
								alicuota1.baseImponibleDesde = null
								alicuota1.baseImponibleHasta = 2000000

								actividad.addToAlicuotasActividadIIBB(alicuota1)

								AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
								alicuota2.fecha = new LocalDate('2019-01-01')
								alicuota2.provincia = provincia
								alicuota2.valor = (valor2 * 100).round(2)
								alicuota2.baseImponibleDesde = 2000000
								alicuota2.baseImponibleHasta = 52000000

								actividad.addToAlicuotasActividadIIBB(alicuota2)

								AlicuotaProvinciaActividadIIBB alicuota3 = new AlicuotaProvinciaActividadIIBB()
								alicuota3.fecha = new LocalDate('2019-01-01')
								alicuota3.provincia = provincia
								alicuota3.valor = (valor3 * 100).round(2)
								alicuota3.baseImponibleDesde = 52000000
								alicuota3.baseImponibleHasta = null

								actividad.addToAlicuotasActividadIIBB(alicuota3)

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					numeroFila = 0
					println 'Pagina 2:'

					for (fila in sheet2.rowIterator()) {
						if (numeroFila >= 1){
							codigoAfip = fila.getCell(0).getNumericCellValue()
							valor1 = fila.getCell(2).getNumericCellValue()
							valor2 = fila.getCell(3).getNumericCellValue()
							valor3 = fila.getCell(4).getNumericCellValue()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
								alicuota1.fecha = new LocalDate('2019-01-01')
								alicuota1.provincia = provincia
								alicuota1.valor = (valor1 * 100).round(2)
								alicuota1.baseImponibleDesde = null
								alicuota1.baseImponibleHasta = 650000

								actividad.addToAlicuotasActividadIIBB(alicuota1)

								AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
								alicuota2.fecha = new LocalDate('2019-01-01')
								alicuota2.provincia = provincia
								alicuota2.valor = (valor2 * 100).round(2)
								alicuota2.baseImponibleDesde = 650000
								alicuota2.baseImponibleHasta = 39000000

								actividad.addToAlicuotasActividadIIBB(alicuota2)

								AlicuotaProvinciaActividadIIBB alicuota3 = new AlicuotaProvinciaActividadIIBB()
								alicuota3.fecha = new LocalDate('2019-01-01')
								alicuota3.provincia = provincia
								alicuota3.valor = (valor3 * 100).round(2)
								alicuota3.baseImponibleDesde = 39000000
								alicuota3.baseImponibleHasta = null

								actividad.addToAlicuotasActividadIIBB(alicuota3)

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					numeroFila = 0
					println 'Pagina 3:'

					for (fila in sheet3.rowIterator()) {
						if (numeroFila >= 1){
							codigoAfip = fila.getCell(0).getNumericCellValue()
							valor1 = fila.getCell(2).getNumericCellValue()
							valor2 = fila.getCell(3).getNumericCellValue()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
								alicuota1.fecha = new LocalDate('2019-01-01')
								alicuota1.provincia = provincia
								alicuota1.valor = (valor1 * 100).round(2)
								alicuota1.baseImponibleDesde = null
								alicuota1.baseImponibleHasta = 4800000

								actividad.addToAlicuotasActividadIIBB(alicuota1)

								AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
								alicuota2.fecha = new LocalDate('2019-01-01')
								alicuota2.provincia = provincia
								alicuota2.valor = (valor2 * 100).round(2)
								alicuota2.baseImponibleDesde = 4800000
								alicuota2.baseImponibleHasta = null

								actividad.addToAlicuotasActividadIIBB(alicuota2)

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					numeroFila = 0
					println 'Pagina 4:'

					for (fila in sheet4.rowIterator()) {
						if (numeroFila >= 1){
							codigoAfip = fila.getCell(0).getNumericCellValue()
							valor1 = fila.getCell(2).getNumericCellValue()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
								alicuota1.fecha = new LocalDate('2019-01-01')
								alicuota1.provincia = provincia
								alicuota1.valor = (valor1 * 100).round(2)
								alicuota1.baseImponibleDesde = null
								alicuota1.baseImponibleHasta = null

								actividad.addToAlicuotasActividadIIBB(alicuota1)

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					numeroFila = 0
					println 'Pagina 5:'

					for (fila in sheet5.rowIterator()) {
						if (numeroFila >= 1){
							codigoAfip = fila.getCell(0).getNumericCellValue()
							valor1 = fila.getCell(2).getNumericCellValue()
							valor2 = fila.getCell(3).getNumericCellValue()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
								alicuota1.fecha = new LocalDate('2019-01-01')
								alicuota1.provincia = provincia
								alicuota1.valor = (valor1 * 100).round(2)
								alicuota1.baseImponibleDesde = null
								alicuota1.baseImponibleHasta = 78000000

								actividad.addToAlicuotasActividadIIBB(alicuota1)

								AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
								alicuota2.fecha = new LocalDate('2019-01-01')
								alicuota2.provincia = provincia
								alicuota2.valor = (valor2 * 100).round(2)
								alicuota2.baseImponibleDesde = 78000000
								alicuota2.baseImponibleHasta = null

								actividad.addToAlicuotasActividadIIBB(alicuota2)

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					println """Terminamos de parsear el archivo."""
				}

				if(inputFilename=='alicuotas bs as 2021.xlsx'){
					println 'Archivo alicuotas bs as 2021.xlsx'
					provincia = Provincia.findByNombre('Buenos Aires')

					def sheet1
					
					switch (inputFilename.substring(inputFilename.lastIndexOf(".") + 1, inputFilename.length())) {
						case "xls":
							sheet1 = new HSSFWorkbook(it.getInputStream()).getSheetAt(0)
							println "Detectamos que es la versión de excel vieja."
							break;
						case "xlsx":
							sheet1 = new XSSFWorkbook(it.getInputStream()).getSheetAt(0)
							println "Detectamos que es la versión de excel nueva."
							break;
						default:
							throw new Exception("formato")
					}

					Integer codigoAfip
					String codigoAfipString
					Double valor1
					Double valor2
					Double valor3
					Double valor4
					Double valor5
					Double valor6
					Double valor7

					int numeroFila = 0

					println 'Pagina 1:'
					for (fila in sheet1.rowIterator()) {
						println 'Itera'
						if (numeroFila >= 1){
							valor1=null
							valor2=null
							valor3=null
							valor4=null
							valor5=null
							valor6=null
							valor7=null

							codigoAfip = fila.getCell(0).getNumericCellValue()
							println 'Codigo ' + codigoAfip.toString()
							Cell cell = fila.getCell(2, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor1 = fila.getCell(2).getNumericCellValue()
							println 'Valor1 ' + valor1?.toString() + fila.getCell(2).getCellType()

							cell = fila.getCell(3, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor2 = fila.getCell(3).getNumericCellValue()
							println 'Valor2 ' + valor2?.toString() + fila.getCell(3).getCellType()

							cell = fila.getCell(4, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor3 = fila.getCell(4).getNumericCellValue()
							println 'Valor3 ' + valor3?.toString() + fila.getCell(4).getCellType()

							cell = fila.getCell(5, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor4 = fila.getCell(5).getNumericCellValue()
							println 'Valor4 ' + valor4?.toString() + fila.getCell(5).getCellType()

							cell = fila.getCell(6, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor5 = fila.getCell(6).getNumericCellValue()
							println 'Valor5 ' + valor5?.toString() + fila.getCell(6).getCellType()

							cell = fila.getCell(7, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor6 = fila.getCell(7).getNumericCellValue()
							println 'Valor6 ' + valor6?.toString() + fila.getCell(7).getCellType()

							cell = fila.getCell(8, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor7 = fila.getCell(8).getNumericCellValue()
							println 'Valor7 ' + valor7?.toString() + fila.getCell(8).getCellType()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								Double baseImponibleDesde1 = null
								Double baseImponibleDesde2 = null

								if(valor1!=null){
									println 'Carga valor 1'
									//Se crea la alícuota para ingresos menores a 975.000 para inscripto antes de 01/2021
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor1
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = 975000
									alicuota1.inscriptoArba2021 = false

									//Se crea la alícuota para ingresos menores a 162.500 para inscripto posterior a 01/2021
									AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
									alicuota2.fecha = new LocalDate('2021-01-01')
									alicuota2.provincia = provincia
									alicuota2.valor = valor1
									alicuota2.baseImponibleDesde = baseImponibleDesde2
									alicuota2.baseImponibleHasta = 162500
									alicuota2.inscriptoArba2021 = true

									baseImponibleDesde1 = 975000
									baseImponibleDesde2 = 162500

									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.addToAlicuotasActividadIIBB(alicuota2)
									println 'Antes de salvar valor 1'
									actividad.save(flush:true)
									println 'Salva valor 1'
								}

								if(valor2!=null){
									//Se crea la alícuota para ingresos menores a 2.000.000 para inscripto antes de 01/2021
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor2
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = 2000000
									alicuota1.inscriptoArba2021 = false

									//Se crea la alícuota para ingresos menores a 340.000 para inscripto posterior a 01/2021
									AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
									alicuota2.fecha = new LocalDate('2021-01-01')
									alicuota2.provincia = provincia
									alicuota2.valor = valor2
									alicuota2.baseImponibleDesde = baseImponibleDesde2
									alicuota2.baseImponibleHasta = 340000
									alicuota2.inscriptoArba2021 = true

									baseImponibleDesde1 = 2000000
									baseImponibleDesde2 = 340000

									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.addToAlicuotasActividadIIBB(alicuota2)
									actividad.save(flush:true)
								}

								if(valor3!=null){
									//Se crea la alícuota para ingresos menores a 3.000.000 para inscripto antes de 01/2021
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor3
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = 3000000
									alicuota1.inscriptoArba2021 = false

									//Se crea la alícuota para ingresos menores a 510.000 para inscripto posterior a 01/2021
									AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
									alicuota2.fecha = new LocalDate('2021-01-01')
									alicuota2.provincia = provincia
									alicuota2.valor = valor3
									alicuota2.baseImponibleDesde = baseImponibleDesde2
									alicuota2.baseImponibleHasta = 510000
									alicuota2.inscriptoArba2021 = true

									baseImponibleDesde1 = 3000000
									baseImponibleDesde2 = 510000

									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.addToAlicuotasActividadIIBB(alicuota2)
									actividad.save(flush:true)
								}

								if(valor4!=null){
									//Se crea la alícuota para ingresos menores a 58.500.000 para inscripto antes de 01/2021
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor4
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = 58500000
									alicuota1.inscriptoArba2021 = false

									//Se crea la alícuota para ingresos menores a  9.750.000 para inscripto posterior a 01/2021
									AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
									alicuota2.fecha = new LocalDate('2021-01-01')
									alicuota2.provincia = provincia
									alicuota2.valor = valor4
									alicuota2.baseImponibleDesde = baseImponibleDesde2
									alicuota2.baseImponibleHasta = 9750000
									alicuota2.inscriptoArba2021 = true

									baseImponibleDesde1 = 58500000
									baseImponibleDesde2 = 9750000

									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.addToAlicuotasActividadIIBB(alicuota2)
									actividad.save(flush:true)
								}

								if(valor5!=null){
									//Se crea la alícuota para ingresos menores a 78.000.000 para inscripto antes de 01/2021
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor5
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = 78000000
									alicuota1.inscriptoArba2021 = false

									//Se crea la alícuota para ingresos menores a  9.750.000 para inscripto posterior a 01/2021
									AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
									alicuota2.fecha = new LocalDate('2021-01-01')
									alicuota2.provincia = provincia
									alicuota2.valor = valor5
									alicuota2.baseImponibleDesde = baseImponibleDesde2
									alicuota2.baseImponibleHasta =  9750000
									alicuota2.inscriptoArba2021 = true

									baseImponibleDesde1 = 78000000
									baseImponibleDesde2 = 9750000

									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.addToAlicuotasActividadIIBB(alicuota2)
									actividad.save(flush:true)
								}

								if(valor6!=null){
									//Se crea la alícuota para ingresos menores a 117.000.000 para inscripto antes de 01/2021
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor6
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = 117000000
									alicuota1.inscriptoArba2021 = false

									//Se crea la alícuota para ingresos menores a  19.500.000 para inscripto posterior a 01/2021
									AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
									alicuota2.fecha = new LocalDate('2021-01-01')
									alicuota2.provincia = provincia
									alicuota2.valor = valor6
									alicuota2.baseImponibleDesde = baseImponibleDesde2
									alicuota2.baseImponibleHasta =  19500000
									alicuota2.inscriptoArba2021 = true

									baseImponibleDesde1 = 117000000
									baseImponibleDesde2 = 19500000

									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.addToAlicuotasActividadIIBB(alicuota2)
									actividad.save(flush:true)
								}

								if(valor7!=null){
									//Se crea la alícuota para ingresos menores a 117.000.000 para inscripto antes de 01/2021
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor7
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = null
									alicuota1.inscriptoArba2021 = false

									//Se crea la alícuota para ingresos menores a  19.500.000 para inscripto posterior a 01/2021
									AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
									alicuota2.fecha = new LocalDate('2021-01-01')
									alicuota2.provincia = provincia
									alicuota2.valor = valor7
									alicuota2.baseImponibleDesde = baseImponibleDesde2
									alicuota2.baseImponibleHasta =  null
									alicuota2.inscriptoArba2021 = true

									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.addToAlicuotasActividadIIBB(alicuota2)
									actividad.save(flush:true)
								}


								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					println """Terminamos de parsear el archivo."""
				}

				if(inputFilename=='alicuotas agip 2021.xlsx'){
					println 'Archivo alicuotas agip 2021.xlsx'
					provincia = Provincia.findByNombre('CABA')

					def sheet1
					
					switch (inputFilename.substring(inputFilename.lastIndexOf(".") + 1, inputFilename.length())) {
						case "xls":
							sheet1 = new HSSFWorkbook(it.getInputStream()).getSheetAt(0)
							println "Detectamos que es la versión de excel vieja."
							break;
						case "xlsx":
							sheet1 = new XSSFWorkbook(it.getInputStream()).getSheetAt(0)
							println "Detectamos que es la versión de excel nueva."
							break;
						default:
							throw new Exception("formato")
					}

					Integer codigoAfip
					String codigoAfipString
					Double valor1
					Double valor2
					Double valor3
					Double valor4
					
					int numeroFila = 0

					println 'Pagina 1:'
					for (fila in sheet1.rowIterator()) {
						if (numeroFila >= 1){
							valor1=null
							valor2=null
							valor3=null
							valor4=null
							
							codigoAfip = fila.getCell(0).getNumericCellValue()
							println 'Codigo ' + codigoAfip.toString()
							Cell cell = fila.getCell(2, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor1 = fila.getCell(2).getNumericCellValue()
							
							cell = fila.getCell(3, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor2 = fila.getCell(3).getNumericCellValue()
							
							cell = fila.getCell(4, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor3 = fila.getCell(4).getNumericCellValue()
							
							cell = fila.getCell(5, Row.RETURN_NULL_AND_BLANK);
							if (!((cell == null) || (cell.equals("")) || (cell.getCellType() == cell.CELL_TYPE_BLANK)))
								valor4 = fila.getCell(5).getNumericCellValue()
							
							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								Double baseImponibleDesde1 = null
								Double baseImponibleDesde2 = null

								if(valor1!=null){
									//Se crea la alícuota para ingresos menores a 650.000
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor1
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = 650000
									alicuota1.inscriptoArba2021 = false

									baseImponibleDesde1 = 650000

									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.save(flush:true)
								}

								if(valor2!=null){
									//Se crea la alícuota para ingresos menores a 22.750.000
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor2
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = 22750000
									alicuota1.inscriptoArba2021 = false

									baseImponibleDesde1 = 22750000

									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.save(flush:true)
								}

								if(valor3!=null){
									//Se crea la alícuota para ingresos menores a 125.000.000
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor3
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = 12500000
									alicuota1.inscriptoArba2021 = false

									baseImponibleDesde1 = 12500000
									
									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.save(flush:true)
								}

								if(valor4!=null){
									//Se crea la alícuota para ingresos mayores a la ultima baseImponibleDesde1
									AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
									alicuota1.fecha = new LocalDate('2021-01-01')
									alicuota1.provincia = provincia
									alicuota1.valor = valor4
									alicuota1.baseImponibleDesde = baseImponibleDesde1
									alicuota1.baseImponibleHasta = null
									alicuota1.inscriptoArba2021 = false

									actividad.addToAlicuotasActividadIIBB(alicuota1)
									actividad.save(flush:true)
								}

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					println """Terminamos de parsear el archivo."""
				}

				if(inputFilename=='alicuotas CABA 2019.xlsx'){
					provincia = Provincia.findByNombre('CABA')

					def sheet1
					def sheet2
					def sheet3
					def sheet4
					def sheet5

					switch (inputFilename.substring(inputFilename.lastIndexOf(".") + 1, inputFilename.length())) {
						case "xls":
							sheet1 = new HSSFWorkbook(it.getInputStream()).getSheetAt(0)
							sheet2 = new HSSFWorkbook(it.getInputStream()).getSheetAt(1)
							sheet3 = new HSSFWorkbook(it.getInputStream()).getSheetAt(2)
							sheet4 = new HSSFWorkbook(it.getInputStream()).getSheetAt(3)
							sheet5 = new HSSFWorkbook(it.getInputStream()).getSheetAt(4)
							println "Detectamos que es la versión de excel vieja."
							break;
						case "xlsx":
							sheet1 = new XSSFWorkbook(it.getInputStream()).getSheetAt(0)
							sheet2 = new XSSFWorkbook(it.getInputStream()).getSheetAt(1)
							sheet3 = new XSSFWorkbook(it.getInputStream()).getSheetAt(2)
							sheet4 = new XSSFWorkbook(it.getInputStream()).getSheetAt(3)
							sheet5 = new XSSFWorkbook(it.getInputStream()).getSheetAt(4)
							println "Detectamos que es la versión de excel nueva."
							break;
						default:
							throw new Exception("formato")
					}

					Integer codigoAfip
					String codigoAfipString
					Double valor1
					Double valor2
					Double valor3

					int numeroFila = 0

					println 'Pagina 1:'
					for (fila in sheet1.rowIterator()) {
						if (numeroFila >= 1){
							codigoAfip = fila.getCell(0).getNumericCellValue()
							valor1 = fila.getCell(2).getNumericCellValue()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
								alicuota1.fecha = new LocalDate('2019-01-01')
								alicuota1.provincia = provincia
								alicuota1.valor = (valor1 * 100).round(2)
								alicuota1.baseImponibleDesde = null
								alicuota1.baseImponibleHasta = null

								actividad.addToAlicuotasActividadIIBB(alicuota1)

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					numeroFila = 0
					println 'Pagina 2:'

					for (fila in sheet2.rowIterator()) {
						if (numeroFila >= 2){
							codigoAfip = fila.getCell(0).getNumericCellValue()
							valor1 = fila.getCell(2).getNumericCellValue()
							valor2 = fila.getCell(3).getNumericCellValue()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
								alicuota1.fecha = new LocalDate('2019-01-01')
								alicuota1.provincia = provincia
								alicuota1.valor = (valor1 * 100).round(2)
								alicuota1.baseImponibleDesde = null
								alicuota1.baseImponibleHasta = 71500000

								actividad.addToAlicuotasActividadIIBB(alicuota1)

								AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
								alicuota2.fecha = new LocalDate('2019-01-01')
								alicuota2.provincia = provincia
								alicuota2.valor = (valor2 * 100).round(2)
								alicuota2.baseImponibleDesde = 71500000
								alicuota2.baseImponibleHasta = null

								actividad.addToAlicuotasActividadIIBB(alicuota2)

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					numeroFila = 0
					println 'Pagina 3:'

					for (fila in sheet3.rowIterator()) {
						if (numeroFila >= 2){
							codigoAfip = fila.getCell(0).getNumericCellValue()
							valor1 = fila.getCell(2).getNumericCellValue()
							valor2 = fila.getCell(3).getNumericCellValue()
							valor3 = fila.getCell(7).getNumericCellValue()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
								alicuota1.fecha = new LocalDate('2019-01-01')
								alicuota1.provincia = provincia
								alicuota1.valor = (valor1 * 100).round(2)
								alicuota1.baseImponibleDesde = null
								alicuota1.baseImponibleHasta = 13000000

								actividad.addToAlicuotasActividadIIBB(alicuota1)

								AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
								alicuota2.fecha = new LocalDate('2019-01-01')
								alicuota2.provincia = provincia
								alicuota2.valor = (valor2 * 100).round(2)
								alicuota2.baseImponibleDesde = 13000000
								alicuota2.baseImponibleHasta = 71500000

								actividad.addToAlicuotasActividadIIBB(alicuota2)

								AlicuotaProvinciaActividadIIBB alicuota3 = new AlicuotaProvinciaActividadIIBB()
								alicuota3.fecha = new LocalDate('2019-01-01')
								alicuota3.provincia = provincia
								alicuota3.valor = (valor3 * 100).round(2)
								alicuota3.baseImponibleDesde = 71500000
								alicuota3.baseImponibleHasta = null

								actividad.addToAlicuotasActividadIIBB(alicuota3)

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					numeroFila = 0
					println 'Pagina 4:'

					for (fila in sheet4.rowIterator()) {
						if (numeroFila >= 2){
							codigoAfip = fila.getCell(0).getNumericCellValue()
							valor1 = fila.getCell(2).getNumericCellValue()
							valor2 = fila.getCell(3).getNumericCellValue()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
								alicuota1.fecha = new LocalDate('2019-01-01')
								alicuota1.provincia = provincia
								alicuota1.valor = (valor1 * 100).round(2)
								alicuota1.baseImponibleDesde = null
								alicuota1.baseImponibleHasta = 71500000

								actividad.addToAlicuotasActividadIIBB(alicuota1)

								AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
								alicuota2.fecha = new LocalDate('2019-01-01')
								alicuota2.provincia = provincia
								alicuota2.valor = (valor2 * 100).round(2)
								alicuota2.baseImponibleDesde = 71500000
								alicuota2.baseImponibleHasta = null

								actividad.addToAlicuotasActividadIIBB(alicuota2)

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}

					numeroFila = 0
					println 'Pagina 5:'

					for (fila in sheet5.rowIterator()) {
						if (numeroFila >= 1){
							codigoAfip = fila.getCell(0).getNumericCellValue()
							valor1 = fila.getCell(2).getNumericCellValue()
							valor2 = fila.getCell(3).getNumericCellValue()

							codigoAfipString = codigoAfip.toString()
							while(codigoAfipString.length()<6){
								codigoAfipString = '0' + codigoAfipString
							}

							def actividad = Actividad.findByCodigoNaes(codigoAfipString)
							if(actividad!=null){
								AlicuotaProvinciaActividadIIBB alicuota1 = new AlicuotaProvinciaActividadIIBB()
								alicuota1.fecha = new LocalDate('2019-01-01')
								alicuota1.provincia = provincia
								alicuota1.valor = (valor1 * 100).round(2)
								alicuota1.baseImponibleDesde = null
								alicuota1.baseImponibleHasta = 71500000

								actividad.addToAlicuotasActividadIIBB(alicuota1)

								AlicuotaProvinciaActividadIIBB alicuota2 = new AlicuotaProvinciaActividadIIBB()
								alicuota2.fecha = new LocalDate('2019-01-01')
								alicuota2.provincia = provincia
								alicuota2.valor = (valor2 * 100).round(2)
								alicuota2.baseImponibleDesde = 71500000
								alicuota2.baseImponibleHasta = null

								actividad.addToAlicuotasActividadIIBB(alicuota2)

								actividad.save(flush:true)
							}else{
								println 'codigo: ' + codigoAfipString + ' no se encontro.'
							}
						}

						numeroFila++
					}
				}

				println """Terminamos de parsear el archivo."""
			} catch(Exception e) {
				log.error("Error en archivo ${archivoActual}:\n" + e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				archivoActual++
			}
		}
		return
	}

	def importacionMasivaRetPer(archivos, Long cuentaId){
		Cuenta cuenta = Cuenta.get(cuentaId)
		if (!cuenta || cuenta.estado.id != Estado.findByNombre('Activo').id)
			throw new Exception("cuenta")
		def listaLogs = []

		archivos.each{
			String tipo
			String nombreArchivo = it.getOriginalFilename().toLowerCase()
			try {
				// AGIP
					if(nombreArchivo.contains("esicol")){
						if(nombreArchivo.contains("bancarias"))
							tipo = "bancaria"
						else if(nombreArchivo.contains("retenciones"))
							tipo = "retencion"
						else if(nombreArchivo.contains("percepciones"))
							tipo = "percepcion"
						else
							throw new Exception("nombre")
						listaLogs.push(importarRetencionesPercepcionesAGIP(cuenta, it, tipo))
				// AFIP
					}else if(nombreArchivo.contains("impositivasparaaplicativo")){
						if(nombreArchivo.contains("retenciones"))
							tipo = "retencion"
						else if(nombreArchivo.contains("percepciones"))
							tipo = "percepcion"
						else
							throw new Exception("nombre")
						listaLogs.push(importarRetencionesPercepcionesAFIP(cuenta, it, tipo))
				// Caba multiLateral
					}else if (nombreArchivo.contains("retencionesexport")){
						listaLogs.push(importarRetencionesCabaMultilateral(cuenta, it))
				// Sircreb Recaudaciones
					}else if (nombreArchivo.contains("sircreb_recaudaciones")){
						listaLogs.push(importarRetencionesBancariasSircreb(cuenta, it)) // El archivo tiene CUIT, ¿autoBuscarCuenta?
				//ARBA o error
					}else{
						boolean nuevoArba = false
						if(nombreArchivo[-7..-5] == "m-b"){
							tipo = "bancaria"
							nuevoArba = true
						}
						else if(nombreArchivo[-7..-5] == "m-r"){
							tipo = "retencion"
							nuevoArba = true
						}
						else if(nombreArchivo[-7..-5] == "m-p"){
							tipo = "percepcion"
							nuevoArba = true
						}
						else if(nombreArchivo.contains("cb"))
							tipo = "bancaria"
						else if(nombreArchivo.contains("cr"))
							tipo = "retencion"
						else if(nombreArchivo.contains("cp"))
							tipo = "percepcion"
						else
							throw new Exception("nombre")

						if (nuevoArba)
							listaLogs.push(importarRetencionesPercepcionesARBANuevo(cuenta, it, tipo))
						else
							listaLogs.push(importarRetencionesPercepcionesARBA(cuenta, it, tipo))
					}
			}
			catch(Exception e) {
				log.error(e.message)
				LogImportacion fallado = new LogImportacion()
				fallado.nombreArchivo = it.getOriginalFilename()
				fallado.estado = Estado.findByNombre("Error")
				fallado.detalle = (e.message == "nombre") ? "Nombre de archivo inválido." : "La importación falló por un error de archivo."
				listaLogs.push(fallado)
			}
		}
		listaLogs.each{
			if (it.estado.nombre=='Activo'){
				liquidacionIvaService.liquidacionAutomatica(it.fecha.toString("MM"), it.fecha.toString("YYYY"), cuenta.id)
				liquidacionIIBBService.liquidacionAutomatica(it.fecha.toString("MM"), it.fecha.toString("YYYY"), cuenta.id)
			}
		}
		return listaLogs
	}

	/*def importarRetPerFactura(archivo, Long cuentaId){
		Cuenta cuenta = Cuenta.get(cuentaId)
		if (!cuenta || cuenta.estado.nombre != 'Activo')
			throw new Exception("cuenta")
		def listaLogs = []

		String tipoRPB
		String nombreArchivo = archivo.getOriginalFilename().toLowerCase()
		try {
			if(nombreArchivo.contains("esicol")){ //RPB - AGIP
				if(nombreArchivo.contains("bancarias"))
					tipoRPB = "bancaria"
				else if(nombreArchivo.contains("retenciones"))
					tipoRPB = "retencion"
				else if(nombreArchivo.contains("percepciones"))
					tipoRPB = "percepcion"
				else
					throw new Exception("nombre")
				listaLogs.push(importarRetencionesPercepcionesAGIP(cuenta, archivo, tipoRPB))
			}else if(nombreArchivo.contains("impositivasparaaplicativo")){ //RPB - AFIP
				if(nombreArchivo.contains("retenciones"))
					tipoRPB = "retencion"
				else if(nombreArchivo.contains("percepciones"))
					tipoRPB = "percepcion"
				else
					throw new Exception("nombre")
				listaLogs.push(importarRetencionesPercepcionesAFIP(cuenta, archivo, tipoRPB))
			}else if (nombreArchivo.contains("retencionesexport")){ //RPB - Caba MultiLateral
				listaLogs.push(importarRetencionesCabaMultilateral(cuenta, archivo))
			}else{ //RPB - ARBA
				if(nombreArchivo.contains("cb"))
					listaLogs.push(importarRetencionesPercepcionesARBA(cuenta, archivo, "bancaria"))
				else if(nombreArchivo.contains("cr"))
					listaLogs.push(importarRetencionesPercepcionesARBA(cuenta, archivo, "retencion"))
				else if(nombreArchivo.contains("cp"))
					listaLogs.push(importarRetencionesPercepcionesARBA(cuenta, archivo, "percepcion"))
				else // No es ningún tipo de ret/per/banc. , así que le pasamos el archivo a la función que verifica si es factura e importa
					listaLogs = importacionMasivaFacturas(archivo, cuentaId)
			}
		}
		catch(Exception e) {
			LogImportacion fallado = new LogImportacion()
			fallado.nombreArchivo = archivo.getOriginalFilename()
			fallado.estado = Estado.findByNombre("Error")
			fallado.detalle = (e.message == "nombre") ? "Nombre de archivo inválido." : "La importación falló por un error de archivo."
			listaLogs.push(fallado)
		}

		listaLogs.each{
			if (it.estado.nombre=='Activo')
				liquidacionIIBBService.liquidacionAutomatica(it.fecha.toString("MM"), it.fecha.toString("YYYY"), cuenta.id)
		}
		return listaLogs
	}*/

	def generarListImportaciones(ano, mes){
		//Se definen los estados que se usarán a lo largo de la función:
			Estado estadoActivo = Estado.findByNombre('Activo')
		LocalDate fecha = new LocalDate(ano + '-' + mes + '-01')
		def listaItems = []
		def logs = LogImportacion.findAllByFechaAndEstado(fecha, estadoActivo)

		Cuenta.findAllByEstado(estadoActivo).each{
			EstadoImportacionesItem item = new EstadoImportacionesItem()
			item.clienteId = it.id
			logs.findAll { it.cuenta.id == item.clienteId}.each{
				if (it.compra)
					item.compra = true
				else if (it.venta)
					item.venta = true
				else if (it.retencion)
					if (it.retPerEsIva)
						item.retencionesIva = true
					else
						item.retencionesIibb = true
				else if (it.percepcion)
					if (it.retPerEsIva)
						item.percepcionesIva = true
					else
						 item.percepcionesIibb = true
				else if (it.bancaria)
					item.bancarias = true
			}
			listaItems.push(item)
		}
		return listaItems
	}

	def generarListImportacionesPorCuenta(cuentaId, ano){
		def cuenta = Cuenta.get(cuentaId)
		def salida = []
		def mes = new LocalDate(ano + '-01-01')

		for(def i=0; i<12; i++){
			EstadoImportacionesItem item = new EstadoImportacionesItem()
			item.fecha = mes.toString("MM")
			LogImportacion.createCriteria().list() {
				and{
					eq('cuenta', cuenta)
					eq('fecha', mes)
					eq('estado', Estado.findByNombre('Activo'))
				}
			}.each{
				if(it.compra){
					item.compra = true
					item.cantidadFacturasCompra += it.total
				}
				else if (it.venta){
					item.venta = true
					item.cantidadFacturasVenta += it.total
				}
				else if (it.retencion)
					if (it.retPerEsIva){
						item.retencionesIva = true
						item.cantidadRetencionesIva += it.total
					}
					else{
						item.retencionesIibb = true
						item.cantidadRetencionesIibb += it.total
					}
				else if (it.percepcion)
					if (it.retPerEsIva){
						item.percepcionesIva = true
						item.cantidadPercepcionesIva += it.total
					}
					else{
						item.percepcionesIibb = true
						item.cantidadPercepcionesIibb += it.total
					}
				else if (it.bancaria){
					item.bancarias = true
					item.cantidadBancarias += it.total
				}
				/*if (i!=0)
					item.archivos+=' ; '
				item.archivos += it.nombreArchivo*/
			}

			salida.push(item)

			mes = mes.plusMonths(1)
		}
		return salida
	}

	def deleteLogImportacion (id){
		def importacion = LogImportacion.get(id)
		if (importacion){
			importacion.facturasVenta?.clear()
			importacion.facturasCompra?.clear()
			importacion.retPerIva?.clear()
			importacion.retPerIIBB?.clear()
			importacion.estado = Estado.findByNombre('Borrado')
			importacion.save(flush:true, failOnError:true)
		}
	}

	def deleteLogs(String logsId){
		logsId.split(',').each{
			deleteLogImportacion(it)
		}
	}

	def importarRetencionesPercepcionesAFIP(Cuenta cuenta, def fileInput, String tipo){
		importarRetencionesPercepcionesAFIP(cuenta, fileInput.getInputStream(), tipo, fileInput.getOriginalFilename())
	}
	def importarRetencionesPercepcionesAFIP(Cuenta cuenta, InputStream inputStream, String tipo, String nombre){
		Provincia provinciaCaba = Provincia.findByNombre("CABA")
		BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))
		boolean primeraVuelta = true
		LogImportacion log = new LogImportacion()
		log.retPerEsIva = true
		log.fechaHora = new LocalDateTime()
		log.provincia = provinciaCaba
		log.responsable = (accessRulesService.currentUser?.username ?: "-")
		if (tipo == "percepcion")
			log.percepcion = true
		else if (tipo == "bancaria")
			log.bancaria = true
		else
			log.retencion = true
		log.fecha = new LocalDate()
		log.estado = Estado.findByNombre('Activo')
		log.nombreArchivo = nombre
		log.cuenta = cuenta
		log.save(flush:true)

		while(reader.ready()) {
			log.total++
			String line = reader.readLine()
			RetencionPercepcionIva retencionPercepcion = new RetencionPercepcionIva()

			retencionPercepcion.cuit = line[3..15].trim()
			retencionPercepcion.tipo = tipo

			if (tipo == "retencion"){
				retencionPercepcion.comprobante = line[26..50].trim()
				retencionPercepcion.monto = new Double (line[51..66].trim().replace(',', '.'))
			 }
			else{
				retencionPercepcion.facturaParteA = line[26..33].trim()
				retencionPercepcion.facturaParteB = line[34..41].trim()
				// retencionPercepcion.with{comprobante = facturaParteA + facturaParteB}
				retencionPercepcion.monto = new Double (line[42..57].trim().replace(',', '.'))
			}

			retencionPercepcion.codigo = line[0..2].trim()

			String ano = line[22..25]
			String mes = line[19..20]
			String dia = line[16..17]
			if (primeraVuelta){
				log.fecha = new LocalDate((ano + "-" + mes + "-01"))
				// limpiarImportacionAnteriorRP(log)
				primeraVuelta = false
			}
			retencionPercepcion.fecha = new LocalDate((ano + "-" + mes + "-" + dia))

			retencionPercepcion.origen = "afip"
			retencionPercepcion.provincia = provinciaCaba
			try {
				cuenta.addToRetPerIva(retencionPercepcion)
				log.addToRetPerIva(retencionPercepcion)
				if (retencionPercepcion.validate()){	
					retencionPercepcion.save(flush:true, failOnError:true)
				}
				else{
					println "........Retención duplicada ignorada"
					cuenta.removeFromRetPerIva(retencionPercepcion)
					log.removeFromRetPerIva(retencionPercepcion)
				}
			}
			catch(Exception e) {
				// println "La rentención ${retencionPercepcion.comprobante} está repetida"
				cuenta.removeFromRetPerIva(retencionPercepcion)
				log.cantidadIgnoradas++	
			}
		}
		log.cantidadOk = log.total - log.cantidadIgnoradas
		cuenta.addToLogs(log).save(flush:true, failOnError: true)
		log.save(flush:true, failOnError: true)
		// println "Se liquida automáticamente."
		// liquidacionIvaService.liquidacionAutomatica(log.fecha.toString("MM"), log.fecha.toString("YYYY"), cuenta.id)
		return log
	}

	def importarRetencionesPercepcionesAGIP(Cuenta cuenta, def fileInput, String tipo){
		importarRetencionesPercepcionesAGIP(cuenta, fileInput.getInputStream(), tipo, fileInput.getOriginalFilename())
	}
	def importarRetencionesPercepcionesAGIP(Cuenta cuenta, InputStream inputStream, String tipo, String nombre){
		Provincia provinciaCaba = Provincia.findByNombre("CABA")
		BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))
		boolean primeraVuelta = true
		LogImportacion log = new LogImportacion()
		log.fechaHora = new LocalDateTime()
		log.provincia = provinciaCaba
		log.responsable = (accessRulesService.currentUser?.username ?: "Selenium")
		if (tipo == "percepcion")
			log.percepcion = true
		else if (tipo == "bancaria")
			log.bancaria = true
		else
			log.retencion = true
		log.fecha = new LocalDate()
		log.estado = Estado.findByNombre('Activo')
		log.nombreArchivo = nombre
		log.cuenta = cuenta
		log.save(flush:true)

		while(reader.ready()) {
			log.total++
			String line = reader.readLine()
			RetencionPercepcionIIBB retencionPercepcion = new RetencionPercepcionIIBB()

			retencionPercepcion.cuit = line[0..10].trim()
			retencionPercepcion.tipo = tipo
			if (tipo != "percepcion"){
				String ano = line[11..14]
				String mes = line[15..16]
				String dia = line[17..18]
				if (primeraVuelta){
					log.fecha = new LocalDate((ano + "-" + mes + "-01"))
					limpiarImportacionAnteriorRP(log)
					primeraVuelta = false
				}
				retencionPercepcion.fecha = new LocalDate((ano + "-" + mes + "-" + dia))

				if (tipo == "retencion"){
					retencionPercepcion.comprobante = line[19..26].trim()
					retencionPercepcion.monto = new Double(line[43..58].trim().replace(',', '.'))
					retencionPercepcion.montoBase = new Double(line[27..42].trim().replace(',', '.'))
				}
				else if (tipo == "bancaria"){
					retencionPercepcion.tipoCuenta = line[35..40].trim()
					retencionPercepcion.cbu = line[41..62].trim()
					retencionPercepcion.monto = new Double(line[19..34].trim().replace(',', '.'))
				}
			}else{
				String ano = line[19..22]
				String mes = line[23..24]
				String dia = line[25..26]
				if (primeraVuelta){
					log.fecha = new LocalDate((ano + "-" + mes + "-01"))
					limpiarImportacionAnteriorRP(log)
					primeraVuelta = false
				}
				retencionPercepcion.fecha = new LocalDate((ano + "-" + mes + "-" + dia))
				retencionPercepcion.facturaParteA = line[27..30].trim().replace(' ', '0') //Numero sucursal
				retencionPercepcion.facturaParteB = line[11..18].trim().replace(' ', '0') //Numero comprobante
				retencionPercepcion.with{comprobante = facturaParteA + facturaParteB}
				retencionPercepcion.monto = new Double(line[47..62].trim().replace(',', '.'))
				retencionPercepcion.montoBase = new Double(line[31..46].trim().replace(',', '.'))
				retencionPercepcion.tipoComprobante = line[63]
				retencionPercepcion.letraComprobante = line[64]
			}
			retencionPercepcion.origen = "agip"
			retencionPercepcion.provincia = provinciaCaba
			retencionPercepcion.codigo = retencionPercepcion.provincia.codigoRPB
			cuenta.addToRetPerIIBB(retencionPercepcion)
			log.addToRetPerIIBB(retencionPercepcion)
		}
		log.cantidadOk = log.total
		cuenta.addToLogs(log).save(flush:true, failOnError: true)
		log.save(flush:true, failOnError: true)
		return log
	}

	def importarBancariasExcelAGIP(Cuenta cuenta, InputStream inputStream){
		Provincia provinciaCaba = Provincia.findByNombre("CABA")
		BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))
		boolean primeraVuelta = true
		LogImportacion log = new LogImportacion()
		log.fechaHora = new LocalDateTime()
		log.provincia = provinciaCaba
		log.responsable = (accessRulesService.currentUser?.username ?: "Selenium")
		log.bancaria = true
		log.fecha = new LocalDate()
		log.estado = Estado.findByNombre('Activo')
		log.nombreArchivo = "RentasCiudad.csv"
		log.cuenta = cuenta
		log.save(flush:true)
		def dtf = DateTimeFormat.forPattern("dd/MM/yyyy")
		reader.readLine()
		reader.readLine()
		while(reader.ready()) {
			log.total++
			def renglon = reader.readLine().replaceAll('"',"").split(",")
			RetencionPercepcionIIBB retencionPercepcion = new RetencionPercepcionIIBB().with{
				cuit = renglon[0]
				fecha = dtf.parseLocalDate(renglon[2])
				montoBase = new Double(renglon[4])
				monto = new Double(renglon[6])
				tipoCuenta = renglon[7]
				cbu = renglon[8]
				origen = "agip"
				tipo= "bancaria"
				provincia = provinciaCaba
				codigo = provincia.codigoRPB
				return it
			}

			if (primeraVuelta){
				log.fecha = retencionPercepcion.fecha.withDayOfMonth(1)
				limpiarImportacionAnteriorRP(log)
				primeraVuelta = false
			}
			cuenta.addToRetPerIIBB(retencionPercepcion)
			log.addToRetPerIIBB(retencionPercepcion)
		}
		log.cantidadOk = log.total
		cuenta.addToLogs(log).save(flush:true, failOnError: true)
		log.save(flush:true, failOnError: true)
		return log
	}

	def importarRetencionesPercepcionesARBA(Cuenta cuenta, def fileInput, String tipo){
		importarRetencionesPercepcionesARBA(cuenta, fileInput.getInputStream(), tipo, fileInput.getOriginalFilename())
	}
	def importarRetencionesPercepcionesARBA(Cuenta cuenta, InputStream inputStream, String tipo, String nombre){
		Provincia provinciaBuenosAires = Provincia.findByNombre("Buenos Aires")
		BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))
		boolean primeraVuelta = true
		LogImportacion log = new LogImportacion()
		log.fechaHora = new LocalDateTime()
		log.responsable = (accessRulesService.currentUser?.username ?: "-")
		if (tipo == "percepcion")
			log.percepcion = true
		else if (tipo == "bancaria")
			log.bancaria = true
		else
			log.retencion = true
		log.fecha = new LocalDate()
		log.provincia = provinciaBuenosAires
		log.estado = Estado.findByNombre('Activo')
		log.nombreArchivo = nombre
		log.cuenta = cuenta
		log.save(flush:true)
		def logId = log.id
		int total = 0
		int cantidadIgnoradas = 0
		LocalDate fecha

		while(reader.ready()) {
			total++
			String line = reader.readLine()
			RetencionPercepcionIIBB retencionPercepcion = new RetencionPercepcionIIBB()

			retencionPercepcion.cuit = line[3..15].trim()
			retencionPercepcion.codigo = line[0..2] //En realidad es Jurisdiccion
			retencionPercepcion.tipo = tipo
			if (tipo != "bancaria"){
				String dia = line[16..17]
				String mes = line[19..20]
				String ano = line[22..25]
				if (primeraVuelta){
					fecha = new LocalDate((ano + "-" + mes + "-01"))
					// limpiarImportacionAnteriorRP(log)
					primeraVuelta = false
				}
				retencionPercepcion.fecha = new LocalDate((ano + "-" + mes + "-" + dia))
				if (tipo == "retencion"){
					retencionPercepcion.monto = new Double(line[68..77].trim().replace(',', '.'))
					retencionPercepcion.facturaParteA = line[26..29] //Punto de Venta
					retencionPercepcion.facturaParteB = new Long(line[30..45]).toString() //Numero comprobante
				}else{
					retencionPercepcion.monto = new Double(line[40..50].trim().replace(',', '.'))
					retencionPercepcion.facturaParteA = line[26..29].trim().replace(' ', '0') //Punto de Venta
					retencionPercepcion.facturaParteB = line[30..37].trim().replace(' ', '0') //Numero comprobante
					retencionPercepcion.tipoComprobante = line[38]
					retencionPercepcion.letraComprobante = line[39]
				}
				retencionPercepcion.comprobante = retencionPercepcion.facturaParteA + retencionPercepcion.facturaParteB
			}else{
				String dia = "01"
				String mes = line[21..22]
				String ano = line[16..19]
				if (primeraVuelta){
					fecha = new LocalDate((ano + "-" + mes + "-01"))
					// limpiarImportacionAnteriorRP(log)
					primeraVuelta = false
				}
				retencionPercepcion.fecha = new LocalDate((ano + "-" + mes + "-" + dia))
				retencionPercepcion.tipoCuenta = line[45..47].trim()
				retencionPercepcion.cbu = line[23..44].trim()
				retencionPercepcion.monto = new Double(line[48..57].trim().replace(',', '.'))
			}

			retencionPercepcion.origen = "arba"
			retencionPercepcion.provincia = provinciaBuenosAires
			try {
				// cuenta.addToRetPerIIBB(retencionPercepcion)
				retencionPercepcion.cuenta = cuenta
				// log.addToRetPerIIBB(retencionPercepcion)
				if (retencionPercepcion.validate()){
					retencionPercepcion.save(flush:true, failOnError:true)
					retencionPercepcion.logImportacion = log
				}
				else{
					println "........Retención duplicada ignorada"
					// cuenta.removeFromRetPerIIBB(retencionPercepcion)
					cantidadIgnoradas++	
					// log.removeFromRetPerIIBB(retencionPercepcion)
				}
			}
			catch(Exception e) {
				println "La rentención ${retencionPercepcion.comprobante} está repetida"
				cuenta.removeFromRetPerIIBB(retencionPercepcion)
				cantidadIgnoradas++	
			}
			
		}
		println "Cantidad de retenciones"
		println log.retPerIIBB.size()
		log = LogImportacion.get(logId)
		println log.retPerIIBB.size()
		log.total = total
		log.cantidadIgnoradas = cantidadIgnoradas
		log.with{cantidadOk = total - cantidadIgnoradas}
		// cuenta.addToLogs(log).save(flush:true)
		log.save(flush:true)
		return log
	}

	def importarRetencionesPercepcionesARBANuevo(Cuenta cuenta, fileInput, String tipo){
		Provincia provinciaBuenosAires = Provincia.findByNombre("Buenos Aires")
		def dateFormat = DateTimeFormat.forPattern("dd/MM/yyyy")
		BufferedReader reader = new BufferedReader(new InputStreamReader(fileInput.getInputStream()))
		boolean primeraVuelta = true
		LogImportacion log = new LogImportacion()
		log.fechaHora = new LocalDateTime()
		log.responsable = (accessRulesService.currentUser?.username ?: "-")
		if (tipo == "percepcion")
			log.percepcion = true
		else if (tipo == "bancaria")
			log.bancaria = true
		else
			log.retencion = true
		log.fecha = new LocalDate()
		log.provincia = provinciaBuenosAires
		log.estado = Estado.findByNombre('Activo')
		log.nombreArchivo = fileInput.getOriginalFilename()
		log.cuenta = cuenta
		log.save(flush:true)
		def logId = log.id
		int total = 0
		int cantidadIgnoradas = 0
		LocalDate fecha

		while(reader.ready()) {
			total++
			String line = reader.readLine()
			RetencionPercepcionIIBB retencionPercepcion = new RetencionPercepcionIIBB()

			retencionPercepcion.codigo = "902"
			retencionPercepcion.tipo = tipo
			if (tipo != "bancaria"){
				retencionPercepcion.cuit = line[0..12].trim()
				retencionPercepcion.fecha = dateFormat.parseLocalDate(line[13..22])
				if (tipo == "retencion"){
					retencionPercepcion.monto = new Double(line[35..44].trim().replace(',', '.'))
					retencionPercepcion.facturaParteA = line[23..26] //Punto de Venta 
					retencionPercepcion.facturaParteB = new Long(line[27..34]).toString() //Numero comprobante
				}else{
					retencionPercepcion.tipoComprobante = line[23]
					retencionPercepcion.letraComprobante = line[24]
					retencionPercepcion.facturaParteA = line[25..28].trim().replace(' ', '0') //Punto de Venta
					retencionPercepcion.facturaParteB = line[29..36].trim().replace(' ', '0') //Numero comprobante
					retencionPercepcion.monto = new Double(line[37..47].trim().replace(',', '.'))
				}
				retencionPercepcion.comprobante = retencionPercepcion.facturaParteA + retencionPercepcion.facturaParteB
			}else{
				retencionPercepcion.cbu = line[0..21].trim()
				retencionPercepcion.cuit = line[22..34].trim()
				retencionPercepcion.fecha = dateFormat.parseLocalDate(line[35..44])
				retencionPercepcion.tipoCuenta = line[46].trim()
				retencionPercepcion.monto = new Double(line[47..56].trim().replace(',', '.'))
			}
			if (primeraVuelta){
				fecha = retencionPercepcion.fecha.withDayOfMonth(1)
				// limpiarImportacionAnteriorRP(log)
				primeraVuelta = false
			}

			retencionPercepcion.origen = "arba"
			retencionPercepcion.provincia = provinciaBuenosAires
			try {
				//cuenta.addToRetPerIIBB(retencionPercepcion)
				retencionPercepcion.cuenta = cuenta
				if (retencionPercepcion.validate()){
					retencionPercepcion.save(flush:true, failOnError:true)
					// log.addToRetPerIIBB(retencionPercepcion)
					retencionPercepcion.logImportacion = log
				}
				else{
					println "........Retención duplicada ignorada"
					cantidadIgnoradas++	
					// cuenta.removeFromRetPerIIBB(retencionPercepcion)
					// log.removeFromRetPerIIBB(retencionPercepcion)
				}
			}
			catch(Exception e) {
				println "La rentención ${retencionPercepcion.comprobante} está repetida"
				cuenta.removeFromRetPerIIBB(retencionPercepcion)
				cantidadIgnoradas++	
			}
		}
		println "Cantidad de retenciones"
		println log.retPerIIBB ? log.retPerIIBB.size() : 0
		log = LogImportacion.get(logId)
		println log.retPerIIBB ? log.retPerIIBB.size() : 0
		log.total = total
		log.cantidadIgnoradas = cantidadIgnoradas
		log.with{cantidadOk = total - cantidadIgnoradas}
		//cuenta.addToLogs(log).save(flush:true, failOnError: true)
		log.save(flush:true, failOnError: true)
		return log
	}

	def importarRetencionesCabaMultilateral(Cuenta cuenta, def fileInput){
		BufferedReader reader = new BufferedReader(new InputStreamReader(fileInput.getInputStream()))
		boolean primeraVuelta = true
		Provincia provinciaCaba = Provincia.findByNombre("CABA")
		LogImportacion log = new LogImportacion()
		log.bancaria = true
		log.fechaHora = new LocalDateTime()
		log.responsable = (accessRulesService.currentUser?.username ?: "-")
		log.fecha = new LocalDate()
		log.estado = Estado.findByNombre('Activo')
		log.nombreArchivo = fileInput.getOriginalFilename()
		log.cuenta = cuenta
		log.provincia = provinciaCaba
		log.save(flush:true)

		while(reader.ready()) {
			String line = reader.readLine()
			if (line[0..2]=="901"){ //Sólo lee la provincia cuyo código es el de caba
				log.total++
				RetencionPercepcionIIBB retencionPercepcion = new RetencionPercepcionIIBB()
				retencionPercepcion.tipo = 'bancaria'
				retencionPercepcion.cuit = line[3..15].trim()
				String ano = line[16..19]
				String mes = line[21..22]
				String dia = "01"
				if (primeraVuelta){
					log.fecha = new LocalDate((ano + "-" + mes + "-01"))
					limpiarImportacionAnteriorRP(log)
					primeraVuelta = false
				}
				retencionPercepcion.fecha = new LocalDate((ano + "-" + mes + "-" + dia))
				retencionPercepcion.cbu = line[23..44].trim()
				retencionPercepcion.tipoCuenta = line[45..47].trim()
				retencionPercepcion.monto = new Double(line[48..57].trim().replace(',', '.'))
				retencionPercepcion.origen = "agip"
				retencionPercepcion.provincia = provinciaCaba
				cuenta.addToRetPerIIBB(retencionPercepcion)
				log.addToRetPerIIBB(retencionPercepcion)
			}
		}
		log.cantidadOk = log.total
		cuenta.addToLogs(log).save(flush:true, failOnError: true)
		log.save(flush:true, failOnError: true)
		return log
	}

	def importarRetencionesBancariasSircreb(Cuenta cuenta, fileInput){
		importarRetencionesBancariasSircreb(cuenta, fileInput.getInputStream(), fileInput.originalFilename)
	}

	def importarRetencionesBancariasSircreb(Cuenta cuenta, FileInputStream inputStream, String nombreArchivo){
		BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))
		boolean primeraVuelta = true
		LogImportacion log = new LogImportacion()
		log.bancaria = true
		log.fechaHora = new LocalDateTime()
		log.responsable = (accessRulesService.currentUser?.username ?: "-")
		log.fecha = new LocalDate()
		log.estado = Estado.findByNombre('Activo')
		log.nombreArchivo = nombreArchivo
		log.cuenta = cuenta
		log.save(flush:true)

		while(reader.ready()) {
			String line = reader.readLine()
			RetencionPercepcionIIBB retencionPercepcion = new RetencionPercepcionIIBB()
			retencionPercepcion.codigo = line[0..2]
			retencionPercepcion.provincia = Provincia.findByCodigoRPB(retencionPercepcion.codigo)
			retencionPercepcion.tipo = 'bancaria'
			retencionPercepcion.cuit = line[3..15].trim()
			String ano = line[16..19]
			String mes = line[21..22]
			retencionPercepcion.fecha = new LocalDate((ano + "-" + mes + "-01"))
			if (primeraVuelta){
				log.fecha = retencionPercepcion.fecha
				// limpiarImportacionAnteriorRP(log)
				primeraVuelta = false
			}
			retencionPercepcion.cbu = line[23..44].trim()
			retencionPercepcion.tipoCuenta = line[45..47].trim()
			retencionPercepcion.monto = new Double(line[48..57].trim().replace(',', '.'))
			retencionPercepcion.origen = "sircreb"
			try {
				cuenta.addToRetPerIIBB(retencionPercepcion)
				log.addToRetPerIIBB(retencionPercepcion)
				if (retencionPercepcion.validate())
					retencionPercepcion.save(flush:true, failOnError:true)
				else{
					println "........Retención duplicada ignorada"
					log.cantidadIgnoradas++	
					cuenta.removeFromRetPerIIBB(retencionPercepcion)
					log.removeFromRetPerIIBB(retencionPercepcion)
				}
			}
			catch(Exception e) {
				println "La rentención ${retencionPercepcion.comprobante} está repetida"
				cuenta.removeFromRetPerIIBB(retencionPercepcion)
				log.cantidadIgnoradas++	
			}
		}
		log.cantidadOk = log.retPerIIBB ? log.retPerIIBB.size() : 0
		cuenta.addToLogs(log).save(flush:true)
		log.save(flush:true)
		return log
	}

	def importarRetencionesConvenio(Cuenta cuenta, FileInputStream inputStream, String origen, String nombreArchivo){
		BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))
		boolean primeraVuelta = true
		LogImportacion log = new LogImportacion()
		log.retencion = true
		log.fechaHora = new LocalDateTime()
		log.responsable = (accessRulesService.currentUser?.username ?: "-")
		log.fecha = new LocalDate()
		log.estado = Estado.findByNombre('Activo')
		log.nombreArchivo = nombreArchivo
		log.cuenta = cuenta
		log.save(flush:true)

		while(reader.ready()) {
			String line = reader.readLine()
			RetencionPercepcionIIBB retencionPercepcion = new RetencionPercepcionIIBB()
			retencionPercepcion.codigo = line[0..2]
			retencionPercepcion.provincia = Provincia.findByCodigoRPB(retencionPercepcion.codigo)
			retencionPercepcion.tipo = 'retencion'
			retencionPercepcion.cuit = line[3..15].trim()
			Integer ano = new Integer( line[22..25] )
			Integer mes = new Integer( line[19..20] )
			Integer dia = new Integer( line[16..17] )
			retencionPercepcion.fecha = new LocalDate(ano,mes,dia)
			if (primeraVuelta){
				log.fecha = new LocalDate(ano,mes,1)
				// limpiarImportacionAnteriorRP(log)
				primeraVuelta = false
			}
			retencionPercepcion.monto = new Double(line[68..78].trim().replace(',', '.'))
			retencionPercepcion.facturaParteA = new Long(line[26..29]).toString()
			retencionPercepcion.facturaParteB = new Long(line[30..45]).toString()
			retencionPercepcion.tipoComprobante = line[46]
			retencionPercepcion.letraComprobante = line[47]
			// retencionPercepcion.comprobante = new Long(line[48..67]).toString()
			retencionPercepcion.comprobante = retencionPercepcion.facturaParteA + retencionPercepcion.facturaParteB
			retencionPercepcion.origen = origen
			try {
				cuenta.addToRetPerIIBB(retencionPercepcion)
				log.addToRetPerIIBB(retencionPercepcion)
				if (retencionPercepcion.validate())
					retencionPercepcion.save(flush:true, failOnError:true)
				else{
					println "........Retención duplicada ignorada"
					log.cantidadIgnoradas++	
					cuenta.removeFromRetPerIIBB(retencionPercepcion)
					log.removeFromRetPerIIBB(retencionPercepcion)
				}
			}
			catch(Exception e) {
				println "La rentención ${retencionPercepcion.comprobante} está repetida"
				cuenta.removeFromRetPerIIBB(retencionPercepcion)
				log.cantidadIgnoradas++	
			}
		}
		log.cantidadOk = log.retPerIIBB ? log.retPerIIBB.size() : 0
		cuenta.addToLogs(log).save(flush:true)
		log.save(flush:true)
		return log
	}

	def importacionFoto(String foto, archivo){
		def cuentaInstance = accessRulesService.getCurrentUser()?.cuenta

		cuentaInstance[foto] = foto

		String cuentaPath = cuentaInstance.getPath()

		String pathFotos = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/fotos/"

		File carpeta = new File(pathFotos)
		if(!carpeta.exists())
			carpeta.mkdirs()

		String fullPath = pathFotos + foto + ".jpg"
		if(new File(fullPath).exists())
			(new File(fullPath)).delete()
		
		archivo.transferTo(new File(fullPath))

		if(cuentaInstance.fotoFrenteDni && cuentaInstance.fotoDorsoDni && cuentaInstance.fotoSelfie/* && cuentaInstance.actionRegistro != "registroCompleto"*/){
			cuentaInstance.ingresoFotosRegistro = true
			if (cuentaInstance.actionRegistro != "registroCompleto"){
				bitrixService.generarTaskAltaMonotributo(cuentaInstance.bitrixId, cuentaInstance.id)
				if(cuentaInstance.bitrixDealId){
					try{
						bitrixService.editarNegociacion(cuentaInstance.bitrixDealId,["fields":["STAGE_ID":"C5:3"]])
					}
					catch(e){
						log.error("Error actualizando stage de Deal a Subio Fotos")
					}
				}
			cuentaInstance.actionRegistro = "registroCompleto"
			}else{
				cuentaService.verificarErroresCorregidos(cuentaInstance.id)
			}
		}
		cuentaInstance.save(flush:true,failOnError:true)
		
		return cuentaInstance

	}

	def importacionComprobante(String tipoEnum, Long cuentaId ,archivo){
		def cuentaInstance = Cuenta.get(cuentaId)
		def comprobanteInstance = new Comprobante()

		String nombreOriginal = comprobanteInstance.nombreArchivo = archivo.originalFilename
		String cuentaPath = cuentaInstance.getPath()
		String path = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/comprobantes/"

		File carpeta = new File(path)
		if(!carpeta.exists())
			carpeta.mkdirs()

		String fullPath = path + nombreOriginal
		int versionArchivo = 0
		comprobanteInstance.tipo = Comprobante.Tipo[tipoEnum]
		while((new File(fullPath)).exists()){
			versionArchivo++
			fullPath = path + nombreOriginal + " (" + versionArchivo.toString() + ")"
		}
		if (versionArchivo>0)
			comprobanteInstance.nombreArchivo += " (" + versionArchivo.toString() + ")"
		archivo.transferTo(new File(fullPath))
		comprobanteInstance.fecha = new LocalDate()
		cuentaInstance.addToComprobantes(comprobanteInstance)
		
		if(cuentaInstance.trabajaConApp() && tipoEnum == "CONSTANCIA_MONOTRIBUTO"){
			cuentaInstance.infoRevisada = true
			cuentaInstance.inscriptoAfip = true
			try{
				bitrixService.editarNegociacion(cuentaInstance.bitrixDealId,["fields":["STAGE_ID":"C5:WON"]])
			}
			catch(e){
				log.error("Error moviendo de stage el deal a Ganada")
			}
		}
		cuentaInstance.save(flush:true,failOnError:true)
		comprobanteInstance.save(flush:true,failOnError:true)

		return comprobanteInstance
	}

	def limpiarImportacionAnteriorRP(LogImportacion logActual){
		LogImportacion.createCriteria().list(){
			and{
				eq('cuenta', logActual.cuenta)
				eq('fecha' , logActual.fecha)
				eq('estado', Estado.findByNombre('Activo'))
				if (logActual.retencion)
					eq('retencion', true)
				else if (logActual.percepcion)
					eq('percepcion', true)
				else if (logActual.bancaria)
					eq('bancaria', true)
				eq('retPerEsIva' , logActual.retPerEsIva)
				if (logActual.provincia)
					eq('provincia' , logActual.provincia)
			}
		}.each{
			if (it.id != logActual.id)
				deleteLogImportacion(it.id)
		}
	}

	LogMercadoPago getLogGerencia(Long id){ LogMercadoPago.get(id) }

	public LogMercadoPago importarDumpMP(LocalDate mesAno, archivo){
		Estado activo = Estado.findByNombre("Activo")
		LogMercadoPago.findByFechaAndEstado(mesAno, activo)?.with{
			estado = Estado.findByNombre("Expirado")
			save(flush:false)
		}
		LogMercadoPago log = new LogMercadoPago(estado: activo, fecha: mesAno, fechaHora: new LocalDateTime(), responsable: (accessRulesService.currentUser?.username ?: "-"))
		/* Declaración de variables */
		boolean dispararMP
		def fila, servicio
		DetalleErroneoMP detalle
		String codigoCalim, estadoMP
		/* Obtengo las listas de pagos en los que buscaré */
		LocalDateTime fechaHoraBusqueda = mesAno.toLocalDateTime(new LocalTime(0,0))
		def pagos = PagoCuenta.createCriteria().list() {
			ge('fechaPago', fechaHoraBusqueda)
			lt('fechaPago', fechaHoraBusqueda.plusMonths(1))
		}
		def leerCatch = {row, index, numerico ->
			try {
				return row.getCell(index).getStringCellValue()
			}
			catch(Exception e) {
				return numerico ? "0" : ""
			}
			
		}
		/* Empiezo a recorrer el archivo */
		def rows = obtenerExcel(archivo,true).rowIterator()
		fila = rows.next () // Salteamos la primera línea con los nombres de columnas
		while (rows.hasNext()){
			log.total ++
			fila = rows.next ()
			/* Leo el excel y guardo en variables */
			detalle = new DetalleErroneoMP(	
										  	fechaHora: leerCatch(fila,0,false),
										  	mailPagante: leerCatch(fila,5,false),
										  	descripcion: leerCatch(fila,9,false),
											notificacionId: new Long(leerCatch(fila,12,true)), 
										  	estado: leerCatch(fila,13,false),
										  	monto: new Double(leerCatch(fila,16,true))
										  )
			codigoCalim = fila.getCell(10).getStringCellValue()
			switch( detalle.estado ) {
			 	case "approved":
			 		estadoMP = 	"Pagado"
			 		break
			 	case "refunded":
			 		estadoMP = 	"Reembolsado"
			 		break
			 	default:
			 		estadoMP = ""
			 }
			/* Busco el servicio dentro de mi lista, según el código */
			if ( ! (codigoCalim.contains("SE") || codigoCalim.contains("SM") || detalle.descripcion == "Servicio CALIM") ){
				log.ignorados ++
				detalle.tipoError = "Ignorado"
				log.addToFallos(detalle)
				continue 
			}
			servicio = pagos.find{it.tieneLaNotificacion(detalle.notificacionId)}
			/* Sumo el importe */
			if (estadoMP == "Pagado")
				log.sumatoriaAcreditados += detalle.monto
			/* Si es necesario, redisparo la notificación */
			dispararMP = true;
			if (!servicio){
				log.faltantes ++
				// println "\nNo se encontró la notif. ${detalle.notificacionId} dentro del rango."
				detalle.tipoError = "No encontrado"
			}
			else if (servicio.importe != detalle.monto){
				log.incorrectos ++
				// println "\nMal importe para ${detalle.notificacionId}: " + servicio.importe + " vs " + detalle.monto
				detalle.tipoError = "Diferente importe"
			}else if ((!estadoMP && servicio.estado.with{nombre == "Pagado" || nombre == "Reembolsado"}) || (estadoMP && estadoMP != servicio.estado.nombre)){
				log.incorrectos ++
				// println "\nMal estado para ${detalle.notificacionId}: " + servicio.estado.nombre + " vs " + detalle.estado
				detalle.tipoError = "Diferente estado"
			}else if (! servicio.notificaciones.find{it.payer?.email == detalle.mailPagante}){
				log.incorrectos ++
				// println "\n La notificación ${detalle.notificacionId} no tenía guardado el mail del cliente."
				detalle.tipoError = "Mail no guardado"
				detalle.logDisparo = "No se hicieron cambios"
				servicio.notificaciones.find{it.payer && ! it.payer.email}?.payer?.with{
					detalle.logDisparo = "Mail actualizado"
					email = detalle.mailPagante
					save(flush:false)
				}
				dispararMP = false;
				detalle.pago = servicio
				detalle.montoSistema = servicio.importe
				detalle.estadoSistema = servicio.estado.nombre
				log.addToFallos(detalle)
			}
			else
				dispararMP = false;
			if (dispararMP){
				if (servicio){
					detalle.pago = servicio
					detalle.montoSistema = servicio.importe
					detalle.estadoSistema = servicio.estado.nombre
				}
				detalle.logDisparo = pagoCuentaService.reconstruirMP(detalle.notificacionId).join("\n")
				log.addToFallos(detalle)
			}
		}
		log.correctos = log.with{total-ignorados-faltantes-incorrectos}
		return log.save(flush:true, failOnError:true)
	}

	def importarCuentasRider(archivo){
		def rows = obtenerExcel(archivo,true).rowIterator()
		def fila = rows.next () // Salteamos la primera línea con los nombres de columnas
		String cRiderId, cNombre, cApellido, cTelefono, cEmail, cCuit
		Contador alejandro = Contador.findByNombreApellido('Alejandro Pavoni')
		Estado activo = Estado.findByNombre('Activo')
		CondicionIva monotributista = CondicionIva.findByNombre("Sin inscribir")
		RegimenIibb simplificado = RegimenIibb.get(16)
		Role rider = Role.findByAuthority('ROLE_RIDER_PY')
		def errores = []
		while (rows.hasNext()){
			fila = rows.next ()
			
			cRiderId = ((Integer) fila.getCell(0).getNumericCellValue()).toString()
			cNombre = fila.getCell(1).getStringCellValue()
			cApellido = fila.getCell(2).getStringCellValue()
			cTelefono = ((Integer) fila.getCell(3).getNumericCellValue()).toString()
			cEmail = fila.getCell(4).getStringCellValue()
			cCuit = ((Integer) fila.getCell(5).getNumericCellValue()).toString()

			try {
				Cuenta nuevaCuenta = new Cuenta().with{
					fechaAlta = new LocalDateTime()
					email = cEmail
					profesion == "app"
					cuit = cCuit
					detalle = "Rider"
					razonSocial = nombreApellido = cNombre + " " + cApellido
					telefono = whatsapp = cTelefono
					riderId = cRiderId
					it.estado = activo
					contador = alejandro
					regimenIibb = simplificado
					condicionIva = monotributista
					save(flush:true, failOnError:true)
				}
				new ItemApp(cuenta:nuevaCuenta, app:App.findByNombre("PedidosYa")).save(flush:true)
				User nuevoUser = new User().with{
					username = cEmail
					password = cRiderId
					accountExpired = false
					accountLocked = false
					passwordExpired = false
					cuenta = nuevaCuenta
					userTenantId = 2
					save(flush:true, failOnError:true)
				}
				UserRole.create(nuevoUser, rider, true)	
				
				NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Email Registro Rider")
				String url = UsuarioService.getLinkResetPassword(nuevoUser)
				String urlNotificaciones = UsuarioService.getLinkDesactivarNotificaciones(nuevoUser)
				String bodyMail = plantilla.llenarVariablesBody([url,urlNotificaciones, cNombre])
				notificacionService.enviarEmail(nuevoUser.username, plantilla.llenarVariablesAsunto([cNombre]), bodyMail, 'registroRider', null, plantilla.tituloApp, plantilla.textoApp)
			}
			catch(Exception e) {
				log.error("Error importando cuenta Rider PedidosYa:\n" + e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				errores << [id:cRiderId, nombre: cNombre + " " + cApellido, cuit: cCuit]
			}
		}
		return errores;
	}

	def parsearPdfPedidosYa(archivo, Long proformaId){
		def parseo;
		try {
			String boundary = Long.toHexString(System.currentTimeMillis()); // Just generate some unique random value.
			String CRLF = "\r\n"; // Line separator required by multipart/form-data.

			URLConnection connection = new URL("http://core.xpenser.io/parser").openConnection();
			connection.setDoOutput(true);
			connection.setRequestProperty ("Authorization", 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkaWVnb0BicmFzaWwuY29tIiwiaWF0IjoxNjA4MjQyODc1fQ.o-GrCf8Tc4lbGWUnqFOVrdb4l_7nWacSmAmKA8qXToI');
			connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);

		    OutputStream output = connection.getOutputStream();
		    PrintWriter writer = new PrintWriter(new OutputStreamWriter(output, "UTF-8"), true);
		    writer.append("--" + boundary).append(CRLF);
		    writer.append("Content-Disposition: form-data; name=\"file\"; filename=\"" + archivo.getOriginalFilename() + "\"").append(CRLF);
		    writer.append("Content-Type: " + URLConnection.guessContentTypeFromName(archivo.getOriginalFilename())).append(CRLF);
		    writer.append("Content-Transfer-Encoding: binary").append(CRLF);
		    writer.append(CRLF).flush();
		    output.write(archivo.getBytes())
		    output.flush(); // Important before continuing with writer!
		    writer.append(CRLF).flush(); // CRLF is important! It indicates end of boundary.
		    writer.append("--" + boundary + "--").append(CRLF).flush();

		    // Request is lazily fired whenever you need to obtain information about response.
		    parseo = new groovy.json.JsonSlurper().parseText(((HttpURLConnection) connection).getInputStream().getText())
		}
		catch(Exception e) {
			assert false : "El archivo ingresado es inválido.finerror"	
		}

		Proforma proforma = Proforma.get(proformaId)
		FacturaVenta facturaNueva
		Cuenta cuentaActual = accessRulesService.currentUser.cuenta;
		Persona pedidosYa = Persona.findByCuit("30711985766")
		assert pedidosYa.cuit == parseo.dest_tax_code : "El CUIT receptor de a factura no corresponde a PedidosYa.finerror"
		assert cuentaActual.cuit == parseo.sender_tax_code : "El CUIT emisor de a factura no corresponde al de la cuenta actual.finerror"
		facturaNueva = new FacturaVenta().with{
			fecha = new LocalDate(parseo.invoice_date)
			assert fecha.withDayOfWeek(1) == proforma.fecha : "La fecha de facturación no corresponde a la semana actual.finerror"
			numero = new Long(parseo.invoice_number)
			Long numeroPdV = new Long(parseo.point_of_sale_number)
			puntoVenta = cuentaActual.puntosDeVenta?.find{it.numero == numeroPdV} ?: new PuntoVenta(cuenta: cuentaActual, numero: numeroPdV).save(flush:true)
			tipoComprobante = TipoComprobante.findByCodigoAfip(new Long(parseo.invoice_type_code).toString())
			concepto = TipoConcepto.findByNombre('Servicio')
			// periodoFacturadoDesde = proforma.fecha.minusWeeks(1)
			// periodoFacturadoHasta = proforma.fecha
			// periodoFacturadoVencimientoPago = proforma.fecha.plusWeeks(1)
			cliente = pedidosYa
			neto = parseo.amount_before_tax
			total = parseo.amount_total
			assert total == proforma.importe : "El monto facturado no se corresponde con lo solicitado.finerror"
			iva = total - neto
			importado = true
			bienImportado = true
			cae = parseo.invoice_electronic_auth_number
			assert !!cae : "La factura no tiene CAE.finerror"
			vencimientoCae = new LocalDate(parseo.invoice_electronic_auth_due_date)
			// fechaInicioServicios = periodoFacturadoDesde
			// fechaFinServicios = periodoFacturadoHasta
			// fechaVencimientoPagoServicio = periodoFacturadoVencimientoPago
			cuenta = cuentaActual
			return it
		}
		guardarArchivo(facturaNueva, archivo).save(flush:true,failOnError:true)
		
		proforma.with{
			ultimaSubida = new LocalDateTime()
			factura = facturaNueva
			nombreArchivo = factura.nombreArchivo
			estado = Proforma.Estados.VERIFICADA
			save(flush:true)
		}
	}

	def guardarArchivo(instance,  archivo){
		String nombreOriginal = instance.nombreArchivo = archivo.originalFilename
		String cuentaPath = instance.cuenta.getPath()
		String path = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/facturasVenta/"

		File carpeta = new File(path)
		if(!carpeta.exists())
			carpeta.mkdirs()

		String fullPath = path + nombreOriginal
		int versionArchivo = 0
		while((new File(fullPath)).exists()){
			versionArchivo++
			fullPath = path + nombreOriginal + " (" + versionArchivo.toString() + ")"
		}
		if (versionArchivo>0)
			instance.nombreArchivo += " (" + versionArchivo.toString() + ")"
		archivo.transferTo(new File(fullPath))

		return instance
	}
 
	def ajusteConvenio(archivo, LocalDate mes, Long cuentaId) throws AssertionError{
		def filas = obtenerExcel(archivo,true).rowIterator()
		def primeraFila = filas.next()
		def distribucion = [:]
		// Reviso de la primera fila si los headers coinciden con nuestra plantilla. De ser así, uso esa importación.
		if (primeraFila.getCell(0).getStringCellValue() == "Provincia" && primeraFila.getCell(1).getStringCellValue() == "Venta Total")
			distribucion = ajusteConvenioPlantilla(filas)
		// Si no coincide con nuestra plantilla, estamos ante el excel de mercadolibre.
		else
			distribucion = ajusteConvenioMercadoLibre(filas, mes)
		try {
			liquidacionIIBBService.liquidacionAutomatica(mes.toString("MM"),mes.toString("yyyy"),cuentaId,distribucion)
		}
		catch(Exception e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			assert false: "Error liquidandofinerror"
		}
		try {
			guardarArchivo(new ArchivoConvenio(fecha:mes,cuenta:Cuenta.get(cuentaId)), archivo).save(flush:true)
		}
		catch(Exception e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		
	}

	private ajusteConvenioMercadoLibre(rowIterator, LocalDate mes) throws AssertionError{
		LocalDate fecha
		Double importe
		DateTimeFormatter dtf = DateTimeFormat.forPattern("ddMMMMyyyy").withLocale(new Locale("es", "ARG"));
		def sumatoria = [:]
		Double total = 0
		def fila
		while (rowIterator.hasNext()){
			fila = rowIterator.next ()
			/* Leo el excel y guardo en variables */
			try {
				fecha = dtf.parseLocalDate(fila.getCell(1).getStringCellValue().split().with{it[0] + it[2] + it[4]})
				importe = fila.getCell(6).getNumericCellValue()
			}
			catch(Exception e) {
				// println "Ignoramos fila porque el importe está vacío o la fecha es inválida"
				continue
			}
			String provincia = fila.getCell(23).getStringCellValue()
			if (provincia.allWhitespace || fecha.with{it.year != mes.year || it.monthOfYear != mes.monthOfYear}){
				// println "Ignoramos fila porque la provincia está vacía"
				continue
			}
			if (provincia == "Capital Federal")
				provincia = "CABA"
			sumatoria[provincia] = (sumatoria[provincia] ?: 0) + importe
			total += importe
		}
		assert total : "No hay facturas para el periodo ${mes.toString('MM/yyyy')} en el archivo ingresadofinerror"
		return sumatoria
	}

	private ajusteConvenioPlantilla(rowIterator){
		println "Detectamos que es la plantilla excel"
		def salida = [:]
		def renglon
		while (rowIterator.hasNext()){
			renglon = rowIterator.next()
			salida[renglon.getCell(0).getStringCellValue()] = renglon.getCell(1).getNumericCellValue()
		}
		return salida
	}
}