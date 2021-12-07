package com.zifras.documento

import com.zifras.AccessRulesService
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.Localidad
import com.zifras.Provincia
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.MovimientoCuentaService
import com.zifras.liquidacion.LiquidacionGanancia
import com.zifras.liquidacion.LiquidacionIIBB
import com.zifras.liquidacion.LiquidacionIva

import grails.config.Config
import grails.transaction.Transactional
import grails.validation.ValidationException
import groovy.json.JsonSlurper
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import org.springframework.web.multipart.MultipartFile

@Transactional
class DeclaracionJuradaService {
	AccessRulesService accessRulesService
	def grailsApplication
	def movimientoCuentaService
	
	def createDeclaracionJuradaCommand(){
		def command = new DeclaracionJuradaCommand()
		command.fecha = new LocalDate()
		return command
	}

	private saveDeclaracionJurada(DeclaracionJurada declaracionJuradaInstance, DeclaracionJuradaCommand command, MultipartFile archivo, Double importe){
		declaracionJuradaInstance.cuenta = Cuenta.get(command.cuentaId)

		declaracionJuradaInstance.fecha = new LocalDate()
		declaracionJuradaInstance.descripcion = command.descripcion
		declaracionJuradaInstance.estado = Estado.get(command.estadoId) ?: Estado.findByNombre("Presentada")

		declaracionJuradaInstance = guardarArchivo(declaracionJuradaInstance, archivo)
		declaracionJuradaInstance.save(flush:true)

		//movimientoCuentaService.saveMovimientoCuentaDDJJ(declaracionJuradaInstance, importe)

		return declaracionJuradaInstance
	}

	private DeclaracionJurada guardarArchivo(DeclaracionJurada declaracionJuradaInstance, MultipartFile archivo){
		declaracionJuradaInstance.nombreOriginal = declaracionJuradaInstance.nombreArchivo = archivo.originalFilename
		String cuentaPath = declaracionJuradaInstance.cuenta.getPath()
		String pathDDJJ = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/ddjj/"

		File carpeta = new File(pathDDJJ)
		if(!carpeta.exists())
			carpeta.mkdirs()

		String fullPath = pathDDJJ + declaracionJuradaInstance.nombreOriginal
		int versionArchivo = 0
		while((new File(fullPath)).exists()){
			versionArchivo++
			fullPath = pathDDJJ + declaracionJuradaInstance.nombreOriginal + " (" + versionArchivo.toString() + ")"
		}
		if (versionArchivo>0)
			declaracionJuradaInstance.nombreArchivo += " (" + versionArchivo.toString() + ")"
		archivo.transferTo(new File(fullPath))

		return declaracionJuradaInstance
	}

	def saveDeclaracionJuradaPorLiquidacionIva(DeclaracionJuradaCommand command,MultipartFile archivo){
		def liquidacion = LiquidacionIva.get(command.liquidacionId)
		def declaracionJuradaInstance = DeclaracionJurada.findByLiquidacionIva(liquidacion)
		if (! declaracionJuradaInstance){
			declaracionJuradaInstance = new DeclaracionJurada()
			declaracionJuradaInstance.liquidacionIva = liquidacion
		}
		declaracionJuradaInstance.liquidacionIva.estado = Estado.findByNombre("Presentada")
		declaracionJuradaInstance.liquidacionIva.save(flush:true, failOnError:true)
		Double importe = declaracionJuradaInstance.liquidacionIva?.saldoDdjj
		return saveDeclaracionJurada(declaracionJuradaInstance, command, archivo, importe)
	}

	def saveDeclaracionJuradaPorLiquidacionIibb(DeclaracionJuradaCommand command,MultipartFile archivo){
		def liquidacion = LiquidacionIIBB.get(command.liquidacionId)
		def declaracionJuradaInstance = DeclaracionJurada.findByLiquidacionIibb(liquidacion)
		if (! declaracionJuradaInstance){
			declaracionJuradaInstance = new DeclaracionJurada()
			declaracionJuradaInstance.liquidacionIibb = liquidacion
		}

		declaracionJuradaInstance.liquidacionIibb.with{ LiquidacionIIBB.findAllByCuentaAndFecha(cuenta, fecha) }*.with{
			estado = Estado.findByNombre("Presentada")
			save(flush:true)
		}
		Double importe = declaracionJuradaInstance.liquidacionIibb?.saldoDdjj
		return saveDeclaracionJurada(declaracionJuradaInstance, command, archivo, importe)
	}

	def saveDeclaracionJuradaPorLiquidacionGanancia(DeclaracionJuradaCommand command,MultipartFile archivo){
		def declaracionJuradaInstance = new DeclaracionJurada()

		declaracionJuradaInstance.liquidacionGanancia = LiquidacionGanancia.get(command.liquidacionId)
		Double importe = declaracionJuradaInstance.liquidacionGanancia?.impuesto
		return saveDeclaracionJurada(declaracionJuradaInstance, command, archivo, importe)
	}

	def saveDeclaracionJuradaPendientePorLiquidacionIva(LiquidacionIva liquidacion){
		def declaracionJuradaInstance = DeclaracionJurada.findByLiquidacionIva(liquidacion)
		if(declaracionJuradaInstance==null)
			declaracionJuradaInstance = new DeclaracionJurada()

		declaracionJuradaInstance.cuenta = liquidacion.cuenta	
		declaracionJuradaInstance.liquidacionIva = liquidacion
		declaracionJuradaInstance.fecha = new LocalDate()
		declaracionJuradaInstance.nombreArchivo = "-"
		declaracionJuradaInstance.nombreOriginal = "-"
		declaracionJuradaInstance.descripcion = "IVA " + liquidacion.fecha.toString('MM') + "/" + liquidacion.fecha.toString('YYYY')
		declaracionJuradaInstance.estado = Estado.findByNombre('Pendiente')
		declaracionJuradaInstance.save(flush:true)

		Double importe = liquidacion.saldoDdjj
		//movimientoCuentaService.saveMovimientoCuentaDDJJ(declaracionJuradaInstance, importe)

		return declaracionJuradaInstance
	}

	def saveDeclaracionJuradaPendientePorLiquidacionIibb(LiquidacionIIBB liquidacion){
		def declaracionJuradaInstance = DeclaracionJurada.findByLiquidacionIibb(liquidacion)
		if(declaracionJuradaInstance==null)
			declaracionJuradaInstance = new DeclaracionJurada()

		declaracionJuradaInstance.cuenta = liquidacion.cuenta	
		declaracionJuradaInstance.liquidacionIibb = liquidacion
		declaracionJuradaInstance.fecha = new LocalDate()
		declaracionJuradaInstance.nombreArchivo = "-"
		declaracionJuradaInstance.nombreOriginal = "-"
		declaracionJuradaInstance.descripcion = "Ingresos brutos " + liquidacion.provincia.nombre + " " + liquidacion.fecha.toString('MM') + "/" + liquidacion.fecha.toString('YYYY')
		declaracionJuradaInstance.estado = Estado.findByNombre('Pendiente')
		declaracionJuradaInstance.save(flush:true)

		Double importe = liquidacion.saldoDdjj
		//movimientoCuentaService.saveMovimientoCuentaDDJJ(declaracionJuradaInstance, importe)

		return declaracionJuradaInstance
	}

	def getFile(Long id){
		def usuario = accessRulesService.getCurrentUser()
		def declaracionJuradaInstance = DeclaracionJurada.get(id)
		if (!declaracionJuradaInstance)
			throw new Exception("no existe")
		if (usuario.hasRole("ROLE_CUENTA") && (usuario.cuenta?.id != declaracionJuradaInstance?.cuenta?.id))
			throw new Exception("permisos")
		String nombre = declaracionJuradaInstance.nombreArchivo
		String cuentaPath = declaracionJuradaInstance.cuenta.getPath()
		
		def file = new File(System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/ddjj/" + nombre)

		return file
	}
	
	def listDeclaracionJurada(String filter,Long cuentaId) {
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		lista = DeclaracionJurada.createCriteria().list() {
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}
			if(filter!=null)
				ilike('descripcion', '%' + filter + '%')
		
			order('descripcion', 'asc')
		}				
		return lista
	}

	def listDeclaracionesJuradasPresentadasPorCuenta(String cuentaId) {
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		def estadoInstance = Estado.findByNombre("Presentada")
		lista = DeclaracionJurada.createCriteria().list() {
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}
				eq('estado', estadoInstance)
				isNull("comprobantePago")

		}			
		return lista
	}
	def listDeclaracionesJuradasPresentadasPorCuentaEdit(String cuentaId) {
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		def estadoInstance = Estado.findByNombre("Presentada")
		lista = DeclaracionJurada.createCriteria().list() {
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}
				eq('estado', estadoInstance)

		}			
		return lista
	}
	
	def getDeclaracionJurada(Long id){
		def declaracionJuradaInstance = DeclaracionJurada.get(id)
	}
	
	def getDeclaracionJuradaCommand(Long id){
		def declaracionJuradaInstance = DeclaracionJurada.get(id)
		
		if(declaracionJuradaInstance!=null){
			def command = new DeclaracionJuradaCommand()
			
			command.declaracionJuradaId = declaracionJuradaInstance.id
			command.version = declaracionJuradaInstance.version
			command.cuentaId = declaracionJuradaInstance.cuenta.id
			command.fecha = declaracionJuradaInstance.fecha
			command.descripcion = declaracionJuradaInstance.descripcion
			command.nombreArchivo = declaracionJuradaInstance.nombreArchivo
			command.estadoId = declaracionJuradaInstance.estado?.id

			return command
		} else {
			return null
		}
	}
	
	def getDeclaracionJuradaList() {
		lista = DeclaracionJurada.list();
	}
	
	def deleteDeclaracionJurada(Long id){
		def declaracionJuradaInstance = DeclaracionJurada.get(id)

		borrarArchivo(declaracionJuradaInstance)
		movimientoCuentaService.deleteMovimientoCuentaDDJJ(declaracionJuradaInstance)
		declaracionJuradaInstance.cuenta.removeFromDeclaracionesJuradas(declaracionJuradaInstance).save(flush:true)
	}

	private def borrarArchivo(DeclaracionJurada declaracion){
		String nombre = declaracion.nombreArchivo
		String cuentaPath = declaracion.cuenta.path
		String ruta = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/ddjj/" + nombre
		(new File(ruta)).delete()
	}

	def updateDeclaracionJurada(DeclaracionJuradaCommand command, MultipartFile archivo){
		def declaracionJuradaInstance = DeclaracionJurada.get(command.declaracionJuradaId)
		
		if (command.version != null) {
			if (declaracionJuradaInstance.version > command.version) {
				DeclaracionJuradaCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["DeclaracionJurada"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el Declaracion Jurada")
				throw new ValidationException("Error de versión", DeclaracionJuradaCommand.errors)
			}
		}
		
		declaracionJuradaInstance.fecha = command.fecha
		declaracionJuradaInstance.descripcion = command.descripcion
		declaracionJuradaInstance.estado = Estado.get(command.estadoId)

		if(!archivo.isEmpty()){
			borrarArchivo(declaracionJuradaInstance)
			guardarArchivo(declaracionJuradaInstance, archivo)
		}

		declaracionJuradaInstance.save(flush:true)
		
		return declaracionJuradaInstance
	}
	
	def getCantidadDeclaracionJuradasTotales(){
		return DeclaracionJurada.count()
	}

	def getDeclaracionJuradaListPorMes(Cuenta cuenta, String ano, String mes){
		def fechaBuscada = new LocalDate(ano + '-' + mes + '-01')
		return DeclaracionJurada.createCriteria().list() {
			and{
				eq("cuenta", cuenta)
				ge("fecha", fechaBuscada)
				lt("fecha", fechaBuscada.plusMonths(1))
			}
		}
	}

	static def getDeclaracionJuradaListIIBB(String ano, String mes){
		LocalDate fechaBuscada = new LocalDate(ano + '-' + mes + '-01')
		return DeclaracionJurada.createCriteria().list() {
			and{
				isNotNull("liquidacionIibb")
			}
		}.findAll { declaracion ->
			LocalDate fechaDeclaracion = declaracion.liquidacion.fecha
			return (fechaDeclaracion >= fechaBuscada && fechaDeclaracion < fechaBuscada.plusMonths(1))
		}
	}

	def importar(archivo){
		def nombre = org.apache.commons.io.FilenameUtils.removeExtension(archivo.originalFilename).split() //Le saco la extensión antes de hacer el Split, para que no moleste a la hora de analizar el nombre
		Cuenta cuenta = Cuenta.findByCuit(nombre[0].replaceAll("-",""))
		assert cuenta?.estado?.nombre == "Activo" : "La cuenta no existe o bien no está activa."
		String ano = nombre[1][0..3]
		String mes = nombre[1][4..5]
		LocalDate fecha = new LocalDate( ano + '-' + mes + '-01')
		boolean esIva = nombre[2][0..6] == "DJF2002"

		def respuesta = [:]
		respuesta['nombreArchivo'] = archivo.originalFilename
		respuesta['cuenta'] = cuenta.toString()
		respuesta['periodo'] = "${mes}/${ano}"
		respuesta['tipo'] = esIva ? "IVA" : "IIBB"
		respuesta['estado'] = "El periodo no está liquidado."

		Estado estadoPresentada = Estado.findByNombre("Presentada")

		//Uso un closure porque tanto si es IVA como si es IIBB cada liquidación hará exactamente lo mismo, así que lo ejecuto desde el if de abajo
		Closure importar_prensentarDeclaracion = { liquidacion ->

			if(["Liquidado","Liquidado A","Liquidado A2","Automatico","Autorizada"].contains(liquidacion?.estado?.nombre)){
				if (liquidacion.estado.nombre != "Autorizada")
					respuesta['estado'] = "La liquidación no estaba Autorizada."
				liquidacion.estado = estadoPresentada
				liquidacion.save(flush:true)
				DeclaracionJurada declaracion
				if (esIva) 
					declaracion = DeclaracionJurada.findByLiquidacionIva(liquidacion) ?: saveDeclaracionJuradaPendientePorLiquidacionIva(liquidacion)
				else
					declaracion = DeclaracionJurada.findByLiquidacionIibb(liquidacion) ?: saveDeclaracionJuradaPendientePorLiquidacionIibb(liquidacion)
				declaracion.estado = estadoPresentada
				guardarArchivo(declaracion, archivo)
				declaracion.save(flush:true)
				respuesta['estado'] = "OK"
			} else if (liquidacion?.estado?.nombre == "Presentada")
				respuesta['estado'] = "La liquidación ya estaba presentada."
		}

		if (esIva)
			importar_prensentarDeclaracion(LiquidacionIva.findByCuentaAndFecha(cuenta,fecha))
		else // Ingresos brutos
			LiquidacionIIBB.findAllByCuentaAndFecha(cuenta, fecha).each{
				importar_prensentarDeclaracion(it)
			}

		
		return respuesta
	}
}
