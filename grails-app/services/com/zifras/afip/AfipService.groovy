package com.zifras.afip

import com.google.common.base.Charsets
import com.google.common.base.Throwables
import com.sun.org.apache.xerces.internal.jaxp.datatype.XMLGregorianCalendarImpl
import groovy.transform.CompileDynamic
import groovy.transform.CompileStatic
import groovy.util.XmlSlurper
import java.io.FileInputStream
import java.security.Key
import java.security.KeyStore
import java.security.PrivateKey
import java.security.Security
import java.security.cert.CertStore
import java.security.cert.CertificateFactory
import java.security.cert.CollectionCertStoreParameters
import java.security.cert.X509Certificate
import java.util.ArrayList
import java.util.Date
import java.util.GregorianCalendar
import javax.xml.rpc.ParameterMode
import org.apache.commons.lang.WordUtils
import org.bouncycastle.cert.X509CertificateHolder
import org.bouncycastle.cert.jcajce.JcaCertStore
import org.bouncycastle.cert.jcajce.JcaX509CertificateHolder
import org.bouncycastle.cms.CMSProcessable
import org.bouncycastle.cms.CMSProcessableByteArray
import org.bouncycastle.cms.CMSSignedData
import org.bouncycastle.cms.CMSSignedDataGenerator
import org.bouncycastle.cms.CMSTypedData
import org.bouncycastle.cms.jcajce.JcaSignerInfoGeneratorBuilder
import org.bouncycastle.jce.provider.BouncyCastleProvider
import org.bouncycastle.openssl.PEMKeyPair
import org.bouncycastle.openssl.PEMParser
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter
import org.bouncycastle.operator.ContentSigner
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder
import org.bouncycastle.operator.jcajce.JcaDigestCalculatorProviderBuilder
import org.bouncycastle.util.Store
import org.bouncycastle.util.encoders.Base64
import org.joda.time.LocalDate
import org.joda.time.LocalDateTime
import org.joda.time.format.DateTimeFormat
import wslite.soap.SOAPClient
import wslite.soap.SOAPResponse
import wslite.soap.SOAPVersion

import com.zifras.AccessRulesService
import com.zifras.Estado
import com.zifras.Provincia
import com.zifras.cuenta.Actividad
import com.zifras.cuenta.CantidadImpuesto
import com.zifras.cuenta.Categoria
import com.zifras.cuenta.CondicionIva
import com.zifras.cuenta.Cuenta
import com.zifras.cuenta.CuentaService
import com.zifras.cuenta.Domicilio
import com.zifras.cuenta.Impuesto
import com.zifras.cuenta.PorcentajeActividadIIBB
import com.zifras.cuenta.TipoClave
import com.zifras.cuenta.TipoPersona
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.NotaCreditoCuenta
import com.zifras.facturacion.FacturaVenta
import com.zifras.facturacion.PuntoVenta
import com.zifras.facturacion.TipoComprobante
import com.zifras.notificacion.NotificacionService
import com.zifras.security.RegisterCommand

class AfipService {
	static final boolean estamosEnProduccion = ! grails.util.Environment.isDevelopmentMode()
	AccessRulesService accessRulesService
	def grailsApplication
	def notificacionService

	String invoke_wsaa (CMSSignedData LoginTicketRequest_xml_cms) {
		String mensaje_base64 = Base64.toBase64String(LoginTicketRequest_xml_cms.getEncoded())
		String xmlMessage = """<?xml version='1.0' encoding='UTF-8'?>
				   <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://services.authws.sua.dvadac.desein.afip.gov">
						<soapenv:Header/>
						<soapenv:Body>
							<ser:loginCms soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
								<request xsi:type="xsd:string">
									""" + mensaje_base64 + """
								</request>
							</ser:loginCms>
						</soapenv:Body>
					</soapenv:Envelope>"""

		String url = grailsApplication.config.getProperty('loginCmsAfip')
		SOAPClient client = new SOAPClient(url)
		SOAPResponse response = client.send(SOAPAction: url,
			xmlMessage
			)
		// println response.getBody()
		return response.getBody().toString()
	}

	@SuppressWarnings("unchecked")
	private static <T> T fromPem(String data) throws IOException {
		PEMParser parser = new PEMParser(new StringReader(data))
			return (T) parser.readObject()
	}

	// Create the CMS Message
	public static CMSSignedData create_cms (String p12file, String p12pass, String dstDN, String service, Long TicketTime) {
		// Create a keystore using keys from the pkcs#12 p12file
		KeyStore ks = KeyStore.getInstance("PKCS12")
		FileInputStream p12stream = new FileInputStream ( p12file ) 
		ks.load(p12stream, p12pass.toCharArray())
		p12stream.close()

		// Get Certificate & Private key from KeyStore
		PrivateKey privateKey = (PrivateKey) ks.getKey('1'/*signer*/, p12pass.toCharArray())
		X509Certificate signCert = (X509Certificate)ks.getCertificate('1')

		String LoginTicketRequest_xml = create_LoginTicketRequest(service, TicketTime)

		// Create CMS Message
		try {
			if (Security.getProvider("BC") == null) {
				Security.addProvider(new BouncyCastleProvider())
			}

			List<X509Certificate> certList = new ArrayList<X509Certificate>()
			CMSTypedData msg = new CMSProcessableByteArray(LoginTicketRequest_xml.getBytes(Charsets.UTF_8))

			certList.add(signCert)

			@SuppressWarnings("unchecked")
			Store<X509Certificate> certs = new JcaCertStore(certList)

			CMSSignedDataGenerator gen = new CMSSignedDataGenerator()
			ContentSigner signer = new JcaContentSignerBuilder(
					"SHA512withRSA")
					.setProvider("BC").build(privateKey)

			gen.addSignerInfoGenerator(new JcaSignerInfoGeneratorBuilder(
					new JcaDigestCalculatorProviderBuilder().setProvider(
							"BC").build()).build(signer, signCert))

			gen.addCertificates(certs)

			return gen.generate(msg, true)
		} 
		catch (Exception e) {
			println ""
			println "ERROR:"
			println e.message
			println e.stackTrace?.findAll{it.toString()?.with{contains(".groovy:") && ! toLowerCase().with{contains("transaction") || contains("springsecurity")}}}?.join("\n")
			println ""
		} 

		return null
	}

	// Create XML Message for AFIP wsaa
	public static String create_LoginTicketRequest (String service, Long TicketTime) {

		String LoginTicketRequest_xml

		Date GenTime = new Date()
		GregorianCalendar gentime = new GregorianCalendar()
		GregorianCalendar exptime = new GregorianCalendar()
		String UniqueId = new Long(new Double(GenTime.getTime() / 1000).longValue()).toString()

		exptime.setTime(new Date(GenTime.getTime()+TicketTime))

		XMLGregorianCalendarImpl XMLGenTime = new XMLGregorianCalendarImpl(gentime)
		XMLGregorianCalendarImpl XMLExpTime = new XMLGregorianCalendarImpl(exptime)

		LoginTicketRequest_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + "<loginTicketRequest version=\"1.0\">" + "<header>" + "<uniqueId>" + UniqueId + "</uniqueId>" + "<generationTime>" + XMLGenTime + "</generationTime>" + "<expirationTime>" + XMLExpTime + "</expirationTime>" + "</header>" + "<service>" + service + "</service>" + "</loginTicketRequest>"

		//System.out.println("TRA: " + LoginTicketRequest_xml)

		return (LoginTicketRequest_xml)
	}

	TokenAfip pedirToken(String servicio){
		// Hago el request y obtengo la respuesta:
		String pathCertificado = System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('certificadoAfip')
		String serialNumberAfip = grailsApplication.config.getProperty('serialNumberAfip')
		String nombreCertificado = estamosEnProduccion ? 'calim' : 'calim2021'
		def responseXml = invoke_wsaa( create_cms(pathCertificado , nombreCertificado, 'cn='+servicio+',o=' + nombreCertificado + ',c=ar,serialNumber='+serialNumberAfip, servicio, new Long("600000")) )
		// Parseo la respuesta y la guardo en la base de datos:
		TokenAfip respuestaParseada;
		TokenAfip.withNewSession {session ->
			respuestaParseada = new TokenAfip()
			respuestaParseada.xml = responseXml.replaceAll("&lt;", "<").replaceAll("&gt;", ">").replaceAll("&quot;", '"')
			respuestaParseada.save(flush:true, failOnError:true)

			def parseo = new XmlSlurper().parseText(respuestaParseada.xml)
			respuestaParseada.expiracion = parseo.header.expirationTime
			respuestaParseada.token = parseo.credentials.token
			respuestaParseada.sign = parseo.credentials.sign
			respuestaParseada.service = servicio
			respuestaParseada.save(flush:true, failOnError:true)
		}

		/*println """


		Token = """ + respuestaParseada.token

		println """


		sign = """ + respuestaParseada.sign

		println """


		expirationTime = """ + respuestaParseada.expiracion*/
		
		return respuestaParseada
	}

	RespuestaWsAfip consultarCuit(TokenAfip token, String cuitBuscado){
		String request = """<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
							xmlns:a5="http://a5.soap.ws.server.puc.sr/">
								<soapenv:Header/>
								<soapenv:Body>
									<a5:getPersona>
										<token>""" + token.token.trim() + """</token>
										<sign>""" + token.sign.trim() + """</sign>
										<cuitRepresentada>""" + grailsApplication.config.getProperty('serialNumberAfip').split()[1] + """</cuitRepresentada>
										<idPersona>""" + cuitBuscado + """</idPersona>
									</a5:getPersona>
								</soapenv:Body>
							</soapenv:Envelope>"""



		String serviceUrl = grailsApplication.config.getProperty('wsPadronA5Afip')
		SOAPClient cliente = new SOAPClient("${serviceUrl}")

		SOAPResponse afipResponse = cliente.send(SOAPAction: serviceUrl,
			request
			)

		RespuestaWsAfip respuesta = RespuestaWsAfip.findByServiceAndCuit(token.service,cuitBuscado)?: new RespuestaWsAfip()
		respuesta.xml = afipResponse.text
		respuesta.service = token.service
		respuesta.cuit = cuitBuscado
		respuesta.fechaHora = new LocalDateTime()
		return respuesta.save(flush:true, failOnError:true)
	}

	def obtenerDatosProveedor(String cuit){
		if (cuit.size() == 8){ // Si es un DNI, llamo a esta función para lo que espero que sea el cuit. Pruebo con hombre y si sale mal con mujer.
			try {
				return obtenerDatosProveedor(CuentaService.calcularCUIT(cuit,true))
			}
			catch(Exception e) {
				return obtenerDatosProveedor(CuentaService.calcularCUIT(cuit,false))
			}
		}
		def salida = [:]
		def parseo = obtenerRespuesta("ws_sr_padron_a5", cuit).parseoPersona
		if (parseo.errorConstancia.size()){
			salida.razonSocial = parseo.errorConstancia.apellido.toString().toLowerCase().capitalize()
			salida.localidad = ''
			salida.domicilio = ''
		}else{
			String nombre = WordUtils.capitalizeFully(parseo.datosGenerales.nombre.toString())
			String apellido = WordUtils.capitalizeFully(parseo.datosGenerales.apellido.toString())
			salida['razonSocial'] = parseo.datosGenerales.razonSocial.toString() ?: apellido + " " + nombre
			String provincia = parseo.datosGenerales.domicilioFiscal.descripcionProvincia.toString()
			String localidad = parseo.datosGenerales.domicilioFiscal.localidad.toString()
			salida['localidad'] = provincia + (localidad ? " - " + localidad : "")
			salida['domicilio'] = parseo.datosGenerales.domicilioFiscal.direccion.toString()
		}
		salida.provincia = parseo?.datosGenerales?.domicilioFiscal?.idProvincia?.with{
			Provincia.findByCodigoAfip(new Integer(it.toString()))
		}
		if(salida.provincia)
			salida['provinciaId'] = salida.provincia.id
		if (parseo.datosRegimenGeneral.size()){
			if (parseo.datosRegimenGeneral.impuesto?.find{it.idImpuesto == 32})
				salida['condicionIvaId'] = CondicionIva.findByNombre("Exento").id
			else
				salida['condicionIvaId'] = 11
		}
		else if (parseo.datosMonotributo.size())
			salida['condicionIvaId'] = 12
		else
			salida['condicionIvaId'] = 13
		return salida
	}

	public RegisterCommand llenarCommandRegistro(String cuit){
		RespuestaWsAfip respuesta = obtenerRespuesta("ws_sr_padron_a5", cuit)
		def parseo = respuesta.parseoPersona

		assert !(parseo.errorConstancia.size()) : "La constancia registra errores."
		assert !(parseo.errorRegimenGeneral.size()) : "El Régimen General registra errores."
		assert !(parseo.errorMonotributo.size()) : "El Régimen Monotributo registra errores."
		RegisterCommand command = new RegisterCommand()

		command.cuit = respuesta.cuit
		command.nombre = WordUtils.capitalizeFully(parseo.datosGenerales.nombre.toString())
		command.apellido = WordUtils.capitalizeFully(parseo.datosGenerales.apellido.toString())
		command.razonSocial = parseo.datosGenerales.razonSocial.toString() ?: command.apellido + " " + command.nombre
		command.tipo = (parseo.datosGenerales.tipoPersona.toString() == 'FISICA') ? 'Física' : 'Jurídica'
		String provincia = parseo.datosGenerales.domicilioFiscal.descripcionProvincia.toString()
		String localidad = parseo.datosGenerales.domicilioFiscal.localidad.toString()
		command.localidad = provincia + (localidad ? " - " + localidad : "")
		command.domicilio = parseo.datosGenerales.domicilioFiscal.direccion.toString()
		if (parseo.datosMonotributo.size()>0){
			command.tipoIva = 'Régimen Monotributo'
			// command.actividad = (Actividad.findByCodigoAfip(parseo.datosMonotributo.actividadMonotributista.idActividad.toString())?.descripcionAfip)?: 'No encontrada en el sistema.'
			command.actividad = parseo.datosMonotributo.actividadMonotributista.descripcionActividad.toString().toLowerCase().capitalize()
			command.categoria = parseo.datosMonotributo.categoriaMonotributo.descripcionCategoria.toString()
		}else{
			command.tipoIva = 'Régimen General'
			// command.actividad = (Actividad.findByCodigoAfip(parseo.datosRegimenGeneral.actividad.idActividad.toString())?.descripcionAfip)?: 'No encontrada en el sistema.'
			command.actividad = parseo.datosRegimenGeneral.actividad.descripcionActividad.toString().toLowerCase().capitalize()
		}

		if(parseo.datosRegimenGeneral.size()){
			command.impuestos = ""
			parseo.datosRegimenGeneral.impuesto.each{
				command.impuestos += "<br/>" + it.descripcionImpuesto.toString().toLowerCase().capitalize()
			}
		}
		command.idExistente = Cuenta.findByCuit(cuit)?.id

		return command
	}

	private RespuestaWsAfip obtenerRespuesta(String serviceUtilizado, String cuit){
		RespuestaWsAfip respuesta = RespuestaWsAfip.findByServiceAndCuit(serviceUtilizado, cuit)
		if ( estamosEnProduccion && respuesta?.expirada){
			respuesta.delete(flush:true)
			respuesta = null // Esto lo obliga a caer en el if de abajo
		}
		if (!respuesta){
			TokenAfip token = TokenAfip.findAllByService(serviceUtilizado).find {!it.expirado}
			if (!token)
				token = pedirToken(serviceUtilizado)
			respuesta = consultarCuit(token, cuit)
		}
		return respuesta
	}

	public guardarResponseEnCuenta(String cuit, Long cuentaId){
		llenarCuentaConResponse(cuit, cuentaId, true).save(flush:true,failOnError:true)
	}

	public Cuenta llenarCuentaConResponse(String cuit, Long cuentaId, boolean guardarColecciones){
		Cuenta cuenta = Cuenta.read(cuentaId)
		Estado estadoActivo = Estado.findByNombre('Activo')

		def parseo = obtenerRespuesta("ws_sr_padron_a5", cuit).parseoPersona
		cuenta.cuit = cuit

		Domicilio domFiscal = new Domicilio()
		domFiscal.codigoPostal = parseo.datosGenerales.domicilioFiscal.codPostal.toString()
		domFiscal.direccion = parseo.datosGenerales.domicilioFiscal.direccion.toString()
		String provinciaNombre = ''
		switch(parseo.datosGenerales.domicilioFiscal.descripcionProvincia.toString()) {
			case 'CIUDAD AUTONOMA BUENOS AIRES':
			default:
				provinciaNombre = 'CABA'
				break
		}

		// TODO: Condición IVA
		// TODO: Régimen IIBB
		domFiscal.provincia = Provincia.findByNombreIlike("%" + provinciaNombre + "%")
		domFiscal.localidad = parseo.datosGenerales.domicilioFiscal.localidad.toString()
		domFiscal.save(flush:true,failOnError:true)
		cuenta.domicilioFiscal = domFiscal

		cuenta.estadoClave = Estado.findByNombreIlike("%" + parseo.datosGenerales.estadoClave.toString() + "%")
		String contratoSocialString = parseo.datosGenerales.fechaContratoSocial.toString()
		if (contratoSocialString)
			cuenta.fechaContratoSocial = new LocalDate(contratoSocialString[0..9])
		if (parseo.datosGenerales.mesCierre.toString())
			cuenta.mesCierre = new Long(parseo.datosGenerales.mesCierre.toString())
		cuenta.razonSocial = parseo.datosGenerales.razonSocial.toString() ?: WordUtils.capitalizeFully(parseo.datosGenerales.apellido.toString() + " " + parseo.datosGenerales.nombre.toString())

		// Las siguientes líneas buscan en la clase según el string parseado. Si no encuentra coincidencias crean una nueva instancia pasándole al constructor de la clase el string parseado
			String tipoClaveString = parseo.datosGenerales.tipoClave.toString()
			cuenta.tipoClave = TipoClave.findByNombre(tipoClaveString)?: new TipoClave(nombre: tipoClaveString).save(flush:true)
			String tipoPersonaString = parseo.datosGenerales.tipoPersona.toString()
			cuenta.tipoPersona = TipoPersona.findByNombre(tipoPersonaString)?: new TipoPersona(nombre: tipoPersonaString).save(flush:true)

		if (parseo.datosMonotributo.size()){
			cuenta.condicionIva = CondicionIva.findByNombre('Monotributista')

			Double pocentajePromedio = (100.0 / new Double(parseo.datosMonotributo.actividadMonotributista.size())).round(2)
			parseo.datosMonotributo.actividadMonotributista.each{
				PorcentajeActividadIIBB actividad = new PorcentajeActividadIIBB()
				actividad.porcentaje = pocentajePromedio
				actividad.actividad = Actividad.findByCodigoAfip(it.idActividad.toString().padLeft(6,'0'))
				actividad.orden = new Long(it.orden.toString())
				actividad.monotributo = true
				actividad.estado = estadoActivo
				actividad.periodo = parsearFechaYYYYMM(it.periodo.toString())
				if (guardarColecciones)
					actividad.cuenta = cuenta
				cuenta.porcentajesActividadIIBB << actividad
			}

			if (parseo.datosMonotributo.categoriaMonotributo.size()){
				// Busco la categoría, si no la encuentro la creo
					String categoriaString = parseo.datosMonotributo.categoriaMonotributo.descripcionCategoria.toString()
					cuenta.categoriaMonotributo = Categoria.findByNombre(categoriaString)?: new Categoria(nombre: categoriaString).save(flush:true)
				cuenta.periodoMonotributo = parsearFechaYYYYMM(parseo.datosMonotributo.categoriaMonotributo.periodo.toString())
				cuenta.impuestoMonotributo = Impuesto.get(parseo.datosMonotributo.categoriaMonotributo.idImpuesto.toString())
			}

			parseo.datosMonotributo.impuesto.each{
				CantidadImpuesto cantidad = new CantidadImpuesto()
				cantidad.impuesto = Impuesto.get(it.idImpuesto.toString())
				cantidad.periodo = parsearFechaYYYYMM(it.periodo.toString())
				if (cantidad.impuesto.nombre == "MONOTRIBUTO")
					cuenta.fechaInicioActividades = cantidad.periodo
				cantidad.monotributo = true
				if (guardarColecciones)
					cantidad.cuenta = cuenta
				cuenta.impuestos << cantidad
			}
		}

		if (parseo.datosRegimenGeneral.size()){
			cuenta.condicionIva = CondicionIva.findByNombre('Responsable inscripto')
			Double pocentajePromedio = (100.0 / new Double(parseo.datosRegimenGeneral.actividad.size())).round(2)
			parseo.datosRegimenGeneral.actividad.each{
				PorcentajeActividadIIBB actividad = new PorcentajeActividadIIBB()
				actividad.porcentaje = pocentajePromedio
				actividad.actividad = Actividad.findByCodigoAfip(it.idActividad.toString().padLeft(6,'0'))
				actividad.orden = new Long(it.orden.toString())
				actividad.estado = estadoActivo
				actividad.periodo = parsearFechaYYYYMM(it.periodo.toString())
				if (guardarColecciones)
					actividad.cuenta = cuenta
				cuenta.porcentajesActividadIIBB << actividad
			}

			if (parseo.datosRegimenGeneral.categoriaAutonomo.size()){
				// Busco la categoría, si no la encuentro la creo
					String categoriaString = parseo.datosRegimenGeneral.categoriaAutonomo.descripcionCategoria.toString()
					cuenta.categoriaAutonomo = Categoria.findByNombre(categoriaString)?: new Categoria(nombre: categoriaString).save(flush:true)
				cuenta.periodoAutonomo = parsearFechaYYYYMM(parseo.datosRegimenGeneral.categoriaAutonomo.periodo.toString())
				cuenta.impuestoAutonomo = Impuesto.get(parseo.datosRegimenGeneral.categoriaAutonomo.idImpuesto.toString())
			}

			parseo.datosRegimenGeneral.impuesto.each{
				CantidadImpuesto cantidad = new CantidadImpuesto()
				cantidad.impuesto = Impuesto.get(it.idImpuesto.toString())
				cantidad.periodo = parsearFechaYYYYMM(it.periodo.toString())
				if (cantidad.impuesto.nombre == "MONOTRIBUTO AUTONOMO")
					cuenta.fechaInicioActividades = cantidad.periodo
				if (guardarColecciones)
					cantidad.cuenta = cuenta
				cuenta.impuestos << cantidad
			}
		}
		if (!(parseo.datosRegimenGeneral.size() || parseo.datosMonotributo.size()))
			cuenta.condicionIva = CondicionIva.findByNombre('Sin inscribir')
		cuenta.estado = estadoActivo
		cuenta.fechaConfirmacion = new LocalDateTime()
		return cuenta
	}

	private LocalDate parsearFechaYYYYMM(String fecha){
		return new LocalDate(fecha[0..3] + "-" + fecha[4..5] + "-01")
	}

	public String getResponseXML(String cuit){
		return (obtenerRespuesta("ws_sr_padron_a5", cuit).xml).replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll('"', "&quot;")
	}

	def obtenerCaeFactura(FacturaVenta factura){
		if (! estamosEnProduccion)
			return factura.with{
				cae = "666"
				vencimientoCae = new LocalDate()
				save(flush:true, failOnError:true)
			}
		def solicitud = enviarSolicitudCae(new SolicitudCaeCommand().with{
			cuitEmisor = factura.cuenta.cuit
			docTipoComprador = factura.cliente.tipoDocumentoAfip
			cuitComprador = factura.cliente.cuit
			cbteTipo = factura.tipoComprobante.codigoAfip
			puntoVenta = factura.puntoVenta.numero
			numeroComprobante = factura.numero
			fecha = factura.fecha.toString("yyyyMMdd")
			total = factura.total
			netoNoGravado = factura.netoNoGravado
			neto = factura.neto
			facturaId = factura.id
			exento = factura.exento
			totalIva = factura.iva

			switch(factura.concepto.nombre){
				case "Producto":
					concepto = "1"
					break;
				case "Servicio":
					concepto = "2"
					fechaInicioServicios = factura.fechaInicioServicios.toString("yyyyMMdd")
					fechaFinServicios = factura.fechaFinServicios.toString("yyyyMMdd")
					fechaVencimientoPagoServicio = factura.fechaVencimientoPagoServicio.toString("yyyyMMdd")
					break;
				case "Producto y Servicio":
					concepto = "3"
					fechaInicioServicios = factura.fechaInicioServicios.toString("yyyyMMdd")
					fechaFinServicios = factura.fechaFinServicios.toString("yyyyMMdd")
					fechaVencimientoPagoServicio = factura.fechaVencimientoPagoServicio.toString("yyyyMMdd")
					break;
			}
			if(factura.esNotaDeCredito()){
				def comp = factura.comprobantesAsociados[0]
				def fact = FacturaVenta.get(comp.comprobanteId)
				comprobanteAsociado = """<CbtesAsoc>
											<CbteAsoc>
												<Tipo>"""+fact.tipoComprobante?.codigoAfip+"""</Tipo>
												<PtoVta>"""+fact.puntoVenta.numero+"""</PtoVta>
												<Nro>"""+fact.numero+"""</Nro>
												<Cuit>"""+fact.cuenta.cuit+"""</Cuit>
												<CbteFch>"""+fact.fecha.toString("yyyyMMdd")+"""</CbteFch>
											</CbteAsoc>
										</CbtesAsoc>"""
			}
			if (totalIva){
				arrayAlicuotas = "<Iva>"
				factura.itemsFactura.findAll{it.alicuota.codigoAfip}.groupBy{it.alicuota.codigoAfip}.collect{key, value ->
					[key, value.sum{it.neto}, value.sum{it.iva}]
				}.each{
					arrayAlicuotas += "<AlicIva><Id>"+it[0]+"</Id><BaseImp>"+it[1]+"</BaseImp><Importe>"+it[2].round(2)+"</Importe></AlicIva>"
				}
				arrayAlicuotas += "</Iva>"
			}
			if(["201","211"].contains(factura.codigoComprobante)){
				opcionales = """<Opcionales>
									<Opcional>
										<Id>2101</Id>
										<Valor>"""+factura.cbuEmisor+"""</Valor>
									</Opcional>
									<Opcional>
										<Id>27</Id>
										<Valor>SCA</Valor>
									</Opcional>
								</Opcionales>"""
			}

			return it
		})

		return factura.with{
			cae = solicitud.cae
			vencimientoCae = solicitud.vencimiento
			save(flush:true, failOnError:true)
		}
	}

	def obtenerCaeFacturaExportacion(FacturaVenta factura){
		if (! estamosEnProduccion)
			return factura.with{
				cae = "666"
				vencimientoCae = new LocalDate()
				save(flush:true, failOnError:true)
			}
		def solicitud = enviarSolicitudCaeExportacion(new SolicitudCaeCommand().with{
			cuitEmisor = factura.cuenta.cuit
			docTipoComprador = factura.cliente.tipoDocumentoAfip
			cuitComprador = factura.cliente.cuit
			cbteTipo = factura.tipoComprobante.codigoAfip
			puntoVenta = factura.puntoVenta.numero
			numeroComprobante = factura.numero
			fecha = factura.fecha.toString("yyyyMMdd")
			total = factura.total
			netoNoGravado = factura.netoNoGravado
			neto = factura.neto
			facturaId = factura.id
			exento = factura.exento
			totalIva = factura.iva
			tipoExportacion = 2
			permisoExistente = null
			codigoPais = factura.codigoPais.codigoAfip
			cuitPais = factura.cuitPais[factura.tipoCuitPais]
			razonSocialComprador = factura.cliente.razonSocial
			domicilioComprador = factura.cliente.domicilio
			codigoMoneda = factura.moneda.codigoAfip
			cotizacionMoneda = factura.cotizacionMoneda
			codigoIdioma = factura.idioma.codigoAfip

			switch(factura.concepto.nombre){
				case "Producto":
					concepto = "1"
					break;
				case "Servicio":
					concepto = "2"
					fechaInicioServicios = factura.fechaInicioServicios.toString("yyyyMMdd")
					fechaFinServicios = factura.fechaFinServicios.toString("yyyyMMdd")
					fechaVencimientoPagoServicio = factura.fechaVencimientoPagoServicio.toString("yyyyMMdd")
					break;
				case "Producto y Servicio":
					concepto = "3"
					fechaInicioServicios = factura.fechaInicioServicios.toString("yyyyMMdd")
					fechaFinServicios = factura.fechaFinServicios.toString("yyyyMMdd")
					fechaVencimientoPagoServicio = factura.fechaVencimientoPagoServicio.toString("yyyyMMdd")
					break;
			}
			if(factura.esNotaDeCredito()){
				def comp = factura.comprobantesAsociados[0]
				def fact = FacturaVenta.get(comp.comprobanteId)
				comprobanteAsociado = """<Cmps_asoc>
											<Cmp_asoc>
												<Cbte_tipo>"""+fact.tipoComprobante?.codigoAfip+"""</Cbte_tipo>
												<Cbte_punto_vta>"""+fact.puntoVenta.numero+"""</Cbte_punto_vta>
												<Cbte_nro>"""+fact.numero+"""</Cbte_nro>
												<Cbte_cuit>"""+fact.cuenta.cuit+"""</Cbte_cuit>
											</Cmp_asoc>
										</Cmps_asoc>"""
			}
			itemsExportacion = ""
			factura.itemsFactura.each{
				itemsExportacion += """<Item>
								<Pro_ds>""" + it.concepto.nombre + """</Pro_ds>
								<Pro_umed>0</Pro_umed>
								<Pro_total_item>""" + it.total + """</Pro_total_item>
							</Item>"""
			}

			if (totalIva){
				arrayAlicuotas = "<Iva>"
				factura.itemsFactura.findAll{it.alicuota.codigoAfip}.groupBy{it.alicuota.codigoAfip}.collect{key, value ->
					[key, value.sum{it.neto}, value.sum{it.iva}]
				}.each{
					arrayAlicuotas += "<AlicIva><Id>"+it[0]+"</Id><BaseImp>"+it[1]+"</BaseImp><Importe>"+it[2].round(2)+"</Importe></AlicIva>"
				}
				arrayAlicuotas += "</Iva>"
			}
			return it
		})

		return factura.with{
			cae = solicitud.cae
			vencimientoCae = solicitud.vencimiento
			save(flush:true, failOnError:true)
		}
	}

	def solicitarCaeCalim(Long facturaId){
		FacturaCuenta factura = FacturaCuenta.get(facturaId)
		return factura ? solicitarCaeCalim(factura) : null
	}

	def solicitarCaeCalim(FacturaCuenta factura){
		if(!factura.reembolsada){
			if (factura.cae) // Nunca volvemos a facturar algo que ya tenga CAE
				return factura
		}
		else{
			if(factura.notaCredito)
				return factura
		}

		factura.cae = "Procesando..."
		factura.save(flush:true)
		boolean esMonotributo = factura.cuenta.condicionIva != null ? factura.cuenta.condicionIva.nombre == 'Monotributista' : true
		def codigoComprobanteAfip
		def codigoAfipFactura 
		if(factura.reembolsada)
			codigoAfipFactura = esMonotributo ? "8" /*Nota Credito B*/ : "3" /*Nota Credito A*/
		else
			codigoAfipFactura = esMonotributo ? "6" /*Factura B*/ : "1" /*Factura A*/

		def solicitud = enviarSolicitudCae(new SolicitudCaeCommand().with{
			total = factura.importe.round(2)
			if (factura.itemMensual?.servicio?.subcodigo == "2019_11" && esMonotributo){ // En teoría, los SE no pasan este check porque NULL != "2019_11"
				cuitEmisor = "20188404112"	// Ernesto Pavoni
				cbteTipo =  "11" // Factura C
				totalIva = 0
				neto = total
			}else{
				cuitEmisor = "30716783916"	// Calim
				cbteTipo = codigoAfipFactura
				neto = (total / 1.21).round(2)
				totalIva = (total - neto).round(2)
				arrayAlicuotas = "<Iva><AlicIva><Id>5</Id><BaseImp>"+neto+"</BaseImp><Importe>"+totalIva+"</Importe></AlicIva></Iva>" // Se informa al 21%
			}
			puntoVenta = "3" // Tanto Pavoni como Calim usan este PV
			if (factura.cuenta.with{estado.nombre == "Activo" && cuit != email}){
				docTipoComprador = "80" // Siempre los clientes tendrán CUIT
				cuitComprador = factura.cuenta.cuit
			}else{
				if(factura.reembolsada)
					cbteTipo = "8"
				else
					cbteTipo = "6"
				docTipoComprador = "99"
				cuitComprador = "0"
			}
			facturaId = factura.id
			numeroComprobante = getProximoNumero(puntoVenta, cbteTipo, cuitEmisor)
			fecha = new LocalDateTime().minusHours(3).toString("yyyyMMdd")
			netoNoGravado = 0
			exento = 0
			concepto = 2
			fechaInicioServicios = factura.fechaHora.minusMonths(1).withDayOfMonth(1).toString("yyyyMMdd")
			fechaFinServicios = factura.fechaHora.withDayOfMonth(1).minusDays(1).toString("yyyyMMdd")
			fechaVencimientoPagoServicio = new LocalDateTime().toString("yyyyMMdd")
			if(factura.reembolsada){
				def cuit = (factura.itemMensual?.servicio?.subcodigo == "2019_11" && esMonotributo) ? "20188404112" : "30716783916"
				comprobanteAsociado = """<CbtesAsoc>
											<CbteAsoc>
												<Tipo>"""+codigoAfipFactura+"""</Tipo>
												<PtoVta>"""+ 3 +"""</PtoVta>
												<Nro>"""+factura.numero+"""</Nro>
												<Cuit>"""+cuit+"""</Cuit>
												<CbteFch>"""+factura.fechaHora.toString("yyyyMMdd")+"""</CbteFch>
											</CbteAsoc>
										</CbtesAsoc>"""
				}
			return it
		})
		return factura.with{
			if(factura.reembolsada){
				def nota = new NotaCreditoCuenta()
				nota.cae = solicitud.cae
				nota.numero = solicitud.numeroComprobante
				nota.vencimientoCae = solicitud.vencimiento
				nota.fechaHora = new LocalDateTime().minusHours(3)
				nota.save(flush:true,failOnError:true)
				notaCredito = nota
			}else{
				cae = solicitud.cae
				numero = solicitud.numeroComprobante
				vencimientoCae = solicitud.vencimiento
			}
			save(flush:true, failOnError:true)
		}
	}

	private enviarSolicitudCae(SolicitudCaeCommand solicitud){ // Tira AssertionError si sale mal
		String requestBody = solicitud.with{
			return  """<FeCAEReq>
							<FeCabReq>
								<CantReg>1</CantReg>
								<PtoVta>""" + puntoVenta + """</PtoVta>
								<CbteTipo>""" + cbteTipo + """</CbteTipo>
							</FeCabReq>
							<FeDetReq>
								<FECAEDetRequest>
									<Concepto>""" + concepto + """</Concepto>
									<DocTipo>""" + docTipoComprador + """</DocTipo>
									<DocNro>""" + cuitComprador + """</DocNro>
									<CbteDesde>""" + numeroComprobante + """</CbteDesde>
									<CbteHasta>""" + numeroComprobante + """</CbteHasta>
									<CbteFch>""" + fecha + """</CbteFch>
									<ImpTotal>""" + total + """</ImpTotal>
									<ImpTotConc>""" + netoNoGravado + """</ImpTotConc>
									<ImpNeto>""" + neto + """</ImpNeto>
									<ImpOpEx>""" + exento +"""</ImpOpEx>
									<ImpTrib>0</ImpTrib>
									<ImpIVA>""" + totalIva + """</ImpIVA>
									<FchServDesde>""" + fechaInicioServicios + """</FchServDesde>
									<FchServHasta>""" + fechaFinServicios + """</FchServHasta>
									<FchVtoPago>""" + fechaVencimientoPagoServicio + """</FchVtoPago>
									<MonId>PES</MonId>
									<MonCotiz>1</MonCotiz>
									""" + comprobanteAsociado + """
									""" + arrayAlicuotas + """
									""" + opcionales + """
								</FECAEDetRequest>
							</FeDetReq>
						</FeCAEReq>"""
		}

		def afipResponseText = dispararServiceWsfe("FECAESolicitar", solicitud.cuitEmisor, requestBody)
		def respuesta = new XmlSlurper().parseText(afipResponseText).Body.FECAESolicitarResponse.FECAESolicitarResult
		String codigoErrorAfip
		String mensajeErrorAfip
		if (respuesta.Errors.size()){
			codigoErrorAfip = respuesta.Errors.Err.Code
			mensajeErrorAfip = respuesta.Errors.Err.Msg
		}else{
			respuesta = respuesta.FeDetResp.FECAEDetResponse
			if (respuesta.Resultado != 'R'){
				solicitud.cae = respuesta.CAE
				String vencimientoString = respuesta.CAEFchVto
				solicitud.vencimiento = LocalDate.parse(vencimientoString, DateTimeFormat.forPattern("yyyyMMdd"))
				return solicitud
			}else{
				codigoErrorAfip = respuesta.Observaciones.Obs.Code
				mensajeErrorAfip = respuesta.Observaciones.Obs.Msg
			}
		}
		if (codigoErrorAfip){
			String mensajeError = " No se pudo obtener CAE.\nError: #$codigoErrorAfip ($mensajeErrorAfip)\n"
			log.error(mensajeError)
			println "Respuesta Afip:\n"
			println afipResponseText + "\n\n"
			String mensajeInternoHtml = mensajeError
				mensajeInternoHtml += "\ncuitEmisor = " + solicitud.cuitEmisor
				mensajeInternoHtml += "\ndocTipoComprador = " + solicitud.docTipoComprador
				mensajeInternoHtml += "\ncuitComprador = " + solicitud.cuitComprador
				mensajeInternoHtml += "\ncbteTipo = " + solicitud.cbteTipo
				mensajeInternoHtml += "\npuntoVenta = " + solicitud.puntoVenta
				mensajeInternoHtml += "\nfecha = " + solicitud.fecha
				mensajeInternoHtml += "\ntotal = " + solicitud.total
				mensajeInternoHtml += "\nnetoNoGravado = " + solicitud.netoNoGravado
				mensajeInternoHtml += "\nneto = " + solicitud.neto
				mensajeInternoHtml += "\nexento = " + solicitud.exento
				mensajeInternoHtml += "\ntotalIva = " + solicitud.totalIva
				mensajeInternoHtml += "\nconcepto = " + solicitud.concepto
				mensajeInternoHtml += "\nfechaInicioServicios = " + solicitud.fechaInicioServicios
				mensajeInternoHtml += "\nfechaFinServicios = " + solicitud.fechaFinServicios
				mensajeInternoHtml += "\nfechaVencimientoPagoServicio = " + solicitud.fechaVencimientoPagoServicio
				mensajeInternoHtml += "\narrayAlicuotas = " + solicitud.arrayAlicuotas
				mensajeInternoHtml += "\n\n\nfacturaId = " + solicitud.facturaId
				mensajeInternoHtml += "\nnumeroComprobante = " + solicitud.numeroComprobante
			// notificacionService.enviarEmailInterno("franco@calim.com.ar", "Error facturando AFIP", mensajeInternoHtml.replaceAll("\n", "<br/>") , 'pagoConfirmado')
			assert false : (mensajeError + "finerror")
		}
	}

	private enviarSolicitudCaeExportacion(SolicitudCaeCommand solicitud){ // Tira AssertionError si sale mal
		String requestBody = solicitud.with{
			def solic = """	<Cmp>
							<Id>"""+ facturaId +"""</Id>
							<Fecha_cbte>""" + fecha + """</Fecha_cbte>
							<Cbte_Tipo>""" + cbteTipo + """</Cbte_Tipo>
							<Punto_vta>""" + puntoVenta + """</Punto_vta>
							<Cbte_nro>""" + numeroComprobante + """</Cbte_nro>
							<Tipo_expo>""" +  tipoExportacion+ """</Tipo_expo>
							<Permiso_existente></Permiso_existente>
							<Dst_cmp>""" + codigoPais + """</Dst_cmp>
							<Cliente>""" + razonSocialComprador + """</Cliente>
							<Cuit_pais_cliente>""" + cuitPais + """</Cuit_pais_cliente>
							<Domicilio_cliente>""" + domicilioComprador + """</Domicilio_cliente>
							<Moneda_Id>""" + codigoMoneda + """</Moneda_Id>
							<Moneda_ctz>""" + cotizacionMoneda + """</Moneda_ctz>
							<Imp_total>""" + total + """</Imp_total>
							""" + comprobanteAsociado + """
							<Idioma_cbte>""" + codigoIdioma + """</Idioma_cbte>
							<Items>""" + itemsExportacion + """</Items>"""

			if(cbteTipo == "19"){
				solic += """<Fecha_pago>""" + fecha + """</Fecha_pago>
							</Cmp>"""
			}else{
				solic += """</Cmp>"""
			}

			return solic
		}
		def afipResponseText = dispararServiceWsfex("FEXAuthorize", solicitud.cuitEmisor, requestBody)
		def respuesta = new XmlSlurper().parseText(afipResponseText).Body.FEXAuthorizeResponse.FEXAuthorizeResult
		println "Respuesta:"
		println respuesta
		String codigoErrorAfip
		String mensajeErrorAfip
		if (respuesta.FEXErr.ErrCode != "0"){
			println respuesta
			codigoErrorAfip = respuesta.FEXErr.ErrCode
			mensajeErrorAfip = respuesta.FEXErr.ErrMsg
		}else{
			respuesta = respuesta.FEXResultAuth
			if (respuesta.Resultado != 'R'){
				println respuesta
				solicitud.cae = respuesta.Cae
				String vencimientoString = respuesta.Fch_venc_Cae
				solicitud.vencimiento = LocalDate.parse(vencimientoString, DateTimeFormat.forPattern("yyyyMMdd"))
				return solicitud
			}else{
				codigoErrorAfip = "Error Factura Exportación"
				mensajeErrorAfip = respuesta.Motivos_Obs
			}
		}
		if (codigoErrorAfip){
			String mensajeError = " No se pudo obtener CAE.\nError: #$codigoErrorAfip ($mensajeErrorAfip)\n"
			log.error(mensajeError)
			println "Respuesta Afip:\n"
			println afipResponseText + "\n\n"
			String mensajeInternoHtml = mensajeError
				mensajeInternoHtml += "\ncuitEmisor = " + solicitud.cuitEmisor
				mensajeInternoHtml += "\ndocTipoComprador = " + solicitud.docTipoComprador
				mensajeInternoHtml += "\ncuitComprador = " + solicitud.cuitComprador
				mensajeInternoHtml += "\ncbteTipo = " + solicitud.cbteTipo
				mensajeInternoHtml += "\npuntoVenta = " + solicitud.puntoVenta
				mensajeInternoHtml += "\nfecha = " + solicitud.fecha
				mensajeInternoHtml += "\ntotal = " + solicitud.total
				mensajeInternoHtml += "\nnetoNoGravado = " + solicitud.netoNoGravado
				mensajeInternoHtml += "\nneto = " + solicitud.neto
				mensajeInternoHtml += "\nexento = " + solicitud.exento
				mensajeInternoHtml += "\ntotalIva = " + solicitud.totalIva
				mensajeInternoHtml += "\nconcepto = " + solicitud.concepto
				mensajeInternoHtml += "\nfechaInicioServicios = " + solicitud.fechaInicioServicios
				mensajeInternoHtml += "\nfechaFinServicios = " + solicitud.fechaFinServicios
				mensajeInternoHtml += "\nfechaVencimientoPagoServicio = " + solicitud.fechaVencimientoPagoServicio
				mensajeInternoHtml += "\narrayAlicuotas = " + solicitud.arrayAlicuotas
				mensajeInternoHtml += "\n\n\nfacturaId = " + solicitud.facturaId
				mensajeInternoHtml += "\nnumeroComprobante = " + solicitud.numeroComprobante
			//notificacionService.enviarEmailInterno("info@calim.com.ar", "Error facturando AFIP Exportación", mensajeInternoHtml.replaceAll("\n", "<br/>") , 'errorExportacion')
			assert false : (mensajeError + "finerror")
		}
	}


	def dispararServiceWsfe(String actionAfip, String cuit, String otrosParametros = ""){
		TokenAfip token = TokenAfip.findAllByService("wsfe").find {!it.expirado} ?: pedirToken("wsfe")

		String request = """<?xml version="1.0" encoding="utf-8"?>
							<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
							  <soap12:Body>
								<""" + actionAfip + """ xmlns="http://ar.gov.afip.dif.FEV1/">
								  <Auth>
									<Token>""" + token.token + """</Token>
									<Sign>""" + token.sign + """</Sign>
									<Cuit>""" + cuit + """</Cuit>
								  </Auth>
								  """ + otrosParametros + """
								</""" + actionAfip + """>
							  </soap12:Body>
							</soap12:Envelope>"""

		String serviceUrl = "https://" + (estamosEnProduccion ? "servicios1" : "wswhomo") + ".afip.gov.ar/wsfev1/service.asmx?op=" + actionAfip
		SOAPClient cliente = new SOAPClient("${serviceUrl}")
		SOAPResponse afipResponse = cliente.send(SOAPAction: serviceUrl, request)
		if (cuit == '27947942390'){
			println "DEBUG AFIP PARA 27947942390"
			println "\n"*3
			println "Request: $request"
			println "\n"*3
			println "Respuesta: ${afipResponse.text}"
			println "\n"*3
		}
		return afipResponse.text
	}

	def dispararServiceWsfex(String actionAfip, String cuit, String otrosParametros = ""){
		TokenAfip token = TokenAfip.findAllByService("wsfex").find {!it.expirado} ?: pedirToken("wsfex")

		String request = """<?xml version="1.0" encoding="utf-8"?>
							<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
							  <soap12:Body>
								<""" + actionAfip + """ xmlns="http://ar.gov.afip.dif.fexv1/">
								  <Auth>
									<Token>""" + token.token + """</Token>
									<Sign>""" + token.sign + """</Sign>
									<Cuit>""" + cuit + """</Cuit>"""

		if(actionAfip != "FEXGetLast_CMP")
			request += """</Auth>"""

		request += otrosParametros + """
					</""" + actionAfip + """>
				</soap12:Body>
			</soap12:Envelope>""" 

		String serviceUrl = "https://" + (estamosEnProduccion ? "servicios1" : "wswhomo") + ".afip.gov.ar/wsfexv1/service.asmx?op=" + actionAfip
		SOAPClient cliente = new SOAPClient("${serviceUrl}")
		SOAPResponse afipResponse = cliente.send(SOAPAction: serviceUrl, request)
		return afipResponse.text
	}

	def getPuntosDeVenta(Long cuentaId){ // Devuelve un array de Longs
		Cuenta cuenta = Cuenta.get(cuentaId)
		if (! estamosEnProduccion)
			return /*cuenta?.puntoVentaCalim ? */[666]/* : []*/
		def salida = []
		String cuit = cuenta?.cuit ?: ""
		def respuestaAfip = dispararServiceWsfe("FEParamGetPtosVenta", cuit)
		def respuesta = new XmlSlurper().parseText(respuestaAfip).Body.FEParamGetPtosVentaResponse.FEParamGetPtosVentaResult
		def respuestaAfipExportacion = dispararServiceWsfex("FEXGetPARAM_PtoVenta", cuit)
		def respuestaExportacion = new XmlSlurper().parseText(respuestaAfipExportacion).Body.FEXGetPARAM_PtoVentaResponse.FEXGetPARAM_PtoVentaResult
	
		if (respuesta.Errors.size()){
			def errorDiv = respuesta.Errors.Err
			if (errorDiv.Code != "600" && errorDiv.Code != "602")
				log.error(" No pudieron obtenerse puntos de venta para la cuenta " + cuit + ": #" + errorDiv.Code + "(" + errorDiv.Msg + ")\n")
		}else{
			respuesta.ResultGet.PtoVenta.each{
				if (it.FchBaja.toString() == "NULL")
					salida << new Long(it.Nro.toString())
			}
			respuestaExportacion.FEXResultGet.ClsFEXResponse_PtoVenta.each{
				if(it.Pve_FchBaja.toString() == "" || !it.Pve_FchBaja)
					salida << new Long(it.Pve_Nro.toString())
			}
		}
		return salida
	}

	def getProximoNumero(Long puntoVenta, Long tipoComprobanteId){
		getProximoNumero(puntoVenta.toString(), TipoComprobante.get(tipoComprobanteId).codigoAfip, accessRulesService.currentUser.cuenta.cuit)
	}

	def getProximoNumero(String puntoVenta, String codigoComprobante, String cuit){
		def respuesta
		String otrosParametros
		String numeroActual
		if(codigoComprobante != "19" && codigoComprobante != "21"){
			otrosParametros = """<PtoVta>""" + puntoVenta + """</PtoVta>
								  <CbteTipo>""" + codigoComprobante + """</CbteTipo>"""

			respuesta = dispararServiceWsfe("FECompUltimoAutorizado", cuit, otrosParametros)
			numeroActual = new XmlSlurper().parseText(respuesta).Body.FECompUltimoAutorizadoResponse.FECompUltimoAutorizadoResult.CbteNro
		}else{
			otrosParametros = """<Pto_venta>""" + puntoVenta + """</Pto_venta>
								  <Cbte_Tipo>""" + codigoComprobante + """</Cbte_Tipo>
								  </Auth>"""

			respuesta = dispararServiceWsfex("FEXGetLast_CMP", cuit, otrosParametros)
			numeroActual = new XmlSlurper().parseText(respuesta).Body.FEXGetLast_CMPResponse.FEXGetLast_CMPResult.FEXResult_LastCMP.Cbte_nro
		}
		Long proximo = new Long(numeroActual) + 1
		return String.format("%08d", proximo)
	}

	def obtenerCotizacionMoneda(String codigoMoneda, String cuit){
		def respuesta = dispararServiceWsfex("FEXGetPARAM_Ctz", cuit, codigoMoneda)
		def cotizacionStr = new XmlSlurper().parseText(respuesta).Body.FEXGetPARAM_CtzResponse.FEXGetPARAM_CtzResult.FEXResultGet.Mon_ctz

		return new Double(cotizacionStr.toString())
	}

}
