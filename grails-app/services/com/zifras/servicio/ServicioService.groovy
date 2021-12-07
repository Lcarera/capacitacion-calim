package com.zifras.servicio

import static com.zifras.inicializacion.JsonInicializacion.formatear

import com.zifras.AccessRulesService
import com.zifras.BitrixService
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.GoogleAPIService
import com.zifras.TokenGoogle
import com.zifras.User
import com.zifras.UsuarioService
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.cuenta.MoratoriaService
import com.zifras.cuenta.VencimientoAutonomo
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.FacturaCuentaService
import com.zifras.documento.PagoCuenta
import com.zifras.documento.PagoCuentaService
import com.zifras.documento.VencimientoVep
import com.zifras.documento.Vep
import com.zifras.facturacion.AlicuotaIva
import com.zifras.notificacion.ConsultaWeb
import com.zifras.notificacion.NotificacionService
import com.zifras.notificacion.NotificacionTemplate

import static org.apache.poi.ss.usermodel.Cell.*
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.ss.usermodel.Cell
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.xssf.usermodel.XSSFSheet
import org.apache.poi.poifs.filesystem.POIFSFileSystem
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.apache.poi.ss.usermodel.CellStyle
import org.apache.poi.ss.usermodel.Font

import grails.transaction.Transactional
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.LocalTime
import org.joda.time.format.DateTimeFormat

@Transactional
class ServicioService {
	AccessRulesService accessRulesService
	CuentaService cuentaService
	FacturaCuentaService facturaCuentaService
	NotificacionService notificacionService
	PagoCuentaService pagoCuentaService
	UsuarioService usuarioService
	MoratoriaService moratoriaService
	def googleAPIService
	def bitrixService

	def listServiciosEspeciales() { Servicio.findAllByMensualAndActivo(false, true).sort{it.id}.reverse().unique{it.codigo}.sort{it.codigo} }

	def listServiciosMensuales() { Servicio.findAllByMensualAndActivo(true, true).sort{it.id}.reverse().unique{it.codigo}.sort{it.codigo} }

	def listServicios() { Servicio.findAllByActivo(true) }

	def listCobranza(String filtro, LocalDate fecha, Boolean esMensual) {
		def items = []
		// if (esMensual)
		// 	fecha = fecha.withDayOfMonth(Estudio.get(2).diaFacturacionMensual).plusDays(6)

		LocalDateTime inicioMes = fecha.toLocalDateTime(new LocalTime(0,0)).withDayOfMonth(1)
		LocalDateTime finMes = inicioMes.plusMonths(1)
		// LocalDateTime fechaHoraBusqueda = fecha.toLocalDateTime(new LocalTime(0,0))
		def listaFacturas = FacturaCuenta.createCriteria().list() { // Obtengo las facturas emitidas dentro del periodo
			ge('fechaHora', inicioMes)
			lt('fechaHora', finMes)
			if (esMensual)
				isNotNull('itemMensual')
			else
				isNull('itemMensual')
		}
		// fecha = fecha.withDayOfMonth(1) // A la hora de ver las pagadas, busco por mes y no por mes corrido
		PagoCuenta.createCriteria().list() { // Obtengo las facturas pagadas dentro del periodo y las agrego a la lista anterior
			eq('estado', Estado.findByNombre("Pagado"))
			ge('fechaPago', inicioMes)
			lt('fechaPago', finMes)
		}?.each{
			it.facturas.each{
				if (it.mensual == esMensual && ! listaFacturas.contains(it))
					listaFacturas << it
			}
		}
		def servicios = []
		listaFacturas.each{ facturaBuscada ->
			facturaBuscada.items.each{
				if (! filtro || it.servicio.codigo == filtro){
					def resultado = [:]
					resultado['codigo'] = it.servicio.codigo
					resultado['servicioNombre'] = it.servicio.nombre
					resultado['servicio'] = resultado.with{codigo + " - " + servicioNombre}
					resultado['subcodigo'] = it.servicio.subcodigo
					resultado['cuenta'] = it.cuenta.toString()
					resultado['responsable'] = it.responsable
					resultado['cuentaId'] = it.cuenta.id
					resultado['precioCrudo'] = resultado['cobradoCrudo'] = 0
					resultado['profesion'] = it.cuenta.profesion
					resultado['pagado'] = false
					resultado['precio'] = resultado['precioMP'] = resultado['fechaFactura'] = resultado['fechaPago'] = resultado['avisos'] = resultado['cae'] = resultado['mailMP'] = resultado['nombreMP'] = "-"
					resultado['primerSM'] = facturaBuscada.esPrimerSM() ? "Sí" : "No"
					facturaBuscada?.with{
						resultado['precioMP'] = formatear(importe)
						resultado['codigoMP'] = it.movimiento?.movimientoMPId ?: '-'
						resultado['precioCrudo'] = importe / (itemsEspeciales?.size() ?: 1)
						resultado['precio'] = formatear(resultado['precioCrudo'])
						resultado['cobradoCrudo'] = pagada ? (importe/(itemsEspeciales?.size()?:1)) : 0
						resultado['pagado'] = pagada
						resultado['fechaFactura'] = fechaHora.toString("dd/MM/yyyy")
						movimiento?.pago?.with{
							resultado['fechaPago'] = fechaPago.toString("dd/MM/yyyy")
							resultado['mailMP'] = mailMP ?: "-"
							resultado['nombreMP'] = nombreMP ?: "-"
						}
						resultado['avisos'] = cantidadAvisos
						resultado['cae'] = cae ? "Nro. " +  numero + " CAE " + cae : "Fact. Sin Cae"
					}
					items << resultado
					def servicio = servicios.find{it.codigo == resultado.codigo}
					if (! servicio){
						servicio = [codigo:resultado.codigo, nombre: resultado.servicioNombre, pagados:0, pagadosAtrasados:0, emitidos:0]
						if (resultado.codigo == filtro)
							servicio.filtrar = """<a onclick="redirigir('')" href="#" class="m-0 text-uppercase d-inline-block" style="color: #8B0000">Quitar</a>"""
						else
							servicio.filtrar = """<a onclick="redirigir('${resultado.codigo}')" href="#" class="m-0 text-uppercase d-inline-block">Filtrar</a>"""
						servicios << servicio
					}
					if (facturaBuscada.fechaHora >= inicioMes && facturaBuscada.fechaHora < finMes)
						servicio.emitidos++
					else
						servicio.pagadosAtrasados++
					if (resultado.pagado)
						servicio.pagados++
				}
			}
		}
		// unifico con el otro
		def salida = [:]
		salida.items = items
		salida.servicios = servicios
		return salida
	}

	/*def obtenerCantidadClientesServicio(LocalDate fecha, Boolean mensual) {
		def respuesta = []
		def servicios
		if (mensual){
			fecha = fecha.withDayOfMonth(Estudio.get(2).diaFacturacionMensual)
			servicios = ItemServicioMensual.createCriteria().list() {
				le('fechaAlta', fecha.plusDays(5)) // Hacer menos 1 mes??
				or{
					isNull('fechaBaja')
					gt('fechaBaja', fecha)
				}
			}
		}else
			servicios = ItemServicioEspecial.createCriteria().list() {
				ge('fechaAlta', fecha)
				le('fechaAlta', fecha.plusMonths(1))
			}

		Servicio.findAllByMensualAndActivo(mensual, true).collect{[it.codigo, it.nombre]}.sort{it[0]}.unique{it[0]}.each{ cod, nom ->
			def item = [:]
			item['codigo'] = cod
			item['nombre'] = nom
			def serviciosFiltrados = servicios.findAll{ it.servicio.codigo == cod }
			item['cantidad'] = serviciosFiltrados.size()
			if (mensual)
				item['pagados'] = serviciosFiltrados.findAll{it.getMesPagado(fecha)}.size()
			else
				item['pagados'] = serviciosFiltrados.findAll{it.factura?.pagada}.size()
			respuesta << item
		}

		return respuesta
	}*/

	def createServicioCommand() { new ServicioCommand() }

	def getServicioCommand(Long id) {
		def servicio = Servicio.get(id)
		return servicio ? pasarDatos(servicio, createServicioCommand(), true) : null
	}

	def saveServicio(ServicioCommand command){ pasarDatos(command, new Servicio()).save(flush:true) }

	def updateServicio(ServicioCommand command){
		Servicio servicioInstance = Servicio.get(command.servicioId)
		assert !(command.version && servicioInstance.version > command.version) : "Mientras usted editaba, otro usuario ha actualizado el serviciofinerror"
		pasarDatos(command, servicioInstance).save(flush:true)
	}

	def getServicios(ids) {
		def respuesta = []
		([Collection, Object[]].any { it.isAssignableFrom(ids.getClass()) } ? ids : [ids]).each {
			Servicio servicio = Servicio.get(it)
			if (servicio)
				respuesta.push(servicio)
		}
		return respuesta
	}

	def listEspecialesCuenta(Long cuentaId){ Cuenta.get(cuentaId)?.serviciosEspeciales ?: [] }

	def listMensualesCuenta(Long cuentaId){ Cuenta.get(cuentaId)?.serviciosMensuales ?: [] }

	def pagarServiciosEspeciales() {
		def items = ItemServicioEspecial.findAllByFechaAltaAndFactura(new LocalDate(), null)
		items.collect {
			it.cuenta.id
		}.unique().each {
			cuentaId ->
				def filtroPorCuenta = items.findAll {
					item -> item.cuenta.id == cuentaId
				}
			if (filtroPorCuenta){
				println "\nFacturando servicio Especial para ${filtroPorCuenta[0].cuenta} ...\n"
				facturaCuentaService.generarPorItemsServicio(filtroPorCuenta)
			}
		}
	}

	def adelantarCuotaEspecial(Long itemId){
		ItemServicioEspecial item = ItemServicioEspecial.get(itemId)
		item.fechaAlta = new LocalDate()
		item.save(flush:true, failOnError:true)
		facturaCuentaService.generarPorItemsServicio([item])
	}

	def pagarServiciosMensuales() {
		LocalDate hoy = new LocalDate()
		LocalDate mesProximo = hoy.plusMonths(1)
		def cuentasVencidas = []
		def errores = []
		ItemServicioMensual.createCriteria().list() {
			or {
				isNull('fechaBaja')
				gt('fechaBaja', hoy)
			}
		}?.findAll {it.vigente}?.each {
			if (!it.mesFacturado) {
				println "\nFacturando servicio Mensual de \$${it.precio} para ${it.cuenta} ...\n"
				try {
					facturaCuentaService.generarPorItemsServicio([it],!it.cuenta.tarjetaDebitoAutomatico)
				}
				catch(Exception e) {
					println "Error generando pago para ${it.cuenta}:"
					log.error(e.message)
					println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
					errores << it.cuenta
				}
				
				if (!it.periodoAplica(mesProximo))
					cuentasVencidas << it.cuenta
			}
		}
		String detalleVencidas = cuentasVencidas?.findAll{! it.getServicioPorFecha(mesProximo)}?.collect{"-<a href='https://app.calim.com.ar/cuenta/servicios/${it.id}'>$it</a> (tenía servicio ${it.servicioActivo})"}?.join("<br/>")
		String detalleErrores = errores?.join("<br/>")
		String cuerpoMail = "El servicio de las siguientes cuentas expiró, y no tienen ninguno activo para facturar el mes próximo:<br/><br/>" + (detalleVencidas ?: "-")
		cuerpoMail += "<br/><br/>Las siguientes cuentas tuvieron errores:<br/>" + (detalleErrores ?: "-")
		notificacionService.enviarEmailInterno("info@calim.com.ar", "Servicios Mensuales Expirados", cuerpoMail, 'avisoInternoVencimiento')
		notificacionService.enviarEmailInterno("samanta@calim.com.ar", "Servicios Mensuales Expirados", cuerpoMail, 'avisoInternoVencimiento')
		notificacionService.enviarEmailInterno("franco@calim.com.ar", "Servicios Mensuales Expirados", cuerpoMail, 'avisoInternoVencimiento')
	}

	def enviarRecordatoriosMensuales(Integer numeroAviso, Integer diferenciaAvisoDias){
		String mes = new LocalDate().minusMonths(1).toString("MMMM",new java.util.Locale('ES'))
		LocalDateTime diaFacturaInicio = new LocalDateTime().minusDays(diferenciaAvisoDias).withHourOfDay(0).withMinuteOfHour(0).withSecondOfMinute(0)
		LocalDateTime diaFacturaFin = diaFacturaInicio.withHourOfDay(23).withMinuteOfHour(59).withSecondOfMinute(59)
		FacturaCuenta.createCriteria().list() {
			and{
				ge('fechaHora', diaFacturaInicio)
				le('fechaHora', diaFacturaFin)
			}
		}.findAll{it.cantidadAvisos != numeroAviso && it.itemMensual && !it.pagada && !it.debitoAutomatico && it.cuenta.with{estado.nombre == "Activo" && primeraFacturaSMPaga}}.each{
			it.with{
				cantidadAvisos = numeroAviso
				save(flush:true, failOnError:true)
			}
			User usuario = User.findByCuenta(it.cuenta)
			String linkPago = pagoCuentaService.generarLinkPago(it.movimiento.id, usuario)
			String importe = formatear(it.importe)
			String nombre = it.cuenta.nombreApellido.split()[0].capitalize()
			String linkNotif = usuarioService.getLinkDesactivarNotificaciones(usuario)
			def plantilla
			if(it.cuenta.trabajaConApp())
				plantilla = NotificacionTemplate.findByNombre("Factura Cuenta Aviso "+numeroAviso+" App")
			else
				plantilla = NotificacionTemplate.findByNombre("Factura Cuenta Aviso "+numeroAviso)
			String bodyMail = plantilla.llenarVariablesBody([nombre,mes,importe,linkPago,linkNotif])
			String asunto = numeroAviso == 2 ? plantilla.llenarVariablesAsunto([nombre,mes]) : plantilla.llenarVariablesAsunto([nombre])
			
			notificacionService.enviarEmail(usuario.username, asunto, bodyMail, 'aviso' + numeroAviso + 'Factura', null, plantilla.tituloApp, plantilla.textoApp)
		}
	}

	def enviarRecordatoriosMoratoria(String aviso){

		def estadoActivo = Estado.findByNombre("Activo")
		String linkNotif
		String nombre
		String importeCuota
		User usuario 
		def plantilla
		Cuenta.createCriteria().list(){
			eq('estado', estadoActivo)
		}.findAll{it.poseePlanMoratoriaAbierto()}.each{
			usuario = User.findByCuenta(it)
			linkNotif = usuarioService.getLinkDesactivarNotificaciones(usuario)
			nombre = it.nombreApellido.split()[0].capitalize()
			importeCuota = it.cuotaMoratoriaAPagar().importe
			numeroCuota = it.cuotaMoratoriaAPagar().numero


			if(aviso=="primerAviso"){
				if(it.noTieneServicioMensual)
					plantilla = NotificacionTemplate.findByNombre("Recordatorio Moratoria")
				else
					plantilla = NotificacionTemplate.findByNombre("Recordatorio Moratoria Usuarios Calim")
			}
			else
				plantilla = NotificacionTemplate.findByNombre("Recordatorio Moratoria Segundo Aviso") // HACEMOS UNO PARA LOS NO USUARIOS TAMBIEN???

			String bodyMail = plantilla.llenarVariablesBody([nombre,numeroCuota,importeCuota,linkNotif])
		//	String asunto = plantilla.llenarVariablesAsunto([VARIABLES ASUNTO])

			notificacionService.enviarEmail(usuario.username, asunto, bodyMail, 'Recordatorio Moratoria', null, plantilla.tituloApp, plantilla.textoApp)
		}
	}

	def cerrarMoratoriasVencidas(){
		moratoriaService.cerrarPlanesVencidos()
	}

	def enviarRecordatoriosCondicionIVA(String nombrePlantilla, String condicion, Integer dia){
		def fecha = new LocalDate()
		def ano = new Integer(new LocalDate().toString("YYYY"))
		def mes = new Integer(new LocalDate().toString("MM"))
		def estado = Estado.findByNombre("Activo")
		def cuentas = Cuenta.createCriteria().list(){
			eq('estado',estado)
		}.findAll{it.condicionIva?.nombre == condicion && it.servicioActivo}
		def usuario
		def bodyMail
		def plantilla = NotificacionTemplate.findByNombre(nombrePlantilla)
		String nombre
		String linkNotif
		def tituloApp
		def asunto
		LocalDateTime fechaProgramada = new LocalDateTime()
		Integer diaFacturacion

		cuentas.each{
			usuario = User.findByCuenta(it)
			linkNotif = usuarioService.getLinkDesactivarNotificaciones(usuario)
			nombre = it.nombreApellido.split()[0].capitalize()
			diaFacturacion = condicion == "Monotributista" ? dia : VencimientoAutonomo.findByAnoAndMesAndTerminacionCuit(ano,mes,it.terminacionCuit()).dia
			bodyMail = plantilla.llenarVariablesBody([nombre,fecha.withDayOfMonth(diaFacturacion).toString("dd/MM"),linkNotif])
			asunto = plantilla.llenarVariablesAsunto([nombre])
			tituloApp = plantilla.llenarVariablesTituloApp([nombre])

			if(condicion == "Monotributista")
				notificacionService.enviarEmail(usuario.username, asunto, bodyMail, 'recordatorio', null, tituloApp, plantilla.textoApp)
			else
				notificacionService.enviarEmail(usuario.username, asunto, bodyMail, 'recordatorio', fechaProgramada.withDayOfMonth(diaFacturacion - 1), tituloApp, plantilla.textoApp)
		}
	}

	def enviarRecordatoriosVencimientoVep(){
		LocalDate hoy = new LocalDate()
		def veps = Vep.createCriteria().list() {
			ge('fechaEmision', hoy.minusMonths(5).withDayOfMonth(1))
		}.findAll{it -> it.vencimientoSimplificado.isEqual(hoy)}

		def plantilla = NotificacionTemplate.findByNombre("Aviso Vencimiento Regimen Simplificado")
		def nombre
		def bodyMail
		def usuario
		def periodo
		def asunto
		def tituloApp

		vencenHoy.each{
			usuario = User.findByCuenta(it.cuenta)
			nombre = it.cuenta.nombreApellido.split()[0]
			periodo = it.periodo
			bodyMail = plantilla.llenarVariablesBody([nombre,periodo])
			asunto = plantilla.llenarVariablesAsunto([nombre])
			tituloApp = plantilla.llenarVariablesTituloApp([nombre])

			notificacionService.enviarEmail(usuario.username, asunto, bodyMail, 'recordatorio', null, tituloApp, plantilla.textoApp)
		}

	}

	def enviarRecordatoriosFacturacionApp(){
		LocalDateTime diaFacturaInicio = new LocalDateTime()
		def trabajadoresApp = Cuenta.findAllByProfesion("app")
		
		//-DIF ENTRE FACTURA VENTA Y FACTURA CUENTA, Y CON CUAL SE DEBE TRABAJAR EN ESTE CASO (QUE ESTE PENDIENTE DE CREACION *F VENTA* O PENDIENTE DE PAGO *F CUENTA*)
		//-CUANTAS VECES DEBEN FACTURAR LOS RAPPI?? EN QUE FECHA??

		//-ACORDAR LAS FECHAS QUE SE PONEN EN LA CREACION DE FACTURA APP PARA QUE SE PUEDA TRABAJAR CONSISTENTEMENTE ACA
		//-CUANDO SE COMIENZAN A ENVIAR LOS RECORDATORIOS??? CADA CUANTO SE SIGUEN MANDANDO??
	}

	def pasarDatos(origen, destino, Boolean destinoEsCommand = false) {
		destino.with {
			nombre = origen.nombre
			codigo = origen.codigo
			subcodigo = origen.subcodigo
			mensual = origen.mensual
			if (destinoEsCommand) {
				precio = origen.precio
				servicioId = origen.id
				alicuotaId = origen.precioServicio.alicuota.id
				version = origen.version
			}
			else {
				if (precioServicio.with{ precio != origen.precio || alicuota.id != origen.alicuotaId }){
					LocalDate hoy = new LocalDate()
					AlicuotaIva nuevaAlicuota = AlicuotaIva.get(origen.alicuotaId)
					PrecioServicio precioRepetido = precios.find{it.fecha == hoy}
					if (precioRepetido){
						precioRepetido.precio = origen.precio
						precioRepetido.alicuota = nuevaAlicuota
						precioRepetido.save(flush:true)
					}else
						addToPrecios(new PrecioServicio(precio: origen.precio, alicuota: nuevaAlicuota, fecha: hoy))
				}
			}
			return it
		}
	}

	def adherirEspecial(servicios, Double importe, Integer cuotas, String comentarioServicio, String fechaString, Long cuentaId){
		LocalDate fecha = DateTimeFormat.forPattern("dd/MM/yyyy").parseLocalDate(fechaString)
		LocalDate hoy = new LocalDate()
		Cuenta cuentaInstance = Cuenta.get(cuentaId)
		cuotas = cuotas ?: 1
		if (servicios){
			def listaServicios = ([Collection, Object[]].any { it.isAssignableFrom(servicios.getClass()) } ? servicios : [servicios]).collect{Servicio.get(it)}
			Double totalLista = listaServicios.sum{it.precio}
			Double descuentoMultiplicador = 1 - (importe - totalLista) * (-1) / totalLista

			def listaItems = []
			def serviciosBitrix = []
			
			listaServicios.each{
				Servicio servicioInstance = it
				Double descuentoProfesion = 1 - (cuentaInstance.obtenerDescuentoProfesion(servicioInstance.codigo) / 100)
				def item = [:]
				item.codigo = it.codigo
				item.nombre = it.nombre
				item.precio = it.precio * descuentoProfesion * descuentoMultiplicador 
				serviciosBitrix << item
				//Double descuentoCodigo = cuentaInstance.codigoDescuentoActivo() ? (1 - (cuentaInstance.codigoDescuentoActivo()?.obtenerDescuentoServicio(servicioInstance.codigo) / 100) : 1
				for (i in 	0..< cuotas){
					listaItems << new ItemServicioEspecial().with{
						vendedor = accessRulesService.currentUser?.vendedor
						if (! vendedor)
							responsable = accessRulesService.currentUser?.username
						servicio = servicioInstance
						cuota = i + 1
						totalCuotas = cuotas
						cuenta = cuentaInstance
						precio = (servicioInstance.precio * descuentoProfesion * descuentoMultiplicador / cuotas).round(2)
						//precio = (servicioInstance.precio * descuentoMultiplicador / cuotas).round(2)
						fechaAlta = fecha.plusMonths(i)
						comentario = comentarioServicio
						save(flush:true, failOnError:true)
					}
				}
			}
				if(cuentaInstance.bitrixDealId){
					try{
							Thread.start{
								Servicio.withNewSession{session ->
									bitrixService.agregarProductosDeal(cuentaInstance.bitrixDealId, cuentaInstance.bitrixId, serviciosBitrix, accessRulesService.currentUser?.vendedor?.email ?: accessRulesService.currentUser?.username)
								}
							}
					}
					catch(e){
						log.error(e.message)
						log.error("No se pudo agregar el/los productos" + serviciosBitrix + "al deal")
					}
				}
			
			def pagarHoy = listaItems.findAll{it.fechaAlta == hoy}
			if (pagarHoy)
				facturaCuentaService.generarPorItemsServicio(pagarHoy)
		}
	}

	def adherirMensual(Long servicioId, Double descuentoInput , Long cuentaId, int periodos, Boolean debitoAutom, String fechaAltaString){
		Servicio servicioInstance = Servicio.get(servicioId)
		LocalDate fechaAltaInput = DateTimeFormat.forPattern("dd/MM/yyyy").parseLocalDate(fechaAltaString)
		Cuenta cuentaInstance = Cuenta.get(cuentaId)
		adherirMensual(servicioInstance, descuentoInput , cuentaInstance, periodos, debitoAutom, fechaAltaInput, true, null)
	}

	def adherirMensual(Servicio servicioInstance, Double descuentoInput , Cuenta cuentaInstance, int periodos, Boolean debitoAutom, LocalDate fechaAltaInput, Boolean facturar, String resp){
		LocalDate hoy = new LocalDate()
		int diaFacturacion = Estudio.get(2).diaFacturacionMensual
		assert 0 <= descuentoInput : "El descuento debe ser mayor o igual a cerofinerror"
		assert 100 >= descuentoInput : "El descuento debe ser menor o igual a cienfinerror"
		assert hoy <= fechaAltaInput : "No puede elegir fecha alta en el pasadofinerror"
		Double descuentoProfesion = cuentaInstance.obtenerDescuentoProfesion(servicioInstance.codigo)
		//Double descuentoCodigo = cuentaInstance.codigoDescuentoActivo() ? cuentaInstance.codigoDescuentoActivo()?.obtenerDescuentoServicio(servicioInstance.codigo) : 0
		assert ! cuentaInstance.serviciosMensuales.find{it.fechaAlta > fechaAltaInput} : "Ya existe un servicio con fecha de alta posterior a la seleccionadafinerror"
		cuentaInstance.servicioActivo?.with{
			LocalDate fechaFacturacion = fechaAlta.withDayOfMonth(diaFacturacion)
			if (!facturas){
				if (fechaAlta < fechaFacturacion) {
					if (fechaAltaInput < fechaFacturacion)
						assert false: "El alta de este servicio anularía el anterior antes de que produzca facturasfinerror"
				} else
					if (fechaAltaInput < fechaFacturacion.plusMonths(1))
						assert false: "El alta de este servicio anularía el anterior antes de que produzca facturasfinerror"
			}
			fechaBaja = fechaAltaInput
			save(flush:false, failOnError:true)
		}
		def item = new ItemServicioMensual().with{
			vendedor = accessRulesService.currentUser?.vendedor
				if (! vendedor){
					if(resp)
						responsable = resp
					else
						responsable = accessRulesService.currentUser?.username
				}
			servicio = servicioInstance
			cuenta = cuentaInstance
			descuento = descuentoInput >= descuentoProfesion ? descuentoInput : descuentoProfesion
			//descuento = descuentoInput
			fechaAlta = fechaAltaInput
			debitoAutomatico = debitoAutom
			if (periodos)
				fechaBaja = fechaAlta.plusMonths(periodos)
			save(flush:true, failOnError:true)
		}

		// Facturo por adelantado el primer mes:
		if (facturar){
			String linkPago
			if (hoy.plusMonths(1) > fechaAltaInput/* && cuentaInstance.serviciosMensuales.size() == 0*/){ // Sólo si falta menos de un mes para la fecha de alta/*, y además es su primer SM*/
				LocalDate fechaFacturacion = fechaAltaInput.withDayOfMonth(diaFacturacion)
				linkPago = facturaCuentaService.facturarItemMensualAdelantado(item, fechaAltaInput, fechaAltaInput <= fechaFacturacion.plusDays(5))?.linkPago
			}
			return linkPago
		}else{
			return item
		}
	}

	def deleteItemServicio(Long id){
		return ItemServicioEspecial.get(id).with{
			if (it){
				def cuentaId = cuenta.id
				if (factura)
					facturaCuentaService.deleteFacturaCuenta(factura.id)
				else
					delete(flush:true)
				return cuentaId
			}else{
				return ItemServicioMensual.get(id)?.with{
					def cuentaId = cuenta.id
					if (facturas){
						fechaBaja = new LocalDate()
						save(flush:true)
					}else
						delete(flush:true)
					return cuentaId
				}
			}
		}
	}

	def deleteServicio(Long id){
		Servicio.get(id)?.with{
			String nombreSalida = it.toString()
			if (items){
				assert ! (mensual && items.find{it.fechaBaja == null}) : 'El servicio está adherido a las cuentas ' + items.collect{it.cuenta.toString()} + 'finerror'
				activo = false
				save(flush:true, failOnError:true)
			}
			else
				delete(flush:true, failOnError:true)
			return nombreSalida
		}
	}

	def eliminarContactosGoogleAntiguos(){
		try{
			println "Comienza borrado de contactos Google"
			googleAPIService.borrarContactosAntiguos(TokenGoogle.findByUsuario("Cuenta Contactos Maria").refreshToken) 
			googleAPIService.borrarContactosAntiguos(TokenGoogle.findByUsuario("Cuenta Contactos Gonzalo").refreshToken)
			googleAPIService.borrarContactosAntiguos(TokenGoogle.findByUsuario("Cuenta Contactos Juan").refreshToken) //actualmente se borran 4500 contactos 1500*3 
			println "CONTACTOS GOOGLE ANTIGUOS BORRADOS CORRECTAMENTE"
		}
		catch(e){
			println "Ocurrio un error borrando los contactos antiguos"
		}
	}

	def generarDealsAvisoCobranza(){
		LocalDateTime diaFacturaInicio = new LocalDateTime().withDayOfMonth(Estudio.get(2).diaFacturacionMensual).withHourOfDay(0).withMinuteOfHour(0).withSecondOfMinute(0) 
		LocalDateTime diaFacturaFin = diaFacturaInicio.withHourOfDay(23).withMinuteOfHour(59).withSecondOfMinute(59)
		FacturaCuenta.createCriteria().list() {
			and{
				ge('fechaHora', diaFacturaInicio)
				le('fechaHora', diaFacturaFin)
			}
		}.findAll{it.cantidadAvisos == 3 && it.itemMensual && !it.pagada && !it.debitoAutomatico && it.cuenta.estado.nombre == "Activo"}.each{
			if(it.cuenta.bitrixId == null){
				try{
					def nombreCompleto = it.cuenta.nombreApellido.split()
					def nombreSolo = nombreCompleto[0]
					nombreCompleto = nombreCompleto - nombreSolo
					def bitrixContactId = bitrixService.crearContactoBitrix(nombreSolo,nombreCompleto.join(" "),it.cuenta.whatsapp,it.cuenta.email,it.cuenta.id.toString(),"Aviso Cobranza")
					cuentaService.actualizarBitrixId(it.cuenta.id,bitrixContactId)
				}
				catch(e){
					log.error("Ocurrio un error guardando Contact Id en cuenta: " + it.cuenta.id)
				}
			}
			try{
				bitrixService.crearNegociacionBitrix(it.cuenta.bitrixId,"3er Aviso emitido",null,"avisoCobranza")
			}
			catch(e){
				try{
					notificacionService.notificarErrorDealCobranza(it.cuenta.id,"Aviso SM no pagado")
				}
				catch(ex){
					log.error("Ocurrio un error notificando error sobre deal Aviso SM no pagado cuenta " + it.cuenta.id)
				}
			}
		}
	}

	def generarMailReporte(LocalDate fecha, Boolean mensual){
		LocalDateTime inicioPeriodo
		LocalDateTime finPeriodo
		String fechaString

		if (mensual){
			fechaString = fecha.toString('MM') + "-" +fecha.toString('YYYY')
			inicioPeriodo = fecha.toLocalDateTime(new LocalTime(0,0)).withDayOfMonth(1)
			finPeriodo = inicioPeriodo.plusMonths(1)
		}
		else{
			fechaString = fecha.toString('dd') + "-" + fecha.toString('MM') + "-" +fecha.toString('YYYY')
			inicioPeriodo = fecha.toLocalDateTime(new LocalTime(0,0)).withDayOfMonth(new Integer(fecha.toString('dd')))
			finPeriodo = inicioPeriodo.plusHours(24)
		}
		
		def consultasWeb = ConsultaWeb.createCriteria().list() {
			ge('fechaHora', inicioPeriodo)
			lt('fechaHora', finPeriodo)
		}

		def cuentas = Cuenta.createCriteria().list(){
			ge('fechaAlta', inicioPeriodo)
			lt('fechaAlta', finPeriodo)
		}

		String mensajeHtml = "<b>Reporte $fechaString</b>  <br/><br/>"
		String mensajeHtmlConsultas = mensajeHtml + 'Consultas Web: ' + "$consultasWeb.size <br/>"
		mensajeHtml += 'Cuentas creadas: ' + "$cuentas.size</br>"
		String tipo = mensual ? "Mensual" : "Diario"

		def zipCuentas = generarExcel(cuentas,"Cuentas " + fechaString, fechaString)
		def zipConsultas = generarExcel(consultasWeb,"Consultas Web "+ fechaString, fechaString)

		notificacionService.enviarEmailInterno("admin@calim.com.ar", "Reporte " + tipo + " Cuentas " + fechaString , mensajeHtml, "reporte", zipCuentas)
		notificacionService.enviarEmailInterno("admin@calim.com.ar", "Reporte " + tipo + " Consulta Web " + fechaString , mensajeHtmlConsultas, "reporte", zipConsultas)

	}

	def generarExcel(items,String titulo, String fechaString){
		XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet(titulo);
 
        int rowCount = 0;
        Row row = sheet.createRow(rowCount)
        int columnCount = 0

        CellStyle style = workbook.createCellStyle()
		Font font = workbook.createFont()
		font.setBold(true)
		font.setFontHeightInPoints((short) 10)
		style.setFont(font)

		Cell cellResumen = row.createCell(columnCount)
		cellResumen.setCellValue((String) "Total:")
		cellResumen = row.createCell(++columnCount)
		cellResumen.setCellValue((String) items.size())

		try{
			items = items.sort{it.fechaHora}
		}catch(e){
			items = items.sort{it.fechaAlta}
		}
		row = sheet.createRow(++rowCount)
		row = sheet.createRow(++rowCount)
		columnCount = 0
     	Cell cellCabecera = row.createCell(columnCount)
        cellCabecera.setCellValue((String) "Fecha")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Nombre")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Email")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Celular")
        cellCabecera.setCellStyle(style)
       	cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "CUIT")
        cellCabecera.setCellStyle(style)  
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Tag")
        cellCabecera.setCellStyle(style)

        items.each{
             
            row = sheet.createRow(++rowCount)
            columnCount = 0;

            def fecha 
            try { fecha = it.fechaHora
			}catch(e){fecha = it.fechaAlta}
            Cell cell = row.createCell(columnCount)
            cell.setCellValue((String) fecha.toString())

            def nombre
            try{ nombre = it.nombre + " " + it.apellido}
            catch(e){nombre = it.nombreApellido}
            cell = row.createCell(++columnCount)
            cell.setCellValue((String) nombre?.take(40))   

            cell = row.createCell(++columnCount)
            cell.setCellValue((String) it.email?.take(45))

            cell = row.createCell(++columnCount)
            cell.setCellValue((String) it.telefono?.take(30))

            def cuit
            try{ cuit = it.cuit }
            catch(e){ cuit = "-"}
            cell = row.createCell(++columnCount)
            cell.setCellValue((String) cuit)

            def tag
            try{ tag = it.tag}
            catch(e){tag = "-"}
            cell = row.createCell(++columnCount)
            cell.setCellValue((String) tag)

            }

        sheet.autoSizeColumn(0,false)
        sheet.autoSizeColumn(1,false)
        sheet.autoSizeColumn(2,false)
        sheet.autoSizeColumn(3,false)
        sheet.autoSizeColumn(4,false)
        sheet.autoSizeColumn(5,false)
        
        String pathExcels = System.getProperty("user.home") + "/Excels Reportes/" + fechaString + "/"
		File carpeta = new File(pathExcels)
		if(!carpeta.exists())
			carpeta.mkdirs()

        FileOutputStream outputStream = new FileOutputStream(pathExcels+titulo+".xlsx") 
        workbook.write(outputStream)

        def zipFile = new java.util.zip.ZipOutputStream( new FileOutputStream(pathExcels+titulo+".zip") )

        new File(pathExcels).listFiles().each { file -> 
		  //check if file
		  if (file.isFile() && ! file.name.contains(".zip")){
		    zipFile.putNextEntry(new java.util.zip.ZipEntry(file.name))
		    def buffer = new byte[file.size()]  
		    file.withInputStream { 
		      zipFile.write(buffer, 0, it.read(buffer))  
		    }  
		    zipFile.closeEntry()
		    file.delete()
		  }
		}  
		zipFile.close()

		def archivo = new File(pathExcels + titulo + ".zip")

		return archivo
	}

	def actualizarSubcodigos(String subcodigoViejo, String subcodigoNuevo){
		String templateMail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><title>Calim</title></head><body><div style="width:100%;max-width:700px;margin:auto;font-family:Trebuchet MS,Arial,Helvetica,sans-serif"><div style="border-bottom:1px solid #ddd;padding:30px 0 30px 0;overflow:hidden"><div style="float:left;margin-left:30px"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width:100%"></div><div style="font-size:45px;padding-top:20px;color:#2190a1;text-align:center">¡Hola, VARIABLENOMBRE!</div><br><br><div style="font-size:18px;padding:20px 20px 0 0;color:#666">Debido a los aumentos sostenidos en los últimos meses, y para poder seguir brindándote el mejor servicio, nos vemos obligados a actualizar las tarifas de nuestros planes.<br><br>👉 Tu abono mensual de Calim será de $VARIABLEPRECIO a partir del próximo mes.<br><br>Como siempre, cualquier consulta estamos a disposición.<br><br>Saludos.</div><br><br><div style="font-size:22px;padding-top:20px;color:#2190a1;text-align:center">¡Gracias por ser parte de Calim!</div><ul style="padding-inline-start:0;text-align:center"><li style="list-style:none;display:inline-table"><a href="https://twitter.com/CalimDigital"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style:none;display:inline-table"><a href="https://www.instagram.com/calimdigital/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style:none;display:inline-table"><a href="https://www.facebook.com/calimdigital/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style:none;display:inline-table"><a href="https://www.linkedin.com/company/calimdigital"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size:11px;color:#666;padding:20px 30px 20px 30px;text-align:center">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing<a href="{1}">acá</a>.<br>Calim | Calculo Mis Impuestos.<br>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
		String asunto = 'Actualizamos nuestras tarifas'
		String templateApp = 'Para seguir brindándote el mejor servicio, hemos actualizado nuestras tarifas. Tu abono mensual de Calim será de $VARIABLEPRECIO a partir del próximo mes'
		def salida = []
		Servicio.findAllBySubcodigoAndMensual(subcodigoViejo,true).each{ servicioViejo ->
			Servicio servicioNuevo = Servicio.findByCodigoAndSubcodigo(servicioViejo.codigo, subcodigoNuevo)
			if (!servicioNuevo){
				def reporte = [:]
				reporte.sm = servicioViejo.codigo
				reporte.cuenta = "-"
				reporte.mercadolibre = "-"
				reporte.precioViejo = "-"
				reporte.precioNuevo = "-"
				reporte.error = "No existe subcódigo $subcodigoNuevo"
				salida << reporte
			}
			else{
				servicioViejo.items.each{ item ->
					Cuenta cuenta = item.cuenta
					if (cuenta.primeraFacturaSMPaga && item.vigente && ! ["27379859416","27336069144","20382781148","20214547172","20380547733","27329464453","27389988451","20293776823","27319294118","27399822268","27184630015","27342348233","3348710214","20276905881","27268356628","20315627738","27269784895","27266613909","2168766101","20396727332","20393531666","27331209045","20239163735","20385374314","20282509009","23346453044","20407320159","20341209049"].contains(cuenta.cuit)){
						def reporte = [:]
						reporte.sm = servicioViejo.codigo
						reporte.cuenta = cuenta.toString()
						reporte.mercadolibre = cuenta.profesion == "mercadolibre" ? "Sí" : "-"
						reporte['precioViejo'] = formatear(item.precio)
						reporte.precioNuevo = "-"
						reporte.error = "-"
						if (item.descuento && cuenta.profesion != "mercadolibre")
							reporte.error = "Tiene descuento de ${item.descuento}%"
						else
							try {
								ItemServicioMensual itemNuevo = adherirMensual(servicioNuevo,0,cuenta,0,item.debitoAutomatico,new LocalDate(), false, null)
								reporte['precioNuevo'] = formatear(itemNuevo.precio)
								// notificacionService.enviarEmail(User.findByCuenta(cuenta).username, asunto, templateMail.replace("VARIABLENOMBRE",cuenta.nombre).replace("VARIABLEPRECIO",reporte.precioNuevo), "avisoCambioPrecio", null, asunto, templateApp.replace("VARIABLEPRECIO", reporte.precioNuevo))
							}
							catch(java.lang.AssertionError e) {
								reporte.error = e.message.split("finerror")[0]
							}
						salida << reporte
					}
				}
			}
		}
		// notificacionService.enviarEmailInterno("admin@calim.com.ar", "Reporte cambios de precio $subcodigoViejo a $subcodigoNuevo", Auxiliar.mapEnDatatable(["SM","Cuenta","Mercado","Precio Viejo", "Precio Nuevo", "Error"], salida))
		return salida
	}
}