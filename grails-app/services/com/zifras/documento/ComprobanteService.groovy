package com.zifras.documento
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.springframework.web.multipart.MultipartFile
import grails.transaction.Transactional
import com.zifras.AccessRulesService
import com.zifras.cuenta.Cuenta
import grails.config.Config

@Transactional
class ComprobanteService {
	AccessRulesService accessRulesService
	def grailsApplication

	def listComprobantes(Long cuentaId){
		def cuentaInstance = Cuenta.get(cuentaId)
		return cuentaInstance.comprobantes
	}

	def listTiposComprobante(){
		return Comprobante.Tipo.getEnumConstants()
	}

	Long eliminar(Long comprobanteId){
		Comprobante comprobante = Comprobante.get(comprobanteId)
		Long cuentaId = comprobante.cuenta.id
		def archivo = new File(System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + comprobante.cuenta.path + "/comprobantes/" + comprobante.nombreArchivo)
		archivo.delete()
		comprobante.delete(flush:true)
		return cuentaId
	}

	def getFile(Long id){
		def usuario = accessRulesService.getCurrentUser()
		def comprobanteInstance = Comprobante.get(id)
		if (!comprobanteInstance)
			throw new Exception("no existe")
		if (usuario.hasRole("ROLE_CUENTA") && (usuario.cuenta?.id != comprobanteInstance?.cuenta?.id))
			throw new Exception("permisos")
		String nombre = comprobanteInstance.nombreArchivo
		String cuentaPath = comprobanteInstance.cuenta.getPath()
		
		def file = new File(System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('carpetaArchivos') + "/" + cuentaPath + "/comprobantes/" + nombre)

		return file
	}
}