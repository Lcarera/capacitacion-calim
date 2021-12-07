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
import com.zifras.cuenta.CondicionIva
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.Local
import com.zifras.cuenta.RegimenIibb

import com.zifras.facturacion.FacturaCompra
import com.zifras.facturacion.FacturaCompraService
import com.zifras.facturacion.FacturaVenta
import com.zifras.facturacion.FacturaVentaService
import com.zifras.facturacion.TipoComprobante

import com.zifras.documento.DeclaracionJuradaService
import com.zifras.documento.VencimientoDeclaracion
import com.zifras.importacion.LogImportacion
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
class LiquidacionIvaService {
	AccessRulesService accessRulesService
	LinkGenerator grailsLinkGenerator
	SeleniumService seleniumService
	def declaracionJuradaService
	def facturaCompraService
	def facturaVentaService
	def grailsApplication
	def notificacionService
	def retencionPercepcionService
	def usuarioService

	def createLiquidacionIvaCommand(LiquidacionIvaCommand command){
		def currentUser = accessRulesService.getCurrentUser()

		if(command==null)
			command = new LiquidacionIvaCommand()

		command.estadoId = Estado.findByNombre('Liquidado').id

		command.saldoTecnicoAFavorPeriodoAnterior = 0
		command.saldoLibreDisponibilidadPeriodoAnterior = 0
		command.saldoLibreDisponibilidad = 0
		command.retencion = 0
		command.percepcion = 0

		//Si hay una cuenta seteada se busca si tiene una liquidación en el mes anterior
		if(command.cuentaId!=null){
			//Tiene que estar seteado el año y el mes
			if((command.ano!=null)&&(command.mes)){
				def fechaLiquidacion = new LocalDate(command.ano + '-' + command.mes + '-01')
				def fechaLiquidacionMesAnterior = fechaLiquidacion.minusMonths(1)

				def cuenta = Cuenta.get(command.cuentaId)
				command.fechaVencimiento = VencimientoDeclaracion.findAllByMesPeriodoAndTipoImpuesto(new Integer(command.mes), "IVA").find{ it.cuitAplica(cuenta.cuit) }?.fechaVencimiento
				LiquidacionIva liquidacionAnterior = LiquidacionIva.findByCuentaAndFecha(cuenta, fechaLiquidacionMesAnterior)

				if(liquidacionAnterior!=null){
					command.saldoTecnicoAFavorPeriodoAnterior = liquidacionAnterior.saldoTecnicoAFavor
					command.saldoLibreDisponibilidadPeriodoAnterior = liquidacionAnterior.saldoLibreDisponibilidad
				}
			}
		}
		command.porcentajeDebitoCredito = 0

		command.debitoFiscal = 0
		command.debitoFiscal21 = 0
		command.debitoFiscal10 = 0
		command.debitoFiscal27 = 0
		command.debitoFiscal2 = 0
		command.debitoFiscal5 = 0

		command.netoVenta = 0
		command.netoVenta21 = 0
		command.netoVenta27 = 0
		command.netoVenta10 = 0
		command.netoVenta2 = 0
		command.netoVenta5 = 0

		command.netoNoGravadoVenta = 0
		command.exentoVenta = 0

		command.totalVenta = 0
		command.totalVenta21 = 0
		command.totalVenta10 = 0
		command.totalVenta27 = 0
		command.totalVenta2 = 0
		command.totalVenta5 = 0

		command.totalNoGravadoVenta = 0
		command.totalExentoVenta = 0

		command.creditoFiscal = 0
		command.creditoFiscal21 = 0
		command.creditoFiscal27 = 0
		command.creditoFiscal10 = 0
		command.creditoFiscal2 = 0
		command.creditoFiscal5 = 0

		command.netoCompra = 0
		command.netoCompra21 = 0
		command.netoCompra27 = 0
		command.netoCompra10 = 0
		command.netoCompra2 = 0
		command.netoCompra5 = 0

		command.netoNoGravadoCompra = 0
		command.exentoCompra = 0

		command.totalCompra = 0
		command.totalCompra21 = 0
		command.totalCompra27 = 0
		command.totalCompra10 = 0
		command.totalCompra2 = 0
		command.totalCompra5 = 0

		command.totalNoGravadoCompra = 0
		command.totalExentoCompra = 0
		if (command.cuentaId!=null && command.ano != null && command.mes != null)
			command = verificarImportacion(command, Cuenta.get(command.cuentaId), new LocalDate(command.ano + '-' + command.mes + '-01'))
		return agregarSumatoriaImportaciones(command, true)
	}

	def listLiquidacionIva() {
		return LiquidacionIva.list()
	}

	def getLiquidacionIva(Long id){
		def liquidacionIvaInstance = LiquidacionIva.get(id)
	}

	def getLiquidacionIvaPorCuentaFecha(Long cuentaId, String ano, String mes){
		def fecha = new LocalDate(ano + "-" + mes + "-01")
		def cuenta = Cuenta.get(cuentaId)
		def liquidacionIvaInstance = LiquidacionIva.findByCuentaAndFecha(cuenta,fecha)
		if(liquidacionIvaInstance==null){
			liquidacionIvaInstance = new LiquidacionIva()
			def estadoSinLiquidar = Estado.findByNombre('Sin liquidar')
			liquidacionIvaInstance.estado = estadoSinLiquidar
			liquidacionIvaInstance.saldoDdjj = 0
		}
		return liquidacionIvaInstance
	}

	def getLiquidacionIvaCommand(Long id){
		LiquidacionIva liquidacionIvaInstance = LiquidacionIva.get(id)

		if(liquidacionIvaInstance!=null){
			def command = new LiquidacionIvaCommand()

			command.liquidacionIvaId = liquidacionIvaInstance.id
			command.version = liquidacionIvaInstance.version

			if(liquidacionIvaInstance.cuenta!=null)
				command.cuentaId = liquidacionIvaInstance.cuenta.id
			command.mes = liquidacionIvaInstance.fecha.toString("MM")
			command.ano = liquidacionIvaInstance.fecha.toString("YYYY")
			command.porcentajeDebitoCredito = liquidacionIvaInstance.porcentajeDebitoCredito

			command.fechaVencimiento = liquidacionIvaInstance.fechaVencimiento

			command.facturasA = liquidacionIvaInstance.facturasA
			command.facturasA21 = liquidacionIvaInstance.facturasA21
			command.facturasA10 = liquidacionIvaInstance.facturasA10
			command.facturasA27 = liquidacionIvaInstance.facturasA27
			command.facturasA2 = liquidacionIvaInstance.facturasA2
			command.facturasA5 = liquidacionIvaInstance.facturasA5

			command.noGravadoFacturasA = liquidacionIvaInstance.noGravadoFacturasA
			command.exentoFacturasA = liquidacionIvaInstance.exentoFacturasA

			command.otrasFacturas = liquidacionIvaInstance.otrasFacturas
			command.otrasFacturas21 = liquidacionIvaInstance.otrasFacturas21
			command.otrasFacturas10 = liquidacionIvaInstance.otrasFacturas10
			command.otrasFacturas27 = liquidacionIvaInstance.otrasFacturas27
			command.otrasFacturas2 = liquidacionIvaInstance.otrasFacturas2
			command.otrasFacturas5 = liquidacionIvaInstance.otrasFacturas5

			command.noGravadoOtrasFacturas = liquidacionIvaInstance.noGravadoOtrasFacturas
			command.exentoOtrasFacturas = liquidacionIvaInstance.exentoOtrasFacturas

			command.netoVenta = liquidacionIvaInstance.netoVenta
			command.netoVenta21 = liquidacionIvaInstance.netoVenta21
			command.netoVenta10 = liquidacionIvaInstance.netoVenta10
			command.netoVenta27 = liquidacionIvaInstance.netoVenta27
			command.netoVenta2 = liquidacionIvaInstance.netoVenta2
			command.netoVenta5 = liquidacionIvaInstance.netoVenta5

			command.netoNoGravadoVenta = liquidacionIvaInstance.netoNoGravadoVenta
			command.exentoVenta = liquidacionIvaInstance.exentoVenta

			command.debitoFiscal = liquidacionIvaInstance.debitoFiscal
			command.debitoFiscal21 = liquidacionIvaInstance.debitoFiscal21
			command.debitoFiscal10 = liquidacionIvaInstance.debitoFiscal10
			command.debitoFiscal27 = liquidacionIvaInstance.debitoFiscal27
			command.debitoFiscal2 = liquidacionIvaInstance.debitoFiscal2
			command.debitoFiscal5 = liquidacionIvaInstance.debitoFiscal5

			command.totalVenta = liquidacionIvaInstance.totalVenta
			command.totalVenta21 = liquidacionIvaInstance.totalVenta21
			command.totalVenta10 = liquidacionIvaInstance.totalVenta10
			command.totalVenta27 = liquidacionIvaInstance.totalVenta27
			command.totalVenta2 = liquidacionIvaInstance.totalVenta2
			command.totalVenta5 = liquidacionIvaInstance.totalVenta5

			command.totalNoGravadoVenta = liquidacionIvaInstance.totalNoGravadoVenta
			command.totalExentoVenta = liquidacionIvaInstance.totalExentoVenta

			command.netoCompra = liquidacionIvaInstance.netoCompra
			command.netoCompra21 = liquidacionIvaInstance.netoCompra21
			command.netoCompra10 = liquidacionIvaInstance.netoCompra10
			command.netoCompra27 = liquidacionIvaInstance.netoCompra27
			command.netoCompra2 = liquidacionIvaInstance.netoCompra2
			command.netoCompra5 = liquidacionIvaInstance.netoCompra5

			command.netoNoGravadoCompra = liquidacionIvaInstance.netoNoGravadoCompra
			command.exentoCompra = liquidacionIvaInstance.exentoCompra

			command.creditoFiscal = liquidacionIvaInstance.creditoFiscal
			command.creditoFiscal21 = liquidacionIvaInstance.creditoFiscal21
			command.creditoFiscal10 = liquidacionIvaInstance.creditoFiscal10
			command.creditoFiscal27 = liquidacionIvaInstance.creditoFiscal27
			command.creditoFiscal2 = liquidacionIvaInstance.creditoFiscal2
			command.creditoFiscal5 = liquidacionIvaInstance.creditoFiscal5

			command.totalCompra = liquidacionIvaInstance.totalCompra
			command.totalCompra21 = liquidacionIvaInstance.totalCompra21
			command.totalCompra10 = liquidacionIvaInstance.totalCompra10
			command.totalCompra27 = liquidacionIvaInstance.totalCompra27
			command.totalCompra2 = liquidacionIvaInstance.totalCompra2
			command.totalCompra5 = liquidacionIvaInstance.totalCompra5

			command.totalNoGravadoCompra = liquidacionIvaInstance.totalNoGravadoCompra
			command.totalExentoCompra = liquidacionIvaInstance.totalExentoCompra

			command.debitoMenosCredito = liquidacionIvaInstance.debitoMenosCredito
			command.saldoTecnicoAFavorPeriodoAnterior = liquidacionIvaInstance.saldoTecnicoAFavorPeriodoAnterior
			command.saldoTecnicoAFavor = liquidacionIvaInstance.saldoTecnicoAFavor
			command.saldoLibreDisponibilidadPeriodoAnterior = liquidacionIvaInstance.saldoLibreDisponibilidadPeriodoAnterior
			command.saldoLibreDisponibilidad = liquidacionIvaInstance.saldoLibreDisponibilidad
			command.retencion = liquidacionIvaInstance.retencion
			command.percepcion = liquidacionIvaInstance.percepcion

			command.saldoDdjj = liquidacionIvaInstance.saldoDdjj

			command.nota = liquidacionIvaInstance.nota

			command = verificarImportacion(command, liquidacionIvaInstance.cuenta, liquidacionIvaInstance.fecha)

			if (! ['Presentada','Autorizada'].contains(liquidacionIvaInstance.estado.nombre))
				command.estadoId = Estado.findByNombre("Liquidado").id
			else
				command.estadoId = liquidacionIvaInstance.estado.id

			return agregarSumatoriaImportaciones(command, ! ['Liquidado','Liquidado A','Liquidado A2','Presentada','Autorizada'].contains(liquidacionIvaInstance.estado.nombre))
		} else
			return null
	}

	def agregarSumatoriaImportaciones(LiquidacionIvaCommand command, Boolean pisarDatos){
		def negativo = 1
		//Obtengo la lista de facturas de compra y realizo la sumatoria
		facturaCompraService.listFacturaCompra(command.mes, command.ano, command.cuentaId).each{
			negativo = it.tipoComprobante.multiplicador

			command.netoNoGravadoCompraSumatoria += it.netoNoGravado * negativo
			command.exentoCompraSumatoria += it.exento * negativo
			if (it.tipoComprobante.letra != 'B'){
				command.creditoFiscalSumatoria += it.iva * negativo
				command.creditoFiscal21Sumatoria += it.iva21 * negativo
				command.creditoFiscal10Sumatoria += it.iva10 * negativo
				command.creditoFiscal27Sumatoria += it.iva27 * negativo
				command.creditoFiscal2Sumatoria += it.iva2 * negativo
				command.creditoFiscal5Sumatoria += it.iva5 * negativo

				command.netoCompra21Sumatoria += it.netoGravado21 * negativo
				command.netoCompra10Sumatoria += it.netoGravado10 * negativo
				command.netoCompra27Sumatoria += it.netoGravado27 * negativo
				command.netoCompra2Sumatoria += it.netoGravado2 * negativo
				command.netoCompra5Sumatoria += it.netoGravado5 * negativo
				command.netoCompraSumatoria += it.netoGravado * negativo
			}else
				command.netoNoGravadoCompraSumatoria += it.total * negativo // Porque netoGravado es la sumatoria de todos los demás netos.

			// if(it.percepcionImportada!=null)
			// 	command.percepcionImportadaSumatoria += it.percepcionImportada * negativo
		}
		command.netoCompraSumatoria =  (command.netoCompraSumatoria + command.netoNoGravadoCompraSumatoria + command.exentoCompraSumatoria)
		//Obtengo la lista de facturas de venta y realizo la sumatoria
		facturaVentaService.listFacturaVenta(command.mes, command.ano, command.cuentaId).each{
			def fact = it
			negativo = it.tipoComprobante.multiplicador

			command.netoVenta21Sumatoria += it.netoGravado21 * negativo
			command.netoVenta10Sumatoria += it.netoGravado10 * negativo
			command.netoVenta27Sumatoria += it.netoGravado27 * negativo
			command.netoVenta2Sumatoria += it.netoGravado2 * negativo
			command.netoVenta5Sumatoria += it.netoGravado5 * negativo
			command.netoVenta0Sumatoria += it.netoGravado0 * negativo

			command.netoNoGravadoVentaSumatoria += it.netoNoGravado * negativo
			command.exentoVentaSumatoria += it.exento * negativo

			if (['A','M'].contains(it.tipoComprobante.letra)){
				command.facturasASumatoria += it.neto * negativo
				command.facturasA21Sumatoria += it.netoGravado21 * negativo
				command.facturasA10Sumatoria += it.netoGravado10 * negativo
				command.facturasA27Sumatoria += it.netoGravado27 * negativo
				command.facturasA2Sumatoria += it.netoGravado2 * negativo
				command.facturasA5Sumatoria += it.netoGravado5 * negativo

				command.noGravadoFacturasASumatoria += it.netoNoGravado * negativo
				command.exentoFacturasASumatoria += it.exento * negativo
			}else{
				command.otrasFacturasSumatoria += it.neto * negativo
				command.otrasFacturas21Sumatoria += it.netoGravado21 * negativo
				command.otrasFacturas10Sumatoria += it.netoGravado10 * negativo
				command.otrasFacturas27Sumatoria += it.netoGravado27 * negativo
				command.otrasFacturas2Sumatoria += it.netoGravado2 * negativo
				command.otrasFacturas5Sumatoria += it.netoGravado5 * negativo

				command.noGravadoOtrasFacturasSumatoria += it.netoNoGravado * negativo
				command.exentoOtrasFacturasSumatoria += it.exento * negativo
			}

			command.debitoFiscalSumatoria += it.iva * negativo
			command.debitoFiscal21Sumatoria += it.iva21 * negativo
			command.debitoFiscal10Sumatoria += it.iva10 * negativo
			command.debitoFiscal27Sumatoria += it.iva27 * negativo
			command.debitoFiscal2Sumatoria += it.iva2 * negativo
			command.debitoFiscal5Sumatoria += it.iva5 * negativo
			command.debitoFiscal0Sumatoria += it.iva0 * negativo

			command.totalVentaSumatoria += it.total * negativo
			command.netoVentaSumatoria += it.neto * negativo

			command.importeOtrosTributosVentaSumatoria += it.importeOtrosTributos * negativo
		}
		// Obtengo la sumatoria de retenciones y percepciones
			def percepcionRetencion = retencionPercepcionService.calcularRetencionPercepcionSumatoria(command.cuentaId, command.mes, command.ano, true)
			command.percepcionImportadaSumatoria = percepcionRetencion[2]
			command.retencionImportadaSumatoria = percepcionRetencion[0] + percepcionRetencion[1]
		//Sumo los totales:
			command.totalCompra21Sumatoria = command.netoCompra21Sumatoria + command.creditoFiscal21Sumatoria
			command.totalCompra10Sumatoria = command.netoCompra10Sumatoria + command.creditoFiscal10Sumatoria
			command.totalCompra27Sumatoria = command.netoCompra27Sumatoria + command.creditoFiscal27Sumatoria
			command.totalCompra2Sumatoria = command.netoCompra2Sumatoria + command.creditoFiscal2Sumatoria
			command.totalCompra5Sumatoria = command.netoCompra5Sumatoria + command.creditoFiscal5Sumatoria

			command.totalNoGravadoCompraSumatoria = command.netoNoGravadoCompraSumatoria
			command.totalExentoCompraSumatoria = command.exentoCompraSumatoria

			command.totalCompraSumatoria = command.totalCompra21Sumatoria + command.totalCompra10Sumatoria + command.totalCompra27Sumatoria + command.totalCompra2Sumatoria + command.totalCompra5Sumatoria + command.totalNoGravadoCompraSumatoria + command.totalExentoCompraSumatoria

			command.totalNoGravadoVentaSumatoria = command.netoNoGravadoVentaSumatoria
			command.totalExentoVentaSumatoria = command.exentoVentaSumatoria

			command.totalVenta21Sumatoria = command.netoVenta21Sumatoria + command.debitoFiscal21Sumatoria
			command.totalVenta10Sumatoria = command.netoVenta10Sumatoria + command.debitoFiscal10Sumatoria
			command.totalVenta27Sumatoria = command.netoVenta27Sumatoria + command.debitoFiscal27Sumatoria
			command.totalVenta2Sumatoria = command.netoVenta2Sumatoria + command.debitoFiscal2Sumatoria
			command.totalVenta5Sumatoria = command.netoVenta5Sumatoria + command.debitoFiscal5Sumatoria
		//Piso los datos default
		if (pisarDatos){
			//Provisoriamente se pondrán acá solamente los que aparezcan en la vista.

			command.facturasA = command.facturasASumatoria
			command.facturasA21 = command.facturasA21Sumatoria
			command.facturasA10 = command.facturasA10Sumatoria
			command.facturasA27 = command.facturasA27Sumatoria
			command.facturasA2 = command.facturasA2Sumatoria
			command.facturasA5 = command.facturasA5Sumatoria
			command.noGravadoFacturasA = command.noGravadoFacturasASumatoria
			command.exentoFacturasA = command.exentoFacturasASumatoria

			command.otrasFacturas = command.otrasFacturasSumatoria
			command.otrasFacturas21 = command.otrasFacturas21Sumatoria
			command.otrasFacturas10 = command.otrasFacturas10Sumatoria
			command.otrasFacturas27 = command.otrasFacturas27Sumatoria
			command.otrasFacturas2 = command.otrasFacturas2Sumatoria
			command.otrasFacturas5 = command.otrasFacturas5Sumatoria
			command.noGravadoOtrasFacturas = command.noGravadoOtrasFacturasSumatoria
			command.exentoOtrasFacturas = command.exentoOtrasFacturasSumatoria

			command.netoVenta  = command.netoVentaSumatoria
			command.netoVenta21 = command.netoVenta21Sumatoria
			command.netoVenta10 = command.netoVenta10Sumatoria
			command.netoVenta27 = command.netoVenta27Sumatoria
			command.netoVenta2 = command.netoVenta2Sumatoria
			command.netoVenta5 = command.netoVenta5Sumatoria
			command.exentoVenta = command.exentoVentaSumatoria
			command.netoNoGravadoVenta = command.netoNoGravadoVentaSumatoria

			command.debitoFiscal = command.debitoFiscalSumatoria
			command.debitoFiscal21 = command.debitoFiscal21Sumatoria
			command.debitoFiscal10 = command.debitoFiscal10Sumatoria
			command.debitoFiscal27 = command.debitoFiscal27Sumatoria
			command.debitoFiscal2 = command.debitoFiscal2Sumatoria
			command.debitoFiscal5 = command.debitoFiscal5Sumatoria

			command.totalVenta = command.totalVentaSumatoria
			command.totalVenta21 = command.totalVenta21Sumatoria
			command.totalVenta10 = command.totalVenta10Sumatoria
			command.totalVenta27 = command.totalVenta27Sumatoria
			command.totalVenta2 = command.totalVenta2Sumatoria
			command.totalVenta5 = command.totalVenta5Sumatoria
			command.totalNoGravadoCompra = command.totalNoGravadoCompraSumatoria
			command.totalExentoCompra = command.totalExentoCompraSumatoria

			command.netoCompra = command.netoCompraSumatoria
			command.netoCompra21 = command.netoCompra21Sumatoria
			command.netoCompra10 = command.netoCompra10Sumatoria
			command.netoCompra27 = command.netoCompra27Sumatoria
			command.netoCompra2 = command.netoCompra2Sumatoria
			command.netoCompra5 = command.netoCompra5Sumatoria
			command.exentoCompra = command.exentoCompraSumatoria
			command.netoNoGravadoCompra = command.netoNoGravadoCompraSumatoria

			command.creditoFiscal = command.creditoFiscalSumatoria
			command.creditoFiscal21 = command.creditoFiscal21Sumatoria
			command.creditoFiscal10 = command.creditoFiscal10Sumatoria
			command.creditoFiscal27 = command.creditoFiscal27Sumatoria
			command.creditoFiscal2 = command.creditoFiscal2Sumatoria
			command.creditoFiscal5 = command.creditoFiscal5Sumatoria

			command.totalCompra = command.totalCompraSumatoria
			command.totalCompra21 = command.totalCompra21Sumatoria
			command.totalCompra10 = command.totalCompra10Sumatoria
			command.totalCompra27 = command.totalCompra27Sumatoria
			command.totalCompra2 = command.totalCompra2Sumatoria
			command.totalCompra5 = command.totalCompra5Sumatoria
			command.totalNoGravadoVenta = command.totalNoGravadoVentaSumatoria
			command.totalExentoVenta = command.totalExentoVentaSumatoria

			command.percepcion = command.percepcionImportadaSumatoria
			command.retencion = command.retencionImportadaSumatoria
		}
		command.pisarDatos = pisarDatos
		return command
	}

	def getLiquidacionIvaList(String mes, String ano) {
		CondicionIva condicionIva = CondicionIva.findByNombre('Responsable inscripto')
		Estado estadoBorrado = Estado.findByNombre('Borrado')
		Estado estadoSinLiquidar = Estado.findByNombre('Sin liquidar')
		def salida = []
		LocalDate fecha = new LocalDate(ano + '-' + mes + '-01')
		def liquidaciones = LiquidacionIva.findAllByFecha(fecha)

		Cuenta.createCriteria().list(sort: "razonSocial", order: "asc") {
			and{
				eq('condicionIva', condicionIva)
				ne('estado', estadoBorrado)
				if (accessRulesService.currentUser.userTenantId == 2)
					eq('etiqueta','Verde')
			}
		}.each{
			def cuenta = it
			def liquidacion = liquidaciones.find { it.cuenta.id == cuenta.id}
			if(liquidacion==null){
				liquidacion = new LiquidacionIva()
				liquidacion.cuenta = it
				liquidacion.fecha = fecha
				liquidacion =  verificarImportacion(liquidacion, cuenta, fecha)
				liquidacion.estado = estadoSinLiquidar

				cuenta.locales.each{
					def liquidacionLocal = new LiquidacionIvaLocal()
					liquidacionLocal.local = it
					liquidacionLocal.porcentajeLocal = it.porcentaje
					liquidacion.addToLiquidacionlocales(liquidacionLocal)
				}
			}

			salida.push(liquidacion)
		}

		return salida
	}

	def getLiquidacionesPorCuenta(Long cuentaId, String ano) {
		def cuenta = Cuenta.get(cuentaId)
		def salida = []
		def mes = new LocalDate(ano + '-01-01')
		def liquidaciones = LiquidacionIva.createCriteria().list(){
			and{
				eq('cuenta', cuenta)
				ge('fecha', mes)
				le('fecha', mes.plusMonths(12))
			}
		}

		def estadoSinLiquidar = Estado.findByNombre('Sin liquidar')

		def i
		for(i=0; i<12; i++){
			def lista = liquidaciones.findAll { it.fecha == mes}.each{
				salida.push(it)
			}
			if(! lista){
				def liquidacion = new LiquidacionIva()
				liquidacion.cuenta = cuenta
				liquidacion.fecha = mes
				liquidacion.estado = estadoSinLiquidar
				salida.push(liquidacion)
			}

			mes = mes.plusMonths(1)
		}

		return salida
	}

	def getLiquidacionPorCuitMes(String cuit, String mes, String ano) {
		def lista
		def cuenta = Cuenta.findByCuit(cuit)
		def salida = []

		def fecha = new LocalDate(ano + '-' + mes + '-01')

		def liquidacion = LiquidacionIva.findByCuentaAndFecha(cuenta, fecha)

		return liquidacion
	}

	def borrarLiquidacionIva(Long id){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionIva = LiquidacionIva.get(id)
		liquidacionIva.estado = estadoBorrado

		def currentUser = accessRulesService.getCurrentUser()
		liquidacionIva.ultimaModificacion = new LocalDateTime()
		liquidacionIva.ultimoModificador = currentUser.username
		liquidacionIva.save(flush:true)

		return liquidacionIva
	}

	def deleteLiquidacionIva(Long id){
		def liquidacionIvaInstance = LiquidacionIva.get(id)
		liquidacionIvaInstance.delete(flush:true, failOnError:true)
	}

	def deleteMesLiquidacionIva(String mes, String ano){
		def fecha = new LocalDate(ano + '-' + mes + '-01')

		def liquidaciones = LiquidacionIva.findAllByFecha(fecha)

		def cantidad = 0
		liquidaciones.each{
			it.delete(flush:true)
			cantidad++
		}

		return cantidad
	}

	def saveLiquidacionIva(LiquidacionIvaCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionIvaInstance = new LiquidacionIva()

		liquidacionIvaInstance.fecha = new LocalDate(command.ano + '-' + command.mes + '-01')
		liquidacionIvaInstance.porcentajeDebitoCredito = command.porcentajeDebitoCredito

		liquidacionIvaInstance.fechaVencimiento = command.fechaVencimiento

		liquidacionIvaInstance.facturasA = command.facturasA
		liquidacionIvaInstance.facturasA21 = command.facturasA21
		liquidacionIvaInstance.facturasA10 = command.facturasA10
		liquidacionIvaInstance.facturasA27 = command.facturasA27
		liquidacionIvaInstance.facturasA2 = command.facturasA2
		liquidacionIvaInstance.facturasA5 = command.facturasA5

		liquidacionIvaInstance.noGravadoFacturasA = command.noGravadoFacturasA
		liquidacionIvaInstance.exentoFacturasA = command.exentoFacturasA

		liquidacionIvaInstance.otrasFacturas = command.otrasFacturas
		liquidacionIvaInstance.otrasFacturas21 = command.otrasFacturas21
		liquidacionIvaInstance.otrasFacturas10 = command.otrasFacturas10
		liquidacionIvaInstance.otrasFacturas27 = command.otrasFacturas27
		liquidacionIvaInstance.otrasFacturas2 = command.otrasFacturas2
		liquidacionIvaInstance.otrasFacturas5 = command.otrasFacturas5

		liquidacionIvaInstance.noGravadoOtrasFacturas = command.noGravadoOtrasFacturas
		liquidacionIvaInstance.exentoOtrasFacturas = command.exentoOtrasFacturas

		liquidacionIvaInstance.netoVenta = command.netoVenta
		liquidacionIvaInstance.netoVenta21 = command.netoVenta21
		liquidacionIvaInstance.netoVenta10 = command.netoVenta10
		liquidacionIvaInstance.netoVenta27 = command.netoVenta27
		liquidacionIvaInstance.netoVenta2 = command.netoVenta2
		liquidacionIvaInstance.netoVenta5 = command.netoVenta5

		liquidacionIvaInstance.netoNoGravadoVenta = command.netoNoGravadoVenta
		liquidacionIvaInstance.exentoVenta = command.exentoVenta

		liquidacionIvaInstance.debitoFiscal = command.debitoFiscal
		liquidacionIvaInstance.debitoFiscal21 = command.debitoFiscal21
		liquidacionIvaInstance.debitoFiscal10 = command.debitoFiscal10
		liquidacionIvaInstance.debitoFiscal27 = command.debitoFiscal27
		liquidacionIvaInstance.debitoFiscal2 = command.debitoFiscal2
		liquidacionIvaInstance.debitoFiscal5 = command.debitoFiscal5

		liquidacionIvaInstance.totalVenta = command.totalVenta
		liquidacionIvaInstance.totalVenta21 = command.totalVenta21
		liquidacionIvaInstance.totalVenta10 = command.totalVenta10
		liquidacionIvaInstance.totalVenta27 = command.totalVenta27
		liquidacionIvaInstance.totalVenta2 = command.totalVenta2
		liquidacionIvaInstance.totalVenta5 = command.totalVenta5

		liquidacionIvaInstance.totalNoGravadoVenta = command.totalNoGravadoVenta
		liquidacionIvaInstance.totalExentoVenta = command.totalExentoVenta

		liquidacionIvaInstance.netoCompra = command.netoCompra
		liquidacionIvaInstance.netoCompra21 = command.netoCompra21
		liquidacionIvaInstance.netoCompra10 = command.netoCompra10
		liquidacionIvaInstance.netoCompra27 = command.netoCompra27
		liquidacionIvaInstance.netoCompra2 = command.netoCompra2
		liquidacionIvaInstance.netoCompra5 = command.netoCompra5

		liquidacionIvaInstance.netoNoGravadoCompra = command.netoNoGravadoCompra
		liquidacionIvaInstance.exentoCompra = command.exentoCompra

		liquidacionIvaInstance.creditoFiscal = command.creditoFiscal
		liquidacionIvaInstance.creditoFiscal21 = command.creditoFiscal21
		liquidacionIvaInstance.creditoFiscal10 = command.creditoFiscal10
		liquidacionIvaInstance.creditoFiscal27 = command.creditoFiscal27
		liquidacionIvaInstance.creditoFiscal2 = command.creditoFiscal2
		liquidacionIvaInstance.creditoFiscal5 = command.creditoFiscal5

		liquidacionIvaInstance.totalCompra = command.totalCompra
		liquidacionIvaInstance.totalCompra21 = command.totalCompra21
		liquidacionIvaInstance.totalCompra10 = command.totalCompra10
		liquidacionIvaInstance.totalCompra27 = command.totalCompra27
		liquidacionIvaInstance.totalCompra2 = command.totalCompra2
		liquidacionIvaInstance.totalCompra5 = command.totalCompra5

		liquidacionIvaInstance.totalNoGravadoCompra = command.totalNoGravadoCompra
		liquidacionIvaInstance.totalExentoCompra = command.totalExentoCompra

		liquidacionIvaInstance.debitoMenosCredito = command.debitoMenosCredito
		liquidacionIvaInstance.saldoTecnicoAFavorPeriodoAnterior = command.saldoTecnicoAFavorPeriodoAnterior
		liquidacionIvaInstance.saldoTecnicoAFavor = command.saldoTecnicoAFavor
		liquidacionIvaInstance.saldoLibreDisponibilidadPeriodoAnterior = command.saldoLibreDisponibilidadPeriodoAnterior
		liquidacionIvaInstance.saldoLibreDisponibilidad = command.saldoLibreDisponibilidad
		liquidacionIvaInstance.retencion = command.retencion
		liquidacionIvaInstance.percepcion = command.percepcion

		liquidacionIvaInstance.saldoDdjj = command.saldoDdjj

		liquidacionIvaInstance.facturasVentaImportadas = command.facturasVentaImportadas
		liquidacionIvaInstance.facturasCompraImportadas = command.facturasCompraImportadas

		liquidacionIvaInstance.nota = command.nota

		liquidacionIvaInstance.estado = Estado.findByNombre('Liquidado')

		if(command.cuentaId!=null){
			def cuenta = Cuenta.get(command.cuentaId)
			liquidacionIvaInstance.cuenta = cuenta

			//Se debe liquidar los locales correspondientes a esta cuenta
			cuenta.locales.each{
				if(it.estado!=estadoBorrado){
					def liquidacionLocal = new LiquidacionIvaLocal()
					liquidacionLocal.local = it
					liquidacionLocal.porcentajeLocal = it.porcentaje
					liquidacionLocal.saldoDdjj = ((liquidacionIvaInstance.saldoDdjj * it.porcentaje)/100).round(2)

					liquidacionIvaInstance.addToLiquidacionlocales(liquidacionLocal)
				}
			}
		}

		def currentUser = accessRulesService.getCurrentUser()
		liquidacionIvaInstance.ultimaModificacion = new LocalDateTime()
		liquidacionIvaInstance.ultimoModificador = currentUser.username

		liquidacionIvaInstance.save(flush:true)

		return liquidacionIvaInstance
	}

	def updateLiquidacionIva(LiquidacionIvaCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionIvaInstance = LiquidacionIva.get(command.liquidacionIvaId)

		if (command.version != null) {
			if (liquidacionIvaInstance.version > command.version) {
				LiquidacionIvaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["LiquidacionIva"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado al LiquidacionIva")
				throw new ValidationException("Error de versión", LiquidacionIvaCommand.errors)
			}
		}

		liquidacionIvaInstance.fechaVencimiento = command.fechaVencimiento
		liquidacionIvaInstance.porcentajeDebitoCredito = command.porcentajeDebitoCredito

		liquidacionIvaInstance.facturasA = command.facturasA
		liquidacionIvaInstance.facturasA21 = command.facturasA21
		liquidacionIvaInstance.facturasA10 = command.facturasA10
		liquidacionIvaInstance.facturasA27 = command.facturasA27
		liquidacionIvaInstance.facturasA2 = command.facturasA2
		liquidacionIvaInstance.facturasA5 = command.facturasA5

		liquidacionIvaInstance.noGravadoFacturasA = command.noGravadoFacturasA
		liquidacionIvaInstance.exentoFacturasA = command.exentoFacturasA

		liquidacionIvaInstance.otrasFacturas = command.otrasFacturas
		liquidacionIvaInstance.otrasFacturas21 = command.otrasFacturas21
		liquidacionIvaInstance.otrasFacturas10 = command.otrasFacturas10
		liquidacionIvaInstance.otrasFacturas27 = command.otrasFacturas27
		liquidacionIvaInstance.otrasFacturas2 = command.otrasFacturas2
		liquidacionIvaInstance.otrasFacturas5 = command.otrasFacturas5

		liquidacionIvaInstance.noGravadoOtrasFacturas = command.noGravadoOtrasFacturas
		liquidacionIvaInstance.exentoOtrasFacturas = command.exentoOtrasFacturas

		liquidacionIvaInstance.netoVenta = command.netoVenta
		liquidacionIvaInstance.netoVenta21 = command.netoVenta21
		liquidacionIvaInstance.netoVenta10 = command.netoVenta10
		liquidacionIvaInstance.netoVenta27 = command.netoVenta27
		liquidacionIvaInstance.netoVenta2 = command.netoVenta2
		liquidacionIvaInstance.netoVenta5 = command.netoVenta5

		liquidacionIvaInstance.netoNoGravadoVenta = command.netoNoGravadoVenta
		liquidacionIvaInstance.exentoVenta = command.exentoVenta

		liquidacionIvaInstance.debitoFiscal = command.debitoFiscal
		liquidacionIvaInstance.debitoFiscal21 = command.debitoFiscal21
		liquidacionIvaInstance.debitoFiscal10 = command.debitoFiscal10
		liquidacionIvaInstance.debitoFiscal27 = command.debitoFiscal27
		liquidacionIvaInstance.debitoFiscal2 = command.debitoFiscal2
		liquidacionIvaInstance.debitoFiscal5 = command.debitoFiscal5

		liquidacionIvaInstance.totalVenta = command.totalVenta
		liquidacionIvaInstance.totalVenta21 = command.totalVenta21
		liquidacionIvaInstance.totalVenta10 = command.totalVenta10
		liquidacionIvaInstance.totalVenta27 = command.totalVenta27
		liquidacionIvaInstance.totalVenta2 = command.totalVenta2
		liquidacionIvaInstance.totalVenta5 = command.totalVenta5

		liquidacionIvaInstance.totalNoGravadoVenta = command.totalNoGravadoVenta
		liquidacionIvaInstance.totalExentoVenta = command.totalExentoVenta

		liquidacionIvaInstance.netoCompra = command.netoCompra
		liquidacionIvaInstance.netoCompra21 = command.netoCompra21
		liquidacionIvaInstance.netoCompra10 = command.netoCompra10
		liquidacionIvaInstance.netoCompra27 = command.netoCompra27
		liquidacionIvaInstance.netoCompra2 = command.netoCompra2
		liquidacionIvaInstance.netoCompra5 = command.netoCompra5

		liquidacionIvaInstance.netoNoGravadoCompra = command.netoNoGravadoCompra
		liquidacionIvaInstance.exentoCompra = command.exentoCompra

		liquidacionIvaInstance.creditoFiscal = command.creditoFiscal
		liquidacionIvaInstance.creditoFiscal21 = command.creditoFiscal21
		liquidacionIvaInstance.creditoFiscal10 = command.creditoFiscal10
		liquidacionIvaInstance.creditoFiscal27 = command.creditoFiscal27
		liquidacionIvaInstance.creditoFiscal2 = command.creditoFiscal2
		liquidacionIvaInstance.creditoFiscal5 = command.creditoFiscal5

		liquidacionIvaInstance.totalCompra = command.totalCompra
		liquidacionIvaInstance.totalCompra21 = command.totalCompra21
		liquidacionIvaInstance.totalCompra10 = command.totalCompra10
		liquidacionIvaInstance.totalCompra27 = command.totalCompra27
		liquidacionIvaInstance.totalCompra2 = command.totalCompra2
		liquidacionIvaInstance.totalCompra5 = command.totalCompra5

		liquidacionIvaInstance.totalNoGravadoCompra = command.totalNoGravadoCompra
		liquidacionIvaInstance.totalExentoCompra = command.totalExentoCompra

		liquidacionIvaInstance.debitoMenosCredito = command.debitoMenosCredito
		liquidacionIvaInstance.saldoTecnicoAFavorPeriodoAnterior = command.saldoTecnicoAFavorPeriodoAnterior
		liquidacionIvaInstance.saldoTecnicoAFavor = command.saldoTecnicoAFavor
		liquidacionIvaInstance.saldoLibreDisponibilidadPeriodoAnterior = command.saldoLibreDisponibilidadPeriodoAnterior
		liquidacionIvaInstance.saldoLibreDisponibilidad = command.saldoLibreDisponibilidad
		liquidacionIvaInstance.retencion = command.retencion
		liquidacionIvaInstance.percepcion = command.percepcion

		liquidacionIvaInstance.saldoDdjj = command.saldoDdjj

		liquidacionIvaInstance.facturasVentaImportadas = command.facturasVentaImportadas
		liquidacionIvaInstance.facturasCompraImportadas = command.facturasCompraImportadas

		liquidacionIvaInstance.nota = command.nota

		liquidacionIvaInstance.estado = Estado.get(command.estadoId)

		liquidacionIvaInstance.importacionPosterior = false

		def cuenta = Cuenta.get(command.cuentaId)
		if(cuenta!=null){
			liquidacionIvaInstance.cuenta = cuenta

			if(liquidacionIvaInstance.liquidacionlocales!=null){
				liquidacionIvaInstance.liquidacionlocales.clear()
				liquidacionIvaInstance.save(flush:true,failOnError:true)
			}

			//Se debe liquidar los locales correspondientes a esta cuenta
			cuenta.locales.each{
				if(it.estado!=estadoBorrado){
					def liquidacionLocal = new LiquidacionIvaLocal()
					liquidacionLocal.local = it
					liquidacionLocal.porcentajeLocal = it.porcentaje
					liquidacionLocal.saldoDdjj = ((liquidacionIvaInstance.saldoDdjj * it.porcentaje)/100).round(2)

					liquidacionIvaInstance.addToLiquidacionlocales(liquidacionLocal)
				}
			}
		}

		def currentUser = accessRulesService.getCurrentUser()
		liquidacionIvaInstance.ultimaModificacion = new LocalDateTime()
		liquidacionIvaInstance.ultimoModificador = currentUser.username

		liquidacionIvaInstance.save(flush:true,failOnError:true) 
		return liquidacionIvaInstance
	}

	def updateRetencionPercepcion(LiquidacionIvaCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionIvaInstance = LiquidacionIva.get(command.liquidacionIvaId)

		if (command.version != null) {
			if (liquidacionIvaInstance.version > command.version) {
				LiquidacionIvaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["LiquidacionIva"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado al LiquidacionIva")
				throw new ValidationException("Error de versión", LiquidacionIvaCommand.errors)
			}
		}

		if(liquidacionIvaInstance==null){
			liquidacionIvaInstance = new LiquidacionIva()

			liquidacionIvaInstance.fecha = new LocalDate(command.ano + '-' + command.mes + '-01')

			def cuenta = Cuenta.get(command.cuentaId)
			if(cuenta!=null){
				liquidacionIvaInstance.cuenta = cuenta
			}
			liquidacionIvaInstance = verificarImportacion(liquidacionIvaInstance, cuenta, liquidacionIvaInstance.fecha)
			//Toma los saldos de períodos anteriores
			def fechaLiquidacionMesAnterior = liquidacionIvaInstance.fecha.minusMonths(1)

			LiquidacionIva liquidacionAnterior = LiquidacionIva.findByCuentaAndFecha(liquidacionIvaInstance.cuenta, fechaLiquidacionMesAnterior)

			if(liquidacionAnterior!=null){
				liquidacionIvaInstance.saldoTecnicoAFavor = liquidacionAnterior.saldoTecnicoAFavor
				liquidacionIvaInstance.saldoTecnicoAFavorPeriodoAnterior = liquidacionAnterior.saldoTecnicoAFavor
				liquidacionIvaInstance.saldoLibreDisponibilidadPeriodoAnterior = liquidacionAnterior.saldoLibreDisponibilidad
				liquidacionIvaInstance.saldoLibreDisponibilidad = (liquidacionAnterior.saldoLibreDisponibilidad + command.retencion + command.percepcion).round(2)
			}else{
				liquidacionIvaInstance.saldoTecnicoAFavor = 0
				liquidacionIvaInstance.saldoTecnicoAFavorPeriodoAnterior = 0
				liquidacionIvaInstance.saldoLibreDisponibilidadPeriodoAnterior = 0
				liquidacionIvaInstance.saldoLibreDisponibilidad = (command.retencion + command.percepcion).round(2)
			}
		}

		if(command.retencion!=null)
			liquidacionIvaInstance.retencion = command.retencion
		else
			liquidacionIvaInstance.retencion = 0

		if(command.percepcion!=null)
			liquidacionIvaInstance.percepcion = command.percepcion
		else
			liquidacionIvaInstance.percepcion = 0

		liquidacionIvaInstance.estado = Estado.findByNombre('Per/Ret ingresado')

		if(liquidacionIvaInstance.liquidacionlocales!=null){
			liquidacionIvaInstance.liquidacionlocales.clear()
			liquidacionIvaInstance.save(flush:true)
		}

		//Se debe liquidar los locales correspondientes a esta cuenta
		liquidacionIvaInstance.cuenta.locales.each{
			if(it.estado!=estadoBorrado){
				def liquidacionLocal = new LiquidacionIvaLocal()
				liquidacionLocal.local = it
				liquidacionLocal.porcentajeLocal = it.porcentaje
				liquidacionLocal.saldoDdjj = ((liquidacionIvaInstance.saldoDdjj * it.porcentaje)/100).round(2)

				liquidacionIvaInstance.addToLiquidacionlocales(liquidacionLocal)
			}
		}

		def currentUser = accessRulesService.getCurrentUser()
		liquidacionIvaInstance.ultimaModificacion = new LocalDateTime()
		liquidacionIvaInstance.ultimoModificador = currentUser.username

		liquidacionIvaInstance.save(flush:true)

		return liquidacionIvaInstance
	}

	def updateNota(LiquidacionIvaCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionIvaInstance = LiquidacionIva.get(command.liquidacionIvaId)

		if (command.version != null) {
			if (liquidacionIvaInstance.version > command.version) {
				LiquidacionIvaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["LiquidacionIva"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado al LiquidacionIva")
				throw new ValidationException("Error de versión", LiquidacionIvaCommand.errors)
			}
		}

		if(liquidacionIvaInstance==null){
			liquidacionIvaInstance = new LiquidacionIva()

			liquidacionIvaInstance.fecha = new LocalDate(command.ano + '-' + command.mes + '-01')

			def cuenta = Cuenta.get(command.cuentaId)
			if(cuenta!=null){
				liquidacionIvaInstance.cuenta = cuenta
			}
			liquidacionIvaInstance = verificarImportacion(liquidacionIvaInstance, cuenta, liquidacionIvaInstance.fecha)

			//Toma los saldos de períodos anteriores
			def fechaLiquidacionMesAnterior = liquidacionIvaInstance.fecha.minusMonths(1)

			LiquidacionIva liquidacionAnterior = LiquidacionIva.findByCuentaAndFecha(liquidacionIvaInstance.cuenta, fechaLiquidacionMesAnterior)

			if(liquidacionAnterior!=null){
				liquidacionIvaInstance.saldoTecnicoAFavor = liquidacionAnterior.saldoTecnicoAFavor
				liquidacionIvaInstance.saldoTecnicoAFavorPeriodoAnterior = liquidacionAnterior.saldoTecnicoAFavor
				liquidacionIvaInstance.saldoLibreDisponibilidadPeriodoAnterior = liquidacionAnterior.saldoLibreDisponibilidad
				liquidacionIvaInstance.saldoLibreDisponibilidad = (liquidacionAnterior.saldoLibreDisponibilidad).round(2)
			}else{
				liquidacionIvaInstance.saldoTecnicoAFavor = 0
				liquidacionIvaInstance.saldoTecnicoAFavorPeriodoAnterior = 0
				liquidacionIvaInstance.saldoLibreDisponibilidadPeriodoAnterior = 0
				liquidacionIvaInstance.saldoLibreDisponibilidad = 0
			}
		}

		if(command.nota!=null)
			liquidacionIvaInstance.nota = command.nota
		else
			liquidacionIvaInstance.nota = ''

		liquidacionIvaInstance.estado = Estado.findByNombre('Nota ingresada')

		if(liquidacionIvaInstance.liquidacionlocales!=null){
			liquidacionIvaInstance.liquidacionlocales.clear()
			liquidacionIvaInstance.save(flush:true)
		}

		//Se debe liquidar los locales correspondientes a esta cuenta
		liquidacionIvaInstance.cuenta.locales.each{
			if(it.estado!=estadoBorrado){
				def liquidacionLocal = new LiquidacionIvaLocal()
				liquidacionLocal.local = it
				liquidacionLocal.porcentajeLocal = it.porcentaje
				liquidacionLocal.saldoDdjj = ((liquidacionIvaInstance.saldoDdjj * it.porcentaje)/100).round(2)

				liquidacionIvaInstance.addToLiquidacionlocales(liquidacionLocal)
			}
		}

		def currentUser = accessRulesService.getCurrentUser()
		liquidacionIvaInstance.ultimaModificacion = new LocalDateTime()
		liquidacionIvaInstance.ultimoModificador = currentUser.username

		liquidacionIvaInstance.save(flush:true)

		return liquidacionIvaInstance
	}

	def liquidacionMasiva(LiquidacionIvaMasivaCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def fecha = new LocalDate(command.ano + '-' + command.mes + '-01')
		def fechaAnterior = fecha.minusMonths(1)
		def cuentasIds = command.cuentasIds.split(',')

		def resultado = []

		cuentasIds.each{
			def cuenta = Cuenta.get(it)
			LiquidacionIva liquidacionAnterior = LiquidacionIva.findByCuentaAndFecha(cuenta, fechaAnterior)
			LiquidacionIva liquidacion = LiquidacionIva.findByCuentaAndFecha(cuenta, fecha)

			if(liquidacion==null){
				liquidacion = new LiquidacionIva()
				liquidacion.retencion = 0
				liquidacion.percepcion = 0
				liquidacion.cuenta = cuenta
			}

			//Obtiene la confirmación si hubo importación de facturas de compra
			liquidacion = verificarImportacion(liquidacion, cuenta, fecha)

			liquidacion.fecha = fecha
			liquidacion.porcentajeSaldoDdjj = command.porcentajeSaldoDdjj
			liquidacion.porcentajeDebitoFiscalDdjj = command.porcentajeDebitoFiscal

			if(liquidacionAnterior!=null){
				liquidacion.saldoTecnicoAFavorPeriodoAnterior = liquidacionAnterior.saldoTecnicoAFavor
				liquidacion.saldoLibreDisponibilidadPeriodoAnterior = liquidacionAnterior.saldoLibreDisponibilidad

				//Obtiene los valores calculados por porcentaje pasado según liquidacion anterior
				liquidacion.saldoDdjj = (command.porcentajeSaldoDdjj * liquidacionAnterior.saldoDdjj).round(2)
				liquidacion.debitoFiscal = (command.porcentajeDebitoFiscal * liquidacionAnterior.debitoFiscal).round(2)

				liquidacion.netoVenta = (liquidacion.debitoFiscal / 0.21).round(2)
				liquidacion.totalVenta = (liquidacion.netoVenta + liquidacion.debitoFiscal).round(2)

				liquidacion.creditoFiscal = (liquidacion.debitoFiscal 
												- liquidacion.saldoDdjj 
												- liquidacion.saldoTecnicoAFavorPeriodoAnterior 
												- liquidacion.saldoLibreDisponibilidadPeriodoAnterior 
												- liquidacion.retencion 
												- liquidacion.percepcion).round(2)

				//Si el crédito fiscal es mayor o igual a 0, quiere decir que no habrá saldos a favor (ni técnico ni de libre disponibilidad,
				//o sea que se consumió todos los saldos anteriores si es que había, junto con las percepciones y retenciones actuales
				if(liquidacion.creditoFiscal >= 0){
					liquidacion.netoCompra = (liquidacion.creditoFiscal / 0.21).round(2)
					liquidacion.totalCompra = (liquidacion.netoCompra + liquidacion.creditoFiscal).round(2)

					liquidacion.porcentajeDebitoCredito = liquidacion.creditoFiscal ? (((liquidacion.debitoFiscal / liquidacion.creditoFiscal) - 1) * 100).round(2) : 100
					liquidacion.debitoMenosCredito = (liquidacion.debitoFiscal - liquidacion.creditoFiscal).round(2)

					//liquidacion.netoNoGravadoVenta = (liquidacion.netoNoGravadoCompra * (liquidacion.debitoMenosCredito + 1)).round(2)
					liquidacion.exentoVenta = (liquidacion.exentoCompra * ((liquidacion.debitoMenosCredito/100) + 1)).round(2)
					//liquidacion.totalNoGravadoVenta = (lquidacion.totalNoGravadoCompra * (liquidacion.debitoMenosCredito + 1)).round(2)
					liquidacion.totalExentoVenta = (liquidacion.totalExentoCompra * ((liquidacion.debitoMenosCredito/100) + 1)).round(2)

					liquidacion.saldoTecnicoAFavor = 0
					liquidacion.saldoLibreDisponibilidad = 0
				}else{
					//En caso que el credito fiscal de negativo es porque quedó saldo (tecnico o de libre disponibilidad)
					//Siguiendo la lógica el saldoDDJJ y el creditoFiscal no pueden ser negativos, entonces se igualan a 0
					liquidacion.debitoMenosCredito = liquidacion.debitoFiscal

					// La fórmula general es:
					// saldoDDJJ = debito - credito - saldoTecnicoAnterior - saldoLibreDisponibilidadAnterior - retenciones - percepciones
					//
					// Esta fórmula se usó para sacar el crédito, pero dió negativo

					if(liquidacion.debitoFiscal <= liquidacion.saldoTecnicoAFavorPeriodoAnterior){
						liquidacion.saldoTecnicoAFavor = (liquidacion.saldoTecnicoAFavorPeriodoAnterior - liquidacion.debitoFiscal).round(2)
						liquidacion.saldoLibreDisponibilidad = (liquidacion.saldoLibreDisponibilidadPeriodoAnterior + liquidacion.retencion + liquidacion.percepcion).round(2)
					}else{
						liquidacion.saldoTecnicoAFavor = 0
						liquidacion.saldoLibreDisponibilidad = (liquidacion.saldoLibreDisponibilidadPeriodoAnterior
																	+ liquidacion.retencion
																	+ liquidacion.percepcion
																	- (liquidacion.debitoFiscal - liquidacion.saldoTecnicoAFavorPeriodoAnterior)
																	).round(2)
					}
				}

				liquidacion.netoVenta21 = liquidacion.netoVenta
				liquidacion.debitoFiscal21 = liquidacion.debitoFiscal
				liquidacion.totalVenta21 = liquidacion.totalVenta

				liquidacion.netoCompra21 = liquidacion.netoCompra
				liquidacion.creditoFiscal21 = liquidacion.creditoFiscal
				liquidacion.totalCompra21 = liquidacion.totalCompra

			}else{
				// Como no hay liquidacion anterior, entonces la nueva liquidación quedará en 0 todo, menos las percepciones y retenciones
				// que fueron cargadas previamente, y se calcula el nuevo
				liquidacion.saldoTecnicoAFavor = 0
				liquidacion.saldoTecnicoAFavorPeriodoAnterior = 0

				liquidacion.saldoLibreDisponibilidad = (liquidacion.retencion + liquidacion.percepcion).round(2)
				liquidacion.saldoLibreDisponibilidadPeriodoAnterior = 0

				liquidacion.saldoDdjj = 0
			}

			if(liquidacion.liquidacionlocales!=null){
				liquidacion.liquidacionlocales.clear()
				liquidacion.save(flush:true)
			}

			//Se debe liquidar los locales correspondientes a esta cuenta
			liquidacion.cuenta.locales.each{
				if(it.estado!=estadoBorrado){
					def liquidacionLocal = new LiquidacionIvaLocal()
					liquidacionLocal.local = it
					liquidacionLocal.porcentajeLocal = it.porcentaje
					liquidacionLocal.saldoDdjj = ((liquidacion.saldoDdjj * it.porcentaje)/100).round(2)

					liquidacion.addToLiquidacionlocales(liquidacionLocal)
				}
			}

			liquidacion.estado = Estado.findByNombre('Liquidado A')

			def currentUser = accessRulesService.getCurrentUser()
			liquidacion.ultimaModificacion = new LocalDateTime()
			liquidacion.ultimoModificador = currentUser.username

			liquidacion.save(flush:true)

			resultado.push(liquidacion)
		}

		return resultado
	}

	def liquidacionMasiva2(LiquidacionIvaMasivaCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def fecha = new LocalDate(command.ano + '-' + command.mes + '-01')
		def fechaAnterior = fecha.minusMonths(1)
		def cuentasIds = command.cuentasIds.split(',')
		def estadoLiquidadoA2 = Estado.findByNombre('Liquidado A2')

		def resultado = []

		def liquidaciones = LiquidacionIva.findAllByFecha(fecha)
		def liquidacionesAnteriores = LiquidacionIva.findAllByFecha(fechaAnterior)
		cuentasIds.each{
			def cuenta = Cuenta.get(it)
			LiquidacionIva liquidacionAnterior = liquidacionesAnteriores.find { it.cuenta.id == cuenta.id}
			LiquidacionIva liquidacion = liquidaciones.find { it.cuenta.id == cuenta.id}

			if(liquidacion==null){
				liquidacion = new LiquidacionIva()
				liquidacion.cuenta = cuenta
				liquidacion.percepcion = 0
				liquidacion.retencion = 0
			}

			if (command.pisarRetPer){
				def percepcionRetencion = retencionPercepcionService.calcularRetencionPercepcionSumatoria(cuenta.id, command.mes, command.ano, true)
				liquidacion.percepcion = percepcionRetencion[2]
				liquidacion.retencion = percepcionRetencion[0] + percepcionRetencion[1]
			}

			liquidacion.fecha = fecha
			liquidacion.porcentajeSaldoDdjj = command.porcentajeSaldoDdjj
			liquidacion.porcentajeDebitoFiscalDdjj = null

			if(liquidacionAnterior!=null){
				liquidacion.saldoTecnicoAFavorPeriodoAnterior = liquidacionAnterior.saldoTecnicoAFavor
				liquidacion.saldoLibreDisponibilidadPeriodoAnterior = liquidacionAnterior.saldoLibreDisponibilidad

				//Obtiene los valores calculados por porcentaje pasado según liquidacion anterior
				liquidacion.saldoDdjj = (command.porcentajeSaldoDdjj * liquidacionAnterior.saldoDdjj).round(2)

				//Obtiene la confirmación si hubo importación de facturas de compra
				liquidacion = verificarImportacion(liquidacion, cuenta, fecha)

				if(liquidacion.facturasCompraImportadas){
					//Obtiene la sumatoria de facturas de compra
					def liquidacionIvaCommand = new LiquidacionIvaCommand()
					liquidacionIvaCommand.cuentaId = cuenta.id
					liquidacionIvaCommand.ano = command.ano
					liquidacionIvaCommand.mes = command.mes
					liquidacionIvaCommand = agregarSumatoriaImportaciones(liquidacionIvaCommand, false)

					liquidacion.netoCompra = liquidacionIvaCommand.netoCompraSumatoria
					liquidacion.creditoFiscal = liquidacionIvaCommand.creditoFiscalSumatoria
					liquidacion.totalCompra = liquidacionIvaCommand.totalCompraSumatoria
					//21%
					liquidacion.netoCompra21 = liquidacionIvaCommand.netoCompra21Sumatoria
					liquidacion.creditoFiscal21 = liquidacionIvaCommand.creditoFiscal21Sumatoria
					liquidacion.totalCompra21 = liquidacionIvaCommand.totalCompra21Sumatoria
					//10%
					liquidacion.netoCompra10 = liquidacionIvaCommand.netoCompra10Sumatoria
					liquidacion.creditoFiscal10 = liquidacionIvaCommand.creditoFiscal10Sumatoria
					liquidacion.totalCompra10 = liquidacionIvaCommand.totalCompra10Sumatoria
					//27%
					liquidacion.netoCompra27 = liquidacionIvaCommand.netoCompra27Sumatoria
					liquidacion.creditoFiscal27 = liquidacionIvaCommand.creditoFiscal27Sumatoria
					liquidacion.totalCompra27 = liquidacionIvaCommand.totalCompra27Sumatoria
					//2%
					liquidacion.netoCompra2 = liquidacionIvaCommand.netoCompra2Sumatoria
					liquidacion.creditoFiscal2 = liquidacionIvaCommand.creditoFiscal2Sumatoria
					liquidacion.totalCompra2 = liquidacionIvaCommand.totalCompra2Sumatoria
					//5%
					liquidacion.netoCompra5 = liquidacionIvaCommand.netoCompra5Sumatoria
					liquidacion.creditoFiscal5 = liquidacionIvaCommand.creditoFiscal5Sumatoria
					liquidacion.totalCompra5 = liquidacionIvaCommand.totalCompra5Sumatoria

					//Se realiza un ajuste matemático por si el neto+iva no es exactamente igual al total
					if( (liquidacion.creditoFiscal21/0.21).round(2) != liquidacion.netoCompra21){
						liquidacion.netoCompra21 = (liquidacion.creditoFiscal21/0.21).round(2)
						liquidacion.totalCompra21 = (liquidacion.creditoFiscal21 + liquidacion.netoCompra21).round(2)
					}
					if( (liquidacion.creditoFiscal10/0.105).round(2) != liquidacion.netoCompra10){
						liquidacion.netoCompra10 = (liquidacion.creditoFiscal10/0.105).round(2)
						liquidacion.totalCompra10 = (liquidacion.creditoFiscal10 + liquidacion.netoCompra10).round(2)
					}

					if( (liquidacion.creditoFiscal27/0.27).round(2) != liquidacion.netoCompra27){
						liquidacion.netoCompra27 = (liquidacion.creditoFiscal27/0.27).round(2)
						liquidacion.totalCompra27 = (liquidacion.creditoFiscal27 + liquidacion.netoCompra27).round(2)
					}
					/*if( (liquidacion.netoCompra21*0.21).round(2) != liquidacion.creditoFiscal21){
						liquidacion.creditoFiscal21 = (liquidacion.netoCompra21*0.21).round(2)
						liquidacion.totalCompra21 = (liquidacion.creditoFiscal21 + liquidacion.netoCompra21).round(2)
					}
					if( (liquidacion.netoCompra10*0.105).round(2) != liquidacion.creditoFiscal10){
						liquidacion.creditoFiscal10 = (liquidacion.netoCompra10*0.105).round(2)
						liquidacion.totalCompra10 = (liquidacion.creditoFiscal10 + liquidacion.netoCompra10).round(2)
					}

					if( (liquidacion.netoCompra27*0.27).round(2) != liquidacion.creditoFiscal27){
						liquidacion.creditoFiscal27 = (liquidacion.netoCompra27*0.27).round(2)
						liquidacion.totalCompra27 = (liquidacion.creditoFiscal27 + liquidacion.netoCompra27).round(2)
					}*/

					liquidacion.netoCompra = liquidacion.netoCompra21 + liquidacion.netoCompra10 + liquidacion.netoCompra27 + liquidacion.netoCompra2 + liquidacion.netoCompra5
					liquidacion.creditoFiscal = liquidacion.creditoFiscal21 + liquidacion.creditoFiscal10 + liquidacion.creditoFiscal27 + liquidacion.creditoFiscal2 + liquidacion.creditoFiscal5
					liquidacion.totalCompra = liquidacion.totalCompra21 + liquidacion.totalCompra10 + liquidacion.totalCompra27 + liquidacion.totalCompra2 + liquidacion.totalCompra5

					//No Gravado y Exento
					liquidacion.netoNoGravadoCompra = 0
					liquidacion.exentoCompra = liquidacionIvaCommand.exentoCompraSumatoria
					liquidacion.totalNoGravadoCompra = 0
					liquidacion.totalExentoCompra = liquidacionIvaCommand.totalExentoCompraSumatoria
				}

				// La fórmula general es:
				// saldoDDJJ = debito - credito - saldoTecnicoAnterior - saldoLibreDisponibilidadAnterior - retenciones - percepciones
				// Entonces
				// debito = saldoDDJJ + credito + saldoTecnicoAnterior + saldoLibreDisponibilidadAnterior + retenciones + percepciones
				// esto quiere decir que debito es siempre positivo o 0

				liquidacion.debitoFiscal = (liquidacion.saldoDdjj 
												+ liquidacion.creditoFiscal 
												+ liquidacion.saldoTecnicoAFavorPeriodoAnterior 
												+ liquidacion.saldoLibreDisponibilidadPeriodoAnterior 
												+ liquidacion.retencion 
												+ liquidacion.percepcion).round(2)

				// Se debe distribuir el debitoFiscal total entre debitoFiscal21 y debitoFiscal10
				// La lógica es calcular qué % del creditoFiscal corresponde al 10,5%, para sacar el debitoFiscal10
				// el resto de debitoFiscal lo aplicamos al debitoFiscal21

				// se calcula cuánto creditoFiscal del total va a 10,5%
				def porcentajeCreditoFiscal10 = liquidacion.creditoFiscal ? liquidacion.creditoFiscal10 / liquidacion.creditoFiscal : 1
				liquidacion.debitoFiscal10 = (liquidacion.debitoFiscal * porcentajeCreditoFiscal10).round(2)
				liquidacion.debitoFiscal21 = liquidacion.debitoFiscal - liquidacion.debitoFiscal10

				liquidacion.netoVenta10 = (liquidacion.debitoFiscal10 / 0.105).round(2)
				liquidacion.totalVenta10 = (liquidacion.netoVenta10 + liquidacion.debitoFiscal10).round(2)
				liquidacion.netoVenta21 = (liquidacion.debitoFiscal21 / 0.21).round(2)
				liquidacion.totalVenta21 = (liquidacion.netoVenta21 + liquidacion.debitoFiscal21).round(2)

				liquidacion.netoVenta = liquidacion.netoVenta21 + liquidacion.netoVenta10
				liquidacion.totalVenta = liquidacion.totalVenta21 + liquidacion.totalVenta10

				liquidacion.porcentajeDebitoCredito = liquidacion.creditoFiscal ? (((liquidacion.debitoFiscal / liquidacion.creditoFiscal) - 1) * 100).round(2) : 100
				liquidacion.debitoMenosCredito = (liquidacion.debitoFiscal - liquidacion.creditoFiscal).round(2)

				liquidacion.saldoTecnicoAFavor = 0
				liquidacion.saldoLibreDisponibilidad = 0
			}

			if(liquidacion.liquidacionlocales!=null){
				liquidacion.liquidacionlocales.clear()
				liquidacion.save(flush:true)
			}

			//Se debe liquidar los locales correspondientes a esta cuenta
			liquidacion.cuenta.locales.each{
				if(it.estado!=estadoBorrado){
					def liquidacionLocal = new LiquidacionIvaLocal()
					liquidacionLocal.local = it
					liquidacionLocal.porcentajeLocal = it.porcentaje
					liquidacionLocal.saldoDdjj = ((liquidacion.saldoDdjj * it.porcentaje)/100).round(2)

					liquidacion.addToLiquidacionlocales(liquidacionLocal)
				}
			}

			liquidacion.estado = estadoLiquidadoA2

			def currentUser = accessRulesService.getCurrentUser()
			liquidacion.ultimaModificacion = new LocalDateTime()
			liquidacion.ultimoModificador = currentUser?.username ?: "Selenium"
			liquidacion.save(flush:true)

			resultado.push(liquidacion)
		}

		return resultado
	}

	def enviarNotificaciones(String cuentas, String mes, String ano){
		enviarNotificaciones(new LiquidacionIvaMasivaCommand(mes:mes,ano:ano,cuentasIds:cuentas))
	}
	def enviarNotificaciones(LiquidacionIvaMasivaCommand command){
		def fecha = new LocalDate(command.ano + '-' + command.mes + '-01')
		def cuentasIds = command.cuentasIds.split(',')
		Estado estadoNotificado = Estado.findByNombre("Notificado")
		Estado estadoAutorizado = Estado.findByNombre("Autorizada")
		def resultado = []

		def liquidaciones = LiquidacionIva.findAllByFecha(fecha)
		def vencimientos = VencimientoDeclaracion.findAllByMesPeriodoAndTipoImpuesto(new Integer(command.mes), "IVA")

		cuentasIds.each{
			def cuenta = Cuenta.get(it)
			def usuario = User.findByCuenta(cuenta)

			LiquidacionIva liquidacion = liquidaciones.find { it.cuenta.id == cuenta.id}

			if(liquidacion!=null){
				def fechaVencimiento = liquidacion.fechaVencimiento
				def saldoDdjj = liquidacion.saldoDdjj
				def saf = liquidacion.saldoTecnicoAFavor

				if(fechaVencimiento==null)
					fechaVencimiento = vencimientos.find{ it.cuitAplica(cuenta.cuit) }?.fechaVencimiento


				String nombreUsuario = ""
				if(cuenta!=null){
					nombreUsuario = (cuenta.nombreApellido.split(' '))[0]
				}

				String urlNotificaciones = usuarioService.getLinkDesactivarNotificaciones(usuario)
				String urlLinkAutorizacionLiquidaciones = grailsApplication.config.getProperty('grails.serverURL') + grailsLinkGenerator.link(controller: 'notificacion', action: 'autorizarLiquidaciones', absolute: false, params:['uId': usuario.id, 'cId': cuenta.id, 'ano': command.ano, 'mes':command.mes, 'iva':true])

				String valorIVA = ""
				String fechaVencimientoIVA = ""
				if(saf==0){
					valorIVA = "\$ " + formatear(saldoDdjj)
				}else{
					valorIVA = "Saldo a Favor \$" + formatear(saf)
				}

				fechaVencimientoIVA = fechaVencimiento.toString("dd/MM/YYYY")

				def currentUser = accessRulesService.getCurrentUser()
				liquidacion.ultimaModificacion = new LocalDateTime()
				liquidacion.ultimoModificador = currentUser.username

				liquidacion.notificado = true
				liquidacion.fechaHoraNotificacion = new LocalDateTime()

				if (cuenta.with{maximoAutorizarIva != null && maximoAutorizarIva >= liquidacion.saldoDdjj}){
					liquidacion.estado = estadoAutorizado
					liquidacion.save(flush:true)
					declaracionJuradaService.saveDeclaracionJuradaPendientePorLiquidacionIva(liquidacion)
				}else{
					NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Liquidacion Lista IVA")
					String bodyMail = plantilla.llenarVariablesBody([nombreUsuario,valorIVA,fechaVencimientoIVA, urlLinkAutorizacionLiquidaciones,urlNotificaciones])
					notificacionService.enviarEmail(usuario.username, plantilla.asuntoEmail, bodyMail, 'notificacionIVA', null, plantilla.tituloApp, plantilla.textoApp)
					liquidacion.estado = estadoNotificado
					liquidacion.save(flush:true)
				}

				resultado.push(liquidacion)
			}
		}

		return resultado
	}

	def liquidacionAutomatica(String mes, String ano, Long cuentaId){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def estadoActivo = Estado.findByNombre('Activo')
		def fecha = new LocalDate(ano + '-' + mes + '-01')
		def fechaAnterior = fecha.minusMonths(1)
		def estadoAutomatico = Estado.findByNombre('Automatico')

		def cuenta = Cuenta.get(cuentaId)
		def liquidacion = LiquidacionIva.findByFechaAndCuenta(fecha, cuenta)
		def liquidacionAnterior = LiquidacionIva.findByFechaAndCuenta(fechaAnterior, cuenta)

		if(liquidacion==null){
			liquidacion = new LiquidacionIva()
			liquidacion.retencion = 0
			liquidacion.percepcion = 0
			liquidacion.cuenta = cuenta
			liquidacion.fecha = fecha
		}else if (liquidacion.estado.nombre.with{it == "Autorizada" || it == "Presentada"})
			return liquidacion

		if(liquidacionAnterior!=null){
			liquidacion.saldoTecnicoAFavorPeriodoAnterior = liquidacionAnterior.saldoTecnicoAFavor
			liquidacion.saldoLibreDisponibilidadPeriodoAnterior = liquidacionAnterior.saldoLibreDisponibilidad
		}else {
			liquidacion.saldoTecnicoAFavorPeriodoAnterior = 0
			liquidacion.saldoLibreDisponibilidadPeriodoAnterior = 0
		}

		//Obtiene la confirmación si hubo importación de facturas de compra
		liquidacion = verificarImportacion(liquidacion, cuenta, fecha)

		//Obtiene la sumatoria de facturas
		def liquidacionIvaCommand = new LiquidacionIvaCommand()
		liquidacionIvaCommand.cuentaId = cuentaId
		liquidacionIvaCommand.ano = ano
		liquidacionIvaCommand.mes = mes
		liquidacionIvaCommand = agregarSumatoriaImportaciones(liquidacionIvaCommand, true)

		//Para compras
		liquidacion.netoCompra = liquidacionIvaCommand.netoCompraSumatoria
		liquidacion.creditoFiscal = liquidacionIvaCommand.creditoFiscalSumatoria
		liquidacion.totalCompra = liquidacionIvaCommand.totalCompraSumatoria
		//21%
		liquidacion.netoCompra21 = liquidacionIvaCommand.netoCompra21Sumatoria
		liquidacion.creditoFiscal21 = liquidacionIvaCommand.creditoFiscal21Sumatoria
		liquidacion.totalCompra21 = liquidacionIvaCommand.totalCompra21Sumatoria
		//10%
		liquidacion.netoCompra10 = liquidacionIvaCommand.netoCompra10Sumatoria
		liquidacion.creditoFiscal10 = liquidacionIvaCommand.creditoFiscal10Sumatoria
		liquidacion.totalCompra10 = liquidacionIvaCommand.totalCompra10Sumatoria
		//27%
		liquidacion.netoCompra27 = liquidacionIvaCommand.netoCompra27Sumatoria
		liquidacion.creditoFiscal27 = liquidacionIvaCommand.creditoFiscal27Sumatoria
		liquidacion.totalCompra27 = liquidacionIvaCommand.totalCompra27Sumatoria
		//2%
		liquidacion.netoCompra2 = liquidacionIvaCommand.netoCompra2Sumatoria
		liquidacion.creditoFiscal2 = liquidacionIvaCommand.creditoFiscal2Sumatoria
		liquidacion.totalCompra2 = liquidacionIvaCommand.totalCompra2Sumatoria
		//5%
		liquidacion.netoCompra5 = liquidacionIvaCommand.netoCompra5Sumatoria
		liquidacion.creditoFiscal5 = liquidacionIvaCommand.creditoFiscal5Sumatoria
		liquidacion.totalCompra5 = liquidacionIvaCommand.totalCompra5Sumatoria
		//No Gravado y Exento
		liquidacion.netoNoGravadoCompra = liquidacionIvaCommand.netoNoGravadoCompraSumatoria
		liquidacion.exentoCompra = liquidacionIvaCommand.exentoCompraSumatoria
		liquidacion.totalNoGravadoCompra = liquidacionIvaCommand.totalNoGravadoCompraSumatoria
		liquidacion.totalExentoCompra = liquidacionIvaCommand.totalExentoCompraSumatoria
		//Para ventas
		liquidacion.netoVenta = liquidacionIvaCommand.netoVentaSumatoria
		liquidacion.debitoFiscal = liquidacionIvaCommand.debitoFiscalSumatoria
		liquidacion.totalVenta = liquidacionIvaCommand.totalVentaSumatoria
		//21%
		liquidacion.netoVenta21 = liquidacionIvaCommand.netoVenta21Sumatoria
		liquidacion.debitoFiscal21 = liquidacionIvaCommand.debitoFiscal21Sumatoria
		liquidacion.totalVenta21 = liquidacionIvaCommand.totalVenta21Sumatoria
		//10%
		liquidacion.netoVenta10 = liquidacionIvaCommand.netoVenta10Sumatoria
		liquidacion.debitoFiscal10 = liquidacionIvaCommand.debitoFiscal10Sumatoria
		liquidacion.totalVenta10 = liquidacionIvaCommand.totalVenta10Sumatoria
		//27%
		liquidacion.netoVenta27 = liquidacionIvaCommand.netoVenta27Sumatoria
		liquidacion.debitoFiscal27 = liquidacionIvaCommand.debitoFiscal27Sumatoria
		liquidacion.totalVenta27 = liquidacionIvaCommand.totalVenta27Sumatoria
		//2%
		liquidacion.netoVenta2 = liquidacionIvaCommand.netoVenta2Sumatoria
		liquidacion.debitoFiscal2 = liquidacionIvaCommand.debitoFiscal2Sumatoria
		liquidacion.totalVenta2 = liquidacionIvaCommand.totalVenta2Sumatoria
		//5%
		liquidacion.netoVenta5 = liquidacionIvaCommand.netoVenta5Sumatoria
		liquidacion.debitoFiscal5 = liquidacionIvaCommand.debitoFiscal5Sumatoria
		liquidacion.totalVenta5 = liquidacionIvaCommand.totalVenta5Sumatoria
		//No Gravado y Exento
		liquidacion.netoNoGravadoVenta = liquidacionIvaCommand.netoNoGravadoVentaSumatoria
		liquidacion.exentoVenta = liquidacionIvaCommand.exentoVentaSumatoria
		liquidacion.totalNoGravadoVenta = liquidacionIvaCommand.totalNoGravadoVentaSumatoria
		liquidacion.totalExentoVenta = liquidacionIvaCommand.totalExentoVentaSumatoria

		//Facturas A
		liquidacion.facturasA = liquidacionIvaCommand.facturasASumatoria
		liquidacion.facturasA21 = liquidacionIvaCommand.facturasA21Sumatoria
		liquidacion.facturasA10 = liquidacionIvaCommand.facturasA10Sumatoria
		liquidacion.facturasA27 = liquidacionIvaCommand.facturasA27Sumatoria
		liquidacion.facturasA2 = liquidacionIvaCommand.facturasA2Sumatoria
		liquidacion.facturasA5 = liquidacionIvaCommand.facturasA5Sumatoria
		liquidacion.noGravadoFacturasA = liquidacionIvaCommand.noGravadoFacturasASumatoria
		liquidacion.exentoFacturasA = liquidacionIvaCommand.exentoFacturasASumatoria

		//Facturas No A
		liquidacion.otrasFacturas = liquidacionIvaCommand.otrasFacturasSumatoria
		liquidacion.otrasFacturas21 = liquidacionIvaCommand.otrasFacturas21Sumatoria
		liquidacion.otrasFacturas10 = liquidacionIvaCommand.otrasFacturas10Sumatoria
		liquidacion.otrasFacturas27 = liquidacionIvaCommand.otrasFacturas27Sumatoria
		liquidacion.otrasFacturas2 = liquidacionIvaCommand.otrasFacturas2Sumatoria
		liquidacion.otrasFacturas5 = liquidacionIvaCommand.otrasFacturas5Sumatoria
		liquidacion.noGravadoOtrasFacturas = liquidacionIvaCommand.noGravadoOtrasFacturasSumatoria
		liquidacion.exentoOtrasFacturas = liquidacionIvaCommand.exentoOtrasFacturasSumatoria

		//Se debe obtener las percepciones y las retenciones
		def percepcionRetencion = retencionPercepcionService.calcularRetencionPercepcionSumatoria(cuentaId, mes, ano, true)
		liquidacion.percepcion = percepcionRetencion[2]
		liquidacion.retencion = percepcionRetencion[0] + percepcionRetencion[1]

		liquidacion.debitoMenosCredito = (liquidacion.debitoFiscal - liquidacion.creditoFiscal).round(2)
		liquidacion.porcentajeDebitoCredito = liquidacion.creditoFiscal ? (((liquidacion.debitoFiscal / liquidacion.creditoFiscal) - 1) * 100).round(2) : 100

		//Se debe calcular los saldos nuevos
		if((liquidacion.saldoTecnicoAFavorPeriodoAnterior + liquidacion.creditoFiscal) > liquidacion.debitoFiscal){
			liquidacion.saldoTecnicoAFavor = (liquidacion.saldoTecnicoAFavorPeriodoAnterior + liquidacion.creditoFiscal - liquidacion.debitoFiscal).round(2)
		}else{
			liquidacion.saldoTecnicoAFavor = 0
		}

		//Se calcula el saldo de libre disponibilidad
		liquidacion.saldoLibreDisponibilidad = (liquidacion.retencion + liquidacion.percepcion + liquidacion.saldoLibreDisponibilidadPeriodoAnterior).round(2)
		def consumoSaldoLibreDisponibilidad = (liquidacion.debitoMenosCredito - liquidacion.saldoTecnicoAFavorPeriodoAnterior).round(2)

		//Si debitoMenosCredito - saldoTecnicoAFavorPeriodo anterior es mayor que cero, 
		//hay que consumir del saldoLibreDisponibilidad
		if(consumoSaldoLibreDisponibilidad>0){
			liquidacion.saldoLibreDisponibilidad = (liquidacion.saldoLibreDisponibilidad - consumoSaldoLibreDisponibilidad).round(2)

			if(liquidacion.saldoLibreDisponibilidad<0)
				liquidacion.saldoLibreDisponibilidad = 0;
		}

		liquidacion.saldoDdjj = (liquidacion.debitoFiscal
								- liquidacion.creditoFiscal 
								- liquidacion.saldoTecnicoAFavorPeriodoAnterior 
								- liquidacion.saldoLibreDisponibilidadPeriodoAnterior 
								- liquidacion.retencion 
								- liquidacion.percepcion).round(2)

		//Si el saldo da negativo, hay que igualarlo a 0
		if(liquidacion.saldoDdjj<0){
			liquidacion.saldoDdjj = 0;
		}

		LogImportacion.createCriteria().list() {
			and{
				eq('cuenta', cuenta)
				eq('fecha', fecha)
				eq('estado', estadoActivo)
			}
		}.each{
			if(it.compra){
				liquidacion.facturasCompraImportadas = true
			}
			else if (it.venta){
				liquidacion.facturasVentaImportadas = true
			}
			else if (it.retencion)
				if (it.retPerEsIva){
					liquidacion.retencionesImportadas = true
				}
			else if (it.percepcion)
				if (it.retPerEsIva){
					liquidacion.percepcionesImportadas = true
				}
			else if (it.bancaria){
				liquidacion.retencionesBancariasImportadas = true
			}
		}

		liquidacion.estado = estadoAutomatico

		def currentUser = accessRulesService.getCurrentUser()
		liquidacion.ultimaModificacion = new LocalDateTime()
		liquidacion.ultimoModificador = currentUser?.username ?: "Selenium"

		liquidacion.save(flush:true)
		return liquidacion
	}

	def verificarImportacion(liquidacion, cuenta, fecha){

		def logs = LogImportacion.createCriteria().list() {
			and{
				eq('cuenta', cuenta)
				eq('fecha', fecha)
				eq('estado', Estado.findByNombre('Activo'))
				or{
					eq('compra', true)
					eq('venta', true)
				}
			}
		}.each{
			if (it.compra)
				liquidacion.facturasCompraImportadas = true
			else if (it.venta)
				liquidacion.facturasVentaImportadas = true
			if (liquidacion.facturasVentaImportadas && liquidacion.facturasCompraImportadas) //Para performance, si encuentra que ambas están ya deja de buscar
				return liquidacion
		}

		return liquidacion
	}

	def getCantidadLiquidacionIvasTotales(){
		return LiquidacionIva.count()
	}

	def presentar(Long id){ // En realidad es Autorizar
		LiquidacionIva liquidacionIvaInstance = LiquidacionIva.get(id)
		liquidacionIvaInstance.estado = Estado.findByNombre('Autorizada')
		liquidacionIvaInstance.save(flush:true, failOnError:true)
	}

	def autorizarMes(Long cuentaId, String mes, String ano){ //Salidas: la declaración pendiente si se autorizó o null si no estaba liquidado
		LiquidacionIva liquidacion = getLiquidacionIvaPorCuentaFecha(cuentaId, ano, mes)
		if (liquidacion.estadoUsuario != "Liquidado")
			return null //Sólo autorizaremos si está liquidada
		liquidacion.estado = Estado.findByNombre('Autorizada')
		liquidacion.save(flush:true)

		return declaracionJuradaService.saveDeclaracionJuradaPendientePorLiquidacionIva(liquidacion) //Se genera una declaración Jurada Pendiente
	}
}


