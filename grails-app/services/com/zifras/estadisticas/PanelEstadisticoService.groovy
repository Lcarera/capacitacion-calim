package com.zifras.estadisticas

import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.cuenta.Cuenta
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.PagoCuenta
import static com.zifras.inicializacion.JsonInicializacion.formatear
import com.zifras.notificacion.ConsultaWeb
import com.zifras.servicio.ItemServicioEspecial
import com.zifras.servicio.ItemServicioMensual
import com.zifras.servicio.Servicio
import com.zifras.ventas.Vendedor
import grails.validation.Validateable

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.LocalTime
import java.time.DayOfWeek
import java.time.temporal.TemporalAdjusters
import java.time.format.DateTimeFormatter

class PanelEstadisticoService {


	def datosServicios(LocalDate fecha, Boolean mensual) {
		def mesesPeriodo = periodoAnual(fecha)
		def anoActual = getAnoActual(fecha)
		def mesActual = getMesActual(fecha)
		def respuesta = []
		def servicios
		def fechaBusq
		def dif 
		mesesPeriodo.eachWithIndex{ mesPeriodo, index ->
			dif = mesPeriodo - mesActual
			fechaBusq = dif<0 ? new LocalDate(anoActual+"-"+mesPeriodo+"-01") : new LocalDate(anoActual - 1 +"-"+mesPeriodo+"-01")
			if(index == 12)
				fechaBusq = fechaBusq.plusYears(1)

			if (mensual){
				fechaBusq = fechaBusq.withDayOfMonth(Estudio.get(2).diaFacturacionMensual)
				servicios = ItemServicioMensual.createCriteria().list() {
					le('fechaAlta', fechaBusq.plusDays(5)) // Hacer menos 1 mes??
					or{
						isNull('fechaBaja')
						gt('fechaBaja', fechaBusq)
					}
				}
			}else
				servicios = ItemServicioEspecial.createCriteria().list() {
					ge('fechaAlta', fechaBusq)
					le('fechaAlta', fechaBusq.plusMonths(1))
				}

			Servicio.findAllByMensualAndActivo(mensual, true).collect{[it.codigo, it.nombre]}.sort{it[0]}.unique{it[0]}.each{ cod, nom ->
				def item = [:]
				item['mes'] = mesPeriodo
				item['codigo'] = cod
				item['nombre'] = nom
				def serviciosFiltrados = servicios.findAll{ it.servicio.codigo == cod }
				item['cantidad'] = serviciosFiltrados.size()
				if (mensual)
					item['pagados'] = serviciosFiltrados.findAll{it.getMesPagado(fechaBusq)}.size()
				else{
					item['pagados'] = serviciosFiltrados.findAll{it.factura?.pagada}.size()
					def responsables = Vendedor.getAll().each{ resp ->
						item['responsable'+resp.nombre+'Enviados'] = serviciosFiltrados.findAll{it.vendedor?.id == resp.id}.size()
						item['responsable'+resp.nombre+'Vendidos'] = serviciosFiltrados.findAll{it.factura?.pagada && it.vendedor?.id == resp.id}.size()
					}
				}
				respuesta << item
			}
		}

		return respuesta
	}

	def vendedoresCalim(){
		return Vendedor.getAll().findAll{v -> !v.deshabilitado}
	}

	def datosRegistro(LocalDate fecha,String grupo){
		def mesesPeriodo = periodoAnual(fecha)
		def anoActual = getAnoActual(fecha)
		def mesActual = getMesActual(fecha)
		def respuesta = []
		def cuentas
		def fechaBusq
		def dif 

		mesesPeriodo.eachWithIndex{ mesPeriodo, index ->
			dif = mesPeriodo - mesActual
			fechaBusq = dif<0 ? new LocalDateTime(anoActual+"-"+mesPeriodo+"-01T00:00:01") : new LocalDateTime(anoActual - 1+"-"+mesPeriodo+"-01T00:00:01")
			if(index == 12)
				fechaBusq = fechaBusq.plusYears(1)

			cuentas = Cuenta.createCriteria().list(){
				ge('fechaAlta',fechaBusq)
				le('fechaAlta',fechaBusq.plusMonths(1))
			}

			if(grupo == "tiendaNube")
				cuentas = cuentas.findAll{it.tokenTiendaNube}
			if(grupo == "delivery")
				cuentas = cuentas.findAll{it.trabajaConApp()}

			for(int i=0;i<3;i++){ //Los 3 diferentes Stages: confirmacion de mail, pleno onboarding y quienes completaron el registro
				def item = [:]
				item['mes'] = mesPeriodo
				switch (i){
					case 0:
						item['stage'] = 'confirmacionEmail'
						item['cantidad'] = cuentas.findAll{it.estado?.nombre == "Sin verificar" && it.actionRegistro == ''}.size()
						break
					case 1:
						item['stage'] = 'plenoOnboarding'
						item['cantidad'] = cuentas.findAll{it.estado?.nombre == "Sin verificar" && it.actionRegistro != '' && it.actionRegistro != null}.size()
						break
					case 2:
						item['stage'] = 'registroCompleto'
						item['cantidad'] = cuentas.findAll{it.estado?.nombre == "Activo"}.size()
						break
				}
				respuesta << item	
			}
		}
		return respuesta
	}

	def datosContactos(LocalDate fecha){
		def mesesPeriodo = periodoAnual(fecha)
		def anoActual = getAnoActual(fecha)
		def mesActual = getMesActual(fecha)
		def respuesta = []
		def consultas
		def cuentas
		def fechaBusq
		def dif 
		def fechaComienzoContactos = new LocalDateTime("2020-08-07T17:00:00")// fecha en que se implemento el modulo de creacion de contactos

		mesesPeriodo.eachWithIndex{ mesPeriodo, index ->
			dif = mesPeriodo - mesActual
			fechaBusq = dif<0 ? new LocalDateTime(anoActual+"-"+mesPeriodo+"-01T00:00:01") : new LocalDateTime(anoActual - 1+"-"+mesPeriodo+"-01T00:00:01")
			if(index == 12)
				fechaBusq = fechaBusq.plusYears(1)

			consultas = ConsultaWeb.createCriteria().list(){
				ge('fechaHora',fechaBusq)
				le('fechaHora',fechaBusq.plusMonths(1))
			}

			cuentas = Cuenta.createCriteria().list(){
				ge('fechaAlta',fechaBusq)
				le('fechaAlta',fechaBusq.plusMonths(1))
				and{
					ge('fechaAlta',fechaComienzoContactos)
				}
			}.findAll{it.actionRegistro != '' && it.actionRegistro != null}

			def item=[:]
			item['mes'] = mesPeriodo
			item['cantidad'] = consultas.size() + cuentas.size()
			respuesta << item
		}
		return respuesta
	}

	def cantidadUsuariosDelivery(){
		def cuentas = Cuenta.getAll().findAll{it.estado?.nombre == "Activo" && it.trabajaConApp()}
		return cuentas.size()
	}

	def cantidadUsuariosConApp(){
		return cantidadUsuarios("tokenFCM")
	}

	def cantidadUsuariosTiendaNube(){
		return cantidadUsuarios("tokenTiendaNube")
	}

	def cantidadUsuariosActivos(){
		return cantidadUsuarios()
	}

	def cantidadUsuarios(String condicion){
			def cuentas = Cuenta.getAll().findAll{it.estado?.nombre == "Activo"}
		if(condicion)
			cuentas = cuentas.findAll{it[condicion]}
		
		return cuentas.size()
	}
	
	def periodoAnual(LocalDate fecha){
		def mes = fecha.toString("MM")
		def mesInt = new Integer(mes)
		def periodo = []

		for(int i=mesInt; i<=12; i++){
			periodo.push(i)
		}
		for(int i=1;i<=mesInt;i++){
			periodo.push(i)
		}
		return periodo
	}

	Integer getAnoActual(LocalDate fecha){
		return new Integer(fecha.toString("YYYY"))
	}
	Integer getMesActual(LocalDate fecha){
		return new Integer(fecha.toString("MM"))
	}

	def listadoGerencia(LocalDate mesAno){
		def salida = [:]
		LocalDateTime inicioMes = mesAno.toLocalDateTime(new LocalTime(0,0)).withDayOfMonth(1)
		LocalDateTime finMes = inicioMes.plusMonths(1)
		def pagados = PagoCuenta.createCriteria().list() {
			ge('fechaPago', inicioMes)
			lt('fechaPago', finMes)
			eq('estado', Estado.findByNombre('Pagado'))
		}
		def reembolsados = PagoCuenta.createCriteria().list() {
			ge('fechaPago', inicioMes)
			lt('fechaPago', finMes)
			eq('estado', Estado.findByNombre('Reembolsado'))
		}

		def facturasFinde = FacturaCuenta.createCriteria().list() {
			ge('fechaHora', inicioMes)
			lt('fechaHora', finMes)
		}?.findAll{ [6,7].contains(it.fechaHora.dayOfWeek) }
		salida.facturasFinde = facturasFinde.size()
		salida.facturasFindePagadas = facturasFinde.findAll{it.pagada}.size()
		salida.facturasFindeReembolsadas = facturasFinde.findAll{it.reembolsada}.size()

		salida.cantidadSM = 0
		salida.nuevosSM = 0
		salida.cantidadSE = 0
		salida.atrasadosSM = 0
		Double importeSE = 0
		Double importeSM = 0
		def facturasPagadas = []
		pagados.each{
			it.facturas.each{
				if (it.itemMensual){
					salida.cantidadSM ++
					importeSM += it.importe
					if (it.esPrimerSM()){
						salida.nuevosSM ++
						facturasPagadas << it
					}
					if (it.fechaHora < inicioMes.withDayOfMonth(com.zifras.Estudio.get(2).diaFacturacionMensual).plusDays(6).minusMonths(1))
						salida.atrasadosSM ++
				}
				else{
					importeSE += it.importe
					salida.cantidadSE ++
					facturasPagadas << it
				}
			}
		}
		salida.importeSE = formatear(importeSE)
		salida.importeSM = formatear(importeSM)
		salida.importeTotal = formatear(importeSM + importeSE)

		Double importeReembolsado = 0
		salida.reembolsosSE = 0
		salida.reembolsosSM = 0
		reembolsados.each{
			it.facturas.each{
				if (it.itemMensual)
					salida.reembolsosSM ++
				else
					salida.reembolsosSE ++
				importeReembolsado += it.importe
			}
		}
		salida.reembolsos = salida.reembolsosSE + salida.reembolsosSM
		salida.importeReembolsado = formatear(importeReembolsado)

		salida.vendedores = []
		Double comisionTotal = 0
		Double totalTotal = 0
		Vendedor.list().findAll{v -> !v.deshabilitado}.each{
			def vendedor = [:]
			vendedor.id = it.id
			vendedor.nombre = it.nombre
			vendedor.correo = it.email
			vendedor.ventas = []
			vendedor.cantEspeciales = 0
			vendedor.cantMensuales = 0
			Double comision = 0
			Double total = 0
			facturasPagadas.findAll{it.vendedor?.id == vendedor.id}.each{
				def factura = [:]
				factura.fechaEmision = it.fechaHora.toString("dd/MM/yyyy")
				factura.fechaPago = it.fechaPago?.toString("dd/MM/yyyy")
				factura.detalle = it.descripcion
				factura.cliente = it.cuenta.toString()
				factura.profesion = it.cuenta?.profesion
				factura.emailMP = it.cuenta.getMailsMercadoPago()
				factura.vendedor = vendedor.nombre
				Double importe = it.importe
				Double porcentajeComision = it.itemMensual ? 0.2 : 0.05
				Double comisionVenta = importe * porcentajeComision
				factura.importe = formatear(importe)
				total += importe
				factura.comision = formatear(comisionVenta)
				comision += comisionVenta
				if (it.itemMensual)
					vendedor.cantMensuales ++
				else
					vendedor.cantEspeciales ++
				vendedor.ventas << factura
			}
			comision = comision / 1.21
			vendedor.comision = formatear(comision)
			vendedor.total = formatear(total)
			comisionTotal += comision
			totalTotal += total
			salida.vendedores << vendedor
		}
		def vendedorSumatoria = [:]
		vendedorSumatoria.nombre = "Todos"
		vendedorSumatoria.correo = ""
		vendedorSumatoria.ventas = []
		vendedorSumatoria.comision = formatear(comisionTotal)
		vendedorSumatoria.total = formatear(totalTotal)
		salida.vendedores << vendedorSumatoria
		return salida;
	}

	def datosVendedor(String email, LocalDate mesAno){
		def salida = [:]
		def vendedor = Vendedor.findByEmail(email)
		def fechaMensual = mesAno.withDayOfMonth(Estudio.get(2).diaFacturacionMensual)
		LocalDateTime inicioMesPagos = mesAno.toLocalDateTime(new LocalTime(0,0)).withDayOfMonth(1)
		LocalDateTime finMesPagos = inicioMesPagos.plusMonths(1)
		LocalDate inicioMes = mesAno
		LocalDate finMes = inicioMes.plusMonths(1)

		def pagados = PagoCuenta.createCriteria().list() {
			ge('fechaPago', inicioMesPagos)
			lt('fechaPago', finMesPagos)
			eq('estado', Estado.findByNombre('Pagado'))
		}

		def reembolsados = PagoCuenta.createCriteria().list() {
			ge('fechaPago', inicioMesPagos)
			lt('fechaPago', finMesPagos)
			eq('estado', Estado.findByNombre('Reembolsado'))
		}

		def serviciosEspeciales = ItemServicioEspecial.createCriteria().list() {
			ge('fechaAlta', inicioMes)
			le('fechaAlta', finMes)
		}

		def serviciosMensuales = ItemServicioMensual.createCriteria().list() {
			le('fechaAlta', fechaMensual.plusDays(5)) //dia 10
			or{
				isNull('fechaBaja')
				gt('fechaBaja', finMes.plusDays(10))
			}
		}

		def facturasPagadas = []
		pagados.each{
			it.facturas.each{
				facturasPagadas << it
			}
		}

		def dataVendedor = [:]
		dataVendedor.id = vendedor.id
		dataVendedor.nombre = vendedor.nombre
		dataVendedor.correo = vendedor.email
		dataVendedor.ventas = []
		dataVendedor.cantSEVendidos = 0
		dataVendedor.cantSMVendidos = 0
		Double comision = 0
		Double total = 0
		Double importeReembolsado = 0
		facturasPagadas.findAll{it.vendedor?.id == vendedor.id}.each{
			def factura = [:]
			factura.fechaEmision = it.fechaHora.toString("dd/MM/yyyy")
			factura.fechaPago = it.fechaPago?.toString("dd/MM/yyyy")
			factura.detalle = it.descripcion
			factura.cliente = it.cuenta.toString()
			factura.vendedor = vendedor.nombre
			Double importe = it.importe
			Double porcentajeComision = it.itemMensual ? 0.2 : 0.05
			Double comisionVenta = importe * porcentajeComision
			factura.importe = formatear(importe)
			total += importe
			factura.comision = formatear(comisionVenta)
			comision += comisionVenta
			if (it.itemMensual){
				if(it.esPrimerSM())
					dataVendedor.cantSMVendidos ++
			}
			else
				dataVendedor.cantSEVendidos ++
			dataVendedor.ventas << factura
		}
		comision = comision / 1.21
		dataVendedor.comision = formatear(comision)
		dataVendedor.total = formatear(total)
		Double comisionTotal = 0
		Double totalTotal = 0
		comisionTotal += comision
		totalTotal += total
		dataVendedor.cantSENoCobrados = serviciosEspeciales.findAll{it.vendedor?.id == vendedor.id}.size() - dataVendedor.cantSEVendidos
		dataVendedor.cantSMNoCobrados= serviciosMensuales.findAll{it.vendedor?.id == vendedor.id}.size() - dataVendedor.cantSMVendidos
		def cantSMReembolsados = 0, cantSEReembolsados = 0
		reembolsados.each{
			it.facturas.findAll{it.vendedor?.id == vendedor.id}.each{
				if (it.itemMensual)
					cantSMReembolsados ++
				else
					cantSEReembolsados ++
				importeReembolsado += it.importe
			}
		}
		dataVendedor.cantSMReembolsados = cantSMReembolsados
		dataVendedor.cantSEReembolsados = cantSEReembolsados
		dataVendedor.importeReembolsadoTotal = importeReembolsado

		dataVendedor = datosVentasMensualesVendedor(dataVendedor,mesAno)

		salida.vendedor = dataVendedor
	}

	def datosVentasMensualesVendedor(vendedor,LocalDate mesAno){
		vendedor.ventasMesesSE = []
		vendedor.enviadosMesesSE = []
		vendedor.ventasMesesSM = []
		vendedor.enviadosMesesSM = []
		def mesActual = getMesActual(mesAno)
		def anoActual = getAnoActual(mesAno)
		def mesesPeriodo = periodoAnual(mesAno)
		def dif
		def fechaBusq

		mesesPeriodo.eachWithIndex{ mesPeriodo, indice->
			def cantSMVendidos = 0, cantSEVendidos = 0
			if(indice == 0)
				fechaBusq = new LocalDate(anoActual - 1+"-"+mesPeriodo+"-01")
			else{
				dif = mesPeriodo - mesActual
				fechaBusq = dif<=0 ? new LocalDate(anoActual+"-"+mesPeriodo+"-01") : new LocalDate(anoActual - 1+"-"+mesPeriodo+"-01")
			}
			LocalDateTime inicioMesPagos = fechaBusq.toLocalDateTime(new LocalTime(0,0)).withDayOfMonth(1)
			LocalDateTime finMesPagos = inicioMesPagos.plusMonths(1)
			def serviciosMensuales = ItemServicioMensual.createCriteria().list() {
				le('fechaAlta', fechaBusq.plusDays(5)) // Hacer menos 1 mes??
				gt('fechaAlta', fechaBusq.minusMonths(1).plusDays(5))
			}.findAll{it.vendedor?.id == vendedor.id}.size()

			def serviciosEspeciales = ItemServicioEspecial.createCriteria().list(){
				ge('fechaAlta', fechaBusq)
				le('fechaAlta', fechaBusq.plusMonths(1))
			}findAll{it.vendedor?.id == vendedor.id}.size()

			def pagados = PagoCuenta.createCriteria().list() {
			ge('fechaPago', inicioMesPagos)
			lt('fechaPago', finMesPagos)
			eq('estado', Estado.findByNombre('Pagado'))
			}

			pagados.each{
				it.facturas?.each{
					if(it.vendedor?.id == vendedor.id){
						if(it.itemMensual){
							if(it.esPrimerSM())
								cantSMVendidos ++
						}
						else
							cantSEVendidos ++
					}
				}
			}
			vendedor.ventasMesesSE.push(cantSEVendidos)
			vendedor.ventasMesesSM.push(cantSMVendidos)
			vendedor.enviadosMesesSM.push(serviciosMensuales)
			vendedor.enviadosMesesSE.push(serviciosEspeciales)
		}
		return vendedor
	}

	def listConsultasWeb(LocalDate mesAno){
		LocalDateTime inicioMes = mesAno.toLocalDateTime(new LocalTime(0,0)).withDayOfMonth(1)
		LocalDateTime finMes = inicioMes.plusMonths(1)		
		def consultas = ConsultaWeb.createCriteria().list(){
			ge('fechaHora',inicioMes)
			lt('fechaHora',finMes)
		}
		def lista = []
		consultas.each{
			def item = [:]
			item.id = it.id
			item.nombreApellido = it.nombre + " " + it.apellido
			item.nombre = it.nombre
			item.apellido = it.apellido
			item.telefono = it.telefono
			item.email = it.email
			item.fecha = it.fechaHora.toString("dd/MM/YYYY hh:mm")
			item.tag = it.tag
			item.vendedorAsignado = it.vendedorAsignado
			item.urlOrigen = it.urlOrigen
			item.getParameters = it.getParameters
			item.contactId = it.bitrixClientId
			item.dealId = it.bitrixDealId
			def cuenta = Cuenta.findByEmail(it.email)
			item.cuentaExistente = cuenta != null
			item.mensualActivo = cuenta?.servicioActivo
			item.algunServicioPagado = cuenta?.algunServicioPagado()
			item.cuentaId = cuenta?.id
			lista << item
		}
		/*String query = """
			SELECT consulta_web.id,
			       nombre, 
			       apellido, 
			       telefono, 
			       email, 
			       fecha_hora, 
			       tag,
			       vendedor_asignado,
			       url_origen,
			       get_parameters
			FROM   consulta_web
			       LEFT JOIN cuenta
			              ON consulta_web.email = cuenta.email
			WHERE  fecha_hora BETWEEN ${inicioMes} AND ${finMes}
		"""
		query += ";"
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.selected = ''
			item.id = it[0]
			item.nombreApellido = it[1] + it[2]
			item.telefono = it[3]
			item.email = it[4]
			item.fechaHora = it[5]
			item.tag = it[6]
			item.vendedorAsignado = it[7]
			item.urlOrigen = it[8]
			item.getParameters = it[9]
			item.cuenta = it[9]
			return item
		}
	}*/
		return lista
	}

	def datosConsultasWeb(Boolean mensual, LocalDate fecha){
		def anoActual = getAnoActual(fecha)
		def mesActual = getMesActual(fecha)
		def diaActual = fecha.toString("dd")
		def consultas
		java.time.YearMonth yearMonthObject = java.time.YearMonth.of(new Integer(anoActual),new Integer(mesActual));
		def diasMes = yearMonthObject.lengthOfMonth();
		def dif
		def fechaBusq = new LocalDateTime(anoActual+"-"+mesActual+"-"+diaActual).withHourOfDay(00)
		def respuesta = []
		if(mensual){
			consultas = ConsultaWeb.createCriteria().list(){
				ge('fechaHora',fechaBusq.withDayOfMonth(1))
				lt('fechaHora',fechaBusq.plusMonths(1))
			}
			def today = java.time.LocalDate.now()
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/YYYY")
			java.time.LocalDate firstOfMonth = today.with( TemporalAdjusters.firstDayOfMonth() );
			java.time.LocalDate monday = firstOfMonth.with( TemporalAdjusters.nextOrSame( DayOfWeek.MONDAY ) );
			int num = monday.getDayOfMonth()
			for(int i=0;i<4;i++){
				for(int j=0;j<7;j++){
					def diaBusq = (j+i*7)+num
					fechaBusq = new LocalDateTime(anoActual+"-"+mesActual+"-"+diaBusq)
					def item = [:]
					item['semana'] = i + 1
					item['dia'] = j + 1
					item['cantidad'] = consultas.findAll{it.fechaHora.isBefore(fechaBusq.withHourOfDay(23).withMinuteOfHour(59)) && it.fechaHora.isAfter(fechaBusq.withHourOfDay(00).withMinuteOfHour(00))}.size()
					respuesta << item
				}
			}
		}else{
			for(int i=0; i<=23; i++){
				if(i>=0 && i<21){
					consultas = ConsultaWeb.createCriteria().list(){
						ge('fechaHora',fechaBusq.withHourOfDay(i + 3).withMinuteOfHour(0))
						le('fechaHora',fechaBusq.withHourOfDay(i + 3).withMinuteOfHour(59))
					} 
				}else{
					consultas = ConsultaWeb.createCriteria().list(){
						ge('fechaHora',fechaBusq.plusDays(1).withHourOfDay(i - 21).withMinuteOfHour(0))
						le('fechaHora',fechaBusq.plusDays(1).withHourOfDay(i - 21).withMinuteOfHour(59))
					} 
				}
				def item=[:]
				item['hora'] = i
				item['cantidad'] = consultas.size()
				respuesta << item
			}
		}
		return respuesta
	}

	def clientesMensuales(int cantMeses){
		def meses = [:]
		LocalDateTime fin = new LocalDate().toLocalDateTime(new LocalTime(0,0)).withDayOfMonth(Estudio.get(2).diaFacturacionMensual).plusDays(6).plusMonths(1) // Menor estricto a esta fecha
		LocalDateTime inicio = fin.minusMonths(1 + cantMeses) // Mayor o igual a esta fecha: 6 meses antes de hoy
		def facturas = FacturaCuenta.createCriteria().list() {
			ge('fechaHora', inicio)
			lt('fechaHora', fin)
			isNotNull('itemMensual')
		}
		LocalDateTime actual = inicio.plusMonths(1)
		def espanol = new java.util.Locale('ES')
		while (actual <= fin){ // inicializo la salida
			meses[actual.monthOfYear] = [emitidos:0, pagados:0, reembolsados:0, nuevosSinPagar:0, nuevosPagados:0, nombre:actual.toString("MMMM",espanol).capitalize()]
			actual = actual.plusMonths(1)
		}
		facturas.each{ factura ->
			def mesReal = (factura.fechaHora.dayOfMonth < fin.dayOfMonth) ? factura.fechaHora.monthOfYear : factura.fechaHora.plusMonths(1).monthOfYear
			def itemMes = meses[mesReal]
			itemMes.emitidos++
			boolean nuevo = factura.esPrimerSM()
			if (factura.pagada){
				itemMes.pagados++
				if (nuevo)
					itemMes.nuevosPagados++
			}
			else if (nuevo)
				itemMes.nuevosSinPagar++
			if (factura.reembolsada)
				itemMes.reembolsados++
		}
		return meses
	}

	def bajasMensuales(int cantMeses){
		def meses = [:]
		LocalDate fin = new LocalDate().plusMonths(2).withDayOfMonth(1)
		LocalDate inicio = fin.minusMonths(1 + cantMeses	)
		def items = ItemServicioMensual.createCriteria().list() {
			ge('fechaBaja', inicio)
			lt('fechaBaja', fin)
		}
		LocalDate actual = inicio//.plusMonths(1)
		while (actual < fin){ // inicializo la salida
			meses[actual.monthOfYear] = 0
			actual = actual.plusMonths(1)
		}
		items.each{ item ->
			if (!item.cuenta.serviciosMensuales.find{it.fechaAlta >= item.fechaBaja})
				meses[item.fechaBaja.monthOfYear]++
		}
		return meses
	}
}
