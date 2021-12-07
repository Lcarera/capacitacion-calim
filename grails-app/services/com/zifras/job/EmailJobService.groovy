package com.zifras.job

import com.agileorbit.schwartz.SchwartzJob
import org.joda.time.LocalDateTime
import groovy.transform.CompileStatic
import groovy.util.logging.Slf4j
import org.quartz.JobExecutionContext
import org.quartz.JobExecutionException
import static org.quartz.DateBuilder.todayAt
import static org.quartz.DateBuilder.tomorrowAt
import com.zifras.notificacion.NotificacionService

@CompileStatic
@Slf4j
class EmailJobService implements SchwartzJob {
	NotificacionService notificacionService

	void execute(JobExecutionContext context) throws JobExecutionException {
		grails.gorm.multitenancy.Tenants.withId(2) {
	    	notificacionService.enviarEmailProgramados()
	    }
	}

	void buildTriggers() {
	    
	    triggers <<
	        factory('Email Jobs every 10 seconds')
	        .intervalInSeconds(120)
	        .build()
	}
}