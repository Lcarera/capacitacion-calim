package com.zifras.debito

import com.zifras.cuenta.Cuenta
import com.zifras.Estado
import com.zifras.documento.FacturaCuenta

import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormatter
import org.joda.time.format.DateTimeFormat
import grails.transaction.Transactional
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols


@Transactional
class DebitoAutomaticoService{
	
	def listDebitosMensuales(){
		String patternCurrency = '###,###,##0.00'
		DecimalFormat decimalCurencyFormat = new DecimalFormat(patternCurrency)
		DecimalFormatSymbols otherSymbols = new   DecimalFormatSymbols(Locale.ENGLISH)
		otherSymbols.setDecimalSeparator(',' as char)
		otherSymbols.setGroupingSeparator('.' as char)
		decimalCurencyFormat.setGroupingUsed(false)
		decimalCurencyFormat.setDecimalFormatSymbols(otherSymbols)

		def salida = []
		def factura
		def cuentas = cuentasSMDebitoAutomatico(true)
		 cuentas?.each{
			def item = [:]
			item['cuenta'] = it.toString()
			item['numeroTarjeta'] = it.tarjetaDebitoAutomatico?.numero
			factura = FacturaCuenta.findAllByCuenta(it).findAll{fact -> fact.items.contains(it.servicioActivo)}.findAll{f -> !f.pagada && entraEnPeriodo(f.fechaHora)}.sort{it.fechaHora}.reverse()[0]
			item['facturaId'] = factura?.id
			item['fechaVencimiento'] = new LocalDate().toString("dd/MM/YYYY")
			item['importe'] = "\$ " + decimalCurencyFormat.format(it.servicioActivo.precio)
			item['importeCrudo'] = it.servicioActivo.precio
			item['cuentaId'] = it.id
			item['primerDebito'] = it.primerDebito ? "E" : "N"
			item['tipo'] = tipoTarjeta(it.tarjetaDebitoAutomatico)
			if(item['facturaId'])
				salida << item
		}

		return salida
	}


	def listDebitosMensualesGenerados(String mes, String ano){
		def fechaMes = new LocalDate(ano+"-"+mes+"-01")
		def fechaMesSiguiente = fechaMes.plusMonths(1)
		def debitos

		debitos = DebitoAutomatico.createCriteria().list(){
			ge('fechaCreacion',fechaMes)
			lt('fechaCreacion',fechaMesSiguiente)
		}

		return debitos
	}

	def saveDebitosMensuales(){
		def debitosMensuales = listDebitosMensuales()
		DateTimeFormatter formatter = DateTimeFormat.forPattern("dd/MM/yyyy");
		def estado = Estado.findByNombre("Pendiente")
		def debitosGuardados = []
		def facturaCuenta
		def debito
		debitosMensuales.each{
			facturaCuenta = FacturaCuenta.get(it.facturaId)
			debito = DebitoAutomatico.findByFactura(facturaCuenta)
			if(!debito){
				debito = new DebitoAutomatico()
				debito.primerDebito = it.primerDebito
			}

			debito.numeroTarjeta = it.numeroTarjeta
			debito.estado = estado
			debito.factura = facturaCuenta
			debito.fechaCreacion = LocalDate.parse(it.fechaVencimiento,formatter)
			debito.importe = Math.floor(it.importeCrudo)
			debito.cuenta = Cuenta.get(it.cuentaId)
			debito.tipo = it.tipo

			debito.save(flush:true, failOnError:true)
			debitosGuardados.add(debito)
		}
		return debitosGuardados
	}

	def debitoMensualPendiente(){
		def mesActual = new LocalDate().toString("MM")
		//def ultimoDebito = DebitoAutomatico.getAll().sort{it.fechaCreacion}.reverse()[0]
		def ultimoDebito = DebitoAutomatico.last(sort:'id')
		return (ultimoDebito == null || ultimoDebito?.fechaCreacion?.toString("MM") != mesActual)
	}

	def entraEnPeriodo(LocalDateTime fecha){
		def limiteInferior = new LocalDateTime().minusMonths(1).withDayOfMonth(10)
		def limiteSuperior = new LocalDateTime().withDayOfMonth(11)

		return fecha.isAfter(limiteInferior) && fecha.isBefore(limiteSuperior)
	}

	def cuentasSMDebitoAutomatico(Boolean tarjeta){
		return Cuenta.findAllByEstado(Estado.findByNombre("Activo")).findAll{it.servicioActivo && !it.servicioActivo.getMesPagado(new LocalDate()) && it.servicioActivo.debitoAutomatico && (it.tarjetaDebitoAutomatico!=null)==tarjeta}
	}

	def tipoTarjeta(Tarjeta tarjeta){
		if(tarjeta.visa)
			if(tarjeta.credito)
				return "visacredito"
			else
				return "visadebito"
		else
			return "mastercard"
	}

	def procesarDebitoAutomatico(Long idFactura, Boolean aceptado, String descripcion){
		Estado estadoResultado = aceptado ? Estado.findByNombre("Pagado") : Estado.findByNombre("Rechazado")
		def debito = DebitoAutomatico.findByFactura(FacturaCuenta.get(idFactura))
		debito.estado = estadoResultado
		debito.detalleCobro = descripcion
		debito.save(flush:true, failOnError:true)
	}

	def actualizarTarjetaCuenta(cuentaId, numeroTarjeta, tarjetaCredito){
		def cuenta = Cuenta.get(cuentaId)
		def tarjeta = cuenta.tarjetaDebitoAutomatico
		if(!tarjeta)
			tarjeta = new Tarjeta()
		tarjeta.numero = numeroTarjeta
		tarjeta.credito = new Boolean(tarjetaCredito)
		tarjeta.visa = (numeroTarjeta[0] == "4")
		tarjeta.save(flush:true,failOnError:true)
		cuenta.tarjetaDebitoAutomatico = tarjeta
		cuenta.save(flush:true,failOnError:true)
	}

	def generarTxt(String nombreArchivo, String numeroEstablecimiento, String tipoDebito){
		File archivo = new File(nombreArchivo + ".txt")
		LocalDateTime fecha = new LocalDateTime()
		String stringFecha = fecha.toString("yyyyMMdd")+fecha.toString("hhmm")
		def debitos = listDebitosMensualesGenerados(fecha.toString("MM"),fecha.toString("yyyy")).findAll{it.tipo == tipoDebito}
		Double importeTotal = 0
		def header = """0"""+nombreArchivo+""" 00"""+numeroEstablecimiento+"""900000    """+stringFecha+"""0                                                         *\n"""
		def registros = ""
		debitos.each{
			Double precio = it.importe
			Integer entera = precio
			Integer decimal = (precio - entera) * 100
			String charPrimerDebito = it.primerDebito ? "E" : " "
			importeTotal += it.importe
			registros += """1"""+it.numeroTarjeta+"""   """+String.format("%08d",it.factura.id)+fecha.toString("yyyyMMdd")+"""0005"""+String.format("%013d%02d",entera,decimal)+
						String.format("%015d",it.cuenta.id)+charPrimerDebito+"""                            *\n"""
		}
		Integer enteraTotal = importeTotal
		Integer decimalTotal = (importeTotal - enteraTotal) * 100
		def footer = """9"""+nombreArchivo+""" 00"""+numeroEstablecimiento+"""900000    """+stringFecha+String.format("%07d",debitos.size())+String.format("%013d%02d",enteraTotal,decimalTotal)+
						"""                                    *"""

		def total = header + registros + footer
		archivo.write total
		return archivo
	}
}