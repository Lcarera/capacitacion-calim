package com.zifras.documento

import com.zifras.AccessRulesService
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.Localidad
import com.zifras.Provincia
import com.zifras.cuenta.Cuenta
import com.zifras.liquidacion.LiquidacionGanancia
import com.zifras.liquidacion.LiquidacionIIBB
import com.zifras.liquidacion.LiquidacionIva
import com.zifras.documento.ComprobantePagoCommand

import grails.config.Config
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.transaction.Transactional
import grails.validation.ValidationException
import groovy.json.JsonSlurper
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import org.springframework.web.multipart.MultipartFile

@Transactional
class ComprobantePagoService{
	AccessRulesService accessRulesService
	def grailsApplication

	def createComprobantePagoCommand(){
		return new ComprobantePagoCommand()
	}

	def listComprobantesPago(String filter,Long cuentaId) {
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		lista = ComprobantePago.createCriteria().list() {
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}
			if(filter!=null)
				ilike('descripcion', '%' + filter + '%')
		
			order('descripcion', 'asc')
			
		}				
		return lista
	}
	private saveComprobantePago(ComprobantePagoCommand command, MultipartFile archivo){
		def comprobantePagoInstance = new ComprobantePago()
		def cuentaInstance 
		cuentaInstance = Cuenta.get(command.cuentaId)
		def declaracionInstance 
		declaracionInstance = DeclaracionJurada.get(command.declaracionId)
		
		comprobantePagoInstance.fecha = command.fecha
		comprobantePagoInstance.descripcion = command.descripcion
		comprobantePagoInstance.declaracion = declaracionInstance		
		comprobantePagoInstance.importe = command.importe


		comprobantePagoInstance = guardarArchivo(comprobantePagoInstance, archivo,cuentaInstance)
		comprobantePagoInstance.save(flush:true)
	
		declaracionInstance.comprobantePago = comprobantePagoInstance
		declaracionInstance.save(flush:true)

		return comprobantePagoInstance
	}

	def updateComprobantePago(ComprobantePagoCommand command, MultipartFile archivo){
		def comprobantePagoInstance = ComprobantePago.get(command.comprobantePagoId)

		if (command.version != null) {
			if (comprobantePagoInstance.version > command.version) {
				ComprobantePagoCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["ComprobantePago"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el Comprobante de Pago")
				throw new ValidationException("Error de versión", ComprobantePagoCommand.errors)
			}
		}
		def cuentaInstance = Cuenta.get(comprobantePagoInstance.declaracion.cuenta.id)

		comprobantePagoInstance.fecha = command.fecha
		comprobantePagoInstance.descripcion = command.descripcion
		comprobantePagoInstance.importe = command.importe

		if(!archivo.isEmpty()){
			borrarArchivo(comprobantePagoInstance)
			guardarArchivo(comprobantePagoInstance, archivo, cuentaInstance)
		}
		
		comprobantePagoInstance.save(flush:true)
		
		return comprobantePagoInstance
	}

	def getComprobantePagoCommand(Long id){
		def comprobantePagoInstance = ComprobantePago.get(id)
		
		if(comprobantePagoInstance!=null){
			def command = new ComprobantePagoCommand()
			
			command.comprobantePagoId = comprobantePagoInstance.id
			command.version = comprobantePagoInstance.version
			command.cuentaId = comprobantePagoInstance.declaracion.cuenta.id
			command.fecha = comprobantePagoInstance.fecha
			command.descripcion = comprobantePagoInstance.descripcion
			command.nombreArchivo = comprobantePagoInstance.nombreArchivo
			command.importe = comprobantePagoInstance.importe
			command.declaracionId = comprobantePagoInstance.declaracion.id

			return command
		} else {
			return null
		}
	}

	private ComprobantePago guardarArchivo(ComprobantePago comprobantePagoInstance, MultipartFile archivo, Cuenta cuentaComprobante){
		comprobantePagoInstance.nombreOriginal = comprobantePagoInstance.nombreArchivo = archivo.originalFilename
		String cuentaPath = cuentaComprobante.getPath()
		String pathComprobantesPago = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/comprobantesPago/"

		File carpeta = new File(pathComprobantesPago)
		if(!carpeta.exists())
			carpeta.mkdirs()

		String fullPath = pathComprobantesPago + comprobantePagoInstance.nombreOriginal
		int versionArchivo = 0
		while((new File(fullPath)).exists()){
			versionArchivo++
			fullPath = pathComprobantesPago + comprobantePagoInstance.nombreOriginal + " (" + versionArchivo.toString() + ")"
		}
		if (versionArchivo>0)
			comprobantePagoInstance.nombreArchivo += " (" + versionArchivo.toString() + ")"
		archivo.transferTo(new File(fullPath))

		return comprobantePagoInstance
	}

	private def borrarArchivo(ComprobantePago comprobante){
		String nombre = comprobante.nombreArchivo
		String cuentaPath = comprobante.declaracion.cuenta.path
		String ruta = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/comprobantesPago/" + nombre
		(new File(ruta)).delete()
	}

	def getFile(Long id){
		def usuario = accessRulesService.getCurrentUser()
		def comprobantePagoInstance = ComprobantePago.get(id)
		if (!comprobantePagoInstance)
			throw new Exception("no existe")
		if (usuario.hasRole("ROLE_CUENTA") && (usuario.cuenta?.id != comprobantePagoInstance?.declaracion?.cuenta?.id))
			throw new Exception("permisos")
		String nombre = comprobantePagoInstance.nombreArchivo
		String cuentaPath = comprobantePagoInstance.declaracion.cuenta.getPath()
		
		def file = new File(System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/comprobantesPago/" + nombre)

		return file
	}

	def deleteComprobantePago(Long id){
		def comprobantePagoInstance = ComprobantePago.get(id)
		def declaracionInstance = comprobantePagoInstance.declaracion

		declaracionInstance.comprobantePago = null
		declaracionInstance.save(flush:true)
		borrarArchivo(comprobantePagoInstance)

		comprobantePagoInstance.delete(flush:true)
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
			
		return respuesta
	}

}