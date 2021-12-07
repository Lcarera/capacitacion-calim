package com.zifras.pedidosYa
import static com.zifras.inicializacion.JsonInicializacion.formatear

import com.zifras.AccessRulesService
import com.zifras.afip.AfipService
import com.zifras.cuenta.ClienteProveedor
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.facturacion.FacturaVenta
import com.zifras.facturacion.Persona
import com.zifras.facturacion.Proforma

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.plugin.springsecurity.annotation.Secured
import org.joda.time.LocalDate
import org.joda.time.format.DateTimeFormat

@Secured(['ROLE_RIDER_PY', 'ROLE_ADMIN_PY','ROLE_ADMIN'])
class PedidosYaController {
	def accessRulesService
	CuentaService cuentaService
	AfipService afipService
	def pedidosYaService

	@Secured(['ROLE_RIDER_PY'])
	def rider(Boolean mobile){
        def cuentaUsuario = accessRulesService.getCurrentUser().cuenta
        Proforma ultimaProforma = Proforma.findAllByRiderIdAndEstadoNotEqual(cuentaUsuario.riderId, Proforma.Estados.NUEVA)?.max{it.fecha}
        def tienePuntoVenta = afipService.getPuntosDeVenta(cuentaUsuario.id).size() > 0
        
      	def salida = [
      		estado: ultimaProforma?.estado?.toString(),
      		facturadoCalim: !ultimaProforma?.nombreArchivo,
      		semana: (ultimaProforma?.fecha ?: new LocalDate().withDayOfWeek(1)).toString("dd/MM"),
      		importe: ultimaProforma ? formatear(ultimaProforma.importe) : "0,00",
      		proformaId: ultimaProforma?.id,
      		claveFiscal: cuentaUsuario.claveFiscal,
      		puntoVentaCalim: tienePuntoVenta,
      		cuenta:cuentaUsuario
      	]

      	if(mobile)
      		render salida as JSON
      	else
      		return salida
	}

	@Secured(['ROLE_ADMIN_PY'])
	def admin(){
		[fechaHoy : new LocalDate().toString("dd/MM/YYYY")]
	}

	@Secured(['ROLE_ADMIN_PY'])
	def listRiders(){
	}

	def test(){
		generarExcel("31/05/2021","04/04/2021","04/04/2021")
	}
	def generarExcel(String emision, String desde, String hasta){
		
		/*try{
			pedidosYaService.generarExcel(emision,desde,hasta)
		}
		catch(e){
			println "Ocurrió un error generando el excel de facturación Pedidos Ya"
		}*/
		pedidosYaService.generarExcel(emision,desde,hasta)

		render "aaa"
	}

	def ajaxGetProformas(){
		def proformas = pedidosYaService.listProformas(params.fechaInicio)
		render proformas as JSON
	}

	def ajaxGetRiders(){
		render cuentaService.getRiders() as JSON
	}

	def ajaxNotificarRiders(){
		def resultado = [:]
		def riders = params.riders.split(',')
		try{
			pedidosYaService.notificarRiders(riders)
			resultado['ok'] = "Los Riders fueron notificados correctamente"
		}
		catch(e){
			log.error(e.message)
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			resultado['error'] = "Ocurrió un error notificando a los Riders"
		}
		render resultado as JSON
	}

	def getDatosFactura(Long proformaId){
		def salida = [:]
		def cuenta = accessRulesService.getCurrentUser().cuenta
		Proforma proforma = Proforma.get(proformaId)
		def pedidosYaId = proforma ? 346859 : null

		if (proforma && !cuenta.clientesProveedores?.find{it.persona.id == pedidosYaId})
			new ClienteProveedor(persona: Persona.get(pedidosYaId),cuenta: cuenta, cliente: true).save(flush:true)

		salida['pedidosYaId'] = pedidosYaId
		salida['proforma'] = proforma
		render salida as JSON
		return
	}

}
