package com.zifras.selenium
import com.zifras.Auxiliar
import com.zifras.cuenta.Cuenta
import com.zifras.notificacion.NotificacionService
import com.zifras.AccessRulesService

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import org.joda.time.LocalDate

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'ROLE_SM', 'IS_AUTHENTICATED_FULLY'])
class SeleniumController {
	
}