package com.zifras.inicializacion

import com.zifras.Contador
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.Localidad
import com.zifras.Role
import com.zifras.User
import com.zifras.UserRole
import com.zifras.Zona
import com.zifras.app.App

import com.zifras.cuenta.Actividad
import com.zifras.cuenta.AlicuotaIIBB
import com.zifras.cuenta.AlicuotaProvinciaActividadIIBB
import com.zifras.cuenta.CantidadImpuesto
import com.zifras.cuenta.ClienteProveedor
import com.zifras.cuenta.CondicionIva
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuotaMoratoria
import com.zifras.cuenta.Impuesto
import com.zifras.cuenta.Local
import com.zifras.cuenta.MedioPago
import com.zifras.cuenta.MovimientoCuenta
import com.zifras.cuenta.Pariente
import com.zifras.cuenta.PlanMoratoria
import com.zifras.cuenta.PorcentajeActividadIIBB
import com.zifras.cuenta.PorcentajeProvinciaIIBB
import com.zifras.cuenta.RegimenIibb
import com.zifras.cuenta.TipoClave
import com.zifras.cuenta.TipoPersona

import com.zifras.debito.DebitoAutomatico

import com.zifras.descuento.CodigoDescuento

import com.zifras.documento.Comprobante
import com.zifras.documento.ComprobantePago
import com.zifras.documento.DeclaracionJurada
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.PagoCuenta
import com.zifras.documento.Vep

import com.zifras.facturacion.*
import com.zifras.importacion.EstadoImportacionesItem
import com.zifras.importacion.LogImportacion
import com.zifras.importacion.LogMercadoPago
import com.zifras.importacion.LogSelenium

import com.zifras.liquidacion.GastoDeduccionGanancia
import com.zifras.liquidacion.LiquidacionGanancia
import com.zifras.liquidacion.LiquidacionIIBB
import com.zifras.liquidacion.LiquidacionIIBBAlicuota
import com.zifras.liquidacion.LiquidacionIva
import com.zifras.liquidacion.MontoConceptoDeducibleGanancia
import com.zifras.liquidacion.ParienteGanancia
import com.zifras.liquidacion.PatrimonioGanancia
import com.zifras.liquidacion.RangoImpuestoGanancia
import com.zifras.liquidacion.RetencionPercepcionIIBB
import com.zifras.liquidacion.RetencionPercepcionIva

import com.zifras.notificacion.ConsultaWeb
import com.zifras.notificacion.Email
import com.zifras.notificacion.NotificacionTemplate

import com.zifras.servicio.ItemServicioEspecial
import com.zifras.servicio.ItemServicioMensual
import com.zifras.servicio.Servicio

import com.zifras.ticket.ElementoFaq
import com.zifras.ticket.CategoriaFaq
import com.zifras.ticket.Mensaje

import com.zifras.ventas.Vendedor
import com.zifras.ventas.VendedorDiaExtra

import grails.converters.JSON
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import org.joda.time.LocalDate

class JsonInicializacion {
	private static DecimalFormat decimalCurencyFormat = null;
	private static DecimalFormat decimalCurencyFormatSinPunto = null;
	public static String formatear(numero){
		if (decimalCurencyFormat == null){
			// println "\nCreando formateador decimal...\n"
			String patternCurrency = '###,###,##0.00'
			decimalCurencyFormat = new DecimalFormat(patternCurrency)
			DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
			otherSymbols.setDecimalSeparator(',' as char)
			otherSymbols.setGroupingSeparator('.' as char)
			decimalCurencyFormat.setGroupingUsed(true)
			decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)
		}
		return decimalCurencyFormat.format(numero)
	}

	public static String formatearSinPunto(numero){
		if (decimalCurencyFormatSinPunto == null){
			// println "\nCreando formateador decimal...\n"
			String patternCurrency = '###,###,##0.00'
			decimalCurencyFormatSinPunto = new DecimalFormat(patternCurrency)
			DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
			otherSymbols.setDecimalSeparator(',' as char)
			otherSymbols.setGroupingSeparator('.' as char)
			decimalCurencyFormatSinPunto.setGroupingUsed(false)
			decimalCurencyFormatSinPunto.setDecimalFormatSymbols(otherSymbols)
		}
		def a_formatear = numero ?: 0
		return decimalCurencyFormatSinPunto.format(a_formatear)
	}

	static def inicializar(){
		JSON.registerObjectMarshaller(Cuenta){
			def returnArray = [:]

			returnArray['selected'] = ''

			returnArray['id'] = it.id
			returnArray['cuit'] = (it.cuit && it.cuit != it.email) ? it.cuit : "-"
			returnArray['razonSocial'] = it.razonSocial
			returnArray['nombreApellido'] = it.nombreApellido
			returnArray['telefono'] = it.telefono ?: "-"
			returnArray['email'] = it.email
			returnArray['wechat'] = it.wechat
			returnArray['whatsapp'] = it.whatsapp
			returnArray['numeroSicol'] = it.numeroSicol
			returnArray['saldo'] = it.saldo
			returnArray['locales'] = ''
			returnArray['provincias'] = ''
			returnArray['mailConfirmado'] = !it.usuario?.accountLocked
			returnArray['toString'] = it.toString()
			returnArray['condicionIva'] = it.condicionIva?.nombre ?: ''
			returnArray['condicionIvaId'] = it.condicionIva?.id ?: 0
			returnArray['appCalimDescargada'] = it.appCalimDescargada()
			returnArray['trabajaConApp'] = it.trabajaConApp()
			returnArray['tieneClaveFiscal'] = !!it.claveFiscal
			returnArray['ingresoFotosRegistro'] = it.ingresoFotosRegistro
			returnArray['inscriptoAfip'] = it.inscriptoAfip
			returnArray['tieneMensual'] = it.getServicioActivo()
			returnArray['maximoAutorizarIva'] = it.maximoAutorizarIva
			returnArray['maximoAutorizarIIBB'] = it.maximoAutorizarIIBB
			
			returnArray['medioPagoIva'] = it.medioPagoIva
			returnArray['medioPagoIibb'] = it.medioPagoIibb

			returnArray['tarjeta'] = it.tarjetaDebitoAutomatico

			if(it.domicilioFiscal!=null){
				returnArray['domicilio'] = it.domicilioFiscal
			}
			returnArray['algunServicioPagado'] = it.algunServicioPagado()
			returnArray['regimenIibb'] = it.regimenIibb?.nombre ?: ''
			returnArray['regimenIibbId'] = it.regimenIibb?.id ?: 0
			returnArray['actividad'] = it.actividad?.nombre ?: ''
			if(it.moratoriaPaga()){
				if(it.planesMoratoria){
					def plan = it.planesMoratoria.first()
					returnArray['fechaAdquisicionSE'] = plan.servicioEspecial?.fechaEmisionFactura?.toString("dd/MM/YYYY")
					returnArray['fechaInicioMoratoria'] = plan.inicio.toString("dd/MM/YYYY")
					returnArray['fechaFinMoratoria'] =plan.fin.toString("dd/MM/YYYY")
					returnArray['importeMoratoria'] = "\$ " + formatear(plan.importeTotal)
					returnArray['cuotasTotalesMoratoria'] = plan.cantidadDeCuotas
					returnArray['cuotasVencidasMoratoria'] = plan.cuotasVencidas + '/' + plan.cantidadDeCuotas
					returnArray['estadoMoratoria'] = plan.estado.nombre
				}
				else{
					returnArray['fechaAdquisicionSE'] = "-"
					returnArray['fechaInicioMoratoria'] = "-"
					returnArray['fechaFinMoratoria'] = "-"
					returnArray['importeMoratoria'] = "-"
					returnArray['cuotasTotalesMoratoria'] = "-"
					returnArray['cuotasVencidasMoratoria'] = "-"
					returnArray['estadoMoratoria'] = "-"
				}
			}
			def numero = 0
			it.locales.findAll{it.estado.nombre=="Activo"}.each{
				def local = it
				if(numero!=0){
					returnArray['locales'] += '<br/>'
					returnArray['provincias'] += '<br/>'
				}

				if((local.direccion!=null)&&(local.direccion!=''))
					returnArray['locales'] += local.direccion

				if((local.telefono!=null)&&(local.telefono!=''))
					returnArray['locales'] += ' - ' + local.telefono

				if((local.email!=null)&&(local.email!=''))
					returnArray['locales'] += ' - ' + local.email

				if(local.localidad!=null){
					if((local.localidad.nombre!=null)&&(local.localidad.nombre!=''))
						returnArray['locales'] += ' - ' + local.localidad.nombre
				}

				if(local.zona!=null)
					returnArray['locales'] += ' (' + local.zona.nombre + ')'
				else
					returnArray['locales'] += ' (Sin Zona) '
				
				
				returnArray['provincias'] += local.provincia.nombre
				numero = numero+1 
			}

			returnArray['fechaAlta'] = it.fechaAlta?.toString("dd/MM/YYYY") ?: ''
			returnArray['milisegundos'] = it.fechaAlta?.localMillis ?: ''
			returnArray['fechaConfirmacion'] = it.fechaConfirmacion?.toString("dd/MM/YYYY") ?: ''
			returnArray['responsable'] = it.responsable?.toString() ?: "-"
			returnArray['fechaEnvioConfirmacionMail'] = it.ultimoMailConfirmacion?.fechaHora?.toString("dd/MM/YYYY HH:mm")

			returnArray['porcentajesProvinciaIIBB'] = it.porcentajesProvinciaIIBBActivos?.join('<br/>') ?: ''
			returnArray['porcentajesActividadIIBB'] = it.porcentajesActividadIIBBActivos?.join('<br/>') ?: ''

			returnArray['puntoVenta'] = it.puntoVentaCalim
			returnArray['afipMiscomprobantes'] = it.afipMiscomprobantes
			returnArray['ingresosBrutos'] = it.ingresosBrutos
			returnArray['infoRevisada'] = it.infoRevisada
			returnArray['agipGestionar'] = it.agipGestionar
			returnArray['arbaPresentacionDdjj'] = it.arbaPresentacionDdjj
			returnArray['estado'] = it.estado.nombre

			returnArray['numeroTarjeta'] = it.tarjetaDebitoAutomatico?.numero
			returnArray['smDebitoAutomatico'] = it.servicioActivo != null && it.servicioActivo?.debitoAutomatico
			returnArray['etiqueta'] = it.etiqueta ?: ''
			returnArray['abono'] = it.servicioActivo?.servicio?.toString() ?: '-'
			returnArray['actionRegistro'] = it.actionRegistro
			returnArray['trabajaConApp'] = it.trabajaConApp()
			returnArray['apps'] = it.trabajaConApp() ? it.apps.collect{it.app} : ""

			returnArray['contador'] = it.contador
			returnArray['riderId'] = it.riderId

			return returnArray
		}

		JSON.registerObjectMarshaller(User){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['username'] = it.username
			returnArray['enabled'] = it.enabled
			if(it.enabled)
				returnArray['enabledText'] = 'Si'
			else
				returnArray['enabledText'] = 'No'

			returnArray['accountExpired'] = it.accountExpired
			returnArray['accountLocked'] = it.accountLocked
			returnArray['passwordExpired'] = it.passwordExpired

			def roles = UserRole.findAllByUser(it)

			returnArray['roleText'] = ""
			roles.each { userRole ->
				returnArray['roleText'] = userRole.role.authority
			}

			def estudio = Estudio.get(it.userTenantId.toString())
			if(estudio!=null)
				returnArray['estudioNombre'] = estudio.nombre
			else
				returnArray['estudioNombre'] = ''
			return returnArray
		}

		JSON.registerObjectMarshaller(Role){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.authority

			return returnArray
		}

		JSON.registerObjectMarshaller(Contador){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombreApellido'] = it.nombreApellido
			returnArray['cuit'] = it.cuit
			returnArray['matricula'] = it.matricula
			returnArray['email'] = it.email
			returnArray['whatsapp'] = it.whatsapp
			returnArray['foto'] = it.foto

			return returnArray
		}

		JSON.registerObjectMarshaller(AlicuotaProvinciaActividadIIBB){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['valor'] = it.valor
			returnArray['baseImponibleDesde'] = it.baseImponibleDesde
			returnArray['baseImponibleHasta'] = it.baseImponibleHasta
			if (it.provincia){
				returnArray['provinciaId'] = it.provincia.id
				returnArray['provincia'] = it.provincia.toString()
			}else{
				returnArray['provinciaId'] = ""
				returnArray['provincia'] = ""
			}
			if (it.actividad){
				returnArray['actividadId'] = it.actividad.id
				returnArray['actividad'] = it.actividad.toString()
			}else{
				returnArray['actividadId'] = ""
				returnArray['actividad'] = ""
			}
			if (it.inscriptoArba2021==null){
				returnArray['inscriptoArba2021'] = "-"
			}else{
				if (it.inscriptoArba2021==true){
					returnArray['inscriptoArba2021'] = "Si"
				}else{
					returnArray['inscriptoArba2021'] = "No"
				}
			}
			returnArray['fecha'] = it.fecha ? it.fecha.toString("dd/MM/YYYY") : ""

			return returnArray
		}

		JSON.registerObjectMarshaller(CondicionIva){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre

			return returnArray
		}

		JSON.registerObjectMarshaller(Vep){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['numero'] = it.numero ?: ""
			if(it.cuenta != null){
				returnArray['cuentaId'] = it.cuenta.id
				returnArray['cuentaNombre'] = it.cuenta.toString()
			}
			else{
				returnArray['cuentaId'] = ""
				returnArray['cuentaNombre'] = ""
			}
			if(it.estado != null){
				returnArray['estadoId'] = it.estado.id
				returnArray['estadoNombre'] = it.estado.nombre
			}
			else{
				returnArray['estadoNombre'] = ""
				returnArray['estadoId'] = ""
			}
			returnArray['periodo'] = it.periodo
			returnArray['vencimientoSimplificado'] = it.vencimientoSimplificado?.toString("dd/MM/YYYY") ?: ""
			returnArray['descripcion'] = it.descripcion
			returnArray['importe'] = '$ ' + it.importe?.with{formatear(it)} ?: "-"
			returnArray['fechaPago'] = it.fechaPago?.toString("dd/MM/YYYY") ?: ""
			returnArray['fechaEmision'] = it.fechaEmision?.toString("dd/MM/YYYY") ?: ""
			returnArray['nombreArchivo'] = it.nombreArchivo

			if(it.nombreArchivo.contains(".pdf"))
				returnArray['tipoArchivo'] = "pdf"
			else{
				if(it.nombreArchivo.contains(".doc") || it.nombreArchivo.contains(".docx")){
					returnArray['tipoArchivo'] = "doc"
				}else{
					returnArray['tipoArchivo'] = "otro"
				}
			}
			returnArray['vencimiento'] = it.vencimiento?.toString("dd/MM/YYYY") ?: ""
			returnArray['tipo'] = it.tipo?.nombre ?: ""

			return returnArray
		}

		JSON.registerObjectMarshaller(ClienteProveedor){

			def returnArray = [:]
			returnArray['id'] = it.id
			returnArray['razonSocial'] = it.persona.razonSocial
			returnArray['domicilio'] = it.persona.domicilio
			returnArray['cuit'] = it.persona.cuit
			returnArray['tipoDocumento'] = it.persona.tipoDocumento
			returnArray['email'] = it.email
			returnArray['nota'] = it.nota
			returnArray['alias'] = it.alias

			return returnArray

		}

		JSON.registerObjectMarshaller(App){

			def returnArray = [:]
			returnArray['id'] = it.id

			if(it.persona){
				returnArray['cuit'] = it.persona.cuit
				returnArray['razonSocial'] = it.persona.razonSocial
				returnArray['domicilio'] = it.persona.domicilio
			}else{
				returnArray['cuit'] = ""
				returnArray['razonSocial'] = ""
				returnArray['domicilio'] = ""
			}

			returnArray['nombre'] = it.nombre
			returnArray['logo'] = it.logo

			return returnArray

		}

		JSON.registerObjectMarshaller(PagoCuenta){
			def returnArray = [:]

			returnArray['id'] = it.id
			if(it.cuenta != null){
				returnArray['cuentaId'] = it.cuenta.id
				returnArray['cuentaNombre'] = it.cuenta.toString()
			}
			else{
				returnArray['cuentaId'] = ""
				returnArray['cuentaNombre'] = ""
			}
			if(it.estado != null){
				returnArray['estadoId'] = it.estado.id
				returnArray['estadoNombre'] = it.estado.nombre
			}
			else{
				returnArray['estadoNombre'] = ""
				returnArray['estadoId'] = ""
			}
			returnArray['descripcion'] = it.descripcion
			returnArray['importe'] = formatear(it.importe)
			returnArray['fechaPago'] = it.fechaPago.toString("dd/MM/YYYY")
			returnArray['fechaNotificacion'] = it.notificaciones ? it.getFechaNotificacion()?.toString() : "-"

			if(it.nombreArchivo){
				returnArray['nombreArchivo'] = it.nombreArchivo

				if(it.nombreArchivo.contains(".pdf"))
					returnArray['tipoArchivo'] = "pdf"
				else{
					if(it.nombreArchivo.contains(".doc") || it.nombreArchivo.contains(".docx")){
						returnArray['tipoArchivo'] = "doc"
					}else{
						returnArray['tipoArchivo'] = "otro"
					}
				}
			}else{
				returnArray['nombreArchivo'] = ""
				returnArray['tipoArchivo'] = ""
			}
			return returnArray
		}

		JSON.registerObjectMarshaller(Mensaje){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['asunto'] = it.asunto
			returnArray['mensaje'] = it.mensaje
			returnArray['fechaHora'] = it.fechaHora.toString("dd/MM/YYYY")

			if(it.remitente != null){
				returnArray['cuentaId'] = it.remitente.id
				returnArray['cuentaNombre'] = it.remitente.toString()
			}
			else{
				returnArray['cuentaId'] = ""
				returnArray['cuentaNombre'] = ""
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(MovimientoCuenta){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['responsable'] = it.responsable ?: "-"
			if(it.cuenta != null){
				returnArray['cuentaId'] = it.cuenta.id
				returnArray['cuentaNombre'] = it.cuenta.toString()
			}
			else{
				returnArray['cuentaId'] = ""
				returnArray['cuentaNombre'] = ""
			}

			returnArray['descripcion'] = it.descripcion
			returnArray['movimientosRelacionados'] = ''
			if (it.pago){
				if(!it.factura && !it.declaracion?.liquidacionIva && !it.declaracion?.liquidacionIibb)
					returnArray['descripcion'] = it.pago.descripcionMovimientos	
				def movimientosPagados = MovimientoCuenta.findAllByPago(it.pago) - [it]
				if (it.positivo){
					returnArray['movimientosRelacionados'] = movimientosPagados*.id
					returnArray['descripcionEstudio'] = "${it.descripcion ? it.descripcion + '<br/>' : ''}Paga los movimientos ${movimientosPagados*.id}"
					if (it.tipo != "Pago Reembolsado")
						returnArray['descripcionEstudio'] += " <a style='font-weight: normal;' href='#cuentaCorriente' onclick=\"cancelarPago(${it.pago?.id})\">(cancelar)</a>"
				}
				else{
					def idPositivo = movimientosPagados.find{it.positivo}?.id
					if (idPositivo){
						returnArray['movimientosRelacionados'] = [idPositivo]
						returnArray['descripcionEstudio'] = "${it.descripcion}<br/>Pagado por movimiento [$idPositivo]"
					}
					else
						returnArray['descripcionEstudio'] = "${it.descripcion}<br/>[Asociado al pago NO acreditado #${it.pago?.id}] <a href='#cuentaCorriente' onclick='acreditarPago(${it.pago?.id})'>(acreditar)</a>"
				}
			}else
				returnArray['descripcionEstudio'] = it.descripcion
			returnArray['importe'] = formatear(it.importe)
			returnArray['fechaHora'] = it.fechaHora.toString("dd/MM/YYYY")
			returnArray['milisegundos'] = it.fechaHora.localMillis

			returnArray['positivo'] = it.positivo

			returnArray['declaracion'] = it.declaracion?.id ?: ""
			returnArray['factura'] = it.factura?.id ?: ""
			returnArray['pago'] = it.pago?.id ?: ""
			returnArray['tipo'] = it.tipo

			returnArray['saldo'] = formatear(it.saldo >= 0 ? it.saldo : it.saldo * -1)

			returnArray['pagado'] = it.pagado
			returnArray['selected'] = ""
			return returnArray
		}

		JSON.registerObjectMarshaller(Actividad){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre
			returnArray['codigo'] = it.codigo
			returnArray['codigoAfip'] = it.codigoAfip
			returnArray['codigoNaes'] = it.codigoNaes
			returnArray['codigoCuacm'] = it.codigoCuacm

			returnArray['descripcionAfip'] = it.descripcionAfip
			returnArray['descripcionNaes'] = it.descripcionNaes
			returnArray['descripcionCuacm'] = it.descripcionCuacm

			def cantidadCaba = 0
			def cantidadBsAs = 0
			it.alicuotasActividadIIBB.each{
				def alicuota = it
				if(alicuota.provincia.nombre=='CABA')
					cantidadCaba++

				if(alicuota.provincia.nombre=='Buenos Aires')
					cantidadBsAs++
			}

			returnArray['cantidadAlicuotasCaba'] = cantidadCaba
			returnArray['cantidadAlicuotasBuenosAires'] = cantidadBsAs

			returnArray['toString'] = it.toString()
			if(it.utilidadMaxima!=null){
				returnArray['utilidadMaxima'] = formatear(it.utilidadMaxima)
			}else{
				returnArray['utilidadMaxima'] = ''
			}
			if(it.utilidadMinima!=null){
				returnArray['utilidadMinima'] = formatear(it.utilidadMinima)
			}else{
				returnArray['utilidadMinima'] = ''
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(RegimenIibb){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre

			return returnArray
		}

		JSON.registerObjectMarshaller(Localidad){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre
			returnArray['provinciaNombre'] = it.provincia.nombre

			return returnArray
		}

		JSON.registerObjectMarshaller(Zona){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre

			return returnArray
		}

		JSON.registerObjectMarshaller(Estado){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre

			return returnArray
		}

		JSON.registerObjectMarshaller(Local){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['localId'] = it.id
			returnArray['numeroLocal'] = it.numeroLocal
			returnArray['direccion'] = it.direccion
			returnArray['email'] = it.email
			returnArray['email'] = it.urlQrCode
			returnArray['localidadId'] = it.localidad.id
			returnArray['localidadNombre'] = it.localidad.nombre
			returnArray['provinciaId'] = it.localidad.provincia.id
			returnArray['provinciaNombre'] = it.localidad.provincia.nombre
			
			if(it.zona!=null){
				returnArray['zonaId'] = it.zona.id
				returnArray['zonaNombre'] = it.zona.nombre
			}else{
				returnArray['zonaId'] = ''
				returnArray['zonaNombre'] = ''
			}
			returnArray['cantidadEmpleados'] = it.cantidadEmpleados ?:"0"
			returnArray['estadoId'] = it.estado.id
			returnArray['estadoNombre'] = it.estado.nombre
			returnArray['porcentaje'] = it.porcentaje
			returnArray['telefono'] = it.telefono
			returnArray['porcentajeIIBB'] = it.porcentajeIIBB
			returnArray['toString'] = it.toString()

			return returnArray
		}

		JSON.registerObjectMarshaller(Pariente){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['parienteId'] = it.id
			returnArray['tipoId'] = it.tipoId
			returnArray['nombre'] = it.nombre
			returnArray['apellido'] = it.apellido
			returnArray['cuil'] = it.cuil
			returnArray['toString'] = it.toString()
			if(it.tipoId==0){
				returnArray['fecha'] = it.fechaCasamiento.toString("dd/MM/YYYY")
				returnArray['tipoNombre'] = 'Conyuge'
			}else{
				returnArray['fecha'] = it.fechaNacimiento.toString("dd/MM/YYYY")
				returnArray['tipoNombre'] = 'Hijo/a'
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(AlicuotaIIBB){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['alicuotaIIBBId'] = it.id
			returnArray['provinciaId'] = it.provincia.id
			returnArray['provinciaNombre'] = it.provincia.nombre
			returnArray['valor'] = it.valor
			returnArray['porcentaje'] = it.porcentaje

			returnArray['ultimoModificador'] = it.ultimoModificador
			if(it.ultimaModificacion!=null)
				returnArray['ultimaModificacion'] = it.ultimaModificacion.toString("dd/MM/YYYY HH:mm:ss")
			else
				returnArray['ultimaModificacion'] = ''

			return returnArray
		}

		JSON.registerObjectMarshaller(PorcentajeProvinciaIIBB){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['porcentajeProvinciaIIBBId'] = it.id
			returnArray['provinciaId'] = it.provincia.id
			returnArray['provinciaNombre'] = it.provincia.nombre
			returnArray['porcentaje'] = it.porcentaje

			returnArray['ultimoModificador'] = it.ultimoModificador
			if(it.ultimaModificacion!=null)
				returnArray['ultimaModificacion'] = it.ultimaModificacion.toString("dd/MM/YYYY HH:mm:ss")
			else
				returnArray['ultimaModificacion'] = ''

			return returnArray
		}

		JSON.registerObjectMarshaller(PorcentajeActividadIIBB){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['porcentajeActividadIIBBId'] = it.id
			returnArray['actividadId'] = it.actividad.id
			returnArray['actividadNombre'] = it.actividad.toString()
			returnArray['porcentaje'] = it.porcentaje

			if(it.puntoVenta!=null){
				returnArray['puntoVentaId'] = it.puntoVenta.id
				returnArray['puntoVentaNumero'] = it.puntoVenta.numero
			}

			returnArray['ultimoModificador'] = it.ultimoModificador
			if(it.ultimaModificacion!=null)
				returnArray['ultimaModificacion'] = it.ultimaModificacion.toString("dd/MM/YYYY HH:mm:ss")
			else
				returnArray['ultimaModificacion'] = ''

			return returnArray
		}

		JSON.registerObjectMarshaller(LiquidacionIva){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['liquidacionIvaId'] = it.id

			returnArray['fecha'] = it.fecha
			returnArray['mes'] = it.fecha.toString("MM")
			returnArray['ano'] = it.fecha.toString("YYYY")

			returnArray['porcentajeDebitoCredito'] = formatear(it.porcentajeDebitoCredito ?: 0)
			returnArray['netoVenta'] = formatear(it.netoVenta ?: 0)
			returnArray['debitoFiscal'] = formatear(it.debitoFiscal ?: 0)
			returnArray['debitoFiscal21'] = formatear(it.debitoFiscal21 ?: 0)
			returnArray['debitoFiscal2'] = formatear(it.debitoFiscal2 ?: 0)
			returnArray['debitoFiscal5'] = formatear(it.debitoFiscal5 ?: 0)
			returnArray['debitoFiscal10'] = formatear(it.debitoFiscal10 ?: 0)
			returnArray['debitoFiscal27'] = formatear(it.debitoFiscal27 ?: 0)
			returnArray['totalNoGravadoVenta'] = formatear(it.totalNoGravadoVenta ?: 0)
			returnArray['totalExentoVenta'] = formatear(it.totalExentoVenta ?: 0)
			returnArray['totalVenta'] = formatear(it.totalVenta ?: 0)
			returnArray['netoCompra'] = formatear(it.netoCompra ?: 0)
			returnArray['creditoFiscal'] = formatear(it.creditoFiscal ?: 0)
			returnArray['creditoFiscal21'] = formatear(it.creditoFiscal21 ?: 0)
			returnArray['creditoFiscal10'] = formatear(it.creditoFiscal10 ?: 0)
			returnArray['creditoFiscal27'] = formatear(it.creditoFiscal27 ?: 0)
			returnArray['creditoFiscal2'] = formatear(it.creditoFiscal2 ?: 0)
			returnArray['creditoFiscal5'] = formatear(it.creditoFiscal5 ?: 0)
			returnArray['totalNoGravadoCompra'] = formatear(it.totalNoGravadoCompra ?: 0)
			returnArray['totalExentoCompra'] = formatear(it.totalExentoCompra ?: 0)
			returnArray['totalCompra'] = formatear(it.totalCompra ?: 0)
			returnArray['debitoMenosCredito'] = formatear(it.debitoMenosCredito ?: 0)
			returnArray['saldoTecnicoAFavorPeriodoAnterior'] = formatear(it.saldoTecnicoAFavorPeriodoAnterior ?: 0)
			returnArray['saldoTecnicoAFavor'] = formatear(it.saldoTecnicoAFavor ?: 0)
			returnArray['saldoLibreDisponibilidadPeriodoAnterior'] = formatear(it.saldoLibreDisponibilidadPeriodoAnterior ?: 0)
			returnArray['saldoLibreDisponibilidad'] = formatear(it.saldoLibreDisponibilidad ?: 0)
			returnArray['retencion'] = formatear(it.retencion ?: 0)
			returnArray['percepcion'] = formatear(it.percepcion ?: 0)
			returnArray['saldoDdjj'] = formatear(it.saldoDdjj ?: 0)

			returnArray['facturasCompraImportadas'] = it.facturasCompraImportadas ? 'Importado' : '-'
			returnArray['facturasVentaImportadas'] = it.facturasVentaImportadas ? 'Importado' : '-'

			returnArray['notificado'] = it.notificado ? 'Si' : '-'
			if(it.fechaHoraNotificacion!=null)
				returnArray['fechaHoraNotificacion'] = it.fechaHoraNotificacion.toString('dd/MM/YYYY HH:mm')
			else
				returnArray['fechaHoraNotificacion'] = '-'

			if(it.fechaVencimiento!=null)
				returnArray['fechaVencimiento'] = it.fechaVencimiento.toString('dd/MM/YYYY')
			else
				returnArray['fechaVencimiento'] = '-'

			if(it.nota!=null)
				returnArray['nota'] = it.nota
			else
				returnArray['nota'] = ''

			returnArray['locales'] = ''
			returnArray['zonas'] = ''
			returnArray['direcciones'] = ''
			returnArray['cantidadLocales'] = ''
			if(it.liquidacionlocales!=null){
				def numero = 0
				it.liquidacionlocales.each{
					def local = it.local
					if(numero!=0){
						returnArray['locales'] += '<br/>\n\t'
						returnArray['zonas'] += ' - <br/>\n\t'
						returnArray['direcciones'] += ' - <br/>\n\t'
					}

					if(it.saldoDdjj!=null)
						returnArray['locales'] += '<< $' + formatear(it.saldoDdjj) + ' >> ' + local.direccion + ' - ' + local.localidad.nombre + ' ' + formatear(it.porcentajeLocal) + '% '
					else
						returnArray['locales'] += local.direccion + ' - ' + local.localidad.nombre + ' ' + formatear(it.porcentajeLocal) + '% '

					returnArray['direcciones'] += local.direccion

					if(local.zona!=null)
						returnArray['zonas'] += local.zona.nombre
					else
						returnArray['zonas'] += 'Sin Zona'

					numero = numero+1
				}

				returnArray['cantidadLocales'] = numero
			}

			returnArray['estado'] = it.estado.nombre
			returnArray['estadoUsuario'] = it.estadoUsuario

			returnArray['cuentaId'] = it.cuenta.id
			returnArray['cuentaNombre'] = it.cuenta.razonSocial
			returnArray['cuentaEmail'] = it.cuenta.email
			returnArray['cuentaCuit'] = it.cuenta.cuit

			def advertencias = []
			if(it.porcentajeDebitoCredito!=null){
				//Se analiza si se pasa de límite
				if((it.estado.nombre!='Sin liquidar')&&(it.estado.nombre!='Per/Ret ingresado')&&(it.estado.nombre!='Nota ingresada')){
					if(it.cuenta.actividad!=null){
						if(it.cuenta.actividad.utilidadMaxima!=null){
							if(it.porcentajeDebitoCredito>it.cuenta.actividad.utilidadMaxima){
								advertencias << 'Supera utilidad para ' + it.cuenta.actividad.nombre + ' de ' + formatear(it.cuenta.actividad.utilidadMaxima) + '%'
							}

							if(it.porcentajeDebitoCredito<it.cuenta.actividad.utilidadMinima){
								advertencias << 'Por debajo de utilidad para ' + it.cuenta.actividad.nombre + ' de ' + formatear(it.cuenta.actividad.utilidadMinima) + '%'
							}
						}
					}
				}
			}
			if (it.tenantId == 1 && it.creditoFiscal10 > (it.creditoFiscal21 * 1.1))
				advertencias << "El CF10 supera al CF21 en más del 10%"
			returnArray['advertencia'] = advertencias.join("</br>")

			returnArray['selected'] = ''

			/*returnArray['debitoFiscalConSimbolo'] = "\$" + formatear(it.debitoFiscal)
			returnArray['creditoFiscalConSimbolo'] = "\$" + formatear(it.creditoFiscal)
			returnArray['saldoTecnicoAFavorConSimbolo'] = "\$" + formatear(it.saldoTecnicoAFavor)
			returnArray['saldoLibreDisponibilidadConSimbolo'] = "\$" + formatear(it.saldoLibreDisponibilidad)
			returnArray['retencionConSimbolo'] = "\$" + formatear(it.retencion)
			returnArray['percepcionConSimbolo'] = "\$" + formatear(it.percepcion)
			returnArray['saldoDdjjConSimbolo'] = "\$" + formatear(it.saldoDdjj)
			*/

			return returnArray
		}

		JSON.registerObjectMarshaller(LiquidacionIIBB){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['liquidacionIIBBId'] = it.id

			if(it.provincia!=null){
				returnArray['provinciaId'] = it.provincia.id
				returnArray['provinciaNombre'] = it.provincia.toString(true)
			}else{
				returnArray['provinciaId'] = ''
				returnArray['provinciaNombre'] = ''
			}

			returnArray['fecha'] = it.fecha
			returnArray['mes'] = it.fecha.toString("MM")
			returnArray['ano'] = it.fecha.toString("YYYY")
			returnArray["alicuotas"] = it.alicuotas?.collect{it.alicuota}?.join("<br/>") ?: "-"
			returnArray["actividades"] = it.alicuotas?.collect{it.actividad.toString()}?.join("<br/>") ?: "-"

			if(it.neto!=null){
				returnArray['neto'] = formatear(it.neto)
			}else{
				returnArray['neto'] = ''
			}

			if(it.netoTotal!=null){
				returnArray['netoTotal'] = formatear(it.netoTotal)
			}else{
				returnArray['netoTotal'] = ''
			}

			if(it.porcentajeProvincia!=null){
				returnArray['porcentajeProvincia'] = formatear(it.porcentajeProvincia)
			}else{
				returnArray['porcentajeProvincia'] = ''
			}

			if(it.impuesto!=null)
				returnArray['impuesto'] = formatear(it.impuesto)
			else
				returnArray['impuesto'] = ''

			if(it.retencion!=null)
				returnArray['retencion'] = formatear(it.retencion)
			else
				returnArray['retencion'] = ''

			if(it.sircreb!=null)
				returnArray['sircreb'] = formatear(it.sircreb)
			else
				returnArray['sircreb'] = ''

			if(it.percepcion!=null)
				returnArray['percepcion'] = formatear(it.percepcion)
			else
				returnArray['percepcion'] = ''

			if(it.saldoAFavorPeriodoAnterior!=null)
				returnArray['saldoAFavorPeriodoAnterior'] = formatear(it.saldoAFavorPeriodoAnterior)
			else
				returnArray['saldoAFavorPeriodoAnterior'] = ''

			if(it.saldoAFavor!=null)
				returnArray['saldoAFavor'] = formatear(it.saldoAFavor)
			else
				returnArray['saldoAFavor'] = ''

			if(it.saldoDdjj!=null)
				returnArray['saldoDdjj'] = formatear(it.saldoDdjj)
			else
				returnArray['saldoDdjj'] = ''

			returnArray['notificado'] = it.notificado ? 'Si' : '-'
			if(it.fechaHoraNotificacion!=null)
				returnArray['fechaHoraNotificacion'] = it.fechaHoraNotificacion.toString('dd/MM/YYYY HH:mm')
			else
				returnArray['fechaHoraNotificacion'] = '-'

			if(it.fechaVencimiento!=null)
				returnArray['fechaVencimiento'] = it.fechaVencimiento.toString('dd/MM/YYYY')
			else
				returnArray['fechaVencimiento'] = '-'

			if(it.nota!=null)
				returnArray['nota'] = it.nota
			else
				returnArray['nota'] = ''

			returnArray['locales'] = ''
			returnArray['zonas'] = ''
			returnArray['direcciones'] = ''
			returnArray['cantidadLocales'] = ''
			if(it.liquidacionlocales!=null){
				def numero = 0
				it.liquidacionlocales.each{
					def local = it.local
					if(numero!=0){
						returnArray['locales'] += '<br/>\n\t'
						returnArray['zonas'] += ' - <br/>\n\t'
						returnArray['direcciones'] += ' - <br/>\n\t'
					}

					if(it.saldoDdjj!=null)
						returnArray['locales'] += '<< $' + formatear(it.saldoDdjj) + ' >> ' + local.direccion + ' - ' + local.localidad.nombre + ' ' + formatear(it.porcentajeLocal) + '% '
					else
						returnArray['locales'] += local.direccion + ' - ' + local.localidad.nombre + ' ' + formatear(it.porcentajeLocal) + '% '

					returnArray['direcciones'] += local.direccion

					if(local.zona!=null)
						returnArray['zonas'] += local.zona.nombre
					else
						returnArray['zonas'] += 'Sin Zona'

					numero = numero+1
				}

				returnArray['cantidadLocales'] = numero
			}

			returnArray['estado'] = it.estado.nombre
			returnArray['estadoUsuario'] = it.estadoUsuario

			returnArray['cuentaId'] = it.cuenta.id
			// returnArray['cuentaNombre'] = it.cuenta.razonSocial
			returnArray['cuentaNombre'] = "<a href='/cuenta/show/" + it.cuenta.id + "' target='_blank'>" + it.cuenta.razonSocial + "</a>"
			returnArray['cuentaCuit'] = it.cuenta.cuit
			returnArray['cuentaEmail'] = it.cuenta.email

			def advertencias = []
			if(it.percepcion && it.percepcion<0) //Se analiza si se pasa de límite
				advertencias << 'Percepcion negativa.'
			if (it.nuevaProvincia)
				advertencias << "Nueva Provincia."
			if (it.masFacturadoQueVendido)
				advertencias << "El monto facturado (afip) es mayor al informado por el cliente."
			if (it.saldoNoIdentificadoInsuficiente)
				advertencias << "La facturación total no alcanza para cancelar la venta total."
			else if (it.diferenciaNetoCalculado){
				if (it.diferenciaNetoCalculado == it.neto)
					advertencias << "No se detectó facturación en esta provincia."
				else
					advertencias << "La facturación de la provincia es menor a la venta."
			}
			if (it.alicuotaGeneral)
				advertencias << "Utilizamos la Alicuota General de la provincia."

			returnArray['advertencia'] = advertencias.join("<br/>")
			// returnArray['nuevaProvincia'] = it.nuevaProvincia ? 'Sí' : '-'
			returnArray['selected'] = ''

			return returnArray
		}

		JSON.registerObjectMarshaller(LiquidacionIIBBAlicuota){
			def returnArray = [:]

			if(it.id!=null){
				returnArray['liquidacionIIBBAlicuotaId'] = it.id
			}else{
				returnArray['liquidacionIIBBAlicuotaId'] = ''
			}

			if(it.baseImponible!=null){
				returnArray['baseImponible'] = formatear(it.baseImponible)
			}else{
				returnArray['baseImponible'] = ''
			}

			if(it.impuesto!=null)
				returnArray['impuesto'] = formatear(it.impuesto)
			else
				returnArray['impuesto'] = ''

			if(it.alicuota!=null)
				returnArray['alicuota'] = formatear(it.alicuota)
			else
				returnArray['alicuota'] = ''

			if(it.porcentaje!=null)
				returnArray['porcentaje'] = formatear(it.porcentaje)
			else
				returnArray['porcentaje'] = ''

			return returnArray
		}

		JSON.registerObjectMarshaller(LiquidacionGanancia){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['liquidacionGananciaId'] = it.id

			returnArray['fecha'] = it.fecha
			returnArray['ano'] = it.fecha.toString("YYYY")

			if(it.netoVenta!=null){
				returnArray['netoVenta'] = formatear(it.netoVenta)
			}else{
				returnArray['netoVenta'] = ''
			}

			if(it.netoCompra!=null){
				returnArray['netoCompra'] = formatear(it.netoCompra)
			}else{
				returnArray['netoCompra'] = ''
			}

			if(it.totalIngresos!=null){
				returnArray['totalIngresos'] = formatear(it.totalIngresos)
			}else{
				returnArray['totalIngresos'] = ''
			}

			if(it.existenciaInicial!=null){
				returnArray['existenciaInicial'] = formatear(it.existenciaInicial)
			}else{
				returnArray['existenciaInicial'] = ''
			}

			if(it.existenciaFinal!=null){
				returnArray['existenciaFinal'] = formatear(it.existenciaFinal)
			}else{
				returnArray['existenciaFinal'] = ''
			}

			if(it.ingresosBrutos!=null){
				returnArray['ingresosBrutos'] = formatear(it.ingresosBrutos)
			}else{
				returnArray['ingresosBrutos'] = ''
			}

			if(it.totalGastosDeducciones!=null){
				returnArray['totalGastosDeducciones'] = formatear(it.totalGastosDeducciones)
			}else{
				returnArray['totalGastosDeducciones'] = ''
			}

			if(it.costoMercaderiaVendida!=null){
				returnArray['costoMercaderiaVendida'] = formatear(it.costoMercaderiaVendida)
			}else{
				returnArray['costoMercaderiaVendida'] = ''
			}

			if(it.costoTotal!=null){
				returnArray['costoTotal'] = formatear(it.costoTotal)
			}else{
				returnArray['costoTotal'] = ''
			}

			if(it.rentaImponible!=null){
				returnArray['rentaImponible'] = formatear(it.rentaImponible)
			}else{
				returnArray['rentaImponible'] = ''
			}

			if(it.baseGNI!=null){
				returnArray['baseGNI'] = formatear(it.baseGNI)
			}else{
				returnArray['baseGNI'] = ''
			}

			if(it.mesesGNI!=null){
				returnArray['mesesGNI'] = formatear(it.mesesGNI)
			}else{
				returnArray['mesesGNI'] = ''
			}

			if(it.gananciaNoImponible!=null){
				returnArray['gananciaNoImponible'] = formatear(it.gananciaNoImponible)
			}else{
				returnArray['gananciaNoImponible'] = ''
			}

			if(it.baseDE!=null){
				returnArray['baseDE'] = formatear(it.baseDE)
			}else{
				returnArray['baseDE'] = ''
			}

			if(it.mesesDE!=null){
				returnArray['mesesDE'] = formatear(it.mesesDE)
			}else{
				returnArray['mesesDE'] = ''
			}

			if(it.deduccionEspecial!=null){
				returnArray['deduccionEspecial'] = formatear(it.deduccionEspecial)
			}else{
				returnArray['deduccionEspecial'] = ''
			}

			if(it.subtotalGananciaImponible!=null){
				returnArray['subtotalGananciaImponible'] = formatear(it.subtotalGananciaImponible)
			}else{
				returnArray['subtotalGananciaImponible'] = ''
			}

			if(it.gananciaImponible!=null){
				returnArray['gananciaImponible'] = formatear(it.gananciaImponible)
			}else{
				returnArray['gananciaImponible'] = ''
			}

			if(it.retencion!=null)
				returnArray['retencion'] = formatear(it.retencion)
			else
				returnArray['retencion'] = ''

			if(it.percepcion!=null)
				returnArray['percepcion'] = formatear(it.percepcion)
			else
				returnArray['percepcion'] = ''

			if(it.anticipos!=null)
				returnArray['anticipos'] = formatear(it.anticipos)
			else
				returnArray['anticipos'] = ''

			if(it.impuestoDebitoCredito!=null)
				returnArray['impuestoDebitoCredito'] = formatear(it.impuestoDebitoCredito)
			else
				returnArray['impuestoDebitoCredito'] = ''

			if(it.impuestoDeterminado!=null)
				returnArray['impuestoDeterminado'] = formatear(it.impuestoDeterminado)
			else
				returnArray['impuestoDeterminado'] = ''

			if(it.impuesto!=null)
				returnArray['impuesto'] = formatear(it.impuesto)
			else
				returnArray['impuesto'] = ''

			if(it.sumatoriaPatrimonioInicial!=null)
				returnArray['sumatoriaPatrimonioInicial'] = formatear(it.sumatoriaPatrimonioInicial)
			else
				returnArray['sumatoriaPatrimonioInicial'] = ''

			if(it.sumatoriaPatrimonioFinal!=null)
				returnArray['sumatoriaPatrimonioFinal'] = formatear(it.sumatoriaPatrimonioFinal)
			else
				returnArray['sumatoriaPatrimonioFinal'] = ''

			if(it.consumido!=null)
				returnArray['consumido'] = formatear(it.consumido)
			else
				returnArray['consumido'] = ''

			if(it.totalPatrimonio!=null)
				returnArray['totalPatrimonio'] = formatear(it.totalPatrimonio)
			else
				returnArray['totalPatrimonio'] = ''

			if(it.nota!=null)
				returnArray['nota'] = it.nota
			else
				returnArray['nota'] = ''

			returnArray['locales'] = ''
			returnArray['zonas'] = ''
			returnArray['direcciones'] = ''
			returnArray['cantidadLocales'] = ''

			def cuenta = it.cuenta
			if(cuenta.locales!=null){
				def numero = 0
				cuenta.locales.each{
					def local = it
					if(numero!=0){
						returnArray['locales'] += '<br/>\n\t'
						returnArray['zonas'] += ' - <br/>\n\t'
						returnArray['direcciones'] += ' - <br/>\n\t'
					}

					returnArray['locales'] += local.direccion + ' - ' + local.localidad.nombre + ' ' + formatear(it.porcentaje) + '% '
					returnArray['direcciones'] += local.direccion

					if(local.zona!=null)
						returnArray['zonas'] += local.zona.nombre
					else
						returnArray['zonas'] += 'Sin Zona'

					numero = numero+1
				}

				returnArray['cantidadLocales'] = numero
			}

			returnArray['estado'] = it.estado.nombre

			returnArray['cuentaId'] = it.cuenta.id
			returnArray['cuentaNombre'] = it.cuenta.razonSocial
			returnArray['cuentaCuit'] = it.cuenta.cuit

			returnArray['advertencia'] = ''
			if(it.percepcion!=null){
				if(it.percepcion<0){
					//Se analiza si se pasa de límite
					returnArray['advertencia'] = 'Percepcion negativa'
				}
			}

			returnArray['selected'] = ''

			return returnArray
		}

		JSON.registerObjectMarshaller(RangoImpuestoGanancia){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['rangoImpuestoGananciaId'] = it.id

			returnArray['fecha'] = it.fecha
			returnArray['ano'] = it.fecha.toString("YYYY")

			if(it.desde!=null){
				returnArray['desde'] = formatearSinPunto(it.desde)
			}else{
				returnArray['desde'] = ''
			}

			if(it.hasta!=null){
				returnArray['hasta'] = formatearSinPunto(it.hasta)
			}else{
				returnArray['hasta'] = ''
			}

			if(it.fijo!=null){
				returnArray['fijo'] = formatearSinPunto(it.fijo)
			}else{
				returnArray['fijo'] = ''
			}

			if(it.porcentaje!=null){
				returnArray['porcentaje'] = formatearSinPunto(it.porcentaje)
			}else{
				returnArray['porcentaje'] = ''
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(MontoConceptoDeducibleGanancia){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['montoConceptoDeducibleGananciaId'] = it.id

			returnArray['fecha'] = it.fecha
			returnArray['ano'] = it.fecha.toString("YYYY")

			if(it.concepto!=null){
				returnArray['concepto'] = it.concepto
			}else{
				returnArray['concepto'] = ''
			}

			switch(it.concepto){
				case 0:
					returnArray['conceptoNombre'] = 'Conyuge'
					break
				case 1:
					returnArray['conceptoNombre'] = 'Hijo/a'
					break
				case 2:
					returnArray['conceptoNombre'] = 'Ganancia no imponible'
					break
				case 3:
					returnArray['conceptoNombre'] = 'Deduccion especial'
					break
			}

			if(it.valor!=null){
				returnArray['valor'] = formatearSinPunto(it.valor)
			}else{
				returnArray['valor'] = ''
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(ParienteGanancia){
			def returnArray = [:]

			if(it.id!=null){
				returnArray['id'] = it.id
				returnArray['parienteGananciaId'] = it.id
			}else{
				returnArray['id'] = '-1'
				returnArray['parienteGananciaId'] = '-1'
			}

			if(it.base!=null){
				returnArray['base'] = formatearSinPunto(it.base)
			}else{
				returnArray['base'] = ''
			}

			if(it.meses!=null){
				returnArray['meses'] = it.meses
			}else{
				returnArray['meses'] = ''
			}

			if(it.valor!=null){
				returnArray['valor'] = formatearSinPunto(it.valor)
			}else{
				returnArray['valor'] = ''
			}

			if(it.pariente!=null){
				returnArray['parienteId'] = it.pariente.id
				returnArray['parienteNombre'] = it.pariente.nombre
				returnArray['parienteApellido'] = it.pariente.apellido
				returnArray['parienteCuil'] = it.pariente.cuil
				returnArray['tipoId'] = it.pariente.tipoId
				if(it.pariente.tipoId==0){
					returnArray['parienteTipoNombre'] = 'Conyuge'
					LocalDate fecha = it.pariente.fechaCasamiento
					returnArray['parienteFecha'] = fecha.toString("dd/MM/YYYY")
				}else{
					returnArray['parienteTipoNombre'] = 'Hijo/a'
					LocalDate fecha = it.pariente.fechaNacimiento
					returnArray['parienteFecha'] = fecha.toString("dd/MM/YYYY")
				}
			}else{
				returnArray['parienteId'] = ''
				returnArray['parienteNombre'] = ''
				returnArray['parienteApellido'] = ''
				returnArray['parienteCuil'] = ''
				returnArray['tipoId'] = ''
				returnArray['parienteTipoNombre'] = ''
				returnArray['parienteFecha'] = ''
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(GastoDeduccionGanancia){
			def returnArray = [:]

			if(it.id!=null){
				returnArray['id'] = it.id
				returnArray['gastoDeduccionId'] = it.id
			}else{
				returnArray['id'] = '-1'
				returnArray['gastoDeduccionId'] = '-1'
			}

			if(it.tipo!=null){
				returnArray['tipoId'] = it.tipo.id
				returnArray['tipoNombre'] = it.tipo.nombre
			}else{
				returnArray['tipoId'] = ''
				returnArray['tipoNombre'] = ''
			}

			if(it.valor!=null){
				returnArray['valor'] = formatearSinPunto(it.valor)
			}else{
				returnArray['valor'] = ''
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(PatrimonioGanancia){
			def returnArray = [:]

			if(it.id!=null){
				returnArray['id'] = it.id
				returnArray['patrimonioId'] = it.id
			}else{
				returnArray['id'] = '-1'
				returnArray['patrimonioId'] = '-1'
			}

			if(it.tipo!=null){
				returnArray['tipoId'] = it.tipo.id
				returnArray['tipoNombre'] = it.tipo.nombre
			}else{
				returnArray['tipoId'] = ''
				returnArray['tipoNombre'] = ''
			}

			if(it.valorInicial!=null){
				returnArray['valorInicial'] = formatearSinPunto(it.valorInicial)
			}else{
				returnArray['valorInicial'] = ''
			}

			if(it.valorCierre!=null){
				returnArray['valorCierre'] = formatearSinPunto(it.valorCierre)
			}else{
				returnArray['valorCierre'] = ''
			}

			if(it.detalleInicial!=null){
				returnArray['detalleInicial'] = it.detalleInicial
			}else{
				returnArray['detalleInicial'] = ''
			}

			if(it.detalleCierre!=null){
				returnArray['detalleCierre'] = it.detalleCierre
			}else{
				returnArray['detalleCierre'] = ''
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(FacturaCompra){
			def returnArray = [:]

			if(it.id!=null){
				returnArray['id'] = it.id
				returnArray['facturaCompraId'] = it.id
			}else{
				returnArray['id'] = '-1'
				returnArray['facturaCompraId'] = '-1'
			}

			if(it.proveedor!=null){
				returnArray['personaNombre'] = it.proveedor.cuit + " - " + it.proveedor.razonSocial
			}else{
				returnArray['personaNombre'] = ''
			}

			if(it.cuenta!=null){
				returnArray['cuentaNombre'] = it.cuenta.toString()
			}else{
				returnArray['cuentaNombre'] = ''
			}

			if(it.numero!=null && it.puntoVenta!=null){
				returnArray['numeroFactura'] = it.puntoVenta.toString() + "-" + it.numero.toString()
			}else{
				returnArray['numeroFactura'] = ""
			}

			if(it.fecha!=null){
				returnArray['fecha'] = it.fecha.toString("dd/MM/YYYY")
			}else{
				returnArray['fecha'] = ""
			}

			if(it.tipoComprobante!=null){
				returnArray['tipoComprobante'] = it.tipoComprobante.nombre
			}else{
				returnArray['tipoComprobante'] = ''
			}

			if(it.netoGravado!=null){
				returnArray['netoGravado'] = formatear(it.netoGravado)
			}else{
				returnArray['netoGravado'] = ''
			}

			if(it.iva!=null){
				returnArray['iva'] = formatear(it.iva)
			}else{
				returnArray['iva'] = ''
			}

			if(it.total!=null){
				returnArray['total'] = formatear(it.total)
			}else{
				returnArray['total'] = ''
			}

			if(it.bienImportado!=true){
				returnArray['advertencia'] = "Error al importar."
			}else{
				returnArray['advertencia'] = ''
			}

			if(it.netoGravado!=null && it.netoNoGravado!=null && it.exento!=null){
				returnArray['neto'] = formatear(it.netoGravado + it.netoNoGravado + it.exento)
			}else{
				returnArray['neto'] = formatear(0)
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(FacturaVenta){
			def returnArray = [:]

			if(it.id!=null){
				returnArray['id'] = it.id
				returnArray['facturaVentaId'] = it.id
			}else{
				returnArray['id'] = '-1'
				returnArray['facturaVentaId'] = '-1'
			}

			if(it.cliente!=null){
				returnArray['personaNombre'] = it.cliente.cuit + " - " + it.cliente.razonSocial
			}else{
				if(it.app!=null)
					returnArray['personaNombre'] = it.app.nombre + " - " + it.app.cuit
				else
					returnArray['personaNombre'] = ''
			}

			if(it.cuenta!=null){
				returnArray['cuentaNombre'] = it.cuenta.toString()
			}else{
				returnArray['cuentaNombre'] = ''
			}

			returnArray['numeroFactura'] = String.format("%04d", it.puntoVenta.numero) + "-" + String.format("%08d", it.numero)

			if(it.fecha!=null){
				returnArray['fecha'] = it.fecha.toString("dd/MM/YYYY")
			}else{
				returnArray['fecha'] = ""
			}

			if(it.tipoComprobante!=null){
				returnArray['tipoComprobante'] = it.tipoComprobante.nombre
			}else{
				returnArray['tipoComprobante'] = ''
			}

			if(it.neto!=null){
				returnArray['neto'] = formatear(it.neto)
			}else{
				returnArray['neto'] = ''
			}

			if(it.iva!=null){
				returnArray['iva'] = formatear(it.iva)
			}else{
				returnArray['iva'] = ''
			}

			if(it.total!=null){
				returnArray['total'] = formatear(it.total)
			}else{
				returnArray['total'] = ''
			}

			if(it.bienImportado!=true){
				returnArray['advertencia'] = "Error al importar."
			}else{
				returnArray['advertencia'] = ''
			}

			returnArray['esFacturaCancelada'] = it.esFacturaCancelada()
			returnArray['esNotaDeCredito'] = it.esNotaDeCredito()
			returnArray['cae'] = it.cae ?: "-"

			return returnArray
		}

		JSON.registerObjectMarshaller(Persona){
			def returnArray = [:]

			returnArray['toString'] = it.toString()

			if(it.id!=null){
				returnArray['id'] = it.id
				returnArray['personaId'] = it.id
			}else{
				returnArray['id'] = '-1'
				returnArray['personaId'] = '-1'
			}

			if(it.razonSocial!=null){
				returnArray['razonSocial'] = it.razonSocial
			}else{
				returnArray['razonSocial'] = ""
			}

			if(it.tipoDocumento!=null){
				returnArray['tipoDocumento'] = it.tipoDocumento
			}else{
				returnArray['tipoDocumento'] = ""
			}

			if(it.cuit!=null){
				returnArray['cuit'] = it.cuit
			}else{
				returnArray['cuit'] = ""
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(LogImportacion){
			def returnArray = [:]


			returnArray['nombreArchivo'] = it.nombreArchivo?: "-"

			if(it.id!=null){
				returnArray['id'] = it.id
			}else{
				returnArray['id'] = -1
			}

			returnArray['selected'] = ''

			returnArray['estado'] = it.estado.nombre

			returnArray['responsable'] = it.responsable?: "-"

			if(it.cuenta!=null){
				returnArray['cuentaNombre'] = it.cuenta.toString()
			}else{
				returnArray['cuentaNombre'] = '-'
			}

			if(it.fecha!=null){
				returnArray['fecha'] = it.fecha.toString("dd/MM/YYYY")
			}else{
				returnArray['fecha'] = "-"
			}

			if(it.compra)
				returnArray['tipo'] = "Factura compra"
			else if(it.venta)
				returnArray['tipo'] = "Factura venta"
			else if(it.retencion)
				returnArray['tipo'] = "Retención " + ((it.retPerEsIva) ? "IVA" : "IIBB")
			else if(it.percepcion)
				returnArray['tipo'] = "Percepción " + ((it.retPerEsIva) ? "IVA" : "IIBB")
			else if(it.bancaria)
				returnArray['tipo'] = "Retención bancaria IIBB"
			else
				returnArray['tipo'] = "-"

			if(it.fechaHora!=null){
				returnArray['fechaHora'] = it.fechaHora.toString("dd/MM/YYYY")
			}else{
				returnArray['fechaHora'] = "-"
			}

			returnArray['total'] = it.total
			returnArray['cantidadOk'] = it.cantidadOk
			returnArray['cantidadMal'] = it.cantidadMal
			returnArray['cantidadIgnoradas'] = it.cantidadIgnoradas
			returnArray['nuevasPersonas'] = it.nuevasPersonas
			returnArray['nuevosTiposComprobantes'] = it.nuevosTiposComprobantes

			returnArray['detalle'] = it.detalle?: "-"

			return returnArray
		}

		JSON.registerObjectMarshaller(PuntoVenta){
			def returnArray = [:]

			if(it.id!=null){
				returnArray['id'] = it.id
			}else{
				returnArray['id'] = ''
			}

			if(it.numero!=null){
				returnArray['numero'] = it.numero
			}else{
				returnArray['numero'] = 0
			}

			if(it.domicilio!=null){
				returnArray['domicilio'] = it.domicilio
				returnArray['caption'] = it.numero.toString() + " - " + it.domicilio
			}else{
				returnArray['domicilio'] = ''
				returnArray['caption'] = it.numero.toString()
			}

			if(it.localidad!=null){
				returnArray['localidad'] = it.localidad
			}else{
				returnArray['localidad'] = ''
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(UnidadMedida){
			def returnArray = [:]

			if(it.id!=null){
				returnArray['id'] = it.id
			}else{
				returnArray['id'] = ''
			}

			if(it.nombre!=null){
				returnArray['nombre'] = it.nombre
			}else{
				returnArray['nombre'] = ''
			}

			if(it.medidaAfipId!=null){
				returnArray['medidaAfipId'] = it.medidaAfipId
			}else{
				returnArray['medidaAfipId'] = ''
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(ItemFactura){
			def returnArray = [:]

			returnArray['id'] = returnArray['itemId'] = it.id
			returnArray['detalle'] = it.concepto.nombre
			returnArray['cantidad'] = it.cantidad
			returnArray['precioUnitario'] = formatear(it.precioUnitario)
			returnArray['ivaId'] = it.alicuota.id
			returnArray['ivaNombre'] = it.alicuota.caption
			returnArray['ivaValor'] = formatear(it.alicuota.valor)
			returnArray['neto'] = formatear(it.neto)
			returnArray['iva'] = formatear(it.iva)
			returnArray['total'] = formatear(it.total)

			return returnArray
		}

		JSON.registerObjectMarshaller(EstadoImportacionesItem){
			def returnArray = [:]

			returnArray['locales'] = ''
			returnArray['zonas'] = ''
			returnArray['direcciones'] = ''

			if(it.clienteId!=null){
				Cuenta cliente = Cuenta.get(it.clienteId)
				returnArray['cliente'] = cliente.toString()
				returnArray['clienteId'] = cliente.id

				boolean primeraVuelta = true
				cliente.locales.each{
					def local = it
					if(!primeraVuelta){
						returnArray['locales'] += '<br/>\n\t'
						returnArray['zonas'] += ' - <br/>\n\t'
						returnArray['direcciones'] += ' - <br/>\n\t'
					}

					returnArray['locales'] += local.direccion + ' - ' + local.localidad.nombre

					returnArray['direcciones'] += local.direccion

					if(local.zona!=null)
						returnArray['zonas'] += local.zona.nombre
					else
						returnArray['zonas'] += 'Sin Zona'
					primeraVuelta=false
				}
			}else{
				returnArray['cliente'] = ''
			}

			if(it.compra){
				returnArray['compra'] = "Importado"
			}else{
				returnArray['compra'] = '-'
			}

			if(it.venta){
				returnArray['venta'] = "Importado"
			}else{
				returnArray['venta'] = '-'
			}

			if(it.retencionesIva){
				returnArray['retencionesIva'] = "Importado"
			}else{
				returnArray['retencionesIva'] = '-'
			}

			if(it.percepcionesIva){
				returnArray['percepcionesIva'] = "Importado"
			}else{
				returnArray['percepcionesIva'] = '-'
			}

			if(it.retencionesIibb){
				returnArray['retencionesIibb'] = "Importado"
			}else{
				returnArray['retencionesIibb'] = '-'
			}

			if(it.percepcionesIibb){
				returnArray['percepcionesIibb'] = "Importado"
			}else{
				returnArray['percepcionesIibb'] = '-'
			}

			if(it.bancarias){
				returnArray['bancarias'] = "Importado"
			}else{
				returnArray['bancarias'] = '-'
			}

			if(it.cantidadFacturasCompra){
				returnArray['cantidadFacturasCompra'] = it.cantidadFacturasCompra
			}else{
				returnArray['cantidadFacturasCompra'] = '-'
			}

			if(it.cantidadFacturasVenta){
				returnArray['cantidadFacturasVenta'] = it.cantidadFacturasVenta
			}else{
				returnArray['cantidadFacturasVenta'] = '-'
			}

			if(it.cantidadRetencionesIva){
				returnArray['cantidadRetencionesIva'] = it.cantidadRetencionesIva
			}else{
				returnArray['cantidadRetencionesIva'] = '-'
			}

			if(it.cantidadPercepcionesIva){
				returnArray['cantidadPercepcionesIva'] = it.cantidadPercepcionesIva
			}else{
				returnArray['cantidadPercepcionesIva'] = '-'
			}

			if(it.cantidadRetencionesIibb){
				returnArray['cantidadRetencionesIibb'] = it.cantidadRetencionesIibb
			}else{
				returnArray['cantidadRetencionesIibb'] = '-'
			}

			if(it.cantidadPercepcionesIibb){
				returnArray['cantidadPercepcionesIibb'] = it.cantidadPercepcionesIibb
			}else{
				returnArray['cantidadPercepcionesIibb'] = '-'
			}

			if(it.cantidadBancarias){
				returnArray['cantidadBancarias'] = it.cantidadBancarias
			}else{
				returnArray['cantidadBancarias'] = '-'
			}

			if(it.fecha){
				returnArray['fecha'] = it.fecha
			}else{
				returnArray['fecha'] = '-'
			}

			if(it.archivos){
				returnArray['archivos'] = it.archivos
			}else{
				returnArray['archivos'] = '-'
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(RetencionPercepcionIIBB){
			def returnArray = [:]
			returnArray['id'] = it.id
			returnArray['origen'] = it.origen
			if (it.codigo == "902")
				returnArray['codigo'] = "902 - Bs As"
			else if (it.codigo == "901")
				returnArray['codigo'] = "901 - CABA"
			else if (it.codigo)
				returnArray['codigo'] = it.codigo
			else
				returnArray['codigo'] = "-"
			returnArray['cuit'] = it.cuit
			returnArray['fecha'] = it.fecha.toString("dd/MM/YYYY")
			returnArray['monto'] = "\$" + formatear(it.monto)
			if (it.tipo == "retencion"){
				if (it.comprobante)
					returnArray['comprobante'] = it.comprobante
				else
					returnArray['comprobante'] = "-"
				returnArray['tipo'] = "Retención"
			}else if (it.tipo == "percepcion"){
				if (it.letraComprobante && it.tipoComprobante)
					returnArray['comprobante'] = it.tipoComprobante + it.letraComprobante + " "
				else
					returnArray['comprobante'] = ""
				returnArray['comprobante'] += it.facturaParteA + "-" + it.facturaParteB
				returnArray['tipo'] = "Percepción"
			}else{
				returnArray['comprobante'] = "-"
				returnArray['tipo'] = "Retención Bancaria"
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(RetencionPercepcionIva){
			def returnArray = [:]
			returnArray['id'] = it.id
			if (it.codigo == "902")
				returnArray['codigo'] = "902 - Bs As"
			else if (it.codigo == "901")
				returnArray['codigo'] = "901 - CABA"
			else if (it.codigo)
				returnArray['codigo'] = it.codigo
			else
				returnArray['codigo'] = "-"
			returnArray['cuit'] = it.cuit
			returnArray['fecha'] = it.fecha.toString("dd/MM/YYYY")
			returnArray['monto'] = "\$" + formatear(it.monto)
			if (it.tipo == "retencion"){
				if (it.comprobante)
					returnArray['comprobante'] = it.comprobante
				else
					returnArray['comprobante'] = "-"
				returnArray['tipo'] = "Retención"
			}else if (it.tipo == "percepcion"){
				if (it.letraComprobante && it.tipoComprobante)
					returnArray['comprobante'] = it.tipoComprobante + it.letraComprobante + " "
				else
					returnArray['comprobante'] = ""
				returnArray['comprobante'] += it.facturaParteA + "-" + it.facturaParteB
				returnArray['tipo'] = "Percepción"
			}else{
				returnArray['comprobante'] = "-"
				returnArray['tipo'] = "Retención Bancaria"
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(FacturaCuenta){
			def returnArray = [:]
			returnArray['id'] = it.id
			returnArray['facturaCuentaId'] = it.id
			if(it.cuenta){
				returnArray['cuentaId'] = it.cuenta.id
				returnArray['cuentaNombre'] = it.cuenta.toString()
				returnArray['cuentaEmail'] = it.cuenta.email
			}
			returnArray['fecha'] = it.fechaHora.toString("dd/MM/YYYY")
			returnArray['descripcion'] = it.descripcion
			returnArray['nombreArchivo'] = it.nombreArchivo
			returnArray['importe'] = "\$ " + formatear(it.importe)
			returnArray['importeCrudo'] = it.importe
			returnArray['cobradoCrudo'] = it.pagada ? it.importe : 0

			if(it.nombreArchivo.contains(".pdf"))
				returnArray['tipoArchivo'] = "pdf"
			else{
				if(it.nombreArchivo.contains(".doc") || it.nombreArchivo.contains(".docx")){
					returnArray['tipoArchivo'] = "doc"
				}else{
					returnArray['tipoArchivo'] = "otro"
				}
			}
			returnArray['pagadaCheck'] = it.pagada ? '<i class="icofont icofont-ui-check"></i>' : '-'
			returnArray['fechaPago'] = it.pagada ? it.movimiento?.pago?.fechaPago?.toString("dd/MM/YYYY") : '-'
			returnArray['fechaNotificacion'] = it.fechaNotificacion?.toString("dd/MM/YYYY") ?: '-'
			returnArray['responsable'] = it.itemMensual?.responsable ?: it.itemEspecial?.responsable
			returnArray['cantidadAvisos'] = it.cantidadAvisos ?: 0
			returnArray['cae'] = it.cae ?: '-'
			returnArray['linkPago'] = it.linkPago ?: ''
			returnArray['local'] = it.local?.toString() ?: ''
			returnArray['responsable'] = it.responsable ?: ''
			returnArray['profesion'] = it.cuenta?.profesion
			returnArray['mailMercadoPago'] = it.cuenta?.getMailsMercadoPago()
			
			return returnArray
		}

		JSON.registerObjectMarshaller(DeclaracionJurada){
			def returnArray = [:]
			returnArray['id'] = it.id
			returnArray['declaracionJuradaId'] = it.id
			returnArray['cuentaId'] = it.cuenta.id
			returnArray['cuentaNombre'] = it.cuenta.toString()
			returnArray['fecha'] = it.fecha.toString("dd/MM/YYYY")
			returnArray['descripcion'] = it.descripcion ?: "Sin descripcion"
			returnArray['nombreArchivo'] = it.nombreArchivo
			returnArray['comprobante'] = it.comprobantePago ? "SI" : ((it.estado?.nombre =="Presentada")? "NO" : "-")
			if(it.nombreArchivo.contains(".pdf"))
				returnArray['tipoArchivo'] = "pdf"
			else{
				if(it.nombreArchivo.contains(".doc") || it.nombreArchivo.contains(".docx")){
					returnArray['tipoArchivo'] = "doc"
				}else{
					returnArray['tipoArchivo'] = "otro"
				}
			}

			if (it.liquidacionIva)
				returnArray['tipo'] = "IVA"
			else if (it.liquidacionIibb){
				returnArray['tipo'] = "IIBB (${it.liquidacionIibb.provincia})"
				returnArray['saldoAFavor'] = it.liquidacionIibb.saldoAFavor ? '$' + formatear(it.liquidacionIibb.saldoAFavor) : '-'
			}
			else
				returnArray['tipo'] = "Ganancias"

			returnArray['periodo'] = it.liquidacion?.fecha?.toString("dd/MM/YYYY") ?: ""
			returnArray['estadoNombre'] = it.estado?.nombre ?: ""

			returnArray['saldoDdjj'] = it.liquidacion.saldoDdjj ? '$' + formatear(it.liquidacion.saldoDdjj) : '-'
			returnArray['selected'] = ''

			return returnArray
		}

		JSON.registerObjectMarshaller(ComprobantePago){
			def returnArray = [:]
			returnArray['id'] = it.id
			returnArray['cuentaNombre'] = it.declaracion.cuenta.toString()
			returnArray['comprobantePagoId'] = it.id
			returnArray['declaracionId'] = it.declaracion.id
			returnArray['declaracionDescripcion'] = it.declaracion.descripcion
			returnArray['fecha'] = it.fecha.toString("dd/MM/YYYY")
			returnArray['descripcion'] = it.descripcion ?: "Sin descripcion"
			returnArray['nombreArchivo'] = it.nombreArchivo

			returnArray['periodo'] = it.liquidacion?.fecha?.toString("dd/MM/YYYY") ?: ""

			returnArray['importe'] = it.importe? "\$ " + formatear(it.importe) : '-'
			returnArray['selected'] = ''

			return returnArray
		}


		JSON.registerObjectMarshaller(TipoClave){
			def returnArray = [:]
			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre

			return returnArray
		}

		JSON.registerObjectMarshaller(TipoPersona){
			def returnArray = [:]
			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre

			return returnArray
		}

		JSON.registerObjectMarshaller(Impuesto){
			def returnArray = [:]
			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre

			return returnArray
		}

		JSON.registerObjectMarshaller(CantidadImpuesto){
			def returnArray = [:]
			returnArray['id'] = it.id
			returnArray['monotributo'] = it.monotributo
			returnArray['impuestoId'] = it.impuesto.id
			returnArray['impuestoNombre'] = it.impuesto.nombre
			returnArray['periodoMesAno'] = it.periodo.toString("MM/YYYY")

			return returnArray
		}

		JSON.registerObjectMarshaller(CodigoDescuento){
			def returnArray = [:]
			returnArray['selected'] = ""
			returnArray['id'] = it.id
			returnArray['codigo'] = it.codigo
			returnArray['beneficiado'] = it.beneficiado?.toString() ?: "-"
			returnArray['vendedor'] = it.vendedor?.username ?: "-"
			returnArray['fechaExpiracion'] = it.fechaExpiracion.toString("dd/MM/YYYY")
			returnArray['fechaGenerado'] = it.fechaGenerado.toString("dd/MM/YYYY")
			returnArray['fechaActivacion'] = it.fechaActivacion?.toString("dd/MM/YYYY") ?: "-"
			returnArray['descuento'] = it.descuento ?: ""
			returnArray['detalle'] = it.detalle ?: ""

			return returnArray
		}

		JSON.registerObjectMarshaller(Servicio){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['precio'] = it.precio
			returnArray['precioString'] = "\$${formatear(returnArray['precio'])}"
			returnArray['precioNeto'] = it.precioNeto
			returnArray['precioNetoString'] = "\$${formatear(returnArray['precioNeto'])}"
			returnArray['toString'] =  "${it.toString()} (${returnArray['precioString']})"
			returnArray['codigo'] = it.codigo
			returnArray['subcodigo'] = it.subcodigo
			returnArray['nombre'] = it.nombre
			returnArray['mensualCheck'] = it.mensual ? '<i class="icofont icofont-ui-check"></i>' : '-'

			return returnArray
		}

		JSON.registerObjectMarshaller(ItemServicioEspecial){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['precio'] = "\$${formatear(it.precio)}"
			it.servicio.with{
				returnArray['codigo'] = codigo + (subcodigo ? " (${subcodigo})" : '')
				returnArray['nombre'] = nombre
			}
			returnArray['cuota'] = it.cuotaString
			returnArray['estado'] = it.estado
			returnArray['responsable'] = it.responsable ?: "-"
			returnArray['fecha'] = it.fechaAlta.toString("dd/MM/YYYY")
			
			return returnArray
		}

		JSON.registerObjectMarshaller(ItemServicioMensual){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['precio'] = "\$${formatear(it.servicio.precio)}"
			returnArray['descuento'] = "${formatear(it.descuento)} %"
			it.servicio.with{
				returnArray['codigo'] = codigo + (subcodigo ? ' (' + subcodigo + ')' : '')
				returnArray['nombre'] = nombre
			}
			returnArray['fechaAlta'] = it.fechaAlta.toString("dd/MM/YYYY")
			returnArray['responsable'] = it.responsable ?: "-"
			returnArray['fechaBaja'] = it.fechaBaja?.toString("dd/MM/YYYY") ?: '-'
			returnArray['debitoAutomatico'] = it.debitoAutomatico
			returnArray['borrable'] = it.with{
												LocalDate hoy = new LocalDate();
												return ! fechaBaja || fechaBaja > hoy || fechaAlta > hoy
											}
			
			return returnArray
		}

		JSON.registerObjectMarshaller(NotificacionTemplate){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre
			returnArray['asuntoEmail'] = it.asuntoEmail
			returnArray['cuerpoEmail'] = it.cuerpoEmail
			returnArray['tituloApp'] = it.tituloApp
			returnArray['textoApp'] = it.textoApp

			return returnArray
		}

		JSON.registerObjectMarshaller(PlanMoratoria){
			def returnArray = [:]

			returnArray['cuit'] = it.cuenta?.cuit
			returnArray['nombreApellido'] = it.cuenta?.nombreApellido
			returnArray['email'] = it.cuenta?.email
			returnArray['fechaInicioMoratoria'] = it.inicio
			returnArray['servicioEspecialId'] = it.servicioEspecial.id 
			returnArray['fechaFinMoratoria'] = it.fin
			returnArray['importeMoratoria'] = it.importeTotal
			returnArray['cuotasTotalesMoratoria'] = it.cantidadDeCuotas
			returnArray['cuotasVencidasMoratoria'] = it.cuotasTranscurridas
			returnArray['estadoMoratoria'] = it.estado
		
			return returnArray
		}


		JSON.registerObjectMarshaller(CuotaMoratoria){
			def returnArray = [:]

			returnArray['planMoratoriaId'] = it.id
			returnArray['numero'] = it.numero
			returnArray['importe'] = formatear(it.importe)
		
			return returnArray
		}

		JSON.registerObjectMarshaller(ElementoFaq){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['titulo'] = it.titulo
			returnArray['peso'] = it.peso
			returnArray['categoria'] = it.categoria?.nombre
			returnArray['contenidoHtml'] = it.contenidoHtml
			returnArray['monotributista'] = it.monotributista
			returnArray['respInscripto'] = it.respInscripto
			returnArray['regimenSimplificado'] = it.regimenSimplificado
			returnArray['convenio'] = it.convenio
			returnArray['local'] = it.local

			return returnArray
		}

		JSON.registerObjectMarshaller(CategoriaFaq){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre
			returnArray['peso'] = it.peso

			return returnArray
		}

		JSON.registerObjectMarshaller(MedioPago){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre
			returnArray['afip'] = it.afip
			returnArray['agip'] = it.agip
			returnArray['arba'] = it.arba

			return returnArray
		}

		JSON.registerObjectMarshaller(LogMercadoPago){
			def returnArray = [:]

			returnArray['detalle'] = it.detalle
			returnArray['mensajeError'] = it.mensajeError ?: ''
			def items = []
			it.fallos.each{
				def fallo = [:]
				fallo['notificacionId'] = it.notificacionId
				fallo['mailPagante'] = it.mailPagante
				fallo['fechaHora'] = it.fechaHora
				fallo['descripcion'] = it.descripcion
				fallo['tipoError'] = it.tipoError
				fallo['estado'] = it.estado
				fallo['estadoSistema'] = it.estadoSistema ?: ''
				fallo['monto'] = formatear(it.monto)
				fallo['montoSistema'] = it.montoSistema ? formatear(it.montoSistema) : ''
				fallo['cuenta'] = it.pago?.cuenta?.toString() ?: ''
				fallo['logDisparo'] = it.logDisparo?.replaceAll("\n","<br/>") ?: ''
				items << fallo
			}
			returnArray['fallos'] = items
			return returnArray
		}

		JSON.registerObjectMarshaller(DebitoAutomatico){
			def returnArray = [:]
			
			returnArray['id'] = it.id
			returnArray['numeroTarjeta'] = it.numeroTarjeta
			returnArray['estado'] = it.estado.nombre
			returnArray['fechaVencimiento'] = new LocalDate().toString("dd/MM/YYYY")
			returnArray['fechaCreacion'] = it.fechaCreacion
			returnArray['facturaId'] = it.factura.id
			returnArray['importe'] = "\$ " + formatear(it.importe)
			returnArray['importeCrudo'] = it.importe
			returnArray['cuentaId'] = it.cuenta.id
			returnArray['cuenta'] = it.cuenta.toString()
			returnArray['primerDebito'] = it.primerDebito ? 'E' : 'N'
			returnArray['tipo'] = it.tipo

			return returnArray
		}

		JSON.registerObjectMarshaller(Proforma){
			def returnArray = [:]
			
			returnArray['id'] = it.id
			returnArray['importe'] = "\$ " + formatear(it.importe)
			returnArray['importeSinFormatear'] = it.importe
			returnArray['riderId'] = it.riderId
			returnArray['cuenta'] = it.cuenta.toString()
			returnArray['fecha'] = it.fecha
			returnArray['cuit'] = it.cuit
			returnArray['estado'] = it.estado.toString()
			returnArray['estadoDetallado'] = returnArray.estado + (returnArray.estado == "Verificada" ? ' (' + (it.nombreArchivo ? 'PDF' : 'Fact.Calim') + ')' : '')
			returnArray['ultimaSubida'] = it.ultimaSubida?.toString("dd/MM/YYYY")
			returnArray['nombreArchivo'] = it.nombreArchivo
			returnArray['facturaId'] = it.factura?.id ?: ''

			return returnArray
		}

		JSON.registerObjectMarshaller(VendedorDiaExtra){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['fecha'] = it.fecha.toString("dd/MM/YYYY")
			returnArray['detalle'] = it.detalle
			returnArray['vendedor'] = it.vendedor?.nombre ?: "-"

			return returnArray
		}

		JSON.registerObjectMarshaller(LogSelenium){
			def returnArray = [:]

			returnArray.with{ nuevo ->
				comprobantes = it.comprobantes
				afipRetenciones = it.afipRetenciones
				afipPercepciones = it.afipPercepciones
				arbaRetenciones = it.arbaRetenciones
				arbaPercepciones = it.arbaPercepciones
				agipRetenciones = it.agipRetenciones
				agipPercepciones = it.agipPercepciones
				agipPercepciones = it.agipPercepciones
				arbaBancarias = it.arbaBancarias
				agipBancarias = it.agipBancarias
				convenioRetenciones = it.convenioRetenciones
				errorE1 = it.with{
					String salida = ""
					if (errorAfip)
						salida = errorAfip
					if (errorAgip)
						salida += (salida ? "<br/>" : '') + "Agip: " + errorAgip
					if (errorArba)
						salida += (salida ? "<br/>" : '') + "Arba: " + errorArba
					if (errorConvenioRetenciones)
						salida += (salida ? "<br/>" : '') + "Sifere: " + errorConvenioRetenciones
					return salida
				}
				etapa1 = it.etapa1
				errorE2 = it.with{
					String salida = ""
					if (errorIva)
						salida = "LIBRO IVA: " + errorIva
					if (errorIvaDdjjPrecarga)
						salida += (salida ? "<br/><br/>" : '') + "DDJJ IVA: " + errorIvaDdjjPrecarga
					if (errorIibb)
						salida += (salida ? "<br/><br/>" : '') + "IIBB: " + errorIibb
					return salida
				}
				etapa2 = it.etapa2
				precargaIva = it.precargaIva
				precargaIvaDdjj = it.precargaIvaDdjj
				precargaAgip = it.precargaAgip
				precargaArba = it.precargaArba
				precargaConvenio = it.precargaConvenio
				ddjjIva = it.ddjjIva
				ddjjIibb = it.ddjjIibb
				vepIva = it.vepIva
				vepIibb = it.vepIibb
				errorVepIibb = it.errorVepIibb
				errorE3 = it.with{
					String salida = ""
					if (errorDdjjIva || errorDdjjIibb){
						salida = "DDJJs:"
						if (errorDdjjIva)
							salida += "<br/>-Iva: $errorDdjjIva"
						if (errorDdjjIibb)
							salida += "<br/>-IIbb: $errorDdjjIibb"
					}
					if (errorVepIva || errorVepIibb){
						salida += (salida ? "<br/><br/>" : '') + "VEPs:"
						if (errorVepIva)
							salida += "<br/>-Iva: $errorVepIva"
						if (errorVepIibb)
							salida += "<br/>-IIBB: $errorVepIibb"
					}
					return salida
				}
				etapa3 = it.etapa3
			}

			return returnArray
		}

		JSON.registerObjectMarshaller(Comprobante){
			def returnArray = [:]
			returnArray['id'] = it.id
			returnArray["fecha"] = it.fecha.toString("dd/MM/YYYY")
			returnArray["tipo"] = it.tipo.toString()
			returnArray["nombreArchivo"] = it.nombreArchivo
			return returnArray
		}

		JSON.registerObjectMarshaller(Vendedor){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombre'] = it.nombre
			returnArray['email'] = it.email
			returnArray['celular'] = it.celular
			returnArray['cuentaGoogle'] = it.cuentaGoogle
			returnArray['vacaciones'] = it.vacaciones
			returnArray['lunes'] = it.horario?.lunes?.toString() ?: "-"
			returnArray['martes'] = it.horario?.martes?.toString() ?: "-"
			returnArray['miercoles'] = it.horario?.miercoles?.toString() ?: "-"
			returnArray['jueves'] = it.horario?.jueves?.toString() ?: "-"
			returnArray['viernes'] = it.horario?.viernes?.toString() ?: "-"


			return returnArray
		}

		JSON.registerObjectMarshaller(ConsultaWeb){
			def returnArray = [:]

			returnArray['id'] = it.id
			returnArray['nombreApellido'] = it.nombre + " " + it.apellido
			returnArray['nombre'] = it.nombre
			returnArray['apellido'] = it.apellido
			returnArray['email'] = it.email
			returnArray['telefono'] = it.telefono
			returnArray['fecha'] = it.fechaHora.toString("dd/MM/YYYY")
			returnArray['tag'] = it.tag
			returnArray['vendedorAsignado'] = it.vendedorAsignado
			returnArray['urlOrigen'] = it.urlOrigen
			returnArray['getParameters'] = it.getParameters

			return returnArray
		}
	}
}
