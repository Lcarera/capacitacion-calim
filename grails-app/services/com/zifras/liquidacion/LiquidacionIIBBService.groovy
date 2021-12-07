package com.zifras.liquidacion

import static com.zifras.inicializacion.JsonInicializacion.formatear

import com.zifras.AccessRulesService
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.Localidad
import com.zifras.Provincia
import com.zifras.User
import com.zifras.UsuarioService
import com.zifras.Zona

import com.zifras.cuenta.Actividad
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.Local
import com.zifras.cuenta.PorcentajeProvinciaIIBB
import com.zifras.cuenta.RegimenIibb

import com.zifras.documento.DeclaracionJuradaService
import com.zifras.documento.VencimientoDeclaracion
import com.zifras.facturacion.FacturaVentaService
import com.zifras.facturacion.TipoComprobante
import com.zifras.selenium.SeleniumService
import com.zifras.notificacion.NotificacionService
import com.zifras.notificacion.NotificacionTemplate

import grails.transaction.Transactional
import grails.validation.ValidationException
import grails.web.mapping.LinkGenerator
import groovy.json.JsonSlurper
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

@Transactional
class LiquidacionIIBBService {
	def retencionPercepcionService
	AccessRulesService accessRulesService
	def facturaVentaService
	def usuarioService
	def notificacionService
	def grailsApplication
	SeleniumService seleniumService
	LinkGenerator grailsLinkGenerator
	def declaracionJuradaService

	def createLiquidacionIIBBCommand(LiquidacionIIBBCommand command){
		def currentUser = accessRulesService.getCurrentUser()
		def estadoActivo = Estado.findByNombre('Activo')

		if(command==null){
			command = new LiquidacionIIBBCommand()
			// TOFIX: CreateCommand de IIBB 
			// Por ahora se hardcodean valores para que funcione sin recibir bien el parámetro
			command.provinciaId = Provincia.findByNombre("CABA").id
			def hoy = new LocalDate()
			command.ano = hoy.toString("YYYY")
			command.mes = hoy.toString("MM")
		}

		command.estadoId = Estado.findByNombre('Liquidado').id

		def provincia = Provincia.get(command.provinciaId)

		if(command.provinciaId==null)
			command.provinciaId = provincia.id

		command.retencion = 0
		command.percepcion = 0
		command.sircreb = 0

		//Si hay una cuenta seteada se busca si tiene una liquidación en el mes anterior
		if(command.cuentaId!=null){
			def cuenta = Cuenta.get(command.cuentaId)
			command.porcentajeProvincia = PorcentajeProvinciaIIBB.findByProvinciaAndEstadoAndCuenta(provincia, estadoActivo, cuenta)?.porcentaje ?: 0
			//Tiene que estar seteado el año y el mes
			if((command.ano!=null)&&(command.mes)){
				command.fechaVencimiento = VencimientoDeclaracion.findAllByMesPeriodoAndTipoImpuesto(new Integer(command.mes), (cuenta.esConvenio ? "Convenio" : "IIBB")).find{ it.cuitAplica(cuenta.cuit) }?.fechaVencimiento
				def fechaLiquidacion = new LocalDate(command.ano + '-' + command.mes + '-01')
				def fechaLiquidacionMesAnterior = fechaLiquidacion.minusMonths(1)

				LiquidacionIIBB liquidacionAnterior = LiquidacionIIBB.findByCuentaAndProvinciaAndFecha(cuenta, provincia, fechaLiquidacionMesAnterior)

				if(liquidacionAnterior!=null){
					command.saldoAFavorPeriodoAnterior = liquidacionAnterior.saldoAFavor
				}else{
					command.saldoAFavorPeriodoAnterior = 0
				}

				command.netoTotal = LiquidacionIva.findByCuentaAndFecha(cuenta, fechaLiquidacion)?.netoVenta ?: 0

				command.neto = ((command.netoTotal * command.porcentajeProvincia) / 100).round(2)

				//Acá debo calcular el impuesto total
				//debo tomar las alícuotas de la provincia seteada

				command.impuesto = 0

				cuenta.alicuotasIIBB.each{
					if((it.provincia==provincia)&&(it.estado==estadoActivo)){
						def liquidacionIIBBAlicuota = new LiquidacionIIBBAlicuota()

						command.impuesto = (command.impuesto + ((command.neto * it.porcentaje)/100 * it.valor/100)).round(2)
					}
				}

				if(command.impuesto < command.saldoAFavorPeriodoAnterior){
					command.saldoAFavor = (command.saldoAFavorPeriodoAnterior - command.impuesto).round(2)
					command.saldoDdjj = 0
				}else{
					command.saldoAFavor = 0
					command.saldoDdjj = (command.impuesto - command.saldoAFavorPeriodoAnterior).round(2)
				}
			}
		}

		def listaRetPerBanc = retencionPercepcionService.calcularRetencionPercepcionSumatoria(command.cuentaId, command.mes, command.ano, false)
		command.retencionSumatoria = listaRetPerBanc[0]
		command.bancariaSumatoria = listaRetPerBanc[1]
		command.percepcionSumatoria = listaRetPerBanc[2]
		return command
	}

	def listLiquidacionIIBB() {
		return LiquidacionIIBB.list()
	}

	def getLiquidacionIIBB(Long id){
		def liquidacionIIBBInstance = LiquidacionIIBB.get(id)
	}

	def getLiquidacionesIIBBPorCuentaYFecha(Long cuentaId, String ano, String mes){
		LocalDate fecha = new LocalDate(ano + '-' + mes + '-01')
		return LiquidacionIIBB.findAllByCuentaAndFecha(Cuenta.get(cuentaId), fecha)
	}

	def getLiquidacionIIBBCommand(Long id){
		LiquidacionIIBB liquidacionIIBBInstance = LiquidacionIIBB.get(id)

		return liquidacionIIBBInstance ? pasarDatos(liquidacionIIBBInstance, createLiquidacionIIBBCommand()) : null
	}

	def getLiquidacionIIBBList(String mes, String ano) {
		def lista
		Estado activo = Estado.findByNombre('Activo')
		Estado sinLiquidar = Estado.findByNombre('Sin liquidar')
		//Debo traer las cuentas que tengan un régimen IIBB
		//B.A. Mensual y Sicol
		def regimenBAMensual = RegimenIibb.findByNombre('B.A. Mensual')
		def regimenSicol = RegimenIibb.findByNombre('Sicol')
		def regimenCM = RegimenIibb.findByNombre('Convenio Multilateral')
		def cuentas = Cuenta.createCriteria().list() {
					and{
						inList('regimenIibb', [regimenBAMensual, regimenSicol, regimenCM])
						eq('estado', activo)
						if (accessRulesService.currentUser.userTenantId == 2)
							eq('etiqueta', "Verde")
					}
		};

		def salida = []
		def fecha = new LocalDate(ano + '-' + mes + '-01')
		def liquidaciones = LiquidacionIIBB.findAllByFecha(fecha)
		cuentas.each{
			def cuenta = it
			if(cuenta.regimenIibb.nombre != "Simplificado"){
				def provincias = getProvinciasDeCuenta(cuenta)

				provincias.each{
					def provincia = it
					def liquidacion = liquidaciones.find { it.cuenta.id == cuenta.id && it.provincia.id == provincia.id}
					if(liquidacion==null){
						liquidacion = new LiquidacionIIBB()
						liquidacion.cuenta = cuenta
						liquidacion.fecha = fecha
						liquidacion.estado = sinLiquidar
						liquidacion.provincia = provincia

						cuenta.locales.each{
							def liquidacionLocal = new LiquidacionIIBBLocal()
							liquidacionLocal.local = it
							liquidacionLocal.porcentajeLocal = it.porcentaje
							liquidacion.addToLiquidacionlocales(liquidacionLocal)
						}
					}

					salida.push(liquidacion)
				}
			}
		}

		return salida
	}

	def getProvinciasDeCuenta(Cuenta cuenta){
		def provincias = []
		if (accessRulesService.getCurrentUser().userTenantId == 1){
			cuenta.locales.each{
				if(it.estado.nombre=="Activo"){
					def provincia = it.provincia

					def esta = false
					provincias.each{
						if(it.id == provincia.id)
							esta = true
					}

					if(!esta){
						provincias.push(provincia)
					}
				}
			}
		}else{
			cuenta.porcentajesProvinciaIIBB.each{
				if (it.estado.nombre != "Borrado" && (!provincias.contains(it.provincia)))
					provincias.push(it.provincia)
			}
		}

		return provincias
	}

	def getLiquidacionesPorCuenta(Long cuentaId, String ano) {
		def cuenta = Cuenta.get(cuentaId)
		def salida = []

		def mes = new LocalDate(ano + '-01-01')
		Estado estadoSinLiquidar = Estado.findByNombre('Sin liquidar')
		def i
		def provincias = getProvinciasDeCuenta(cuenta)
		def liquidacionesDeCuenta = LiquidacionIIBB.createCriteria().list(){
			and{
				eq('cuenta', cuenta)
				ge('fecha', mes)
				le('fecha', mes.plusMonths(12))
			}
		}
		for(i=0; i<12; i++){
			//puede haber más de una liquidacion porque puede tener varias provincias
			def liquidaciones = liquidacionesDeCuenta.findAll { it.fecha == mes}
			if(! liquidaciones){
				provincias.each{
					def liquidacion = new LiquidacionIIBB()
					liquidacion.cuenta = cuenta
					liquidacion.fecha = mes
					liquidacion.estado = estadoSinLiquidar
					liquidacion.provincia = it

					salida.push(liquidacion)
				}
			}else{
				liquidaciones.each{
					salida.push(it)
				}
			}

			mes = mes.plusMonths(1)
		}
		return salida
	}

	def borrarLiquidacionIIBB(Long id){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionIIBB = LiquidacionIIBB.get(id)
		liquidacionIIBB.estado = estadoBorrado

		def currentUser = accessRulesService.getCurrentUser()
		liquidacionIIBB.ultimaModificacion = new LocalDateTime()
		liquidacionIIBB.ultimoModificador = currentUser.username
		liquidacionIIBB.save(flush:true)

		return liquidacionIIBB
	}

	def deleteLiquidacionIIBB(Long id){
		def liquidacionIIBBInstance = LiquidacionIIBB.get(id)
		liquidacionIIBBInstance.delete(flush:true, failOnError:true)
	}

	def deleteLiquidacionIIBBRepetidas(LocalDate mes){
		def liquidaciones = LiquidacionIIBB.createCriteria().list() {
			eq('fecha', mes)
			order('cuenta')
		}

		def liquidacionesIds = []

		def liquidacionAnterior = null
		liquidaciones.each {
			if(liquidacionAnterior!=null){
				//Se trata de la misma liquidacion
				if(it.cuenta == liquidacionAnterior.cuenta){
					if(it.id > liquidacionAnterior.id)
						liquidacionesIds.push(liquidacionAnterior.id)
					else
						liquidacionesIds.push(it.id)
				}
			}

			liquidacionAnterior = it
		}

		def count = 0
		liquidacionesIds.each{
			def liquidacionParaBorrar = LiquidacionIIBB.get(it)
			liquidacionParaBorrar.delete(flush:true)
			println count.toString() + " Se borra la liquidacion: " + it.toString()
			count++
		}

		return count
	}

	def saveLiquidacionIIBB(LiquidacionIIBBCommand command){
		return pasarDatos(command, new LiquidacionIIBB()).save(flush:true, failOnError:true)
	}

	def updateLiquidacionIIBB(LiquidacionIIBBCommand command){
		def liquidacionIIBBInstance = LiquidacionIIBB.get(command.liquidacionIIBBId)

		if (command.version != null) {
			if (liquidacionIIBBInstance.version > command.version) {
				LiquidacionIIBBCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["LiquidacionIIBB"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado al LiquidacionIIBB")
				throw new ValidationException("Error de versión", LiquidacionIIBBCommand.errors)
			}
		}

		return pasarDatos(command, liquidacionIIBBInstance).save(flush:true, failOnError:true)
	}

	def updateRetencionSircreb(LiquidacionIIBBCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionIIBBInstance = LiquidacionIIBB.get(command.liquidacionIIBBId)

		if (command.version != null) {
			if (liquidacionIIBBInstance.version > command.version) {
				LiquidacionIIBBCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["LiquidacionIIBB"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado al LiquidacionIIBB")
				throw new ValidationException("Error de versión", LiquidacionIIBBCommand.errors)
			}
		}

		if(liquidacionIIBBInstance==null){
			liquidacionIIBBInstance = new LiquidacionIIBB()

			if(command.provinciaId!=null){
				liquidacionIIBBInstance.provincia = Provincia.get(command.provinciaId)
			}

			liquidacionIIBBInstance.fecha = new LocalDate(command.ano + '-' + command.mes + '-01')

			liquidacionIIBBInstance.netoTotal = 0
			liquidacionIIBBInstance.porcentajeProvincia = 0

			liquidacionIIBBInstance.neto = 0
			liquidacionIIBBInstance.impuesto = 0

			liquidacionIIBBInstance.sircreb = command.sircreb
			liquidacionIIBBInstance.retencion = command.retencion
			liquidacionIIBBInstance.percepcion = command.percepcion

			liquidacionIIBBInstance.saldoAFavorPeriodoAnterior = 0
			liquidacionIIBBInstance.saldoAFavor = 0

			liquidacionIIBBInstance.saldoDdjj = 0

			if(command.cuentaId!=null){
				def cuenta = Cuenta.get(command.cuentaId)
				liquidacionIIBBInstance.cuenta = cuenta
			}
		}

		if(command.retencion!=null)
			liquidacionIIBBInstance.retencion = command.retencion
		else
			liquidacionIIBBInstance.retencion = 0

		if(command.sircreb!=null)
			liquidacionIIBBInstance.sircreb = command.sircreb
		else
			liquidacionIIBBInstance.sircreb = 0

		if(command.percepcion!=null)
			liquidacionIIBBInstance.percepcion = command.percepcion
		else
			liquidacionIIBBInstance.percepcion = 0

		liquidacionIIBBInstance.estado = Estado.findByNombre('Sircreb/Ret ingresado')

		def currentUser = accessRulesService.getCurrentUser()
		liquidacionIIBBInstance.ultimaModificacion = new LocalDateTime()
		liquidacionIIBBInstance.ultimoModificador = currentUser.username

		liquidacionIIBBInstance.save(flush:true)

		return liquidacionIIBBInstance
	}

	def updateNota(LiquidacionIIBBCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionIIBBInstance = LiquidacionIIBB.get(command.liquidacionIIBBId)

		if (command.version != null) {
			if (liquidacionIIBBInstance.version > command.version) {
				LiquidacionIIBBCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["LiquidacionIIBB"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado al LiquidacionIIBB")
				throw new ValidationException("Error de versión", LiquidacionIIBBCommand.errors)
			}
		}

		if(liquidacionIIBBInstance==null){
			liquidacionIIBBInstance = new LiquidacionIIBB()

			if(command.provinciaId!=null){
				liquidacionIIBBInstance.provincia = Provincia.get(command.provinciaId)
			}

			liquidacionIIBBInstance.fecha = new LocalDate(command.ano + '-' + command.mes + '-01')

			liquidacionIIBBInstance.netoTotal = 0
			liquidacionIIBBInstance.porcentajeProvincia = 0

			liquidacionIIBBInstance.neto = 0
			liquidacionIIBBInstance.impuesto = 0

			liquidacionIIBBInstance.sircreb = command.sircreb
			liquidacionIIBBInstance.retencion = command.retencion
			liquidacionIIBBInstance.percepcion = 0

			liquidacionIIBBInstance.saldoAFavorPeriodoAnterior = 0
			liquidacionIIBBInstance.saldoAFavor = 0

			liquidacionIIBBInstance.saldoDdjj = 0

			liquidacionIIBBInstance.retencion = 0
			liquidacionIIBBInstance.sircreb = 0

			if(command.cuentaId!=null){
				def cuenta = Cuenta.get(command.cuentaId)
				liquidacionIIBBInstance.cuenta = cuenta
			}
		}

		if(command.nota!=null)
			liquidacionIIBBInstance.nota = command.nota
		else
			liquidacionIIBBInstance.nota = ''

		liquidacionIIBBInstance.estado = Estado.findByNombre('Nota ingresada')

		def currentUser = accessRulesService.getCurrentUser()
		liquidacionIIBBInstance.ultimaModificacion = new LocalDateTime()
		liquidacionIIBBInstance.ultimoModificador = currentUser.username

		liquidacionIIBBInstance.save(flush:true)

		return liquidacionIIBBInstance
	}

	def liquidacionMasiva(LiquidacionIvaMasivaCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def estadoActivo = Estado.findByNombre('Activo')
		def fecha = new LocalDate(command.ano + '-' + command.mes + '-01')
		def fechaAnterior = fecha.minusMonths(1)
		def cuentasIds = command.cuentasIds.split(',')

		def resultado = []

		def liquidacionesIva = LiquidacionIva.findAllByFecha(fecha)
		def liquidaciones = LiquidacionIIBB.findAllByFecha(fecha)
		def liquidacionesAnteriores = LiquidacionIIBB.findAllByFecha(fechaAnterior)
		def estadoLiquidadoA = Estado.findByNombre('Liquidado A')
		def listaLocales = Local.findAllByEstado(estadoActivo)
		def currentUser = accessRulesService.getCurrentUser()

		cuentasIds.each{
			def cuenta = Cuenta.get(it)

			//Me fijo cuantas provincias tiene
			def provincias = getProvinciasDeCuenta(cuenta)

			LiquidacionIva liquidacionIva = liquidacionesIva.find { it.cuenta.id == cuenta.id}
			provincias.each {
				def provincia = it
				LiquidacionIIBB liquidacionAnterior = liquidacionesAnteriores.find { it.cuenta.id == cuenta.id && it.provincia.id == provincia.id}
				LiquidacionIIBB liquidacion = liquidaciones.find { it.cuenta.id == cuenta.id && it.provincia.id == provincia.id}

				if(liquidacion==null){
					liquidacion = new LiquidacionIIBB()
					liquidacion.retencion = 0
					liquidacion.percepcion = 0
					liquidacion.sircreb = 0
					liquidacion.cuenta = cuenta
					liquidacion.provincia = provincia
				}
				liquidacion.ultimaModificacion = new LocalDateTime()
				liquidacion.ultimoModificador = currentUser.username

				liquidacion.fecha = fecha
				liquidacion.porcentajeSaldoDdjj = command.porcentajeSaldoDdjj

				//En el caso que no tenga hecha la liquidación de IVA toma $0
				liquidacion.netoTotal = liquidacionIva?.netoVenta ?: 0

				//Tengo que tomar el % de IIBB que le corresponde a esta provincia
				//desde la configuracion de la cuenta
				def porcentajeProvinciaIIBB = 100
				cuenta.porcentajesProvinciaIIBB.each{
					if((it.provincia==provincia)&&(it.estado==estadoActivo)){
						porcentajeProvinciaIIBB = it.porcentaje
					}
				}
				liquidacion.porcentajeProvincia = porcentajeProvinciaIIBB
				liquidacion.neto = (liquidacion.porcentajeProvincia * liquidacion.netoTotal / 100).round(2)

				//Tengo que calcular el impuesto, tomo las alicuotas IIBB de la cuenta
				if(liquidacion.alicuotas!=null){
					liquidacion.alicuotas.clear()
					liquidacion.save(flush:true, failOnError:false)
				}

				def impuesto = 0
				cuenta.alicuotasIIBB.each{
					if((it.provincia==provincia)&&(it.estado==estadoActivo)){
						def alicuota = new LiquidacionIIBBAlicuota()
						alicuota.alicuota = it.valor
						alicuota.porcentaje = it.porcentaje

						alicuota.baseImponible = (liquidacion.neto * it.porcentaje / 100).round(2)
						alicuota.impuesto = (alicuota.baseImponible * alicuota.alicuota / 100).round(2)

						impuesto = (impuesto + alicuota.impuesto).round(2)

						liquidacion.addToAlicuotas(alicuota)
					}
				}
				liquidacion.impuesto = impuesto

				if(liquidacionAnterior!=null){
					liquidacion.saldoAFavorPeriodoAnterior = liquidacionAnterior.saldoAFavor
					//Obtiene los valores calculados por porcentaje pasado según liquidacion anterior
					liquidacion.saldoDdjj = (command.porcentajeSaldoDdjj * liquidacionAnterior.saldoDdjj).round(2)
				}else{
					liquidacion.saldoAFavorPeriodoAnterior = 0
					liquidacion.saldoDdjj = 0
				}

				liquidacion.percepcion = (liquidacion.impuesto - liquidacion.saldoDdjj - liquidacion.retencion - liquidacion.sircreb - liquidacion.saldoAFavorPeriodoAnterior).round(2)
				//El saldo a favor de este período siempre dará 0
				liquidacion.saldoAFavor = 0

				liquidacion.estado = estadoLiquidadoA
				liquidacion.save(flush:true, failOnError:false)

				if(liquidacion.liquidacionlocales!=null){
					liquidacion.liquidacionlocales.clear()
					liquidacion.save(flush:true, failOnError:false)
				}

				//Se debe liquidar los locales correspondientes a esta cuenta
				def locales = listaLocales.findAll { it.cuenta.id == cuenta.id && it.provincia.id == provincia.id}

				locales.each{
					if(it.porcentajeIIBB!=null){
						def liquidacionLocal = new LiquidacionIIBBLocal()
						liquidacionLocal.local = it
						liquidacionLocal.porcentajeLocal = it.porcentajeIIBB
						liquidacionLocal.saldoDdjj = ((liquidacion.saldoDdjj * it.porcentajeIIBB)/100).round(2)

						liquidacion.addToLiquidacionlocales(liquidacionLocal)
					}
				}

				liquidacion.ultimaModificacion = new LocalDateTime()
				liquidacion.ultimoModificador = currentUser.username

				liquidacion.save(flush:true)

				resultado.push(liquidacion)
			}
		}

		return resultado
	}

	def enviarNotificaciones(String cuentas, String mes, String ano){
		enviarNotificaciones(new LiquidacionIvaMasivaCommand(mes:mes,ano:ano,cuentasIds:cuentas))
	}

	def enviarNotificaciones(LiquidacionIvaMasivaCommand command){
		def fecha = new LocalDate(command.ano + '-' + command.mes + '-01')
		Estado estadoNotificado = Estado.findByNombre("Notificado")
		Estado estadoAutorizado = Estado.findByNombre("Autorizada")
		def cuentasIds = command.cuentasIds.split(',')

		def resultado = []

		def liquidaciones = LiquidacionIIBB.findAllByFecha(fecha)

		cuentasIds.each{
			def cuenta = Cuenta.get(it)
			def usuario = User.findByCuenta(cuenta)

			def liquidacionesIIBB = liquidaciones.findAll { it.cuenta.id == cuenta.id}

			if(liquidacionesIIBB.size()>0 && ! liquidacionesIIBB.find{it.estado.with{nombre == "Autorizada" || nombre == "Presentada"}}){
				def fechaVencimiento
				def saldoDdjj = 0
				def saf = 0

				liquidacionesIIBB.each {
					fechaVencimiento = it.fechaVencimiento
					saldoDdjj = (it.saldoDdjj+saldoDdjj).round(2)
					saf = (it.saldoAFavor+saf).round(2)
				}

				if(fechaVencimiento==null)
					fechaVencimiento = VencimientoDeclaracion.findAllByMesPeriodoAndTipoImpuesto(new Integer(command.mes), (cuenta.esConvenio ? "Convenio" : "IIBB")).find{ it.cuitAplica(cuenta.cuit) }?.fechaVencimiento


				String nombreUsuario = ""
				if(cuenta!=null){
					nombreUsuario = (cuenta.nombreApellido.split(' '))[0]
				}

				String urlNotificaciones = usuarioService.getLinkDesactivarNotificaciones(usuario)
				String urlLinkAutorizacionLiquidaciones = grailsApplication.config.getProperty('grails.serverURL') + grailsLinkGenerator.link(controller: 'notificacion', action: 'autorizarLiquidaciones', absolute: false, params:['uId': usuario.id, 'cId': cuenta.id, 'ano': command.ano, 'mes':command.mes, 'iva':false])

				String valorIIBB = ""
				String fechaVencimientoIIBB = ""
				if((saf>=0)&&(saldoDdjj==0)){
					valorIIBB = "Saldo a Favor \$" + formatear(saf)
				}else{
					valorIIBB = "\$ " + formatear(saldoDdjj)
				}

				fechaVencimientoIIBB = fechaVencimiento.toString("dd/MM/YYYY")

				def currentUser = accessRulesService.getCurrentUser()
				def ahora = new LocalDateTime()
				boolean autorizar = cuenta.with{maximoAutorizarIIBB != null && maximoAutorizarIIBB >= saldoDdjj}
				liquidacionesIIBB.each {
					it.ultimaModificacion = ahora
					it.ultimoModificador = currentUser.username
					it.estado = autorizar ? estadoAutorizado : estadoNotificado
					it.notificado = true
					it.fechaHoraNotificacion = ahora
					it.save(flush:true)

					resultado.push(it)
				}
				if (autorizar)
					autorizarMes(cuenta.id, command.mes, command.ano)
				else{
					NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Liquidacion Lista IIBB")
					String bodyMail = plantilla.llenarVariablesBody([nombreUsuario,valorIIBB,fechaVencimientoIIBB,urlLinkAutorizacionLiquidaciones,urlNotificaciones])
					notificacionService.enviarEmail(usuario.username, plantilla.asuntoEmail, bodyMail, 'notificacionIIBB', null, plantilla.tituloApp, plantilla.textoApp)
				}
			}
		}

		return resultado
	}

	def liquidacionAutomatica(String mes, String ano, Long cuentaId, distribucionMercadoLibre = null){
		def salida = []
		def estadoBorrado = Estado.findByNombre('Borrado')
		def estadoActivo = Estado.findByNombre('Activo')
		def estadoAutomatico = Estado.findByNombre('Automatico')
		def fecha = new LocalDate(ano + '-' + mes + '-01')
		def anoIIBB = new LocalDate(ano + '-01-01')
		def fechaAnterior = fecha.minusMonths(1)
		def fechaSiguiente = fecha.plusMonths(1)
		def currentUser = accessRulesService.getCurrentUser()

		def cuenta = Cuenta.get(cuentaId)

		Double baseImponible = new Double(0)
		Double sumatoriaNuevasProvincias = new Double(0)
		Double montoProvinciaNoIdentificada = new Double(0)

		def liquidaciones = LiquidacionIIBB.findAllByCuentaAndFecha(cuenta,fecha)
		if (liquidaciones.find{it.estado.nombre.with{it == "Autorizada" || it == "Presentada"}})
			return
		liquidaciones*.delete(flush:true, failOnError:true)
		PorcentajeProvinciaIIBB.findAllByCuentaAndPeriodoCreacion(cuenta,fecha)*.delete(flush:true, failOnError:true)
		def porcentajesProvincia = cuenta.porcentajesProvinciaIIBBActivos

		def montosProvincia = [:]
		def diferencias = [:]
		boolean saldoNoIdentificadoInsuficiente = false
		def alicuotasGenerales = AlicuotaGeneralProvinciaIIBB.findAllByAno(new Integer(ano))
		def nuevasProvincias = []
		if (cuenta.tenantId == 1)
			baseImponible = (LiquidacionIva.findByFechaAndCuenta(fecha, cuenta)?.netoVenta ?: 0)
		else{
			// Obtengo la sumatoria de todas las provincias:
			facturaVentaService.listFacturaVenta(mes, ano, cuentaId).each{
				if (it.tipoComprobante.letra != 'E'){
					String prov = it.cliente.provincia?.nombre
					Double montoFactura = it.montoLiquidable
					if (prov){
						montosProvincia[prov] = (montosProvincia[prov] ?: 0) + montoFactura
						sumatoriaNuevasProvincias += montoFactura
					}
					else 
						montoProvinciaNoIdentificada += montoFactura
				}
			}
			if (cuenta.regimenIibb.nombre == "Convenio Multilateral"){
				// Para la las provincias que NO son por asignación directa, agrupo el monto en la base imponible y las borro del map.
				porcentajesProvincia.each{
					if (it.porcentaje > 0){
						Double monto = montosProvincia[it.provincia.nombre] ?: 0
						baseImponible += monto
						sumatoriaNuevasProvincias -= monto
						montosProvincia.remove(it.provincia.nombre)
					}else if (! montosProvincia[it.provincia.nombre]) // Inicializo en 0 aquellas provincias de asignación directa para las que NO encontré facturas este mes.
						montosProvincia[it.provincia.nombre] = new Double(0)
				}
				montosProvincia.each{ monto -> // A las provincias de asignacion directa que se generaron este mes, les creo un porcentaje provincia y lo guardo
					if (!porcentajesProvincia.find{it.provincia.nombre == monto.key}){
						nuevasProvincias << monto.key
						porcentajesProvincia << new PorcentajeProvinciaIIBB(periodoCreacion:fecha, provincia: Provincia.findByNombre(monto.key), porcentaje: 0, tenantId: cuenta.tenantId,
													ultimoModificador:'Selenium', ultimaModificacion: new LocalDateTime(), estado: estadoActivo, cuenta:cuenta).save(flush:true)
					}
				}
				if (distribucionMercadoLibre){
					// println " \n"*3
					// println "baseImponible: $baseImponible"
					// println "sumatoriaNuevasProvincias: $sumatoriaNuevasProvincias"
					// println "\nmontosProvincia:"
					// montosProvincia*.with{println "	\$$value  	-	$key"}
					// println "\nporcentajesProvincia:"
					// porcentajesProvincia*.with{println "	$porcentaje%	-	$provincia"}
					// println "\ndistribucionMercadoLibre:"
					// distribucionMercadoLibre*.with{println "	\$$value  	-	$key"}
					// Si se importó el excel de MercadoLibre, utilizo esos montos para corregir este cálculo.
					diferencias['baseImponible'] = new Double(0)
					distribucionMercadoLibre.each{
						String prov = it.key
						PorcentajeProvinciaIIBB porcentajePro = porcentajesProvincia.find{it.provincia.nombre == prov}
						if (porcentajePro){ // La provincia de MercadoLibre existe en la lista, así que calculo la diferencia.
							if (! porcentajePro.porcentaje){
								Double diferencia = (it.value - montosProvincia[prov]).round(2)
								if (diferencia > 0) // Cómo no queremos tener diferencias negativas, si facturamos más de lo esperado no realizamos ninguna corrección.
									diferencias[prov] = diferencia
							}else // Agrupo en un solo elemento todas las provincias que no son directas
								diferencias['baseImponible'] += it.value
						}else if (it.value > 0){ // Si la provincia de MercadoLibre no existe en la lista es porque no detectamos facturas de ella. La agregamos a la lista y marcamos que lo vendido es la diferencia.
							porcentajesProvincia << new PorcentajeProvinciaIIBB(periodoCreacion:fecha, provincia: Provincia.findByNombre(prov), porcentaje: 0, tenantId: cuenta.tenantId,
														ultimoModificador:'Selenium', ultimaModificacion: new LocalDateTime(), estado: estadoActivo, cuenta:cuenta).save(flush:true)
							montosProvincia[prov] = new Double(0)
							nuevasProvincias << prov
							diferencias[prov] = it.value
						}
					}
					Double diferenciaBaseImponible = diferencias['baseImponible'] - baseImponible
					diferencias['baseImponible'] = diferenciaBaseImponible > 0 ? diferenciaBaseImponible : 0
					Double diferenciaTotal = diferencias*.value.sum()
					// println "\ndiferenciaTotal: $diferenciaTotal"
					// println "montoProvinciaNoIdentificada: $montoProvinciaNoIdentificada"
					// println "\ndiferencias:"
					// diferencias*.with{println "	\$$value  	-	$key"}
					if (diferenciaTotal <= montoProvinciaNoIdentificada){ // En caso de que el saldo disponible me alcance para cancelar todas las diferencias, hago eso mismo
						baseImponible += diferencias['baseImponible']
						diferencias.remove("baseImponible")
						diferencias.each{
							montosProvincia[it.key] += it.value
							sumatoriaNuevasProvincias += it.value
						}
						montoProvinciaNoIdentificada -= diferenciaTotal
						if (montoProvinciaNoIdentificada){ // Por si sobró algo
							if (porcentajesProvincia.find{it.porcentaje}) // Si existen porcentajes de distrubición, el sobrante va a la base imponible.
								baseImponible += montoProvinciaNoIdentificada
							else{ // Si sólo trabajamos provincias con asignación directa, mandamos todo el sobrante a la provincia Sede.
								sumatoriaNuevasProvincias += montoProvinciaNoIdentificada
								montosProvincia[cuenta.provincia.nombre] += montoProvinciaNoIdentificada
							}
						}
					}else{ // Si no me alcanza para cancelar todas las diferencias, distribuyo ponderadamente mi saldo disponible
						// La cuenta realizada (vendido / totalVendido * montoDisp) primero obtiene el porcentaje de la venta total representada en esta provincia, y luego lo aplica a mi disponible.
						saldoNoIdentificadoInsuficiente = true
						baseImponible += ((diferencias['baseImponible'] / diferenciaTotal) * montoProvinciaNoIdentificada).round(2)
						diferencias.remove("baseImponible")
						diferencias.each{
							Double diferenciaPonderada = ((it.value / diferenciaTotal) * montoProvinciaNoIdentificada).round(2)
							montosProvincia[it.key] += diferenciaPonderada
							sumatoriaNuevasProvincias += diferenciaPonderada
						}
					}

					// println "baseImponibleFinal: $baseImponible"
					// println "sumatoriaNuevasProvinciasFinal: $sumatoriaNuevasProvincias"
					// println "\nmontosProvinciaFinal:"
					// montosProvincia*.with{println "	\$$value  	-	$key"}
				}else{
					// Si no se importó MercadoLibre, vuelco en la jurisdiccion Sede aquellas facturas de las cuales no pude obtener la provincia.
					Provincia sede = cuenta.provincia
					if (porcentajesProvincia.find{it.provincia == sede && it.porcentaje}) // Si existe un porcentaje para la provincia sede, se manda a la base imponible general
						baseImponible += montoProvinciaNoIdentificada
					else{
						montosProvincia[sede.nombre] += montoProvinciaNoIdentificada
						sumatoriaNuevasProvincias += montoProvinciaNoIdentificada
					}
				}
			}else{
				// Si no es convenio, no nos importa en qué provincias facturó. Juntamos todo en una sola variable.
				baseImponible += sumatoriaNuevasProvincias + montoProvinciaNoIdentificada
				montosProvincia.clear()
			}
		}
		baseImponible = baseImponible.round(2)
		sumatoriaNuevasProvincias = sumatoriaNuevasProvincias.round(2)

		//Se debe hacer una liquidacion por provincia
		porcentajesProvincia.each{
			Provincia provincia = it.provincia
			def porcentajeProvincia = it.porcentaje

			def liquidacionAnterior = LiquidacionIIBB.findByFechaAndCuentaAndProvincia(fechaAnterior, cuenta, provincia)

			def liquidacion = new LiquidacionIIBB()
			liquidacion.cuenta = cuenta
			liquidacion.provincia = provincia
			liquidacion.nuevaProvincia = nuevasProvincias.contains(provincia.nombre)

			liquidacion.fecha = fecha

			def percepcionRetencion = retencionPercepcionService.calcularRetencionPercepcionSumatoria(cuentaId, mes, ano, false, provincia)
			liquidacion.percepcion = percepcionRetencion[2]
			liquidacion.retencion = percepcionRetencion[0]
			liquidacion.sircreb = percepcionRetencion[1]
			liquidacion.saldoAFavorPeriodoAnterior = liquidacionAnterior?.saldoAFavor ?: 0

			if (montosProvincia[it.provincia.nombre] == null){
				liquidacion.netoTotal =  baseImponible
				liquidacion.neto = (baseImponible * porcentajeProvincia / 100).round(2)
			}else{
				liquidacion.netoTotal = sumatoriaNuevasProvincias
				liquidacion.neto = montosProvincia[it.provincia.nombre].round(2)
			}
			liquidacion.porcentajeProvincia = porcentajeProvincia
			liquidacion.diferenciaNetoCalculado = diferencias[it.provincia.nombre]
			if(saldoNoIdentificadoInsuficiente){
				liquidacion.masFacturadoQueVendido = liquidacion.neto > distribucionMercadoLibre[liquidacion.provincia.nombre]
				liquidacion.saldoNoIdentificadoInsuficiente = ! liquidacion.masFacturadoQueVendido
			}

			if(liquidacion.alicuotas!=null){
				liquidacion.alicuotas.clear()
				liquidacion.save(flush:true, failOnError:true)
			}

			def impuesto = 0

			if (cuenta.tenantId == 2)
				cuenta.porcentajesActividadIIBB.each{
					def porcentajeActividad = it
					if(it.estado==estadoActivo){
						def alicuota = new LiquidacionIIBBAlicuota()
						//Buscar la alicuota que corresponda
						alicuota.actividad = porcentajeActividad.actividad
						def actividad = Actividad.get(porcentajeActividad.actividad.id)
						def alicuotaActividadIIBB = actividad.alicuotasActividadIIBB.find{ ali ->
							ali.provincia==provincia && ali.fecha==anoIIBB && (ali.baseImponibleDesde==null || ali.baseImponibleDesde <= liquidacion.neto) && (ali.baseImponibleHasta==null || ali.baseImponibleHasta >= liquidacion.neto)
						}?.valor ?: 0
						liquidacion.alicuotaGeneral = ! alicuotaActividadIIBB
						if (liquidacion.alicuotaGeneral)
							alicuotaActividadIIBB = alicuotasGenerales.find{it.provincia == provincia}.valor

						alicuota.alicuota = alicuotaActividadIIBB
						alicuota.porcentaje = porcentajeActividad.porcentaje

						alicuota.baseImponible = (liquidacion.neto * porcentajeActividad.porcentaje / 100).round(2)
						alicuota.impuesto = (alicuota.baseImponible * alicuota.alicuota / 100).round(2)

						impuesto = (impuesto + alicuota.impuesto).round(2)

						liquidacion.addToAlicuotas(alicuota)
					}
				}
			else
				cuenta.alicuotasIIBB.each{
					if((it.provincia==provincia)&&(it.estado==estadoActivo)){
						def alicuota = new LiquidacionIIBBAlicuota()
						alicuota.alicuota = it.valor
						alicuota.porcentaje = it.porcentaje

						alicuota.baseImponible = (liquidacion.neto * it.porcentaje / 100).round(2)
						alicuota.impuesto = (alicuota.baseImponible * alicuota.alicuota / 100).round(2)

						impuesto = (impuesto + alicuota.impuesto).round(2)

						liquidacion.addToAlicuotas(alicuota)
					}
				}
			liquidacion.impuesto = impuesto

			liquidacion.saldoDdjj = (liquidacion.impuesto - liquidacion.percepcion - liquidacion.retencion - liquidacion.sircreb - liquidacion.saldoAFavorPeriodoAnterior).round(2)
			if(liquidacion.saldoDdjj < 0){
				liquidacion.saldoAFavor = liquidacion.saldoDdjj * -1
				liquidacion.saldoDdjj = 0
			}else{
				liquidacion.saldoAFavor = 0
			}

			if (cuenta.tenantId == 1){ //Se debe liquidar los locales correspondientes a esta cuenta
				if(liquidacion.liquidacionlocales!=null){
					liquidacion.liquidacionlocales.clear()
					liquidacion.save(flush:true, failOnError:false)
				}
				Local.findAllByCuentaAndProvinciaAndEstado(cuenta, provincia, estadoActivo).each{
					if(it.porcentajeIIBB!=null){
						def liquidacionLocal = new LiquidacionIIBBLocal()
						liquidacionLocal.local = it
						liquidacionLocal.porcentajeLocal = it.porcentajeIIBB
						liquidacionLocal.saldoDdjj = ((liquidacion.saldoDdjj * it.porcentajeIIBB)/100).round(2)

						liquidacion.addToLiquidacionlocales(liquidacionLocal)
					}
				}
			}

			liquidacion.estado = estadoAutomatico
			liquidacion.ultimaModificacion = new LocalDateTime()
			liquidacion.ultimoModificador = currentUser?.username ?: "Selenium"

			liquidacion.save(flush:true, failOnError:true)
			salida << liquidacion
		}
		return salida
	}

	def liquidacionIIBBImportado(String cuit, String ano, String mes, Double saldoDdjj, Double alicuota1, Double base1, Double alicuota2, Double base2, Double retencion, Double safa){
		def estadoActivo = Estado.findByNombre('Activo')
		def fecha = new LocalDate(ano + '-' + mes + '-01')
		def fechaAnterior = fecha.minusMonths(1)

		def cuenta = Cuenta.findByCuit(cuit)
		def provincias = getProvinciasDeCuenta(cuenta)

		def resultado = []

		provincias.each {
			def provincia = it
			LiquidacionIIBB liquidacionAnterior = LiquidacionIIBB.findByCuentaAndFechaAndProvincia(cuenta, fechaAnterior, provincia)
			LiquidacionIIBB liquidacion = LiquidacionIIBB.findByCuentaAndFechaAndProvincia(cuenta, fecha, provincia)
			LiquidacionIva liquidacionIva = LiquidacionIva.findByCuentaAndFecha(cuenta, fecha)

			if(liquidacion==null){
				liquidacion = new LiquidacionIIBB()
			}

			liquidacion.retencion = retencion
			liquidacion.percepcion = 0
			liquidacion.sircreb = 0
			liquidacion.cuenta = cuenta
			liquidacion.provincia = provincia

			liquidacion.fecha = fecha

			//En el caso que no tenga hecha la liquidación de IVA toma $0
			liquidacion.netoTotal = liquidacionIva?.netoVenta ?: 0

			//Tengo que tomar el % de IIBB que le corresponde a esta provincia
			//desde la configuracion de la cuenta
			def porcentajeProvinciaIIBB = 100
			cuenta.porcentajesProvinciaIIBB.each{
				if((it.provincia==provincia)&&(it.estado==estadoActivo)){
					porcentajeProvinciaIIBB = it.porcentaje
				}
			}
			liquidacion.porcentajeProvincia = porcentajeProvinciaIIBB
			liquidacion.neto = (liquidacion.porcentajeProvincia * liquidacion.netoTotal / 100).round(2)

			//Tengo que calcular el impuesto, tomo las alicuotas IIBB de la cuenta
			if(liquidacion.alicuotas!=null){
				liquidacion.alicuotas.clear()
				liquidacion.save(flush:true)
			}

			def impuesto = 0
			def porcentaje1 = 100
			def porcentaje2 = 100
			if( (alicuota1!=0) && (alicuota2!=0)){
				if(liquidacion.neto!=0){
					porcentaje1 = ((base1 * 100) / liquidacion.neto).round(2)
					porcentaje2 = ((base2 * 100) / liquidacion.neto).round(2)
				}
			}

			if(alicuota1!=0){
				def alicuota = new LiquidacionIIBBAlicuota()
				alicuota.alicuota = alicuota1
				alicuota.porcentaje = porcentaje1

				alicuota.baseImponible = (liquidacion.neto * porcentaje1 / 100).round(2)
				alicuota.impuesto = (alicuota.baseImponible * alicuota.alicuota / 100).round(2)

				impuesto = (impuesto + alicuota.impuesto).round(2)

				liquidacion.addToAlicuotas(alicuota)
			}

			if(alicuota2!=0){
				def alicuota = new LiquidacionIIBBAlicuota()
				alicuota.alicuota = alicuota2
				alicuota.porcentaje = porcentaje2

				alicuota.baseImponible = (liquidacion.neto * porcentaje1 / 100).round(2)
				alicuota.impuesto = (alicuota.baseImponible * alicuota.alicuota / 100).round(2)

				impuesto = (impuesto + alicuota.impuesto).round(2)

				liquidacion.addToAlicuotas(alicuota)
			}

			liquidacion.impuesto = impuesto

			liquidacion.saldoAFavorPeriodoAnterior = safa

			if(saldoDdjj>=0){
				liquidacion.saldoAFavor = 0
				liquidacion.saldoDdjj = saldoDdjj
			}else{
				liquidacion.saldoAFavor = (saldoDdjj * -1).round(2)
				liquidacion.saldoDdjj = 0
			}

			liquidacion.percepcion = (liquidacion.impuesto - liquidacion.saldoDdjj - liquidacion.retencion - liquidacion.sircreb - liquidacion.saldoAFavorPeriodoAnterior).round(2)

			liquidacion.estado = Estado.findByNombre('Importado')
			liquidacion.save(flush:true)

			if(liquidacion.liquidacionlocales!=null){
				liquidacion.liquidacionlocales.clear()
				liquidacion.save(flush:true)
			}

			//Se debe liquidar los locales correspondientes a esta cuenta
			def locales = Local.findAllByCuentaAndProvinciaAndEstado(cuenta, provincia, estadoActivo)

			locales.each{
				if(it.porcentajeIIBB!=null){
					def liquidacionLocal = new LiquidacionIIBBLocal()
					liquidacionLocal.local = it
					liquidacionLocal.porcentajeLocal = it.porcentajeIIBB
					liquidacionLocal.saldoDdjj = ((liquidacion.saldoDdjj * it.porcentajeIIBB)/100).round(2)

					liquidacion.addToLiquidacionlocales(liquidacionLocal)
				}
			}

			liquidacion.save(flush:true)

			def currentUser = accessRulesService.getCurrentUser()
			liquidacion.ultimaModificacion = new LocalDateTime()
			liquidacion.ultimoModificador = "excel"

			liquidacion.save(flush:true)

			resultado.push(liquidacion)
		}

		return resultado
	}

	def getCantidadLiquidacionIIBBsTotales(){
		return LiquidacionIIBB.count()
	}

	def getLiquidacionIIBBAlicuotas(LiquidacionIIBBCommand command){
		def cuenta = Cuenta.get(command.cuentaId)
		def provincia = Provincia.get(command.provinciaId)
		def estadoActivo = Estado.findByNombre('Activo')
		command.neto = command.neto ?: 0
		def liquidacion = LiquidacionIIBB.get(command.liquidacionIIBBId)

		def salida = []

		if(liquidacion==null){
			if(cuenta!=null){
				cuenta.alicuotasIIBB.each{
					if((it.provincia==provincia)&&(it.estado==estadoActivo)){
						def liquidacionIIBBAlicuota = new LiquidacionIIBBAlicuota()

						liquidacionIIBBAlicuota.alicuota = it.valor
						liquidacionIIBBAlicuota.porcentaje = it.porcentaje

						if(command.neto!=null){
							liquidacionIIBBAlicuota.baseImponible = (command.neto * it.porcentaje / 100).round(2)
							liquidacionIIBBAlicuota.impuesto = (liquidacionIIBBAlicuota.baseImponible * it.valor /100).round(2)
						}else{
							liquidacionIIBBAlicuota.baseImponible = new Double('0')
							liquidacionIIBBAlicuota.impuesto = new Double('0')
						}

						salida.push(liquidacionIIBBAlicuota)
					}
				}
				cuenta.porcentajesActividadIIBB.findAll{it.estado.nombre == 'Activo'}.each{
					def liquidacionIIBBAlicuota = new LiquidacionIIBBAlicuota()
					def valor = it.actividad.alicuotasActividadIIBB.findAll{it.provincia == provincia}?.find{it.netoAplica(command.neto)}?.valor ?: 0
					liquidacionIIBBAlicuota.alicuota = valor
					liquidacionIIBBAlicuota.porcentaje = it.porcentaje

					liquidacionIIBBAlicuota.baseImponible = (command.neto * it.porcentaje / 100).round(2)
					liquidacionIIBBAlicuota.impuesto = (liquidacionIIBBAlicuota.baseImponible * valor /100).round(2)

					salida.push(liquidacionIIBBAlicuota)
				}
			}
		}else{
			liquidacion.alicuotas.each{
				salida.push(it)
			}
		}

		return salida
	}

	def obtenerSumaTotal(ArrayList liquidaciones){
		def sumaTotal = 0
		for(LiquidacionIIBB liq in liquidaciones){
			sumaTotal+=liq.saldoDdjj
		}
		return sumaTotal
	}

	def autorizarMes(Long cuentaId, String mes, String ano){ //Devuelve una lista con las declaraciones pendientes que se pudieron hacer
		Estado estadoAutorizado = Estado.findByNombre('Autorizada')
		def declaraciones = []
		def liquidacionesBuscadas = getLiquidacionesIIBBPorCuentaYFecha(cuentaId, ano, mes)
		liquidacionesBuscadas.each{
			if(it.estadoUsuario == "Liquidado"){
				it.estado = estadoAutorizado
				it.save(flush:true)

				declaraciones.push(declaracionJuradaService.saveDeclaracionJuradaPendientePorLiquidacionIibb(it))
			}
		}
		return declaraciones 
	}

	def pasarDatos(origen, destino){ //No hacer saves acá porque es llamada de otro service
		//Instrucciones independientes de command o Instance:
			destino.netoTotal = origen.netoTotal
			destino.porcentajeProvincia = origen.porcentajeProvincia

			destino.neto = origen.neto
			destino.impuesto = origen.impuesto

			destino.retencion = origen.retencion
			destino.percepcion = origen.percepcion
			destino.sircreb = origen.sircreb

			destino.saldoAFavorPeriodoAnterior = origen.saldoAFavorPeriodoAnterior
			destino.saldoAFavor = origen.saldoAFavor

			destino.saldoDdjj = origen.saldoDdjj

			destino.nota = origen.nota

			destino.fechaVencimiento = origen. fechaVencimiento

		if (destino instanceof LiquidacionIIBBCommand){ // Instrucciones sólo para el getCommand
			destino.liquidacionIIBBId = origen.id
			destino.version = origen.version
			destino.cuentaId = origen.cuenta?.id
			destino.provinciaId = origen.provincia?.id
			destino.mes = origen.fecha.toString("MM")
			destino.ano = origen.fecha.toString("YYYY")
			if (! ['Presentada','Autorizada'].contains(origen.estado?.nombre))
				destino.estadoId = Estado.findByNombre("Liquidado").id
			else
				destino.estadoId = origen.estado.id
			def listaRetPerBanc = retencionPercepcionService.calcularRetencionPercepcionSumatoria(destino.cuentaId, destino.mes, destino.ano, false)
			destino.retencionSumatoria = listaRetPerBanc[0]
			destino.bancariaSumatoria = listaRetPerBanc[1]
			destino.percepcionSumatoria = listaRetPerBanc[2]
		}else{ // Instrucciones para pasar a un Instance
			if (!(destino.id)){ // Instrucciones sólo para el create
				destino.cuenta = Cuenta.get(origen.cuentaId)
				destino.provincia = Provincia.get(origen.provinciaId)
				destino.fecha = new LocalDate(origen.ano + '-' + origen.mes + '-01')
			}else{ // Instrucciones sólo para el update
				destino.alicuotas.clear()
				destino.liquidacionlocales.clear()
			}
			destino.estado = Estado.get(origen.estadoId)

			if(origen.alicuotas){
				new JsonSlurper().parseText(origen.alicuotas).each{
					def alicuota = new LiquidacionIIBBAlicuota()
					alicuota.baseImponible = new Double(it.baseImponible.replace(".", "").replace(",", "."))
					alicuota.impuesto = new Double(it.impuesto.replace(".", "").replace(",", "."))
					alicuota.alicuota = new Double(it.alicuota.replace(".", "").replace(",", "."))
					alicuota.porcentaje = new Double(it.porcentaje.replace(".", "").replace(",", "."))

					destino.addToAlicuotas(alicuota)
				}
			}

			def locales = destino.cuenta?.locales.findAll{ it.porcentajeIIBB != null && it.provincia == destino.provincia && it.estado.id == Estado.findByNombre('Activo').id}
			if (locales)
				locales.each{
					def liquidacionLocal = new LiquidacionIIBBLocal()
					liquidacionLocal.local = it
					liquidacionLocal.porcentajeLocal = it.porcentajeIIBB
					liquidacionLocal.saldoDdjj = ((destino.saldoDdjj * it.porcentajeIIBB)/100).round(2)

					destino.addToLiquidacionlocales(liquidacionLocal)
				}

			destino.ultimaModificacion = new LocalDateTime()
			destino.ultimoModificador = accessRulesService.getCurrentUser().username
		}

		return destino
	}

	def getLiquidacionesUnificadas(Long cuentaId, String ano){
		def cuentaInstance = Cuenta.get(cuentaId)
		def salida = []

		def mes = new LocalDate(ano + '-01-01')
		Estado estadoSinLiquidar = Estado.findByNombre('Sin liquidar')
		def liquidacionesDeCuenta = LiquidacionIIBB.createCriteria().list(){
			and{
				eq('cuenta', cuentaInstance)
				ge('fecha', mes)
				le('fecha', mes.plusMonths(12))
			}
		}
		for(i in 0..11){
			def liquidaciones = liquidacionesDeCuenta.findAll { it.fecha == mes}
			salida << new LiquidacionIIBB().with{
				cuenta = cuentaInstance
				fecha = mes
				estado = liquidaciones ? liquidaciones[0].estado : estadoSinLiquidar
				nota = liquidaciones ? liquidaciones[0].nota : ""
				saldoDdjj = liquidaciones ? liquidaciones.sum{liquidacion -> liquidacion.saldoDdjj} : 0
				return it
			}
			mes = mes.plusMonths(1)
		}
		return salida
	}

	def listSinAlicuota(LocalDate mes){
		return LiquidacionIIBB.findAllByFechaAndAlicuotaGeneral(mes,true)
	}
}