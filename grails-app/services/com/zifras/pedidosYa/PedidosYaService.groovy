package com.zifras.pedidosYa

import com.zifras.cuenta.Cuenta
import com.zifras.facturacion.Proforma
import com.zifras.facturacion.Persona
import com.zifras.facturacion.FacturaVenta
import com.zifras.notificacion.NotificacionService

import grails.transaction.Transactional
import grails.validation.ValidationException
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.ui.RegistrationCode
import org.joda.time.LocalDate
import org.joda.time.format.DateTimeFormat
import static org.apache.poi.ss.usermodel.Cell.*
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.ss.usermodel.Cell
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.xssf.usermodel.XSSFSheet
import org.apache.poi.poifs.filesystem.POIFSFileSystem
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.apache.poi.ss.usermodel.CellStyle
import org.apache.poi.ss.usermodel.Font
import java.time.DayOfWeek
import java.time.temporal.TemporalAdjusters
import java.time.format.DateTimeFormatter


@Transactional
class PedidosYaService{

	def notificacionService

	def listProformas(String fechaInicio){
		LocalDate fecha = DateTimeFormat.forPattern("dd/MM/yyyy").parseLocalDate(fechaInicio)
		return Proforma.findAllByFecha(primerDiaSemana(fecha))
	}

	def notificarRiders(riders){
		riders.each{
			def cuenta = Cuenta.findByRiderId(it)
			def proforma = Proforma.findAllByRiderId(it).sort{p -> p.fecha}.reverse()[0]
			if(proforma.estado == Proforma.Estados.NUEVA){
				notificacionService.notificarProforma(cuenta.nombreApellido.split(' ')[0],'$' + proforma.importe, proforma.fecha.toString("dd/MM/YYYY"), cuenta.email)
				proforma.estado = Proforma.Estados.NOTIFICADA
				proforma.save(flush:true,failOnError:true)
			}
		}
	}

	private crearArchivoExcel(archivo, Boolean errorEsAssertion){
		InputStream targetStream
		String nombre
		try {
			targetStream = archivo.getInputStream()
			nombre = archivo.getOriginalFilename()
		}
		catch(Exception e) {
			targetStream = new FileInputStream(archivo);
			nombre = archivo.name
		}
		
		switch (nombre.substring(nombre.lastIndexOf(".") + 1,
				nombre.length())) {
			case "xls":
				println "Detectamos que es la versión de excel vieja."
				return new HSSFWorkbook(targetStream).getSheetAt(0)
			case "xlsx":
				println "Detectamos que es la versión de excel nueva."
				return new XSSFWorkbook(targetStream).getSheetAt(0)
			default:
				if (errorEsAssertion)
					assert false : "El archivo ingresado no es un Excel.finerror"
				else
					throw new Exception("formato")
		}
	}

	def generarExcel(emision,desde,hasta){
		def fechaEmision = DateTimeFormat.forPattern("dd/MM/yyyy").parseLocalDate(emision)
		def fechaDesde = DateTimeFormat.forPattern("dd/MM/yyyy").parseLocalDate(desde)
		def fechaHasta = DateTimeFormat.forPattern("dd/MM/yyyy").parseLocalDate(hasta)

		def pedidosYa = Persona.findByCuit("33715667369")
		
		def facturas = FacturaVenta.findAllByCliente(pedidosYa).findAll{it.fecha.isBefore(fechaEmision) && it.fecha.isAfter(fechaEmision.withDayOfMonth(1))}
		
		XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet("Facturación Riders");
 
        int rowCount = 0;
        Row row = sheet.createRow(rowCount)
        int columnCount = 0

        CellStyle style = workbook.createCellStyle()
		Font font = workbook.createFont()
		font.setBold(true)
		font.setFontHeightInPoints((short) 10)
		style.setFont(font)

     	Cell cellCabecera = row.createCell(columnCount)
        cellCabecera.setCellValue((String) "Fecha")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Servicios desde")
        cellCabecera.setCellStyle(style)
		cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Servicios hasta")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "CUIT")
        cellCabecera.setCellStyle(style)         
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Nombre")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Descripción")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Punto de venta")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Nº de factura")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Tipo")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "Monto")
        cellCabecera.setCellStyle(style)
        cellCabecera = row.createCell(++columnCount)
        cellCabecera.setCellValue((String) "CAE")
        cellCabecera.setCellStyle(style)

        facturas.each{
             
            row = sheet.createRow(++rowCount)
            columnCount = 0;
            String tipo = it.tipoComprobante.nombre
            if( tipo == "Factura C")
            	tipo = "FC"

			def today = java.time.LocalDate.now()
			
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/YYYY")
			java.time.LocalDate firstOfMonth = today.with( TemporalAdjusters.firstDayOfMonth() );
			java.time.LocalDate monday = firstOfMonth.with( TemporalAdjusters.previousOrSame( DayOfWeek.MONDAY ) );

			java.time.LocalDate endOfMonth = today.with( TemporalAdjusters.lastDayOfMonth() );
			java.time.LocalDate sunday = endOfMonth.with( TemporalAdjusters.previousOrSame( DayOfWeek.SUNDAY ) );

			def periodoDesde = monday.format(formatter)
			def periodoHasta = sunday.format(formatter)

            Cell cell = row.createCell(columnCount)
            cell.setCellValue((String) it.fecha.toString())
            cell = row.createCell(++columnCount)
            cell.setCellValue((String) periodoDesde)
			cell = row.createCell(++columnCount)
            cell.setCellValue((String) periodoHasta)    
            cell = row.createCell(++columnCount)
            cell.setCellValue((String) it.cuenta.cuit)         
            cell = row.createCell(++columnCount)
            cell.setCellValue((String) it.cuenta.razonSocial)
            cell = row.createCell(++columnCount)
            cell.setCellValue((String) "Facturacion Pedidos Ya")
            cell = row.createCell(++columnCount)
            cell.setCellValue((String) it.puntoVenta.numero.toString())
            cell = row.createCell(++columnCount)
            cell.setCellValue(it.numero)
            cell = row.createCell(++columnCount)
            cell.setCellValue((String) tipo)
            cell = row.createCell(++columnCount)
            cell.setCellValue(it.total)
            cell = row.createCell(++columnCount)
            cell.setCellValue((String) it.cae)
            }
        
        String pathExcels = System.getProperty("user.home") + "/Excels Pedidos Ya/"
		File carpeta = new File(pathExcels)
		if(!carpeta.exists())
			carpeta.mkdirs()

        FileOutputStream outputStream = new FileOutputStream(pathExcels+"Facturacion Riders "+new LocalDate().toString()+".xlsx") 
        workbook.write(outputStream)

		return 
	}

	def primerDiaSemana(LocalDate fecha){
		return fecha.withDayOfWeek(1)
	}

}