package com.zifras.cuenta

import com.zifras.AccessRulesService
import com.zifras.BitrixService
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.Localidad
import com.zifras.Provincia
import com.zifras.User
import com.zifras.UsuarioService
import com.zifras.afip.AfipService
import com.zifras.app.App
import com.zifras.app.ItemApp
import com.zifras.importacion.LogSelenium
import com.zifras.liquidacion.LiquidacionIIBBService
import com.zifras.liquidacion.LiquidacionIvaService
import com.zifras.notificacion.NotificacionService
import com.zifras.selenium.SeleniumService

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.springframework.dao.DataIntegrityViolationException
import static grails.gorm.multitenancy.Tenants.*


@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class CuentaController {
	AccessRulesService accessRulesService
	def afipService
	def bitrixService
	def cuentaService
	def liquidacionIIBBService
	def liquidacionIvaService
	def notificacionService
	def seleniumService
	def springSecurityService
	def usuarioService
	MovimientoCuentaService movimientoCuentaService

	def selenium(Long id){
		def cuentaInstance = cuentaService.getCuenta(id)
		if (!cuentaInstance) {
			def intentoCuit = cuentaService.getCuentaByCuit(id.toString())
			if (intentoCuit){
				redirect(action: "selenium", id:intentoCuit.id)
				return
			}
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), id])
			redirect(action: "list")
			return
		}
		[ano: new LocalDate().minusMonths(1).year, cuentaId:id, cuit: cuentaInstance.cuit, razonSocial: cuentaInstance.razonSocial]
	}
	def seleniumViejo(Long id, String mes, String ano){
		def resultado = "sdsd"
		flash.message = "<br/>Comprobantes: ${resultado.comprobantes}<br/>Ret/Per Afip: ${resultado.afip}<br/>Agip: ${resultado.agip}<br/>Arba: ${resultado.arba}"
		redirect(action:'show', id: id)
	}

	def recuperarChinos(){
		def liquidacion
		def estadoActivo = Estado.findByNombre('Activo')
		def liqs = [1971148,2012332,2012358,2012385,2012425,2012441,2012456,2012516,2012518,2012719,2013699,2013709,2013720,2013745,2013757,2013764,2013775,2013997,2014539,2014874,2014945,2014980,2015080,2015096,2015121,2015130,2015141,2016195,2016221,2016224,2016226,2016229,2016236,2016252,2016262,2016271,2016273,2016283,2016286,2016297,2016299,2016301,2016304,2023137,2023181,2025493,2025549,2025565,2025582,2025805,2025844,2025893,2025907,2025930,2025980,2026001,2026004,2026066,2026160,2026166,2026182,2026695,2030891,2030918,2030954,2031004,2031013,2031021,2031047,2031060,2031083,2031158,2031424,2031428,2031471,2031478,2031495,2031497,2031499,2037217,2037270,2037378,2037423,2037536,2037568,2037575,2037617,2037623,2037660,2037730,2037778,2037821,2037830,2037837,2037843,2038071,2038101,2038110,2038418,2038646,2038654,2038664,2038668,2038681,2038768,2038798,2038808,2038823,2038870,2038908,2038943,2038970,2039009,2039012,2039018,2039034,2039037,2039057,2039061,2039085,2039088,2039111,2039141,2042534,2042537,2042541,2042545,2042579,2042581,2042585,2042588,2042590,2042597,2042600,2042602,2042604,2042607,2042616,2042628,2042633,2042636,2042639,2042641,2042643,2042645,2042677,2042679,2042685,2042693,2042697,2042702,2042704,2042706,2042708,2042712,2042715,2042718,2042720,2042724,2042726,2042728,2042731,2042735,2042737,2042739,2042741,2042748,2042752,2042754,2042757,2042760,2042762,2042764,2042768,2042770,2042788,2042793,2042817,2042819,2043655,2043659,2043662,2043665,2043690,2043850,2043855,2043864,2043868,2043871,2043873,2043909,2043923,2043928,2043931,2043939,2043941,2043944,2043948,2043950,2043954,2043958,2043973,2043975,2043979,2043982,2043988,2043990,2043994,2043997,2044040,2044067,2044085,2044088,2044197,2044203,2044207,2044210,2044212,2044214,2044216,2044222,2044224,2044226,2044233,2044235,2044237,2044239,2044241,2044247,2044251,2044253,2044256,2044258,2044261,2044274,2044296,2044334,2044336,2044339,2044351,2044366,2044374,2044376,2044378,2044380,2044382,2044386,2044388,2044390,2044395,2044398,2044400,2044404,2044408,2044414,2044416,2044418,2044420,2044422,2044427,2044429,2044493,2044495,2044757,2044766,2044818,2044820,2044927,2044972,2044975,2045048,2045107,2045152,2045170,2045279,2045309,2045322,2045330,2045338,2045358,2045364,2045384,2045389,2045392,2045400,2045410,2045489,2045548,2045563,2045567,2045584,2046269,2046283,2046299,2046393,2046409,2046467,2046474,2046560,2046822,2046836,2046885,2046948,2047036,2047062,2047104,2047120,2047134,2047198,2047209,2047244,2047257,2047371,2047439,2047452,2047459,2047473,2047488,2047498,2047509,2047598,2047605,2047634,2047660,2047705,2047713,2047759,2047780,2047788,2047795,2047799,2047825,2047872,2082719,2093431,2139726,2202349]
		liqs.each{
			liquidacion = com.zifras.liquidacion.LiquidacionIva.get(it)
			if(liquidacion.liquidacionlocales!=null){
				liquidacion.liquidacionlocales.clear()
				liquidacion.save(flush:false)
			}
			liquidacion.cuenta.locales.each{
				if(it.estado.nombre != "Borrado"){
					def liquidacionLocal = new com.zifras.liquidacion.LiquidacionIvaLocal()
					liquidacionLocal.local = it
					liquidacionLocal.porcentajeLocal = it.porcentaje
					liquidacionLocal.saldoDdjj = ((liquidacion.saldoDdjj * it.porcentaje)/100).round(2)

					liquidacion.addToLiquidacionlocales(liquidacionLocal)
				}
			}
			liquidacion.save(flush:false)
		}


		liqs = [2141205,2141208,2141211,2141217,2141223,2141227,2141230,2141234,2141237,2142738,2142781,2142853,2142958,2143130,2143151,2142751,2142795,2142810,2142825,2143010,2143043,2143059,2143073,2143099,2143415,2143432,2142838,2143445,2142872,2142937,2142979,2143024,2143462,2143496,2143526,2143529,2143532,2143535,2143577,2143580,2143583,2143586,2143491,2143499,2143502,2143505,2143508,2143511,2143514,2143517,2143520,2143538,2143523,2143541,2143544,2143547,2143550,2143553,2143556,2143559,2143562,2143565,2143571,2143568,2143574,2143589,2143592,2143595,2143598,2143601,2143604,2143607,2143610,2143613,2143616,2143619,2143622,2143625,2143628,2143631,2143634,2143637,2143640,2143643,2143646,2143649,2143652,2143655,2143658,2143661,2143664,2143668,2143674,2143809,2202282,2202371,2202421,2202442,2154540,2181824,2181368,2181395,2181829,2181841,2181382,2181832,2181835,2181838,2181844,2181847,2181850,2181877,2181880,2181883,2181410,2181452,2181853,2181856,2181859,2181862,2181886,2181868,2181889,2181871,2181865,2181423,2181438,2181892,2181466,2181520,2181537,2181555,2181895,2181898,2181907,2181910,2181913,2181916,2181919,2181922,2181925,2181928,2181952,2181501,2181599,2181931,2181934,2181937,2181940,2181943,2181946,2181949,2181955,2181958,2181961,2181968,2181972,2181585,2181612,2181976,2181980,2181984,2181988,2181996,2182000,2181626,2182014,2181643,2182039,2181664,2181678,2181698,2084434,2093537,2084553,2084580,2084645,2084455,2084468,2084605,2093560,2093574,2093729,2093831,2084628,2093590,2093744,2093757,2093771,2093785,2093847,2084682,2093612,2093660,2093801,2093919,2093922,2093632,2093676,2093692,2093887,2093895,2093898,2093901,2093904,2093907,2093910,2093913,2093916,2093925,2093928,2093647,2093931,2093951,2093934,2093937,2093940,2093943,2093947,2093955,2093959,2093962,2093965,2093969,2140462,2140632,2140703,2140717,2140645,2140674,2140687,2140731,2140759,2140779,2140793,2140850,2140864,2140821,2140836,2140878,2140892,2140930,2140944,2140958,2141010,2140910,2141028,2141043,2141059,2141073,2141087,2141169,2141124,2141132,2141133,2141136,2141139,2141142,2141145,2141148,2141151,2141154,2141157,2141160,2141163,2141166,2141175,2141178,2141181,2141184,2141187,2141190,2141193,2141196,2141202]
		liqs.each{
			liquidacion = com.zifras.liquidacion.LiquidacionIIBB.get(it)
			if(liquidacion.liquidacionlocales!=null){
				liquidacion.liquidacionlocales.clear()
				liquidacion.save(flush:false, failOnError:false)
			}
			Local.findAllByCuentaAndProvinciaAndEstado(liquidacion.cuenta, liquidacion.provincia, estadoActivo).each{
				if(it.porcentajeIIBB!=null){
					def liquidacionLocal = new com.zifras.liquidacion.LiquidacionIIBBLocal()
					liquidacionLocal.local = it
					liquidacionLocal.porcentajeLocal = it.porcentajeIIBB
					liquidacionLocal.saldoDdjj = ((liquidacion.saldoDdjj * it.porcentajeIIBB)/100).round(2)

					liquidacion.addToLiquidacionlocales(liquidacionLocal)
				}
			}

			if(liquidacion.alicuotas!=null){
				liquidacion.alicuotas.clear()
				liquidacion.save(flush:false, failOnError:true)
			}

			liquidacion.cuenta.alicuotasIIBB.each{
				if((it.provincia==liquidacion.provincia)&&(it.estado==estadoActivo)){
					def alicuota = new com.zifras.liquidacion.LiquidacionIIBBAlicuota()
					alicuota.alicuota = it.valor
					alicuota.porcentaje = it.porcentaje

					alicuota.baseImponible = (liquidacion.neto * it.porcentaje / 100).round(2)
					alicuota.impuesto = (alicuota.baseImponible * alicuota.alicuota / 100).round(2)


					liquidacion.addToAlicuotas(alicuota)
				}
			}

			liquidacion.save(flush:false, failOnError:true)
		}
		liquidacion.save(flush:true, failOnError:true)

		render "fin"
	}

	def configurar(){
		int cont = 0;
		LocalDateTime ahora = new LocalDateTime()
		Provincia buenosAires = Provincia.get(20)
		Provincia caba = Provincia.get(19)
		Estado activo = Estado.findByNombre('Activo')
		Cuenta.list().each{
			println "\nCuenta: $it"
			if (! it.porcentajesProvinciaIIBBActivos){
				Provincia prov
				println "Regimen: " + it.regimenIibb.nombre
				if (it.regimenIibb.nombre == "B.A. Mensual")
					prov = buenosAires
				else if(it.regimenIibb.nombre == "Sicol")
					prov = caba
				else
					return // No configuro cuentas que no sean arba ni agip
				println "Provincia: $prov"


				it.addToPorcentajesProvinciaIIBB(new PorcentajeProvinciaIIBB(
						provincia: prov,
						porcentaje: 100,
						ultimaModificacion: ahora,
						ultimoModificador: "Selenium",
						estado: activo
					)).save(flush:true)
				cont++
			}
		}
		render "Se configuraron $cont cuentas"
	}

	def generarPuntoVentaSelenium(Long id){
		try {
			if (true)
				flash.message = "Punto de venta generado"
			else
				flash.error = "No pudo generarse el punto de venta"
		}
		catch(java.lang.AssertionError e){
			flash.error = e.message.split("finerror")[0]
		}
		redirect(action:'show', id:id)
	}

	def aceptarDelegaciones(String id){
		try {
			def salida = "seleniumService.aceptarDelegaciones(id)"
			flash.message = "Se aceptaron " + salida.cantidad + " delegaciones."
			if (salida.malos)
				flash.error = "Los siguientes cuits dieron error para autorizar al computador: [" + salida.malos.join(", ") + "]"
		}
		catch(Exception e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error = "No pudieron aceptarse delegaciones."
		}
		redirect(action:'list')
	}

	def limpiarContador(){
		Cuenta.findAllByContadorIsNotNullAndServiciosMensualesIsNotNull().findAll{! it.serviciosMensuales.find{it.facturas.find{it.pagada}}}.each{
			it.contador = null
			it.save(flush:true)
		}
		render "listo"
	}

	def actualizarAppsDeprecated(){
		def cuentas = Cuenta.getAll().findAll{it.trabajaConApp()}
		def appOtro = App.findByNombre("Otro")
		def appsDeprecated = ["Uber","Uber Eats","Cabify","Beat","Rappi"]
		cuentas.each{
			if(it.apps.any{item -> appsDeprecated.contains(item.app.nombre)}){
				def itemNew = new ItemApp()
				itemNew.cuenta = it
				itemNew.app = appOtro
				itemNew.save(flush:true, failOnError:true)
				it.apps.add(itemNew)
				it.save(flush:true, failOnError:true)
			}
		}
		render "Apps actualizadas"
	}

	def asociarPrimerPago(){
		// def inicio = LocalDateTime.now().localMillis
		Cuenta cuenta;
		Cuenta.list().each{
			cuenta = it
			boolean salir;
			for(mensual in cuenta.serviciosMensuales.sort{it.fechaAlta}) {
				salir = false;
				for(factura in mensual.facturas.sort{it.fechaHora}) {
					if (factura.pagada){
						cuenta.primeraFacturaSMPaga = factura
						cuenta.save(flush: false)
						salir = true;
						break
					}
				}
				if (salir)
					break
			}
		}
		cuenta.save(flush:true)
		flash.message = "Primer pago asociado a las cuentas."
		redirect(controller:'panelEstadistico', action:'gerencia')
	}

	def numerarLocales(){
		Cuenta.findAllByEstado(Estado.findByNombre("Activo")).each{
			int num = 1
			it.localesActivos?.each{
				it.with{
					numeroLocal = num
					save(flush:false, failOnError:true)
				}
				num++
			}
			it.locales.findAll{it.estado.nombre == 'Borrado'}?.each{
				it.with{
					numeroLocal = num
					save(flush:false, failOnError:true)
				}
				num++
			}
		}
		Cuenta.first().save(flush:true)
		render "Locales numerados"
	}

	def verificarSaldosMalos(){
		String salida = "Lista de clientes cuyo saldo no coincide con la suma de sus movimientos impagos:\n\n"
		Cuenta.list()*.with{
			if (movimientos){
				Double totalMovimientos = (movimientos.findAll{ ! it.pagado }?.sum{it.importe}) ?: 0.00
				if (saldo && totalMovimientos && totalMovimientos * -1 != saldo)
					salida += "Cuenta:" + '<a href ="' + createLink(action: 'show', id: id) + '">' + " $it </a>\n Saldo entre comillas: ${saldo * -1} \n Saldo calculado: $totalMovimientos \n \n"
			}
		}
		render salida.replaceAll("\n", "<br/>")
	}

	def verificarPagosImpagos(){
		String salida = "Lista de clientes que tienen movimientos con pagos asociados pero no acreditados:\n\n"
		Cuenta.list()*.with{
			// salida += "hola\n"
			if (estado.nombre == "Activo" && movimientos.findAll{it.with{ pago && ! pagado}})
				salida += '<a href ="' + createLink(action: 'show', id: id) + '">' + it.toString() + "</a>\n"
		}
		render salida.replaceAll("\n", "<br/>")
	}

	def recalcularSaldo(Long id){
		movimientoCuentaService.calcularSaldo(id)
		redirect(action:"show", id: id)
	}

	def eliminarMovLiq(){
		Integer total = 0;
		def cuentas = []
		MovimientoCuenta.createCriteria().list(){
			and{
				isNotNull('declaracion')
			}
		}.findAll{! it.pagado}?.each{
			cuentas << it.cuenta.id
			it.setPago(null)
			it.delete(flush:true, fainOnError:true)
			total++
		}
		cuentas = cuentas.unique()
		cuentas.each{
			movimientoCuentaService.calcularSaldo(it)
		}
		render "Se eliminaron $total movimientos y se recalculó el saldo de ${cuentas.size()} cuentas."
	}

	def crearLocal(){
		def salida
		String token = Estudio.get(1).mercadoPagoAccessTokenProduccion
		String mercadoLink = "https://api.mercadopago.com/pos?access_token=$token"
		println "\n${mercadoLink}\n"
		def httpconection = new groovyx.net.http.HTTPBuilder(mercadoLink);
		httpconection.request( groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON ) { req ->
			body = [name:"PavoniCaja2", 
					fixed_amount: false,
					external_store_id: "1"//,
					// external_id: "exper4",
					// url: createLink(controller:'pagoCuenta', action:'mercadoPagoQR', id:666, absolute:true)
					]
			response.failure = { resp, reader ->
				println "\nF\n"
				salida = "Status: ${resp.status}<br/><br/>Text: ${reader}"
			}
			response.success = { resp, reader ->
				println "\nG\n"
				salida = "Status: ${resp.status}<br/><br/>Text: ${reader}"
				println "\n\n$salida \n\n"
				redirect(url:reader.qr.template_document)
			}
		}
		render salida
	}

	def getCajas(){
		def salida
		String token = Estudio.get(1).mercadoPagoAccessTokenProduccion
		String mercadoLink = "https://api.mercadopago.com/pos?access_token=$token&external_store_id=1"
		println "\n${mercadoLink}\n"
		def httpconection = new groovyx.net.http.HTTPBuilder(mercadoLink);
		httpconection.request( groovyx.net.http.Method.GET, groovyx.net.http.ContentType.JSON ) { req ->
			//body = [store_id: "1", 
			//		external_store_id: "1"]
			response.failure = { resp, reader ->
				println "\nF\n"
				salida = "Status: ${resp.status}<br/><br/>Text: ${reader}"
			}
			response.success = { resp, reader ->
				println "\nG\n"
				salida = "Status: ${resp.status}<br/><br/>Text: ${reader}"
				println "\n\n$salida \n\n"
				//redirect(url:reader.qr.template_document)
			}
		}
		render salida
	}

	def generarPuntosPorLocal(){
		String token = Estudio.get(1).mercadoPagoAccessTokenProduccion
		String mercadoLink = "https://api.mercadopago.com/pos?access_token=$token"
		def httpconection = new groovyx.net.http.HTTPBuilder(mercadoLink);
		Cuenta.findAllByEstado(Estado.findByNombre('Activo')).each{
			it.locales?.each{
				def local = it
				httpconection.request( groovyx.net.http.Method.POST, groovyx.net.http.ContentType.JSON ) { req ->
					body = [name:it.direccion, 
							fixed_amount: true,
							external_store_id: "1",
							external_id: it.id,
							url: createLink(controller:'pagoCuenta', action:'mercadoPagoQR', id:it.id , absolute:true)]
					response.failure = { resp, reader ->
						println "\n\nStatus: ${resp.status}<br/><br/>Text: ${reader}\n"
					}
					response.success = { resp, reader ->
						println "\n\nStatus: ${resp.status}<br/><br/>Text: ${reader}\n"
						local.with{
							urlQrCode = reader.qr.template_image
							save(flush:true)
						}
					}
				}
			}
		}
		render "Locales creados."
	}

	def index() {
		redirect(action: "list", params: params)
	}

	def consultarAfip(String id, String cuit, Long cuentaId){
		String cuitAMandar = cuit ?: (Cuenta.get(cuentaId)?.cuit ?: "20282509009")
		render afipService.dispararServiceWsfe(id, cuitAMandar)
	}
	def list() {
		if (accessRulesService.currentUser?.esCalim)
			render(view: "listCalim", model:[etiqueta:''])
		else
			render(view: "listPavoni")
	}

	def buscar(){
	}

	def listBorradas() {
	}

	def listDelivery() {
	}

	def listPendientes() {
	}

	def listAbonos() {
	}

	def listVentas(){
	}

	def listSuspendidas(){
	}

	def listVerdes(){
		render(view: "listCalim", model:[etiqueta:'Verde'])
	}

	def listNaranjas(){
		render(view: "listCalim", model:[etiqueta:'Naranja'])
	}

	def listAmarillos(){
		render(view: "listCalim", model:[etiqueta:'Amarillo'])
	}

	def listDeudores() {
	}

	def listRiders() {
	}

	@Secured(['ROLE_USER', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def create() {
		if (accessRulesService.currentUser?.esCalim)
			render(view: "createCalim")
		else
			[cuentaInstance: cuentaService.createCuentaCommand()]
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM','ROLE_SE','ROLE_VENTAS','IS_AUTHENTICATED_FULLY'])
	def save(CuentaCommand command) {
		if (command.hasErrors()) {
			flash.error = message(code: 'zifras.cuenta.Cuenta.command.hasErrors', default:'Algun atributo esta mal')
			render(view: "create", model: [cuentaInstance: command])
			return
		}
		
		def cuentaInstance
		
		try {
			cuentaInstance = cuentaService.saveCuenta(command)
		}catch (e){
			flash.error	= message(code: 'zifras.cuenta.Cuenta.save.error', default: 'Error al intentar salvar al cuenta')
			render(view: "create", model: [cuentaInstance: command])
			return
		}
		
		if (cuentaInstance.hasErrors()) {
			flash.error = message(code: 'zifras.cuenta.Cuenta.error.datoExistente', default:'Este valor ya existe en la base')
			command.errors = cuentaInstance.errors
			render(view: "create", model: [cuentaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.created.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), cuentaInstance.toString()], encodeAs:'none')
		redirect(action: "list")
	}

	@Secured(['ROLE_ADMIN','ROLE_SM','ROLE_SE','ROLE_VENTAS','IS_AUTHENTICATED_FULLY'])
	def saveCalim(CuentaCalimCommand command) {
		command.email = command.email?.toLowerCase()
		
		def cuenta = Cuenta.findByEmail(command.email)
		if(cuenta){
			flash.error = "Ya hay una cuenta registrada con ese email"
			redirect(action:'show',params:['id':cuenta.id])
			return
		}

		try {
			assert ! command.hasErrors() : "Campos inválidos: " + command.errors.allErrors.collect{it.field}.join(", ") + "finerror"
			def facturaId = cuentaService.saveCuentaCalim(command, params.servicios)
			flash.message = "Se creó correctamente la cuenta"
			if (facturaId)
				redirect(controller:'facturaCuenta', action:'show', id:facturaId)
			else
				redirect(action:'listPendientes')
			return
		}
		catch(Exception e) {
			flash.error = "Ocurrió un error creando la cuenta"
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		catch(java.lang.AssertionError e){
			flash.error = e.message.split("finerror")[0]
		}
		redirect(action:'create')
	}

	def show(Long id) {
		def cuentaInstance = cuentaService.getCuenta(id)
		if (!cuentaInstance) {
			def intentoCuit = cuentaService.getCuentaByCuit(id.toString())
			if (intentoCuit){
				redirect(action: "show", id:intentoCuit.id)
				return
			}
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), id])
			redirect(action: "list")
			return
		}

		def locales = cuentaInstance.locales.sort{it.numeroLocal}
		
		def hoy = new LocalDate().minusMonths(1)
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		
		[cuentaInstance: cuentaInstance, ano: ano, mes:mes, fechaHoy: hoy.toString("dd/MM/YYYY"), locales:locales, ultimaDeudaCCMA: cuentaInstance.ultimaDeudaCCMA]
	}

	def convenio(Long id, Integer ano) {
		def cuentaInstance = cuentaService.getCuenta(id)
		if (!cuentaInstance) {
			cuentaInstance = cuentaService.getCuentaByCuit(id.toString())
			if (! cuentaInstance){
				flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), id])
				redirect(action: "list")
				return
			}
		}
		if (!ano)
			ano = new LocalDate().minusMonths(2).year
		[cuentaId:id, cuit:cuentaInstance.cuit, razonSocial: cuentaInstance.razonSocial, ano:ano]
	}

	def servicios(Long id) {
		def cuentaInstance = cuentaService.getCuenta(id)
		if (!cuentaInstance) {
			def intentoCuit = cuentaService.getCuentaByCuit(id.toString())
			if (intentoCuit){
				redirect(action: "servicios", id:intentoCuit.id)
				return
			}
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), id])
			redirect(action: "list")
			return
		}

		[cuentaId: cuentaInstance.id, profesion:cuentaInstance.profesion, cuentaNombre: cuentaInstance.toString(), fechaHoy: new LocalDate().toString("dd/MM/YYYY"), cuentaDebitoAutomatico: cuentaInstance.tarjetaDebitoAutomatico!=null]
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM','ROLE_SE','ROLE_VENTAS','IS_AUTHENTICATED_FULLY'])
	def edit(Long id) {
		def cuentaInstance = cuentaService.getCuentaCommand(id)
		def appsCuenta = cuentaInstance?.apps?.split(',')
		def apps = cuentaService.getAllApps()
		if (!cuentaInstance) {
			flash.error = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), id])
			redirect(action: "list")
			return
		}

		[cuentaInstance: cuentaInstance, appsCuenta:appsCuenta, apps:apps]
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM','ROLE_SE','ROLE_VENTAS','IS_AUTHENTICATED_FULLY'])
	def editPorAfip(Long id, String cuit) {
		try {
			def cuentaInstance = cuentaService.getCuentaCommand(afipService.llenarCuentaConResponse(cuit, id, false))
			cuentaInstance.version++
			def appsCuenta = cuentaInstance?.apps?.split(',')
			def apps = cuentaService.getAllApps()
			render(view: "edit", model: [cuentaInstance: cuentaInstance, appsCuenta:appsCuenta, apps:apps])
		}
		catch(Exception e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error = "Error obteniendo datos AFIP"
			redirect(action:'edit', id:id)
		}
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM','ROLE_SE','ROLE_VENTAS','IS_AUTHENTICATED_FULLY'])
	def update(CuentaCommand command) {
		if (command.hasErrors()) {
			flash.error = command.getErrors()
			render(view: "edit", model: [cuentaInstance: command])
			return
		}
		
		def cuentaInstance
		
		try {
			cuentaInstance = cuentaService.updateCuenta(command)
		}
		catch (ValidationException e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			command.errors = e.errors
			flash.error = "Los siguientes campos contienen errores: " + command.errors.allErrors.collect{it.field}
			render(view: "edit", model: [cuentaInstance: command])
			return
		}
		catch (e) {
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error = e.toString()
			render(view: "edit", model: [cuentaInstance: command])
			return
		}
		
		flash.message = message(code: 'default.updated.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), cuentaInstance.toString()], encodeAs:'none')
		redirect(action: "show", id: command.cuentaId)
	}

	def updatePendiente(String nombre, Long cuentaId, String detalle, String telefono){ // Deprecated?
		try {
			cuentaService.updateCuentaPendiente(nombre, cuentaId, detalle, telefono)	
		}
		catch(Exception e) {
			flash.error = "No pudo editarse la cuenta"
		}
		redirect(action: "show", id: cuentaId)
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM','ROLE_SE','ROLE_VENTAS','IS_AUTHENTICATED_FULLY'])
	def delete(Long id) {
		def cuentaInstance = cuentaService.getCuenta(id)
		if (!cuentaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), id])
			redirect(action: "list")
			return
		}
		String nombre = cuentaInstance.nombreApellido

		try {
			cuentaService.borrarCuenta(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), nombre], encodeAs:'none')
			redirect(action: "show", id: id)
		}
	}

	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def deleteFisico(Long id) {
		def cuentaInstance = cuentaService.getCuenta(id)
		if (!cuentaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), id])
			redirect(action: "list")
			return
		}
		String nombre = cuentaInstance.nombreApellido

		try {
			cuentaService.deleteCuenta(id)
			flash.message = message(code: 'default.deleted.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.deleted.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), nombre], encodeAs:'none')
			redirect(action: "show", id: id)
		}
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM','ROLE_SE','ROLE_VENTAS','IS_AUTHENTICATED_FULLY'])
	def recuperar(Long id) {
		def cuentaInstance = cuentaService.getCuenta(id)
		if (!cuentaInstance) {
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), id])
			redirect(action: "list")
			return
		}
		String nombre = cuentaInstance.nombreApellido

		try {
			cuentaService.recuperarCuenta(id)
			flash.message = message(code: 'default.recuperada.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), nombre], encodeAs:'none')
			redirect(action: "list")
		}
		catch (DataIntegrityViolationException e) {
			flash.error = message(code: 'default.not.recuperada.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), nombre], encodeAs:'none')
			redirect(action: "show", id: id)
		}
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_SM','ROLE_SE','ROLE_VENTAS','IS_AUTHENTICATED_FULLY'])
	def suspender(Long id){
		def cuentaInstance = Cuenta.get(id)
		if(!cuentaInstance){
			flash.message = message(code: 'default.not.found.message', args: [message(code: 'zifras.cuenta.Cuenta.label', default: 'Cuenta'), id])
			redirect(action:"list")
			return
		}
		try{
			cuentaService.suspenderCuenta(id)
			flash.message = "La cuenta "+id.toString()+" se ha suspendido exitosamente"
			redirect(action:"list")
		}
		catch(e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			flash.error = "Ha ocurrido un error suspendiendo la cuenta "+id.toString()
			redirect(action:"list")
		}
	}

	def activacionManual(Long cuentaId, String cuit){
		try {
			afipService.guardarResponseEnCuenta(cuit, cuentaId)
			cuentaService.activacionManualToken(cuentaId)
			flash.message = "Se activó manualmente la cuenta"
		}
		catch(Exception e) {
			log.error(e.message)
			flash.error = "Ocurrió un error activando la cuenta: ${e.message}"
		}
		redirect(action: "show", id: cuentaId)
	}

	def ajaxObtenerDatosAfip(String cuit){
		try {
			render afipService.llenarCommandRegistro(cuit) as JSON
		}
		catch(java.lang.AssertionError e){
			def salida = [:]
			salida["error"] = e.message.substring(0,e.message.indexOf('..')+1)
			render salida as JSON
		}
		catch(Exception e) {
			if (e.localizedMessage.contains('No existe')){
				def salida = [:]
				salida["error"] = "El cuit ingresado no existe."
				render salida as JSON
			}
			else{
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				def salida = [:]
				salida["error"] = "Ocurrió un error intentando recuperar los datos de la AFIP."
				render salida as JSON
			}
		}
	}

	def resolverErrorAfip(Long id){
		cuentaService.actualizarErrorAfip(id,false)
		flash.message = "El usuario no posee más error de registro AFIP!"
		redirect(action:"show", params:['id':id])
	}

	def cambiarEtiqueta(Long cuentaId, String color){
		try {
			cuentaService.cambiarEtiqueta(cuentaId, color)
		}
		catch(java.lang.AssertionError e) {
			flash.error = e.message.split("finerror")[0]
		}
		redirect(action: "show", id: cuentaId)
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasList(String filter){
		render cuentaService.listCuenta(filter) as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasSQL(String etiqueta){
		render cuentaService.listCuentaSql(Estado.findByNombre("Activo"), etiqueta) as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxBuscarSQL(String filtro, String campo){
		render cuentaService.buscarSql(filtro,campo) as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasDeliverySQL(String etiqueta){
		render cuentaService.listCuentaDeliverySql() as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasPavoniSQL(){
		render cuentaService.listCuentasPavoniSql() as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxListEtapasSelenium(String mes, String ano, Integer etapa, Boolean simplificado, String etiqueta, Long cuentaId){
		if (cuentaId)
			render cuentaService.listEtapasSeleniumCuenta(cuentaId, ano) as JSON
		else
			render cuentaService.listEtapasSeleniumSql(mes, ano, etapa, simplificado, etiqueta) as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasAbonosSQL(){
		render cuentaService.listCuentaAbonoSql() as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasNombresSQL(){
		render cuentaService.listCuentaNombreSql() as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasVentasList(String filter){
		def cuentas = cuentaService.listCuentasVentas(filter)
		render cuentas as JSON
	}

	@Secured(['ROLE_USER','ROLE_CUENTA' ,'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetApps(Long id){
		def apps = cuentaService.listApps(id)
		render apps as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasMonoSimplificadoList(String filter){
		def cuentas = cuentaService.listCuentasMonoSimplificado(filter)
		render cuentas as JSON
	}


	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasBorradasList(){
		def cuentas = cuentaService.listCuentasBorradas()
		render cuentas as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasSuspendidasList(){
		def cuentas = cuentaService.listCuentasSuspendidas()
		render cuentas as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentasPendientesList(){
		render cuentaService.listCuentaSql(Estado.findByNombre("Sin verificar")) as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuenta(Long id){
		def cuenta = cuentaService.getCuenta(id)
		render cuenta as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCuentaPorLocal(Long id){
		def cuenta = cuentaService.getCuentaPorLocal(id)
		render cuenta as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLocales(Long id){
		def locales = cuentaService.listLocales(id)
		render locales as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetLocalesAllList(){
		def locales = cuentaService.listAllLocales()
		render locales as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetAlicuotasIIBB(Long id){
		def alicuotasIIBB = cuentaService.listAlicuotasIIBB(id)
		render alicuotasIIBB as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetPorcentajesActividadIIBB(Long id){
		def porcentajesActividadIIBB = cuentaService.listPorcentajesActividadIIBB(id)
		render porcentajesActividadIIBB as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetPorcentajesProvinciaIIBB(Long id){
		def porcentajesProvinciaIIBB = cuentaService.listPorcentajesProvinciaIIBB(id)
		render porcentajesProvinciaIIBB as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetParientes(Long id){
		def parientes = cuentaService.listParientes(id)
		render parientes as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetPariente(Long id){
		def pariente = cuentaService.getPariente(id)
		render pariente as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetTiposClaveList(){
		render cuentaService.listTiposClave() as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetTiposPersonaList(){
		render cuentaService.listTiposPersona() as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetImpuestosList(){
		render cuentaService.listImpuestos() as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCategoriasList(){
		render cuentaService.listCategorias() as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA','ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetNacionalidades(){
		render cuentaService.listNacionalidades() as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA','ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetObrasSociales(){
		render cuentaService.listObrasSociales() as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetCantidadImpuestos(Long id){
		render cuentaService.getCantidadImpuestos(id) as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxReenviarMailBienvenida(Long cuentaId){
		render cuentaService.reenviarMailBienvenida(cuentaId) as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxReenviarMailMasivoBienvenida(String cuentasIds){
		def ids = cuentasIds.split(',')
		def cuentas = []
		def fechaHoy = new LocalDateTime()
		def fechaUltimoMail
		def cuenta
		ids.each{
			cuenta = Cuenta.get(it)
			fechaUltimoMail = cuenta?.ultimoMailConfirmacion?.fechaHora
			if(User.findByUsername(cuenta?.email)?.accountLocked)
				if(fechaUltimoMail?.isBefore(fechaHoy.minusDays(1)) || fechaUltimoMail == null)
					cuentas.add(cuentaService.reenviarMailBienvenida(new Long(it)))
		}
		render cuentas as JSON
	}

	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def entrar(String id){
		String mail
		if (id)
			mail = usuarioService.getUsuarioPorCuenta(id)?.username
		else 
			mail = "christian@calim.com.ar"
		springSecurityService.reauthenticate(mail)
		redirect(controller:"start")
	}

	def ajaxCambiarBooleanoPasos(Long cuentaId, String nombreBooleano){
		try {
			cuentaService.cambiarBooleanoPasos(cuentaId, nombreBooleano)	
		}
		catch(java.lang.AssertionError e){
			println "Error actualizando booleano para la cuenta ${cuentaId}"
		}
		render [:] as JSON
	}

	def ajaxObtenerDeudores(){
		render cuentaService.obtenerDeudores() as JSON
	}

	@Secured(['ROLE_CUENTA','ROLE_RIDER_PY'])
	def appGetCuenta(){
		def cuentaInstance = accessRulesService.getCurrentUser()?.cuenta
		if(cuentaInstance)
			render cuentaInstance as JSON
		else
			render ""
	}

	@Secured(['permitAll'])
	def appGetEstado(String mail) {
		def estudioCalim = Estudio.findByNombre('Calim')

		def cuentaInstance
		withId(new Integer(estudioCalim.id.toString())) {
			cuentaInstance = cuentaService.getCuentaByEmail(mail)
		}
		if(cuentaInstance)
			render cuentaInstance.estado as JSON 
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_CUENTA','ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetMediosPago(Long condicionIvaId, Long regimenIibbId){
		render cuentaService.listMediosPago(condicionIvaId, regimenIibbId) as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN','ROLE_CUENTA','ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetMediosPagoCuenta(){
		def cuenta = accessRulesService.getCurrentUser()?.cuenta
		render cuentaService.listMediosPago(cuenta.condicionIva.id, cuenta.regimenIibb.id) as JSON
	}

	@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_CUENTA','ROLE_VENTAS','ROLE_SM','ROLE_SE','ROLE_COBRANZA','ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxBorrarCuentas(String cuentasIds){
		def ids = cuentasIds.split(',')
		def cuentas = []
		ids.each{
			cuentas.add(cuentaService.borrarCuenta(new Long(it)))
		}
		render cuentas as JSON
	}

	@Secured(['ROLE_RIDER_PY','ROLE_CUENTA','ROLE_USER'])
	def ajaxCargarClaveFiscal(String cuit, String claveFiscal){
		def cuenta = accessRulesService.getCurrentUser()?.cuenta
		def respuesta = "seleniumService.validarCUIT((cuit ?: cuenta.cuit),claveFiscal)"
		if(respuesta == "OK"){
			try {
				cuenta = cuentaService.actualizarCuit(cuenta.id, cuit)
				cuenta = cuentaService.actualizarClaveFiscal(cuenta.id, claveFiscal)
				if(cuenta.actionRegistro != "registroCompleto"){
					try{
						if(cuenta.bitrixDealId)
							bitrixService.editarNegociacion(cuenta.bitrixDealId,["fields":["STAGE_ID":"C5:2"]])
					}
					catch(e2){
						log.error("Error actualizando stage de Deal a Informo CF")
					}
				}
				try {
					if (!cuenta.trabajaConApp())
						//seleniumService.puntoVenta(cuenta)
						println "selenium service puntoVenta"
					else if (cuenta.inscriptoAfip)
						notificacionService.enviarEmailInterno("alejandro@calim.com.ar", "Clave Fiscal Delivery", "La cuenta <a href='/cuenta/show/${cuenta.id}'>${cuenta}</a> ingresó su CUIT y clave fiscal, hay que generarle un punto de venta.")
				}
				catch(Exception e3) {
					log.error("\n\nNo pudo generarse punto de venta para $cuenta \n" + e.message)
					notificacionService.enviarEmailInterno("info@calim.com.ar", "Error Punto de venta", "Para la cuenta <a href='/cuenta/show/${cuenta.id}'>${cuenta}</a>")
					println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
					println ""
				}catch(java.lang.AssertionError e4){
					log.error("\n\nNo pudo generarse punto de venta para $cuenta \n" + e4.message.split("finerror")[0])
				}
				
				render cuenta as JSON
			}
			catch(Exception e) {
				def salida = [:]
				salida['error'] = "Ya existe una cuenta con este CUIT."
				render salida as JSON
			}
		}
		else{
			def salida = [:]
			salida['error'] = respuesta
			render salida as JSON
		}	
	}

	def ajaxGetRiders(){
		render cuentaService.getRiders() as JSON
	}

	def bajarFotos(Long id){ 
		try {
			response.setContentType("APPLICATION/OCTET-STREAM")
			def archivo = cuentaService.descargarFotos(id)
				response.setHeader("Content-Disposition", "Attachment;Filename=\"${archivo.getName()}\"")
				def fileInputStream = new FileInputStream(archivo)
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
			flash.error="Ocurrió un error descargando el archivo."
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
		}
		redirect(action: "show", id:id)
	}

	@Secured(['ROLE_USER', 'ROLE_CUENTA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
	def ajaxActualizarDomicilio(String direccion, String codigoPostal){
		def cuentaInstance = accessRulesService.getCurrentUser().cuenta
		def respuesta = [:]

		try{
			cuentaService.actualizarDomicilioError(cuentaInstance.id, direccion, codigoPostal)
			respuesta['ok'] = "Domicilio actualizado correctamente"
		}
		catch(e){
			respuesta['error'] = "Ocurrió un error actualizando el domicilio"
		}
		render respuesta as JSON
	}

	def ajaxGetCuentasSMActivo(){
		def cuentas = cuentaService.listCuentasSMActivo()
		render cuentas as JSON
	}

	def afip(Long id){
		String ip = request.getHeader("Client-IP") ?: request.getHeader("X-Forwarded-For") ?: request.getRemoteAddr()
		String msjerror = "seleniumService.loginExterno(id, ip)"
		if (msjerror)
			flash.error = msjerror
		redirect(action:'show',id:id)
	}

	def consultarCCMA(Long id){
		try {
			flash.message = "CCMA recalculado"
		}
		catch(AssertionError e) {
			flash.error = e.message.split("finerror")[0]
		}
		redirect(action:'show', id:id)
	}

	def actualizarCCMAs(){
		String reporte = "Aaa"
		notificacionService.enviarEmailInterno("franco@calim.com.ar", "Erroes calculando CCMA", reporte)
		render reporte
	}

	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def listCcma(){

	}
	@Secured(['ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
	def ajaxGetListDeudasCcma(){
		render cuentaService.listCCMASql() as JSON
	}

	def ajaxObtenerDistribucionConvenio(Long cuentaId, Integer ano){
		render cuentaService.coeficientesConvenio(cuentaId, ano) as JSON
	}
}