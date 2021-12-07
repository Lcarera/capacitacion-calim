package com.zifras.importacion

import org.joda.time.LocalDate
import com.zifras.cuenta.Cuenta

class LogSelenium {
	LogSelenium(Cuenta cuenta, LocalDate mes){
		this.cuenta = cuenta
		this.mes = mes
	}
	LocalDate mes

	// Etapa 1
	Boolean comprobantes
	Boolean afipRetenciones
	Boolean afipPercepciones
	Boolean arbaRetenciones
	Boolean arbaPercepciones
	Boolean arbaBancarias
	Boolean agipRetenciones
	Boolean agipPercepciones
	Boolean agipBancarias
	Boolean convenioRetenciones

	String errorAfip
	String errorArba
	String errorConvenioRetenciones
	String errorAgip

	Boolean etapa1

	public boolean calcularEtapa1(){
		if (errorAfip || errorArba || errorAgip)
			return false
		if (!(comprobantes))
			return false
		if (!(cuenta.condicionIva.nombre == "Monotributista" || (afipRetenciones && afipPercepciones)))
			return false
		if (!(cuenta.regimenIibb.nombre != "Sicol" || (agipRetenciones && agipPercepciones)))
			return false
		if (!(cuenta.regimenIibb.nombre != "B.A. Mensual" || (arbaRetenciones && arbaPercepciones)))
			return false
		if (!(cuenta.regimenIibb.nombre != "Convenio Multilateral" || (convenioRetenciones)))
			return false
		return true
	}

	// Etapa 2
	Boolean precargaIva
	Boolean precargaIvaDdjj
	Boolean precargaAgip
	Boolean precargaArba
	Boolean precargaConvenio

	String errorIva
	String errorIvaDdjjPrecarga
	String errorIibb

	Boolean etapa2

	public boolean calcularEtapa2(){
		return false
		if (errorIva || errorIibb || errorDdjjIva)
			return false
		if (!(cuenta.condicionIva.nombre == "Monotributista" || (precargaIva && precargaIvaDdjj)))
			return false
		if (cuenta.regimenIibb.nombre == "Sicol" && precargaAgip)
			return true
		if (cuenta.regimenIibb.nombre == "B.A. Mensual" || precargaArba)
			return true
		return false
	}

	// Etapa 3
	Boolean ddjjIva
	Boolean ddjjIibb
	Boolean vepIva
	Boolean vepIibb
	Boolean etapa3
	String errorDdjjIva
	String errorDdjjIibb
	String errorVepIva
	String errorVepIibb

	static belongsTo = [cuenta:Cuenta]

	static constraints = {
		mes nullable:false, unique: 'cuenta'

		comprobantes nullable:true
		afipRetenciones nullable:true
		afipPercepciones nullable:true
		arbaRetenciones nullable:true
		arbaPercepciones nullable:true
		agipRetenciones nullable:true
		agipPercepciones nullable:true
		arbaBancarias nullable:true
		agipBancarias nullable:true
		convenioRetenciones nullable:true
		errorConvenioRetenciones nullable:true
		errorAfip nullable:true
		errorArba nullable:true
		errorAgip nullable:true
		etapa1 nullable:true
		precargaIva nullable:true
		precargaIvaDdjj nullable:true
		precargaAgip nullable:true
		precargaArba nullable:true
		precargaConvenio nullable:true
		errorIibb nullable:true
		errorIva nullable:true
		errorIvaDdjjPrecarga nullable:true
		etapa2 nullable:true
		ddjjIva nullable:true
		ddjjIibb nullable:true
		vepIva nullable:true
		vepIibb nullable:true
		errorVepIva nullable:true
		errorVepIibb nullable:true
		errorDdjjIva nullable:true
		errorDdjjIibb nullable:true
		etapa3 nullable:true
	}
}
