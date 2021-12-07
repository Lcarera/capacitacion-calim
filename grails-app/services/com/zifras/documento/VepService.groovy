package com.zifras.documento

import com.zifras.AccessRulesService
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.Localidad
import com.zifras.Provincia
import com.zifras.UsuarioService

import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.Local

import com.zifras.liquidacion.LiquidacionIIBB
import com.zifras.liquidacion.LiquidacionIva

import com.zifras.notificacion.NotificacionService
import com.zifras.notificacion.NotificacionTemplate

import grails.config.Config
import grails.transaction.Transactional
import grails.validation.ValidationException
import groovy.json.JsonSlurper
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatter
import org.springframework.web.multipart.MultipartFile

@Transactional
class VepService {
	AccessRulesService accessRulesService
	def grailsApplication
	def usuarioService
	def notificacionService

	def createVepCommand(){
		def command = new VepCommand()
		LocalDateTime ahora = LocalDateTime.now()
		command.horaPago = ahora.toString("HH:mm")
		return command
	}

	def saveVep(VepCommand command, MultipartFile archivo, Boolean simplificado){
		def vepInstance = new Vep()
		
		
		vepInstance.cuenta = Cuenta.get(command.cuentaId)
		vepInstance.estado = Estado.get(command.estadoId)
		vepInstance.descripcion = command.descripcion
		vepInstance.importe = command.importe

		if(!simplificado){
			vepInstance.numero = command.numero
			String hora = "T" + command.horaPago + LocalDateTime.now().toString(":ss.SSS")
			vepInstance.fechaPago = new LocalDateTime(command.fechaPago.toString("YYYY-MM-dd") + hora)
		}
		else{
			vepInstance.tipo = TipoVep.findByNombre("Simplificado")
			vepInstance.fechaEmision = new LocalDate(command.fechaEmision.toString("YYYY-MM-dd"))
			}

		return guardarArchivo(vepInstance,archivo)
	}

	private guardarArchivo(Vep vepInstance, archivo){
		vepInstance.nombreArchivo = archivo.originalFilename

		String cuentaPath = vepInstance.cuenta.getPath()
		String pathFC = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/veps/"

		File carpeta = new File(pathFC)
		if(!carpeta.exists())
			carpeta.mkdirs()

		String fullPath = pathFC + vepInstance.nombreArchivo
		int versionArchivo = 0
		while((new File(fullPath)).exists()){
			versionArchivo++
			fullPath = pathFC + vepInstance.nombreArchivo + " (" + versionArchivo.toString() + ")"
		}
		if (versionArchivo>0)
			vepInstance.nombreArchivo += " (" + versionArchivo.toString() + ")"
		archivo.transferTo(new File(fullPath))
		return vepInstance.save(flush:true, failOnError:true)
	}

	def savePorLiquidacion(Long liquidacionId, boolean esIva, archivo, LocalDate fechaVencimiento = null){
		def liquidacion = esIva ? LiquidacionIva.get(liquidacionId) : LiquidacionIIBB.get(liquidacionId)
		DeclaracionJurada declaracion = liquidacion.declaracion // Ojo con el importe iibb
		String tipovep = esIva ? "IVA" : "IIBB"
		Vep vep = new Vep().with{
			vencimiento = fechaVencimiento
			estado = Estado.findByNombre("Activo")
			descripcion = "Generado por liquidación de ${esIva ? 'IVA' : 'IIBB'} con ID ${liquidacion.id}"
			fechaEmision = new LocalDate()
			importe = liquidacion.saldoDdjj
			nombreArchivo = ""
			tipo = TipoVep.findByNombre(tipovep)
			cuenta = liquidacion.cuenta
			save(flush:true)
		}
		if (esIva){
			declaracion.vep = vep
			declaracion.save(flush:true)
		}else{
			vep.importe = 0
			LiquidacionIIBB.findAllByFechaAndCuenta(liquidacion.fecha, vep.cuenta)?.each{
				vep.importe += it.saldoDdjj
				declaracion = it.declaracion
				if (declaracion){
					declaracion.vep = vep
					declaracion.save(flush:true)
				}
			}
		}
		if (archivo)
			guardarArchivo(vep, archivo)
		enviarMailPago(vep)
		return vep
	}

	def enviarMailPago(Vep vep){
		String patternCurrency = '###,###,##0.00'
		DecimalFormat decimalCurencyFormat = new DecimalFormat(patternCurrency)
		DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
		otherSymbols.setDecimalSeparator(',' as char)
		otherSymbols.setGroupingSeparator('.' as char)
		decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)

		String importes_y_vencimientos = '<div style="font-size:18px; padding-top: 40px; color:#666;">' + vep.tipo.nombre + '<br/>Vencimiento: <strong>' + (vep.vencimiento.toString("dd/MM/yyyy") ?: "-") + '</strong></div>'
		NotificacionTemplate plantilla = NotificacionTemplate.findByNombre("Pago impuestos VEP")
		notificacionService.enviarEmail(vep.cuenta.email, plantilla.asuntoEmail, plantilla.llenarVariablesBody([vep.cuenta.nombreApellido, importes_y_vencimientos, "https://app.calim.com.ar/vep/download/${vep.id}", usuarioService.getLinkDesactivarNotificaciones(vep.cuenta.usuario)]))
	}

	def getFile(Long id){
		def usuario = accessRulesService.getCurrentUser()
		def vepInstance = Vep.get(id)
		if (!vepInstance)
			throw new Exception("no existe")
		if (usuario.hasRole("ROLE_CUENTA") && (usuario.cuenta?.id != vepInstance?.cuenta?.id))
			throw new Exception("permisos")
		if (["IVA","IIBB","Intereses"].contains(vepInstance.tipo.nombre) && new LocalDate() > vepInstance.vencimiento){
			throw new Exception("vencido")
		}
		String nombre = vepInstance.nombreArchivo
		String cuentaPath = vepInstance.cuenta.getPath()
		
		def file = new File(System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/veps/" + nombre)

		return file
	}

	def listVep(String filter,Long cuentaId) {
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		lista = Vep.createCriteria().list() {
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}
			if(filter!=null)
				ilike('numero', '%' + filter + '%')
		
			order('fechaEmision', 'desc')
		}				
		return lista
	}
	def listVolantes(Long cuentaId) {
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		def tipoInstance = TipoVep.findByNombre("Simplificado")
		
		lista = Vep.createCriteria().list() {
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}
			
			eq('tipo', tipoInstance)
		
			order('fechaEmision', 'asc')
		}				
		return lista
	}

	def listVepNoPagados(Long cuentaId){
		def lista
		def cuentaInstance = Cuenta.get(cuentaId)
		
		lista = Vep.createCriteria().list() {
			ne('estado', Estado.findByNombre('Pagado'))
			if(cuentaInstance != null){
				eq('cuenta', cuentaInstance)
			}

			order('fechaEmision', 'desc')
		}				
		return lista
	}
	
	def getVep(Long id){
		def vepInstance = Vep.get(id)
	}
	
	def getVepCommand(Long id){
		def vepInstance = Vep.get(id)
		
		if(vepInstance!=null){
			def command = new VepCommand()
			
			command.vepId = vepInstance.id
			command.version = vepInstance.version
			command.numero = vepInstance.numero
			command.cuentaId = vepInstance.cuenta.id
			command.estadoId = vepInstance.estado.id
			command.descripcion = vepInstance.descripcion
			command.importe = vepInstance.importe
			command.fechaPago = new LocalDate(vepInstance.fechaPago?.toString("YYYY-MM-dd"))
			command.horaPago = vepInstance.fechaPago?.toString("HH:mm")
			command.fechaEmision = vepInstance.fechaEmision
			command.nombreArchivo = vepInstance.nombreArchivo

			return command
		} else {
			return null
		}
	}

	public String getNumeroCuota(LocalDate fecha){
		def mes = fecha.toString("MM")
		if(mes=="01" || mes=="12")
			return '6'
		else{
			if(mes=="03" || mes=="02")
				return '1'
			else{
				if(mes=="05" || mes=="04")
					return '2'
				else{
					if(mes=="07" || mes=="06")
						return '3'
					else{
						if(mes=="09" || mes=="08")
							return '4'
						else
							return '5'
					}
				}
			}
		}
	}
	
	def getVepList() {
		lista = Vep.list();
	}
	
	def deleteVep(Long id){
		def vepInstance = Vep.get(id)

		String nombre = vepInstance.nombreArchivo
		String cuentaPath = vepInstance.cuenta.path
		String ruta = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/veps/" + nombre
		(new File(ruta)).delete()

		vepInstance.delete(flush:true)
	}

	def updateVep(VepCommand command, MultipartFile archivo, Boolean simplificado){
		def vepInstance = Vep.get(command.vepId)

		if (command.version != null) {
			if (vepInstance.version > command.version) {
				VepCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["Vep"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado el vep")
				throw new ValidationException("Error de versión", VepCommand.errors)
			}
		}
		
		vepInstance.cuenta = Cuenta.get(command.cuentaId)
		vepInstance.estado = Estado.get(command.estadoId)
		vepInstance.descripcion = command.descripcion
		vepInstance.importe = command.importe
		if(!simplificado){
			vepInstance.numero = command.numero
			String hora = "T" + command.horaPago + LocalDateTime.now().toString(":ss.SSS")
			vepInstance.fechaPago = new LocalDateTime(command.fechaPago.toString("YYYY-MM-dd") + hora)
		}
		else{
			vepInstance.fechaEmision = new LocalDate(command.fechaEmision.toString("YYYY-MM-dd"))
		
		}
		if(!archivo.isEmpty()){
			String cuentaPath = vepInstance.cuenta.getPath()
			String pathFC = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/veps/"

			//Borra archivo viejo:
			String fullPathABorrar = pathFC + vepInstance.nombreArchivo			
			File archivoABorrar = new File(fullPathABorrar)
			archivoABorrar.delete()

			//Cargar archivo nuevo:
			vepInstance.nombreArchivo = archivo.originalFilename

			File carpeta = new File(pathFC)
			if(!carpeta.exists())
				carpeta.mkdirs()

			String fullPath = pathFC + vepInstance.nombreArchivo
			int versionArchivo = 0
			while((new File(fullPath)).exists()){
				versionArchivo++
				fullPath = pathFC + vepInstance.nombreArchivo + " (" + versionArchivo.toString() + ")"
			}
			if (versionArchivo>0)
				vepInstance.nombreArchivo += " (" + versionArchivo.toString() + ")"
			archivo.transferTo(new File(fullPath))
		}

		vepInstance.save(flush:true, failOnError:true)
		
		return vepInstance
	}

	def importar(archivo){
		def nombre = org.apache.commons.io.FilenameUtils.removeExtension(archivo.originalFilename).split('_') //Le saco la extensión antes de hacer el Split, para que no moleste a la hora de analizar el nombre
		assert nombre[2] == "vpSimpl" : "El archivo ingresado no es un Volante de Pago"
		Cuenta cuenta = Cuenta.findByCuit(nombre[0].replaceAll("-",""))
		assert cuenta?.estado?.nombre == "Activo" : "La cuenta no existe o bien no está activa."
		assert cuenta.regimenIibb?.nombre == "Simplificado" : "La cuenta no pertenece al regimen Monotributo Simplificado"
		String ano = nombre[1][0..3]
		String mes = nombre[1][4..5]
		LocalDate fechaEmision = new LocalDate( ano + '-' + mes + '-01')
		def descripcion = "Volante de Pago Monotributista Simplificado"

		def respuesta = [:]
		respuesta['nombreArchivo'] = archivo.originalFilename
		respuesta['cuenta'] = cuenta.toString()
		respuesta['descripcion'] = descripcion
		respuesta['fechaEmision'] = fechaEmision
		respuesta['estado'] = 'OK'
		
		def volantePago = new Vep()
		volantePago.nombreArchivo = archivo.originalFilename
		volantePago.cuenta = cuenta
		
		volantePago.descripcion = descripcion
		volantePago.fechaEmision = fechaEmision

		volantePago = guardarArchivo(volantePago, archivo)
		volantePago.save(flush:true)

		respuesta['periodo'] = volantePago.getPeriodo()

		return respuesta
	}

	
	def getCantidadVepsTotales(){
		return Vep.count()
	}

	def generarMatrizImportaciones(String mes, String ano){
		def respuesta = []
		LocalDate periodo = new LocalDate(ano + "-" + mes + "-01")
		def listaVeps = Vep.createCriteria().list() {
			ge("fechaEmision", periodo)
			lt("fechaEmision", periodo.plusMonths(1))
		}	
		Cuenta.findAllByEstado(Estado.findByNombre('Activo')).each{
			Cuenta cuenta = it
			def vepsDeCuenta = listaVeps.findAll{it.cuenta.id == cuenta.id}
			cuenta.localesActivos?.each{
				Local local = it
				respuesta << generarItemLocal(local, vepsDeCuenta.findAll{it.local.id == local.id}, periodo)
			}
		}
		return respuesta
	}

	def generarMatrizDeCuenta(Long cuentaId, LocalDate fecha){
		def respuesta = []
		Cuenta.get(cuentaId).localesActivos.each{
			respuesta << generarItemLocal(it, it.vepsDeMes(fecha), fecha)
		}
		return respuesta
	}

	private generarItemLocal(Local local, vepsDeLocal, LocalDate periodo){
		def item = [:]
		Cuenta cuenta = local.cuenta
		item['cuenta'] = cuenta.toString()
		item['local'] = local.toString()
		item['idLocal'] = local.id
		if (cuenta.condicionIva?.nombre == "Monotributista"){
			Long idMono = vepsDeLocal.find{it.tipo.nombre == "Monotributo"}?.id
			if (idMono)
				item['monotributo'] = idMono  //Importado
			else
				item['monotributo'] = 0  //No Importado
		}else
			item['monotributo'] = -1 //No aplica

		if (cuenta.condicionIva?.nombre == "Responsable inscripto"){
			Long idResp = vepsDeLocal.find{it.tipo.nombre == "Autonomo"}?.id
			if (idResp)
				item['responsable'] = idResp
			else
				item['responsable'] = 0
			Long idIva = vepsDeLocal.find{it.tipo.nombre == "IVA"}?.id
			if (idIva)
				item['iva'] = idIva
			else
				item['iva'] = 0
		}else
			item['responsable'] = item['iva'] = -1

		if (true){ // Cuando nos den el OK de que están cargados, verificar según la cantidad de empleados
			Long id931 = vepsDeLocal.find{it.tipo.nombre == "931"}?.id
			if (id931)
				item['931'] = id931
			else
				item['931'] = 0
			item['recibosString'] = local.cantidadRecibosCargados(periodo) + " / " + (local.cantidadEmpleados?:0)
			item['cantidadRecibos'] = local.cantidadRecibosCargados(periodo) ?: 0
		}else{
			item['931'] = -1
			item['recibosString'] = -1
		}

		Long idIibb = vepsDeLocal.find{it.tipo.nombre == "IIBB"}?.id
		if (idIibb)
			item['iibb'] = idIibb
		else
			item['iibb'] = 0

		if (local.provincia.nombre == "Buenos Aires"){
			Long idSeguridad = vepsDeLocal.find{it.tipo.nombre == "Seguridad e Higiene"}?.id
			if (idSeguridad)
				item['seguridad'] = idSeguridad
			else
				item['seguridad'] = 0
		}else
			item['seguridad'] = -1
		item['telefono'] = local.telefono
		item['mesPago'] = FacturaCuenta.findAllByLocal(local)?.find{it.fechaHora?.with{ localMillis >= periodo.plusMonths(1).localMillis && localMillis < periodo.plusMonths(2).localMillis}}?.pagada ?: false
		return item
	}

	public Long regenerar(Long viejoId){
		Vep viejo = Vep.get(viejoId)
	}

	public void notificarVepVencido(Long vepId, String error){
		Vep vepInstance = Vep.get(vepId)
		String html = "El cliente <a href='https://app.calim.com.ar/cuenta/show/${vepInstance.cuenta.id}'>${vepInstance.cuenta.toString()}</a> intentó descargar el VEP de tipo '${vepInstance.tipo.nombre}' con ID ${vepInstance.id}, emitido el ${vepInstance.fechaEmision.toString('dd/MM/yyyy')} y con fecha de vencimiento el día ${vepInstance.vencimiento?.toString('dd/MM/yyyy')}"
		html += "</br></br>$error"
		notificacionService.enviarEmailInterno("gestion@calim.com.ar", "VEP Vencido", html)
		// notificacionService.enviarEmailInterno("franco@calim.com.ar", "Error VEP Vencido", html)
	}
}
