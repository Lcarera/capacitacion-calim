package com.zifras.ventas

import grails.transaction.Transactional
import grails.validation.ValidationException
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.ui.RegistrationCode
import com.zifras.notificacion.NecesitoAyudaLog
import com.zifras.TokenGoogle

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

@Transactional
class VendedorService{

	Integer indiceTurno = 0
	Integer indiceAyuda = 0

	def crearVendedor(String nombre, String email, String celular, String cuentaGoogle){
		def vendedor = new Vendedor()
		vendedor.nombre = nombre
		vendedor.email = email
		vendedor.celular = celular
		vendedor.cuentaGoogle = cuentaGoogle
		def token = TokenGoogle.findByUsuario("Cuenta Contactos " + nombre)
		if(token)
			vendedor.tokenGoogle = token
		vendedor.vacaciones = false
		vendedor.save(flush:true, failOnError:true)
		return "Se creó el vendedor correctamente"
	}

	def editarVendedor(String id, String nombre, String email, String celular, String cuentaGoogle, Boolean vacaciones){
		def vendedor = Vendedor.get(id)
		if(vendedor){
			vendedor.nombre = nombre
			vendedor.email = email
			vendedor.celular = celular
			if(vendedor.cuentaGoogle != cuentaGoogle){
				def token = TokenGoogle.findByUsuario("Cuenta Contactos " + cuentaGoogle.split("@")[0].split("\\.")[2].capitalize())
				if(token)
					vendedor.tokenGoogle = token
				else
					throw new Exception("No se encontró un Token Google con el nombre de ese Email")
			}
			vendedor.cuentaGoogle = cuentaGoogle
			vendedor.vacaciones = vacaciones
			vendedor.save(flush:true, failOnError:true)
			return "Se editó el vendedor correctamente"
		}
		else
			throw new Exception("Vendedor inexistente")
	}

	def deshabilitarVendedor(String id){
		def vendedor = Vendedor.get(id)
		if(!vendedor)
			throw new Exception("Vendedor inexistente")
		vendedor.deshabilitado = true
		vendedor.save(flush:true,failOnError:true)
		return "Vendedor deshabilitado correctamente"
	}

	def generarHorarios(){
		def vendedores = Vendedor.getAll()
		def entrada
		def salida

		vendedores.each{
			def horario = new Horario()
			if(it.turnoManana){
				entrada = '9'
				salida = '14'
			}else{
				entrada = '14'
				salida = '21'
			}
			horario.setHorario("lunes",entrada,salida)
			horario.setHorario("martes",entrada,salida)
			horario.setHorario("miercoles",entrada,salida)
			horario.setHorario("jueves",entrada,salida)
			horario.setHorario("viernes",entrada,salida)
			horario.save(flush:true,failOnError:true)
			it.horario = horario
			it.save(flush:true,failOnError:true)
		}

	}

	def editarHorario(params){

		def vendedor = Vendedor.get(params.vendedorId)
		if(!vendedor)
			throw new Exception("Vendedor inexistente")
		def horario = vendedor.horario
		if(vendedor.horario == null) 
			horario = new Horario()
		horario.setHorario("lunes",params.lunesEntrada,params.lunesSalida)
		horario.setHorario("martes",params.martesEntrada,params.martesSalida)
		horario.setHorario("miercoles",params.miercolesEntrada,params.miercolesSalida)
		horario.setHorario("jueves",params.juevesEntrada,params.juevesSalida)
		horario.setHorario("viernes",params.viernesEntrada,params.viernesSalida)
		horario.save(flush:true,failOnError:true)
		vendedor.horario = horario
		vendedor.save(flush:true,failOnError:true)

		return "Horario configurado correctamente"
	}

	def getVendedorAAsignar(){
		VendedorDiaExtra diaExtra = VendedorDiaExtra.findByFecha(new LocalDate())
		if(diaActual() == "viernes" && horaActual() >= 21)
			diaExtra = VendedorDiaExtra.findByFecha(new LocalDate().plusDays(1))
		def vendedor
		if(!diaExtra || !diaExtra?.vendedor || (diaActual() == "sabado" && horaActual() >= 16)){
			def vendedores = getVendedoresDeTurno()
			indiceTurno = indiceTurno >= (vendedores.size() - 1) ? 0 : (indiceTurno + 1)
			vendedor = vendedores[this.indiceTurno]
		}
		else{
			vendedor = diaExtra.vendedor
		}

		return vendedor
	}

	def getVendedorAsignado(){
		VendedorDiaExtra diaExtra = VendedorDiaExtra.findByFecha(new LocalDate())
		def nombre
		if(!diaExtra || !diaExtra?.vendedor){
			def vendedores
			Integer index

			vendedores = getVendedoresDeTurno()
			index = indiceTurno == 0 ? (vendedores.size() - 1) : (indiceTurno - 1)
			nombre = vendedores[index].nombre
		}
		else{
			def vendedor = diaExtra.vendedor 
			nombre = vendedor.nombre
		}
			return nombre
	}

	def getVendedorNecesitoAyuda(Boolean ayuda, Boolean instagram = false){
		String urlWppVendedor
		VendedorDiaExtra diaExtra = VendedorDiaExtra.findByFecha(new LocalDate())
		def vendedor

		if(!diaExtra || !diaExtra?.vendedor){
			def vendedores = getVendedoresDeTurno()

			indiceAyuda = indiceAyuda >= (vendedores.size() - 1) ? 0 : (indiceAyuda + 1)
			vendedor = vendedores[indiceAyuda]
			urlWppVendedor = "https://api.whatsapp.com/send?phone=" + vendedor.celular	
		}
		else{
			vendedor = diaExtra.vendedor
			urlWppVendedor = "https://api.whatsapp.com/send?phone=" + vendedor.celular	
		}
		guardarNecesitoAyuda(vendedor.id, instagram)
		if(instagram)
			urlWppVendedor += "&text=Hola%21%20Los%20vi%20en%20Instagram%20y%20me%20gustar%C3%ADa%20hacerles%20una%20consulta."
		else if(ayuda)
			urlWppVendedor += "&text=Hola%21%20Necesito%20ayuda."
		else
			urlWppVendedor += "&text=Hola%21%20Quiero%20contactarme%20con%20mi%20contador%20asignado."

		return urlWppVendedor 
	}

	def listDiasExtra(){
		return VendedorDiaExtra.getAll().findAll{it.fecha.isAfter(new LocalDate().minusMonths(1).minusWeeks(2))}
	}

	def listVendedoresActivos(){
		return Vendedor.getAll().findAll{!it.deshabilitado}
	}

	def listHorariosVendedores(){
		return Horario.getAll()
	}

	def definirFechasFinDeSemana(){
		LocalDate fechaFin =  LocalDate.parse("2021-12-31")
		LocalDate hoy = new LocalDate()

		for (LocalDate date = hoy; date.isBefore(fechaFin); date = date.plusDays(1))
		{
		    if(date.getDayOfWeek() == 6 || date.getDayOfWeek() == 7){
				def diaExtra = new VendedorDiaExtra()
				if (!VendedorDiaExtra.findByFecha(date)){
			    	diaExtra.fecha = date
			    	diaExtra.detalle = "Fin de semana"
			    	diaExtra.save(flush:true,failOnError:true)
			    }
		    }
		}
	}

	def eliminarDomingos(){
		LocalDate fechaFin =  LocalDate.parse("2021-12-31")
		LocalDate hoy = new LocalDate()

		for (LocalDate date = hoy; date.isBefore(fechaFin); date = date.plusDays(1))
		{
		    if(date.getDayOfWeek() == 7){
				def diaExtra = VendedorDiaExtra.findByFecha(date)
			    diaExtra.delete(flush:true,failOnError:true)
		    }
		}
	}
	 

	def definirFechasFeriado(){
		def listaFeriados = ["02-15", "02-16", "03-24", "04-01", "04-02", "05-24", "05-25", "06-21", "07-09", "08-16", "10-08", "10-11", "11-22", "12-08", "12-24", "12-31"]
		listaFeriados.each{
			LocalDate fecha = LocalDate.parse("2021-" + it)
			def diaExtra = new VendedorDiaExtra()
			if(!VendedorDiaExtra.findByFecha(fecha)){
				diaExtra.fecha = fecha
				diaExtra.detalle = "Feriado"
				diaExtra.save(flush:true,failOnError:true)
			}
		}
	}

	def vendedorTrabajaDiaExtra(String vendedorEmail ,Long fechaId){
		def vendedor = Vendedor.findByEmail(vendedorEmail)
		def diaExtra = VendedorDiaExtra.get(fechaId)
		String mensaje

		if(!diaExtra.vendedor){
			diaExtra.vendedor = vendedor
			mensaje = "Se te asignó el día extra correctamente!"
		}
		else{
			if(diaExtra.vendedor.id == vendedor.id){
				diaExtra.vendedor = null
				mensaje = "Te desasignaste el dia extra correctamente!"
			}
			else
				throw new Exception("El dia seleccionado ya se encuentra asignado a otro vendedor")
		}
		diaExtra.save(flush:true, failOnError:true)
		return mensaje
	}

	def guardarNecesitoAyuda(Long vendedorId, Boolean instagram){
		def vendedor = Vendedor.get(vendedorId)
		NecesitoAyudaLog log = new NecesitoAyudaLog()
		log.fechaHora = new LocalDateTime()
		log.vendedor = vendedor
		log.instagram = instagram
		log.save(flush:true,failOnError:true)
	}

	def horaActual(){
		def hora = new Integer(new LocalDateTime().toString("HH")) - 3
		return hora
	}

	def getVendedoresDeTurno(){
		def hora = horaActual()
		def diaHoy = diaActual()
		if(diaHoy == "sabado" || diaHoy == "domingo"){
			diaHoy = "lunes"
			hora = 9
		}
		return Vendedor.getAll().findAll{v -> !v.deshabilitado && v.deTurno(hora, diaHoy)}.findAll{v -> !v.vacaciones}.sort{it.nombre}
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
