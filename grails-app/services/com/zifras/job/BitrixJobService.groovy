package com.zifras.job

import com.zifras.cuenta.Cuenta
import com.zifras.BitrixService

import com.agileorbit.schwartz.SchwartzJob
import groovy.transform.CompileStatic
import groovy.util.logging.Slf4j
import org.joda.time.LocalDate
import org.quartz.JobExecutionContext
import org.quartz.JobExecutionException
import static org.quartz.DateBuilder.todayAt
import static org.quartz.DateBuilder.tomorrowAt	

@CompileStatic
@Slf4j
class BitrixJobService implements SchwartzJob {

	BitrixService bitrixService

	void execute(JobExecutionContext context) throws JobExecutionException {
		grails.gorm.multitenancy.Tenants.withId(2) {
			LocalDate hoy = new LocalDate()
			println "Actualizando refresh token Bitrix..."
			bitrixService.actualizarRefreshToken()
		}
	}

	void buildTriggers() {
		triggers <<
			factory('Bitrix Job')
			.cronSchedule("0 15 10 ? * SUN")
			.build()

	}
}