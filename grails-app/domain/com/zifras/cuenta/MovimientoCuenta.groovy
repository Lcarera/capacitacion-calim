package com.zifras.cuenta

import com.zifras.documento.DeclaracionJurada
import com.zifras.documento.FacturaCuenta
import com.zifras.documento.PagoCuenta

import org.joda.time.LocalDateTime

import grails.gorm.MultiTenant
class MovimientoCuenta implements MultiTenant<MovimientoCuenta> {
	Integer tenantId
	LocalDateTime fechaHora
	String descripcion
	boolean positivo = true
	Double importe

	Double saldoAnterior
	Double saldo

	Long movimientoMPId

	FacturaCuenta factura // Genera mov. Negativo
	private PagoCuenta pago // Según la positividad del movimiento sabemos quién genera a quién
	DeclaracionJurada declaracion // Genera mov. Negativo

	static belongsTo = [cuenta:Cuenta]

	static constraints = {
		fechaHora nullable:false
		descripcion nullable:true
		importe nullable:false
		saldoAnterior nullable:false
		saldo nullable:false

		movimientoMPId nullable:true

		factura nullable:true
		pago nullable:true
		declaracion nullable:true
	}

	public String toString() {
		return "$tipo ${fechaHora.toString('dd/MM/yyyy')} \$$importe"
	}

	public PagoCuenta getPago(){
		return this.pago
	}

	public void setPago(PagoCuenta pagoNuevo){
		try {
			if (this.pago)
				this.pago.cancelar()
			this.pago = pagoNuevo
		}
		catch(Exception e) {
			log.error("Error intentando asignar un pago al movimiento ID ${this.id}.\nPago anterior: ${this.pago?.id}\nPago nuevo: ${this.pagoNuevo?.id}\nError: ${e.message}")
		}
	}

	public String getResponsable(){
		return this.factura?.responsable
	}

	public String getTipo() {
		if (this.factura){
			if(this.tituloMP[0..1] == "SM")
				return "Servicio Mensual Calim"
			return this.descripcion.replace(';',',')
		}
		if (this.declaracion?.liquidacionIva)
			return "IVA"
		if (this.declaracion?.liquidacionIibb)
			return "Ingresos Brutos"
		if (this.declaracion?.liquidacionGanancia)
			return "Ganancias"
		if (this.pago){
			if (this.reembolsado)
				return "Pago Reembolsado"
			return "Pago"
		}
		return "-"
	}

	public boolean getPagado(){ // Tener en cuenta que devuelve true para los positivos y reembolsados
		return ((this.importe?: 0) == 0 || this.pago?.estado?.with{nombre == 'Pagado' || nombre == 'Reembolsado'})
	}

	public boolean getReembolsado(){
		return this.pago?.estado?.nombre == 'Reembolsado'
	}

	public Double getImporteConSigno(){
		return positivo ? importe : importe*-1 
	}

	public String getDescripcionMP(){
		return campoMP(1)
	}

	public String getTituloMP(){
		return campoMP(0)
	}

	public String campoMP(Integer pos){
		def campo = ''
		if(this.factura){
			this.descripcion.split(' ; ').each{
					campo += it.split(' - ').size() > 1 ? (it.split(' - ')[pos]) + " " : it + " "
			}
		}
		else
			campo += this.descripcion
		return campo
	}
}
