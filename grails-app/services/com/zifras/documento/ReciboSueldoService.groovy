package com.zifras.documento

import grails.config.Config
import grails.transaction.Transactional
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.validation.ValidationException
import groovy.json.JsonSlurper
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormat
import com.zifras.documento.ReciboSueldo
import org.joda.time.format.DateTimeFormatter
import org.springframework.web.multipart.MultipartFile
import com.zifras.cuenta.Cuenta
import com.zifras.documento.ReciboSueldo
import com.zifras.cuenta.Local
import com.zifras.Estado

class ReciboSueldoService {

	def grailsApplication
	def accessRulesService

	def generarLocales(String mes, String ano){
		def respuesta = []
		
		LocalDate periodo = new LocalDate(ano + "-" + mes + "-01")
		Cuenta.findAllByEstado(Estado.findByNombre('Activo')).each{
			Cuenta cuenta = it
			cuenta.localesActivos?.each{
				if(it.poseeEmpleados()){
					Local local = it
					def item = [:]
					item['cuenta'] = cuenta.toString()
					item['local'] = local.toString()
					item['numeroLocal'] = local.numeroLocal
					item['localId'] = local.id
					item['cantidadEmpleados'] = local.cantidadEmpleados ?: "0"
					item['cantidadRecibosCargados'] = recibosCargados(local, periodo).size()
					item['fecha'] = periodo

					respuesta << item
				}
			}
		}
		return respuesta
	}

	def recibosCargados(Local local, LocalDate periodo){	
		def recibosDelMes = ReciboSueldo.createCriteria().list() {
			eq("local", local)
			ge("fechaEmision", periodo)
			lt("fechaEmision", periodo.plusMonths(1))
		}	
		return recibosDelMes
	}

	def getFile(Long id){
		def usuario = accessRulesService.getCurrentUser()
		def reciboSueldoInstance = ReciboSueldo.get(id)
		if (!reciboSueldoInstance)
			throw new Exception("no existe")
		if (usuario.hasRole("ROLE_CUENTA") && (usuario.cuenta?.id != reciboSueldoInstance?.declaracion?.cuenta?.id))
			throw new Exception("permisos")
		String nombre = reciboSueldoInstance.nombreArchivo
		String cuentaPath = reciboSueldoInstance.cuenta.getPath()
		
		def file = new File(System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/recibosSueldo/" + nombre)

		return file
	}

	private saveReciboSueldo(DeclaracionJurada declaracionJuradaInstance, DeclaracionJuradaCommand command, MultipartFile archivo, Double importe){
		declaracionJuradaInstance.cuenta = Cuenta.get(command.cuentaId)

		declaracionJuradaInstance.fecha = command.fecha
		declaracionJuradaInstance.descripcion = command.descripcion
		declaracionJuradaInstance.estado = Estado.get(command.estadoId) ?: Estado.findByNombre("Presentada")

		declaracionJuradaInstance = guardarArchivo(declaracionJuradaInstance, archivo)
		declaracionJuradaInstance.save(flush:true)

		// movimientoCuentaService.saveMovimientoCuentaDDJJ(declaracionJuradaInstance, importe)

		return declaracionJuradaInstance
	}

	private ReciboSueldo guardarArchivo(ReciboSueldo reciboSueldoInstance, MultipartFile archivo){
		reciboSueldoInstance.nombreOriginal = reciboSueldoInstance.nombreArchivo = archivo.originalFilename
		String cuentaPath = reciboSueldoInstance.cuenta.getPath()
		String pathRecibos = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/recibosSueldo/"

		File carpeta = new File(pathRecibos)
		if(!carpeta.exists())
			carpeta.mkdirs()

		String fullPath = pathRecibos + reciboSueldoInstance.nombreOriginal
		int versionArchivo = 0
		while((new File(fullPath)).exists()){
			versionArchivo++
			fullPath = pathRecibos + reciboSueldoInstance.nombreOriginal + " (" + versionArchivo.toString() + ")"
		}
		if (versionArchivo>0)
			reciboSueldoInstance.nombreArchivo += " (" + versionArchivo.toString() + ")"
		archivo.transferTo(new File(fullPath))

		return reciboSueldoInstance
	}

	def importar(archivo){
		def nombre = org.apache.commons.io.FilenameUtils.removeExtension(archivo.originalFilename).split('_') //Le saco la extensión antes de hacer el Split, para que no moleste a la hora de analizar el nombre
		Cuenta cuenta = Cuenta.findByCuit(nombre[2])
		assert nombre[1] =="rs" : "El archivo importado no es un Recibo de Sueldo."
		assert cuenta?.estado?.nombre == "Activo" : "La cuenta no existe o bien no está activa."
		String ano = nombre[0][0..3]
		String mes = nombre[0][4..5]
		LocalDate fecha = new LocalDate( ano + '-' + mes + '-01')

		Integer numeroLocal = new Integer(nombre[3])
		def localInstance = localByNumero(numeroLocal,cuenta)

		assert localByNumero(numeroLocal,cuenta) != null : "No existe el local "+numeroLocal+" para la cuenta dada."

		Long idEmpleado = new Long(nombre[4])

		assert empleadoYaCargado(localInstance, archivo.originalFilename) != true : "Ya se ingreso el recibo de ese empleado."
		assert faltanRecibos(localInstance) == true : "Ya se ingresaron todos los recibos del local ingresado."

		def respuesta = [:]
		respuesta['nombreArchivo'] = archivo.originalFilename
		respuesta['cuenta'] = cuenta.toString()
		respuesta['periodo'] = "${mes}/${ano}"
		respuesta['numeroLocal'] = numeroLocal
		respuesta['idEmpleado'] = idEmpleado
		respuesta['estado'] = 'OK'
		
		def reciboSueldoInstance = new ReciboSueldo()
		reciboSueldoInstance.nombreArchivo = archivo.originalFilename
		reciboSueldoInstance.cuenta = cuenta
		
		reciboSueldoInstance.local = localInstance
		reciboSueldoInstance.fechaEmision = fecha

		reciboSueldoInstance = guardarArchivo(reciboSueldoInstance, archivo)
		reciboSueldoInstance.save(flush:true)

		return respuesta
	}

	def deleteRecibosDelLocal(Local local){
		def recibos = local.recibosSueldo
		local.recibosSueldo = []
		local.save(flush:true)
		println local.direccion
		for(int i=0;i<recibos.size();i++){
			def reciboInstance = recibos[i]
			deleteRecibo(reciboInstance)
			reciboInstance.delete(flush:true)
		}
	}

	def deleteRecibo(ReciboSueldo recibo){
		borrarArchivo(recibo)
	}

	private def borrarArchivo(ReciboSueldo recibo){
		String nombre = recibo.nombreArchivo
		String cuentaPath = recibo.cuenta.path
		String ruta = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/recibosSueldo/" + nombre
		(new File(ruta)).delete()
	}

	public Local localByNumero(Integer numero, Cuenta cuenta){
		return cuenta.locales.find{local -> local.numeroLocal == numero}	
	}

	public Boolean empleadoYaCargado(Local local, String nombreArch){
		return local.recibosSueldo.any{recibo -> recibo.nombreArchivo == nombreArch}
	}

	public	Boolean faltanRecibos(Local local){
		return local.recibosSueldo.size() < local.cantidadEmpleados
	}

	def getReciboSueldo(Long id){
		return ReciboSueldo.get(id)
	}

}