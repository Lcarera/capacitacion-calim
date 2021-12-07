package com.zifras.inicializacion

import com.zifras.Contador
import com.zifras.Estado
import com.zifras.Estudio
import com.zifras.ItemMenu
import com.zifras.Localidad
import com.zifras.Provincia
import com.zifras.Role
import com.zifras.TokenGoogle
import com.zifras.User
import com.zifras.UserRole
import com.zifras.Zona

import com.zifras.app.App

import com.zifras.cuenta.CondicionIva
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.MedioPago
import com.zifras.cuenta.Nacionalidad
import com.zifras.cuenta.RegimenIibb
import com.zifras.cuenta.TipoClave
import com.zifras.cuenta.TipoPersona

import com.zifras.documento.TipoVep

import com.zifras.facturacion.AlicuotaIva
import com.zifras.facturacion.Persona
import com.zifras.facturacion.TipoConcepto 
import com.zifras.facturacion.UnidadMedida

import com.zifras.notificacion.NotificacionTemplate

import com.zifras.ventas.Vendedor

import grails.gorm.multitenancy.Tenant
import java.nio.charset.Charset
import static grails.gorm.multitenancy.Tenants.*

class Inicializacion {
	static def comienzo(){
		println "######################################################################"
		println "Verificando datos del sistema generales..."
		inicializarEstudios()
		inicializarRoles()
		inicializarUsuarios()
		inicializarEstados()
		inicializarCondicionesIVA()
		inicializarCondicionesRegimenesIIBB()
		inicializarProvincias()
		inicializarIVAs()
		inicializarTipoClave()
		inicializarTipoPersona()
		inicializarTipoVep()
		inicializarMediosPago()
		
		//Inicialización para Pavoni
		println "######################################################################"
		println "Verificando datos de estudio Pavoni..."
		def estudioPavoni = Estudio.findByNombre('Pavoni')
		if(estudioPavoni!=null) {
			withId(new Integer(estudioPavoni.id.toString())) {
				inicializarMenuesPavoni()
				inicializarLocalidades()
				inicializarZonas()
				inicializarConceptos()
				inicializarUnidadesMedida()
				inicializarConsumidorFinal()
			}
		}
		
		//Inicialización para Calim
		println "######################################################################"
		println "Verificando datos de estudio Calim..."
		def estudioCalim = Estudio.findByNombre('Calim')
		if(estudioCalim!=null) {
			withId(new Integer(estudioCalim.id.toString())) {
				inicializarMenuesCalim()
				inicializarLocalidades()
				inicializarZonas()
				inicializarConceptos()
				inicializarUnidadesMedida()
				inicializarApps()
				inicializarPlantillasNotificaciones()
				//inicializarCuentasPruebaCalim()
				inicializarContadores()
				inicializarConsumidorFinal()
				inicializarTokensGoogle()
				inicializarVendedores()
				inicializarNacionalidades()
			}
		}
		
		println "######################################################################"
		println "Verificacion finalizada"
	}

	static def inicializarCuentasPruebaCalim(){
		def cuits = ['20940129118','20940256063','20940365903','20942439858','20944766856','20944879669','20945594633','20946348814','20947729579','20947742435','20949015204','20950177544','20950816172','20951284646','20951389790','20952434501','20952850149','20952969073','20953023599','20953268842','20954298974','20954391427','20954572324','20954713149','20955264313','20956168962','20956180857','20956814171','20957049878','20957235337','20958836393','23940014239','23943017484','23952434454','23953359774','23957356109','23957720099','27939920140','27940269100','27940467034','27940580620','27942699013','27944847133','27946381638','27947826765','27949015322','27950069525','27950809901','27951462735','27951486995','27951706421','27951742711','27951815301','27952960291','27953992960','27954355999','27955062456','27955804266','27956004611','27956171887','27956178245','27956197126','27956836641','27956891081','27957237466','27957316501','27957606127','27957645971','27957743922','27959049969','30709472069','30715942182','30708287055','30500191194','20188404112']
		def cuenta
		def estado = Estado.findByNombre('Activo')
		def condicion = CondicionIva.findByNombre('Responsable inscripto')
		def regimen = RegimenIibb.findByNombre('Simplificado')

		println "Inicializando cuentas de prueba"

		cuits.each{
			def cuit = it
			cuenta = Cuenta.findByCuit(cuit)
			if(cuenta==null){
				cuenta = new Cuenta(cuit:cuit, estado: estado, regimenIibb: regimen, condicionIva: condicion)
				cuenta.save(flush:true)
			}
		}
	}
	
	static def inicializarMenuesCalim(){
		println "Verificando Menues..."
		def menues
				
		inicializarMenuCalimRoleAdmin()
		inicializarMenuPavoniRoleUser()
		inicializarMenuPavoniRoleLectura()
		inicializarMenuCalimRoleCuenta()
		inicializarMenuCalimRoleSM()
		inicializarMenuCalimRoleSE()
		inicializarMenuCalimRoleCobranza()
		inicializarMenuCalimRoleVentas()
		inicializarMenuCalimRoleAdminPedidosYa()
		inicializarMenuCalimRoleRiderPedidosYa()
	}
	
	static def inicializarMenuCalimRoleAdmin() {
		def menues
		def role = Role.findByAuthority('ROLE_ADMIN')
		
		println "Verificando Menu ROLE_ADMIN..."
		menues = ItemMenu.findAllByRole(role)
		if (!menues){
			//Nodo padre del menú
			def menuNodo = new ItemMenu(role: role, tipo: 'PRINCIPAL', orden: 0, padre: null)
			menuNodo.save(flush:true)
			
			if(menuNodo!=null) {
				//Nodo padre del menú Cuenta
				def menuCuenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', icono: 'ti-id-badge', orden: 100, padre: menuNodo)
				menuCuenta.save(flush:true)
				println "Nodo cuenta creado"
				
				if(menuCuenta!=null) {
					//Menú Cuenta Buscar
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Buscar', controller: 'cuenta', action: 'buscar', orden: 50, padre: menuCuenta).save(flush:true)
					println "Menu Buscar creado"

					//Menú Cuenta
					def menuCuenta2 = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Activas', controller: 'cuenta', action: 'list', orden: 100, padre: menuCuenta)
					menuCuenta2.save(flush:true)
					println "Menu Cuenta creado"
					
					//Menú Cuenta Pendientes
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Pendientes', controller: 'cuenta', action: 'listPendientes', orden: 200, padre: menuCuenta).save(flush:true)
					println "Menu Pendientes creado"

					//Menú Cuenta Suspendidas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Suspendidas', controller: 'cuenta', action: 'listSuspendidas', orden: 300, padre: menuCuenta).save(flush:true)
					println "Menu Suspendidas creado"
					
					//Menú Cuenta Borradas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Borradas', controller: 'cuenta', action: 'listBorradas', orden: 400, padre: menuCuenta).save(flush:true)
					println "Menu Borradas creado"

					// Verdes
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Verdes', controller: 'cuenta', action: 'listVerdes', orden: 500, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Verdes creado"

					// Naranjas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Naranjas', controller: 'cuenta', action: 'listNaranjas', orden: 550, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Naranjas creado"

					// Amarillas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Amarillos', controller: 'cuenta', action: 'listAmarillos', orden: 600, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Amarillas creado"

					//Menú Cuenta Riders
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Riders (PY)', controller: 'cuenta', action: 'listRiders', orden: 700, padre: menuCuenta).save(flush:true)
					println "Menu Riders creado"

					//Menú Cuenta Delivery
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Delivery', controller: 'cuenta', action: 'listDelivery', orden: 800, padre: menuCuenta).save(flush:true)
					println "Menu Delivery creado"

					//Menú Deudas CCMA
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Deudas CCMA', controller: 'cuenta', action: 'listCcma', orden: 900, padre: menuCuenta).save(flush:true)
					println "Menu Deudas CCMA creado"
				}
				
				//Nodo padre del menú Impuestos
				def menuImpuestos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Impuestos', icono: 'ti-receipt', orden: 200, padre: menuNodo)
				menuImpuestos.save(flush:true)
				println "Nodo impuestos creado"
				
				if(menuImpuestos!=null) {
					/*def menuRetPerIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Per IVA', controller: 'liquidacionIva', action: 'listRetencionPercepcion', orden: 100, padre: menuImpuestos)
					menuRetPerIVA.save(flush:true)
					println "Menu Ret/Per IVA creado"*/
					
					def menuImpRetPerIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Imp. Ret/Per IVA', controller: 'retencionPercepcionIva', action: 'list', orden: 200, padre: menuImpuestos)
					menuImpRetPerIVA.save(flush:true)
					println "Menu Imp. Ret/Per IVA creado"
					
					def menuNotasIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notas IVA', controller: 'liquidacionIva', action: 'listNota', orden: 300, padre: menuImpuestos)
					menuNotasIVA.save(flush:true)
					println "Menu Notas IVA creado"
					
					def menuIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IVA', controller: 'liquidacionIva', action: 'list', orden: 400, padre: menuImpuestos)
					menuIVA.save(flush:true)
					println "Menu IVA creado"
					
					/*def menuLiqMasivaIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Liq. Masiva IVA', controller: 'liquidacionIva', action: 'listLiquidacionMasiva', orden: 500, padre: menuImpuestos)
					menuLiqMasivaIVA.save(flush:true)
					println "Menu Liq. Masiva IVA creado"*/
					
					/*def menuRetSircrebIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Sircreb IIBB', controller: 'liquidacionIibb', action: 'listRetencionSircreb', orden: 600, padre: menuImpuestos)
					menuRetSircrebIIBB.save(flush:true)
					println "Menu Ret/Sircreb IIBB creado"*/
					
					def menuRetPerIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Imp. Ret/Per IIBB', controller: 'retencionPercepcionIIBB', action: 'list', orden: 650, padre: menuImpuestos)
					menuRetPerIIBB.save(flush:true)
					println "Menu Imp. Ret/Per IIBB creado"
					
					def menuNotasIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notas IIBB', controller: 'liquidacionIibb', action: 'listNota', orden: 700, padre: menuImpuestos)
					menuNotasIIBB.save(flush:true)
					println "Menu Notas IIBB creado"
					
					def menuIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB', controller: 'liquidacionIibb', action: 'list', orden: 800, padre: menuImpuestos)
					menuIIBB.save(flush:true)
					println "Menu IIBB creado"
					
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB Sin Alicuotas', controller: 'liquidacionIibb', action: 'listSinAlicuota', orden: 850, padre: menuImpuestos).save(flush:true)
					println "Menu IIBB Sin Alicuotas creado"
					
					/*def menuLiqMasivaIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Liq. Masiva IIBB', controller: 'liquidacionIibb', action: 'listLiquidacionMasiva', orden: 900, padre: menuImpuestos)
					menuLiqMasivaIIBB.save(flush:true)
					println "Menu Liq. Masiva IIBB creado"*/
					
					def menuRetPerAntGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Per/Ant Gan.', controller: 'liquidacionGanancia', action: 'listRetencionPercepcionAnticipo', orden: 1000, padre: menuImpuestos)
					menuRetPerAntGanancia.save(flush:true)
					println "Menu Ret/Per/Ant Gan. creado"
					
					def menuNotaGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notas Ganancias', controller: 'liquidacionGanancia', action: 'listNota', orden: 1100, padre: menuImpuestos)
					menuNotaGanancia.save(flush:true)
					println "Menu Notas Ganancias creado"
					
					def menuGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ganancias', controller: 'liquidacionGanancia', action: 'list', orden: 1200, padre: menuImpuestos)
					menuGanancia.save(flush:true)
					println "Menu Ganancias creado"
				}

				//Nodo padre del menú Notificaciones
				def menuNotificaciones = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notificaciones', icono: 'ti-email', orden: 300, padre: menuNodo)
				menuNotificaciones.save(flush:true)
				println "Nodo Notificaciones creado"

				if(menuNotificaciones!=null) {
					def menuNotificacionesIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IVA', controller: 'liquidacionIva', action: 'listLiquidacionNotificacion', orden: 100, padre: menuNotificaciones)
					menuNotificacionesIVA.save(flush:true)
					println "Menu Notificaciones IVA creado"

					def menuNotificacionesIIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB', controller: 'liquidacionIibb', action: 'listLiquidacionNotificacion', orden: 200, padre: menuNotificaciones)
					menuNotificacionesIIIBB.save(flush:true)
					println "Menu Notificaciones IIBB creado"

					def menuNotificacionesPersonalizables = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Personalizables', controller: 'notificacion', action: 'notificacionesPersonalizables', orden: 300, padre: menuNotificaciones)
					menuNotificacionesPersonalizables.save(flush:true)
					println "Menu Notificaciones Personalizables"

					def menuNotificacionesTemplates = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Plantillas', controller: 'notificacion', action: 'listTemplates', orden: 400, padre: menuNotificaciones)
					menuNotificacionesTemplates.save(flush:true)
					println "Menu Plantillas Notificaciones"
				}

				//Nodo padre del menú Documentos
				def menuDocumentos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Documentos', icono: 'ti-file', orden: 400, padre: menuNodo)
				menuDocumentos.save(flush:true)
				println "Nodo Documentos creado"

				if(menuDocumentos!=null) {
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Veps', controller: 'vep', action: 'list', orden: 100, padre: menuDocumentos).save(flush:true)
					println "Menu Lista Veps creado"

					def menuDeclaracionesJuradas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Declaraciones Juradas', controller: 'declaracionJurada', action: 'list', orden: 200, padre: menuDocumentos)
					menuDeclaracionesJuradas.save(flush:true)
					println "Menu Declaraciones Juradas creado"

					def menuFacturasCalim = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas Calim', controller: 'facturaCuenta', action: 'list', orden: 300, padre: menuDocumentos)
					menuFacturasCalim.save(flush:true)
					println "Menu Facturas Calim creado"

					def menuPagoCuenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Pagos Calim', controller: 'pagoCuenta', action: 'list', orden: 400, padre: menuDocumentos)
					menuPagoCuenta.save(flush:true)
					println "Menu Pagos Calim creado"

					def menuComprobantesPago = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Comprobantes de Pago', controller: 'comprobantePago', action: 'list', orden: 500, padre: menuDocumentos)
					menuComprobantesPago.save(flush:true)
					println "Menu Comprobantes creado"

				}

				//Nodo padre del menú Importaciones
				def menuImportaciones = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Importaciones', icono: 'ti-cloud-up', orden: 500, padre: menuNodo)
				menuImportaciones.save(flush:true)
				println "Nodo importaciones creado"
				
				if(menuImportaciones!=null) {
					def menuPanelControl = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Panel de Control', controller: 'importacion', action: 'panel', orden: 100, padre: menuImportaciones)
					menuPanelControl.save(flush:true)
					println "Menu Panel de Control creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Veps', controller: 'vep', action: 'panel', orden: 200, padre: menuImportaciones).save(flush:true)
					println "Menu Importación Veps creado"
					
					def menuLogs = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Logs', controller: 'importacion', action: 'list', orden: 300, padre: menuImportaciones)
					menuLogs.save(flush:true)
					println "Menu Logs creado"
				}
				
				//Nodo padre del menú Facturacion
				def menuFacturacion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturación', icono: 'ti-folder', orden: 600, padre: menuNodo)
				menuFacturacion.save(flush:true)
				println "Nodo facturacion creado"
				
				if(menuFacturacion!=null) {
					def menuFacturasVenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas de Venta', controller: 'facturaVenta', action: 'list', orden: 100, padre: menuFacturacion)
					menuFacturasVenta.save(flush:true)
					println "Menu Facturas de Venta creado"
					
					def menuFacturasCompra = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas de Compra', controller: 'facturaCompra', action: 'list', orden: 200, padre: menuFacturacion)
					menuFacturasCompra.save(flush:true)
					println "Menu Facturas de Compra creado"
					
					def menuTipoComprobante = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Tipos de Comprobante', controller: 'tipoComprobante', action: 'list', orden: 300, padre: menuFacturacion)
					menuTipoComprobante.save(flush:true)
					println "Menu Tipos de Comprobante creado"
					
					def menuClientes = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Clientes', controller: 'agenda', action: 'list', orden: 400, padre: menuFacturacion)
					menuClientes.save(flush:true)
					println "Menu Clientes creado"
				}
				
				//Nodo padre del menú Administracion
				def menuAdministracion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Administración', icono: 'ti-view-list-alt', orden: 650, padre: menuNodo)
				menuAdministracion.save(flush:true)
				println "Nodo Administracion creado"

				if(menuAdministracion!=null) {
					//Menú  Deudores
					def menuDeudores = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cobranza', controller: 'cuenta', action: 'listDeudores', orden: 100, padre: menuAdministracion)
					menuDeudores.save(flush:true)
					println "Menu Deudores creado"

					//Menu Tarjetas
					def menuTarjetas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Tarjetas', controller: 'debitoAutomatico', action: 'listCuentasSMActivo', orden: 200, padre: menuAdministracion)
					menuTarjetas.save(flush:true)
					println "Menu Tarjetas creado"

					//Menú  CobranzaMensual
					def menuCobranzaMensual = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Mensuales', controller: 'servicio', action: 'cobranza', orden: 300, padre: menuAdministracion)
					menuCobranzaMensual.save(flush:true)
					println "Menu CobranzaMensual creado"

					//Menú  CobranzaEspecial
					def menuCobranzaEspecial = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Especiales', controller: 'servicio', action: 'cobranzaEspecial', orden: 350, padre: menuAdministracion)
					menuCobranzaEspecial.save(flush:true)
					println "Menu CobranzaEspecial creado"

					//Menú  Estadisticas
					def menuEstadisticas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Estadisticas', controller: 'panelEstadistico', action: 'panel', orden: 400, padre: menuAdministracion)
					menuEstadisticas.save(flush:true)
					println "Menu Estadisticas creado"
					
					//Menu Gerencia
					def menuGerencia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Gerencia', controller: 'panelEstadistico', action: 'gerencia', orden: 425, padre: menuAdministracion)
					menuGerencia.save(flush:true)
					println "Menu Gerencia creado"

					//Menu Consultas Formulario
					def menuConsultas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Consultas Formulario', controller: 'panelEstadistico', action: 'consultasWeb', orden: 450, padre: menuAdministracion)
					menuConsultas.save(flush:true)
					println "Menu Consultas Formulario creado"

					//Menú  Debito Automatico
					def menuDebitoAutomatico = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Débito Automático', controller: 'debitoAutomatico', action: 'list', orden: 475, padre: menuAdministracion)
					menuDebitoAutomatico.save(flush:true)
					println "Menu Debito Automatico creado"

					//Menú  Vendedores
					def menuVendedores = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Vendedores', controller: 'vendedor', action: 'list', orden: 500, padre: menuAdministracion)
					menuVendedores.save(flush:true)
					println "Menu Vendedores creado"

					//Menú  Abonos
					def menuAbonos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Abonos', controller: 'cuenta', action: 'listAbonos', orden: 525, padre: menuAdministracion)
					menuAbonos.save(flush:true)
					println "Menu Abonos creado"

					def menuServicios = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Servicios', controller: 'servicio', action: 'list', orden: 550, padre: menuAdministracion)
					menuServicios.save(flush:true)
					println "Menú Servicios creado"
					
					//Menú  Moratoria
					def menuMoratoria = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Moratoria', controller: 'moratoria', action: 'list', orden: 660, padre: menuAdministracion)
					menuMoratoria.save(flush:true)
					println "Menu Moratoria creado"
					
					//Menú  Moratoria
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Clientes', controller: 'panelEstadistico', action: 'clientes', orden: 770, padre: menuAdministracion).save(flush:true)
					println "panelEstadistico Clientes"
				}
				
				//Nodo padre del menú Ventas
				def menuVentas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ventas', icono: 'ti-money', orden: 700, padre: menuNodo)
				menuVentas.save(flush:true)
				println "Nodo Ventas creado"

				if(menuVentas!=null){
					def menuCuentas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Listado de cuentas', controller: 'cuenta', action: 'listVentas', orden: 100, padre: menuVentas)
					menuCuentas.save(flush:true)
					println "Menu Cuentas Ventas creado"

					def menuSolicitudes = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Solicitudes de pago', controller: 'facturaCuenta', action: 'listSolicitudesPago', orden: 200, padre: menuVentas)
					menuSolicitudes.save(flush:true)
					println "Menu Solicitudes de Pago creado"
				}

				//Nodo padre del menú Configuracion
				def menuConfiguracion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Configuración', icono: 'ti-settings', orden: 700, padre: menuNodo)
				menuConfiguracion.save(flush:true)
				println "Nodo configuracion creado"
				
				if(menuConfiguracion!=null) {
					def menuUsuarios = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Usuarios Backoffice', controller: 'usuario', action: 'list', orden: 50, padre: menuConfiguracion)
					menuUsuarios.save(flush:true)
					println "Menu Usuarios creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Usuarios-Cuenta', controller: 'usuario', action: 'listCuentas', orden: 75, padre: menuConfiguracion).save(flush:true)
					println "Menu Usuarios-Cuenta creado"

					def menuActividades = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Actividades', controller: 'actividad', action: 'list', orden: 100, padre: menuConfiguracion)
					menuActividades.save(flush:true)
					println "Menu Actividades creado"

					def menuAlicuotasIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Alicuotas IIBB', controller: 'alicuotaProvinciaActividadIIBB', action: 'list', orden: 150, padre: menuConfiguracion)
					menuAlicuotasIIBB.save(flush:true)
					println "Menu Alicuotas IIBB creado"
					
					def menuCondicionesIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Condiciones IVA', controller: 'condicionIva', action: 'list', orden: 200, padre: menuConfiguracion)
					menuCondicionesIVA.save(flush:true)
					println "Menu Condiciones IVA creado"

					def menuFAQ = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'FAQ', controller: 'elementoFaq', action: 'list', orden: 300, padre: menuConfiguracion)
					menuFAQ.save(flush:true)
					println "Menu FAQ creado"

					def menuMediosPago = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Medios de Pago', controller: 'medioPago', action: 'list', orden: 400, padre: menuConfiguracion)
					menuMediosPago.save(flush:true)
					println "Menu Medios Pago creado"
					
					def menuRegimenesIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Régimenes IIBB', controller: 'regimenIibb', action: 'list', orden: 1100, padre: menuConfiguracion)
					menuRegimenesIIBB.save(flush:true)
					println "Menu Régimenes IIBB creado"
					
					def menuProvincias = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Provincias', controller: 'provincia', action: 'list', orden: 1200, padre: menuConfiguracion)
					menuProvincias.save(flush:true)
					println "Menu Provincias creado"
					
					def menuLocalidades = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Localidades', controller: 'localidad', action: 'list', orden: 500, padre: menuConfiguracion)
					menuLocalidades.save(flush:true)
					println "Menu Localidades creado"
					
					def menuZonas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Zonas', controller: 'zona', action: 'list', orden: 600, padre: menuConfiguracion)
					menuZonas.save(flush:true)
					println "Menu Zonas creado"
					
					def menuGastoDeduccionGan = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Gasto/Deduccion Gan', controller: 'tipoGastoDeduccionGanancia', action: 'list', orden: 700, padre: menuConfiguracion)
					menuGastoDeduccionGan.save(flush:true)
					println "Menu Gasto/Deduccion Gan creado"
					
					def menuPatrimonioGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Patrimonio Gan', controller: 'tipoPatrimonioGanancia', action: 'list', orden: 800, padre: menuConfiguracion)
					menuPatrimonioGanancia.save(flush:true)
					println "Menu Patrimonio Gan creado"
					
					def menuRangosGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Rangos Gan', controller: 'rangoImpuestoGanancia', action: 'list', orden: 900, padre: menuConfiguracion)
					menuRangosGanancia.save(flush:true)
					println "Menu Rangos Gan creado"
					
					def menuMontosDeduccionGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Montos/Deduccion Gan', controller: 'montoConceptoDeducibleGanancia', action: 'list', orden: 1000, padre: menuConfiguracion)
					menuMontosDeduccionGanancia.save(flush:true)
					println "Menu Montos/Deduccion Gan creado"
				}
				
				//Nodo padre del menú Descuentos
				def menuDescuentos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Descuentos', icono: 'ti-cut', orden: 800, padre: menuNodo)
				menuDescuentos.save(flush:true)
				println "Nodo descuentos creado"
				
				if(menuDescuentos!=null) {
					def menuCodigos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Códigos', controller: 'descuento', action: 'codigos', orden: 100, padre: menuDescuentos)
					menuCodigos.save(flush:true)
					println "Menu Códigos creado"
				}

				new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Selenium', icono: 'icofont icofont-upload', orden: 900, padre: menuNodo).save(flush:true)?.with{ menuSelenium ->
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Descargas', controller: 'selenium', action: 'descargas', orden: 100, padre: menuSelenium).save(flush:true)
					println "Menú Descargas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Precargas', controller: 'selenium', action: 'precargas', orden: 200, padre: menuSelenium).save(flush:true)
					println "Menú Precargas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Simplificados', controller: 'selenium', action: 'simplificados', orden: 300, padre: menuSelenium).save(flush:true)
					println "Menú simplificados Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'DDJJ y VEP', controller: 'selenium', action: 'ddjj', orden: 400, padre: menuSelenium).save(flush:true)
					println "Menú DDJJ Selenium creado"
				}

				new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Selenium Naranja', icono: 'icofont icofont-upload', orden: 1000, padre: menuNodo).save(flush:true)?.with{ menuSelenium ->
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Descargas', controller: 'selenium', action: 'descargasNaranjas', orden: 100, padre: menuSelenium).save(flush:true)
					println "Menú DescargasNaranjas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Precargas', controller: 'selenium', action: 'precargasNaranjas', orden: 200, padre: menuSelenium).save(flush:true)
					println "Menú PrecargasNaranjas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'DDJJ y VEP', controller: 'selenium', action: 'ddjjNaranjas', orden: 400, padre: menuSelenium).save(flush:true)
					println "Menú DDJJ SeleniumNaranjas creado"
				}
			}
			
		}
	}
	
	static def inicializarMenuCalimRoleSE(){
		def menues
		def role = Role.findByAuthority('ROLE_SE')

		println "Verificando Menu ROLE_SE..."
		menues = ItemMenu.findAllByRole(role)

		if(!menues){
			def menuNodo = new ItemMenu(role: role, tipo: 'PRINCIPAL', orden: 0, padre: null)
			menuNodo.save(flush:true)
			
			if(menuNodo!=null) {
				//Nodo padre del menú Cuenta
				def menuCuenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', icono: 'ti-id-badge', orden: 100, padre: menuNodo)
				menuCuenta.save(flush:true)
				println "Nodo cuenta creado"
				
				if(menuCuenta!=null) {
					//Menú Cuenta Buscar
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Buscar', controller: 'cuenta', action: 'buscar', orden: 50, padre: menuCuenta).save(flush:true)
					println "Menu Buscar creado"

					//Menú Cuenta
					def menuCuenta2 = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Activas', controller: 'cuenta', action: 'list', orden: 100, padre: menuCuenta)
					menuCuenta2.save(flush:true)
					println "Menu Cuenta creado"
					
					//Menú Cuenta Pendientes
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Pendientes', controller: 'cuenta', action: 'listPendientes', orden: 200, padre: menuCuenta).save(flush:true)
					println "Menu Pendientes creado"

					//Menú Cuenta Suspendidas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Suspendidas', controller: 'cuenta', action: 'listSuspendidas', orden: 300, padre: menuCuenta).save(flush:true)
					println "Menu Suspendidas creado"
					
					//Menú Cuenta Borradas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Borradas', controller: 'cuenta', action: 'listBorradas', orden: 400, padre: menuCuenta).save(flush:true)
					println "Menu Borradas creado"

					// Verdes
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Verdes', controller: 'cuenta', action: 'listVerdes', orden: 500, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Verdes creado"

					// Naranjas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Naranjas', controller: 'cuenta', action: 'listNaranjas', orden: 550, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Naranjas creado"

					// Amarillas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Amarillos', controller: 'cuenta', action: 'listAmarillos', orden: 600, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Amarillas creado"

					//Menú Cuenta Delivery
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Delivery', controller: 'cuenta', action: 'listDelivery', orden: 800, padre: menuCuenta).save(flush:true)
					println "Menu Delivery creado"
				}
				
				//Nodo padre del menú Facturacion
				def menuFacturacion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturación', icono: 'ti-folder', orden: 600, padre: menuNodo)
				menuFacturacion.save(flush:true)
				println "Nodo facturacion creado"
				
				if(menuFacturacion!=null) {
					def menuFacturasVenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas de Venta', controller: 'facturaVenta', action: 'list', orden: 100, padre: menuFacturacion)
					menuFacturasVenta.save(flush:true)
					println "Menu Facturas de Venta creado"
					
					def menuFacturasCompra = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas de Compra', controller: 'facturaCompra', action: 'list', orden: 200, padre: menuFacturacion)
					menuFacturasCompra.save(flush:true)
					println "Menu Facturas de Compra creado"
					
					def menuClientes = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Clientes/Proveedores', controller: 'agenda', action: 'list', orden: 400, padre: menuFacturacion)
					menuClientes.save(flush:true)
					println "Menu Clientes creado"
				}
			}
		}
	}

	static def inicializarMenuCalimRoleSM() {
		def menues
		def role = Role.findByAuthority('ROLE_SM')
		
		println "Verificando Menu ROLE_SM..."
		menues = ItemMenu.findAllByRole(role)
		if (!menues){
			//Nodo padre del menú
			def menuNodo = new ItemMenu(role: role, tipo: 'PRINCIPAL', orden: 0, padre: null)
			menuNodo.save(flush:true)
			
			if(menuNodo!=null) {
				//Nodo padre del menú Cuenta
				def menuCuenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', icono: 'ti-id-badge', orden: 100, padre: menuNodo)
				menuCuenta.save(flush:true)
				println "Nodo cuenta creado"
				
				if(menuCuenta!=null) {
					//Menú Cuenta Buscar
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Buscar', controller: 'cuenta', action: 'buscar', orden: 50, padre: menuCuenta).save(flush:true)
					println "Menu Buscar creado"

					//Menú Cuenta
					def menuCuenta2 = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Activas', controller: 'cuenta', action: 'list', orden: 100, padre: menuCuenta)
					menuCuenta2.save(flush:true)
					println "Menu Cuenta creado"
					
					//Menú Cuenta Pendientes
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Pendientes', controller: 'cuenta', action: 'listPendientes', orden: 200, padre: menuCuenta).save(flush:true)
					println "Menu Pendientes creado"

					//Menú Cuenta Suspendidas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Suspendidas', controller: 'cuenta', action: 'listSuspendidas', orden: 300, padre: menuCuenta).save(flush:true)
					println "Menu Suspendidas creado"
					
					//Menú Cuenta Borradas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Borradas', controller: 'cuenta', action: 'listBorradas', orden: 400, padre: menuCuenta).save(flush:true)
					println "Menu Borradas creado"

					// Verdes
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Verdes', controller: 'cuenta', action: 'listVerdes', orden: 500, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Verdes creado"

					// Naranjas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Naranjas', controller: 'cuenta', action: 'listNaranjas', orden: 550, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Naranjas creado"

					// Amarillas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Amarillos', controller: 'cuenta', action: 'listAmarillos', orden: 600, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Amarillas creado"

					//Menú Cuenta Delivery
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Delivery', controller: 'cuenta', action: 'listDelivery', orden: 800, padre: menuCuenta).save(flush:true)
					println "Menu Delivery creado"
				}
				
				//Nodo padre del menú Impuestos
				def menuImpuestos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Impuestos', icono: 'ti-receipt', orden: 200, padre: menuNodo)
				menuImpuestos.save(flush:true)
				println "Nodo impuestos creado"
				
				if(menuImpuestos!=null) {
					/*def menuRetPerIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Per IVA', controller: 'liquidacionIva', action: 'listRetencionPercepcion', orden: 100, padre: menuImpuestos)
					menuRetPerIVA.save(flush:true)
					println "Menu Ret/Per IVA creado"*/
					
					def menuImpRetPerIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Imp. Ret/Per IVA', controller: 'retencionPercepcionIva', action: 'list', orden: 200, padre: menuImpuestos)
					menuImpRetPerIVA.save(flush:true)
					println "Menu Imp. Ret/Per IVA creado"
					
					def menuIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IVA', controller: 'liquidacionIva', action: 'list', orden: 400, padre: menuImpuestos)
					menuIVA.save(flush:true)
					println "Menu IVA creado"
					
					/*def menuLiqMasivaIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Liq. Masiva IVA', controller: 'liquidacionIva', action: 'listLiquidacionMasiva', orden: 500, padre: menuImpuestos)
					menuLiqMasivaIVA.save(flush:true)
					println "Menu Liq. Masiva IVA creado"*/
					
					/*def menuRetSircrebIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Sircreb IIBB', controller: 'liquidacionIibb', action: 'listRetencionSircreb', orden: 600, padre: menuImpuestos)
					menuRetSircrebIIBB.save(flush:true)
					println "Menu Ret/Sircreb IIBB creado"*/
					
					def menuRetPerIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Imp. Ret/Per IIBB', controller: 'retencionPercepcionIIBB', action: 'list', orden: 650, padre: menuImpuestos)
					menuRetPerIIBB.save(flush:true)
					println "Menu Imp. Ret/Per IIBB creado"
					
					def menuIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB', controller: 'liquidacionIibb', action: 'list', orden: 800, padre: menuImpuestos)
					menuIIBB.save(flush:true)
					println "Menu IIBB creado"
					
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB Sin Alicuotas', controller: 'liquidacionIibb', action: 'listSinAlicuota', orden: 850, padre: menuImpuestos).save(flush:true)
					println "Menu IIBB Sin Alicuotas creado"
					
					/*def menuLiqMasivaIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Liq. Masiva IIBB', controller: 'liquidacionIibb', action: 'listLiquidacionMasiva', orden: 900, padre: menuImpuestos)
					menuLiqMasivaIIBB.save(flush:true)
					println "Menu Liq. Masiva IIBB creado"*/
					
					def menuRetPerAntGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Per/Ant Gan.', controller: 'liquidacionGanancia', action: 'listRetencionPercepcionAnticipo', orden: 1000, padre: menuImpuestos)
					menuRetPerAntGanancia.save(flush:true)
					println "Menu Ret/Per/Ant Gan. creado"
					
					def menuGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ganancias', controller: 'liquidacionGanancia', action: 'list', orden: 1200, padre: menuImpuestos)
					menuGanancia.save(flush:true)
					println "Menu Ganancias creado"
				}

				//Nodo padre del menú Notificaciones
				def menuNotificaciones = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notificaciones', icono: 'ti-email', orden: 300, padre: menuNodo)
				menuNotificaciones.save(flush:true)
				println "Nodo Notificaciones creado"

				if(menuNotificaciones!=null) {
					def menuNotificacionesIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IVA', controller: 'liquidacionIva', action: 'listLiquidacionNotificacion', orden: 100, padre: menuNotificaciones)
					menuNotificacionesIVA.save(flush:true)
					println "Menu Notificaciones IVA creado"

					def menuNotificacionesIIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB', controller: 'liquidacionIibb', action: 'listLiquidacionNotificacion', orden: 200, padre: menuNotificaciones)
					menuNotificacionesIIIBB.save(flush:true)
					println "Menu Notificaciones IIBB creado"
				}

				//Nodo padre del menú Documentos
				def menuDocumentos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Documentos', icono: 'ti-file', orden: 400, padre: menuNodo)
				menuDocumentos.save(flush:true)
				println "Nodo Documentos creado"

				if(menuDocumentos!=null) {
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Veps', controller: 'vep', action: 'list', orden: 100, padre: menuDocumentos).save(flush:true)
					println "Menu Lista Veps creado"

					def menuDeclaracionesJuradas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Declaraciones Juradas', controller: 'declaracionJurada', action: 'list', orden: 200, padre: menuDocumentos)
					menuDeclaracionesJuradas.save(flush:true)
					println "Menu Declaraciones Juradas creado"
				}

				//Nodo padre del menú Importaciones
				def menuImportaciones = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Importaciones', icono: 'ti-cloud-up', orden: 500, padre: menuNodo)
				menuImportaciones.save(flush:true)
				println "Nodo importaciones creado"
				
				if(menuImportaciones!=null) {
					def menuPanelControl = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Panel de Control', controller: 'importacion', action: 'panel', orden: 100, padre: menuImportaciones)
					menuPanelControl.save(flush:true)
					println "Menu Panel de Control creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Veps', controller: 'vep', action: 'panel', orden: 200, padre: menuImportaciones).save(flush:true)
					println "Menu Importación Veps creado"
					
					def menuLogs = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Logs', controller: 'importacion', action: 'list', orden: 300, padre: menuImportaciones)
					menuLogs.save(flush:true)
					println "Menu Logs creado"
				}
				
				//Nodo padre del menú Facturacion
				def menuFacturacion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturación', icono: 'ti-folder', orden: 600, padre: menuNodo)
				menuFacturacion.save(flush:true)
				println "Nodo facturacion creado"
				
				if(menuFacturacion!=null) {
					def menuFacturasVenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas de Venta', controller: 'facturaVenta', action: 'list', orden: 100, padre: menuFacturacion)
					menuFacturasVenta.save(flush:true)
					println "Menu Facturas de Venta creado"
					
					def menuFacturasCompra = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas de Compra', controller: 'facturaCompra', action: 'list', orden: 200, padre: menuFacturacion)
					menuFacturasCompra.save(flush:true)
					println "Menu Facturas de Compra creado"
					
					def menuClientes = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Clientes/Proveedores', controller: 'agenda', action: 'list', orden: 400, padre: menuFacturacion)
					menuClientes.save(flush:true)
					println "Menu Clientes creado"
				}
				
				//Nodo padre del menú Configuracion
				def menuConfiguracion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Configuración', icono: 'ti-settings', orden: 700, padre: menuNodo)
				menuConfiguracion.save(flush:true)
				println "Nodo configuracion creado"
				
				if(menuConfiguracion!=null) {

					def menuActividades = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Actividades', controller: 'actividad', action: 'list', orden: 100, padre: menuConfiguracion)
					menuActividades.save(flush:true)
					println "Menu Actividades creado"

					def menuAlicuotasIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Alicuotas IIBB', controller: 'alicuotaProvinciaActividadIIBB', action: 'list', orden: 150, padre: menuConfiguracion)
					menuAlicuotasIIBB.save(flush:true)
					println "Menu Alicuotas IIBB creado"
					
					def menuCondicionesIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Condiciones IVA', controller: 'condicionIva', action: 'list', orden: 200, padre: menuConfiguracion)
					menuCondicionesIVA.save(flush:true)
					println "Menu Condiciones IVA creado"

					def menuGastoDeduccionGan = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Gasto/Deduccion Gan', controller: 'tipoGastoDeduccionGanancia', action: 'list', orden: 700, padre: menuConfiguracion)
					menuGastoDeduccionGan.save(flush:true)
					println "Menu Gasto/Deduccion Gan creado"
					
					def menuPatrimonioGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Patrimonio Gan', controller: 'tipoPatrimonioGanancia', action: 'list', orden: 800, padre: menuConfiguracion)
					menuPatrimonioGanancia.save(flush:true)
					println "Menu Patrimonio Gan creado"
					
					def menuRangosGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Rangos Gan', controller: 'rangoImpuestoGanancia', action: 'list', orden: 900, padre: menuConfiguracion)
					menuRangosGanancia.save(flush:true)
					println "Menu Rangos Gan creado"
					
					def menuMontosDeduccionGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Montos/Deduccion Gan', controller: 'montoConceptoDeducibleGanancia', action: 'list', orden: 1000, padre: menuConfiguracion)
					menuMontosDeduccionGanancia.save(flush:true)
					println "Menu Montos/Deduccion Gan creado"
				}

				new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Selenium', icono: 'icofont icofont-upload', orden: 900, padre: menuNodo).save(flush:true)?.with{ menuSelenium ->
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Descargas', controller: 'selenium', action: 'descargas', orden: 100, padre: menuSelenium).save(flush:true)
					println "Menú Descargas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Precargas', controller: 'selenium', action: 'precargas', orden: 200, padre: menuSelenium).save(flush:true)
					println "Menú Precargas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Simplificados', controller: 'selenium', action: 'simplificados', orden: 300, padre: menuSelenium).save(flush:true)
					println "Menú simplificados Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'DDJJ y VEP', controller: 'selenium', action: 'ddjj', orden: 400, padre: menuSelenium).save(flush:true)
					println "Menú DDJJ Selenium creado"
				}

				new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Selenium Naranja', icono: 'icofont icofont-upload', orden: 1000, padre: menuNodo).save(flush:true)?.with{ menuSelenium ->
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Descargas', controller: 'selenium', action: 'descargasNaranjas', orden: 100, padre: menuSelenium).save(flush:true)
					println "Menú DescargasNaranjas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Precargas', controller: 'selenium', action: 'precargasNaranjas', orden: 200, padre: menuSelenium).save(flush:true)
					println "Menú PrecargasNaranjas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'DDJJ y VEP', controller: 'selenium', action: 'ddjjNaranjas', orden: 400, padre: menuSelenium).save(flush:true)
					println "Menú DDJJ SeleniumNaranjas creado"
				}
			}
			
		}
	}

	static def inicializarMenuCalimRoleCobranza() {
		def menues
		def role = Role.findByAuthority('ROLE_COBRANZA')
		
		println "Verificando Menu ROLE_COBRANZA..."
		menues = ItemMenu.findAllByRole(role)
		if (!menues){
			//Nodo padre del menú
			def menuNodo = new ItemMenu(role: role, tipo: 'PRINCIPAL', orden: 0, padre: null)
			menuNodo.save(flush:true)
			
			if(menuNodo!=null) {
				//Nodo padre del menú Cuenta
				def menuCuenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', icono: 'ti-id-badge', orden: 100, padre: menuNodo)
				menuCuenta.save(flush:true)
				println "Nodo cuenta creado"
				
				if(menuCuenta!=null) {
					//Menú Cuenta Buscar
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Buscar', controller: 'cuenta', action: 'buscar', orden: 50, padre: menuCuenta).save(flush:true)
					println "Menu Buscar creado"

					//Menú Cuenta
					def menuCuenta2 = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Activas', controller: 'cuenta', action: 'list', orden: 100, padre: menuCuenta)
					menuCuenta2.save(flush:true)
					println "Menu Cuenta creado"
					
					//Menú Cuenta Pendientes
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Pendientes', controller: 'cuenta', action: 'listPendientes', orden: 200, padre: menuCuenta).save(flush:true)
					println "Menu Pendientes creado"

					//Menú Cuenta Suspendidas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Suspendidas', controller: 'cuenta', action: 'listSuspendidas', orden: 300, padre: menuCuenta).save(flush:true)
					println "Menu Suspendidas creado"
					
					//Menú Cuenta Borradas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Borradas', controller: 'cuenta', action: 'listBorradas', orden: 400, padre: menuCuenta).save(flush:true)
					println "Menu Borradas creado"

					// Verdes
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Verdes', controller: 'cuenta', action: 'listVerdes', orden: 500, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Verdes creado"

					// Naranjas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Naranjas', controller: 'cuenta', action: 'listNaranjas', orden: 550, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Naranjas creado"

					// Amarillas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Amarillos', controller: 'cuenta', action: 'listAmarillos', orden: 600, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Amarillas creado"

					//Menú Cuenta Delivery
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Delivery', controller: 'cuenta', action: 'listDelivery', orden: 800, padre: menuCuenta).save(flush:true)
					println "Menu Delivery creado"
				}
				
				//Nodo padre del menú Documentos
				def menuDocumentos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Documentos', icono: 'ti-file', orden: 400, padre: menuNodo)
				menuDocumentos.save(flush:true)
				println "Nodo Documentos creado"

				if(menuDocumentos!=null) {
					def menuFacturasCalim = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas Calim', controller: 'facturaCuenta', action: 'list', orden: 300, padre: menuDocumentos)
					menuFacturasCalim.save(flush:true)
					println "Menu Facturas Calim creado"

					def menuPagoCuenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Pagos Calim', controller: 'pagoCuenta', action: 'list', orden: 400, padre: menuDocumentos)
					menuPagoCuenta.save(flush:true)
					println "Menu Pagos Calim creado"

					def menuComprobantesPago = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Comprobantes de Pago', controller: 'comprobantePago', action: 'list', orden: 500, padre: menuDocumentos)
					menuComprobantesPago.save(flush:true)
					println "Menu Comprobantes creado"

				}

				//Nodo padre del menú Administracion
				def menuAdministracion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Administración', icono: 'ti-view-list-alt', orden: 650, padre: menuNodo)
				menuAdministracion.save(flush:true)
				println "Nodo Administracion creado"

				if(menuAdministracion!=null) {
					//Menú  Deudores
					def menuDeudores = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cobranza', controller: 'cuenta', action: 'listDeudores', orden: 100, padre: menuAdministracion)
					menuDeudores.save(flush:true)
					println "Menu Deudores creado"

					//Menu Tarjetas
					def menuTarjetas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Tarjetas', controller: 'debitoAutomatico', action: 'listCuentasSMActivo', orden: 200, padre: menuAdministracion)
					menuTarjetas.save(flush:true)
					println "Menu Tarjetas creado"

					//Menú  CobranzaMensual
					def menuCobranzaMensual = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Mensuales', controller: 'servicio', action: 'cobranza', orden: 300, padre: menuAdministracion)
					menuCobranzaMensual.save(flush:true)
					println "Menu CobranzaMensual creado"

					//Menú  Debito Automatico
					def menuDebitoAutomatico = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Débito Automático', controller: 'debitoAutomatico', action: 'list', orden: 450, padre: menuAdministracion)
					menuDebitoAutomatico.save(flush:true)
					println "Menu Debito Automatico creado"

					//Menú  Abonos
					def menuAbonos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Abonos', controller: 'cuenta', action: 'listAbonos', orden: 500, padre: menuAdministracion)
					menuAbonos.save(flush:true)
					println "Menu Abonos creado"

					def menuServicios = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Servicios', controller: 'servicio', action: 'list', orden: 550, padre: menuAdministracion)
					menuServicios.save(flush:true)
					println "Menú Servicios creado"
				}
			}
		}
	}

	static def inicializarMenuCalimRoleVentas() {
		def menues
		def role = Role.findByAuthority('ROLE_VENTAS')
		
		println "Verificando Menu ROLE_VENTAS..."
		menues = ItemMenu.findAllByRole(role)
		if (!menues){
			//Nodo padre del menú
			def menuNodo = new ItemMenu(role: role, tipo: 'PRINCIPAL', orden: 0, padre: null)
			menuNodo.save(flush:true)
			
			if(menuNodo!=null) {
				//Nodo padre del menú Cuenta
				def menuCuenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', icono: 'ti-id-badge', orden: 100, padre: menuNodo)
				menuCuenta.save(flush:true)
				println "Nodo cuenta creado"
				
				if(menuCuenta!=null) {
					//Menú Cuenta Buscar
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Buscar', controller: 'cuenta', action: 'buscar', orden: 50, padre: menuCuenta).save(flush:true)
					println "Menu Buscar creado"

					//Menú Cuenta
					def menuCuenta2 = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Activas', controller: 'cuenta', action: 'list', orden: 100, padre: menuCuenta)
					menuCuenta2.save(flush:true)
					println "Menu Cuenta creado"
					
					//Menú Cuenta Pendientes
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Pendientes', controller: 'cuenta', action: 'listPendientes', orden: 200, padre: menuCuenta).save(flush:true)
					println "Menu Pendientes creado"

					//Menú Cuenta Suspendidas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Suspendidas', controller: 'cuenta', action: 'listSuspendidas', orden: 300, padre: menuCuenta).save(flush:true)
					println "Menu Suspendidas creado"
					
					//Menú Cuenta Borradas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Borradas', controller: 'cuenta', action: 'listBorradas', orden: 400, padre: menuCuenta).save(flush:true)
					println "Menu Borradas creado"

					// Verdes
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Verdes', controller: 'cuenta', action: 'listVerdes', orden: 500, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Verdes creado"

					// Naranjas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Naranjas', controller: 'cuenta', action: 'listNaranjas', orden: 550, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Naranjas creado"

					// Amarillas
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Amarillos', controller: 'cuenta', action: 'listAmarillos', orden: 600, padre: menuCuenta).save(flush:true)
					println "Menu Cuentas Amarillas creado"

					//Menú Cuenta Delivery
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Delivery', controller: 'cuenta', action: 'listDelivery', orden: 800, padre: menuCuenta).save(flush:true)
					println "Menu Delivery creado"
				}

				//Nodo padre del menú Documentos
				def menuDocumentos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Documentos', icono: 'ti-file', orden: 400, padre: menuNodo)
				menuDocumentos.save(flush:true)
				println "Nodo Documentos creado"

				if(menuDocumentos!=null) {
					def menuFacturasCalim = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas Calim', controller: 'facturaCuenta', action: 'list', orden: 300, padre: menuDocumentos)
					menuFacturasCalim.save(flush:true)
					println "Menu Facturas Calim creado"
				}
			}
		}
	}

	static def inicializarMenuCalimRoleCuenta(){
		def menues
		def role = Role.findByAuthority('ROLE_CUENTA')

		println "Verificando Menu ROLE_CUENTA Superior..."
		menues = ItemMenu.findAllByRole(role)
		if (!menues){
			//Nodo padre del menú
			def menuNodoSuperior = new ItemMenu(role: role, tipo: 'SUPERIOR', orden: 0, padre: null)
			menuNodoSuperior.save(flush:true)
			
			if(menuNodoSuperior!=null) {
				//Nodo menú Fact. Venta
				def menuFacturas = new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'Facturas',controller: 'facturaVentaUsuario', action: 'list', icono: 'ti-write', orden: 100, padre: menuNodoSuperior)
				menuFacturas.save(flush:true)
				println "Menu Facturas creado"

				//Nodo menú Liquidaciones
				def menuDocumentos = new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'Documentos',controller: 'comprobante', action: 'list', icono: 'icon-docs', orden: 200, padre: menuNodoSuperior)
				menuDocumentos.save(flush:true)
				println "Menu Documentos creado"

				//Nodo menú Liquidaciones
				def menuLiquidaciones = new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'Liquidaciones',controller: 'liquidacionUsuario', action: 'list', icono: 'icon-calculator', orden: 300, padre: menuNodoSuperior)
				menuLiquidaciones.save(flush:true)
				println "Menu Liquidaciones creado"
			
				//Nodo menú DDJJ
				def menuDeclaracionesJuradas = new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'Declaraciones Juradas',controller: 'declaracionJuradaUsuario', action: 'list', icono: 'icon-doc', orden: 400, padre: menuNodoSuperior)
				menuDeclaracionesJuradas.save(flush:true)
				println "Menu DDJJ creado"

				//Nodo menú VEPS
				def menuVeps = new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'VEPS',controller: 'vepUsuario', action: 'list', icono: 'ti-receipt', orden: 350, padre: menuNodoSuperior)
				menuVeps.save(flush:true)
				println "Menu VEPS creado"

				//Nodo menú Agenda
				def menuAgenda = new ItemMenu(role: role, tipo: 'SUPERIOR',controller:'agenda',action:'list', nombre:'Clientes',icono: 'ti-agenda', orden: 500, padre: menuNodoSuperior)
				menuAgenda.save(flush:true)
				println "Menu Agenda Clientes creado"

				//Nodo menú Notificaciones
				def menuNotificaciones = new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'Notificaciones',controller: 'notificacion', action: 'list', icono: 'icon-bell', orden: 600, padre: menuNodoSuperior)
				menuNotificaciones.save(flush:true)
				println "Menu Notificaciones creado"

				//Nodo menú Soporte
				def menuSoporte = new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'Soporte',controller: 'soporte', action: 'index', icono: 'icon-question', orden: 700, padre: menuNodoSuperior)
				menuSoporte.save(flush:true)
				println "Menu Soporte creado"

			}
		
			//Nodo padre del menú
			def menuNodo = new ItemMenu(role: role, tipo: 'PRINCIPAL', orden: 0, padre: null)
			menuNodo.save(flush:true)
			
			if(menuNodo!=null) {
				def menuFacturas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas',controller: 'facturaVentaUsuario', action: 'list', icono: 'ti-write', orden: 100, padre: menuNodo)
				menuFacturas.save(flush:true)
				println "Menu Facturas creado"

				//Nodo menú Liquidaciones
				def menuDocumentos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Documentos',controller: 'comprobante', action: 'list', icono: 'icon-docs', orden: 200, padre: menuNodo)
				menuDocumentos.save(flush:true)
				println "Menu Documentos creado"

				//Nodo menú Liquidaciones
				def menuLiquidaciones = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Liquidaciones',controller: 'liquidacionUsuario', action: 'list', icono: 'icon-calculator', orden: 300, padre: menuNodo)
				menuLiquidaciones.save(flush:true)
				println "Menu Liquidaciones creado"
			
				//Nodo menú DDJJ
				def menuDeclaracionesJuradas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Declaraciones Juradas',controller: 'declaracionJuradaUsuario', action: 'list', icono: 'icon-doc', orden: 400, padre: menuNodo)
				menuDeclaracionesJuradas.save(flush:true)
				println "Menu DDJJ creado"

				//Nodo menú VEPS
				def menuVeps = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'VEPS',controller: 'vepUsuario', action: 'list', icono: 'ti-receipt', orden: 350, padre: menuNodo)
				menuVeps.save(flush:true)
				println "Menu VEPS creado"

				//Nodo menú Agenda
				def menuAgenda = new ItemMenu(role: role, tipo: 'PRINCIPAL',controller:'agenda',action:'list', nombre:'Clientes',icono: 'ti-agenda', orden: 500, padre: menuNodo)
				menuAgenda.save(flush:true)
				println "Menu Agenda Clientes creado"

				//Nodo menú Notificaciones
				def menuNotificaciones = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notificaciones',controller: 'notificacion', action: 'list', icono: 'icon-bell', orden: 600, padre: menuNodo)
				menuNotificaciones.save(flush:true)
				println "Menu Notificaciones creado"

				//Nodo menú Soporte
				def menuSoporte = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Soporte',controller: 'soporte', action: 'index', icono: 'icon-question', orden: 700, padre: menuNodo)
				menuSoporte.save(flush:true)
				println "Menu Soporte creado"

				//Menú Salir
				def menuSalir = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Salir',controller: 'logout', action: 'index', icono: 'ti-power-off', orden: 900, padre: menuNodo)
				menuSalir.save(flush:true)
				println "Menu Salir creado"
			}
		}
	}
	
	static def inicializarMenuCalimRoleAdminPedidosYa(){
		def menues
		def role = Role.findByAuthority('ROLE_ADMIN_PY')

		println "Verificando Menu ROLE_ADMIN_PY Superior..."
		menues = ItemMenu.findAllByRole(role)
		if (!menues){
			//Nodo padre del menú
			def menuNodoSuperior = new ItemMenu(role: role, tipo: 'SUPERIOR', orden: 0, padre: null)
			menuNodoSuperior.save(flush:true)
			
			if(menuNodoSuperior!=null) {

				//Nodo menú Riders
				new ItemMenu(role: role, tipo: 'SUPERIOR',controller:'pedidosYa',action:'listRiders', nombre:'Riders',icono: 'ti-agenda', orden: 100, padre: menuNodoSuperior).save(flush:true)
				println "Menu Riders creado"

				//Nodo menú Proformas
				new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'Proformas',controller: 'pedidosYa', action: 'admin', icono: 'ti-receipt', orden: 200, padre: menuNodoSuperior).save(flush:true)
				println "Menu Proformas creado"

			}
		}
	}
	
	static def inicializarMenuCalimRoleRiderPedidosYa(){
		def menues
		def role = Role.findByAuthority('ROLE_RIDER_PY')

		println "Verificando Menu ROLE_RIDER_PY Superior..."
		menues = ItemMenu.findAllByRole(role)
		if (!menues){
			//Nodo padre del menú
			def menuNodoSuperior = new ItemMenu(role: role, tipo: 'SUPERIOR', orden: 0, padre: null)
			menuNodoSuperior.save(flush:true)
			
			if(menuNodoSuperior!=null) {

				//Nodo menú Facturas
				new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'Facturas',controller: 'facturaVentaUsuario', action: 'list', icono: 'ti-write', orden: 100, padre: menuNodoSuperior).save(flush:true)
				println "Menu Facturas creado"

				//Nodo menú Soporte
				new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'Ayuda',controller: 'soporte', action: 'index', icono: 'icon-question', orden: 200, padre: menuNodoSuperior).save(flush:true)
				println "Menu Soporte creado"

				//Nodo menú Mi Perfil
				new ItemMenu(role: role, tipo: 'SUPERIOR', nombre: 'Mi Perfil',controller: 'cuentaUsuario', action: 'show', icono: 'ti-user', orden: 300, padre: menuNodoSuperior).save(flush:true)
				println "Menu Mi Perfil creado"

			}
		}
	}

	static def inicializarMenuesPavoni(){
		println "Verificando Menues..."
		def menues
				
		inicializarMenuPavoniRoleAdmin()
		inicializarMenuPavoniRoleUser()
		inicializarMenuPavoniRoleLectura()
	}
	
	static def inicializarMenuPavoniRoleAdmin() {
		def menues
		def role = Role.findByAuthority('ROLE_ADMIN')
		
		println "Verificando Menu ROLE_ADMIN..."
		menues = ItemMenu.findAllByRole(role)
		if (!menues){
			//Nodo padre del menú
			def menuNodo = new ItemMenu(role: role, tipo: 'PRINCIPAL', orden: 0, padre: null)
			menuNodo.save(flush:true)
			
			if(menuNodo!=null) {
				//Nodo padre del menú Cuenta
				def menuCuenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', icono: 'ti-id-badge', orden: 100, padre: menuNodo)
				menuCuenta.save(flush:true)
				println "Nodo cuenta creado"
				
				if(menuCuenta!=null) {
					//Menú Cuenta
					def menuCuenta2 = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', controller: 'cuenta', action: 'list', orden: 100, padre: menuCuenta)
					menuCuenta2.save(flush:true)
					println "Menu Cuenta creado"
					
					//Menú Cuenta Borradas
					def menuCuentaBorradas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Borradas', controller: 'cuenta', action: 'listBorradas', orden: 200, padre: menuCuenta)
					menuCuentaBorradas.save(flush:true)
					println "Menu Borradas creado"

					//Menú Deudas CCMA
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Deudas CCMA', controller: 'cuenta', action: 'listCcma', orden: 300, padre: menuCuenta).save(flush:true)
					println "Menu Deudas CCMA creado"
				}
				
				//Nodo padre del menú Impuestos
				def menuImpuestos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Impuestos', icono: 'ti-receipt', orden: 200, padre: menuNodo)
				menuImpuestos.save(flush:true)
				println "Nodo impuestos creado"
				
				if(menuImpuestos!=null) {
					def menuRetPerIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Per IVA', controller: 'liquidacionIva', action: 'listRetencionPercepcion', orden: 100, padre: menuImpuestos)
					menuRetPerIVA.save(flush:true)
					println "Menu Ret/Per IVA creado"
					
					def menuImpRetPerIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Imp. Ret/Per IVA', controller: 'retencionPercepcionIva', action: 'list', orden: 200, padre: menuImpuestos)
					menuImpRetPerIVA.save(flush:true)
					println "Menu Imp. Ret/Per IVA creado"
					
					def menuNotasIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notas IVA', controller: 'liquidacionIva', action: 'listNota', orden: 300, padre: menuImpuestos)
					menuNotasIVA.save(flush:true)
					println "Menu Notas IVA creado"
					
					def menuIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IVA', controller: 'liquidacionIva', action: 'list', orden: 400, padre: menuImpuestos)
					menuIVA.save(flush:true)
					println "Menu IVA creado"
					
					def menuLiqMasivaIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Liq. Masiva IVA', controller: 'liquidacionIva', action: 'listLiquidacionMasiva', orden: 500, padre: menuImpuestos)
					menuLiqMasivaIVA.save(flush:true)
					println "Menu Liq. Masiva IVA creado"
					
					def menuRetSircrebIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Sircreb IIBB', controller: 'liquidacionIibb', action: 'listRetencionSircreb', orden: 600, padre: menuImpuestos)
					menuRetSircrebIIBB.save(flush:true)
					println "Menu Ret/Sircreb IIBB creado"
					
					def menuRetPerIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Imp. Ret/Per IIBB', controller: 'retencionPercepcionIIBB', action: 'list', orden: 650, padre: menuImpuestos)
					menuRetPerIIBB.save(flush:true)
					println "Menu Imp. Ret/Per IIBB creado"
					
					def menuNotasIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notas IIBB', controller: 'liquidacionIibb', action: 'listNota', orden: 700, padre: menuImpuestos)
					menuNotasIIBB.save(flush:true)
					println "Menu Notas IIBB creado"
					
					def menuIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB', controller: 'liquidacionIibb', action: 'list', orden: 800, padre: menuImpuestos)
					menuIIBB.save(flush:true)
					println "Menu IIBB creado"
					
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB Sin Alicuotas', controller: 'liquidacionIibb', action: 'listSinAlicuota', orden: 850, padre: menuImpuestos).save(flush:true)
					println "Menu IIBB Sin Alicuotas creado"
					
					def menuLiqMasivaIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Liq. Masiva IIBB', controller: 'liquidacionIibb', action: 'listLiquidacionMasiva', orden: 900, padre: menuImpuestos)
					menuLiqMasivaIIBB.save(flush:true)
					println "Menu Liq. Masiva IIBB creado"
					
					def menuRetPerAntGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Per/Ant Gan.', controller: 'liquidacionGanancia', action: 'listRetencionPercepcionAnticipo', orden: 1000, padre: menuImpuestos)
					menuRetPerAntGanancia.save(flush:true)
					println "Menu Ret/Per/Ant Gan. creado"
					
					def menuNotaGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notas Ganancias', controller: 'liquidacionGanancia', action: 'listNota', orden: 1100, padre: menuImpuestos)
					menuNotaGanancia.save(flush:true)
					println "Menu Notas Ganancias creado"
					
					def menuGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ganancias', controller: 'liquidacionGanancia', action: 'list', orden: 1200, padre: menuImpuestos)
					menuGanancia.save(flush:true)
					println "Menu Ganancias creado"
				}
				
				//Nodo padre del menú veps
				def menuDocumentos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Documentos', icono: 'ti-file', orden: 300, padre: menuNodo)
				menuDocumentos.save(flush:true)
				println "Nodo Documentos creado"

				if(menuDocumentos!=null) {
					def menuVeps = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Veps', controller: 'vep', action: 'panel', orden: 100, padre: menuDocumentos)
					menuVeps.save(flush:true)
					println "Menu Veps creado"

					def menuDeclaracionesJuradas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Declaraciones Juradas', controller: 'declaracionJurada', action: 'list', orden: 200, padre: menuDocumentos)
					menuDeclaracionesJuradas.save(flush:true)
					println "Menu Declaraciones Juradas creado"

					def menuFacturasCalim = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas Calim', controller: 'facturaCuenta', action: 'list', orden: 300, padre: menuDocumentos)
					menuFacturasCalim.save(flush:true)
					println "Menu Facturas Calim creado"

					def menuRecibosSueldo = new ItemMenu(role:role, tipo: 'PRINCIPAL', nombre:'Recibos de Sueldo', controller:'reciboSueldo', action:'list', orden:600, padre:menuDocumentos)
					menuRecibosSueldo.save(flush:true)
					println "Menu Recibos de Sueldo Creado"
				}	

				//Nodo padre del menú Importaciones
				def menuImportaciones = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Importaciones', icono: 'ti-cloud-up', orden: 300, padre: menuNodo)
				menuImportaciones.save(flush:true)
				println "Nodo importaciones creado"
				
				if(menuImportaciones!=null) {
					def menuPanelControl = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Panel de Control', controller: 'importacion', action: 'panel', orden: 100, padre: menuImportaciones)
					menuPanelControl.save(flush:true)
					println "Menu Panel de Control creado"
					
					def menuLogs = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Logs', controller: 'importacion', action: 'list', orden: 200, padre: menuImportaciones)
					menuLogs.save(flush:true)
					println "Menu Logs creado"
				}
				
				//Nodo padre del menú Facturacion
				def menuFacturacion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturación', icono: 'ti-folder', orden: 400, padre: menuNodo)
				menuFacturacion.save(flush:true)
				println "Nodo facturacion creado"
				
				if(menuFacturacion!=null) {
					def menuFacturasVenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas de Venta', controller: 'facturaVenta', action: 'list', orden: 100, padre: menuFacturacion)
					menuFacturasVenta.save(flush:true)
					println "Menu Facturas de Venta creado"
					
					def menuFacturasCompra = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas de Compra', controller: 'facturaCompra', action: 'list', orden: 200, padre: menuFacturacion)
					menuFacturasCompra.save(flush:true)
					println "Menu Facturas de Compra creado"
					
					def menuTipoComprobante = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Tipos de Comprobante', controller: 'tipoComprobante', action: 'list', orden: 300, padre: menuFacturacion)
					menuTipoComprobante.save(flush:true)
					println "Menu Tipos de Comprobante creado"
					
					def menuClientesProveedores = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Clientes/Proveedores', controller: 'persona', action: 'list', orden: 400, padre: menuFacturacion)
					menuClientesProveedores.save(flush:true)
					println "Menu Clientes/Proveedores creado"
				}
				
				//Nodo padre del menú Configuracion
				def menuConfiguracion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Configuración', icono: 'ti-settings', orden: 600, padre: menuNodo)
				menuConfiguracion.save(flush:true)
				println "Nodo configuracion creado"
				
				if(menuConfiguracion!=null) {
					def menuUsuarios = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Usuarios', controller: 'usuario', action: 'list', orden: 50, padre: menuConfiguracion)
					menuUsuarios.save(flush:true)
					println "Menu Usuarios creado"

					def menuActividades = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Actividades', controller: 'actividad', action: 'list', orden: 100, padre: menuConfiguracion)
					menuActividades.save(flush:true)
					println "Menu Actividades creado"

					def menuAlicuotasIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Alicuotas IIBB', controller: 'alicuotaProvinciaActividadIIBB', action: 'list', orden: 150, padre: menuConfiguracion)
					menuAlicuotasIIBB.save(flush:true)
					println "Menu Alicuotas IIBB creado"
					
					def menuCondicionesIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Condiciones IVA', controller: 'condicionIva', action: 'list', orden: 200, padre: menuConfiguracion)
					menuCondicionesIVA.save(flush:true)
					println "Menu Condiciones IVA creado"
					
					def menuRegimenesIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Régimenes IIBB', controller: 'regimenIibb', action: 'list', orden: 300, padre: menuConfiguracion)
					menuRegimenesIIBB.save(flush:true)
					println "Menu Régimenes IIBB creado"
					
					def menuProvincias = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Provincias', controller: 'provincia', action: 'list', orden: 400, padre: menuConfiguracion)
					menuProvincias.save(flush:true)
					println "Menu Provincias creado"
					
					def menuLocalidades = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Localidades', controller: 'localidad', action: 'list', orden: 500, padre: menuConfiguracion)
					menuLocalidades.save(flush:true)
					println "Menu Localidades creado"
					
					def menuZonas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Zonas', controller: 'zona', action: 'list', orden: 600, padre: menuConfiguracion)
					menuZonas.save(flush:true)
					println "Menu Zonas creado"
					
					def menuGastoDeduccionGan = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Gasto/Deduccion Gan', controller: 'tipoGastoDeduccionGanancia', action: 'list', orden: 700, padre: menuConfiguracion)
					menuGastoDeduccionGan.save(flush:true)
					println "Menu Gasto/Deduccion Gan creado"
					
					def menuPatrimonioGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Patrimonio Gan', controller: 'tipoPatrimonioGanancia', action: 'list', orden: 800, padre: menuConfiguracion)
					menuPatrimonioGanancia.save(flush:true)
					println "Menu Patrimonio Gan creado"
					
					def menuRangosGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Rangos Gan', controller: 'rangoImpuestoGanancia', action: 'list', orden: 900, padre: menuConfiguracion)
					menuRangosGanancia.save(flush:true)
					println "Menu Rangos Gan creado"
					
					def menuMontosDeduccionGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Montos/Deduccion Gan', controller: 'montoConceptoDeducibleGanancia', action: 'list', orden: 1000, padre: menuConfiguracion)
					menuMontosDeduccionGanancia.save(flush:true)
					println "Menu Montos/Deduccion Gan creado"
				}

				new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Selenium', icono: 'icofont icofont-upload', orden: 700, padre: menuNodo).save(flush:true)?.with{ menuSelenium ->
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Descargas', controller: 'selenium', action: 'descargas', orden: 100, padre: menuSelenium).save(flush:true)
					println "Menú Descargas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Precargas', controller: 'selenium', action: 'precargas', orden: 200, padre: menuSelenium).save(flush:true)
					println "Menú Precargas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Simplificados', controller: 'selenium', action: 'simplificados', orden: 300, padre: menuSelenium).save(flush:true)
					println "Menú simplificados Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'DDJJ y VEP', controller: 'selenium', action: 'ddjj', orden: 400, padre: menuSelenium).save(flush:true)
					println "Menú DDJJ Selenium creado"
				}

				new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Selenium Naranja', icono: 'icofont icofont-upload', orden: 1000, padre: menuNodo).save(flush:true)?.with{ menuSelenium ->
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Descargas', controller: 'selenium', action: 'descargasNaranjas', orden: 100, padre: menuSelenium).save(flush:true)
					println "Menú DescargasNaranjas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Precargas', controller: 'selenium', action: 'precargasNaranjas', orden: 200, padre: menuSelenium).save(flush:true)
					println "Menú PrecargasNaranjas Selenium creado"

					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'DDJJ y VEP', controller: 'selenium', action: 'ddjjNaranjas', orden: 400, padre: menuSelenium).save(flush:true)
					println "Menú DDJJ SeleniumNaranjas creado"
				}
			}
			
		}
	}
	
	static def inicializarMenuPavoniRoleUser() {
		def menues
		def role = Role.findByAuthority('ROLE_USER')
		
		println "Verificando Menu ROLE_USER..."
		menues = ItemMenu.findAllByRole(role)
		if (!menues){
			//Nodo padre del menú
			def menuNodo = new ItemMenu(role: role, tipo: 'PRINCIPAL', orden: 0, padre: null)
			menuNodo.save(flush:true)
			
			if(menuNodo!=null) {
				//Nodo padre del menú Cuenta
				def menuCuenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', icono: 'ti-id-badge', orden: 100, padre: menuNodo)
				menuCuenta.save(flush:true)
				println "Nodo cuenta creado"
				
				if(menuCuenta!=null) {
					//Menú Cuenta
					def menuCuenta2 = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', controller: 'cuenta', action: 'list', orden: 100, padre: menuCuenta)
					menuCuenta2.save(flush:true)
					println "Menu Cuenta creado"
					
					//Menú Cuenta Borradas
					def menuCuentaBorradas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Borradas', controller: 'cuenta', action: 'listBorradas', orden: 200, padre: menuCuenta)
					menuCuentaBorradas.save(flush:true)
					println "Menu Borradas creado"
				}
				
				//Nodo padre del menú Impuestos
				def menuImpuestos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Impuestos', icono: 'ti-receipt', orden: 200, padre: menuNodo)
				menuImpuestos.save(flush:true)
				println "Nodo impuestos creado"
				
				if(menuImpuestos!=null) {
					def menuRetPerIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Per IVA', controller: 'liquidacionIva', action: 'listRetencionPercepcion', orden: 100, padre: menuImpuestos)
					menuRetPerIVA.save(flush:true)
					println "Menu Ret/Per IVA creado"
					
					def menuImpRetPerIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Imp. Ret/Per IVA', controller: 'retencionPercepcionIva', action: 'list', orden: 200, padre: menuImpuestos)
					menuImpRetPerIVA.save(flush:true)
					println "Menu Imp. Ret/Per IVA creado"
					
					def menuNotasIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notas IVA', controller: 'liquidacionIva', action: 'listNota', orden: 300, padre: menuImpuestos)
					menuNotasIVA.save(flush:true)
					println "Menu Notas IVA creado"
					
					def menuIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IVA', controller: 'liquidacionIva', action: 'list', orden: 400, padre: menuImpuestos)
					menuIVA.save(flush:true)
					println "Menu IVA creado"
					
					/*def menuLiqMasivaIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Liq. Masiva IVA', controller: 'liquidacionIva', action: 'listLiquidacionMasiva', orden: 500, padre: menuImpuestos)
					menuLiqMasivaIVA.save(flush:true)
					println "Menu Liq. Masiva IVA creado"*/
					
					def menuRetSircrebIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Sircreb IIBB', controller: 'liquidacionIibb', action: 'listRetencionSircreb', orden: 600, padre: menuImpuestos)
					menuRetSircrebIIBB.save(flush:true)
					println "Menu Ret/Sircreb IIBB creado"
					
					def menuRetPerIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Imp. Ret/Per IIBB', controller: 'retencionPercepcionIIBB', action: 'list', orden: 650, padre: menuImpuestos)
					menuRetPerIIBB.save(flush:true)
					println "Menu Imp. Ret/Per IIBB creado"
					
					def menuNotasIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notas IIBB', controller: 'liquidacionIibb', action: 'listNota', orden: 700, padre: menuImpuestos)
					menuNotasIIBB.save(flush:true)
					println "Menu Notas IIBB creado"
					
					def menuIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB', controller: 'liquidacionIibb', action: 'list', orden: 800, padre: menuImpuestos)
					menuIIBB.save(flush:true)
					println "Menu IIBB creado"
					
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB Sin Alicuotas', controller: 'liquidacionIibb', action: 'listSinAlicuota', orden: 850, padre: menuImpuestos).save(flush:true)
					println "Menu IIBB Sin Alicuotas creado"
					
					/*def menuLiqMasivaIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Liq. Masiva IIBB', controller: 'liquidacionIibb', action: 'listLiquidacionMasiva', orden: 900, padre: menuImpuestos)
					menuLiqMasivaIIBB.save(flush:true)
					println "Menu Liq. Masiva IIBB creado"*/
					
					def menuRetPerAntGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ret/Per/Ant Gan.', controller: 'liquidacionGanancia', action: 'listRetencionPercepcionAnticipo', orden: 1000, padre: menuImpuestos)
					menuRetPerAntGanancia.save(flush:true)
					println "Menu Ret/Per/Ant Gan. creado"
					
					def menuNotaGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Notas Ganancias', controller: 'liquidacionGanancia', action: 'listNota', orden: 1100, padre: menuImpuestos)
					menuNotaGanancia.save(flush:true)
					println "Menu Notas Ganancias creado"
					
					/*def menuGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Ganancias', controller: 'liquidacionGanancia', action: 'list', orden: 1200, padre: menuImpuestos)
					menuGanancia.save(flush:true)
					println "Menu Ganancias creado"*/
				}
				
				//Nodo padre del menú Importaciones
				/*def menuImportaciones = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Importaciones', icono: 'ti-cloud-up', orden: 300, padre: menuNodo)
				menuImportaciones.save(flush:true)
				println "Nodo importaciones creado"
				
				if(menuImportaciones!=null) {
					def menuPanelControl = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Panel de Control', controller: 'importacion', action: 'panel', orden: 100, padre: menuImportaciones)
					menuPanelControl.save(flush:true)
					println "Menu Panel de Control creado"
					
					def menuLogs = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Logs', controller: 'importacion', action: 'list', orden: 200, padre: menuImportaciones)
					menuLogs.save(flush:true)
					println "Menu Logs creado"
				}*/
				
				//Nodo padre del menú Facturacion
				/*def menuFacturacion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturación', icono: 'ti-folder', orden: 400, padre: menuNodo)
				menuFacturacion.save(flush:true)
				println "Nodo facturacion creado"
				
				if(menuFacturacion!=null) {
					def menuFacturasVenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas de Venta', controller: 'facturaVenta', action: 'list', orden: 100, padre: menuFacturacion)
					menuFacturasVenta.save(flush:true)
					println "Menu Facturas de Venta creado"
					
					def menuFacturasCompra = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Facturas de Compra', controller: 'facturaCompra', action: 'list', orden: 200, padre: menuFacturacion)
					menuFacturasCompra.save(flush:true)
					println "Menu Facturas de Compra creado"
					
					def menuTipoComprobante = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Tipos de Comprobante', controller: 'tipoComprobante', action: 'list', orden: 300, padre: menuFacturacion)
					menuTipoComprobante.save(flush:true)
					println "Menu Tipos de Comprobante creado"
					
					def menuClientesProveedores = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Clientes/Proveedores', controller: 'persona', action: 'list', orden: 400, padre: menuFacturacion)
					menuClientesProveedores.save(flush:true)
					println "Menu Clientes/Proveedores creado"
				}*/
				
				//Nodo padre del menú Configuracion
				/*def menuConfiguracion = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Configuración', icono: 'ti-settings', orden: 500, padre: menuNodo)
				menuConfiguracion.save(flush:true)
				println "Nodo configuracion creado"
				
				if(menuConfiguracion!=null) {
					def menuActividades = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Actividades', controller: 'actividad', action: 'list', orden: 100, padre: menuConfiguracion)
					menuActividades.save(flush:true)
					println "Menu Actividades creado"
					
					def menuCondicionesIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Condiciones IVA', controller: 'condicionIva', action: 'list', orden: 200, padre: menuConfiguracion)
					menuCondicionesIVA.save(flush:true)
					println "Menu Condiciones IVA creado"
					
					def menuRegimenesIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Régimenes IIBB', controller: 'regimenIibb', action: 'list', orden: 300, padre: menuConfiguracion)
					menuRegimenesIIBB.save(flush:true)
					println "Menu Régimenes IIBB creado"
					
					def menuProvincias = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Provincias', controller: 'provincia', action: 'list', orden: 400, padre: menuConfiguracion)
					menuProvincias.save(flush:true)
					println "Menu Provincias creado"
					
					def menuLocalidades = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Localidades', controller: 'localidad', action: 'list', orden: 500, padre: menuConfiguracion)
					menuLocalidades.save(flush:true)
					println "Menu Localidades creado"
					
					def menuZonas = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Zonas', controller: 'zona', action: 'list', orden: 600, padre: menuConfiguracion)
					menuZonas.save(flush:true)
					println "Menu Zonas creado"
					
					def menuGastoDeduccionGan = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Gasto/Deduccion Gan', controller: 'tipoGastoDeduccionGanancia', action: 'list', orden: 700, padre: menuConfiguracion)
					menuGastoDeduccionGan.save(flush:true)
					println "Menu Gasto/Deduccion Gan creado"
					
					def menuPatrimonioGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Patrimonio Gan', controller: 'tipoPatrimonioGanancia', action: 'list', orden: 800, padre: menuConfiguracion)
					menuPatrimonioGanancia.save(flush:true)
					println "Menu Patrimonio Gan creado"
					
					def menuRangosGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Rangos Gan', controller: 'rangoImpuestoGanancia', action: 'list', orden: 900, padre: menuConfiguracion)
					menuRangosGanancia.save(flush:true)
					println "Menu Rangos Gan creado"
					
					def menuMontosDeduccionGanancia = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Montos/Deduccion Gan', controller: 'montoConceptoDeducibleGanancia', action: 'list', orden: 1000, padre: menuConfiguracion)
					menuMontosDeduccionGanancia.save(flush:true)
					println "Menu Montos/Deduccion Gan creado"
				}*/
			}
			
		}
	}
	
	static def inicializarMenuPavoniRoleLectura() {
		def menues
		def role = Role.findByAuthority('ROLE_LECTURA')
		
		println "Verificando Menu ROLE_LECTURA..."
		menues = ItemMenu.findAllByRole(role)
		if (!menues){
			//Nodo padre del menú
			def menuNodo = new ItemMenu(role: role, tipo: 'PRINCIPAL', orden: 0, padre: null)
			menuNodo.save(flush:true)
			
			if(menuNodo!=null) {
				//Nodo padre del menú Cuenta
				def menuCuenta = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', icono: 'ti-id-badge', orden: 100, padre: menuNodo)
				menuCuenta.save(flush:true)
				println "Nodo cuenta creado"
				
				if(menuCuenta!=null) {
					//Menú Cuenta
					def menuCuenta2 = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Cuenta', controller: 'cuenta', action: 'list', orden: 100, padre: menuCuenta)
					menuCuenta2.save(flush:true)
					println "Menu Cuenta creado"
				}
				
				//Nodo padre del menú Impuestos
				def menuImpuestos = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'Impuestos', icono: 'ti-receipt', orden: 200, padre: menuNodo)
				menuImpuestos.save(flush:true)
				println "Nodo impuestos creado"
				
				if(menuImpuestos!=null) {
					def menuIVA = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IVA', controller: 'liquidacionIva', action: 'list', orden: 400, padre: menuImpuestos)
					menuIVA.save(flush:true)
					println "Menu IVA creado"
					
					def menuIIBB = new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB', controller: 'liquidacionIibb', action: 'list', orden: 800, padre: menuImpuestos)
					menuIIBB.save(flush:true)
					println "Menu IIBB creado"
					
					new ItemMenu(role: role, tipo: 'PRINCIPAL', nombre: 'IIBB Sin Alicuotas', controller: 'liquidacionIibb', action: 'listSinAlicuota', orden: 850, padre: menuImpuestos).save(flush:true)
					println "Menu IIBB Sin Alicuotas creado"
				}
			}			
		}
	}


	static def inicializarIVAs(){
		println "Verificando Porcentajes de IVA..."
		def iva
		iva = AlicuotaIva.findByValor(27)
		if (!iva){
			iva = new AlicuotaIva()
			iva.valor=27
			iva.caption="27%"
			iva.save(flush:true)
			println "Creado IVA 27%."
		}
		iva = AlicuotaIva.findByValor(21)
		if (!iva){
			iva = new AlicuotaIva()
			iva.valor=21
			iva.caption="21%"
			iva.save(flush:true)
			println "Creado IVA 21%."
		}
		iva = AlicuotaIva.findByValor(10.5)
		if (!iva){
			iva = new AlicuotaIva()
			iva.valor=10.5
			iva.caption="10.5%"
			iva.save(flush:true)
			println "Creado IVA 10.5%."
		}
		iva = AlicuotaIva.findByValor(5)
		if (!iva){
			iva = new AlicuotaIva()
			iva.valor=5
			iva.caption="5%"
			iva.save(flush:true)
			println "Creado IVA 5%."
		}
		iva = AlicuotaIva.findByValor(2.5)
		if (!iva){
			iva = new AlicuotaIva()
			iva.valor=2.5
			iva.caption="2.5%"
			iva.save(flush:true)
			println "Creado IVA 2.5%."
		}
		iva = AlicuotaIva.findByCaption("0%")
		if (!iva){
			iva = new AlicuotaIva()
			iva.valor=0
			iva.caption="0%"
			iva.save(flush:true)
			println "Creado IVA 0%."
		}
		iva = AlicuotaIva.findByCaption("No gravado")
		if (!iva){
			iva = new AlicuotaIva()
			iva.valor=0
			iva.caption="No gravado"
			iva.save(flush:true)
			println "Creado IVA No gravado."
		}
		iva = AlicuotaIva.findByCaption("Exento")
		if (!iva){
			iva = new AlicuotaIva()
			iva.valor=0
			iva.caption="Exento"
			iva.save(flush:true)
			println "Creado IVA Exento."
		}
	}
	
	static def inicializarEstudios(){
		println "Verificando Estudios..."
		def estudioDefault = Estudio.findByNombre('Pavoni')
		if(estudioDefault==null){
			estudioDefault = new Estudio(nombre:'Pavoni')
			estudioDefault.save(flush:true)
			println "Estudio Pavoni creado."
		}
		
		def estudioCalim = Estudio.findByNombre('Calim')
		if(estudioCalim==null){
			estudioCalim = new Estudio(nombre:'Calim')
			estudioCalim.save(flush:true)
			println "Estudio Calim creado."
		}
	}
	
	static def inicializarRoles(){
		println "Verificando Roles..."
		['ROLE_USER', 'ROLE_ADMIN', 'ROLE_LECTURA', 'ROLE_CUENTA', 'ROLE_RIDER_PY', 'ROLE_ADMIN_PY'].each{
			if(!Role.findByAuthority(it)){
				new Role(authority:it).save(flush:true)
				println "$it creado"
			}
		}
	}
	
	static def inicializarUsuarios(){
		def estudioDefault = Estudio.findByNombre('Pavoni')
		def roleAdmin = Role.findByAuthority('ROLE_ADMIN')
		def roleLectura = Role.findByAuthority('ROLE_LECTURA')
		def roleUser = Role.findByAuthority('ROLE_USER')
		
		println "Verificando Usuarios..."
		def userDefault = User.findByUsername('cgzechner@gmail.com')
		//Si no hay User
		if(userDefault==null){
			userDefault = new User()
			userDefault.username = 'cgzechner@gmail.com'
			userDefault.password = 'asdfasdf'
			userDefault.accountExpired = false
			userDefault.accountLocked = false
			userDefault.enabled = true
			userDefault.passwordExpired = false
			userDefault.userTenantId = new Integer(estudioDefault.id.toString())
			userDefault.save(flush:true)
			
			def userRole = new UserRole()
			userRole.user = userDefault
			userRole.role = roleAdmin
			userRole.save(flush:true)
			println "User cgzechner@gmail.com creado."
		}
		
		def epavoni = User.findByUsername('epavoni2000@gmail.com')
		if(epavoni==null){
			epavoni = new User()
			epavoni.username = 'epavoni2000@gmail.com'
			epavoni.password = 'pavoni2017'
			epavoni.accountExpired = false
			epavoni.accountLocked = false
			epavoni.enabled = true
			epavoni.passwordExpired = false
			epavoni.userTenantId = new Integer(estudioDefault.id.toString())
			epavoni.save(flush:true)
			
			def userRolePavoni = new UserRole()
			userRolePavoni.user = epavoni
			userRolePavoni.role = roleAdmin
			userRolePavoni.save(flush:true)
			println "User epavoni2000@gmail.com creado."
		}
		
		def cabuqui = User.findByUsername('cabuqui@gmail.com')
		if(cabuqui==null){
			cabuqui = new User()
			cabuqui.username = 'cabuqui@gmail.com'
			cabuqui.password = 'cabuqui2017'
			cabuqui.accountExpired = false
			cabuqui.accountLocked = false
			cabuqui.enabled = true
			cabuqui.passwordExpired = false
			cabuqui.userTenantId = new Integer(estudioDefault.id.toString())
			cabuqui.save(flush:true)
			
			def userRoleCabuqui = new UserRole()
			userRoleCabuqui.user = cabuqui
			userRoleCabuqui.role = roleAdmin
			userRoleCabuqui.save(flush:true)
			println "User cabuqui@gmail.com creado."
		}
		
		def maruPissi = User.findByUsername('maru_pissi@hotmail.com')
		if(maruPissi==null){
			maruPissi = new User()
			maruPissi.username = 'maru_pissi@hotmail.com'
			maruPissi.password = 'maru2017'
			maruPissi.accountExpired = false
			maruPissi.accountLocked = false
			maruPissi.enabled = true
			maruPissi.passwordExpired = false
			maruPissi.userTenantId = new Integer(estudioDefault.id.toString())
			maruPissi.save(flush:true)
			
			def userRoleMaruPissi = new UserRole()
			userRoleMaruPissi.user = maruPissi
			userRoleMaruPissi.role = roleAdmin
			userRoleMaruPissi.save(flush:true)
			println "User maru_pissi@hotmail.com creado."
		}
		
		def marianomarcelo = User.findByUsername('marianomarcelo.mendez@hotmail.com')
		if(marianomarcelo==null){
			marianomarcelo = new User()
			marianomarcelo.username = 'marianomarcelo.mendez@hotmail.com'
			marianomarcelo.password = 'marianomarcelo2018'
			marianomarcelo.accountExpired = false
			marianomarcelo.accountLocked = false
			marianomarcelo.enabled = true
			marianomarcelo.passwordExpired = false
			marianomarcelo.userTenantId = new Integer(estudioDefault.id.toString())
			marianomarcelo.save(flush:true)
			
			def userRoleMarianomarcelo = new UserRole()
			userRoleMarianomarcelo.user = marianomarcelo
			userRoleMarianomarcelo.role = roleLectura
			userRoleMarianomarcelo.save(flush:true)
			println "User marianomarcelo.mendez@hotmail.com creado."
		}
		
		def cvferchero = User.findByUsername('cvferchero@gmail.com')
		if(cvferchero==null){
			cvferchero = new User()
			cvferchero.username = 'cvferchero@gmail.com'
			cvferchero.password = 'cvferchero2018'
			cvferchero.accountExpired = false
			cvferchero.accountLocked = false
			cvferchero.enabled = true
			cvferchero.passwordExpired = false
			cvferchero.userTenantId = new Integer(estudioDefault.id.toString())
			cvferchero.save(flush:true)
			
			def userRoleCvferchero = new UserRole()
			userRoleCvferchero.user = cvferchero
			userRoleCvferchero.role = roleLectura
			userRoleCvferchero.save(flush:true)
			println "User cvferchero@gmail.com creado."
		}
		
		def sabrinaoflin = User.findByUsername('sabrinaoflin@hotmail.com')
		if(sabrinaoflin==null){
			sabrinaoflin = new User()
			sabrinaoflin.username = 'sabrinaoflin@hotmail.com'
			sabrinaoflin.password = 'sabrinaoflin2018'
			sabrinaoflin.accountExpired = false
			sabrinaoflin.accountLocked = false
			sabrinaoflin.enabled = true
			sabrinaoflin.passwordExpired = false
			sabrinaoflin.userTenantId = new Integer(estudioDefault.id.toString())
			sabrinaoflin.save(flush:true)
			
			def userRoleSabrinaoflin = new UserRole()
			userRoleSabrinaoflin.user = sabrinaoflin
			userRoleSabrinaoflin.role = roleUser
			userRoleSabrinaoflin.save(flush:true)
			println "User sabrinaoflin@hotmail.com creado."
		}
		
		def samy = User.findByUsername('samy_cht@yahoo.com.ar')
		if(samy==null){
			samy = new User()
			samy.username = 'samy_cht@yahoo.com.ar'
			samy.password = 'samy2018'
			samy.accountExpired = false
			samy.accountLocked = false
			samy.enabled = true
			samy.passwordExpired = false
			samy.userTenantId = new Integer(estudioDefault.id.toString())
			samy.save(flush:true)
			
			def userRoleCvsamy = new UserRole()
			userRoleCvsamy.user = samy
			userRoleCvsamy.role = roleLectura
			userRoleCvsamy.save(flush:true)
			println "User samy_cht@yahoo.com.ar creado."
		}
		
		def karo = User.findByUsername('karo_2332@hotmail.com')
		if(karo==null){
			karo = new User()
			karo.username = 'karo_2332@hotmail.com'
			karo.password = 'karo2018'
			karo.accountExpired = false
			karo.accountLocked = false
			karo.enabled = true
			karo.passwordExpired = false
			karo.userTenantId = new Integer(estudioDefault.id.toString())
			karo.save(flush:true)
			
			def userRoleCvkaro = new UserRole()
			userRoleCvkaro.user = karo
			userRoleCvkaro.role = roleLectura
			userRoleCvkaro.save(flush:true)
			println "User karo_2332@hotmail.com creado."
		}
		
		def xavier = User.findByUsername('xavier.inochea@gmail.com')
		if(xavier==null){
			xavier = new User()
			xavier.username = 'xavier.inochea@gmail.com'
			xavier.password = 'xavier2018'
			xavier.accountExpired = false
			xavier.accountLocked = false
			xavier.enabled = true
			xavier.passwordExpired = false
			xavier.userTenantId = new Integer(estudioDefault.id.toString())
			xavier.save(flush:true)
			
			def userRoleCvxavier = new UserRole()
			userRoleCvxavier.user = xavier
			userRoleCvxavier.role = roleLectura
			userRoleCvxavier.save(flush:true)
			println "User xavier.inochea@gmail.com creado."
		}
		
		def camilaConte = User.findByUsername('contecamila7@gmail.com')
		if(camilaConte==null){
			camilaConte = new User()
			camilaConte.username = 'contecamila7@gmail.com'
			camilaConte.password = 'camila2018'
			camilaConte.accountExpired = false
			camilaConte.accountLocked = false
			camilaConte.enabled = true
			camilaConte.passwordExpired = false
			camilaConte.userTenantId = new Integer(estudioDefault.id.toString())
			camilaConte.save(flush:true)
			
			def userRoleCamilaConte = new UserRole()
			userRoleCamilaConte.user = camilaConte
			userRoleCamilaConte.role = roleAdmin
			userRoleCamilaConte.save(flush:true)
			println "User contecamila7@gmail.com creado."
		}
	}

	static def inicializarConceptos(){
		println "Verificando Conceptos de venta..."
		def producto = TipoConcepto.findByNombre("Producto")
		if (!producto){
			 producto = new TipoConcepto()
			producto.nombre="Producto"
			producto.save(flush:true)
			println "Concepto Producto creado."
		}
		def servicio = TipoConcepto.findByNombre("Servicio")
		if (!servicio){
			 servicio = new TipoConcepto()
			servicio.nombre="Servicio"
			servicio.save(flush:true)
			println "Concepto Servicio creado."
		}
		def mixto = TipoConcepto.findByNombre("Producto y Servicio")
		if (!mixto){
			 mixto = new TipoConcepto()
			mixto.nombre="Producto y Servicio"
			mixto.save(flush:true)
			println "Concepto Producto y Servicio creado."
		}
	}
	
	static def inicializarUnidadesMedida(){
		println "Verificando Unidades de medida..."
		UnidadMedida unidad
		unidad = UnidadMedida.findByNombre("kilogramos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="kilogramos"
			unidad.medidaAfipId=1
			unidad.save(flush:true)
			println "Medida kilogramos creado."
		}
		unidad = UnidadMedida.findByNombre("metros")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="metros"
			unidad.medidaAfipId=2
			unidad.save(flush:true)
			println "Medida metros creado."
		}
		unidad = UnidadMedida.findByNombre("metros cuadrados")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="metros cuadrados"
			unidad.medidaAfipId=3
			unidad.save(flush:true)
			println "Medida metros cuadrados creado."
		}
		unidad = UnidadMedida.findByNombre("metros cÃºbicos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="metros cÃºbicos"
			unidad.medidaAfipId=4
			unidad.save(flush:true)
			println "Medida metros cÃºbicos creado."
		}
		unidad = UnidadMedida.findByNombre("litros")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="litros"
			unidad.medidaAfipId=5
			unidad.save(flush:true)
			println "Medida litros creado."
		}
		unidad = UnidadMedida.findByNombre("1000 kWh")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="1000 kWh"
			unidad.medidaAfipId=6
			unidad.save(flush:true)
			println "Medida 1000 kWh creado."
		}
		unidad = UnidadMedida.findByNombre("unidades")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="unidades"
			unidad.medidaAfipId=7
			unidad.save(flush:true)
			println "Medida unidades creado."
		}
		unidad = UnidadMedida.findByNombre("pares")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="pares"
			unidad.medidaAfipId=8
			unidad.save(flush:true)
			println "Medida pares creado."
		}
		unidad = UnidadMedida.findByNombre("docenas")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="docenas"
			unidad.medidaAfipId=9
			unidad.save(flush:true)
			println "Medida pares creado."
		}
		unidad = UnidadMedida.findByNombre("quilates")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="quilates"
			unidad.medidaAfipId=10
			unidad.save(flush:true)
			println "Medida quilates creado."
		}
		unidad = UnidadMedida.findByNombre("millares")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="millares"
			unidad.medidaAfipId=11
			unidad.save(flush:true)
			println "Medida millares creado."
		}
		unidad = UnidadMedida.findByNombre("gramos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="gramos"
			unidad.medidaAfipId=14
			unidad.save(flush:true)
			println "Medida gramos creado."
		}
		unidad = UnidadMedida.findByNombre("milimetros")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="milimetros"
			unidad.medidaAfipId=15
			unidad.save(flush:true)
			println "Medida milimetros creado."
		}
		unidad = UnidadMedida.findByNombre("mm cÃºbicos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="mm cÃºbicos"
			unidad.medidaAfipId=16
			unidad.save(flush:true)
			println "Medida mm cÃºbicos creado."
		}
		unidad = UnidadMedida.findByNombre("kilÃ³metros")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="kilÃ³metros"
			unidad.medidaAfipId=17
			unidad.save(flush:true)
			println "Medida kilÃ³metros creado."
		}
		unidad = UnidadMedida.findByNombre("hectolitros")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="hectolitros"
			unidad.medidaAfipId=18
			unidad.save(flush:true)
			println "Medida hectolitros creado."
		}
		unidad = UnidadMedida.findByNombre("centÃ­metros")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="centÃ­metros"
			unidad.medidaAfipId=20
			unidad.save(flush:true)
			println "Medida centÃ­metros creado."
		}
		unidad = UnidadMedida.findByNombre("jgo. pqt. mazo naipes")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="jgo. pqt. mazo naipes"
			unidad.medidaAfipId=25
			unidad.save(flush:true)
			println "Medida jgo. pqt. mazo naipes creado."
		}
		unidad = UnidadMedida.findByNombre("cm cÃºbicos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="cm cÃºbicos"
			unidad.medidaAfipId=27
			unidad.save(flush:true)
			println "Medida cm cÃºbicos creado."
		}
		unidad = UnidadMedida.findByNombre("toneladas")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="toneladas"
			unidad.medidaAfipId=29
			unidad.save(flush:true)
			println "Medida toneladas creado."
		}
		unidad = UnidadMedida.findByNombre("dam cÃºbicos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="dam cÃºbicos"
			unidad.medidaAfipId=30
			unidad.save(flush:true)
			println "Medida dam cÃºbicos creado."
		}
		unidad = UnidadMedida.findByNombre("hm cÃºbicos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="hm cÃºbicos"
			unidad.medidaAfipId=31
			unidad.save(flush:true)
			println "Medida hm cÃºbicos creado."
		}
		unidad = UnidadMedida.findByNombre("km cÃºbicos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="km cÃºbicos"
			unidad.medidaAfipId=32
			unidad.save(flush:true)
			println "Medida km cÃºbicos creado."
		}
		unidad = UnidadMedida.findByNombre("microgramos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="microgramos"
			unidad.medidaAfipId=33
			unidad.save(flush:true)
			println "Medida microgramos creado."
		}
		unidad = UnidadMedida.findByNombre("nanogramos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="nanogramos"
			unidad.medidaAfipId=34
			unidad.save(flush:true)
			println "Medida nanogramos creado."
		}
		unidad = UnidadMedida.findByNombre("picogramos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="picogramos"
			unidad.medidaAfipId=35
			unidad.save(flush:true)
			println "Medida picogramos creado."
		}
		unidad = UnidadMedida.findByNombre("miligramos")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="miligramos"
			unidad.medidaAfipId=41
			unidad.save(flush:true)
			println "Medida miligramos creado."
		}
		unidad = UnidadMedida.findByNombre("mililitros")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="mililitros"
			unidad.medidaAfipId=47
			unidad.save(flush:true)
			println "Medida mililitros creado."
		}
		unidad = UnidadMedida.findByNombre("curie")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="curie"
			unidad.medidaAfipId=48
			unidad.save(flush:true)
			println "Medida curie creado."
		}
		unidad = UnidadMedida.findByNombre("milicurie")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="milicurie"
			unidad.medidaAfipId=49
			unidad.save(flush:true)
			println "Medida milicurie creado."
		}
		unidad = UnidadMedida.findByNombre("microcurie")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="microcurie"
			unidad.medidaAfipId=50
			unidad.save(flush:true)
			println "Medida microcurie creado."
		}
		unidad = UnidadMedida.findByNombre("uiacthor")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="uiacthor"
			unidad.medidaAfipId=51
			unidad.save(flush:true)
			println "Medida uiacthor creado."
		}
		unidad = UnidadMedida.findByNombre("muiacthor")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="muiacthor"
			unidad.medidaAfipId=52
			unidad.save(flush:true)
			println "Medida muiacthor creado."
		}
		unidad = UnidadMedida.findByNombre("kg base")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="kg base"
			unidad.medidaAfipId=53
			unidad.save(flush:true)
			println "Medida kg base creado."
		}
		unidad = UnidadMedida.findByNombre("gruesa")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="gruesa"
			unidad.medidaAfipId=54
			unidad.save(flush:true)
			println "Medida gruesa creado."
		}
		unidad = UnidadMedida.findByNombre("kg bruto")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="kg bruto"
			unidad.medidaAfipId=61
			unidad.save(flush:true)
			println "Medida kg bruto creado."
		}
		unidad = UnidadMedida.findByNombre("uiactant")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="uiactant"
			unidad.medidaAfipId=62
			unidad.save(flush:true)
			println "Medida uiactant creado."
		}
		unidad = UnidadMedida.findByNombre("muiactant")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="muiactant"
			unidad.medidaAfipId=63
			unidad.save(flush:true)
			println "Medida muiactant creado."
		}
		unidad = UnidadMedida.findByNombre("uiactig")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="uiactig"
			unidad.medidaAfipId=64
			unidad.save(flush:true)
			println "Medida uiactig creado."
		}
		unidad = UnidadMedida.findByNombre("muiactig")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="muiactig"
			unidad.medidaAfipId=65
			unidad.save(flush:true)
			println "Medida muiactig creado."
		}
		unidad = UnidadMedida.findByNombre("kg activo")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="kg activo"
			unidad.medidaAfipId=66
			unidad.save(flush:true)
			println "Medida kg activo creado."
		}
		unidad = UnidadMedida.findByNombre("gramo activo")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="gramo activo"
			unidad.medidaAfipId=67
			unidad.save(flush:true)
			println "Medida gramo activo creado."
		}
		unidad = UnidadMedida.findByNombre("gramo base")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="gramo base"
			unidad.medidaAfipId=68
			unidad.save(flush:true)
			println "Medida gramo base creado."
		}
		unidad = UnidadMedida.findByNombre("packs")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="packs"
			unidad.medidaAfipId=96
			unidad.save(flush:true)
			println "Medida packs creado."
		}
		unidad = UnidadMedida.findByNombre("otras unidades")
		if (!unidad){
			unidad = new UnidadMedida()
			unidad.nombre="otras unidades"
			unidad.medidaAfipId=98
			unidad.save(flush:true)
			println "Medida otras unidades creado."
		}
	}
	
	static def inicializarEstados(){
		println "Verificando estados..."
		
		['Activo','Inactivo','Borrado','Suspendido','Nuevo','Verificado','Sin verificar','Sin liquidar','Liquidado',
		 'Per/Ret ingresado','Sircreb/Ret ingresado','Nota ingresada','Liquidado A','Liquidado A2','Presentada',
		 'Autorizada','Importado','Error','Pagado','Expirado','En Banelco','En Link','Emitido','Automatico',
		 'Pendiente','Notificado','Abierto','Cerrado','Cancelado','Reembolsado','Rechazado'].each{
		 	if (! Estado.findByNombre(it)){
		 		new Estado(nombre:it).save(flush:true)
		 		println "    Estado $it creado"
		 	}
		 }
	}
	
	static def inicializarCondicionesIVA(){
		println "Verificando condiciones de IVA..."
		['Responsable inscripto','Monotributista','Sin inscribir','Exento'].each{
			if (! CondicionIva.findByNombre(it)){
				new CondicionIva(nombre: it).save(flush:true)
				println "....condicion $it creado."
			}
		}
	}
	
	static def inicializarZonas(){
		println "Verificando zonas..."
		
		def norte = Zona.findByNombre('Norte')
		if(norte==null){
			norte = new Zona()
			norte.nombre = 'Norte'
			norte.save(flush:true)
			println "Zona 'Norte' creado."
		}
		
		def sur = Zona.findByNombre('Sur')
		if(sur==null){
			sur = new Zona()
			sur.nombre = 'Sur'
			sur.save(flush:true)
			println "Zona 'Sur' creado."
		}
	}
	
	static def inicializarCondicionesRegimenesIIBB(){
		println "Verificando regimenes de IIBB..."

		['Convenio Multilateral', 'Sicol', 'Simplificado', 'B.A. Mensual', 'Sin inscribir', 'Unificado', 'Provincial'].each{
			if (!RegimenIibb.findByNombre(it)){
				new RegimenIibb(nombre: it).save(flush:true)
				println "IIBB '$it' creado."
			}
		}
	}
	
	static def inicializarProvincias(){
		println "Verificando provincias..."
		
		def caba = Provincia.findByNombre('CABA')
		if(caba==null){
			caba = new Provincia()
			caba.nombre= 'CABA'
			caba.save(flush:true)
			println "CABA creado."
		}
		
		def buenosAires = Provincia.findByNombre('Buenos Aires')
		if(buenosAires==null){
			buenosAires = new Provincia()
			buenosAires.nombre= 'Buenos Aires'
			buenosAires.save(flush:true)
			println "Buenos Aires creado."
		}
	}
	
	static def inicializarLocalidades(){
		if(Localidad.count()==0){
			println "Verificando localidades..."
			
			def caba = Provincia.findByNombre('CABA')
			if(caba!=null){
				def cabaLocalidad = Localidad.findByProvinciaAndNombre(caba, 'CABA') 
				if(cabaLocalidad == null){
					cabaLocalidad = new Localidad()
					cabaLocalidad.nombre= 'CABA'
					caba.addToLocalidades(cabaLocalidad)
					caba.save(flush:true)
					println "Localidad CABA creado."
				}
			}
			
			def buenosAires = Provincia.findByNombre('Buenos Aires')
			if(buenosAires!=null){
				def bsAsLocalidades = [
					'Martinez', 
					'JosÃ© C. Paz', 
					'Hurlingham',
					'Villa Ballester',
					'San MartÃ­n',
					'Chacabuco',
					'Ramos MejÃ­a',
					'Ituzaingo',
					'San AndrÃ©s',
					'Caseros',
					'San Miguel',
					'Billinghurst',
					'Lomas De Zamora',
					'El Talar',
					'SÃ¡enz PeÃ±a',
					'Villa Chacabuco',
					'Pacheco',
					'Loma Hermosa',
					'Villa Lynch',
					'Castelar',
					'Del Viso',
					'Burzaco',
					'Villa Hermosa',
					'Santos Lugares',
					'Quilmes',
					'Villa Elisa, La Plata',
					'Florida',
					'Polvorines',
					'Merlo',
					'La Lucila',
					'Campana',
					'Pilar',
					'Ciudadela',
					'JosÃ© L. SuÃ¡rez',
					'Pablo PodestÃ¡',
					'Palomar',
					'MartÃ­n Coronado',
					'Villa Bosch',
					'Paso Del Rey',
					'Libertad (merlo)',
					'LanÃºs',
					'Olivos',
					'Avellaneda',
					'Banfield',
					'Pablo Nogues',
					'Monte Grande',
					'Moreno',
					'Tigre',
					'Luis GuillÃ³n',
					'Ezpeleta',
					'San Justo',
					'Villa Adelina',
					'Tablada',
					'San Francisco Solano',
					'Bernal',
					'Claypole',
					'Quilmes Oeste',
					'Villa Raffo',
					'ValentÃ­n Alsina',
					'Libertad',
					'Longchamps',
					'Tortuguitas',
					'Aldo Bonzi',
					'Maquinista Savio',
					'Villa Martelli',
					'Villa Libertad',
					'Azul',
					'Ayacucho',
					'OlavarrÃ­a',
					'Rafael Castillo',
					'LujÃ¡n',
					'GonzÃ¡lez CatÃ¡n',
					'Isidro Casanova',
					'Remedios De Escalada',
					'El Palomar',
					'Lomas Del Mirador',
					'MorÃ³n',
					'Vicente LÃ³pez',
					'TropezÃ³n',
					'San Fernando',
					'Entre RÃ­os',
					'Lavallol',
					'Ezeiza',
					'Sourdeaux',
					'Gregorio Laferrere',
					'Grand Bourd',
					'Boulogne',
					'Villa Gesell',
					'Villa Tessei',
					'General Alvear',
					'Balcarce',
					'Malvinas Argentinas']
				
				bsAsLocalidades.each{
					byte[] byteText = it.getBytes(Charset.forName("UTF-8"))
					String originalString= new String(it);
					
					def localidad = Localidad.findByProvinciaAndNombre(buenosAires, originalString)
					if(localidad==null){
						localidad = new Localidad()
						localidad.nombre = originalString
						buenosAires.addToLocalidades(localidad)
						buenosAires.save(fulsh:true)
						println "Localidad " + originalString + " creado."
					}
				}
			}
		}
	}

	static def inicializarContadores(){
		println "Verificando contadores..."
		Contador pavoni = Contador.findByCuit("20188404112")
		if(!pavoni){
			pavoni = new Contador()
			pavoni.cuit = "20188404112"
			pavoni.nombreApellido = "Ernesto Pavoni"
			pavoni.matricula = "?"
			pavoni.email = "epavoni2000@gmail.com"
			pavoni.foto = "ernesto_pavoni.jpg"
			pavoni.whatsapp = "5491162230855"
			pavoni.save(flush:true, failOnError:true)
			println "Contador Pavoni creado."
		}

		Contador alejandro = Contador.findByCuit("23445966169")
		if(!alejandro){
			alejandro = new Contador()
			alejandro.cuit = "23445966169"
			alejandro.nombreApellido = "Alejandro Pavoni"
			alejandro.matricula = "?"
			alejandro.email = "alejandro@calim.com.ar"
			alejandro.foto = ""
			alejandro.whatsapp = "5491151093337"
			alejandro.save(flush:true,failOnError:true)
			println "Contador Pavoni Chiquito creada."
		}
	}

	static def inicializarApps(){
		println "Verificando Apps..."
		App appRappi = App.findByNombre("Rappi")
		Persona persona = Persona.findByCuit("30715803891")
		if(!persona){
			persona = new Persona()
			persona.razonSocial = "RAPPI ARG S.A.S"
			persona.cuit = "30715803891"
			persona.domicilio = "Castillo 1220, CABA"
			persona.tipoDocumento = "CUIT"
			persona.save(flush:true, failOnError:true)
		}
		if(!appRappi){
			appRappi = new App()
			appRappi.nombre = "Rappi"
			appRappi.logo = "logo-rappi-calim.png"
			appRappi.persona = persona
			appRappi.save(flush:true, failOnError:true)
			println "App Rappi creada."
		}else{
			if(!appRappi.persona){
				appRappi.persona = persona	
				appRappi.save(flush:true, failOnError:true)
			}
		}

		App appPedidosYa = App.findByNombre("PedidosYa")
		persona = Persona.findByCuit("33715667369")
		if(!persona){
			persona = new Persona()
			persona.razonSocial = "RepartosYa S.A."
			persona.cuit = "33715667369"
			persona.tipoDocumento = "CUIT"
			persona.save(flush:true, failOnError:true)
		}
		if(!appPedidosYa){
			appPedidosYa = new App()
			appPedidosYa.nombre = "PedidosYa"
			appPedidosYa.persona = persona
			appPedidosYa.logo = "logo-pedidosya-calim.png"
			appPedidosYa.save(flush:true, failOnError:true)
			println "App PedidosYa creada."
		}else{
			if(!appPedidosYa.persona){
				appPedidosYa.persona = persona
				appPedidosYa.save(flush:true, failOnError:true)
			}
		}

		App appUber = App.findByNombre("Uber")
		persona = Persona.findByCuit("30715462245")
		if(!persona){
			persona = new Persona()
			persona.razonSocial = "UBER ARGENTINA S.R.L"
			persona.cuit = "30715462245"
			persona.tipoDocumento = "CUIT"
			persona.save(flush:true, failOnError:true)
		}
		if(!appUber){
			appUber = new App()
			appUber.nombre = "Uber"
			appUber.persona = persona
			appUber.logo = "logo-uber-calim.png"
			appUber.save(flush:true, failOnError:true)
			println "App Uber creada."
		}
		else{
			if(!appUber.persona){
				appUber.persona = persona
				appUber.save(flush:true, failOnError:true)
			}
		}

		App appOtro = App.findByNombre("Otro")
		persona = Persona.findByCuit("0")
		if(!persona){
			persona = new Persona()
			persona.razonSocial = "Otro"
			persona.cuit = "0"
			persona.tipoDocumento = "CUIT"
			persona.save(flush:true, failOnError:true)
		}
		if(!appOtro){
			appOtro = new App()
			appOtro.nombre = "Otro"
			appOtro.persona = persona
			appOtro.logo = "logo-otro-calim.png"
			appOtro.save(flush:true, failOnError:true)
			println "App Otro creada."
		}else{
			if(!appOtro.persona){
				appOtro.persona = persona
				appOtro.save(flush:true, failOnError:true)
			}
		}
	}

	static def inicializarPlantillasNotificaciones(){/*
		
		println "Verificando Plantillas..."

		NotificacionTemplate emailRegistro = NotificacionTemplate.findByNombre("Email Registro")
		if(!emailRegistro){
			emailRegistro = new NotificacionTemplate()
			emailRegistro.nombre = "Email Registro"
			emailRegistro.asuntoEmail = 'Confirma tu email en CALIM'
			emailRegistro.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; "><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; text-align: center; padding-top: 50px; color:#2190a1;">¡Ya casi!</div><div style="font-size:23px; text-align: center; padding: 20px 20px 0px 20px; color:#666;">Estás a sólo un paso de registrarte.</div><div style="font-size:18px; text-align: center; padding-top: 40px; color:#666;">Hacé click acá para confirmar tu cuenta:</div><div style="text-align: center; padding-top:40px;"><a href="{0}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">CONFIRMÁ TU CUENTA</a></div><div style="padding: 30px; margin-top: 70px; background-color: #eee; font-size: 14px; color: #666; text-align: center; line-height: 24px">Si no podés acceder, copiá el siguiente link en tu navegador:<br/><a href="{0}" style="text-decoration: none; font-size: 16px; color: #2190a1;">{0}</a></div><div style="font-size:22px; text-align: center; padding-top: 40px; color:#2190a1;">Gracias por elegir Calim.</div><ul style="text-align: center; padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; text-align: center; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{1}">acá</a>.<br/><br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailRegistro.tituloApp = "Confirma tu cuenta en CALIM"
			emailRegistro.textoApp = "Revisa tu casilla de email"
			emailRegistro.save(flush:true, failOnError:true)
			println "Plantilla email registro creada"
		}

		NotificacionTemplate emailRegistroManual = NotificacionTemplate.findByNombre("Email Registro Manual")
		if(!emailRegistroManual){
			emailRegistroManual = new NotificacionTemplate()
			emailRegistroManual.nombre = "Email Registro Manual"
			emailRegistroManual.asuntoEmail = "¡Bienvenido!, ya tenés usuario en CALIM"
			emailRegistroManual.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; "><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; text-align: center; padding-top: 50px; color:#2190a1;">¡Ya tenés cuenta en Calim!</div><div style="text-align: center; padding-top:40px;"><a href="{0}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">ACTIVALA AHORA</a></div><div style="padding: 30px; margin-top: 70px; background-color: #eee; font-size: 14px; color: #666; text-align: center; line-height: 24px">Si no podés acceder, copiá el siguiente link en tu navegador:<br/><a href="{0}" style="text-decoration: none; font-size: 16px; color: #2190a1;">{0}</a></div><div style="font-size:22px; text-align: center; padding-top: 40px; color:#2190a1;">Gracias por elegir Calim.</div><ul style="text-align: center; padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; text-align: center; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{1}">acá</a>.<br/><br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailRegistroManual.tituloApp = "Bienvenido! Ya tenes usuario en CALIM"
			emailRegistroManual.textoApp = ""
			emailRegistroManual.save(flush:true, failOnError:true)
			println "Plantilla email registro manual creada"
		}

		NotificacionTemplate emailBienvenido = NotificacionTemplate.findByNombre("Email Bienvenido")
		if(!emailBienvenido){
			emailBienvenido = new NotificacionTemplate()
			emailBienvenido.nombre = "Email Bienvenido"
			emailBienvenido.asuntoEmail = "¡Bienvenido! te presentamos a tu contador Calim"
			emailBienvenido.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">¡Felicitaciones {0},<br/>ya tenés Calim!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;">Ya estás listo para comenzar a disfrutar de los beneficios</div><div style="font-size:18px; padding-top: 40px; color:#666;">Te presentamos a tu contador designado:</div><div style="margin: auto; border-radius: 100px; overflow: hidden; width: 190px; height: 190px;margin-top: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/Ernesto-Pavoni-Contador-Calim.jpg"/></div><div style="font-size: 22px; margin-top: 15px; font-weight: bold; color: #2190a1;">Cdor. Ernesto Pavoni</div><div style="font-size:18px; color:#666;">CUIT: 20-18840411-2<br/></div><div style="font-size:18px; color:#666;">WhatsApp: 11 6223-0855<br/></div><div style="font-size:16px; padding: 20px 40px 0px 40px; color:#666;">Matrícula:<br/>CABA: Tomo 359, Folio10<br/>Buenos Aires: Tomo 144, Folio 95, Legajo: 37325/7<br/><br/>Nuestros contadores Calim son profesionales con gran experiencia que simplificarán el cumplimiento de tus impuestos y te ayudarán a resolver todas tus dudas.</div><div style="padding-top:60px;"><a href="https://app.calim.com.ar" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">INGRESÁ A CALIM</a></div><div style="padding: 40px 60px; margin-top: 70px; background-color: #eee; font-size: 14px; color: #666; line-height: 24px; text-align: left;"><span style="font-size: 18px; font-weight: bold;">¿Cómo sigue tu experiencia Calim?</span><br/><br/>1) Deberás delegarnos permisos con tu CUIT para que podamos calcular tus impuestos. Te explicaremos cómo hacerlo en unos sencillos pasos.<br/><br/><a href="https://www.youtube.com/watch?v=2vsAR3JHzHE" style="text-decoration: none; padding: 10px 15px; color:#fff; font-weight: bold; font-size: 12px; background-color: #c1d549; border-radius: 50px;">Video tutorial</a><br/><br/>2) Utilizando la información de tus comprobantes, calcularemos tus impuestos y te avisaremos cuando todo esté listo.<br/><br/>3) Pagá con el botón de pago y listo, ¡ya estás al día!</div><div style="font-size:22px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{1}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailBienvenido.tituloApp = null
			emailBienvenido.textoApp = null
			emailBienvenido.save(flush:true, failOnError:true)
			println "Plantilla email bienvenido creada"
		}

		NotificacionTemplate emailForgotPassword = NotificacionTemplate.findByNombre("Email ForgotPassword")
		if(!emailForgotPassword){
			emailForgotPassword = new NotificacionTemplate()
			emailForgotPassword.nombre = "Email ForgotPassword"
			emailForgotPassword.asuntoEmail = "Recupero de contraseña en Calim"
			emailForgotPassword.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; "><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:23px; text-align: center; padding: 20px 20px 0px 20px; color:#666;">Pediste la recuperación de tu clave en CALIM.</div><div style="font-size:18px; text-align: center; padding-top: 40px; color:#666;">Para cambiar la clave hacé click en el siguiente botón:</div><div style="text-align: center; padding-top:40px;"><a href="{0}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">RECUPERAR CLAVE</a></div><div style="font-size:18px; text-align: center; padding-top: 40px; color:#666;">En caso que no hayas sido vos, simplemente ignorá este email.</div><div style="padding: 30px; margin-top: 70px; background-color: #eee; font-size: 14px; color: #666; text-align: center; line-height: 24px">Si no podés acceder, copiá el siguiente link en tu navegador:<br/><a href="{0}" style="text-decoration: none; font-size: 16px; color: #2190a1;">{0}</a></div><div style="font-size:22px; text-align: center; padding-top: 40px; color:#2190a1;">Gracias por elegir Calim.</div><ul style="text-align: center; padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; text-align: center; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{1}">acá</a>.<br/><br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailForgotPassword.tituloApp = null
			emailForgotPassword.textoApp = null
			emailForgotPassword.save(flush:true, failOnError:true)
			println "Plantilla email forgot password creada"
		}

		NotificacionTemplate emailNosComunicaremosConVos = NotificacionTemplate.findByNombre("Nos Comunicaremos Con Vos")
		if(!emailNosComunicaremosConVos){
			emailNosComunicaremosConVos = new NotificacionTemplate()
			emailNosComunicaremosConVos.nombre = "Nos Comunicaremos Con Vos"
			emailNosComunicaremosConVos.asuntoEmail = "¡Nos vamos a comunicar con vos!"
			emailNosComunicaremosConVos.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">¡Hola {0}!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>En las próximas 48 hs vamos a llamarte por teléfono</strong><br/>para comentarte cuáles son los pasos a seguir y resolver las dudas que tengas.</div><div style="font-size:18px; padding-top: 40px; color:#666;">Estamos trabajando con los datos que nos aportaste para diseñar tu perfil impositvo y brindarte el mejor servicio.</div><div style="padding-top:60px;"><a href="https://app.calim.com.ar" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">INGRESÁ A CALIM</a></div><div style="padding: 40px 60px; margin-top: 70px; background-color: #eee; font-size: 14px; color: #666; line-height: 24px; text-align: left;"><span style="font-size: 18px; font-weight: bold;">¿Querés adelantar pasos?</span><br/><br/>Seguí los tutoriales para delegarnos los permisos así podemos liquidar tus impuestos.<br/><br/><a href="https://www.youtube.com/watch?v=2vsAR3JHzHE" style="text-decoration: none; padding: 10px 15px; color:#fff; font-weight: bold; font-size: 12px; background-color: #c1d549; border-radius: 50px;">Video tutorial</a></div><div style="font-size:22px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{1}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailNosComunicaremosConVos.tituloApp = "Nos vamos a comunicar con vos!"
			emailNosComunicaremosConVos.textoApp = "Lo estaremos haciendo a la brevedad"
			emailNosComunicaremosConVos.save(flush:true, failOnError:true)
			println "Plantilla email nos comunicaremos creada"
		}

		NotificacionTemplate emailLiqIvaEIibbLista = NotificacionTemplate.findByNombre("Liquidacion Lista IVA e IIBB")
		if(!emailLiqIvaEIibbLista){
			emailLiqIvaEIibbLista = new NotificacionTemplate()
			emailLiqIvaEIibbLista.nombre = "Liquidacion Lista IVA e IIBB"
			emailLiqIvaEIibbLista.asuntoEmail = "¡Tus impuestos ya están listos, autorizanos a presentarlos!"
			emailLiqIvaEIibbLista.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">{0}<br/>¡Ya liquidamos tus impuestos!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>Autorizanos a presentarlos</strong></div><div style="font-size:18px; padding-top: 40px; color:#666;">IVA: <strong>{1}</strong><br/>Vencimiento: <strong>{2}</strong><br/><br/>INGRESOS BRUTOS: <strong>{3}</strong><br/>Vencimiento: <strong>{4}</strong></div><div style="padding-top:60px;"><a href="https://app.calim.com.ar" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">AUTORIZAR</a></div><div style="padding: 40px 60px; margin-top: 70px; background-color: #eee; font-size: 20px; color: #666; line-height: 24px; text-align: center;"><span style="font-size: 23px; font-weight: bold;">¡Evitá multas!</span><br/><br/>Autorizá la presentación antes de la fecha de vencimiento</div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{5}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailLiqIvaEIibbLista.tituloApp = "Tus impuestos ya están listos!"
			emailLiqIvaEIibbLista.textoApp = "Autorizanos a presentarlos"
			emailLiqIvaEIibbLista.save(flush:true, failOnError:true)
			println "Plantilla email liquidaciones listas creada"
		}

		NotificacionTemplate emailLiqIvaLista = NotificacionTemplate.findByNombre("Liquidacion Lista IVA")
		if(!emailLiqIvaLista){
			emailLiqIvaLista = new NotificacionTemplate()
			emailLiqIvaLista.nombre = "Liquidacion Lista IVA"
			emailLiqIvaLista.asuntoEmail = "¡Tus impuestos ya están listos, autorizanos a presentarlos!"
			emailLiqIvaLista.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">{0}<br/>¡Ya liquidamos tus impuestos!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>Autorizanos a presentarlos</strong></div><div style="font-size:18px; padding-top: 40px; color:#666;">IVA: <strong>{1}</strong><br/>Vencimiento: <strong>{2}</strong><div style="padding-top:60px;"><a href="https://app.calim.com.ar" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">AUTORIZAR</a></div><div style="padding: 40px 60px; margin-top: 70px; background-color: #eee; font-size: 20px; color: #666; line-height: 24px; text-align: center;"><span style="font-size: 23px; font-weight: bold;">¡Evitá multas!</span><br/><br/>Autorizá la presentación antes de la fecha de vencimiento</div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{3}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailLiqIvaLista.tituloApp = "Liquidación Disponible"
			emailLiqIvaLista.textoApp = "Solo falta tu autorización para presentarla"
			emailLiqIvaLista.save(flush:true, failOnError:true)
			println "Plantilla email liquidacion iva creada"
		}

		NotificacionTemplate emailLiqIibbLista = NotificacionTemplate.findByNombre("Liquidacion Lista IIBB")
		if(!emailLiqIibbLista){
			emailLiqIibbLista = new NotificacionTemplate()
			emailLiqIibbLista.nombre = "Liquidacion Lista IIBB"
			emailLiqIibbLista.asuntoEmail = "¡Tus impuestos ya están listos, autorizanos a presentarlos!"
			emailLiqIibbLista.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">{0}<br/>¡Ya liquidamos tus impuestos!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>Autorizanos a presentarlos</strong></div><div style="font-size:18px; padding-top: 40px; color:#666;">INGRESOS BRUTOS: <strong>{1}</strong><br/>Vencimiento: <strong>{2}</strong></div><div style="padding-top:60px;"><a href="{3}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">AUTORIZAR</a></div><div style="padding: 40px 60px; margin-top: 70px; background-color: #eee; font-size: 20px; color: #666; line-height: 24px; text-align: center;"><span style="font-size: 23px; font-weight: bold;">¡Evitá multas!</span><br/><br/>Autorizá la presentación antes de la fecha de vencimiento</div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{4}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailLiqIibbLista.tituloApp = "Liquidacion Disponible"
			emailLiqIibbLista.textoApp = "Solo falta tu autorización para presentarla"
			emailLiqIibbLista.save(flush:true, failOnError:true)
			println "Plantilla email liquidacion iibb creada"
		}

		NotificacionTemplate emailPagarLiquidaciones = NotificacionTemplate.findByNombre("Pagar Liquidacion IVA e IIBB")
		if(!emailPagarLiquidaciones){
			emailPagarLiquidaciones = new NotificacionTemplate()
			emailPagarLiquidaciones.nombre = "Pagar Liquidacion IVA e IIBB"
			emailPagarLiquidaciones.asuntoEmail = "¡Ya podés pagar tus impuestos!"
			emailPagarLiquidaciones.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">¡Hola {0}!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>¡Usá este botón de pago y elegí el método que más te convenga!</strong></div>{1}<div style="padding-top:60px;"><a href="{2}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">PAGAR</a></div><div style="padding: 40px 60px; margin-top: 70px; background-color: #eee; font-size: 20px; color: #666; line-height: 24px; text-align: center;"><span style="font-size: 23px; font-weight: bold;">¡Evitá intereses!</span><br/><br/>Pagá antes de la fecha de vencimiento</div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{3}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailPagarLiquidaciones.tituloApp = "¡Ya podés pagar tus impuestos!"
			emailPagarLiquidaciones.textoApp = ""
			emailPagarLiquidaciones.save(flush:true, failOnError:true)
			println "Plantilla email pagar liquidaciones creada"
		}

		NotificacionTemplate emailFacturaCuenta = NotificacionTemplate.findByNombre("Factura Cuenta")
		if(!emailFacturaCuenta){
			emailFacturaCuenta = new NotificacionTemplate()
			emailFacturaCuenta.nombre = "Factura Cuenta"
			emailFacturaCuenta.asuntoEmail = "¡Ya podés pagar tu servicio Calim!"
			emailFacturaCuenta.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">¡Hola {0}!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>¡Usá este botón de pago y elegí el método que más te convenga!</strong></div><div style="font-size:18px; padding-top: 40px; color:#666;">Importe del servicio: <strong>{1}</strong></div><div style="padding-top:60px;"><a href="{2}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">PAGAR</a></div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{3}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailFacturaCuenta.tituloApp = "¡Ya podés pagar tu servicio Calim!"
			emailFacturaCuenta.textoApp = "Revisá tu casilla de email"
			emailFacturaCuenta.save(flush:true, failOnError:true)
			println "Plantilla email factura cuenta creada"
		}

		NotificacionTemplate emailInstruccionesClaveFiscal = NotificacionTemplate.findByNombre("Instrucciones Clave Fiscal")
		if(!emailInstruccionesClaveFiscal){
			emailInstruccionesClaveFiscal = new NotificacionTemplate()
			emailInstruccionesClaveFiscal.nombre = "Instrucciones Clave Fiscal"
			emailInstruccionesClaveFiscal.asuntoEmail = "Instrucciones Calim para obtener Clave Fiscal"
			emailInstruccionesClaveFiscal.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif;"><div style="padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="padding: 40px 30px 0px 30px;"><div style="font-size:30px; color:#2190a1; margin-bottom: 20px;">Hola {0}</div><div style="font-size:16px; color:#666;">Para inscribirte en Monotributo, es necesario que tengas Clave Fiscal de AFIP. Podés obtenerla desde tu celular. Aquí te explicamos, paso a paso, cómo hacerlo:<br/><br/>Importante: es requisito contar con DNI argentino formato tarjeta, un celular que posea cámara frontal, y un fondo blanco para tomarte una foto.<br/><br/><span style="font-weight: bold; color: #c1d549; font-size: 18px;">Podés seguir este video tutorial, o los pasos que te dejamos a continuación:</span></div></div><div style="padding: 30px 30px 20px 30px; margin-top: 30px; background-color: #eee;"><iframe width="100%" height="360" src="https://www.youtube.com/embed/dTa1EGkRlsc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe><ol style="margin-top: 30px; font-weight: normal; color:#666; line-height: 22px;"><li>Descargá la app Mi AFIP en tu celular.</li><li>Abrí la app y hace click en ‘Solicitar o recuperar tu Clave Fiscal a través del reconocimiento facial’.</li><li>Clickeá en “Continuar” y autorizá el acceso a tu cámara.</li><li>Escaneá el código de barra de tu DNI, y luego escribí la serie de letras y números que te aparecerá en pantalla.</li><li>Repetí los movimientos faciales que te pida la app (paciencia, puede que tardes varios intentos hasta que lo tome). De lo contrario, intentá desde otro celular y asegurate de tener un fondo blanco atrás.</li><li>Ingresá la Clave Fiscal que desees, con los requerimientos que pide la App (una mayúscula, 10 caracteres y 2 números). Te recomendamos que anotes esta contraseña en algún lugar.</li></ol></div><div style="padding: 30px; font-size:16px; color:#666; text-align: center;"><div style="font-size:35px; color:#2190a1; margin-bottom: 10px;">¡Felicitaciones!</div>Ahora podés ingresar a Calim para que continuemos con tu inscripción.<div style="padding-top:40px;"><a href="https://app.calim.com.ar" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">INGRESAR ACÁ</a></div></div><div style="padding: 30px 20px 0px 30px; font-size:16px; color:#666;">Si no pudiste sacar tu Clave Fiscal por algún error en la App, te sugerimos que intentes de nuevo desde otro celular. Asegurate de tomar las fotos sobre un fondo blanco.<br/><br/>Si aún no funciona, tendrás que ir presencialmente a una agencia de AFIP.<br/>Te explicamos <a href="https://calim.com.ar/como-sacar-cuit-clave-fiscal/" style="color:#2190a1;">cómo hacerlo acá</a>.</div><div style="text-align: center;"><div style="font-size:22px; padding-top: 40px; color:#2190a1;">Gracias por elegir Calim.</div><ul style="padding: 0px; margin-right: 0px; margin-left: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{1}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></div></body></html>'
			emailInstruccionesClaveFiscal.tituloApp = "Instrucciones para Clave Fiscal"
			emailInstruccionesClaveFiscal.textoApp = "Revisá tu casilla de email"
			emailInstruccionesClaveFiscal.save(flush:true, failOnError:true)
			println "Plantilla email instrucciones clave fiscal creada"
		}

		NotificacionTemplate emailInstruccionesClaveFiscalApp = NotificacionTemplate.findByNombre("Instrucciones Clave Fiscal Trabajador App")
		if(!emailInstruccionesClaveFiscalApp){
			emailInstruccionesClaveFiscalApp = new NotificacionTemplate()
			emailInstruccionesClaveFiscalApp.nombre = "Instrucciones Clave Fiscal Trabajador App"
			emailInstruccionesClaveFiscalApp.asuntoEmail = "Instrucciones Calim para obtener Clave Fiscal"
			emailInstruccionesClaveFiscalApp.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif;"><div style="padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2020/04/foto-mail-calim-delivery.jpg" style="width: 100%;"></div><div style="padding: 40px 30px 0px 30px;"><div style="font-size:30px; color:#2190a1; margin-bottom: 20px;">Hola {0}</div><div style="font-size:16px; color:#666;">Para inscribirte en Monotributo, es necesario que tengas Clave Fiscal de AFIP. Podés obtenerla desde tu celular. Aquí te explicamos, paso a paso, cómo hacerlo:<br/><br/>Importante: es requisito contar con DNI argentino formato tarjeta, un celular que posea cámara frontal, y un fondo blanco para tomarte una foto.<br/><br/><span style="font-weight: bold; color: #c1d549; font-size: 18px;">Podés seguir este video tutorial, o los pasos que te dejamos a continuación:</span></div></div><div style="padding: 30px 30px 20px 30px; margin-top: 30px; background-color: #eee;"><iframe width="100%" height="360" src="https://www.youtube.com/embed/dTa1EGkRlsc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe><ol style="margin-top: 30px; font-weight: normal; color:#666; line-height: 22px;"><li>Descargá la app Mi AFIP en tu celular.</li><li>Abrí la app y hace click en ‘Solicitar o recuperar tu Clave Fiscal a través del reconocimiento facial’.</li><li>Clickeá en “Continuar” y autorizá el acceso a tu cámara.</li><li>Escaneá el código de barra de tu DNI, y luego escribí la serie de letras y números que te aparecerá en pantalla.</li><li>Repetí los movimientos faciales que te pida la app (paciencia, puede que tardes varios intentos hasta que lo tome). De lo contrario, intentá desde otro celular y asegurate de tener un fondo blanco atrás.</li><li>Ingresá la Clave Fiscal que desees, con los requerimientos que pide la App (una mayúscula, 10 caracteres y 2 números). Te recomendamos que anotes esta contraseña en algún lugar.</li></ol></div><div style="padding: 30px; font-size:16px; color:#666; text-align: center;"><div style="font-size:35px; color:#2190a1; margin-bottom: 10px;">¡Felicitaciones!</div>Ahora podés ingresar a Calim para que continuemos con tu inscripción.<div style="padding-top:40px;"><a href="https://app.calim.com.ar" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">INGRESAR ACÁ</a></div></div><div style="padding: 30px 20px 0px 30px; font-size:16px; color:#666;">Si no pudiste sacar tu Clave Fiscal por algún error en la App, te sugerimos que intentes de nuevo desde otro celular. Asegurate de tomar las fotos sobre un fondo blanco.<br/><br/>Si aún no funciona, tendrás que ir presencialmente a una agencia de AFIP.<br/>Te explicamos <a href="https://calim.com.ar/como-sacar-cuit-clave-fiscal/" style="color:#2190a1;">cómo hacerlo acá</a>.</div><div style="text-align: center;"><div style="font-size:22px; padding-top: 40px; color:#2190a1;">Gracias por elegir Calim.</div><ul style="padding: 0px; margin-right: 0px; margin-left: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{1}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></div></body></html>'
			emailInstruccionesClaveFiscalApp.tituloApp = "Instrucciones para Clave Fiscal"
			emailInstruccionesClaveFiscalApp.textoApp = "Revisá tu casilla de email"
			emailInstruccionesClaveFiscalApp.save(flush:true, failOnError:true)
			println "Plantilla email instrucciones clave fiscal app creada"
		}

		NotificacionTemplate emailAvisoVolanteMonotributoSimplificado = NotificacionTemplate.findByNombre("Aviso Volante Monotributo Simplificado")
		if(!emailAvisoVolanteMonotributoSimplificado){
			emailAvisoVolanteMonotributoSimplificado = new NotificacionTemplate()
			emailAvisoVolanteMonotributoSimplificado.nombre = "Aviso Volante Monotributo Simplificado"
			emailAvisoVolanteMonotributoSimplificado.asuntoEmail = "¡Tu volante de pago ya está disponible!"
			emailAvisoVolanteMonotributoSimplificado.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:38px; padding-top: 50px; color:#2190a1;">¡Hola {0}!</div><div style="font-size:18px; padding: 20px 20px 0px 20px; color:#666;"><strong>¡Ya podés descargar el volante de pago para tu Monotributo Simplificado! <br><br> Para descargarlo, ingresá a nuestro sitio con tu cuenta Calim <br><br></strong></div><div style="font-size:28px; padding: 20px 20px 0px 20px; color:#666;"><strong> Vencimiento: {1} </strong></div><div style="padding-top:60px;"><a href="https://app.calim.com.ar" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">INGRESAR</a></div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailAvisoVolanteMonotributoSimplificado.tituloApp = "¡Tu volante de pago ya está disponible!"
			emailAvisoVolanteMonotributoSimplificado.textoApp = "Descargalo desde la app"
			emailAvisoVolanteMonotributoSimplificado.save(flush:true, failOnError:true)
			println "Plantilla email iAviso Volante Monotributo Simplificado"
		}

		NotificacionTemplate emailFacturaCuentaAviso1 = NotificacionTemplate.findByNombre("Factura Cuenta Aviso 1")
		if(!emailFacturaCuentaAviso1){
			emailFacturaCuentaAviso1 = new NotificacionTemplate()
			emailFacturaCuentaAviso1.nombre = "Factura Cuenta Aviso 1"
			emailFacturaCuentaAviso1.asuntoEmail = "{0}, recordá que ya está lista tu cuota mensual de Calim"
			emailFacturaCuentaAviso1.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">¡Hola {0}!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>¡No olvides pagar tu cuota Calim de {1} para seguir disfrutando del servicio!</strong></div><div style="font-size:18px; padding-top: 40px; color:#666;">Importe: <strong>{2}</strong></div><div style="padding-top:60px;"><a href="{3}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">PAGAR AHORA</a></div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{4}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailFacturaCuentaAviso1.tituloApp = "Recordá pagar tu Cuota Mensual"
			emailFacturaCuentaAviso1.textoApp = "Revisá tu casilla de email"
			emailFacturaCuentaAviso1.save(flush:true, failOnError:true)
			println "Plantilla email aviso1 factura creada"
		}

		NotificacionTemplate emailFacturaCuentaAviso2 = NotificacionTemplate.findByNombre("Factura Cuenta Aviso 2")
		if(!emailFacturaCuentaAviso2){
			emailFacturaCuentaAviso2 = new NotificacionTemplate()
			emailFacturaCuentaAviso2.nombre = "Factura Cuenta Aviso 2"
			emailFacturaCuentaAviso2.asuntoEmail = "{0}, ¡No te olvides de tu cuota Calim de {1}!"
			emailFacturaCuentaAviso2.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">¡Hola {0}!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>¡Recordá que debés pagar tu cuota de {1} para seguir disfrutando del servicio!</strong></div><div style="font-size:18px; padding-top: 40px; color:#666;">Importe: <strong>{2}</strong></div><div style="padding-top:60px;"><a href="{3}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">PAGAR AHORA</a></div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{4}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailFacturaCuentaAviso2.tituloApp = "No olvides pagar tu Cuota Mensual"
			emailFacturaCuentaAviso2.textoApp = "Revisá tu casilla de email"
			emailFacturaCuentaAviso2.save(flush:true, failOnError:true)
			println "Plantilla email aviso2 factura creada"
		}

		NotificacionTemplate emailFacturaCuentaAviso3 = NotificacionTemplate.findByNombre("Factura Cuenta Aviso 3")
		if(!emailFacturaCuentaAviso3){
			emailFacturaCuentaAviso3 = new NotificacionTemplate()
			emailFacturaCuentaAviso3.nombre = "Factura Cuenta Aviso 3"
			emailFacturaCuentaAviso3.asuntoEmail = "{0}, ¡Todavía no pagaste tu cuota Calim!"
			emailFacturaCuentaAviso3.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2019/11/foto-mail-calim.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">¡Hola {0}!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>Recordá pagar tu cuota Calim de {1} o se suspenderá el servicio.</strong></div><div style="font-size:18px; padding-top: 40px; color:#666;">Importe: <strong>{2}</strong></div><div style="padding-top:60px;"><a href="{3}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">PAGAR AHORA</a></div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{4}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailFacturaCuentaAviso3.tituloApp = "Todavía no pagaste tu Cuota Mensual"
			emailFacturaCuentaAviso3.textoApp = "Revisá tu casilla de email"
			emailFacturaCuentaAviso3.save(flush:true, failOnError:true)
			println "Plantilla email aviso3 factura creada"
		}

		NotificacionTemplate emailFacturaCuentaAviso1App = NotificacionTemplate.findByNombre("Factura Cuenta Aviso 1 App")
		if(!emailFacturaCuentaAviso1App){
			emailFacturaCuentaAviso1App = new NotificacionTemplate()
			emailFacturaCuentaAviso1App.nombre = "Factura Cuenta Aviso 1 App"
			emailFacturaCuentaAviso1App.asuntoEmail = "{0}, recordá que ya está lista tu cuota mensual de Calim"
			emailFacturaCuentaAviso1App.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2020/04/foto-mail-calim-delivery.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">¡Hola {0}!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>¡No olvides pagar tu cuota Calim de {1} para seguir disfrutando del servicio!</strong></div><div style="font-size:18px; padding-top: 40px; color:#666;">Importe: <strong>{2}</strong></div><div style="padding-top:60px;"><a href="{3}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">PAGAR AHORA</a></div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Mandado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{4}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailFacturaCuentaAviso1App.tituloApp = "Recordá pagar tu Cuota Mensual"
			emailFacturaCuentaAviso1App.textoApp = "Revisá tu casilla de email"
			emailFacturaCuentaAviso1App.save(flush:true, failOnError:true)
			println "Plantilla email aviso1 app factura creada"
		}

		NotificacionTemplate emailFacturaCuentaAviso2App = NotificacionTemplate.findByNombre("Factura Cuenta Aviso 2 App")
		if(!emailFacturaCuentaAviso2App){
			emailFacturaCuentaAviso2App = new NotificacionTemplate()
			emailFacturaCuentaAviso2App.nombre = "Factura Cuenta Aviso 2 App"
			emailFacturaCuentaAviso2App.asuntoEmail = "{0}, ¡No te olvides de tu cuota Calim de {1}!"
			emailFacturaCuentaAviso2App.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2020/04/foto-mail-calim-delivery.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">¡Hola {0}!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>¡Recordá que debés pagar tu cuota de {1} para seguir disfrutando del servicio!</strong></div><div style="font-size:18px; padding-top: 40px; color:#666;">Importe: <strong>{2}</strong></div><div style="padding-top:60px;"><a href="{3}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">PAGAR AHORA</a></div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{4}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailFacturaCuentaAviso2App.tituloApp = "No olvides pagar tu Cuota Mensual"
			emailFacturaCuentaAviso2App.textoApp = "Revisá tu casilla de email"
			emailFacturaCuentaAviso2App.save(flush:true, failOnError:true)
			println "Plantilla email aviso2 app factura creada"
		}

		NotificacionTemplate emailFacturaCuentaAviso3App = NotificacionTemplate.findByNombre("Factura Cuenta Aviso 3 App")
		if(!emailFacturaCuentaAviso3App){
			emailFacturaCuentaAviso3App = new NotificacionTemplate()
			emailFacturaCuentaAviso3App.nombre = "Factura Cuenta Aviso 3 App"
			emailFacturaCuentaAviso3App.asuntoEmail = "{0}, ¡Todavía no pagaste tu cuota Calim!"
			emailFacturaCuentaAviso3App.cuerpoEmail = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><title>Calim</title></head><body><div style="width:100%; max-width: 700px; margin:auto; font-family: Trebuchet MS, Arial, Helvetica, sans-serif; text-align: center;"><div style="border-bottom:1px solid #ddd;  padding: 30px 0px 30px 0px; overflow: hidden;"><div style="float: left; margin-left: 30px;"><img src="https://calim.com.ar/wp-content/uploads/2019/11/logo-mail-calim.png"></div></div><div><img src="https://calim.com.ar/wp-content/uploads/2020/04/foto-mail-calim-delivery.jpg" style="width: 100%;"></div><div style="font-size:45px; padding-top: 50px; color:#2190a1;">¡Hola {0}!</div><div style="font-size:23px; padding: 20px 20px 0px 20px; color:#666;"><strong>Recordá pagar tu cuota Calim de {1} o se suspenderá el servicio.</strong></div><div style="font-size:18px; padding-top: 40px; color:#666;">Importe: <strong>{2}</strong></div><div style="padding-top:60px;"><a href="{3}" style="text-decoration: none; padding: 20px 30px; color:#fff; font-weight: bold; font-size: 16px; background-color: #c1d549; border-radius: 50px;">PAGAR AHORA</a></div><div style="font-size:20px; padding-top: 40px; color:#2190a1;">¡Gracias por elegirnos!</div><ul style="padding-inline-start: 0px;"><li style="list-style: none; display: inline-table;"><a href="https://twitter.com/CalimImpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/twitter-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.instagram.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/instagram-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.facebook.com/calimimpuestos/"><img src="https://calim.com.ar/wp-content/uploads/2019/11/fbk-calim.png"></a></li><li style="list-style: none; display: inline-table;"><a href="https://www.linkedin.com/company/calimimpuestos"><img src="https://calim.com.ar/wp-content/uploads/2019/11/linkedin-calim.png"></a></li></ul><div style="font-size: 11px; color: #666; padding: 20px 30px 20px 30px;">Enviado por Calim | Calculo Mis Impuestos. Recibiste este mail porque sos parte de la comunidad Calim. Si ya no querés recibir este tipo de notificaciones, podés darte de baja de nuestra lista de mailing <a href="{4}">acá</a>.<br/>Calim | Calculo Mis Impuestos.<br/>Juramento 1662, C1428DMV CABA, Argentina</div></div></body></html>'
			emailFacturaCuentaAviso3App.tituloApp = "Todavía no pagaste tu Cuota Mensual"
			emailFacturaCuentaAviso3App.textoApp = "Revisá tu casilla de email"
			emailFacturaCuentaAviso3App.save(flush:true, failOnError:true)
			println "Plantilla email aviso3 app factura creada"
		}

	
	*/}

	static def inicializarTipoClave(){
		println "Verificando tipo Claves..."
		TipoClave tipoCuit = TipoClave.findByNombre("CUIT")
		if (!tipoCuit){
			tipoCuit = new TipoClave()
			tipoCuit.nombre = "CUIT"
			tipoCuit.save(flush:true, failOnError:true)
			println "Tipo Clave CUIT creado."
		}

		TipoClave tipoCuil = TipoClave.findByNombre("CUIL")
		if (!tipoCuil){
			tipoCuil = new TipoClave()
			tipoCuil.nombre = "CUIL"
			tipoCuil.save(flush:true, failOnError:true)
			println "Tipo Clave CUIL creado."
		}

		TipoClave tipoCdi = TipoClave.findByNombre("CDI")
		if (!tipoCdi){
			tipoCdi = new TipoClave()
			tipoCdi.nombre = "CDI"
			tipoCdi.save(flush:true, failOnError:true)
			println "Tipo Clave CDI creado."
		}
	}

	static def inicializarTipoPersona(){
		println "Verificando tipo Personas..."
		TipoPersona tipoFisica = TipoPersona.findByNombre("FISICA")
		if (!tipoFisica){
			tipoFisica = new TipoPersona()
			tipoFisica.nombre = "FISICA"
			tipoFisica.save(flush:true, failOnError:true)
			println "Tipo Persona FISICA creado."
		}

		TipoPersona tipoJuridica = TipoPersona.findByNombre("JURIDICA")
		if (!tipoJuridica){
			tipoJuridica = new TipoPersona()
			tipoJuridica.nombre = "JURIDICA"
			tipoJuridica.save(flush:true, failOnError:true)
			println "Tipo Persona JURIDICA creado."
		}
	}

	static inicializarTipoVep(){
		println "Verificando tipos de VEP..."
		["Monotributo","Autonomo","IVA","IIBB","Seguridad e Higiene","931","Simplificado","Unificado","Intereses"].each{
			String nombreActual = it
			if (!TipoVep.findByNombre(nombreActual))
				new TipoVep().with{
					nombre = nombreActual
					save(flush:true, failOnError:true)
					println "    Tipo VEP $nombreActual creado."
				}
		}
	}

	static inicializarMediosPago(){
		println "Verificando medios de pago..."
		[	// [Nombre, afip, agip, arba]
			["Red Link", true, true, true],
			["Banelco", true, true, true],
			["Interbanking", true, true, true],
			["Efectivo", false, false, true],
			["Código QR", false, true, false],
		].each{
			if (!MedioPago.findByNombre(it[0])){
				new MedioPago(it[0],it[1],it[2],it[3]).save(flush:true)
				println "    Medio de Pago ${it[0]} creado."
			}
		}
	}

	static def inicializarConsumidorFinal(){
		println "Verificando persona Consumidor Final..."
		if (! Persona.findByRazonSocial("Consumidor Final")){
			Persona consumidor = new Persona()
			consumidor.razonSocial = "Consumidor Final"
			consumidor.tipoDocumento = "DNI"
			consumidor.cuit = ""
			consumidor.save(flush:true, failOnError:true)
			println "Persona Consumidor Final creado."

		}
	}

	static def inicializarTokensGoogle(){
		println "Verificando tokens Google..."
		if(!TokenGoogle.findByUsuario("Agustin")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Agustin"
			token.refreshToken = "1//0hQq7MGTDh6kfCgYIARAAGBESNwF-L9IrTYL0r8WitrtLCyKkhYu4BlhhnRgkAsIbcZ7gWfdpUfMiFcnthMUMaMBvW4YnRddywWo"
			token.save(flush:true, failOnError:true)
			println "Token Google de Testing Agustin creado"
		}
		if(!TokenGoogle.findByUsuario("Cuenta Contactos Gonzalo")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Cuenta Contactos Gonzalo"
			token.refreshToken = "1//0h8PIAuLz3NJGCgYIARAAGBESNwF-L9IrJM3WSgXA6isd8CpFgASy1QEwpNbxGz82YhGaJxY67qc4XobJXPS-0O2Zy7_3dxl0wZo"
			token.save(flush:true, failOnError:true)
			println "Token Google de Vendedor Gonzalo creado"
		}
		if(!TokenGoogle.findByUsuario("Cuenta Contactos Carolina")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Cuenta Contactos Carolina"
			token.refreshToken = "1//0hPfoksZp_6vuCgYIARAAGBESNwF-L9IrpM13C8S_XBlkj9Y_AGRzXF6b-jndSjwfJAVwvpESF8b2xMjORRgW3LD0EBt5-dWtbXY"
			token.save(flush:true, failOnError:true)
			println "Token Google de Vendedora Carolina creado"
		}	
		if(!TokenGoogle.findByUsuario("Cuenta Contactos Sebastian")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Cuenta Contactos Sebastian"
			token.refreshToken = "1//0htfui6seFTUGCgYIARAAGBESNgF-L9IrX6S9DbUs3mSxBdKhxTNrE1urTXxuit5KKfsRETC0Sjt1Ggqdja6fw4w2sr_JURV9iQ"
			token.save(flush:true, failOnError:true)
			println "Token Google de Vendedor Sebastian creado"
		}
		if(!TokenGoogle.findByUsuario("Cuenta Contactos Violeta")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Cuenta Contactos Violeta"
			token.refreshToken = "1//0hzlZI-3lM0uVCgYIARAAGBESNwF-L9IryYn1Bj3-7Gx67HSNsBuBoeSGeA0ETAhRbLVu_0ToZiDbpHOp5f_nnR4IiHMihmGtfj4"
			token.save(flush:true, failOnError:true)
			println "Token Google de Vendedora Violeta creado"
		}
		if(!TokenGoogle.findByUsuario("Cuenta Contactos Juan")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Cuenta Contactos Juan"
			token.refreshToken = "1//0h9rVkvlkAFkmCgYIARAAGBESNwF-L9IrNsvtianfVqcbV9G639i1UGJ0xSprnX3N5_Cqaj_mNU4PjJki-90jTBZ7S_3kumJfXTQ"
			token.save(flush:true, failOnError:true)
			println "Token Google de Vendedor Juan creado"
		}
		if(!TokenGoogle.findByUsuario("Cuenta Contactos Angeles")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Cuenta Contactos Angeles"
			token.refreshToken = "1//0hVYPBn4dS4M2CgYIARAAGBESNwF-L9IrNdVghbou-KAFFho0TBSuQUQnSTZBm_bU-CI0_r1CPWksZrukliQf68VWCMFUHrT2V_k"
			token.save(flush:true, failOnError:true)
			println "Token Google de Vendedora Angeles creado"
		}
		if(!TokenGoogle.findByUsuario("Cuenta Contactos 1")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Cuenta Contactos 1"
			token.refreshToken = "1//0hkE8g3qTWpqeCgYIARAAGBESNwF-L9IrRBdsi7PZsU87wMalYwUFaMixFhd3XkbIu_DtffIFyp440_1_lAxgiTU6cNvFGxrFq-Q"
			token.save(flush:true, failOnError:true)
			println "Token Google de Cuenta Contactos 1 creado"
		}
		if(!TokenGoogle.findByUsuario("Cuenta Contactos SM")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Cuenta Contactos SM"
			token.refreshToken = "1//0hy_hK0uY2O-iCgYIARAAGBESNwF-L9Ir6otbm-4RhcZdJTzycGxLpELRimzSpurVNORZOSBRmhXIQSE5G-ugKwe-tKGHC4V1Di8"
			token.save(flush:true, failOnError:true)
			println "Token Google de Cuenta Contactos SM creado"
		}
		if(!TokenGoogle.findByUsuario("Cuenta Contactos SE")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Cuenta Contactos SE"
			token.refreshToken = "1//0hccZxlqBG8_RCgYIARAAGBESNwF-L9IrRUnIRuenFefJjmtWJnAtKpvcdqV16b325RzxGij5ADMPkqtER6gp70UaHuI-l9rJuaU"
			token.save(flush:true, failOnError:true)
			println "Token Google de Cuenta Contactos SE creado"
		}
		if(!TokenGoogle.findByUsuario("Cuenta Contactos 2")){
			TokenGoogle token = new TokenGoogle()
			token.usuario = "Cuenta Contactos 2"
			token.refreshToken = "1//0hsCd94oDB1o3CgYIARAAGBESNwF-L9IrEBYxlGTfG5B96qm8H-E6u4Z_CVEYM2Hg9DchsKYVCBSGzn_IpWNlFLIP2yAlE5ExIxo"
			token.save(flush:true, failOnError:true)
			println "Token Google de Cuenta Contactos 2 creado"
		}
	}

	static def inicializarVendedores(){
		println "Verificando vendedores..."
		if(!Vendedor.findByNombre("Gonzalo")){
			Vendedor resp = new Vendedor()
			resp.nombre = "Gonzalo"
			resp.email = "gonzalo@calim.com.ar"
			resp.save(flush:true, failOnError:true)
			println "Vendedor Gonzalo creado"
		}
		if(!Vendedor.findByNombre("Sebastian")){
			Vendedor resp = new Vendedor()
			resp.nombre = "Sebastian"
			resp.email = "sebastian@calim.com.ar"
			resp.save(flush:true, failOnError:true)
			println "Vendedor Sebastian creado"
		}
		if(!Vendedor.findByNombre("Violeta")){
			Vendedor resp = new Vendedor()
			resp.nombre = "Violeta"
			resp.email = "violeta@calim.com.ar"
			resp.save(flush:true, failOnError:true)
			println "Vendedora Violeta creada"
		}
		if(!Vendedor.findByNombre("Marianela")){
			Vendedor resp = new Vendedor()
			resp.nombre = "Marianela"
			resp.email = "marianela@calim.com.ar"
			resp.save(flush:true, failOnError:true)
			println "Vendedora Marianela creada"
		}
		if(!Vendedor.findByNombre("Juan")){
			Vendedor resp = new Vendedor()
			resp.nombre = "Juan"
			resp.email = "juan@calim.com.ar"
			resp.save(flush:true, failOnError:true)
			println "Vendedor Juan creado"
		}
		if(!Vendedor.findByNombre("Carolina")){
			Vendedor resp = new Vendedor()
			resp.nombre = "Carolina"
			resp.email = "carolina@calim.com.ar"
			resp.celular = "5491173657195"
			resp.turnoManana = true
			resp.turnoTarde = false
			resp.save(flush:true, failOnError:true)
			println "Vendedora Carolina creado"
		}
	}

	static def inicializarNacionalidades(){
		println "Verificando nacionalidades..."
		if(!Nacionalidad.findByNombre("Argentina")){
			Nacionalidad nac = new Nacionalidad()
			nac.nombre = "Argentina"
			nac.save(flush:true, failOnError:true)
		}
		if(!Nacionalidad.findByNombre("Bolivia")){
			Nacionalidad nac = new Nacionalidad()
			nac.nombre = "Bolivia"
			nac.save(flush:true, failOnError:true)
		}
		if(!Nacionalidad.findByNombre("Brasil")){
			Nacionalidad nac = new Nacionalidad()
			nac.nombre = "Brasil"
			nac.save(flush:true, failOnError:true)
		}
		if(!Nacionalidad.findByNombre("Chile")){
			Nacionalidad nac = new Nacionalidad()
			nac.nombre = "Chile"
			nac.save(flush:true, failOnError:true)
		}
		if(!Nacionalidad.findByNombre("Colombia")){
			Nacionalidad nac = new Nacionalidad()
			nac.nombre = "Colombia"
			nac.save(flush:true, failOnError:true)
		}
		if(!Nacionalidad.findByNombre("Ecuador")){
			Nacionalidad nac = new Nacionalidad()
			nac.nombre = "Ecuador"
			nac.save(flush:true, failOnError:true)
		}
		if(!Nacionalidad.findByNombre("Peru")){
			Nacionalidad nac = new Nacionalidad()
			nac.nombre = "Peru"
			nac.save(flush:true, failOnError:true)
		}
		if(!Nacionalidad.findByNombre("Uruguay")){
			Nacionalidad nac = new Nacionalidad()
			nac.nombre = "Uruguay"
			nac.save(flush:true, failOnError:true)
		}
		if(!Nacionalidad.findByNombre("Venezuela")){
			Nacionalidad nac = new Nacionalidad()
			nac.nombre = "Venezuela"
			nac.save(flush:true, failOnError:true)
		}
	}
}
