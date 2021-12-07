package com.zifras.cuenta

import org.joda.time.format.DateTimeFormat
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime

import com.zifras.Contador
import com.zifras.User
import com.zifras.Estado

import com.zifras.app.App
import com.zifras.app.ItemApp

import com.zifras.descuento.CodigoDescuento

import com.zifras.documento.Comprobante
import com.zifras.documento.ComprobantePago
import com.zifras.documento.DeclaracionJurada
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.PagoCuenta
import com.zifras.documento.Vep
import com.zifras.documento.ArchivoConvenio

import com.zifras.facturacion.ConceptoFacturaVenta
import com.zifras.facturacion.FacturaCompra
import com.zifras.facturacion.FacturaVenta
import com.zifras.facturacion.PuntoVenta

import com.zifras.importacion.LogImportacion
import com.zifras.importacion.LogSelenium

import com.zifras.liquidacion.LiquidacionGanancia
import com.zifras.liquidacion.LiquidacionIIBB
import com.zifras.liquidacion.LiquidacionIva
import com.zifras.liquidacion.RetencionPercepcionIIBB
import com.zifras.liquidacion.RetencionPercepcionIva

import com.zifras.notificacion.Email

import com.zifras.servicio.ItemServicioEspecial
import com.zifras.servicio.ItemServicioMensual

import com.zifras.debito.DebitoAutomatico
import com.zifras.debito.Tarjeta

import com.zifras.ventas.Vendedor

import grails.gorm.MultiTenant
class Cuenta implements MultiTenant<Cuenta> {
	Integer tenantId
	private static final long serialVersionUID = 1
	
	Long numero
	String cuit
	String razonSocial
	
	LocalDate fechaContratoSocial
	String nombreApellido
	String cuitAdministrador
	String cuitRepresentante
	String cuitGeneradorVep
	String telefono
	String email // MENOR: Hacer el mail único en todo el sistema (respecto a usuarios y cuentas creo)
	String wechat
	String whatsapp

	Boolean relacionDependencia
	String profesion
	String tipoDocumento
	String documento
	String sexo
	Boolean inscriptoAfip
	String descripcionActividad
	Nacionalidad nacionalidad
	String rangoFacturacion

	String actionRegistro
	
	String tokenFCM

	Actividad actividad //Deprecated
	CondicionIva condicionIva
	RegimenIibb regimenIibb
	
	String numeroSicol
	
	String detalle
	
	Estado estado

	Double saldo
	
	String ultimoModificador
	LocalDateTime ultimaModificacion

	Contador contador
	Boolean recibirNotificaciones
	Boolean recibirNotificacionVep
	Boolean recibirNotificacionDeclaracionJurada
	Boolean recibirNotificacionFacturaCuenta

	Estado estadoClave
	TipoClave tipoClave
	Long mesCierre
	TipoPersona tipoPersona
	Domicilio domicilioFiscal

	Categoria categoriaMonotributo
	LocalDate periodoMonotributo
	Impuesto impuestoMonotributo

	Categoria categoriaAutonomo
	LocalDate periodoAutonomo
	Impuesto impuestoAutonomo

	LocalDateTime fechaAlta
	LocalDateTime fechaConfirmacion

	LocalDate fechaInicioActividades

	Boolean afipMiscomprobantes = false
	Boolean agipGestionar = false
	Boolean arbaPresentacionDdjj = false
	Boolean ingresosBrutos = false
	Boolean infoRevisada = false
	Boolean puntoVentaCalim = false
	Boolean claveAfipDelegada = false

	String etiqueta

	Long clientifyId
	Long bitrixId
	Long bitrixDealId
	Long bitrixTaskId

	String tokenTiendaNube
	Boolean registroConErrorAFIP

	Vendedor responsable
	String cbu
	MedioPago medioPago

	FacturaCuenta primeraFacturaSMPaga
	FacturaCuenta primeraFacturaSEPaga

	Tarjeta tarjetaDebitoAutomatico

	String claveFiscal
	String claveArba
	String claveAgip
	String claveVeps

	String riderId

	Double maximoAutorizarIva
	Double maximoAutorizarIIBB

	ObraSocial obraSocial

	String fotoFrenteDni
	String fotoDorsoDni
	String fotoSelfie

	Boolean ingresoFotosRegistro = false
	Integer contadorDisparosError

	Integer cantidadPresentacionesIvaSelenium = 0
	
	String tagFormularioOrigen

	MedioPago medioPagoIva
	MedioPago medioPagoIibb

	public boolean getEsConvenio(){
		return this.porcentajesProvinciaIIBB.size() > 1
	}

	def getProvincia(){
		if (domicilioFiscal)
			return domicilioFiscal.provincia
		return porcentajesProvinciaIIBB ? porcentajesProvinciaIIBBActivos[0].provincia : null 
	}

	static hasMany = [codigosDescuento:CodigoDescuento, comprobantes:Comprobante, planesMoratoria:PlanMoratoria, apps:ItemApp, locales:Local, liquidacionesIva: LiquidacionIva, liquidacionesIIBB: LiquidacionIIBB, alicuotasIIBB:AlicuotaIIBB,
	 porcentajesProvinciaIIBB:PorcentajeProvinciaIIBB, porcentajesActividadIIBB:PorcentajeActividadIIBB, parientes: Pariente, liquidacionesGanancia: LiquidacionGanancia,
	 veps: Vep, facturasCompra:FacturaCompra, facturasVenta:FacturaVenta, facturasCuenta:FacturaCuenta, declaracionesJuradas: DeclaracionJurada, conceptosFacturaVenta:ConceptoFacturaVenta, puntosDeVenta:PuntoVenta,
	 retPerIva: RetencionPercepcionIva, retPerIIBB: RetencionPercepcionIIBB, movimientos:MovimientoCuenta, logs: LogImportacion, logsSelenium: LogSelenium, pagos: PagoCuenta, clientesProveedores: ClienteProveedor, impuestos: CantidadImpuesto,
	 serviciosMensuales: ItemServicioMensual, serviciosEspeciales: ItemServicioEspecial, archivosAjusteConvenio: ArchivoConvenio, deudasCCMA: DeudaCCMA]
	
	static constraints = {
		numero nullable:true
		cuit nullable:false, unique:true
		razonSocial nullable:true
		
		fechaContratoSocial nullable:true
		nombreApellido nullable:true
		cuitAdministrador nullable:true
		cuitRepresentante nullable:true
		cuitGeneradorVep nullable:true
		telefono nullable:true
		email nullable:true
		wechat nullable:true
		whatsapp nullable:true

		relacionDependencia nullable:true

		tokenFCM nullable:true
		
		profesion nullable:true
		documento nullable:true
		tipoDocumento nullable:true
		sexo nullable:true
		actionRegistro nullable:true
		nacionalidad nullable:true
		inscriptoAfip nullable:true
		descripcionActividad nullable:true
		rangoFacturacion nullable:true

		actividad nullable:true
		condicionIva nullable:true
		regimenIibb nullable:true
		
		numeroSicol nullable:true
		
		detalle nullable:true, maxsize:1024

		saldo nullable:true
		
		estado nullable:false
		ultimoModificador nullable:true
		ultimaModificacion nullable:true

		contador nullable:true

		recibirNotificaciones nullable:true
		recibirNotificacionVep nullable:true
		recibirNotificacionDeclaracionJurada nullable:true
		recibirNotificacionFacturaCuenta nullable:true

		estadoClave nullable:true
		tipoClave nullable:true
		mesCierre nullable:true
		tipoPersona nullable:true
		domicilioFiscal nullable:true

		categoriaMonotributo nullable:true
		periodoMonotributo nullable:true
		impuestoMonotributo nullable:true

		categoriaAutonomo nullable:true
		periodoAutonomo nullable:true
		impuestoAutonomo nullable:true
		
		fechaAlta nullable:true
		fechaConfirmacion nullable:true

		fechaInicioActividades nullable:true

		afipMiscomprobantes nullable:true
		agipGestionar nullable:true
		arbaPresentacionDdjj nullable:true
		ingresosBrutos nullable:true
		infoRevisada nullable:true
		puntoVentaCalim nullable:true
		
		etiqueta nullable:true

		clientifyId nullable:true
		bitrixId nullable:true
		bitrixDealId nullable:true
		bitrixTaskId nullable:true
		tokenTiendaNube nullable:true
		registroConErrorAFIP nullable:true
		medioPago nullable:true
		cbu nullable:true
		responsable nullable:true
		tarjetaDebitoAutomatico nullable:true
		primeraFacturaSMPaga nullable:true
		primeraFacturaSEPaga nullable:true

		claveFiscal nullable:true
		claveArba nullable:true
		claveAgip nullable:true
		claveVeps nullable:true

		riderId nullable:true
		claveAfipDelegada nullable:true
		maximoAutorizarIva nullable:true
		maximoAutorizarIIBB nullable:true
		obraSocial nullable:true

		ingresoFotosRegistro nullable:true
		fotoFrenteDni nullable:true
		fotoDorsoDni nullable:true
		fotoSelfie nullable:true
		contadorDisparosError nullable:true

		cantidadPresentacionesIvaSelenium nullable:true

		tagFormularioOrigen nullable:true

		medioPagoIva nullable:true
		medioPagoIibb nullable:true

	}
	
	static mapping = {
		locales cascade: "all-delete-orphan"
		liquidacionesIva cascade: "all-delete-orphan"
		liquidacionesIIBB cascade: "all-delete-orphan"
		alicuotasIIBB cascade: "all-delete-orphan"
		porcentajesProvinciaIIBB cascade: "all-delete-orphan"
		porcentajesActividadIIBB cascade: "all-delete-orphan"
		parientes cascade: "all-delete-orphan"
		liquidacionesGanancia cascade: "all-delete-orphan"
		facturasCompra cascade: "all-delete-orphan"
		facturasVenta cascade: "all-delete-orphan"
		veps cascade: "all-delete-orphan"
		facturasCuenta cascade: "all-delete-orphan"
		declaracionesJuradas cascade: "all-delete-orphan"
		retPerIva cascade: 'all-delete-orphan'
		retPerIIBB cascade: 'all-delete-orphan'
		movimientos cascade: 'all-delete-orphan'
		logs cascade: 'all-delete-orphan'
		logsSelenium cascade: 'all-delete-orphan'
		pagos cascade: 'all-delete-orphan'
		estado index: 'Cuenta_Estado_Index'
		clientesProveedores cascade: 'all-delete-orphan'
		impuestos cascade: 'all-delete-orphan'
		puntosDeVenta cascade: 'all-delete-orphan'
		serviciosEspeciales cascade: "all-delete-orphan"
		serviciosMensuales cascade: "all-delete-orphan"
		archivosAjusteConvenio cascade: "all-delete-orphan"
		deudasCCMA cascade: "all-delete-orphan"
	}
	
	public String getPath() {
		return this.cuit + '_' + this.id.toString()
	}

	public String toString() {
		return cuit + ' - ' + razonSocial
	}
	
	public getAlicuotasIIBBActivas(){
		def estado = Estado.findByNombre('Activo')
		return this.alicuotasIIBB.findAll{ it.estado == estado }.sort{ it.valor }.reverse()
	}

	public getPorcentajesProvinciaIIBBActivos(){
		return this.porcentajesProvinciaIIBB.findAll{ it.estado.nombre == "Activo" }.sort{ it.porcentaje }.reverse()
	}

	public getPorcentajesActividadIIBBActivos(){
		return this.porcentajesActividadIIBB.findAll{ it.estado.nombre == "Activo" }.sort{ it.porcentaje }.reverse()
	}
	
	public getParientesActivos(){
		def estado = Estado.findByNombre('Activo')
		return this.parientes.findAll{ it.estado == estado }.sort{ it.nombre }
	}

	public String getMesCierreString(){
		LocalDate mes = LocalDate.parse(this.mesCierre.toString(), DateTimeFormat.forPattern("MM"))
		return mes.toString("MMMM",new java.util.Locale('ES')).capitalize()
	}

	public getImpuestosUnicos(){
		def unicos = []
		this.impuestos.each{
			def impuesto = it.impuesto
			if (! unicos.find{it.id == impuesto.id})
				unicos.push(impuesto)
		}
		if (this.impuestoMonotributo && ! unicos.find{it.id == this.impuestoMonotributo.id})
			unicos.push(this.impuestoMonotributo)
		if (this.impuestoAutonomo && ! unicos.find{it.id == this.impuestoAutonomo.id})
			unicos.push(this.impuestoAutonomo)
		return unicos.sort {it.nombre}
	}

	public getServiciosString(){ (serviciosMensuales + serviciosEspeciales)?.collect{it.servicio.toString()}?.unique()?.sort()?.join("<br/>") ?: "Ninguno" }

	public ItemServicioMensual getServicioActivo(){ getServicioPorFecha(new LocalDate()) }

	public ItemServicioMensual getServicioPorFecha(LocalDate fecha){ serviciosMensuales?.find{it.periodoAplica(fecha)} }

	public deudaMovimientosImpagos(){ 
		def movimientosImpagos = this.movimientos?.findAll{! it.pagado && it.factura }
		return movimientosImpagos ? movimientosImpagos.sum{it.importe} : 0
	}

	public getLocalesActivos(){ locales?.findAll {it.estado.nombre == "Activo"} }

	public trabajaConApp(){
		return (profesion == "app" && (this.apps.any{ia -> ia.app.nombre == "Rappi"} || this.apps.any{ia -> ia.app.nombre == "PedidosYa"}) )
	}

	public boolean getAplicaIva(){
		return condicionIva.nombre != "Monotributista"
	}

	public boolean getAplicaIIBB(){
		return ! ['Sin inscribir','Simplificado','Unificado'].contains(regimenIibb.nombre)
	}
	public sinVerificar(){return estado.nombre =="Sin verificar"}

	public getUltimoVolante(){
		return veps.sort{a,b-> b.fechaEmision<=>a.fechaEmision}.find{vep -> vep.tipo.nombre == "Simplificado"}}

	public String appsDondeTrabaja(){
		def aps = this.apps
		def nombresApps = []
		aps.each{itemApp-> nombresApps.push(itemApp.app.nombre)}
		return nombresApps
	}

	public Boolean moratoriaPaga(){
		return this.serviciosEspeciales?.any{it.servicioMoratoriaPago()}
	}

	public serviciosMoratoriaPagos(){
		return this.serviciosEspeciales?.findAll{it.servicioMoratoriaPago()}
	}

	public poseePlanMoratoriaAbierto(){
		return this.planesMoratoria.any{it.estado.nombre == "Abierto"}
	}

	public cuotaMoratoriaAPagar(){
		return this.planesMoratoria.find{it.estado.nombre == "Abierto"}.cuotaAPagar()
	}

	public terminacionCuit(){
		return new Integer(this.cuit[-1])
	}

	public appCalimDescargada(){
		return !!this.tokenFCM
	}

	public poseeNotificacionesNoLeidas(){
		def emails = Email.findAllByCuenta(this)
		return emails.any{it.notificacionLeida == false || it.notificacionLeida == null} // luego dejarlo solo en false
	}
	public notificacionesNoLeidas(){
		def emails = Email.findAllByCuenta(this)
		return emails.findAll{it.notificacionLeida == false || it.notificacionLeida == null}.size()
	}
	public poseeLiquidacionNoAutorizada(){
		def ano = new LocalDate().toString("YYYY")

		def liquidacionesIIBBNoAutorizadas = this.liquidacionesIIBB?.findAll{it.estado?.nombre == "Notificado" && it.fecha?.toString("YYYY") == ano}.size()
		def liquidacionesIvaNoAutorizadas = this.liquidacionesIva?.findAll{it.estado?.nombre == "Notificado" && it.fecha?.toString("YYYY") == ano}.size()
		def liquidacionesGananciaNoAutorizadas = this.liquidacionesGanancia?.findAll{it.estado?.nombre == "Liquidado" && it.fecha?.toString("YYYY") == ano}.size()

		def suma = liquidacionesIIBBNoAutorizadas + liquidacionesIvaNoAutorizadas + liquidacionesGananciaNoAutorizadas

		return suma 
	}	

	public algunServicioPagado(){
		return this.serviciosEspeciales.any{it.estado == "Pagado"} || this.serviciosMensuales.any{it.facturas.any{it.pagada}}
	}

	public User getUsuario(){
		User.findByCuenta(this)
	}

	public getUltimoMailConfirmacion(){
		return Email.findAllByCuentaAndSubject(this,"Confirma tu email en CALIM")?.sort{it.fechaHora}?.reverse()[0]
	}

	public getPrimerDebito(){
		return DebitoAutomatico.findAllByCuenta(this).size() <= 0
	}

	public String getMailsMercadoPago(){
		if (pagos){
			def mails = pagos.collect{it.mailMP}?.unique()	
			if (mails){
				mails.remove("")
				return mails.join("\n")
			}
		}
		return ""
	}

	public Integer serviciosEspecialesPagados(){
		return serviciosEspeciales.findAll{it.estado == "Pagado"}.size()
	}

	public codigoDescuentoActivo(){
		return codigosDescuento?.sort{it.descuento}[0] 
	}

	public obtenerDescuentoProfesion(String codigoServicio){
		if(this.profesion == "mercadolibre"){
			if(["SE03","SE04","SE09"].contains(codigoServicio))
				return 30
			return 10
		}
		return 0
	}

	public String getApellido(){
		return nombreApellido.split(" ")[-1]
	}

	public String getNombre(){
		return nombreApellido - (" " + apellido)
	}

	public DeudaCCMA getUltimaDeudaCCMA(){
		return this.deudasCCMA?.max{it.fecha}
	}

	public ItemServicioMensual getUltimoSMAgregado(){
		return serviciosMensuales.last()
	}
}
