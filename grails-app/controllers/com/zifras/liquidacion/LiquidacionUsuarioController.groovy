package com.zifras.liquidacion
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.cuenta.FacturacionCategoriaMonotributo
import static com.zifras.inicializacion.JsonInicializacion.formatear

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import com.zifras.AccessRulesService

@Secured(['ROLE_CUENTA', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class LiquidacionUsuarioController {
	def cuentaService
	AccessRulesService accessRulesService

	def list() {
		def hoy = new LocalDate()
		
		def ano = hoy.toString("YYYY")
		def mes = hoy.toString("MM")
		def cuenta = accessRulesService.getCurrentUser().cuenta
		def ganancias = cuenta.liquidacionesGanancia
		[cuenta: cuenta,cuentaId:cuenta.id,ano:ano, ganancias:ganancias]
	}

	def montosMaximos(){
		Cuenta cuenta = accessRulesService.getCurrentUser().cuenta
		Double iibb
		Double defaultIibb = 7000
		if (cuenta.condicionIva.nombre == "Monotributista")
			iibb = FacturacionCategoriaMonotributo.findByAnoAndNombre(new LocalDate().year ,cuenta.categoriaMonotributo?.with{nombre[0]})?.maximoAutorizar ?: defaultIibb
		else
			iibb = defaultIibb
		Double iva = 25000
		[
			cuentaId: cuenta.id,
			aplicaIva: cuenta.aplicaIva,
			aplicaIibb: cuenta.aplicaIIBB,
			recomendadoIva: formatear(iva).replace(".",""),
			recomendadoIibb: formatear(iibb).replace(".","")
		]
	}

	def saveMontos(Long cuentaId, String valorIva, String valorIIBB){
		cuentaService.setMontosMaximos(cuentaId, new Double(valorIva.replace(",",".")), new Double(valorIIBB.replace(",",".")))
		redirect(controller:'start')
	}

	def saveMontosApp(String valorIva, String valorIIBB){
		Cuenta cuenta = accessRulesService.getCurrentUser().cuenta
		try{
			cuentaService.setMontosMaximos(cuenta.id, new Double(valorIva.replace(",",".")), new Double(valorIIBB.replace(",",".")))
			render "OK"
			return
		}catch(Exception e){
			render "Ocurrió un error"
			return
		}
	}
}
