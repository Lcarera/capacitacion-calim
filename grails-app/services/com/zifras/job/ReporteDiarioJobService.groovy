package com.zifras.job

import com.zifras.cuenta.Cuenta
import com.zifras.servicio.ServicioService

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
class ReporteDiarioJobService implements SchwartzJob {

	ServicioService servicioService

	void execute(JobExecutionContext context) throws JobExecutionException {
		grails.gorm.multitenancy.Tenants.withId(2) {
			LocalDate hoy = new LocalDate()
			println "Iniciando Reporte Diario..."
			servicioService.generarMailReporte(hoy.minusDays(1),false)
		}
	}

	void buildTriggers() {
		triggers <<
			factory('Mail Reporte Diario')
			.cronSchedule("0 0 3 * * ?")
			.build()
	}
}