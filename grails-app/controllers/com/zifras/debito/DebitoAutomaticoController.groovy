package com.zifras.debito

import grails.converters.JSON
import org.joda.time.LocalDate
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_COBRANZA', 'ROLE_LECTURA', 'IS_AUTHENTICATED_FULLY'])
class DebitoAutomaticoController{
	
	def debitoAutomaticoService
	
	def list(){
		def debitoMensualPendiente = debitoAutomaticoService.debitoMensualPendiente()
		def fechaHoy = new LocalDate()
		def cuentasSinTarjeta = debitoAutomaticoService.cuentasSMDebitoAutomatico(false).size()
		[mes:fechaHoy.toString("MM"),ano:fechaHoy.toString("YYYY"),debitoMensualPendiente:debitoMensualPendiente, cuentasSinTarjeta:cuentasSinTarjeta]
	}

	def listCuentasSinTarjeta(){

	}

	def listCuentasSMActivo(){

	}

	def cargarDebitos(){
		def fechaHoy = new LocalDate()
		[mes:fechaHoy.toString("MM"),ano:fechaHoy.toString("YYYY")]
	}

	def generarTxtsDebitosMensuales(){
		def txtVisa = debitoAutomaticoService.generarTxt("DEBLIQC","82870338","visacredito")
		//def txtMaster = debitoAutomaticoService.generarTxt("DEBLIMC","82870346","mastercard")
		return txtVisa
	}

	def descargarTxtVisa(String debitoPendiente){
		def file = debitoAutomaticoService.generarTxt("DEBLIQC","82870338","visacredito")
		println debitoPendiente
		descargaTxt(file)
	}

	def descargarTxtMastercard(){
		def file = debitoAutomaticoService.generarTxt("DEBLIMC","82870346","mastercard")
		descargaTxt(file)
	}

	def descargaTxt(File archivo){
		response.setContentType("APPLICATION/OCTET-STREAM")
        response.setHeader("Content-Disposition", "Attachment;Filename=\"${archivo.getName()}\"")
                
        def fileInputStream = new FileInputStream(archivo)
        def outputStream = response.getOutputStream()
        byte[] buffer = new byte[4096];
        int len;
        while ((len = fileInputStream.read(buffer)) > 0) {
            outputStream.write(buffer, 0, len);
        }

        outputStream.flush()
        outputStream.close()
        fileInputStream.close()

		redirect(action:"list")
	}

	def ajaxSaveDebitosMensuales(){
		def debitos = []
			try{
				debitos = debitoAutomaticoService.saveDebitosMensuales()
			}
			catch(e){
				log.error(e.message)
				def salida = [:]
            	salida["error"] = "Se produjo un error guardando los debitos del mes."
                render salida as JSON
			}

		render debitos as JSON
	}

	def ajaxGetDebitosMensuales(){
		render debitoAutomaticoService.listDebitosMensuales() as JSON
	}

	def ajaxGetListaDebitos(String mes, String ano){
		render debitoAutomaticoService.listDebitosMensualesGenerados(mes,ano) as JSON
	}

	def ajaxGetDebitosMensualesGenerados(String mes, String ano){
		render debitoAutomaticoService.listDebitosMensualesGenerados(mes,ano) as JSON
	}

	def ajaxGetCuentasSinTarjeta(){
		render debitoAutomaticoService.cuentasSMDebitoAutomatico(false) as JSON
	}

	def ajaxCargarTarjeta(){
		def respuesta = [:]
		try{
			debitoAutomaticoService.actualizarTarjetaCuenta(params.cuentaId, params.numeroTarjeta, params.tarjetaCredito)
			respuesta['ok'] = "Ok"
		}
		catch(e){
			respuesta['error'] = "La tarjeta no se pudo actualizar"
		}
		render respuesta as JSON
	}
}