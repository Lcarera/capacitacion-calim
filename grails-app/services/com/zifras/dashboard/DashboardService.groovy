package com.zifras.dashboard

import org.joda.time.LocalDate
import com.zifras.AccessRulesService
import com.zifras.cuenta.Cuenta

import com.zifras.cuenta.FacturacionCategoriaMonotributo
import com.zifras.documento.DeclaracionJuradaService
import com.zifras.cuenta.CuentaService
import com.zifras.liquidacion.LiquidacionIva
import com.zifras.liquidacion.LiquidacionIIBB

class DashboardService {
	AccessRulesService accessRulesService
	def liquidacionIvaService
	def liquidacionIIBBService
	def declaracionJuradaService
	def cuentaService

	def calcularTotalIVA(LocalDate periodo){
		def cuentaId = accessRulesService.getCurrentUser().cuenta?.id

		def ano = periodo.toString("YYYY")
		def mes = periodo.toString("MM")

		def liquidacion = liquidacionIvaService.getLiquidacionIvaPorCuentaFecha(cuentaId, ano, mes) //Si no existe viene con total 0 y estado 'Sin Liquidar'

		def resultado = [:]
		resultado['estado'] = liquidacion.estadoUsuario
		resultado['total'] = liquidacion.saldoDdjj
		resultado['id'] = liquidacion.id
		resultado['pagada'] = liquidacion.pagada
		return resultado
	}

	def calcularTotalIIBB(LocalDate periodo){
		def cuentaId = accessRulesService.getCurrentUser().cuenta?.id

		def ano = periodo.toString("YYYY")
		def mes = periodo.toString("MM")

		def liquidaciones = liquidacionIIBBService.getLiquidacionesIIBBPorCuentaYFecha(cuentaId, ano, mes)

		def resultado = [:]
		if (liquidaciones){
			resultado['estado'] = liquidaciones.first()?.estadoUsuario
			resultado['total'] = 0
			resultado['saldoAFavor'] = 0
			resultado['netoVenta'] = 0
			liquidaciones.each{
				resultado['netoVenta'] += (it.neto ?: 0)
				if(it.saldoAFavor!=null)
					resultado['saldoAFavor'] += it.saldoAFavor
				resultado['total'] += it.saldoDdjj
			}
			resultado['id'] = liquidaciones.first().id
			resultado['pagada'] = liquidaciones.first().pagada
			if((resultado['saldoAFavor']!=0)&&(resultado['total']==0))
				resultado['aFavor'] = true
			else
				resultado['aFavor'] = false
		}else{
			resultado['estado'] = "Sin liquidar"
			resultado['total'] = 0
			resultado['id'] = 0
			resultado['netoVenta'] = 0
			resultado['pagada'] = false
		}
		return resultado
	}

	def calcularTotalFacturacion(String categoria, Long cuentaId){
		def resultado = [:]
		def cuenta = Cuenta.get(cuentaId)
		Integer anoActual = new Integer(new LocalDate().toString("YYYY"))
		def facturacionCategoria
		def facturacionAnual
		def promedioMensual
		def facturacionCuenta = cuentaService.getFacturacion(cuentaId,categoria)
		def limiteServicios,limiteProductos,limiteVentaProducto
		def cuotaMensual
		
		if(categoria){
			facturacionCategoria = FacturacionCategoriaMonotributo.findByAnoAndNombre(anoActual,categoria[0])
			facturacionAnual = facturacionCategoria.importeAnual
			promedioMensual = facturacionAnual ? facturacionAnual / 12 : ""
			limiteServicios = new Double((FacturacionCategoriaMonotributo.findByNombreAndAno("H",2020).importeAnual/12).toString())
			limiteProductos = new Double((FacturacionCategoriaMonotributo.findByNombreAndAno("K",2020).importeAnual/12).toString())
			limiteVentaProducto = new Double("29119.56")
			cuotaMensual = categoria.toLowerCase().contains("muebles") ? facturacionCategoria.cuotaMensualMuebles : facturacionCategoria.cuotaMensualServicios
		}

		resultado['promedioMensual'] = promedioMensual
		resultado['facturacionAnualMaxima'] = facturacionAnual
		resultado['facturacionAnualActual'] = facturacionCuenta['facturacionTotalPeriodo']
		resultado['facturacionAnualRestante'] = categoria ? facturacionAnual - resultado['facturacionAnualActual'] : null
		resultado['facturacionMensualCuenta'] = facturacionCuenta['facturacionMensual']
		resultado['limiteServicios'] = limiteServicios
        resultado['limiteProductos'] = limiteProductos
        resultado['limiteVentaProducto'] = limiteVentaProducto
        resultado['cuotaMensual'] = cuotaMensual
		return resultado
	}

	def calcularCantidadDDJJ(){
		def cuenta = accessRulesService.getCurrentUser().cuenta
		LocalDate periodo = new LocalDate()
		def ano = periodo.toString("YYYY")
		def mes = periodo.toString("MM")

		def listDDJJ = declaracionJuradaService.getDeclaracionJuradaListPorMes(cuenta, ano, mes)

		return listDDJJ.size()
	}
}
