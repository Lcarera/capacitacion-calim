package com.zifras.ticket

class ElementoFaq {
	String titulo
	String contenidoHtml
	Long peso // Los elementos de peso más bajo aparecen arriba de los de peso más alto
	CategoriaFaq categoria
	boolean monotributista = true
	boolean respInscripto = true
	boolean regimenSimplificado = true
	boolean convenio = true
	boolean local = true
}