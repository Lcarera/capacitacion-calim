package com.zifras.dashboard

import grails.plugin.springsecurity.annotation.Secured
import com.zifras.AccessRulesService
import com.zifras.User
import com.zifras.Role
import com.zifras.UserRole
import com.zifras.cuenta.Cuenta
import com.zifras.documento.FacturaCuenta
import com.zifras.servicio.ItemServicioEspecial
import com.zifras.servicio.Servicio
import org.joda.time.LocalDate
import grails.converters.JSON

@Secured(['ROLE_USER', 'ROLE_LECTURA', 'ROLE_ADMIN', 'ROLE_CUENTA', 'IS_AUTHENTICATED_FULLY'])
class DashboardController {
	AccessRulesService accessRulesService
    def dashboardService

    def index(String errores, String mensaje) {
        User userInstance = accessRulesService.getCurrentUser()
        def cuentaUsuario = userInstance.cuenta

    	if(! userInstance.hasRole("ROLE_CUENTA")){ //Sólo se puede entrar a este controller si sos role cuenta
			redirect(controller:"cuenta", action: "list")
            return
        }

        LocalDate periodo = new LocalDate().minusMonths(1)
        String periodoString = periodo.toString("MMMM",new java.util.Locale('ES')).capitalize() + " " + periodo.toString("YYYY")
        def liquidacionIVA = dashboardService.calcularTotalIVA(periodo)

        def liquidacionIIBB = dashboardService.calcularTotalIIBB(periodo)
        boolean  monotributista = cuentaUsuario.condicionIva?.nombre == "Monotributista"
        String categoria
        def facturacionUltimoMes,facturacionAnualMaxima,promedioMensualCategoria,facturacionAnualActual,facturacionAnualRestante,limiteServicios,limiteProductos,limiteVentaProducto,cuotaMensual
        def facturacionMensualCuenta = []
        
        categoria = monotributista ? cuentaUsuario.categoriaMonotributo.toString() : null

        def facturacion = dashboardService.calcularTotalFacturacion(categoria,cuentaUsuario.id)
        promedioMensualCategoria = facturacion['promedioMensual']
        facturacionAnualMaxima = facturacion['facturacionAnualMaxima']
        facturacionAnualActual = facturacion['facturacionAnualActual']
        facturacionAnualRestante = facturacion['facturacionAnualRestante']
        facturacionMensualCuenta = facturacion['facturacionMensualCuenta']
        limiteServicios = facturacion['limiteServicios']
        limiteProductos = facturacion['limiteProductos']
        limiteVentaProducto = facturacion['limiteVentaProducto']
        cuotaMensual = facturacion['cuotaMensual']

        String periodoFacturacionString
        if(cuentaUsuario.puntoVentaCalim){
            facturacionUltimoMes = facturacionMensualCuenta.last()
            periodoFacturacionString = periodo.plusMonths(1).toString("MMMM",new java.util.Locale('ES')).capitalize() + " " + periodo.plusMonths(1).toString("YYYY")
        }
        else{
            facturacionUltimoMes = facturacionMensualCuenta[facturacionMensualCuenta.size - 2]
            periodoFacturacionString = periodoString
        }
    

        Double saldo = cuentaUsuario.saldo

        Boolean mostrarPasos = cuentaUsuario.with{
            return ! infoRevisada
        }

        Boolean inscriptoAfip = cuentaUsuario.inscriptoAfip

        if(saldo==null)
            saldo = new Double(0)

        Boolean trabajaConApp = cuentaUsuario.trabajaConApp()

        int cantidadDDJJ = dashboardService.calcularCantidadDDJJ()
        def cuentaId = cuentaUsuario.id

        def volantePagoSimplificado = cuentaUsuario.ultimoVolante
        def fechaVencimiento = volantePagoSimplificado?.vencimientoSimplificado?.toString("dd/MM")

       if (mensaje)
            flash.message = mensaje
        
        [   periodo: periodoString,
            mesString : periodoString.split()[0],
            periodoFacturacionString: periodoFacturacionString,
            mes: periodo.toString("MM"),
            ano: periodo.toString("YYYY"),
            cuentaId:cuentaId,
            regimen:cuentaUsuario.regimenIibb.nombre,
            volantePago:volantePagoSimplificado,
            fechaVencimiento:fechaVencimiento,

            totalIva: liquidacionIVA['total'],
            estadoIva: liquidacionIVA['estado'],
            idIva: liquidacionIVA['id'],
            pagadoIva: liquidacionIVA['pagada'],
            condicionIva : cuentaUsuario.condicionIva.nombre,
            
            totalIIBB: liquidacionIIBB['total'],
            estadoIIBB: liquidacionIIBB['estado'],
            idIIBB: liquidacionIIBB['id'],
            aFavorIIBB: liquidacionIIBB['aFavor'],
            saldoAFavorIIBB: liquidacionIIBB['saldoAFavor'],
            netoIIBB: liquidacionIIBB['netoVenta'],
            pagadoIIBB: liquidacionIIBB['pagada'],

            monotributista: monotributista,
            categoria: categoria,
            promedioMensualCategoria : promedioMensualCategoria,
            facturacionAnualMaxima : facturacionAnualMaxima,
            facturacionAnualActual : facturacionAnualActual,
            facturacionAnualRestante : facturacionAnualRestante,
            facturacionMensualCuenta : facturacionMensualCuenta,
            facturacionUltimoMes : facturacionUltimoMes,
            cuotaMensual: cuotaMensual,
            limiteServicios : limiteServicios,
            limiteProductos : limiteProductos,
            limiteVentaProducto : limiteVentaProducto,

            saldo: saldo,
            mostrarPasos: mostrarPasos,
            inscriptoAfip: inscriptoAfip,
            cantidadDDJJ: cantidadDDJJ,

            razonSocial: cuentaUsuario.razonSocial,
            tiendaNube: !! cuentaUsuario.tokenTiendaNube,
            trabajaConApp : trabajaConApp,
            ingresoFotosRegistro : cuentaUsuario.ingresoFotosRegistro,
            claveFiscal : cuentaUsuario.claveFiscal,
            stepRegistro : cuentaUsuario.actionRegistro,
            domicilio : cuentaUsuario.domicilioFiscal,

            preguntarCF: errores == "clave",

            actividades: cuentaUsuario.porcentajesActividadIIBBActivos?.collect{it.actividad.nombre},
            servicioActivo: cuentaUsuario.servicioActivo?.toString()
            ]
	}

    def appGetDashboardData(){
        User userInstance = accessRulesService.getCurrentUser()
        def cuenta = userInstance.cuenta

        LocalDate periodo = new LocalDate().minusMonths(1)
        String periodoString = periodo.toString("MMMM",new java.util.Locale('ES')).capitalize() + " " + periodo.toString("YYYY")

        def liquidacionIVA = dashboardService.calcularTotalIVA(periodo)

        def liquidacionIIBB = dashboardService.calcularTotalIIBB(periodo)
        
        boolean  monotributista = cuenta.condicionIva?.nombre == "Monotributista"
        
        String categoria
        def facturacionUltimoMes,facturacionAnualMaxima,promedioMensualCategoria,facturacionAnualActual,facturacionAnualRestante,limiteServicios,limiteProductos,limiteVentaProducto,cuotaMensual
        def facturacionMensualCuenta = []
        
        categoria = monotributista ? cuenta.categoriaMonotributo.toString() : null

        def facturacion = dashboardService.calcularTotalFacturacion(categoria,cuenta.id)
        promedioMensualCategoria = facturacion['promedioMensual']
        facturacionAnualMaxima = facturacion['facturacionAnualMaxima']
        facturacionAnualActual = facturacion['facturacionAnualActual']
        facturacionAnualRestante = facturacion['facturacionAnualRestante']
        facturacionMensualCuenta = facturacion['facturacionMensualCuenta']
        limiteServicios = facturacion['limiteServicios']
        limiteProductos = facturacion['limiteProductos']
        limiteVentaProducto = facturacion['limiteVentaProducto']
        cuotaMensual = facturacion['cuotaMensual']

        String periodoFacturacionString
        if(cuenta.puntoVentaCalim){
            facturacionUltimoMes = facturacionMensualCuenta.last()
            periodoFacturacionString = periodo.plusMonths(1).toString("MMMM",new java.util.Locale('ES')).capitalize() + " " + periodo.plusMonths(1).toString("YYYY")
        }
        else{
            facturacionUltimoMes = facturacionMensualCuenta[facturacionMensualCuenta.size - 2]
            periodoFacturacionString = periodoString
        }

        facturacion['facturacionUltimoMes'] = facturacionUltimoMes
        facturacion['periodoFacturacionString'] = periodoFacturacionString
        
        def datosMonotributista = [:]
        
        if(monotributista){
            datosMonotributista['promedioMensualCategoria'] = promedioMensualCategoria
            datosMonotributista['facturacionAnualMaxima'] = facturacionAnualMaxima
            datosMonotributista['facturacionAnualActual'] = facturacionAnualActual
            datosMonotributista['facturacionAnualRestante'] = facturacionAnualRestante
            datosMonotributista['facturacionMensualCuenta'] = facturacionMensualCuenta
            datosMonotributista['facturacionUltimoMes'] = facturacionUltimoMes
            datosMonotributista['categoria'] = categoria
            datosMonotributista['cuotaMensual'] = cuotaMensual

            datosMonotributista['limiteServicios'] = limiteServicios;
            datosMonotributista['limiteProductos'] = limiteProductos;
            datosMonotributista['limiteVentaProducto'] = limiteVentaProducto;
            datosMonotributista['actividades'] = cuenta.porcentajesActividadIIBBActivos?.collect{it.actividad.nombre};
        }    


        Double saldo = cuenta.saldo

         if(saldo==null)
            saldo = new Double(0)

        int cantidadDDJJ = dashboardService.calcularCantidadDDJJ()

        Boolean mostrarPasos = cuenta.with{
            return ! infoRevisada
        }

        Boolean inscriptoAfip = cuenta.inscriptoAfip

        def volantePagoSimplificado
        def fechaVencimiento
        if (cuenta.regimenIibb.nombre == "Simplificado"){
            volantePagoSimplificado = cuenta.getUltimoVolante()
            fechaVencimiento = volantePagoSimplificado?.vencimientoSimplificado?.toString("dd/MM")
        }

        def returnArray = [:]

        returnArray['facturacion'] = facturacion
        returnArray['regimen'] = cuenta.regimenIibb.nombre;
        returnArray['volantePago'] = volantePagoSimplificado;
        returnArray['fechaVencimiento'] = fechaVencimiento;

        returnArray['periodo'] = periodoString;
        returnArray['mes'] = periodo.toString("MM");
        returnArray['ano'] = periodo.toString("YYYY");

        returnArray['totalIva'] = liquidacionIVA['total'];
        returnArray['estadoIva'] = liquidacionIVA['estado'];
        returnArray['idIva'] = liquidacionIVA['id'];
        
        returnArray['totalIIBB'] = liquidacionIIBB['total'];
        returnArray['estadoIIBB'] = liquidacionIIBB['estado'];
        returnArray['idIIBB'] = liquidacionIIBB['id'];
        returnArray['aFavorIIBB'] = liquidacionIIBB['aFavor'];
        returnArray['saldoAFavorIIBB'] = liquidacionIIBB['saldoAFavor'];
        returnArray['netoIIBB'] = liquidacionIIBB['netoVenta'];

        returnArray['monotributista'] = monotributista;
        returnArray['datosMonotributista'] = datosMonotributista;
        
        returnArray['saldo'] = saldo;
        returnArray['cantidadDDJJ'] = cantidadDDJJ;

        returnArray['mostrarPasos'] = mostrarPasos;
        returnArray['inscriptoAfip'] = inscriptoAfip;

        render returnArray as JSON
    }

    def ajaxLinkMercadoPago(){
        def cuentaInstance = Cuenta.get(accessRulesService.getCurrentUser().cuenta.id)
        def returnArr = [:]
        Servicio servicioInstance = cuentaInstance.apps.collect{it.app.nombre}.any{it == "Rappi"} ? Servicio.findByCodigo("SE17") : Servicio.findByCodigo("SE09") // Servicio Especial 'Alta Afip + IIBB'

        FacturaCuenta facturaCuenta = FacturaCuenta.findByCuenta(cuentaInstance) // Una cuenta recién registrada no puede tener más de una factura, así que agarramos esa.
        if(!facturaCuenta)
            facturaCuenta = facturaCuentaService.generarPorItemsServicio([new ItemServicioEspecial().with{
                        servicio = servicioInstance
                        cuota = 1
                        totalCuotas = 1
                        cuenta = cuentaInstance
                        precio = servicioInstance.precio
                        fechaAlta = new LocalDate()
                        save(flush:true, failOnError:true)
                    }])

        returnArr["link"] = facturaCuenta.linkPago 

       render returnArr as JSON
    }


}
