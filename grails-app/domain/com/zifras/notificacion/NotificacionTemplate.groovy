package com.zifras.notificacion


class NotificacionTemplate{

	String nombre
	String asuntoEmail
	String cuerpoEmail
	String tituloApp
	String textoApp

	 static constraints = {
	 	nombre nullable:false
	 	asuntoEmail nullable:false
	 	cuerpoEmail nullable:false
	 	tituloApp nullable:true
	 	textoApp nullable:true
	}

	static mapping = {
    	cuerpoEmail column: "cuerpo_email", sqlType: "text"
	}

	public String llenarVariablesBody(variables){
		String salida = this.cuerpoEmail
		return llenarVariables(salida,variables)
	}

	public String llenarVariablesAsunto(variables){
		String salida = this.asuntoEmail
		return llenarVariables(salida,variables)
	}

	public String llenarVariablesTituloApp(variables){
		String salida = this.tituloApp
		return llenarVariables(salida,variables)
	}

	public String llenarVariablesBodyApp(variables){
		String salida = this.textoApp
		return llenarVariables(salida,variables)
	}


	public String llenarVariables(String salida, variables){
		Integer i = 0
		String var
		variables.each{
			var = "{"+i+"}"
			salida = salida.replace(var,it)
			i++
		}
		return salida
	}
	
}