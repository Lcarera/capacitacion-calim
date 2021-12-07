package com.zifras.liquidacion

import com.zifras.cuenta.Pariente
import com.zifras.AccessRulesService
import com.zifras.Estudio

import grails.validation.ValidationException
import grails.transaction.Transactional

import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CondicionIva
import com.zifras.Estado

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

import groovy.json.JsonSlurper

@Transactional
class LiquidacionGananciaService {
	AccessRulesService accessRulesService
	RangoImpuestoGananciaService rangoImpuestoGananciaService
	LiquidacionIvaService liquidacionIvaService
	LiquidacionIIBBService liquidacionIIBBService
	
	def createLiquidacionGananciaCommand(LiquidacionGananciaCommand command){
		def currentUser = accessRulesService.getCurrentUser()
		def estadoActivo = Estado.findByNombre('Activo')
		
		if(command==null)
			command = new LiquidacionGananciaCommand()
		
		command.estadoId = Estado.findByNombre('Liquidado').id
		
		//Si hay una cuenta seteada se busca si tiene una liquidación en el mes anterior
		if(command.cuentaId!=null){
			//Tiene que estar seteado el año
			if(command.ano!=null){
				command = inicializacionLiquidacionGananciaCommand(command)
			}
		}
		
		return command
	}
	
	def inicializacionLiquidacionGananciaCommand(LiquidacionGananciaCommand command){
		def fechaLiquidacion = new LocalDate(command.ano + '-01-01')
		def fechaLiquidacionAnoAnterior = fechaLiquidacion.minusYears(1)
		
		def cuenta = Cuenta.get(command.cuentaId)
		LiquidacionGanancia liquidacionAnterior = LiquidacionGanancia.findByCuentaAndFecha(cuenta, fechaLiquidacionAnoAnterior)
		
		if(liquidacionAnterior!=null){
			command.existenciaInicial = liquidacionAnterior.existenciaFinal
		}else{
			if(command.existenciaInicial==null)
				command.existenciaInicial = 0
		}
		
		//Obtiene la facturación anual
		command.netoVenta = getSumatoriaNetoVentasAnual(command.cuentaId, command.ano)
		command.totalIngresos = command.netoVenta
		command.netoCompra = command.netoCompraSumatoria = getSumatoriaNetoComprasAnual(command.cuentaId, command.ano)
		
		//Obtiene la deduccion por IIBB
		command.ingresosBrutos = getSumatoriaIIBBAnual(command.cuentaId, command.ano)
		command.totalGastosDeducciones =command.ingresosBrutos
		
		def montoDeducibleConyugue = MontoConceptoDeducibleGanancia.findByFechaAndConcepto(fechaLiquidacion, 0)
		def montoDeducibleHijo = MontoConceptoDeducibleGanancia.findByFechaAndConcepto(fechaLiquidacion, 1)
		def montoGananciaNoImponible = MontoConceptoDeducibleGanancia.findByFechaAndConcepto(fechaLiquidacion, 2)
		def montoDeduccionEspecial = MontoConceptoDeducibleGanancia.findByFechaAndConcepto(fechaLiquidacion, 3)
		
		//Estos montos se agregan en el command para ser usados en la vista
		if(montoDeducibleConyugue!=null)
			command.baseConyuge = montoDeducibleConyugue.valor
		else
			command.baseConyuge = 0
			
		if(montoDeducibleHijo!=null)
			command.baseHijo = montoDeducibleHijo.valor
		else
			command.baseHijo = 0
			
		
		if(montoGananciaNoImponible!=null)
			command.baseGNI = montoGananciaNoImponible.valor
		else
			command.baseGNI = 0
			
		if(montoDeduccionEspecial!=null)
			command.baseDE = montoDeduccionEspecial.valor
		else
			command.baseDE = 0
			
		//Con esto aplica los 12 meses de Ganancia No Imponible
		command.mesesGNI = 12
		//Con esto borra los meses de Deduccion Especial
		command.mesesDE = 0
		
		return command
	}
	
	def getSumatoriaNetoVentasAnual(Long cuentaId, String ano){
		def liquidacionesIva = liquidacionIvaService.getLiquidacionesPorCuenta(cuentaId, ano)
		
		def facturacion = new Double(0)
		
			liquidacionesIva?.each{
				if(it.netoCompra)
					facturacion += it.netoVenta
				if(it.netoNoGravadoCompra)
					facturacion -= (it.netoNoGravadoVenta?:0)
				if(it.exentoCompra)
					facturacion -= (it.exentoVenta?:0)
			}
		
		return facturacion.round(2)
	}
	
	def getSumatoriaNetoComprasAnual(Long cuentaId, String ano){
		def liquidacionesIva = liquidacionIvaService.getLiquidacionesPorCuenta(cuentaId, ano)
		
		def facturacion = new Double(0)
		
			liquidacionesIva?.each{
				if(it.netoCompra)
					facturacion += it.netoCompra
				if(it.netoNoGravadoCompra)
					facturacion -= (it.netoNoGravadoCompra?:0)
				if(it.exentoCompra)
					facturacion -= (it.exentoCompra?:0)
			}
		
		return facturacion.round(2)
	}
	
	def getSumatoriaIIBBAnual(Long cuentaId, String ano){
		def liquidacionesIIBB = liquidacionIIBBService.getLiquidacionesPorCuenta(cuentaId, ano)
		
		def iibb = new Double(0)
		
		if(liquidacionesIIBB!=null){
			liquidacionesIIBB.each{
				if(it.impuesto!=null)
					iibb = (iibb + it.impuesto).round(2)
			}
		}
		
		return iibb
	}
	
	def listLiquidacionGanancia() {
		return LiquidacionGanancia.list()
	}
	
	def getLiquidacionGanancia(Long id){
		def liquidacionGananciaInstance = LiquidacionGanancia.get(id)
	}
	
	def getLiquidacionGananciaCommand(Long id){
		LiquidacionGanancia liquidacionGananciaInstance = LiquidacionGanancia.get(id)
		
		if(liquidacionGananciaInstance!=null){
			def command = new LiquidacionGananciaCommand()
			
			command.liquidacionGananciaId = liquidacionGananciaInstance.id
			command.version = liquidacionGananciaInstance.version
			
			if(liquidacionGananciaInstance.cuenta!=null){
				command.cuentaId = liquidacionGananciaInstance.cuenta.id
				command.cuenta = liquidacionGananciaInstance.cuenta.toString()
			}
			
			command.ano = liquidacionGananciaInstance.fecha.toString("YYYY")
			
			command.existenciaInicial = liquidacionGananciaInstance.existenciaInicial
			
			command = inicializacionLiquidacionGananciaCommand(command)
			command.netoCompra = liquidacionGananciaInstance.netoCompra
			/*command.netoVenta = liquidacionGananciaInstance.netoVenta
			command.netoCompra = liquidacionGananciaInstance.netoCompra
			
			command.totalIngresos = liquidacionGananciaInstance.totalIngresos
			command.existenciaInicial = liquidacionGananciaInstance.existenciaInicial
			command.existenciaFinal = liquidacionGananciaInstance.existenciaFinal
			command.ingresosBrutos = liquidacionGananciaInstance.ingresosBrutos
			command.totalGastosDeducciones = liquidacionGananciaInstance.totalGastosDeducciones
			
			command.costoMercaderiaVendida = liquidacionGananciaInstance.costoMercaderiaVendida
			command.costoTotal = liquidacionGananciaInstance.costoTotal
			command.rentaImponible = liquidacionGananciaInstance.rentaImponible
			*/
			liquidacionGananciaInstance.gastosDeducciones.each{
				command.totalGastosDeducciones = (command.totalGastosDeducciones + it.valor).round(2)
			}

			command.baseGNI = liquidacionGananciaInstance.baseGNI
			command.mesesGNI = liquidacionGananciaInstance.mesesGNI
			command.gananciaNoImponible = liquidacionGananciaInstance.gananciaNoImponible
			
			command.baseDE = liquidacionGananciaInstance.baseDE
			command.mesesDE = liquidacionGananciaInstance.mesesDE
			command.deduccionEspecial = liquidacionGananciaInstance.deduccionEspecial
			
			command.subtotalGananciaImponible = liquidacionGananciaInstance.subtotalGananciaImponible
			
			command.gananciaImponible = liquidacionGananciaInstance.gananciaImponible
			command.existenciaFinal = liquidacionGananciaInstance.existenciaFinal
			
			command.retencion = liquidacionGananciaInstance.retencion
			command.percepcion = liquidacionGananciaInstance.percepcion
			command.anticipos = liquidacionGananciaInstance.anticipos
			command.impuestoDebitoCredito = liquidacionGananciaInstance.impuestoDebitoCredito
			
			/*command.impuestoDeterminado = liquidacionGananciaInstance.impuestoDeterminado
			
			command.impuesto = liquidacionGananciaInstance.impuesto*/
			
			command.nota = liquidacionGananciaInstance.nota
			
			/*if(liquidacionGananciaInstance.estado!=null){
				command.estadoId = liquidacionGananciaInstance.estado.id
			}*/
			
			command.estadoId = Estado.findByNombre('Liquidado').id
			
			return command
		} else {
			return null
		}
	}
	
	def getLiquidacionGananciaList(String ano) {
		def lista
		def estado = Estado.findByNombre('Activo')
		def estadoBorrado = Estado.findByNombre('Borrado')
		//Debo traer las cuentas que no sean monotributistas
		def monotributista = CondicionIva.findByNombre('Monotributista')
		def cuentas = Cuenta.createCriteria().list() {
					and{
						ne('condicionIva', monotributista)
						eq('estado', estado)
					}
		};
	
		def salida = []
		
		def fecha = new LocalDate(ano + '-01-01')
		
		cuentas.each{
			def cuenta = it
			def liquidacion = LiquidacionGanancia.findByCuentaAndFecha(cuenta, fecha)
			
			if(liquidacion==null){
				liquidacion = new LiquidacionGanancia()
				liquidacion.cuenta = cuenta
				liquidacion.fecha = fecha
				liquidacion.estado = Estado.findByNombre('Sin liquidar')
			}
			
			salida.push(liquidacion)
		}
		
		return salida
	}
	
	def getLiquidacionesPorCuenta(Long cuentaId) {
		def lista
		def cuenta = Cuenta.get(cuentaId)
		
		def liquidaciones = LiquidacionGanancia.findAllByCuenta(cuenta)
		
		return liquidaciones
	}
	
	def borrarLiquidacionGanancia(Long id){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionGanancia = LiquidacionGanancia.get(id)
		liquidacionGanancia.estado = estadoBorrado
		
		def currentUser = accessRulesService.getCurrentUser()
		liquidacionGanancia.ultimaModificacion = new LocalDateTime()
		liquidacionGanancia.ultimoModificador = currentUser.username
		liquidacionGanancia.save(flush:true, failOnError:true)
		
		return liquidacionGanancia
	}
	
	def deleteLiquidacionGanancia(Long id){
		def liquidacionGananciaInstance = LiquidacionGanancia.get(id)
		liquidacionGananciaInstance.delete(flush:true, failOnError:true)
	}
	
	def saveLiquidacionGanancia(LiquidacionGananciaCommand command){
		def liquidacionGananciaInstance = new LiquidacionGanancia()
		liquidacionGananciaInstance.ultimaModificacion = new LocalDateTime()
		liquidacionGananciaInstance.ultimoModificador = accessRulesService.currentUser.username
		def cuenta
		if(command.cuentaId!=null){
			cuenta = Cuenta.get(command.cuentaId)
			liquidacionGananciaInstance.cuenta = cuenta
		}
		
		liquidacionGananciaInstance.fecha = new LocalDate(command.ano + '-01-01')
		
		liquidacionGananciaInstance.netoVenta = command.netoVenta
		liquidacionGananciaInstance.netoCompra = command.netoCompra
		
		liquidacionGananciaInstance.totalIngresos = command.totalIngresos
		liquidacionGananciaInstance.existenciaInicial = command.existenciaInicial
		liquidacionGananciaInstance.existenciaFinal = command.existenciaFinal
		liquidacionGananciaInstance.ingresosBrutos = command.ingresosBrutos
		liquidacionGananciaInstance.totalGastosDeducciones = command.totalGastosDeducciones		
		
		liquidacionGananciaInstance.costoMercaderiaVendida = command.costoMercaderiaVendida
		
		liquidacionGananciaInstance.costoTotal = command.costoTotal
		
		liquidacionGananciaInstance.rentaImponible = command.rentaImponible
		
		liquidacionGananciaInstance.baseGNI = command.baseGNI
		liquidacionGananciaInstance.mesesGNI = command.mesesGNI
		liquidacionGananciaInstance.gananciaNoImponible = command.gananciaNoImponible
		
		liquidacionGananciaInstance.baseDE = command.baseDE
		liquidacionGananciaInstance.mesesDE = command.mesesDE
		liquidacionGananciaInstance.deduccionEspecial = command.deduccionEspecial
		
		liquidacionGananciaInstance.subtotalGananciaImponible = command.subtotalGananciaImponible
		
		liquidacionGananciaInstance.gananciaImponible = command.gananciaImponible
		
		liquidacionGananciaInstance.retencion = command.retencion
		liquidacionGananciaInstance.percepcion = command.percepcion
		liquidacionGananciaInstance.anticipos = command.anticipos
		liquidacionGananciaInstance.impuestoDebitoCredito = command.impuestoDebitoCredito
		
		liquidacionGananciaInstance.impuestoDeterminado = command.impuestoDeterminado
		
		liquidacionGananciaInstance.impuesto = command.impuesto
		
		liquidacionGananciaInstance.nota = command.nota
		
		liquidacionGananciaInstance.sumatoriaPatrimonioInicial = command.sumatoriaPatrimonioInicial
		liquidacionGananciaInstance.sumatoriaPatrimonioFinal = command.sumatoriaPatrimonioFinal
		liquidacionGananciaInstance.totalPatrimonio = command.totalPatrimonio
		liquidacionGananciaInstance.consumido = command.consumido
		
		liquidacionGananciaInstance.estado = Estado.get(command.estadoId)
		liquidacionGananciaInstance.save(flush:true, failOnError:true)
		
		if((command.gastosDeducciones!="")&&(command.gastosDeducciones!=null)){
			def gastosDeducciones = new JsonSlurper().parseText(command.gastosDeducciones)
			
			gastosDeducciones.each{
				GastoDeduccionGanancia gastoDeduccion = new GastoDeduccionGanancia()
				gastoDeduccion.tipo = TipoGastoDeduccionGanancia.get(it.tipoId)
				gastoDeduccion.valor = new Double(it.valor.replace(",", "."))
				liquidacionGananciaInstance.addToGastosDeducciones(gastoDeduccion)
			}
		}
		
		if((command.deduccionesParientes!="")&&(command.deduccionesParientes!=null)){
			def deduccionesParientes = new JsonSlurper().parseText(command.deduccionesParientes)
			
			deduccionesParientes.each{
				ParienteGanancia deduccionPariente = new ParienteGanancia()
				deduccionPariente.pariente = Pariente.get(it.parienteId)
				deduccionPariente.base = new Double(it.base.replace(",", "."))
				deduccionPariente.meses = new Double(it.meses)
				deduccionPariente.valor = new Double(it.valor.replace(",", "."))
				liquidacionGananciaInstance.addToDeduccionesParientes(deduccionPariente)
			}
		}
		
		if((command.patrimonios!="")&&(command.patrimonios!=null)){
			def patrimonios = new JsonSlurper().parseText(command.patrimonios)
			
			patrimonios.each{
				PatrimonioGanancia patrimonio = new PatrimonioGanancia()
				patrimonio.tipo = TipoPatrimonioGanancia.get(it.tipoId)
				if((it.valorInicial!=null)&&(it.valorInicial!=''))
					patrimonio.valorInicial = new Double(it.valorInicial.replace(",", "."))
				else
					patrimonio.valorInicial = null
					
				patrimonio.detalleInicial = it.detalleInicial
				
				if((it.valorCierre!=null)&&(it.valorCierre!=''))
					patrimonio.valorCierre = new Double(it.valorCierre.replace(",", "."))
				else
					patrimonio.valorCierre = null
				patrimonio.detalleCierre = it.detalleCierre
				liquidacionGananciaInstance.addToPatrimonios(patrimonio)
			}
		}
		
		liquidacionGananciaInstance.save(flush:true, failOnError:true)
		
		return liquidacionGananciaInstance
	}
	
	def updateLiquidacionGanancia(LiquidacionGananciaCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def estadoActivo = Estado.findByNombre('Activo')
		def liquidacionGananciaInstance = LiquidacionGanancia.get(command.liquidacionGananciaId)
		
		if (command.version != null) {
			if (liquidacionGananciaInstance.version > command.version) {
				LiquidacionGananciaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["LiquidacionGanancia"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado al LiquidacionGanancia")
				throw new ValidationException("Error de versión", LiquidacionGananciaCommand.errors)
			}
		}
		
		def cuenta = Cuenta.get(command.cuentaId)
		
		liquidacionGananciaInstance.fecha = new LocalDate(command.ano + '-01-01')
		
		liquidacionGananciaInstance.netoVenta = command.netoVenta
		liquidacionGananciaInstance.netoCompra = command.netoCompra
		
		liquidacionGananciaInstance.totalIngresos = command.totalIngresos
		liquidacionGananciaInstance.existenciaInicial = command.existenciaInicial
		liquidacionGananciaInstance.existenciaFinal = command.existenciaFinal
		liquidacionGananciaInstance.ingresosBrutos = command.ingresosBrutos
		liquidacionGananciaInstance.totalGastosDeducciones = command.totalGastosDeducciones		
		
		liquidacionGananciaInstance.costoMercaderiaVendida = command.costoMercaderiaVendida
		
		liquidacionGananciaInstance.costoTotal = command.costoTotal
		
		liquidacionGananciaInstance.rentaImponible = command.rentaImponible
		
		liquidacionGananciaInstance.baseGNI = command.baseGNI
		liquidacionGananciaInstance.mesesGNI = command.mesesGNI
		liquidacionGananciaInstance.gananciaNoImponible = command.gananciaNoImponible
		
		liquidacionGananciaInstance.baseDE = command.baseDE
		liquidacionGananciaInstance.mesesDE = command.mesesDE
		liquidacionGananciaInstance.deduccionEspecial = command.deduccionEspecial
		
		liquidacionGananciaInstance.subtotalGananciaImponible = command.subtotalGananciaImponible
		
		liquidacionGananciaInstance.gananciaImponible = command.gananciaImponible
		
		liquidacionGananciaInstance.retencion = command.retencion
		liquidacionGananciaInstance.percepcion = command.percepcion
		liquidacionGananciaInstance.anticipos = command.anticipos
		liquidacionGananciaInstance.impuestoDebitoCredito = command.impuestoDebitoCredito
		
		liquidacionGananciaInstance.impuestoDeterminado = command.impuestoDeterminado
		
		liquidacionGananciaInstance.impuesto = command.impuesto
		
		liquidacionGananciaInstance.nota = command.nota
		
		liquidacionGananciaInstance.sumatoriaPatrimonioInicial = command.sumatoriaPatrimonioInicial
		liquidacionGananciaInstance.sumatoriaPatrimonioFinal = command.sumatoriaPatrimonioFinal
		liquidacionGananciaInstance.totalPatrimonio = command.totalPatrimonio
		liquidacionGananciaInstance.consumido = command.consumido
		
		liquidacionGananciaInstance.estado = Estado.get(command.estadoId)
		
		liquidacionGananciaInstance.gastosDeducciones.clear()
		liquidacionGananciaInstance.deduccionesParientes.clear()
		liquidacionGananciaInstance.patrimonios.clear()
		liquidacionGananciaInstance.save(flush:true, failOnError:true)
		
		if((command.gastosDeducciones!="")&&(command.gastosDeducciones!=null)){
			def gastosDeducciones = new JsonSlurper().parseText(command.gastosDeducciones)
			
			gastosDeducciones.each{
				GastoDeduccionGanancia gastoDeduccion = new GastoDeduccionGanancia()
				gastoDeduccion.tipo = TipoGastoDeduccionGanancia.get(it.tipoId)
				gastoDeduccion.valor = new Double(it.valor.replace(",", "."))
				liquidacionGananciaInstance.addToGastosDeducciones(gastoDeduccion)
			}
		}
		
		if((command.deduccionesParientes!="")&&(command.deduccionesParientes!=null)){
			def deduccionesParientes = new JsonSlurper().parseText(command.deduccionesParientes)
			
			deduccionesParientes.each{
				ParienteGanancia deduccionPariente = new ParienteGanancia()
				deduccionPariente.pariente = Pariente.get(it.parienteId)
				deduccionPariente.base = new Double(it.base.replace(",", "."))
				deduccionPariente.meses = new Double(it.meses)
				deduccionPariente.valor = new Double(it.valor.replace(",", "."))
				liquidacionGananciaInstance.addToDeduccionesParientes(deduccionPariente)
			}
		}
		
		if((command.patrimonios!="")&&(command.patrimonios!=null)){
			def patrimonios = new JsonSlurper().parseText(command.patrimonios)
			
			patrimonios.each{
				PatrimonioGanancia patrimonio = new PatrimonioGanancia()
				patrimonio.tipo = TipoPatrimonioGanancia.get(it.tipoId)
				if((it.valorInicial!=null)&&(it.valorInicial!=''))
					patrimonio.valorInicial = new Double(it.valorInicial.replace(",", "."))
				else
					patrimonio.valorInicial = null
					
				patrimonio.detalleInicial = it.detalleInicial
				
				if((it.valorCierre!=null)&&(it.valorCierre!=''))
					patrimonio.valorCierre = new Double(it.valorCierre.replace(",", "."))
				else
					patrimonio.valorCierre = null
				patrimonio.detalleCierre = it.detalleCierre
				liquidacionGananciaInstance.addToPatrimonios(patrimonio)
			}
		}
		
		liquidacionGananciaInstance.save(flush:true, failOnError:true)
		def currentUser = accessRulesService.getCurrentUser()
		liquidacionGananciaInstance.ultimaModificacion = new LocalDateTime()
		liquidacionGananciaInstance.ultimoModificador = currentUser.username
		
		liquidacionGananciaInstance.save(flush:true, failOnError:true)
		
		return liquidacionGananciaInstance
	}
	
	def updateRetencionPercepcionAnticipo(LiquidacionGananciaCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionGananciaInstance = LiquidacionGanancia.get(command.liquidacionGananciaId)
		
		if (command.version != null) {
			if (liquidacionGananciaInstance.version > command.version) {
				LiquidacionGananciaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["LiquidacionGanancia"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado al LiquidacionGanancia")
				throw new ValidationException("Error de versión", LiquidacionGananciaCommand.errors)
			}
		}
		
		if(liquidacionGananciaInstance==null){
			liquidacionGananciaInstance = new LiquidacionGanancia()
			liquidacionGananciaInstance.ultimaModificacion = new LocalDateTime()
			liquidacionGananciaInstance.ultimoModificador = accessRulesService.currentUser.username
			liquidacionGananciaInstance.fecha = new LocalDate(command.ano + '-01-01')
			
			def cuenta
			if(command.cuentaId!=null){
				cuenta = Cuenta.get(command.cuentaId)
				liquidacionGananciaInstance.cuenta = cuenta
			}
		}
		
		if(command.retencion!=null)
			liquidacionGananciaInstance.retencion = command.retencion
		else
			liquidacionGananciaInstance.retencion = 0
			
		if(command.percepcion!=null)
			liquidacionGananciaInstance.percepcion = command.percepcion
		else
			liquidacionGananciaInstance.percepcion = 0
			
		if(command.anticipos!=null)
			liquidacionGananciaInstance.anticipos = command.anticipos
		else
			liquidacionGananciaInstance.anticipos = 0
			
		if(command.impuestoDebitoCredito!=null)
			liquidacionGananciaInstance.impuestoDebitoCredito = command.impuestoDebitoCredito
		else
			liquidacionGananciaInstance.impuestoDebitoCredito = 0
			
		liquidacionGananciaInstance.estado = Estado.findByNombre('Per/Ret ingresado')
		
		def currentUser = accessRulesService.getCurrentUser()
		liquidacionGananciaInstance.ultimaModificacion = new LocalDateTime()
		liquidacionGananciaInstance.ultimoModificador = currentUser.username
		
		liquidacionGananciaInstance.save(flush:true, failOnError:true)
		
		return liquidacionGananciaInstance
	}
	
	def updateNota(LiquidacionGananciaCommand command){
		def estadoBorrado = Estado.findByNombre('Borrado')
		def liquidacionGananciaInstance = LiquidacionGanancia.get(command.liquidacionGananciaId)
		
		if (command.version != null) {
			if (liquidacionGananciaInstance.version > command.version) {
				LiquidacionGananciaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["LiquidacionGanancia"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado al LiquidacionGanancia")
				throw new ValidationException("Error de versión", LiquidacionGananciaCommand.errors)
			}
		}
		
		if(liquidacionGananciaInstance==null){
			liquidacionGananciaInstance = new LiquidacionGanancia()
			liquidacionGananciaInstance.ultimaModificacion = new LocalDateTime()
			liquidacionGananciaInstance.ultimoModificador = accessRulesService.currentUser.username
			liquidacionGananciaInstance.fecha = new LocalDate(command.ano + '-01-01')
			
			def cuenta
			if(command.cuentaId!=null){
				cuenta = Cuenta.get(command.cuentaId)
				liquidacionGananciaInstance.cuenta = cuenta
			}
		}
		
		if(command.nota!=null)
			liquidacionGananciaInstance.nota = command.nota
		else
			liquidacionGananciaInstance.nota = ''
			
		if(liquidacionGananciaInstance.id==null)
			liquidacionGananciaInstance.estado = Estado.findByNombre('Nota ingresada')
		
		def currentUser = accessRulesService.getCurrentUser()
		liquidacionGananciaInstance.ultimaModificacion = new LocalDateTime()
		liquidacionGananciaInstance.ultimoModificador = currentUser.username
		
		liquidacionGananciaInstance.save(flush:true, failOnError:true)
		
		return liquidacionGananciaInstance
	}
	
	def getCantidadLiquidacionGananciasTotales(){
		return LiquidacionGanancia.count()
	}
	
	def getDeduccionesParientesList(Long cuentaId, String ano){
		Cuenta cuenta = Cuenta.get(cuentaId)
		LocalDate fecha = new LocalDate(ano + '-01-01')
		
		LiquidacionGanancia liquidacion = LiquidacionGanancia.findByCuentaAndFecha(cuenta, fecha)
		
		/*if(liquidacion!=null){
			return liquidacion.deduccionesParientes
		}*/
		
		def montoDeducibleConyugue = MontoConceptoDeducibleGanancia.findByFechaAndConcepto(fecha, 0)
		def montoDeducibleHijo = MontoConceptoDeducibleGanancia.findByFechaAndConcepto(fecha, 1)
		
		def montoBaseConyugue = new Double(0)
		def montoBaseHijo = new Double(0)
		
		if(montoDeducibleConyugue!=null){
			montoBaseConyugue = montoDeducibleConyugue.valor
		}
		
		if(montoDeducibleHijo!=null){
			montoBaseHijo = montoDeducibleHijo.valor
		}
			
		
		//Si no se encuentra la liquidación entonces se debe generar la lista según los parientes que tenga la cuenta
		def lista = []
		cuenta.parientes.each{
			ParienteGanancia parienteGanancia = new ParienteGanancia()
			parienteGanancia.pariente = it
			
			//Toma la base que corresponde según el tipo de pariente que sea
			if(it.tipoId==0){
				parienteGanancia.base = montoBaseConyugue
				
				def anoCasamiento = it.fechaCasamiento.getYear()
				def anoPedido = fecha.getYear()
				if(anoCasamiento==anoPedido){
					def meses = 13 - it.fechaCasamiento.getMonthOfYear()
					parienteGanancia.meses = meses
				}else{
					if(anoCasamiento<anoPedido){
						parienteGanancia.meses = 12
					}else{
						parienteGanancia.meses = 0
					}
				}
			}else{
				parienteGanancia.base = montoBaseHijo
				
				def anoNacimiento = it.fechaNacimiento.getYear()
				def anoPedido = fecha.getYear()
				
				if(anoNacimiento==anoPedido){
					def meses = 13 - it.fechaNacimiento.getMonthOfYear()
					parienteGanancia.meses = meses
				}else{
					if(anoNacimiento<anoPedido){
						parienteGanancia.meses = 12
					}else{
						parienteGanancia.meses = 0
					}
				}
			}
			
			parienteGanancia.valor = ((parienteGanancia.base / 12) * parienteGanancia.meses).round(2)
			lista.push(parienteGanancia)
		}
		
		return lista
	}
	
	def getGastosDeduccionesList(Long cuentaId, String ano){
		Cuenta cuenta = Cuenta.get(cuentaId)
		LocalDate fecha = new LocalDate(ano + '-01-01')
		
		LiquidacionGanancia liquidacion = LiquidacionGanancia.findByCuentaAndFecha(cuenta, fecha)
		
		if(liquidacion!=null){
			if(liquidacion.gastosDeducciones.size()!=0)
				return liquidacion.gastosDeducciones
		}

		//SE ANULA LO SIGUIENTE, PARA NO TRAER LOS GASTOS DE LA LIQUIDACION DEL AñO ANTERIOR
		
		//Si no se encontró la liquidación, entonces es una liquidación nueva.
		//Entonces se busca la liquidación del año anterior y si existe se devuelve una copia de los gastos/deducciones de esa liquidación
		//si no hay, se devuelve una lista vacía
		
		//def fechaLiquidacionAnoAnterior = fecha.minusYears(1)
		//LiquidacionGanancia liquidacionAnterior = LiquidacionGanancia.findByCuentaAndFecha(cuenta, fechaLiquidacionAnoAnterior)
		
		//Si no se encuentra la liquidación entonces se debe generar la lista según los parientes que tenga la cuenta
		def lista = []
		
		/*if(liquidacionAnterior!=null){
			liquidacionAnterior.gastosDeducciones.each{
				GastoDeduccionGanancia gastoDeduccionGanancia = new GastoDeduccionGanancia()
				gastoDeduccionGanancia.tipo = it.tipo
				gastoDeduccionGanancia.valor = it.valor
				gastoDeduccionGanancia.id = -1
				
				lista.push(gastoDeduccionGanancia)
			}
		}*/
		
		return lista
	}
	
	def getPatrimoniosList(Long cuentaId, String ano){
		Cuenta cuenta = Cuenta.get(cuentaId)
		LocalDate fecha = new LocalDate(ano + '-01-01')
		
		LiquidacionGanancia liquidacion = LiquidacionGanancia.findByCuentaAndFecha(cuenta, fecha)
		
		if(liquidacion!=null){
			if(liquidacion.patrimonios.size()!=0)
				return liquidacion.patrimonios
		}
		
		//Si no se encontró la liquidación, entonces es una liquidación nueva.
		//Entonces se busca la liquidación del año anterior y si existe se devuelve una copia de los gastos/deducciones de esa liquidación
		//si no hay, se devuelve una lista vacía
		
		def fechaLiquidacionAnoAnterior = fecha.minusYears(1)
		LiquidacionGanancia liquidacionAnterior = LiquidacionGanancia.findByCuentaAndFecha(cuenta, fechaLiquidacionAnoAnterior)
		
		//Si no se encuentra la liquidación entonces se debe generar la lista según los parientes que tenga la cuenta
		def lista = []
		
		if(liquidacionAnterior!=null){
			liquidacionAnterior.patrimonios.each{
				// Si existe el patrimonio anterior y su valor de cierre es distinto de null
				if(it.valorCierre!=null){
					PatrimonioGanancia patrimonio = new PatrimonioGanancia()
					patrimonio.tipo = it.tipo
					patrimonio.valorInicial = it.valorCierre
					patrimonio.detalleInicial = it.detalleCierre
					patrimonio.detalleCierre = ""
					patrimonio.id = -1
					
					lista.push(patrimonio)
				}
			}
		}else{
			//Se debe devolver el patrimonio de Mercaderías, pero se debe calcular el valor inicial y final que debe tener
			TipoPatrimonioGanancia tipo = TipoPatrimonioGanancia.get(32419)
			PatrimonioGanancia patrimonio = new PatrimonioGanancia()
			patrimonio.tipo = tipo
			patrimonio.valorInicial = 0
			patrimonio.valorCierre = null
			patrimonio.detalleInicial = ""
			patrimonio.detalleCierre = ""
			patrimonio.id = -1
			
			lista.push(patrimonio)
		}
		
		return lista
	}
}