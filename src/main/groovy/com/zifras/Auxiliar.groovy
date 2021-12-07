package com.zifras

import com.zifras.inicializacion.JsonInicializacion
import org.joda.time.LocalDateTime
class Auxiliar {

	public static String formatear(numero){
		return JsonInicializacion.formatear(numero) // Estas dos por ahora las tomo del JsonInicialización porque me parece que, como ahí el DecimalFormal queda inicializado y guardado, es más performante no hacerlo muchas veces.
	}

	public static String formatearSinPunto(numero){
		return JsonInicializacion.formatearSinPunto(numero) // Estas dos por ahora las tomo del JsonInicialización porque me parece que, como ahí el DecimalFormal queda inicializado y guardado, es más performante no hacerlo muchas veces.
	}

	public static String mapEnDatatable(headers,map){
		boolean filaPar = false
		String texto = """<style>
			table {-webkit-text-size-adjust:100%;-webkit-tap-highlight-color:transparent;font-weight:400;line-height:1.5;font-size:.875em;color:#353c4e;font-family:"Open Sans",sans-serif;box-sizing:inherit;background-color:transparent;border:1px solid #e9ecef;clear:both;max-width:none!important;border-collapse:collapse!important;border-top:none;margin-top:0!important;margin-bottom:0!important;width:100%}
			thead {-webkit-text-size-adjust: 100%;-webkit-tap-highlight-color: transparent;font-weight: 400;line-height: 1.5;font-size: 0.875em;color: #353c4e;font-family: "Open Sans", sans-serif;border-collapse: collapse !important;box-sizing: inherit;}
			thead tr {-webkit-text-size-adjust: 100%;-webkit-tap-highlight-color: transparent;font-weight: 400;line-height: 1.5;font-size: 0.875em;color: #353c4e;font-family: "Open Sans", sans-serif;border-collapse: collapse !important;box-sizing: inherit;}
			thead th {-webkit-text-size-adjust: 100%;-webkit-tap-highlight-color: transparent;line-height: 1.5;font-size: 0.875em;color: #353c4e;font-family: "Open Sans", sans-serif;border-collapse: collapse !important;text-align: left;padding: .75rem;border: 1px solid #e9ecef;vertical-align: bottom;border-bottom: 2px solid #e9ecef;border-bottom-width: 2px;box-sizing: content-box;border-bottom-color: #ccc;white-space: nowrap;cursor: pointer;position: relative;border-left-width: 0;padding-right: 30px;width: 458.867px;}
			tbody {-webkit-text-size-adjust:100%;-webkit-tap-highlight-color:transparent;font-weight:400;line-height:1.5;font-size:.875em;color:#353c4e;font-family:"Open Sans",sans-serif;border-collapse:collapse!important;box-sizing:inherit}
			tbody tr {-webkit-text-size-adjust: 100%;-webkit-tap-highlight-color: transparent;font-weight: 400;line-height: 1.5;font-size: 0.875em;color: #353c4e;font-family: "Open Sans", sans-serif;border-collapse: collapse !important;box-sizing: inherit;}
			tbody td {-webkit-text-size-adjust: 100%;-webkit-tap-highlight-color: transparent;font-weight: 400;line-height: 1.5;font-size: 0.875em;color: #353c4e;font-family: "Open Sans", sans-serif;border-collapse: collapse !important;padding: .75rem;vertical-align: top;border: 1px solid #e9ecef;box-sizing: content-box;white-space: nowrap;border-left-width: 0;border-bottom-width: 0;}
		</style>
		<table>
			<thead>
				<tr>"""
		texto += "<th>" + headers.join("</th><th>") + "</th>"
		texto += "</thead><tbody>"
		texto += map.collect{
			String estilo = filaPar ? '' : 'background-color: rgba(0,0,0,.05);'
			filaPar = !filaPar
			"<tr style='$estilo'>" +
				"<td>" + it.collect{it.value}.join("</td><td>") + "</td>" +
			"</tr>"
		}.join("")
		return texto + "</tbody></table>"
	}

	public static subdividirLista(Object lista, int cant){
		def lista_sep = lista.collate((int) java.lang.Math.ceil(lista.size() / cant))
		// if (lista_sep.size() != cant)
			// lista_sep[-2] = lista_sep[-2] + lista_sep.removeLast()
		return lista_sep
	}

	public static void printHora(String mensaje){
		println "				" + new LocalDateTime() + " ($mensaje)"
	}
}
