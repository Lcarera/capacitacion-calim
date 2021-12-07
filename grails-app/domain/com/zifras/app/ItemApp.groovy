package com.zifras.app

import com.zifras.cuenta.Cuenta
import com.zifras.app.App
import grails.gorm.MultiTenant

class ItemApp implements MultiTenant<ItemApp>{
	Integer tenantId


	static belongsTo = [cuenta:Cuenta, app:App]

	public String toString(){return app.nombre}
}