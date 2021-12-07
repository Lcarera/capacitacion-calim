package com.zifras.cuenta

import com.zifras.Estudio
import com.zifras.servicio.ItemServicioEspecial
import com.zifras.Estado

import com.zifras.AccessRulesService
import grails.validation.ValidationException
import grails.transaction.Transactional
import groovy.json.JsonSlurper
import org.joda.time.LocalDate
import org.joda.time.Months
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols

@Transactional
class MoratoriaService {

	def getPlanMoratoriaCommand(Long id){
			def planMoratoriaInstance = PlanMoratoria.get(id)

			if(planMoratoriaInstance!=null){
				def command = new PlanMoratoriaCommand()

				command.planMoratoriaId = id
				command.inicio = planMoratoriaInstance.inicio
				command.fin = planMoratoriaInstance.fin
				command.estadoId = planMoratoriaInstance.estado?.id
				command.servicioEspecialId = planMoratoriaInstance.servicioEspecial?.id
				command.cliente = planMoratoriaInstance.cliente

				return command
			} else {
				return null
			}
		}
	def savePlanMoratoria(PlanMoratoriaCommand command){
		def planMoratoria = new PlanMoratoria()
		def cuenta = Cuenta.get(command.cuentaId)

		planMoratoria.inicio = command.inicio
		planMoratoria.fin = command.inicio.plusMonths(command.cantidadCuotas.intValue()).withDayOfMonth(20)
		planMoratoria.cuenta = cuenta
		planMoratoria.servicioEspecial = ItemServicioEspecial.get(command.servicioEspecialId)
		planMoratoria.estado = Estado.findByNombre("Abierto")

		if((command.cuotas!="")&&(command.cuotas!=null)){
			def cuotas = new JsonSlurper().parseText(command.cuotas)

			cuotas.each{
				def cuota = new CuotaMoratoria()
				cuota.numero = new Long(it.numero)
				cuota.importe = new Double(it.importe.toString().replace(',', '.'))
				cuota.save(flush:true,failOnError:true)
				planMoratoria.addToCuotas(cuota)
			}
		}

		planMoratoria.save(flush:true,failOnError:true)

		cuenta.addToPlanesMoratoria(planMoratoria)
		cuenta.save(flush:true,failOnError:true)
	}

	def listCuentasMoratoria(String filter){
		def lista
		def estado = Estado.findByNombre('Activo')

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
			lista = Cuenta.findAllByEstado(estado)
		}

		def moratoriaPaga = lista.findAll{it.moratoriaPaga()}

		return moratoriaPaga
	}

	def cerrarPlanesVencidos(){
		def lista
		def estado = Estado.findByNombre("Abierto")
		lista = PlanMoratoria.findAllByEstado(estado)
		lista.collect{
			if(it.vencido()){
				it.cerrarPlan()
				it.save(flush:true,failOnError:true)
			}
		}
	}

	def listCuotasPlan(Long planMoratoriaId){
		def plan = PlanMoratoria.get(planMoratoriaId)
		def cuotas = plan.cuotas
		return cuotas
	}

	def listServiciosMoratoriaCuenta(Long cuentaId){
		def cuenta = Cuenta.get(cuentaId)

		return cuenta.serviciosMoratoriaPagos()
	}

	def listPlanesMoratoria(){
		def lista

		lista = PlanMoratoria.getAll()

		return lista
	}

}

