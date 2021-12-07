package com.zifras.ticket

import com.zifras.cuenta.Cuenta
import com.zifras.ventas.Horario
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

class SoporteService {
	
	Integer indiceTurno = 0

	def elementosFaqCuenta(Long cuentaId){
		def cuenta = Cuenta.get(cuentaId)
		def elementosFaq = ElementoFaq.getAll()
		def condicionesCuenta = []
		def elementosCuenta = []

		condicionesCuenta = getCondicionesCuenta(cuentaId)
		condicionesCuenta.each{
			elementosCuenta  += elementosFaq.findAll{el -> el[it]}
		}
		elementosCuenta = elementosCuenta.unique{a,b -> a.id<=>b.id}.sort{it.peso}

		return elementosCuenta
	}

	def getCondicionesCuenta(Long cuentaId){
		def cuenta = Cuenta.get(cuentaId)
		def condicionIva = cuenta.condicionIva.nombre
		def condicionIibb = cuenta.regimenIibb.nombre
		def condiciones = []

		if(condicionIva == "Monotributista")
			condiciones.push("monotributista")
		else{
			if(condicionIva == "Responsable inscripto")
				condiciones.push("respInscripto")
			else{
				condiciones.push("respInscripto")
				condiciones.push("monotributista")
			}
		}

		if(condicionIibb.contains("Convenio"))
			condiciones.push("convenio")
		else{
			if((condicionIibb == "B.A. Mensual") || (condicionIibb == "Sicol"))
				condiciones.push("local")
			else{
				if(condicionIibb == "Simplificado")
					condiciones.push("regimenSimplificado")
			}
		}
		return condiciones
	}

	def getCategoriasFaq(){
		return CategoriaFaq.getAll().sort{it.peso}.collect{cat -> cat.nombre}
	}

	def crearEmpleadoSoporte(String nombre, String email, String celular){
		def empleado = new EmpleadoSoporte()
		empleado.nombre = nombre
		empleado.email = email
		empleado.celular = celular
		empleado.vacaciones = false
		empleado.save(flush:true, failOnError:true)
		return "Se creó el Empleado Soporte correctamente"
	}

	def editarEmpleadoSoporte(String id, String nombre, String email, String celular, String cuentaGoogle, Boolean vacaciones){
		def empleado = EmpleadoSoporte.get(id)
		if(empleado){
			empleado.nombre = nombre
			empleado.email = email
			empleado.celular = celular
			empleado.cuentaGoogle = cuentaGoogle
			empleado.vacaciones = vacaciones
			empleado.save(flush:true, failOnError:true)
			return "Se editó el Empleado Soporte correctamente"
		}
		else
			throw new Exception("Vendedor inexistente")
	}

	def deshabilitarEmpleadoSoporte(String id){
		def empleado = EmpleadoSoporte.get(id)
		if(!empleado)
			throw new Exception("Empleado Soporte inexistente")
		empleado.deshabilitado = true
		empleado.save(flush:true,failOnError:true)
		return "Empleado Soporte deshabilitado correctamente"
	}

	def editarHorario(params){

		def empleado = EmpleadoSoporte.get(params.empleadoSoporteId)
		if(!empleado)
			throw new Exception("Empleado Soporte inexistente")
		def horario = empleado.horario
		if(horario == null) 
			horario = new Horario()
		horario.setHorario("lunes",params.lunesEntrada,params.lunesSalida)
		horario.setHorario("martes",params.martesEntrada,params.martesSalida)
		horario.setHorario("miercoles",params.miercolesEntrada,params.miercolesSalida)
		horario.setHorario("jueves",params.juevesEntrada,params.juevesSalida)
		horario.setHorario("viernes",params.viernesEntrada,params.viernesSalida)
		horario.save(flush:true,failOnError:true)
		empleado.horario = horario
		empleado.save(flush:true,failOnError:true)

		return "Empleado Soporte configurado correctamente"
	}

	def getEmpleadoSoporteAAsignar(){
		def empleados = getEmpleadosSoporteDeTurno()
		indiceTurno = indiceTurno >= (empleados.size() - 1) ? 0 : (indiceTurno + 1)
		return empleados[this.indiceTurno]
	}

	def listEmpleadosSoporteActivos(){
		return EmpleadoSoporte.getAll().findAll{!it.deshabilitado}
	}

	def listHorariosEmpleadosSoporte(){
		return Horario.getAll()
	}
	 
	def horaActual(){
		def hora = new Integer(new LocalDateTime().toString("HH")) - 3
		return hora
	}

	def getEmpleadosSoporteDeTurno(){
		def hora = horaActual()
		def diaHoy = diaActual()
		if(diaHoy == "sabado")
			return listEmpleadosSoporteActivos()
		if(diaHoy == "domingo"){
			diaHoy = "lunes"
			hora = 9
		}
		return EmpleadoSoporte.getAll().findAll{e -> !e.deshabilitado && e.deTurno(hora, diaHoy)}.findAll{e -> !e.vacaciones}.sort{it.nombre}
	}

	def diaActual(){
		def dia = new LocalDate().getDayOfWeek()

		switch (dia){
			case 7:
				return "domingo"
				break
			case 1:
				return "lunes"
				break
			case 2:
				return "martes"
				break
			case 3:
				return "miercoles"
				break
			case 4:
				return "jueves"
				break
			case 5:
				return "viernes"
				break
			case 6:
				return "sabado"
				break
		}
	}

	

}