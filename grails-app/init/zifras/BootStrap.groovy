package zifras

import com.zifras.inicializacion.Inicializacion
import com.zifras.inicializacion.JsonInicializacion

class BootStrap {

    def init = { servletContext ->
		environments {
			development {
				initDevelopmentData()
			}
			production {
				initProductionData()
			}
		}
		
		JsonInicializacion.inicializar()
    }
	
	def initProductionData(){
		Inicializacion.comienzo()
	}
	
	def initDevelopmentData(){
		Inicializacion.comienzo()
	}
	
    def destroy = {
    }
}
