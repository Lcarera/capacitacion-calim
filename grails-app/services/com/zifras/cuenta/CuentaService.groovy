package com.zifras.cuenta

import static com.zifras.Auxiliar.formatear

import com.zifras.AccessRulesService
import com.zifras.BitrixService
import com.zifras.Contador
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.GoogleAPIService
import com.zifras.Localidad
import com.zifras.Provincia
import com.zifras.TokenGoogle
import com.zifras.User
import com.zifras.UserTrack
import com.zifras.Zona
import com.zifras.app.App
import com.zifras.app.ItemApp
import com.zifras.debito.Tarjeta
import com.zifras.descuento.CodigoDescuento
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.FacturaCuentaService
import com.zifras.facturacion.FacturaCompra
import com.zifras.facturacion.FacturaVenta
import com.zifras.importacion.LogSelenium
import com.zifras.liquidacion.RetencionPercepcionIIBB
import com.zifras.notificacion.Email
import com.zifras.notificacion.NotificacionService
import com.zifras.notificacion.NotificacionTemplate
import com.zifras.security.RegisterCommand
import com.zifras.security.RegistrarController
import com.zifras.servicio.ItemServicioEspecial
import com.zifras.servicio.ItemServicioMensual
import com.zifras.servicio.Servicio
import com.zifras.servicio.ServicioService
import com.zifras.ventas.Vendedor

import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.ui.RegistrationCode
import grails.transaction.Transactional
import grails.validation.ValidationException
import grails.web.mapping.LinkGenerator
import groovy.json.JsonSlurper
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import org.springframework.context.MessageSource
import org.springframework.context.i18n.LocaleContextHolder
import static grails.gorm.multitenancy.Tenants.*

@Transactional
class CuentaService {
	AccessRulesService accessRulesService
	def bitrixService
	MessageSource messageSource
	def facturaCuentaService
	def googleAPIService
	def grailsApplication
	def notificacionService
	def sessionFactory
	def servicioService
	def usuarioService
    LinkGenerator grailsLinkGenerator

	def createCuentaCommand(){
		def command = new CuentaCommand()
		def currentUser = accessRulesService.getCurrentUser()
		command.tenantId = currentUser.userTenantId

		def condicion = CondicionIva.findByNombre('Responsable inscripto')
		def regimen = RegimenIibb.findByNombre('Simplificado')
		def convenioMultilateral = RegimenIibb.findByNombre('Convenio Multilateral')
		def estadoActivo = Estado.findByNombre('Activo')
		def localidadCaba = Localidad.findByNombre('CABA')
		def provinciaCaba = Provincia.findByNombre('CABA')
		def actividadDefault = Actividad.findByNombre('MINIMERCADO')


		if(condicion!=null)
			command.condicionIvaId = condicion.id
		if(regimen!=null)
			command.regimenIibbId = regimen.id
		if(estadoActivo!=null)
			command.estadoActivoId = estadoActivo.id
		if(localidadCaba!=null)
			command.localidadCabaId = localidadCaba.id
		if(provinciaCaba!=null)
			command.provinciaCabaId = provinciaCaba.id
		if(convenioMultilateral!=null)
			command.convenioMultilateralId = convenioMultilateral.id
		if(actividadDefault!=null)
			command.actividadDefaultId = actividadDefault.id

		if (command.tenantId == 2){
			command.estadoClaveId = estadoActivo.id
			command.tipoClaveId = TipoClave.findByNombre("CUIT").id
			command.tipoPersonaId = TipoPersona.findByNombre("FISICA").id
			command.mesCierre = 12
		}

		return command
	}

	def updateMediosPago(Long medioPagoIvaId, Long medioPagoIibbId, Long cuentaId){
		def cuentaInstance = Cuenta.get(cuentaId)

		if(medioPagoIvaId)
			cuentaInstance.medioPagoIva = MedioPago.get(medioPagoIvaId)
		
		if(medioPagoIibbId)
			cuentaInstance.medioPagoIibb = MedioPago.get(medioPagoIibbId)
		
		println "test"
		cuentaInstance.save(flush:true, failOnError:true)

	}

	def updateCuentaUsuario(CuentaCommand command){
		def cuentaInstance = Cuenta.get(command.cuentaId)

		if (command.version != null) {
			if (cuentaInstance.version > command.version) {
				CuentaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["Cuenta"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la Cuenta")
				throw new ValidationException("Error de versión", CuentaCommand.errors)
			}
		}

		cuentaInstance.razonSocial = command.razonSocial
		cuentaInstance.nombreApellido = command.nombreApellido
		cuentaInstance.telefono = command.telefono
		cuentaInstance.wechat = command.wechat
		if(cuentaInstance.profesion == "app" && command.profesion != "app")
			borrarApps(cuentaInstance)
		cuentaInstance.profesion = command.profesion
		if(cuentaInstance.profesion == "app")
			actualizarApps(cuentaInstance.id,parsearAppsToIds(command.apps))
		cuentaInstance.whatsapp = command.whatsapp
		def tarjetaAntigua = cuentaInstance.tarjetaDebitoAutomatico
		cuentaInstance.tarjetaDebitoAutomatico = null
		if(tarjetaAntigua)
			tarjetaAntigua.delete(flush:true)
		if(command.numeroTarjeta != null){
			def tarjeta = new Tarjeta()
			tarjeta.numero = command.numeroTarjeta
			tarjeta.visa = (command.numeroTarjeta[0] == "4")
			tarjeta.save(flush:true, failOnError:true)
			cuentaInstance.tarjetaDebitoAutomatico = tarjeta
			if(cuentaInstance.servicioActivo && !cuentaInstance.servicioActivo?.debitoAutomatico && !cuentaInstance.ultimoSMAgregado?.debitoAutomatico)
				generarSMDebitoAutomatico(cuentaInstance.id)
		}
		cuentaInstance.medioPagoIva = MedioPago.get(command.medioPagoIvaId)
		cuentaInstance.medioPagoIibb = MedioPago.get(command.medioPagoIibbId)

		cuentaInstance.save(flush:true, failOnError:true)

		return cuentaInstance
	}

	def generarSMDebitoAutomatico(Long cuentaId){
		def cuentaInstance = Cuenta.get(cuentaId)
		def servicioAntiguo = cuentaInstance.servicioActivo
		def nuevoServicio = new ItemServicioMensual()
		def hoy = new LocalDate()
		def servicio
		LocalDate fecha
		if(servicioAntiguo.getMesFacturado(hoy)){
			def today = java.time.LocalDate.now()
			java.time.LocalDate finMes = today.with(java.time.temporal.TemporalAdjusters.lastDayOfMonth())
			fecha = hoy.withDayOfMonth(new Integer(finMes.toString().split("-")[2])) //le ponemos una fecha posterior a la de cobro de debitos automaticos
		}
		else
			fecha = hoy

		try{
			servicio = servicioService.adherirMensual(servicioAntiguo.servicio,servicioAntiguo.descuento,cuentaInstance,0,true,fecha,false,servicioAntiguo.responsable)
		}
		catch(java.lang.AssertionError e){
			log.error(e.message)
			log.error(e.message.substring(0,e.message.indexOf('..')+1))
			throw new Exception("Ocurrio un error generando el Servicio Mensual automatico")
		}
		
		return servicio
	}

	def listSicol(Boolean soloVerdesNaranjas = true){
		return Cuenta.createCriteria().list() {
			and{
				eq('estado', Estado.findByNombre('Activo'))
				if(soloVerdesNaranjas)
					or{
						eq('etiqueta', 'Verde')
						eq('etiqueta', 'Naranja')
					}
				or{
					eq('regimenIibb', RegimenIibb.findByNombre("Sicol"))
					eq('regimenIibb', RegimenIibb.findByNombre("Convenio Multilateral"))
				}
			}
		}
	}

	def listArba(Boolean soloVerdesNaranjas = true){
		return Cuenta.createCriteria().list() {
			and{
				eq('estado', Estado.findByNombre('Activo'))
				if(soloVerdesNaranjas)
					or{
						eq('etiqueta', 'Verde')
						eq('etiqueta', 'Naranja')
					}
				or{
					eq('regimenIibb', RegimenIibb.findByNombre("B.A. Mensual"))
					eq('regimenIibb', RegimenIibb.findByNombre("Convenio Multilateral"))
				}
			}
		}
	}

	def listIva(Boolean soloVerdesNaranjas = true){
		return Cuenta.createCriteria().list() {
			and{
				eq('estado', Estado.findByNombre('Activo'))
				if(soloVerdesNaranjas)
					or{
						eq('etiqueta', 'Verde')
						eq('etiqueta', 'Naranja')
					}
				eq('condicionIva', CondicionIva.findByNombre("Responsable inscripto"))
			}
		}
	}

	def listCuenta(String filter, Boolean soloVerdesNaranjas = false) {
		Cuenta.createCriteria().list() {
			eq('estado', Estado.findByNombre('Activo'))
			if(soloVerdesNaranjas)
				or{
					eq('etiqueta', 'Verde')
					eq('etiqueta', 'Naranja')
				}
			if(filter)
				and{
					or{
						ilike('cuit', '%' + filter + '%')
						ilike('razonSocial', '%' + filter + '%')
					}
				}
		}
	}

	def listCuentaSql(Estado estado, String etiqueta = '', String restriccionesAdicionales = ''){
		String query = """
			SELECT cuenta.id,
			       cuit, 
			       razon_social, 
			       telefono, 
			       condicion_iva.nombre  AS condIva, 
			       tokenfcm IS NOT NULL  AS app, 
			       profesion,
			       por_pro.provincias, 
			       regimen_iibb.nombre   AS regimeniibb, 
			       email, 
			       punto_venta_calim, 
			       afip_miscomprobantes, 
			       arba_presentacion_ddjj, 
			       agip_gestionar, 
			       info_revisada,
			       etiqueta,
			       not users.account_locked as mailConfirmado,
			       to_char( fecha_alta, 'DD/MM/yyyy') as fecha_alta,
			       date_part('epoch',fecha_alta) * 1000 as milisegundos,
			       nombre_apellido,
			       categoria.nombre,
			       ingresos_brutos
			FROM   cuenta 
			       LEFT JOIN condicion_iva 
			              ON cuenta.condicion_iva_id = condicion_iva.id 
			       LEFT JOIN (SELECT cuenta_id, 
			                         String_agg(Concat(provincia.nombre, ' - ', round( CAST("porcentaje" as numeric), 2), 
			                                    '%'), 
			                         '<br/>') AS 
			                         provincias 
			                  FROM   porcentaje_provinciaiibb 
			                         JOIN provincia 
			                           ON provincia_id = provincia.id 
			                  WHERE  estado_id = 8 
			                  GROUP  BY cuenta_id) AS por_pro 
			              ON por_pro.cuenta_id = cuenta.id 
			       LEFT JOIN regimen_iibb 
			              ON regimen_iibb.id = cuenta.regimen_iibb_id 
			       LEFT JOIN users
			              ON users.cuenta_id = cuenta.id
			       LEFT JOIN categoria
			       		  ON categoria.id = cuenta.categoria_monotributo_id

			WHERE  estado_id = ${estado.id} AND rider_id is null AND tenant_id = 2
		""" + restriccionesAdicionales
		if (etiqueta)
			query += " AND etiqueta = '${etiqueta}'"
		query += ";"
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.selected = ''
			item.id = it[0]
			item.cuit = it[1] != it[9] ? it[1] : '-'
			item.razonSocial = it[2]
			item.telefono = it[3]
			item.condicionIva = it[4]
			item.appCalimDescargada = it[5]
			item.profesion = it[6]
			item.trabajaConApp = item.profesion == 'app'
			item.esMercadoLibre = item.profesion == 'mercadolibre'
			item.porcentajesProvinciaIIBB = it[7]
			item.regimenIibb = it[8]
			item.email = it[9]
			item.puntoVenta = it[10]
			item.afipMiscomprobantes = it[11]
			item.arbaPresentacionDdjj = it[12]
			item.agipGestionar = it[13]
			item.infoRevisada = it[14]
			item.etiqueta = it[15]
			item.mailConfirmado = it[16]
			item.fechaAlta = it[17]
			item.milisegundos = it[18]
			item.nombreApellido = it[19]
			item.categoriaMonotributo = it[20]
			item.ingresosBrutos = it[21]
			return item
		}
	}

	def buscarSql(String filtro, String campo){
		String restricciones
		if (campo == "todos")
			restricciones = "(cuit ilike '%$filtro%' OR email ilike '%$filtro%' OR razon_social ilike '%$filtro%' OR nombre_apellido ilike '%$filtro%' OR telefono ilike '%$filtro%')"
		else
			restricciones = "$campo ilike '%$filtro%'"
		String query = """
			SELECT id,
			       email,
			       razon_social, 
			       cuit,
			       etiqueta,
			       nombre_apellido,
			       telefono
			FROM   cuenta 
			WHERE  $restricciones AND tenant_id = 2;
		"""
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.id = it[0]
			item.email = it[1]
			item.razonSocial = it[2] != item.email ? it[2] : it[5]
			item.cuit = it[3] != item.email ? it[3] : '-'
			item.telefono = it[6]
			item.etiqueta = it[4]
			return item
		}
	}

	def listCuentaDeliverySql(){
		String query = """
			SELECT cuenta.id,
			       cuit,
			       nombre_apellido,
			       email,
			       razon_social,
			       tokenfcm IS NOT NULL              AS app,
			       clave_fiscal IS NOT NULL          AS clave_fiscal,
			       ingreso_fotos_registro,
			       punto_venta_calim,
			       To_char(fecha_alta, 'DD/MM/yyyy') AS fecha_alta,
			       Date_part('epoch', fecha_alta)    AS milisegundos,
			       action_registro,
			       inscripto_afip,
			       servicios.codigo
			FROM   cuenta
			       LEFT JOIN (SELECT item_servicio.cuenta_id,
			                         codigo
			                  FROM   servicio
			                         JOIN item_servicio
			                           ON servicio.id = item_servicio.servicio_id
			                         JOIN factura_cuenta
			                           ON factura_cuenta.id = item_servicio.factura_id
			                         JOIN movimiento_cuenta
			                           ON movimiento_cuenta.factura_id = factura_cuenta.id
			                         JOIN pago_cuenta
			                           ON pago_cuenta.id = movimiento_cuenta.pago_id
			                              AND pago_cuenta.estado_id = 131824
			                  WHERE  codigo = 'SE17'
			                          OR codigo = 'SE18') AS servicios
			              ON servicios.cuenta_id = cuenta.id
			WHERE  ( estado_id = 8
			          OR estado_id = 766 )
			       AND rider_id IS NULL
			       AND tenant_id = 2
			       AND profesion = 'app';
			"""
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.selected = ''
			item.id = it[0]
			item.cuit = it[1]
			item.email = it[3]
			item.nombre = it[4] != it[3] ? it[4] : it[2]
			item.app = it[5]
			item.claveFiscal = it[6]
			item.fotos = it[7]
			item.puntoVenta = it[8]
			item.fechaAlta = it[9]
			item.milisegundos = it[10]
			item.pasoRegistro = it[11]
			item.inscriptoAfip = it[12]
			item.sePagado = it[13] ?: "-"
			return item
		}
	}

	def listEtapasSeleniumCuenta(Long cuentaId, String ano){
		Cuenta cuenta = Cuenta.get(cuentaId)
		LocalDate fecha = new LocalDate(ano + "-01-01")
		def salida = []
		// String localesCuenta = cuenta.locales.collect{it.toString()}.join("<br/>")
		for(i in 1..12) {
			def item = [:]
			item.selected = ''
			item.id = cuentaId
			cuenta.with{
				item.cuit = cuit
				item.razonSocial ="<a href='/cuenta/show/" + id + "' target='_blank'>" + razonSocial + "</a>"
				item.periodo = fecha.toString("MM")
				item.condicionIva = condicionIva
				item.regimenIibb = regimenIibb
				item.estadoLiq = liquidacionesIIBB.find{it.fecha == fecha}?.estado?.nombre ?: "Sin Liquidar"
				item.local = "localesCuenta"
				item.log = logsSelenium.find{it.mes == fecha} ?: new LogSelenium()
			}
			salida << item
			fecha = fecha.plusMonths(1)
		}
		return salida
	}
	def listEtapasSeleniumSql(String mes, String ano, Integer etapa, Boolean simplificado, String etiqueta){
		String fechaString = "${ano}-${mes}-01"
		def tenant = accessRulesService.currentUser?.userTenantId
		boolean etapa1oSimplificado = etapa == 1 || simplificado
		String query = """
			SELECT cuenta.id,
					cuit, 
					razon_social, 
					condicion_iva.nombre  AS condIva, 
					regimen_iibb.nombre   AS regimeniibb,
					log_selenium.id as log,
					estado.nombre,
					locals.detalle
			FROM cuenta 
					LEFT JOIN (SELECT cuenta_id, 
					                  String_agg(provincia.nombre, '<br/>')             AS 
					provincias, 
					                  String_agg(Concat(direccion, ' - ', telefono, ' - ', 
					                             email, 
					                             ' - ', 
					                             localidad.nombre, ' (', 
					                                        zona.nombre, ')'), '<br/>') AS 
					                  detalle 
					           FROM   local 
					                  LEFT JOIN provincia 
					                         ON provincia.id = local.provincia_id 
					                  LEFT JOIN localidad 
					                         ON localidad.id = local.localidad_id 
					                  LEFT JOIN zona 
					                         ON zona.id = local.zona_id 
					           WHERE  local.estado_id = 8 
					           GROUP  BY cuenta_id) AS locals 
					       ON locals.cuenta_id = cuenta.id
					LEFT JOIN condicion_iva
						ON cuenta.condicion_iva_id = condicion_iva.id
					${etapa == 1 ? 'LEFT' : 'INNER'} JOIN regimen_iibb
						ON regimen_iibb.id = cuenta.regimen_iibb_id """
						if (etapa != 1){
							query += " and (regimen_iibb.id " + (simplificado ? '' : 'not') + " in (16, 1305109)"
							if (simplificado)
								query += ")"
							else {
								query += " or regimen_iibb.id = 14 or condicion_iva.id = 11) "
							}
						}
			query += """\n${etapa1oSimplificado ? 'LEFT' : 'INNER'} JOIN log_selenium
						ON log_selenium.mes = '${fechaString}' and log_selenium.cuenta_id = cuenta.id """ + (etapa1oSimplificado ? '' : "and log_selenium.etapa" + (etapa-1))
			query += """
					LEFT JOIN (select cuenta_id, max(estado_id), fecha from liquidacioniibb group by cuenta_id, fecha) as liqs
						ON liqs.cuenta_id = cuenta.id and liqs.fecha = '${fechaString}'
					LEFT JOIN estado
						ON estado.id = liqs.max
				"""
			query += "\nWHERE  cuenta.estado_id = 8 AND rider_id is null AND tenant_id = $tenant"
			if (tenant == 2)
				query +=" AND etiqueta = '" + etiqueta + "'"
			query += ";"
			return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.selected = ''
			item.id = it[0]
			item.cuit = it[1]
			item.razonSocial ="<a href='/cuenta/show/" + item.id + "' target='_blank'>" + it[2] + "</a>"
			item.periodo = mes
			item.condicionIva = it[3]
			item.regimenIibb = it[4]
			item.log = it[5] ? LogSelenium.get(it[5]) : new LogSelenium()
			item.estadoLiq = it[6] ?: "Sin Liquidar"
			item.local = it[7]
			return item
		}
	}

	def listCCMASql(){
		String hoy = new LocalDate().toString("yyyy-MM-dd")
		def tenant = accessRulesService.getCurrentUser().userTenantId
		String query = """
			SELECT cuenta.id,
			       cuit,
			       razon_social,
			       condicion_iva.nombre AS condIva,
			       regimen_iibb.nombre  AS regimen_iibb,
			       primera_facturasmpaga_id,
			       fecha,
			       deuda,
			       a_favor,
			       email,
			       CONCAT(servicio.codigo, ' (', servicio.subcodigo, ') ', servicio.nombre) as abono,
			       estado.nombre,
			       ultimos3meses_pagos,
			       telefono
			FROM   deudaccma
			       JOIN cuenta
			         ON cuenta.id = deudaccma.cuenta_id and cuenta.tenant_id = $tenant
			       LEFT JOIN condicion_iva
			              ON cuenta.condicion_iva_id = condicion_iva.id
			       LEFT JOIN regimen_iibb
			              ON cuenta.regimen_iibb_id = regimen_iibb.id
			       LEFT JOIN item_servicio 
			              ON class = 'com.zifras.servicio.ItemServicioMensual' and cuenta.id = item_servicio.cuenta_id AND item_servicio.fecha_alta <= '${hoy}' AND (item_servicio.fecha_baja is null OR item_servicio.fecha_baja > '${hoy}')
			       LEFT JOIN servicio
			       		  ON servicio.id = item_servicio.servicio_id
			       LEFT JOIN estado
			       		  ON estado.id = cuenta.estado_id
			WHERE  deudaccma.id IN (SELECT Max(id)
			                        FROM   deudaccma
			                        GROUP  BY cuenta_id); 
		"""
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.selected = ''
			item.id = it[0]
			item.cuit = it[1]
			item.razonSocial = it[2]
			item.condicionIva = it[3]
			item.regimenIibb = it[4]
			item.pagoSm = it[5] ? "Sí" : "-"
			item.fechaConsulta = new LocalDateTime(it[6]).toString("dd/MM/yyyy")
			item.deuda = formatear(it[7])
			item.aFavor = formatear(it[8]) 
			item.email = it[9]
			item.abonoActivo = (it[10]).trim() != "()" ? it[10] : "-"
			item.estado = it[11]
			item.ultimos3MesesPagos = it[12] ? "Sí" : "-"
			item.telefono = it[13]
			return item
		} 
	}

	def listCuentaAbonoSql(){
		String hoy = new LocalDate().toString("yyyy-MM-dd")
		String query = """
			SELECT cuenta.id,
			       cuit, 
			       razon_social, 
			       condicion_iva.nombre  AS condIva,
			       regimen_iibb.nombre  AS regimen_iibb,
			       CONCAT(servicio.codigo, ' (', servicio.subcodigo, ') ', servicio.nombre) as abono,
			       etiqueta,
			       profesion,
			       estado.nombre,
			       email
			FROM   cuenta 
			       LEFT JOIN condicion_iva 
			              ON cuenta.condicion_iva_id = condicion_iva.id
			       LEFT JOIN regimen_iibb 
			              ON cuenta.regimen_iibb_id = regimen_iibb.id
			       LEFT JOIN estado 
			              ON cuenta.estado_id = estado.id
			       INNER JOIN item_servicio 
			              ON cuenta.id = item_servicio.cuenta_id
			       INNER JOIN servicio
			       		  ON servicio.id = item_servicio.servicio_id
			WHERE  
					cuenta.tenant_id = 2
				AND 
					primera_facturasmpaga_id is not null
				AND 
					rider_id is null
				AND 
					servicio.mensual
				AND 
					item_servicio.fecha_alta <= '${hoy}'
				AND 
					(
						item_servicio.fecha_baja is null
					OR
						item_servicio.fecha_baja > '${hoy}'
					)
			;
		"""
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.selected = ''
			item.id = it[0]
			item.cuit = it[1]
			item.razonSocial = it[2]
			item.condicionIva = it[3]
			item.regimenIibb = it[4]
			item.abono = it[5]
			item.etiqueta = it[6]
			item.profesion = it[7]?.capitalize() ?: "Otro"
			item.estado = it[8]
			item.email = it[9]
			boolean servicio_correcto = true
			if (item.abono.contains("SM07") || item.abono.contains("SM08")){
				servicio_correcto = item.profesion == "App"
			}
			else{
				if (item.abono.toLowerCase().contains(item.condicionIva.toLowerCase())){
					if (item.regimenIibb == "Convenio Multilateral")
						servicio_correcto = item.abono.contains("onvenio")
					else if (item.abono.contains("SM03"))
						servicio_correcto = item.regimenIibb == "Unificado" || item.regimenIibb.contains("implificado")
					else
						servicio_correcto = item.abono.contains("local")
				}else
					servicio_correcto = false
			}
			item.abonoCoincide = servicio_correcto ? "Sí" : "No" 
			return item
		}
	}

	def listCuentaNombreSql(){
		String query = """
			SELECT id,
			       cuit, 
			       razon_social
			FROM   cuenta 
			WHERE  estado_id = 8 AND rider_id is null AND tenant_id = """ + (accessRulesService.currentUser?.userTenantId ?: 2) + ";"
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.selected = ''
			item.id = it[0]
			item.cuit = it[1]
			item.razonSocial = it[2]
			item.toString = item.with{cuit + ' - ' + razonSocial}
			return item
		}
	}

	def getRiders(){
		String query = """
			SELECT id,
			       cuit, 
			       razon_social,
			       telefono,
			       rider_id,
			       email
			FROM   cuenta 
			WHERE  rider_id is not null and estado_id = 8 AND tenant_id = 2;"""
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.id = it[0]
			item.cuit = it[1]
			item.nombreApellido = it[2]
			item.telefono = it[3]
			item.riderId = it[4]
			item.email = it[5]
			return item
		}
	}

	def listCuentasPavoniSql(String restriccionesAdicionales = ""){
		String query = """
			SELECT cuenta.id, 
			       cuit, 
			       razon_social, 
			       condicion_iva.nombre as cIva, 
			       locals.detalle, 
			       locals.provincias, 
			       regimen_iibb.nombre as rIibb, 
			       actividad.nombre 
			FROM   cuenta 
			       LEFT JOIN condicion_iva 
			              ON cuenta.condicion_iva_id = condicion_iva.id 
			       LEFT JOIN (SELECT cuenta_id, 
			                         String_agg(provincia.nombre, '<br/>')             AS 
			       provincias, 
			                         String_agg(Concat(direccion, ' - ', telefono, ' - ', 
			                                    email, 
			                                    ' - ', 
			                                    localidad.nombre, ' (', 
			                                               zona.nombre, ')'), '<br/>') AS 
			                         detalle 
			                  FROM   local 
			                         LEFT JOIN provincia 
			                                ON provincia.id = local.provincia_id 
			                         LEFT JOIN localidad 
			                                ON localidad.id = local.localidad_id 
			                         LEFT JOIN zona 
			                                ON zona.id = local.zona_id 
			                  WHERE  local.estado_id = 8 
			                  GROUP  BY cuenta_id) AS locals 
			              ON locals.cuenta_id = cuenta.id 
			       LEFT JOIN regimen_iibb 
			              ON regimen_iibb.id = cuenta.regimen_iibb_id 
			       LEFT JOIN actividad 
			              ON actividad.id = cuenta.actividad_id 
			WHERE  cuenta.estado_id = 8 
			       AND cuenta.tenant_id = 1""" + restriccionesAdicionales + ";"
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.selected = ''
			item.id = it[0]
			item.cuit = it[1]
			item.razonSocial = it[2]
			item.condicionIva = it[3]
			item.locales = it[4]?.replaceAll(/\(\)/, "(Sin Zona)") ?: ''
			item.provincias = it[5] ?: ''
			item.regimenIibb = it[6]
			item.actividad = it[7]
			return item
		}
	}

	def listCuentasMonoSimplificado(String filter) {
		def lista
		def estado = Estado.findByNombre('Activo')
		def regimen = RegimenIibb.findByNombre('Simplificado')

		if(filter){
			lista = Cuenta.createCriteria().list() {
				eq('estado', estado)
				and{
					or{
						ilike('cuit', '%' + filter + '%')
						ilike('razonSocial', '%' + filter + '%')
					}
				}
			}
		}else{
			lista = Cuenta.findAllByEstadoAndRegimenIibb(estado,regimen)
		}

		return lista
	}

	def listCuentasVentas(String filter){
		def lista
		if(filter){
			lista = Cuenta.createCriteria().list(){
				or{
					ilike('cuit','%'+filter+'%')
					ilike('razonSocial','%'+filter+'%')
					ilike('email','%'+filter+'%')
				}
			}
		}
		else{
			lista=Cuenta.getAll()
		}
	}

	def listCuentasBorradas() {
		def estado = Estado.findByNombre('Borrado')
		return Cuenta.findAllByEstado(estado)
	}

	def listCuentasSuspendidas() {
		def estado = Estado.findByNombre('Suspendido')
		return Cuenta.findAllByEstado(estado)
	}

	def listCuentasPendientes() {
		return Cuenta.findAllByEstado(Estado.findByNombre('Sin verificar'))
	}

	def listLocales(Long id){
		def cuenta = Cuenta.get(id)

		return cuenta.locales
	}

	def listAllLocales(){
		def estado = Estado.findByNombre('Activo')
		def cuentas = Cuenta.findAllByEstado(estado)
		
		def locales = []

		cuentas.each{
			it.locales.each{
				def local = it
				if(local.estado == estado)
					locales.add(local)
			}
		}
		return locales.sort{it.direccion.toLowerCase()}
	}

	def listApps(Long id){
		def cuenta = Cuenta.get(id)
		def items
		def apps = []

		items = ItemApp.createCriteria().list(){
			eq('cuenta',cuenta)
		}
		items.each{item -> apps.add(item.app)}
		return apps
	}

	def listAlicuotasIIBB(Long id){
		def cuenta = Cuenta.get(id)
		return cuenta.getAlicuotasIIBBActivas()
	}

	def listPorcentajesProvinciaIIBB(Long id){
		def cuenta = Cuenta.get(id)
		return cuenta.getPorcentajesProvinciaIIBBActivos()
	}

	def listPorcentajesActividadIIBB(Long id){
		def cuenta = Cuenta.get(id)
		return cuenta.getPorcentajesActividadIIBBActivos()
	}

	def listParientes(Long id){
		def cuenta = Cuenta.get(id)
		return cuenta.getParientesActivos()
	}

	def listMovimientos(Long id){
		def cuenta = Cuenta.get(id)
		return cuenta.getMovimientos()
	}

	def listFacturasCuenta(Long id){
		def cuenta = Cuenta.get(id)
		return cuenta.facturasCuenta
	}

	def getPrimeraCuentaId(){
		return Cuenta.first().id
	}

	def getPariente(Long id){
		def pariente = Pariente.get(id)
		return pariente
	}

	def getCuenta(Long id){
		def cuentaInstance = Cuenta.get(id)
	}

	def getCuentaPorLocal(Long id){
		def local = Local.get(id)
		return local.cuenta
	}

	def getCuentaByEmail(String email){
		def cuentaInstance = Cuenta.findByEmail(email)
	}

	def getCuentaByCuit(String cuit){
		def cuentaInstance = Cuenta.findByCuit(cuit)
	}

	def getCuentaByEmailOCuit(String email, String cuit){
		return getCuentaByEmail(email) ?: getCuentaByCuit(cuit)
	}

	def getCuentaCommand(Long id){ getCuentaCommand(Cuenta.get(id)) } 
	def getCuentaCommand(Cuenta cuentaInstance){
		if(cuentaInstance!=null){
			def command = new CuentaCommand()

			command.cuentaId = cuentaInstance.id
			command.version = cuentaInstance.version

			command.cuit = cuentaInstance.cuit
			command.razonSocial = cuentaInstance.razonSocial

			command.cbu = cuentaInstance.cbu
			command.fechaContratoSocial = cuentaInstance.fechaContratoSocial
			command.cuitAdministrador = cuentaInstance.cuitAdministrador
			command.cuitRepresentante = cuentaInstance.cuitRepresentante
			command.cuitGeneradorVep = cuentaInstance.cuitGeneradorVep
			command.nombreApellido = cuentaInstance.nombreApellido
			command.telefono = cuentaInstance.telefono
			command.email = cuentaInstance.email
			command.wechat = cuentaInstance.wechat
			command.whatsapp = cuentaInstance.whatsapp
			command.numeroSicol = cuentaInstance.numeroSicol
			command.detalle = cuentaInstance.detalle
			command.tenantId = cuentaInstance.tenantId
			command.medioPagoId = cuentaInstance.medioPago?.id
			command.medioPagoIvaId = cuentaInstance.medioPagoIva?.id
			command.medioPagoIibbId = cuentaInstance.medioPagoIibb?.id
			command.profesion = cuentaInstance.profesion
			if(command.profesion == "app"){
				command.apps = cuentaInstance.appsDondeTrabaja()
			}
			command.appCalimDescargada = cuentaInstance.appCalimDescargada() ? "Si" : "No"
			command.tipoDocumento = cuentaInstance.tipoDocumento
			command.documento = cuentaInstance.documento
			command.rangoFacturacion = cuentaInstance.rangoFacturacion
			command.inscriptoAfip = cuentaInstance.inscriptoAfip
			command.relacionDependencia = cuentaInstance.relacionDependencia
			command.claveFiscal = cuentaInstance.claveFiscal
			command.claveVeps = cuentaInstance.claveVeps
			command.claveArba = cuentaInstance.claveArba
			command.claveAgip = cuentaInstance.claveAgip

			if(cuentaInstance.actividad!=null){
				command.actividadId = cuentaInstance.actividad.id
			}

			if(cuentaInstance.condicionIva!=null){
				command.condicionIvaId = cuentaInstance.condicionIva.id
			}

			if(cuentaInstance.regimenIibb!=null){
				command.regimenIibbId = cuentaInstance.regimenIibb.id
			}

			def estadoActivo = Estado.findByNombre('Activo')
			def localidadCaba = Localidad.findByNombre('CABA')
			def provinciaCaba = Provincia.findByNombre('CABA')
			def actividadDefault = Actividad.findByNombre('MINIMERCADO')

			if(estadoActivo!=null)
				command.estadoActivoId = estadoActivo.id
			if(localidadCaba!=null)
				command.localidadCabaId = localidadCaba.id
			if(provinciaCaba!=null)
				command.provinciaCabaId = provinciaCaba.id
			if(actividadDefault!=null)
				command.actividadDefaultId = actividadDefault.id

		if (command.tenantId == 2){
			command.tipoClaveId = cuentaInstance.tipoClave?.id
			command.tipoPersonaId = cuentaInstance.tipoPersona?.id
			command.estadoClaveId = cuentaInstance.estadoClave?.id
			command.mesCierre = cuentaInstance.mesCierre
			command.impuestoMonotributoId = cuentaInstance.impuestoMonotributo?.id
			command.categoriaMonotributoId = cuentaInstance.categoriaMonotributo?.id
			if (cuentaInstance.periodoMonotributo)
				command.periodoMonotributo = cuentaInstance.periodoMonotributo.toString("MM/YYYY")
			command.impuestoAutonomoId = cuentaInstance.impuestoAutonomo?.id
			command.categoriaAutonomoId = cuentaInstance.categoriaAutonomo?.id
			if (cuentaInstance.periodoAutonomo)
				command.periodoAutonomo = cuentaInstance.periodoAutonomo.toString("MM/YYYY")
			command.domicilioFiscalCodigoPostal = cuentaInstance.domicilioFiscal?.codigoPostal
			command.domicilioFiscalDireccion = cuentaInstance.domicilioFiscal?.direccion
			command.domicilioFiscalLocalidad = cuentaInstance.domicilioFiscal?.localidad
			command.domicilioFiscalPisoDpto = cuentaInstance.domicilioFiscal?.pisoDpto
			command.domicilioFiscalProvinciaId = cuentaInstance.domicilioFiscal?.provincia?.id
			command.tarjetaDebitoAutomaticoId = cuentaInstance.tarjetaDebitoAutomatico?.id
			if(command.tarjetaDebitoAutomaticoId){
				command.numeroTarjeta = cuentaInstance.tarjetaDebitoAutomatico.numero
			}
		}

		command.impuestos = "[" + cuentaInstance.impuestos.collect{"{'impuestoNombre':'${it.impuesto.nombre}','impuestoId':'${it.impuesto.id}', 'periodoMesAno':'${it.periodo.toString('MM/YYYY')}','monotributo':'${it.monotributo}'}"}.join(",").replaceAll("'",'"') + "]"
		command.porcentajesActividadIIBB = "[" + cuentaInstance.porcentajesActividadIIBBActivos.collect{"{'porcentaje':'${it.porcentaje}', 'ultimaModificacion':'${it.ultimaModificacion?.toString('dd/MM/yyyy') ?: ''}', 'actividadId':'${it.actividad.id}', 'actividadNombre':'${it.actividad.nombre}','porcentajeActividadIIBBId':${it.id ?: 0}}"}.join(",").replaceAll("'",'"') + "]"

			return command
		} else {
			return null
		}
	}

	def getCuentaList(String razonSocial=null) {
		def lista;
		if(razonSocial){
			lista = Cuenta.createCriteria().list(sort: "razonSocial", order: "asc") {
				and{
					ilike('razonSocial', '%' + razonSocial + '%')
				}
			}
		}else{
			lista = Cuenta.list();
		}
	}

	def borrarCuenta(Long id){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def cuenta = Cuenta.get(id)
		cuenta.estado = estadoBorrado
		cuenta.save(flush:true, failOnError:true)

		return cuenta
	}

	def recuperarCuenta(Long id){
		def estadoActivo = Estado.findByNombre('Activo')
		def cuenta = Cuenta.get(id)
		User.findByCuenta(cuenta)?.with{
			enabled = true
			save(flush:false)
		}
		cuenta.estado = estadoActivo
		cuenta.save(flush:true, failOnError:true)

		return cuenta
	}

	def deleteCuenta(Long id){
		def cuentaInstance = Cuenta.get(id)
		com.zifras.ticket.Mensaje.findAllByRemitente(cuentaInstance)*.delete(flush:true, failOnError:true)
		UserTrack.findAllByCuenta(cuentaInstance)*.delete(flush:true, failOnError:true)
		User.findAllByCuenta(cuentaInstance).each{
			usuarioService.deleteUsuario(it.id)
		}
		FacturaVenta.findAllByCuenta(cuentaInstance)*.delete(flush:true, failOnError:true)
		Email.findAllByCuenta(cuentaInstance)*.delete(flush:true, failOnError:true)
		cuentaInstance.delete(flush:true, failOnError:true)
	}

	def saveCuenta(CuentaCommand command){
		def cuentaInstance = new Cuenta()

		def currentUser = accessRulesService.getCurrentUser()
		cuentaInstance.ultimaModificacion = new LocalDateTime()
		cuentaInstance.ultimoModificador = currentUser.username

		cuentaInstance.cuit = command.cuit
		cuentaInstance.razonSocial = command.razonSocial

		cuentaInstance.fechaContratoSocial = command.fechaContratoSocial
		cuentaInstance.cuitAdministrador = command.cuitAdministrador
		cuentaInstance.cuitRepresentante = command.cuitRepresentante
		cuentaInstance.cuitGeneradorVep = command.cuitGeneradorVep
		cuentaInstance.nombreApellido = command.nombreApellido
		cuentaInstance.telefono = command.telefono
		cuentaInstance.email = command.email
		cuentaInstance.wechat = command.wechat
		cuentaInstance.whatsapp = command.whatsapp
		cuentaInstance.numeroSicol = command.numeroSicol
		cuentaInstance.detalle = command.detalle

		if(command.actividadId!=null){
			def actividad = Actividad.get(command.actividadId)
			cuentaInstance.actividad = actividad
		}

		if(command.condicionIvaId!=null){
			def condicionIva = CondicionIva.get(command.condicionIvaId)
			cuentaInstance.condicionIva = condicionIva
		}

		if(command.regimenIibbId!=null){
			def regimenIibb = RegimenIibb.get(command.regimenIibbId)
			cuentaInstance.regimenIibb = regimenIibb
		}

		if((command.alicuotasIIBB!="")&&(command.alicuotasIIBB!=null)){
			def alicuotasIIBB = new JsonSlurper().parseText(command.alicuotasIIBB)

			alicuotasIIBB.each{
				def alicuota = new AlicuotaIIBB()
				alicuota.provincia = Provincia.get(it.provinciaId)
				alicuota.valor = new Double(it.valor)
				alicuota.porcentaje = new Double(it.porcentaje)
				alicuota.ultimoModificador = currentUser.username
				alicuota.ultimaModificacion = new LocalDateTime()
				alicuota.estado = Estado.findByNombre('Activo')
				cuentaInstance.addToAlicuotasIIBB(alicuota)
			}
		}

		if((command.parientes!="")&&(command.parientes!=null)){
			def parientes = new JsonSlurper().parseText(command.parientes)

			parientes.each{
				def pariente = new Pariente()
				pariente.tipoId = new Long(it.tipoId)
				pariente.nombre = it.nombre
				pariente.apellido = it.apellido
				pariente.cuil = it.cuil
				if(pariente.tipoId==0)
					pariente.fechaCasamiento = it.fecha
				else
					pariente.fechaNacimiento = it.fecha

				pariente.ultimoModificador = currentUser.username
				pariente.ultimaModificacion = new LocalDateTime()
				pariente.estado = Estado.findByNombre('Activo')
				cuentaInstance.addToParientes(pariente)
			}
		}

		if(command.porcentajesActividadIIBB){
			new JsonSlurper().parseText(command.porcentajesActividadIIBB).each{
				def porcentajeActividad
				def porcentaje = new Double((it.porcentaje).toString().replace(',', '.'))
				def salvar = false

				if(it.porcentajeActividadIIBBId!=0){
					porcentajeActividad = PorcentajeActividadIIBB.get(it.porcentajeActividadIIBBId)

					if(porcentajeActividad.porcentaje!=porcentaje){
						porcentajeActividad.estado = Estado.findByNombre('Borrado')
						porcentajeActividad.save(flush:true, failOnError:true)
						salvar = true
					}
				}else{
					salvar = true
				}

				if(salvar){
					porcentajeActividad = new PorcentajeActividadIIBB()

					porcentajeActividad.actividad = Actividad.get(it.actividadId)
					porcentajeActividad.porcentaje = porcentaje
					porcentajeActividad.ultimoModificador = currentUser.username
					porcentajeActividad.ultimaModificacion = new LocalDateTime()
					porcentajeActividad.estado = Estado.findByNombre('Activo')

					cuentaInstance.addToPorcentajesActividadIIBB(porcentajeActividad)
				}
			}
		}

		if(command.porcentajesProvinciaIIBB){
			new JsonSlurper().parseText(command.porcentajesProvinciaIIBB).each{
				def porcentajeProvincia
				def porcentaje = new Double((it.porcentaje).toString().replace(',', '.'))
				def salvar = false

				if(it.porcentajeProvinciaIIBBId!=0){
					porcentajeProvincia = PorcentajeProvinciaIIBB.get(it.porcentajeProvinciaIIBBId)

					if(porcentajeProvincia.porcentaje!=porcentaje){
						porcentajeProvincia.estado = Estado.findByNombre('Borrado')
						porcentajeProvincia.save(flush:false)
						salvar = true
					}
				}else{
					salvar = true
				}

				if(salvar){
					porcentajeProvincia = new PorcentajeProvinciaIIBB()

					porcentajeProvincia.provincia = Provincia.get(it.provinciaId)
					porcentajeProvincia.porcentaje = porcentaje
					porcentajeProvincia.ultimoModificador = currentUser.username
					porcentajeProvincia.ultimaModificacion = new LocalDateTime()
					porcentajeProvincia.estado = Estado.findByNombre('Activo')

					cuentaInstance.addToPorcentajesProvinciaIIBB(porcentajeProvincia)
				}
			}
		}

		cuentaInstance.estado = Estado.findByNombre('Activo')

		if((command.locales!="")&&(command.locales!=null)){
			def locales = new JsonSlurper().parseText(command.locales)

			locales.each{
				def local = new Local()
				local.numeroLocal = new Integer(it.numeroLocal)
				local.direccion = it.direccion
				local.email = it.email
				local.telefono = it.telefono
				local.porcentaje = new Double(it.porcentaje)
				local.porcentajeIIBB = new Double(it.porcentajeIIBB)
				local.localidad = Localidad.get(it.localidadId)
				local.zona = Zona.get(it.zonaId)
				if(it.cantidadEmpleados!="")
					local.cantidadEmpleados = new Integer(it.cantidadEmpleados)
				else
					local.cantidadEmpleados = 0
				local.provincia = local.localidad.provincia
				local.estado = Estado.findByNombre('Activo')

				cuentaInstance.addToLocales(local)
			}
		}

		cuentaInstance.claveFiscal = command.claveFiscal
		cuentaInstance.claveVeps = command.claveVeps
		cuentaInstance.claveArba = command.claveArba
		cuentaInstance.claveAgip = command.claveAgip
		if(currentUser?.esCalim){
			cuentaInstance.tipoClave = TipoClave.get(command.tipoClaveId)
			cuentaInstance.estadoClave = Estado.get(command.estadoClaveId)
			cuentaInstance.tipoPersona = TipoPersona.get(command.tipoPersonaId)
			cuentaInstance.mesCierre = command.mesCierre
			cuentaInstance.medioPago = MedioPago.get(command.medioPagoId)
			
			if(command.numeroTarjeta != null){
				def tarjeta = new Tarjeta()
				tarjeta.numero = command.numeroTarjeta
				tarjeta.visa = (command.numeroTarjeta[0] == "4")
				tarjeta.save(flush:true, failOnError:true)

				def tarjetaAntigua = cuentaInstance.tarjetaDebitoAutomatico
				cuentaInstance.tarjetaDebitoAutomatico = tarjeta
				if(tarjetaAntigua)
					tarjetaAntigua.delete(flush:true)

				cuentaInstance.save(flush:true, failOnError:true)
			}
			else{
				if(cuentaInstance.tarjetaDebitoAutomatico)
					cuentaInstance.tarjetaDebitoAutomatico.delete(flush:true)
			}

			if (cuentaInstance.condicionIva.nombre == "Monotributista"){
				cuentaInstance.impuestoMonotributo = Impuesto.get(command.impuestoMonotributoId)
				cuentaInstance.categoriaMonotributo = Categoria.get(command.categoriaMonotributoId)
				cuentaInstance.periodoMonotributo = LocalDate.parse(command.periodoMonotributo, DateTimeFormat.forPattern("MM/YYYY"))
			}else if (cuentaInstance.condicionIva.nombre == "Responsable inscripto"){
				cuentaInstance.impuestoAutonomo = Impuesto.get(command.impuestoAutonomoId)
				cuentaInstance.categoriaAutonomo = Categoria.get(command.categoriaAutonomoId)
				cuentaInstance.periodoAutonomo = LocalDate.parse(command.periodoAutonomo, DateTimeFormat.forPattern("MM/YYYY"))
			}

			if (!cuentaInstance.domicilioFiscal)
				cuentaInstance.domicilioFiscal = new Domicilio()
			cuentaInstance.domicilioFiscal.codigoPostal = command.domicilioFiscalCodigoPostal
			cuentaInstance.domicilioFiscal.direccion = command.domicilioFiscalDireccion
			cuentaInstance.domicilioFiscal.pisoDpto = command.domicilioFiscalPisoDpto
			cuentaInstance.domicilioFiscal.localidad = command.domicilioFiscalLocalidad
			cuentaInstance.domicilioFiscal.provincia = Provincia.get(command.domicilioFiscalProvinciaId)
			cuentaInstance.domicilioFiscal.save(flush:false)

			if(command.impuestos){
				new JsonSlurper().parseText(command.impuestos).each{
					CantidadImpuesto cantidad = new CantidadImpuesto()
					cantidad.impuesto = Impuesto.get(it.impuestoId)
					cantidad.monotributo = it.monotributo
					cantidad.periodo = LocalDate.parse(it.periodoMesAno, DateTimeFormat.forPattern("MM/YYYY"))
					cuentaInstance.addToImpuestos(cantidad)
				}
			}
			cuentaInstance.contador = null
		}

		cuentaInstance.save(flush:true, failOnError:true)
		if (currentUser?.esCalim)
			usuarioService.crearUsuarioParaCuenta(cuentaInstance)

		return cuentaInstance
	}

	def saveCuentaCalim(CuentaCalimCommand command, servicios){
		LocalDate hoy = new LocalDate()
		def respuestaDeal
		if (command.bitrixId){
			try {
				// Hago el get para asegurarme de que exista, por las dudas.
					respuestaDeal = bitrixService.getNegociacion(command.bitrixId.toString())
			}
			catch(Exception e) {
				println e.message
				log.error("El ID bitrix ingresado no se encontró.")
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
				assert false : "El ID de Deal Bitrix ingresado no existe, por favor revisá que sea el del Deal existente y no el de Contacto"
			}
		}
		// Protección anti nulls:
			command.cuotas = command.cuotas ?: 1
			command.primerPago = command.primerPago ?: hoy
		assert command.cuotas < 7 : "El máximo de cuotas aceptadas es 6finerror"
		Cuenta cuentaInstance = new Cuenta().with{
			fechaAlta = new LocalDateTime()
			email = command.email
			cuit = command.email
			telefono = command.telefono
			regimenIibb = RegimenIibb.get(15)
			condicionIva = CondicionIva.findByNombre("Sin inscribir")
			razonSocial = command.nombre
			nombreApellido = command.nombre
			responsable = Vendedor.findByEmail(accessRulesService.currentUser?.username) ?: null
			contador = null
			estado = Estado.findByNombre('Sin verificar')
			if(command.mercadoLibre)
				profesion = "mercadolibre"
			return it
		}
			
		cuentaInstance.save(flush:true, failOnError:true)
		usuarioService.crearUsuarioParaCuenta(cuentaInstance)
		/*---Bitrix---*/
		RegisterCommand commandPasar
		if (respuestaDeal != null)
			try {
					cuentaInstance.bitrixDealId = new Long(respuestaDeal.dealId)
					cuentaInstance.bitrixId = new Long(respuestaDeal.contactId)
					try{
						String tag = respuestaDeal.dealTitle.split("Web")[1].replace(" ","")
						cuentaInstance.tagFormularioOrigen = tag
					}
					catch(ex){}
					cuentaInstance.save(flush:true)
					bitrixService.editarContacto(cuentaInstance.bitrixId.toString(),["fields":["UF_CRM_1600954073": cuentaInstance.id.toString(), "UF_CRM_1607718625" : "https://app.calim.com.ar/cuenta/show/"+cuentaInstance.id.toString()]])	
						
			}
			catch(Exception e) {
				log.error("Ocurrio un error guardando los ID Bitrix en la cuenta " + cuentaInstance.id)
				println e.message
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
		else{
			try {
				commandPasar = new RegisterCommand().with{
					def nombreCompleto = cuentaInstance.nombreApellido.split()
					nombre = nombreCompleto[0]
					nombreCompleto = nombreCompleto - nombreCompleto[0]
					apellido = nombreCompleto.join(" ")
					username = cuentaInstance.email
					celular = cuentaInstance.telefono
					return it
				}
				def respuesta = bitrixService.guardarEnBitrix(commandPasar, cuentaInstance, "Registro Manual", accessRulesService.currentUser?.username)
			}
			catch(Exception e) {
				log.error("No pudo generarse ID bitrix.")
				println e.message
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
			/*---Fin Bitrix---*/
			try{
				googleAPIService.crearContacto(TokenGoogle.findByUsuario("Cuenta Contactos 1").refreshToken, commandPasar.nombre, commandPasar.apellido, commandPasar.celular, commandPasar.username)
			}
			catch(Exception e) {
				println "\nError guardando contacto de Google"
				log.error(e.message)
				println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			}
		}
		if (servicios){
			def listaServicios = ([Collection, Object[]].any { it.isAssignableFrom(servicios.getClass()) } ? servicios : [servicios]).collect{Servicio.get(it)}
			Double totalLista = listaServicios.sum{it.precio}
			Double descuentoMultiplicador = 1 - (command.total - totalLista) * (-1) / totalLista
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
				for (i in 	0..<command.cuotas){
					listaItems << new ItemServicioEspecial().with{
						vendedor = accessRulesService.currentUser?.vendedor
						if (! vendedor)
							responsable = accessRulesService.currentUser?.username
						servicio = servicioInstance
						cuota = i + 1
						totalCuotas = command.cuotas
						cuenta = cuentaInstance
						precio = (servicioInstance.precio * descuentoProfesion * descuentoMultiplicador / command.cuotas).round(2)
						fechaAlta = command.primerPago.plusMonths(i)
						comentario = command.comentarioServicio
						save(flush:true, failOnError:true)
					}
				}
			}
			if(cuentaInstance.bitrixDealId){
				try{
					Thread.start{
						Servicio.withNewSession{session ->
							bitrixService.agregarProductosDeal(cuentaInstance.bitrixDealId,cuentaInstance.bitrixId,serviciosBitrix,null)
						}
					}
				}
				catch(e){
					log.error("No se pudo agregar el/los productos" + serviciosBitrix + "al deal")
					log.error(e.message)
				}
			}
			def pagarHoy = listaItems.findAll{it.fechaAlta == hoy}
			if (pagarHoy)
				return facturaCuentaService.generarPorItemsServicio(pagarHoy)?.id
			else
				return null
		}
	}

	def updateCuenta(CuentaCommand command){
		def cuentaInstance = Cuenta.get(command.cuentaId)
		def estadoBorrado = Estado.findByNombre('Borrado')
		if (command.version != null)
			if (cuentaInstance.version > command.version)
				throw new Exception("Mientras usted editaba, otro usuario ha actualizado la Cuenta")

		def currentUser = accessRulesService.getCurrentUser()
		cuentaInstance.ultimaModificacion = new LocalDateTime()
		cuentaInstance.ultimoModificador = currentUser.username

		cuentaInstance.cuit = command.cuit
		cuentaInstance.razonSocial = command.razonSocial

		cuentaInstance.cuitAdministrador = command.cuitAdministrador
		cuentaInstance.cuitRepresentante = command.cuitRepresentante
		cuentaInstance.cuitGeneradorVep = command.cuitGeneradorVep
		cuentaInstance.fechaContratoSocial = command.fechaContratoSocial
		cuentaInstance.nombreApellido = command.nombreApellido
		cuentaInstance.telefono = command.telefono
		if(cuentaInstance.profesion == "app" && command.profesion != "app")
			borrarApps(cuentaInstance)
		cuentaInstance.profesion = command.profesion
		if(cuentaInstance.profesion == "app"){
			actualizarApps(cuentaInstance.id,parsearAppsToIds(command.apps))
		}
		cuentaInstance.tipoDocumento = command.tipoDocumento
		cuentaInstance.documento = command.documento
		cuentaInstance.rangoFacturacion = command.rangoFacturacion
		cuentaInstance.inscriptoAfip = new Boolean(command.inscriptoAfip)
		cuentaInstance.relacionDependencia = new Boolean(command.relacionDependencia)

		if (cuentaInstance.email != command.email && currentUser?.esCalim)
			User.findByUsername(cuentaInstance.email)?.with{
				username = command.email
				save(flush:true, failOnError:true)
			}
		cuentaInstance.email = command.email
		cuentaInstance.wechat = command.wechat
		cuentaInstance.whatsapp = command.whatsapp
		cuentaInstance.numeroSicol = command.numeroSicol
		cuentaInstance.detalle = command.detalle

		def actividad = Actividad.get(command.actividadId)
		cuentaInstance.actividad = actividad

		if(command.condicionIvaId!=null){
			def condicionIva = CondicionIva.get(command.condicionIvaId)
			cuentaInstance.condicionIva = condicionIva
			if (condicionIva.nombre != "Sin inscribir")
				cuentaInstance.inscriptoAfip = true;
		}

		if(command.regimenIibbId!=null){
			def regimenIibb = RegimenIibb.get(command.regimenIibbId)
			cuentaInstance.regimenIibb = regimenIibb
		}

		if((command.parientesBorrados!="")&&(command.parientesBorrados!=null)){
			def parientesBorrados = new JsonSlurper().parseText( command.parientesBorrados )
			parientesBorrados.each {
				def pariente = Pariente.get(it.parienteId)
				pariente.estado = Estado.findByNombre('Borrado')
				pariente.save(flush:true, failOnError:true)
			}
		}

		if((command.parientes!="")&&(command.parientes!=null)){
			def parientes = new JsonSlurper().parseText(command.parientes)

			parientes.each{
				def pariente
				if(it.parienteId==0){
					pariente = new Pariente()
					pariente.tipoId = new Long(it.tipoId)
					pariente.nombre = it.nombre
					pariente.apellido = it.apellido
					pariente.cuil = it.cuil

					DateTimeFormatter dtf = DateTimeFormat.forPattern("dd/MM/yyyy")
					if(pariente.tipoId==0)
						pariente.fechaCasamiento = dtf.parseLocalDate(it.fecha)
					else
						pariente.fechaNacimiento = dtf.parseLocalDate(it.fecha)

					pariente.ultimoModificador = currentUser.username
					pariente.ultimaModificacion = new LocalDateTime()
					pariente.estado = Estado.findByNombre('Activo')
					cuentaInstance.addToParientes(pariente)
				}else{
					pariente = Pariente.get(it.parienteId)
					pariente.tipoId = new Long(it.tipoId)
					pariente.nombre = it.nombre
					pariente.apellido = it.apellido
					pariente.cuil = it.cuil
					DateTimeFormatter dtf = DateTimeFormat.forPattern("dd/MM/yyyy")
					if(pariente.tipoId==0){
						pariente.fechaCasamiento = dtf.parseLocalDate(it.fecha)
						pariente.fechaNacimiento = null
					}else{
						pariente.fechaCasamiento = null
						pariente.fechaNacimiento = dtf.parseLocalDate(it.fecha)
					}

					pariente.ultimoModificador = currentUser.username
					pariente.ultimaModificacion = new LocalDateTime()
					pariente.estado = Estado.findByNombre('Activo')
					cuentaInstance.addToParientes(pariente)
				}
			}
		}

		if((command.alicuotasIIBBBorradas!="")&&(command.alicuotasIIBBBorradas!=null)){
			def alicuotasIIBBBorradas = new JsonSlurper().parseText( command.alicuotasIIBBBorradas )
			alicuotasIIBBBorradas.each {
				def alicuotaIIBB = AlicuotaIIBB.get(it.alicuotaIIBBId)
				alicuotaIIBB.estado = Estado.findByNombre('Borrado')
				alicuotaIIBB.save(flush:true, failOnError:true)
			}
		}

		if((command.alicuotasIIBB!="")&&(command.alicuotasIIBB!=null)){
			def alicuotasIIBB = new JsonSlurper().parseText(command.alicuotasIIBB)

			alicuotasIIBB.each{
				def alicuota
				if(it.alicuotaIIBBId==0){
					alicuota = new AlicuotaIIBB()

					alicuota.provincia = Provincia.get(it.provinciaId)
					alicuota.valor = new Double((it.valor).toString().replace(',', '.'))
					alicuota.porcentaje = new Double((it.porcentaje).toString().replace(',', '.'))
					alicuota.ultimoModificador = currentUser.username
					alicuota.ultimaModificacion = new LocalDateTime()
					alicuota.estado = Estado.get(it.estadoId)

					cuentaInstance.addToAlicuotasIIBB(alicuota)
				}else{
					alicuota = AlicuotaIIBB.get(it.alicuotaIIBBId)

					def valor = new Double((it.valor).toString().replace(',', '.'))
					def porcentaje = new Double((it.porcentaje).toString().replace(',', '.'))

					if((valor!=alicuota.valor)||(porcentaje!=alicuota.porcentaje)){
						//Se debe cambiar el estado de la alícuota a Borrado para que quede históricamente
						//y se debe crear una alícuota nueva
						alicuota.estado = Estado.findByNombre('Borrado')
						alicuota.save(flush:true, failOnError:true)

						def nuevaAlicuota = new AlicuotaIIBB()

						nuevaAlicuota.provincia = Provincia.get(it.provinciaId)
						nuevaAlicuota.valor = valor
						nuevaAlicuota.porcentaje = porcentaje
						nuevaAlicuota.ultimoModificador = currentUser.username
						nuevaAlicuota.ultimaModificacion = new LocalDateTime()
						nuevaAlicuota.estado = Estado.findByNombre('Activo')

						cuentaInstance.addToAlicuotasIIBB(nuevaAlicuota)
					}
				}
			}
		}

		if(command.porcentajesProvinciaIIBBBorradas){
			new JsonSlurper().parseText( command.porcentajesProvinciaIIBBBorradas ).each {
				def porcentajeABorrar = PorcentajeProvinciaIIBB.get(it.porcentajeProvinciaIIBBId)
				porcentajeABorrar.estado = estadoBorrado
				porcentajeABorrar.save(flush:false)
			}
		}

		if(command.porcentajesProvinciaIIBB){
			new JsonSlurper().parseText(command.porcentajesProvinciaIIBB).each{
				def porcentajeProvincia
				def porcentaje = new Double((it.porcentaje).toString().replace(',', '.'))
				def salvar = false

				if(it.porcentajeProvinciaIIBBId!=0){
					porcentajeProvincia = PorcentajeProvinciaIIBB.get(it.porcentajeProvinciaIIBBId)

					if(porcentajeProvincia.porcentaje!=porcentaje){
						porcentajeProvincia.estado = Estado.findByNombre('Borrado')
						porcentajeProvincia.save(flush:false)
						salvar = true
					}
				}else{
					salvar = true
				}

				if(salvar){
					porcentajeProvincia = new PorcentajeProvinciaIIBB()

					porcentajeProvincia.provincia = Provincia.get(it.provinciaId)
					porcentajeProvincia.porcentaje = porcentaje
					porcentajeProvincia.ultimoModificador = currentUser.username
					porcentajeProvincia.ultimaModificacion = new LocalDateTime()
					porcentajeProvincia.estado = Estado.findByNombre('Activo')

					cuentaInstance.addToPorcentajesProvinciaIIBB(porcentajeProvincia)
				}
			}
		}

		if(command.porcentajesActividadIIBBBorradas){
			new JsonSlurper().parseText( command.porcentajesActividadIIBBBorradas ).each {
				def porcentajeABorrar = PorcentajeActividadIIBB.get(it.porcentajeActividadIIBBId)
				porcentajeABorrar.estado = estadoBorrado
				porcentajeABorrar.save(flush:false)
			}
		}

		//Actualizamos o creamos los nuevos:
		if(command.porcentajesActividadIIBB){
			new JsonSlurper().parseText(command.porcentajesActividadIIBB).each{
				def porcentajeActividad
				def porcentaje = new Double((it.porcentaje).toString().replace(',', '.'))
				def salvar = false

				if(it.porcentajeActividadIIBBId!=0){
					porcentajeActividad = PorcentajeActividadIIBB.get(it.porcentajeActividadIIBBId)

					if(porcentajeActividad.porcentaje!=porcentaje){
						porcentajeActividad.estado = Estado.findByNombre('Borrado')
						porcentajeActividad.save(flush:true, failOnError:true)
						salvar = true
					}
				}else{
					salvar = true
				}

				if(salvar){
					porcentajeActividad = new PorcentajeActividadIIBB()

					porcentajeActividad.actividad = Actividad.get(it.actividadId)
					porcentajeActividad.porcentaje = porcentaje
					porcentajeActividad.ultimoModificador = currentUser.username
					porcentajeActividad.ultimaModificacion = new LocalDateTime()
					porcentajeActividad.estado = Estado.findByNombre('Activo')

					cuentaInstance.addToPorcentajesActividadIIBB(porcentajeActividad)
				}
			}
		}

		if((command.locales!="")&&(command.locales!=null)){
			def locales = new JsonSlurper().parseText(command.locales)

			locales.each{
				def local
				def esteItem = it
				if(it.localId==0){
					local = new Local()
					local.numeroLocal = new Integer(it.numeroLocal)
					local.direccion = it.direccion
					local.email = it.email
					local.telefono = it.telefono
					local.porcentaje = new Double((it.porcentaje).toString().replace(',', '.'))
					if(it.porcentajeIIBB!=null)
						local.porcentajeIIBB = new Double((it.porcentajeIIBB).toString().replace(',', '.'))
					else
						local.porcentajeIIBB = null
					local.localidad = Localidad.get(it.localidadId)
					local.zona = Zona.get(it.zonaId)
					if(it.cantidadEmpleados!="")
					local.cantidadEmpleados = new Integer(it.cantidadEmpleados)
					else
					local.cantidadEmpleados = 0
					local.provincia = local.localidad.provincia
					local.estado = Estado.get(it.estadoId)

					cuentaInstance.addToLocales(local)
				}else{
					local = Local.get(it.localId)
					local.numeroLocal = new Integer(it.numeroLocal)
					local.direccion = it.direccion
					local.email = it.email
					local.telefono = it.telefono
					local.porcentaje = new Double((it.porcentaje).toString().replace(',', '.'))
					if(it.porcentajeIIBB!=null)
						local.porcentajeIIBB = new Double((it.porcentajeIIBB).toString().replace(',', '.'))
					else
						local.porcentajeIIBB = null

					local.localidad = Localidad.get(it.localidadId)
					local.zona = Zona.get(it.zonaId)
					if(it.cantidadEmpleados!="")
					local.cantidadEmpleados = new Integer(it.cantidadEmpleados)
					else
					local.cantidadEmpleados = 0
					local.provincia = local.localidad.provincia
					local.estado = Estado.get(it.estadoId)

					local.save(flush:true, failOnError:true)
				}
			}
		}

		cuentaInstance.medioPago = MedioPago.get(command.medioPagoId)
		cuentaInstance.medioPagoIva = MedioPago.get(command.medioPagoIvaId)
		cuentaInstance.medioPagoIibb = MedioPago.get(command.medioPagoIibbId)
		if(currentUser?.esCalim){
			cuentaInstance.tipoClave = TipoClave.get(command.tipoClaveId)
			cuentaInstance.estadoClave = Estado.get(command.estadoClaveId)
			cuentaInstance.tipoPersona = TipoPersona.get(command.tipoPersonaId)
			cuentaInstance.mesCierre = command.mesCierre
			cuentaInstance.cbu = command.cbu

			def tarjetaExistente = cuentaInstance.tarjetaDebitoAutomatico
			if(command.numeroTarjeta != null){
				if(tarjetaExistente){
					tarjetaExistente.numero = command.numeroTarjeta
					tarjetaExistente.visa = (command.numeroTarjeta[0] == "4")
					tarjetaExistente.credito = true
					tarjetaExistente.save(flush:true, failOnError:true)
				}
				else{
					def tarjeta = new Tarjeta()
					tarjeta.numero = command.numeroTarjeta
					tarjeta.visa = (command.numeroTarjeta[0] == "4")
					tarjeta.save(flush:true, failOnError:true)
					cuentaInstance.tarjetaDebitoAutomatico = tarjeta
				}
			}
			else{
				if(tarjetaExistente){
					cuentaInstance.tarjetaDebitoAutomatico = null
					tarjetaExistente.delete(flush:true)
				}
			}

			if (cuentaInstance.condicionIva?.nombre == "Monotributista"){
				cuentaInstance.impuestoMonotributo = Impuesto.get(command.impuestoMonotributoId)
				cuentaInstance.categoriaMonotributo = Categoria.get(command.categoriaMonotributoId)
				cuentaInstance.periodoMonotributo = LocalDate.parse(command.periodoMonotributo, DateTimeFormat.forPattern("MM/YYYY"))
				cuentaInstance.impuestoAutonomo = null
				cuentaInstance.categoriaAutonomo = null
				cuentaInstance.periodoAutonomo = null
			}else if (cuentaInstance.condicionIva?.nombre == "Responsable inscripto"){
				cuentaInstance.impuestoAutonomo = Impuesto.get(command.impuestoAutonomoId)
				cuentaInstance.categoriaAutonomo = Categoria.get(command.categoriaAutonomoId)
				cuentaInstance.periodoAutonomo = LocalDate.parse(command.periodoAutonomo, DateTimeFormat.forPattern("MM/YYYY"))
				cuentaInstance.impuestoMonotributo = null
				cuentaInstance.categoriaMonotributo = null
				cuentaInstance.periodoMonotributo = null
			}

			Provincia provinciaFiscal = Provincia.get(command.domicilioFiscalProvinciaId)
			if(command.domicilioFiscalDireccion && provinciaFiscal){
				if (!cuentaInstance.domicilioFiscal)
					cuentaInstance.domicilioFiscal = new Domicilio()
				cuentaInstance.domicilioFiscal.codigoPostal = command.domicilioFiscalCodigoPostal
				cuentaInstance.domicilioFiscal.pisoDpto = command.domicilioFiscalPisoDpto
				cuentaInstance.domicilioFiscal.direccion = command.domicilioFiscalDireccion
				cuentaInstance.domicilioFiscal.localidad = command.domicilioFiscalLocalidad
				cuentaInstance.domicilioFiscal.provincia = provinciaFiscal
				cuentaInstance.domicilioFiscal.save(flush:false)
			}

			cuentaInstance.impuestos.clear()
			if(command.impuestos){
				new JsonSlurper().parseText(command.impuestos).each{
					CantidadImpuesto cantidad = new CantidadImpuesto()
					cantidad.impuesto = Impuesto.get(it.impuestoId)
					cantidad.monotributo = it.monotributo
					cantidad.periodo = LocalDate.parse(it.periodoMesAno, DateTimeFormat.forPattern("MM/YYYY"))
					cuentaInstance.addToImpuestos(cantidad)
				}
			}
		}
		cuentaInstance.claveFiscal = command.claveFiscal
		cuentaInstance.claveVeps = command.claveVeps
		cuentaInstance.claveArba = command.claveArba
		cuentaInstance.claveAgip = command.claveAgip
		cuentaInstance.save(flush:true, failOnError:true)

		return cuentaInstance
	}

	def updateTarjetaDebitoAutomatico(Long cuentaId, String numeroTarjeta, Boolean tarjetaCredito){
		def cuentaInstance = Cuenta.get(cuentaId)

		def tarjetaExistente = cuentaInstance.tarjetaDebitoAutomatico
		if(numeroTarjeta != null){
			if(tarjetaExistente){
				tarjetaExistente.numero = numeroTarjeta
				tarjetaExistente.visa = (numeroTarjeta[0] == "4")
				tarjetaExistente.credito = true
				tarjetaExistente.save(flush:true, failOnError:true)
			}
			else{
				def tarjeta = new Tarjeta()
				tarjeta.numero = numeroTarjeta
				tarjeta.visa = (numeroTarjeta[0] == "4")
				tarjeta.save(flush:true, failOnError:true)
				cuentaInstance.tarjetaDebitoAutomatico = tarjeta
			}
		}
		else{
			if(tarjetaExistente){
				cuentaInstance.tarjetaDebitoAutomatico = null
				tarjetaExistente.delete(flush:true)
			}
		}

		if(cuentaInstance.servicioActivo && !cuentaInstance.servicioActivo?.debitoAutomatico)
			generarSMDebitoAutomatico(cuentaInstance.id)

	}

	def updateCuentaPendiente(String nombre, Long cuentaId, String detalleInput, String telefonoInput){
		return Cuenta.get(cuentaId)?.with{
			detalle = detalleInput
			telefono = telefonoInput
			nombreApellido = razonSocial = nombre
			save(flush:true, failOnError:true)
		}
	}

	def getCantidadCuentasTotales(){
		return Cuenta.count()
	}

	def updateConfiguracionCuenta(ConfiguracionCommand command){
		return Cuenta.get(command.cuentaId).with{
			recibirNotificaciones = command.recibirNotificaciones
			recibirNotificacionVep = command.recibirNotificacionVep
			recibirNotificacionDeclaracionJurada = command.recibirNotificacionDeclaracionJurada
			recibirNotificacionFacturaCuenta = command.recibirNotificacionFacturaCuenta
			medioPago = MedioPago.get(command.medioPagoId)
			cbu = command.cbu
			maximoAutorizarIva = command.maximoAutorizarIva
			maximoAutorizarIIBB = command.maximoAutorizarIIBB

			save(flush:true, failOnError:true)
		}
	}

	def existeCuenta(RegisterCommand command){
		def estudioCalim = Estudio.findByNombre('Calim')
		def cuentaInstance

		withId(new Integer(estudioCalim.id.toString())) {
			cuentaInstance = Cuenta.findByEmail(command.username)
		}
		if(cuentaInstance!=null)
			return true

		return false
	}

	def registrarCuenta(RegisterCommand command){
		def cuentaInstance = new Cuenta()

		cuentaInstance.fechaAlta = new LocalDateTime()
		cuentaInstance.email = command.username
		//El cuit como no puede ser null uso el email como cuit para luego sustituirlo
		cuentaInstance.cuit = command.username
		cuentaInstance.razonSocial = command.username
		cuentaInstance.nombreApellido = command.nombre + " " + command.apellido

		def estudioCalim = Estudio.findByNombre('Calim')

		withId(new Integer(estudioCalim.id.toString())) {
			cuentaInstance.contador = null
			//DATOS HARDCODEADOS:
			cuentaInstance.regimenIibb = RegimenIibb.get(15)

			cuentaInstance.condicionIva = CondicionIva.findByNombre("Sin inscribir")

			cuentaInstance.estado = Estado.findByNombre('Sin verificar')
			cuentaInstance.actionRegistro = ""

			cuentaInstance.save(flush:true, failOnError:true)

			usuarioService.crearUsuarioParaCuenta(cuentaInstance,command.password)
		}
		return cuentaInstance
	}

	def suspenderCuenta(Long cuentaId){
		def cuentaInstance = Cuenta.get(cuentaId)
		def suspendido = Estado.findByNombre("Suspendido")
		def user = User.findByCuenta(cuentaInstance)
		user.enabled = false
		user.save(flush:true,failOnError:true)
		cuentaInstance.estado = suspendido
		cuentaInstance.save(flush:true, failOnError:true)
		LocalDate hoy = new LocalDate()
		cuentaInstance.serviciosMensuales?.findAll{! it.fechaBaja || it.fechaBaja > hoy}?.each{
			it.fechaBaja = hoy
			it.save(flush:true, failOnError:true)
		}
	}

	def getStepRegistro(Long cuentaId){
		def cuentaInstance = Cuenta.get(cuentaId)
		return cuentaInstance.actionRegistro
	}

	
	def guardarStepRegistro(Long cuentaId, String action){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance){
			cuentaInstance.actionRegistro = action
			cuentaInstance.save(flush:true, failOnError:true)
		}
	}

	public static String calcularCUIT(String documento, Boolean esHombre){
		def tipo
		if(esHombre)
			tipo="20"
		else
			tipo="27"

		def tipoYDoc = tipo + documento
		Integer[] serie = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2]
		Integer sumaTotal = 0
		for (int i=0; i<10; i++){
        	sumaTotal += (tipoYDoc[i]).toInteger() * serie[i]
   		}
   		def resto = sumaTotal%11
   		def verificador
   		if(resto==0)
   			verificador="0"
   		else{
   			if(resto==1){
   				if(esHombre){
   					verificador="9"
   					tipo="23"
   				}
   				else{
   					verificador="4"
   					tipo="23"
   				}
   			}
   			else{
   				verificador=11-resto
   			}
   		}
   		def cuit = tipo+documento+verificador.toString()
   		return cuit
	}

	def getFacturacion(Long cuentaId, String categoria){
		def mes = new LocalDate().toString("MM")
		def primerSemestre = ["01","02","03","04","05","06"]
		def resultado
		def monotributista = categoria != null

		if(primerSemestre.contains(mes))
			resultado = getFacturacionSemestre(1,mes,cuentaId,monotributista)
		else 
			resultado = getFacturacionSemestre(2,mes,cuentaId,monotributista)

		return resultado
	}

	def getFacturacionSemestre(Integer semestre, String mesActual, Long cuentaId, Boolean monotributista){
		def cuenta = Cuenta.get(cuentaId)
		def meses = []
		def numeroMesActual = new Integer(mesActual)
		def resultado = [:]

		if(semestre==1){
			meses = ["07","08","09","10","11","12","01"]
			for(int i=2;i<=numeroMesActual;i++){
				meses.push("0"+i)
			}
		}
		else{
			meses = ["01","02","03","04","05","06","07"]
			for(int i=8;i<=numeroMesActual;i++){
				if(i>=10)
					meses.push(""+i)
				else
					meses.push("0"+i)
			}
		}

		def facturasCuenta = FacturaVenta.findAllByCuenta(cuenta)
		Double facturacionTotalPeriodo = 0
		def facturacionMensual = []
		Double subtotalMensual = 0
		def facturas 
		LocalDate fecha
		def ano = new LocalDate().toString("YYYY")
		def anoAnterior = new LocalDate().minusYears(1).toString("YYYY")

		meses.each{mes->
			if(semestre==1){
				if(["07","08","09","10","11","12"].contains(mes))
					fecha = new LocalDate(anoAnterior+"-"+mes)
				else
					fecha = new LocalDate(ano+"-"+mes)
			}
			else{
				fecha = new LocalDate(ano+"-"+mes)
			}
			
			facturas = facturasCuenta.findAll{facturaVenta ->
				(facturaVenta.fecha.toString("YYYY-MM") == fecha.toString("YYYY-MM")) }

			if(facturas)
				subtotalMensual = monotributista ? facturas.sum{it.totalReal} : facturas.sum{it.netoReal}
			else
				subtotalMensual = 0

			facturacionTotalPeriodo += subtotalMensual
			facturacionMensual.push(subtotalMensual)	
		}
		resultado['facturacionTotalPeriodo'] = facturacionTotalPeriodo
		resultado['facturacionMensual'] = facturacionMensual
		return resultado
	}

	def actualizarRangoFacturacion(Long cuentaId, String rangoFacturacion){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			cuentaInstance.rangoFacturacion = rangoFacturacion
			cuentaInstance.save(flush:true, failOnError:true)
		}
		
	}

	def actualizarProfesion(Long cuentaId, String profesion){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			cuentaInstance.profesion = profesion
			cuentaInstance.save(flush:true, failOnError:true)
		}
		return cuentaInstance
	}

	def actualizarInscriptoAfip(Long cuentaId, Boolean inscriptoAfip){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			cuentaInstance.inscriptoAfip = inscriptoAfip
			cuentaInstance.save(flush:true, failOnError:true)
		}
		return cuentaInstance
	}

	def actualizarCelular(Long cuentaId, String celular){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			cuentaInstance.whatsapp = celular
			cuentaInstance.telefono = celular
			cuentaInstance.save(flush:true, failOnError:true)
		}
		return cuentaInstance
	}

	def agregarCodigoDescuento(Long cuentaId, String codigoIngresado){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance != null){
			def codigo = CodigoDescuento.findByCodigo(codigoIngresado)
			assert codigo != null: "El codigo ingresado no existe"
			assert !codigo.redimido || codigo.beneficiado == cuentaInstance : "El codigo ingresado ya ha sido utilizado"
			codigo.beneficiado = cuentaInstance
			codigo.save(flush:true, failOnError:true)
			cuentaInstance.addToCodigosDescuento(codigo)
			cuentaInstance.save(flush:true, failOnError:true)
		}
	}

	def actualizarDescripcionActividad(Long cuentaId, String descripcion){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			cuentaInstance.descripcionActividad= descripcion
			cuentaInstance.save(flush:true, failOnError:true)
		}
	}

	def actualizarApps(Long cuentaId, idApps){
		def salida = []
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			borrarApps(cuentaInstance)
			def item
			idApps.each{appId -> 
						item = new ItemApp()
						item.cuenta=cuentaInstance
						item.app=App.get(appId)
						salida << item.app?.nombre
						item.save(flush:true, failOnError:true)
						}	
		}
		return salida.join(", ")
	}

	def borrarApps(Cuenta cuentaInstance){
		def items = ItemApp.findAllByCuenta(cuentaInstance)
		if(items)
			items.each{item -> item.delete(flush:true)}
	}

	def actualizarDocumento(Long cuentaId, String documento, String tipoDocumento){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			cuentaInstance.documento = documento
			cuentaInstance.tipoDocumento = tipoDocumento
			cuentaInstance.save(flush:true, failOnError:true)
		}
	}

	def actualizarDomicilio(Long cuentaId, Domicilio domicilio){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			cuentaInstance.domicilioFiscal = domicilio
			cuentaInstance.save(flush:true, failOnError:true)
		}
	}

	def actualizarNacionalidad(Long cuentaId, String nacionalidadId){
		def nacionalidad = Nacionalidad.get(nacionalidadId)
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			cuentaInstance.nacionalidad = nacionalidad
			cuentaInstance.save(flush:true, failOnError:true)
		}
	}

	def actualizarObraSocial(Long cuentaId, String obraSocialId){
		def obraSocial = ObraSocial.get(obraSocialId)
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			cuentaInstance.obraSocial = obraSocial
			cuentaInstance.save(flush:true, failOnError:true)
		}
	}

	def actualizarSexo(Long cuentaId, String sexo){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance){
			cuentaInstance.sexo = sexo
			cuentaInstance.save(flush:true, failOnError:true)
		}
	}

	def activarCuenta(Cuenta cuentaInstance){
		def estadoActivo = Estado.findByNombre('Activo')
		cuentaInstance.estado = estadoActivo
		
		cuentaInstance.save(flush:true, failOnError:true)
	}

	def actualizarProvincia(Long cuentaId, String provinciaId){
		def cuentaInstance = Cuenta.get(cuentaId)
		borrarProvincia(cuentaInstance)
		def provincia = Provincia.get(provinciaId)

		def porcentajeProvincia100 = new PorcentajeProvinciaIIBB()
		porcentajeProvincia100.provincia = provincia
		porcentajeProvincia100.porcentaje = new Double(100)
		porcentajeProvincia100.ultimoModificador = "Registro"
		porcentajeProvincia100.ultimaModificacion = new LocalDateTime()
		porcentajeProvincia100.estado = Estado.findByNombre('Activo')

		cuentaInstance.addToPorcentajesProvinciaIIBB(porcentajeProvincia100)

		if(cuentaInstance.trabajaConApp()){
			def provincia0 = Provincia.findByNombre(provincia.provinciaCeroPorCiento())

			def porcentajeProvincia0 = new PorcentajeProvinciaIIBB()
			porcentajeProvincia0.provincia = provincia0
			porcentajeProvincia0.porcentaje = new Double(0)
			porcentajeProvincia0.ultimoModificador = "Registro"
			porcentajeProvincia0.ultimaModificacion = new LocalDateTime()
			porcentajeProvincia0.estado = Estado.findByNombre('Activo')

			cuentaInstance.addToPorcentajesProvinciaIIBB(porcentajeProvincia0)
		}
		
		cuentaInstance.save(flush:true, failOnError:true)
		return provincia.nombre
	}
	def borrarProvincia(Cuenta cuentaInstance){
		def items = PorcentajeProvinciaIIBB.findAllByCuenta(cuentaInstance)
		if(items)
		items.each{item -> item.delete(flush:true)}
	}

	def actualizarEstadoRelacionDependencia(Long cuentaId, Boolean reldep){
		Cuenta.get(cuentaId)?.with{
			relacionDependencia = reldep
			save(flush:true, failOnError:true)
		}
	}

	def actualizarErrorAfip(Long cuentaId, Boolean hayError){
		Cuenta.get(cuentaId)?.with{
			registroConErrorAFIP = hayError
			save(flush:true, failOnError:true)
		}
	}

	def actualizarTelefono(Long cuentaId, String telefono){
		def cuentaInstance = Cuenta.get(cuentaId)

		if(cuentaInstance!=null){
			cuentaInstance.telefono = telefono
			cuentaInstance.save(flush:true, failOnError:true)
		}

		return cuentaInstance
	}

	def actualizarCuit(Long cuentaId, String cuit){
		def cuentaInstance = Cuenta.get(cuentaId)

		if(cuentaInstance!=null){
			cuentaInstance.cuit = cuit
			cuentaInstance.save(flush:true, failOnError:true)
		}

		return cuentaInstance
	}

	def actualizarClaveFiscal(Long cuentaId, String claveFiscal){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			cuentaInstance.claveFiscal = claveFiscal
			cuentaInstance.save(flush:true, failOnError:true)
			verificarErroresCorregidos(cuentaId)
		}
		return cuentaInstance
	}

	def actualizarBitrixDealId(Long cuentaId, Integer dealId){
		def cuentaInstance = Cuenta.get(cuentaId)
		cuentaInstance.bitrixDealId = new Long(dealId)
		cuentaInstance.save(flush:true,failOnError:true)
		return
	}

	def actualizarBitrixId(Long cuentaId, Integer contactId){
		def cuentaInstance = Cuenta.get(cuentaId)
		cuentaInstance.bitrixId = new Long(contactId)
		cuentaInstance.save(flush:true,failOnError:true)
		return
	}

	def actualizarBitrixTaskId(Long cuentaId, Long taskId){
		def cuentaInstance = Cuenta.get(cuentaId)
		cuentaInstance.bitrixTaskId = taskId
		cuentaInstance.save(flush:true,failOnError:true)
		return
	}

	def listTiposClave(){
		return TipoClave.list()
	}

	def listTiposPersona(){
		return TipoPersona.list()
	}

	def listImpuestos(){
		return Impuesto.list()
	}

	def listCategorias(){
		return Categoria.list()
	}

	def listResponsables(){
		return Vendedor.list()
	}

	def listNacionalidades(){
		return Nacionalidad.list().sort{it.nombre}
	}

	def listObrasSociales(){
		return ObraSocial.list()
	}

	def getCantidadImpuestos(Long cuentaId){
		return getCuenta(cuentaId)?.impuestos
	}

	def desactivarNotificacionesCuenta(Long userId, Long cuentaIdVerificador){
		Cuenta cuenta = User.get(userId)?.cuenta
		assert cuenta?.id == cuentaIdVerificador
		cuenta.recibirNotificaciones = false
		cuenta.recibirNotificacionVep = false
		cuenta.recibirNotificacionDeclaracionJurada = false
		cuenta.recibirNotificacionFacturaCuenta = false
		cuenta.save(flush:true, failOnError:true)
	}

	def reenviarMailBienvenida(Long cuentaId){
		String username = User.findByCuenta(getCuenta(cuentaId))?.username
		def registrationCode = new RegistrationCode(username: username)
		registrationCode.save(flush: true)
		String url = grailsApplication.config.getProperty('grails.serverURL') + grailsLinkGenerator.link(controller: 'registrar', action: 'verifyRegistration', absolute: false, params:['t': registrationCode.token])

		String urlNotificaciones = usuarioService.getLinkDesactivarNotificaciones(usuarioService.getUsuario(username))

		def conf = SpringSecurityUtils.securityConfig
		//def body = messageSource.getMessage('calim.register.email.body', [url, urlNotificaciones] as Object[], '', LocaleContextHolder.locale)
		//def asunto = messageSource.getMessage('calim.register.email.subject', [] as Object[], '', LocaleContextHolder.locale)

		NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Email Registro")
		String bodyMail = plantilla.llenarVariablesBody([url,urlNotificaciones])
		notificacionService.enviarEmail(username, plantilla.asuntoEmail, bodyMail, 'registro', null, plantilla.tituloApp, plantilla.textoApp)

	}

	def parsearAppsToIds(apps){
		def appsSplit = apps.split(',')
		def ids = []
		appsSplit.each{app-> ids.push(App.findByNombre(app).id)}
		return ids
	}

	def activacionManualToken (Long cuentaId){
		User usuario = User.findByCuenta(getCuenta(cuentaId))
		usuario.accountLocked = false
		RegistrationCode.findAllByUsername(usuario.username).each{
			it.delete(flush:false)
		}
		usuario.save(flush:true, failOnError:true)
	}

	def cambiarBooleanoPasos (Long cuentaId, String nombreBooleano){
		assert ['afipMiscomprobantes', 'ingresosBrutos', 'infoRevisada','claveAfipDelegada','puntoVentaCalim'].contains(nombreBooleano)
		def cuenta = getCuenta(cuentaId)
		cuenta[nombreBooleano] = !(cuenta[nombreBooleano])
		cuenta.save(flush:true, failOnError:true)
		if(nombreBooleano == "puntoVentaCalim" && cuenta.trabajaConApp()){
			notificacionService.notificarFacturacionHabilitadaDelivery(cuentaId)
		}	
	}

	def cambiarEtiqueta(Long cuentaId, String color){
		Cuenta cuenta = Cuenta.get(cuentaId)
		assert color != "Verde" || ( cuenta.primeraFacturaSMPaga && cuenta.getServicioActivo() ) : "La cuenta no tiene SM activo y pagofinerror"
		cuenta.etiqueta = color
		cuenta.save(flush:true, failOnError:true)
	}

	def guardarTokenFcm(Long cuentaId, String token){
		Cuenta cuenta = Cuenta.get(cuentaId)
		cuenta.tokenFCM = token
		cuenta.save(flush:true, failOnError:true)
	}

	def getAllApps(){
		return App.getAll()
	}

	def obtenerDeudores(){
		def lista = []
		Double sumatoriaImportes = 0;
		int sumatoriaCant = 0;
		Cuenta.findAllByEstado(Estado.findByNombre("Activo"))?.each{
			boolean algunoPago = false;
			boolean auxPagado;
			def movimientosImpagos = it.movimientos?.findAll{
				if (! it.factura?.itemMensual)
					return false
				auxPagado = it.pagado
				if (auxPagado)
					algunoPago = true
				return !auxPagado
			}
			if (movimientosImpagos){
				def item = [:]
				item['cuit'] = it.cuit
				item['razonSocial'] = it.razonSocial
				item['id'] = it.id
				item['algunSmPago'] = algunoPago
				item['bitrixId'] = it.bitrixId
				item['smActivo'] = it.servicioActivo?.toString() ?: '-'
				item['cantidad'] = movimientosImpagos.size()
				Double total = movimientosImpagos.sum{it.importe}
				item['total'] = formatear(total)
				lista << item

				sumatoriaCant += item.cantidad
				sumatoriaImportes += total
			}
		}
		def salida = [:]
		salida.total = formatear(sumatoriaImportes)
		salida.cantidad = sumatoriaCant
		salida.lista = lista
		return salida
	}

	def listMediosPago(Long ivaId, Long iibbId){listMediosPago(CondicionIva.get(ivaId)?:null, RegimenIibb.get(iibbId)?:null)}
	def listMediosPago(CondicionIva iva, RegimenIibb iibb){
		if (iva && iibb)
			if (iva.nombre == "Responsable inscripto" || iibb.nombre == "Convenio Multilateral")
				return MedioPago.findAllByAfip(true)
			else if (iibb.nombre == "B.A. Mensual")
				return MedioPago.findAllByArba(true)
			else if (["Sicol","Sicol Presunto", "Simplificado"].contains(iibb.nombre))
				return MedioPago.findAllByAgip(true)

		if(iva)
			return MedioPago.findAllByAfip(true)

		if(iibb)
			if(iibb.nombre == "B.A. Mensual")
				return MedioPago.findAllByArba(true)
			else if(["Sicol","Sicol Presunto","Simplificado"].contains(iibb.nombre))
				return MedioPago.findAllByAgip(true)
			else if(iibb.nombre == "Convenio Multilateral")
				return MedioPago.findAllByAfip(true)
			else if(iibb.nombre == "Unificado")
				return MedioPago.findAllByAfipOrNombre(true, "Efectivo")

		return MedioPago.list()
	}

	def setMontosMaximos(Long cuentaId, Double valorIva, Double valorIIBB){
		Cuenta.get(cuentaId).with{
			maximoAutorizarIIBB = valorIIBB
			maximoAutorizarIva = valorIva
			save(flush:true, failOnError:true)
		}
	}

	def descargarFotos(Long id){
		Cuenta cuenta = Cuenta.get(id)
		String path = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuenta.path + "/fotos/"
		new File(path + "fotos " + cuenta.cuit + ".zip").with{
			if (exists())
				delete()
		}
		def zipFile = new java.util.zip.ZipOutputStream(new FileOutputStream(path + "fotos " + cuenta.cuit + ".zip"))  
		new File(path).listFiles().each { file -> 
		  //check if file
		  if (file.isFile() && ! file.name.contains(".zip")){
		    zipFile.putNextEntry(new java.util.zip.ZipEntry(file.name))
		    def buffer = new byte[file.size()]  
		    file.withInputStream { 
		      zipFile.write(buffer, 0, it.read(buffer))  
		    }  
		    zipFile.closeEntry()
		  }
		}  
		zipFile.close()
		return new File(path + "fotos " + cuenta.cuit + ".zip")
	}

	def errorAltaNotificado(Long cuentaId, Boolean fotos, Boolean claveFiscal, Boolean direccion, Boolean codigoPostal){
		def cuenta = Cuenta.get(cuentaId)
		def domicilio = cuenta.domicilioFiscal
		LocalDateTime fech = new LocalDateTime().plusDays(2).plusHours(3)
		if(fotos)
			cuenta.ingresoFotosRegistro = false
		if(claveFiscal)
			cuenta.claveFiscal = null
		if(direccion){
			domicilio.direccion = "ERROR"
			domicilio.save(flush:true,failOnError:true)
		}
		if(codigoPostal){
			domicilio.codigoPostal = "ERROR"
			domicilio.save(flush:true,failOnError:true)
		}
		cuenta.contadorDisparosError = cuenta.contadorDisparosError ? cuenta.contadorDisparosError + 1 : 1

		if(cuenta.bitrixTaskId)
			try{
				bitrixService.editarTask(cuenta.bitrixTaskId, ["fields":["TITLE":"Error Alta Monotributo Delivery","DEADLINE":fech.toString()]])
			}
			catch(e){
				log.error("Ocurrio un error editando task tras notificacion de errores registro delivery")
			}

		cuenta.save(flush:true,failOnError:true)
	}

	def actualizarDomicilioError(Long cuentaId, String direccion, String codigoPostal){
		def cuentaInstance = Cuenta.get(cuentaId)
		if(cuentaInstance!=null){
			def domicilio = cuentaInstance.domicilioFiscal 
			domicilio.direccion = direccion
			domicilio.codigoPostal = codigoPostal
			domicilio.save(flush:true,failOnError:true)
			cuentaInstance.save(flush:true, failOnError:true)
			verificarErroresCorregidos(cuentaId)
		}
	}

	def verificarErroresCorregidos(Long cuentaId){
		def cuenta = Cuenta.get(cuentaId)
		if(cuenta.claveFiscal && cuenta.ingresoFotosRegistro && cuenta.domicilioFiscal.direccion != "ERROR" && cuenta.domicilioFiscal.codigoPostal != "ERROR"){
			LocalDateTime fech = new LocalDateTime().plusDays(2).plusHours(3)
			if(cuenta.bitrixTaskId){
				try{
					bitrixService.editarTask(cuenta.bitrixTaskId,["fields":["TITLE":"Alta Delivery Monotributo","DEADLINE":fech.toString()]])
				}
				catch(e){
					log.error("Ocurrio un error editando task tras correccion de errores registro delivery")
				}
			}

		}
	}

	def listCuentasSMActivo(){
		String hoy = new LocalDate().toString("yyyy-MM-dd")
		String query = """
			SELECT cuenta.id,
			       cuit, 
			       razon_social,
			       email,
			       item_servicio.debito_automatico AS debitoAutomatico,
			       tarjeta.numero as tarjetaNum
			FROM   cuenta 
				   LEFT JOIN tarjeta
				   		  ON cuenta.tarjeta_debito_automatico_id = tarjeta.id
			       INNER JOIN item_servicio 
			              ON cuenta.id = item_servicio.cuenta_id AND item_servicio.fecha_alta <= '${hoy}' AND (item_servicio.fecha_baja is null OR item_servicio.fecha_baja > '${hoy}')
			       INNER JOIN servicio
			       		  ON servicio.id = item_servicio.servicio_id AND servicio.mensual
			WHERE  cuenta.estado_id = 8 AND cuenta.tenant_id = 2 AND rider_id is null;
		"""
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.selected = ''
			item.id = it[0]
			item.cuit = it[1]
			item.razonSocial = it[2]
			item.email = it[3]
			item.debito = it[4]
			item.tarjeta = it[5]
			return item
		}
	}

	def adquisicionDeServicio(Long cuentaId, String descripcionServicio){
		def cuenta
		if(descripcionServicio == "SE11 - Baja AFIP + IIBB" || descripcionServicio == "SE06 - Baja AFIP"){
			cuenta = Cuenta.get(cuentaId)
			cuenta.condicionIva = CondicionIva.findByNombre("Sin inscribir")
			cuenta.save(flush:true,failOnError:true)
		}
	}

	def coeficientesConvenio(Long cuentaId, Integer ano){ coeficientesConvenio(Cuenta.get(cuentaId), ano) }
	def coeficientesConvenio(Cuenta cuenta, Integer ano){
		def tablaDistribucion = []
		LocalDate fecha = new LocalDate(ano,1,1)
		def jurisdicciones = cuenta.porcentajesProvinciaIIBBActivos.collect{it.provincia}
		String sede = cuenta.provincia.toString(true)
		// Incializo la tabla
		jurisdicciones.each{
			def itemTabla = [:]
			itemTabla.jurisdiccion = it.toString(true)
			for(i in 1..12) {
				itemTabla["ventas" + i] = new Double(0)
				itemTabla["compras" + i] = new Double(0)
				itemTabla["retenciones" + i] = new Double(0)
				itemTabla["percepciones" + i] = new Double(0)
			}
			itemTabla.ventasTotal = new Double(0)
			itemTabla.comprasTotal = new Double(0)
			itemTabla.retencionesTotal = new Double(0)
			itemTabla.percepcionesTotal = new Double(0)
			tablaDistribucion << itemTabla
		}
		// Lleno la tabla con las ventas
		FacturaVenta.createCriteria().list() {
			and{
				eq('cuenta', cuenta)
				ge('fecha', fecha)
				lt('fecha', fecha.plusYears(1))
			}
		}.each{ factura ->
			String jurisdiccion = factura.cliente.provincia?.toString(true) ?: sede
			Double monto = factura.montoLiquidable
			def itemTabla = tablaDistribucion.find{it.jurisdiccion == jurisdiccion}
			itemTabla["ventas" + factura.fecha.monthOfYear] += monto
			// itemTabla.ventasTotal += monto
		}
		// Lleno la tabla con las compras
		FacturaCompra.createCriteria().list() {
			and{
				eq('cuenta', cuenta)
				ge('fecha', fecha)
				lt('fecha', fecha.plusYears(1))
			}
		}.each{ factura ->
			String jurisdiccion = factura.proveedor?.provincia?.toString(true) ?: sede
			Double monto = factura.montoLiquidable
			def itemTabla = tablaDistribucion.find{it.jurisdiccion == jurisdiccion}
			itemTabla["compras" + factura.fecha.monthOfYear] += monto
			// itemTabla.comprasTotal += monto
		}
		// Lleno la tabla con las retenciones y percepciones
		RetencionPercepcionIIBB.createCriteria().list() {
			and{
				eq('cuenta', cuenta)
				ge('fecha', fecha)
				lt('fecha', fecha.plusYears(1))
			}
		}.each{ deduccion ->
			String jurisdiccion = deduccion.provincia.toString(true)
			String prefijo = deduccion.tipo == "percepcion" ? "percepciones" : "retenciones"
			def itemTabla = tablaDistribucion.find{it.jurisdiccion == jurisdiccion}
			itemTabla[prefijo + deduccion.fecha.monthOfYear] += deduccion.monto
			// itemTabla[prefijo + "Total"] += deduccion.monto
		}
		// Redondeo todo y sumo los totales
		tablaDistribucion.each{ itemTabla ->
			for(i in 1..12) {
				itemTabla.ventasTotal += itemTabla["ventas" + i]
				itemTabla["ventas" + i] = formatear(itemTabla["ventas" + i])
				itemTabla.comprasTotal += itemTabla["compras" + i]
				itemTabla["compras" + i] = formatear(itemTabla["compras" + i])
				itemTabla.retencionesTotal += itemTabla["retenciones" + i]
				itemTabla["retenciones" + i] = formatear(itemTabla["retenciones" + i])
				itemTabla.percepcionesTotal += itemTabla["percepciones" + i]
				itemTabla["percepciones" + i] = formatear(itemTabla["percepciones" + i])
			}
			itemTabla.ventasTotal = formatear(itemTabla.ventasTotal)
			itemTabla.comprasTotal = formatear(itemTabla.comprasTotal)
			itemTabla.retencionesTotal = formatear(itemTabla.retencionesTotal)
			itemTabla.percepcionesTotal = formatear(itemTabla.percepcionesTotal)
		}
		return tablaDistribucion 
	}
}