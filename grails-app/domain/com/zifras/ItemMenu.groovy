package com.zifras

import com.zifras.Role

import grails.gorm.MultiTenant

class ItemMenu implements MultiTenant<Localidad> {
	Integer tenantId
	Role role
	String tipo = ''
	
	String nombre =''
	String icono = ''
	
	String controller = ''
	String action = ''
	
	Long orden
	
	ItemMenu padre
	static hasMany = [hijos: ItemMenu]
	static mappedBy = [hijos: 'padre']
	
	//Esto devuelve el nodo padre del Arbol
	def public ItemMenu getRootNode(){
		if(padre){
			return padre.getRootNode()	
		}else{
			return this
		}		
	}
	
	def public boolean esHoja(){
		return hijos.isEmpty()
	}
	
	def public boolean isControllerInSun(String controller){
		boolean respuesta = false
		hijos.each{
			if(it.esHoja()){
				if(it.controller?.toLowerCase() == controller.toLowerCase())
					respuesta = true
			}else{
				respuesta = it.isControllerInSun(controller)
			}
		}
		
		return respuesta
	}
	
    static constraints = {
		role nullable:false
		tipo nullable:false
		
		nombre nullable:true
		icono nullable:true
		
		controller nullable:true
		action nullable:true
		
		padre nullable:true
    }
	
	static mapping = {
		hijos sort: "orden"
	}
}
