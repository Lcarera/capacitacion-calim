package com.zifras.job

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
class DiarioJobService implements SchwartzJob {
	ServicioService servicioService

	void execute(JobExecutionContext context) throws JobExecutionException {
		grails.gorm.multitenancy.Tenants.withId(2) {
			servicioService.with{
				pagarServiciosEspeciales()
				LocalDate hoy = new LocalDate()
				switch(com.zifras.Estudio.get(2).diaFacturacionMensual){
					case fechaToDia(hoy):
						pagarServiciosMensuales()
						break
					case fechaToDia(hoy.minusDays(3)):
						enviarRecordatoriosMensuales(1,3)
						break
					case fechaToDia(hoy.minusDays(7)):
						enviarRecordatoriosMensuales(2,7)
						break
					case fechaToDia(hoy.minusDays(9)):
						enviarRecordatoriosMensuales(3,9)
						break
				}
				switch(fechaToDia(hoy)){ // Para instrucciones que se realizan solamente cierto día
					case 15:
						enviarRecordatoriosMoratoria("primerAviso")
						break
					case 19:
						enviarRecordatoriosCondicionIVA("Aviso Pago Monotributo", "Monotributista", 20)
						break
					case 23:
						generarDealsAvisoCobranza()
						break
					case 25:
						enviarRecordatoriosMoratoria("segundoAviso")
						cerrarMoratoriasVencidas()
						break
					case 28:
						eliminarContactosGoogleAntiguos()
						break
					case 1: //Programo envios de recordatorios para Autonomos segun tabla
						enviarRecordatoriosCondicionIVA("Aviso Pago Responsable Inscripto", "Responsable inscripto", 1)
						generarMailReporte(hoy.minusDays(1),true)
						break
				}
				

				/*switch(com.zifras.Estudio.get(2).diaFacturacionRappi){
					case fechaToDia(hoy):
						enviarRecordatoriosFacturacionApp()
				}*/
			}
		}
	}

	private Integer fechaToDia(LocalDate fecha){
		return new Integer(fecha.toString('dd'))
	}

	void buildTriggers() {
		triggers <<
			factory('Diario Job')
			.cronSchedule("0 0 10 1/1 * ? *")
			.build()

	}
}