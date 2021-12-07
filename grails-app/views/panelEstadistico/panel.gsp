<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>
<body>	
<div style="display: none;">

</div>

<div class="main-body">
	
	<div class="page-wrapper">		
		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<h3>Servicios Mensuales:</h3>
				</br>
					<canvas id="chartServiciosMensuales" width="200" height="100"></canvas>
				</br>
			</div>
		</div>
		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<div id="block" style="text-align: left;">
						<div id="d1" style="display: inline-block;">
							<h3>Servicios Especiales: &nbsp</h3>
						</div>
						<div id="d2" style="display: inline-block;">
							<label style="margin-right: 10px">
			   	            	<input class="form-control" type="radio" name="responsable" id="todos" value="todos" checked="true">Todos
			    	        </label>
							<g:each in="${vendedores}">
				    	        <label style="margin-right: 10px">
				   	            	<input class="form-control" type="radio" name="responsable" id="${it.nombre}" value="${it.nombre}">${it.nombre}
				    	        </label>
			    	      	</g:each>
	    	      		</div>
	    	    	</div>
					</br>
					<canvas id="chartServiciosEspeciales" width="200" height="100"></canvas>
					</br>
					<g:each in="${vendedores}">
						<div id="div${it.nombre}">
							<p id="p${it.nombre}">
						</div>
					</g:each>
					<h3>Tasa de efectividad:</h3>
					</br>
					<canvas id="chartTasaEfectividadSE" width="200" height="100"></canvas>
					</br>
					</br>
				</div>
			</div>
		</div>
		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<h3>Registro:</h3>
					</br>
					<canvas id="chartRegistro" width="200" height="100"></canvas>
					</br>
					</br>
					<h3>Registro Tienda Nube:</h3>
					</br>
					<canvas id="chartRegistroTiendaNube" width="200" height="100"></canvas>
					</br>
					</br>
					<h3>Registro Delivery:</h3>
					</br>
					<canvas id="chartRegistroDelivery" width="200" height="100"></canvas>
				</div>
			</div>
		</div>
		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<h3> Contactos: </h3>
					</br>
					<canvas id="chartContactos" width="200" height="100"></canvas>
				</div>
			</div>
		</div>
		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<h3> Usuarios registrados: </h3>
					</br>
					</br>
					<h5>-Activos: ${cantidadUsuariosActivos}</h5>
					</br>
					<h5>-App descargada: ${cantidadUsuariosConApp}</h5>
					</br>
					<h5>-Tienda Nube: ${cantidadUsuariosTiendaNube}</h5>
					</br>
					<h5>-Delivery: ${cantidadUsuariosDelivery}</h5>
				</div>
			</div>
		</div>
	</div>
</div>

<g:hiddenField name="periodoAnual" id="periodoAnual" value="${periodoAnual}"/>
<g:hiddenField name="datosServiciosMensuales" id="datosServiciosMensuales" value="${datosServiciosMensuales}"/>
<g:hiddenField name="datosServiciosEspeciales" id="datosServiciosEspeciales" value="${datosServiciosEspeciales}"/>
<g:hiddenField name="nombresVendedores" id="nombresVendedores" value="${nombresVendedores}"/>
<g:hiddenField name="datosRegistro" id="datosRegistro" value="${datosRegistro}"/>
<g:hiddenField name="datosRegistroTiendaNube" id="datosRegistroTiendaNube" value="${datosRegistroTiendaNube}"/>
<g:hiddenField name="datosRegistroDelivery" id="datosRegistroDelivery" value="${datosRegistroDelivery}"/>
<g:hiddenField name="datosContactos" id="datosContactos" value="${datosContactos}"/>
<g:hiddenField name="cantidadUsuariosConApp" id="cantidadUsuariosConApp" value="${cantidadUsuariosConApp}"/>


<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
<script type="text/javascript">

	var ctx = document.getElementById('chartServiciosMensuales').getContext('2d');
	var chartSM = new Chart(ctx, {
	    type: 'bar',
	    data: {
	        labels: getPeriodoAnual(),
	        datasets: [{
	            label: 'SM01-R.I.IIBB Local',
	            data: getDataServicios("SM01",true).map(p => p.pagados),
	            backgroundColor: 'rgba(32, 158, 162, 0.4)',
	            borderColor: 'rgba(32, 158, 162, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM02-R.I.Conv',
	            data: getDataServicios("SM02",true).map(p => p.pagados),
	            backgroundColor: 'rgba(60, 60, 162, 0.4)',
	            borderColor: 'rgba(60, 60, 162, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM03-Mono.Simpl',
	            data: getDataServicios("SM03",true).map(p => p.pagados),
	            backgroundColor: 'rgba(0, 177, 106, 0.4)',
	            borderColor: 'rgba(0, 177, 106, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM04-Mono.IIBB Local',
	            data: getDataServicios("SM04",true).map(p => p.pagados),
	            backgroundColor: 'rgba(140, 0, 0, 0.4)',
	            borderColor: 'rgba(140, 0, 0, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM05-Mono.Conv',
	            data: getDataServicios("SM05",true).map(p => p.pagados),
	            backgroundColor: 'rgba(245, 230, 83, 0.4)',
	            borderColor: 'rgba(245, 230, 83, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM06-R.I.Conv',
	            data: getDataServicios("SM06",true).map(p => p.pagados),
	            backgroundColor: 'rgba(32, 0, 0, 0.4)',
	            borderColor: 'rgba(32, 0, 0, 100)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM07-Delivery',
	            data: getDataServicios("SM07",true).map(p => p.pagados),
	            backgroundColor: 'rgba(0, 100, 162, 0.4)',
	            borderColor: 'rgba(0, 100, 162, 1)',
	            borderWidth: 2
	        },
	        { label: 'SM01 Enviados',
	            data: getDataServicios("SM01",true).map(p => p.cantidad),
	            hidden: true,
	            backgroundColor: 'rgba(32, 158, 162, 0.1)',
	            borderColor: 'rgba(32, 158, 162, 0.3)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM02 Enviados',
	            data: getDataServicios("SM02",true).map(p => p.cantidad),
	            hidden: true,
	            backgroundColor: 'rgba(60, 60, 162, 0.1)',
	            borderColor: 'rgba(60, 60, 162, 0.3)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM03 Enviados',
	            data: getDataServicios("SM03",true).map(p => p.cantidad),
	            hidden: true,
	            backgroundColor: 'rgba(0, 177, 106, 0.1)',
	            borderColor: 'rgba(0, 177, 106, 0.3)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM04 Enviados',
	            data: getDataServicios("SM04",true).map(p => p.cantidad),
	            hidden: true,
	            backgroundColor: 'rgba(140, 0, 0, 0.1)',
	            borderColor: 'rgba(140, 0, 0, 0.3)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM05 Enviados',
	            data: getDataServicios("SM05",true).map(p => p.cantidad),
	            hidden: true,
	            backgroundColor: 'rgba(245, 230, 83, 0.1)',
	            borderColor: 'rgba(245, 230, 83, 0.3)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM06 Enviados',
	            data: getDataServicios("SM06",true).map(p => p.cantidad),
	            hidden: true,
	            backgroundColor: 'rgba(32, 0, 0, 0.1)',
	            borderColor: 'rgba(32, 0, 0, 0.3)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SM07 Enviados',
	            data: getDataServicios("SM07",true).map(p => p.cantidad),
	            hidden: true,
	            backgroundColor: 'rgba(0, 100, 162, 0.1)',
	            borderColor: 'rgba(0, 100, 162, 0.3)',
	            borderWidth: 2
	        }]
	    },
	    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero: true,
	                    min:0,
	                    callback: function(value, index, values) {
			                if (Math.floor(value) === value) {
			                    return value;
			                }
			            }
	                }
	            }]
	        }
	    }
	});

	var ctx3 = document.getElementById('chartServiciosEspeciales').getContext('2d');
	var chartServiciosEspeciales = new Chart(ctx3, {
	    type: 'bar',
	    data: {
	        labels: getPeriodoAnual(),
	        datasets: [{
	        	label: 'SE00-Presentación DDJJ',
	            data: getDataPerformanceVendedor("SE00",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(32, 158, 162, 0.3)',
	            borderColor: 'rgba(32, 158, 162, 1)',
	            borderWidth: 2
	        },{
	            label: 'SE01-Moratoria',
	            data: getDataPerformanceVendedor("SE01",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(245, 230, 83, 0.3)',
	            borderColor: 'rgba(245, 230, 83, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE02-Moratoria Ejec. Fiscal',
	            data: getDataPerformanceVendedor("SE02",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(60, 60, 162, 0.3)',
	            borderColor: 'rgba(60, 60, 162, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE03-Alta AFIP',
	            data: getDataPerformanceVendedor("SE03",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(0, 100, 0, 0.3)',
	            borderColor: 'rgba(0, 100, 0, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE04-Alta Rentas IIBB',
	            data: getDataPerformanceVendedor("SE04",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(140, 0, 0, 0.3)',
	            borderColor: 'rgba(140, 0, 0, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE05-Constitución domicilio',
	            data: getDataPerformanceVendedor("SE05",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(248, 148, 6, 0.3)',
	            borderColor: 'rgba(248, 148, 6, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE06-Baja Monotrib.',
	            data: getDataPerformanceVendedor("SE06",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(32, 0, 0, 0.3)',
	            borderColor: 'rgba(32, 0, 0, 100)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE07-Baja IIBB',
	            data: getDataPerformanceVendedor("SE07",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(219, 10, 91, 0.3)',
	            borderColor: 'rgba(219, 10, 91, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE08-Conv.Multilateral',
	            data: getDataPerformanceVendedor("SE08",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(0, 100, 162, 0.3)',
	            borderColor: 'rgba(0, 100, 162, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE09-Alta AFIP + Alta IIBB',
	            data: getDataPerformanceVendedor("SE09",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(0, 230, 64, 0.3)',
	            borderColor: 'rgba(0, 230, 64, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE10-Generación VEP',
	            data: getDataPerformanceVendedor("SE10",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(171, 183, 183, 0.3)',
	            borderColor: 'rgba(171, 183, 183, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE00 Enviados',
	            data: getDataPerformanceVendedor("SE00",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(32, 158, 162, 0.1)',
	            borderColor: 'rgba(32, 158, 162, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },{
	            label: 'SE01 Enviados',
	            data: getDataPerformanceVendedor("SE01",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(245, 230, 83, 0.1)',
	            borderColor: 'rgba(245, 230, 83, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE02 Enviados',
	            data: getDataPerformanceVendedor("SE02",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(60, 60, 162, 0.1)',
	            borderColor: 'rgba(60, 60, 162, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE03 Enviados',
	            data: getDataPerformanceVendedor("SE03",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(0, 100, 0, 0.1)',
	            borderColor: 'rgba(0, 100, 0, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE04 Enviados',
	            data: getDataPerformanceVendedor("SE04",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(140, 0, 0, 0.1)',
	            borderColor: 'rgba(140, 0, 0, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE05 Enviados',
	            data: getDataPerformanceVendedor("SE05",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(248, 148, 6, 0.1)',
	            borderColor: 'rgba(248, 148, 6, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE06 Enviados',
	            data: getDataPerformanceVendedor("SE06",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(32, 0, 0, 0.1)',
	            borderColor: 'rgba(32, 0, 0, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE07 Enviados',
	            data: getDataPerformanceVendedor("SE07",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(219, 10, 91, 0.1)',
	            borderColor: 'rgba(219, 10, 91, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE08 Enviados',
	            data: getDataPerformanceVendedor("SE08",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(0, 100, 162, 0.1)',
	            borderColor: 'rgba(0, 100, 162, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE09 Enviados',
	            data: getDataPerformanceVendedor("SE09",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(0, 230, 64, 0.1)',
	            borderColor: 'rgba(0, 230, 64, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE10-Enviados',
	            data: getDataPerformanceVendedor("SE10",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(171, 183, 183, 0.1)',
	            borderColor: 'rgba(171, 183, 183, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        }]
	    },
	    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero: true,
	                    min:0,
	                    callback: function(value, index, values) {
			                if (Math.floor(value) === value) {
			                    return value;
			                }
			            }
	                }
	            }]
	        }
	    }
	});

var ctx2 = document.getElementById('chartTasaEfectividadSE').getContext('2d');
	var chartTasaEfectividadSE = new Chart(ctx2, {
	    type: 'line',
	    data: {
	        labels: getPeriodoAnual(),
	        datasets: [{
	        	label: 'SE Enviados / SE Vendidos',
	            data: tasasEfectividadServicios(false),
	            backgroundColor: 'rgba(255, 255, 255, 0)',
	            borderColor: 'rgba(32, 158, 162, 1)',
	            borderWidth: 2
	        }]
	    },
	    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero: true,
	                    min:0,
	                    callback: function(value, index, values) {
			                if (Math.floor(value) === value) {
			                    return value + ' %';
			                }
			            }
	                }
	            }]
	        }
	    }
	});

	
	var ctx4 = document.getElementById('chartRegistro').getContext('2d');
	var chartRegistro = new Chart(ctx4, {
	    type: 'bar',
	    data: {
	        labels: getPeriodoAnual(),
	        datasets: [{
	            label: 'Confirmación Email',
	            data: getDataRegistro("confirmacionEmail","#datosRegistro"),
	            backgroundColor: 'rgba(240, 52, 52, 0.3)',
	            borderColor: 'rgba(240, 52, 52, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'Varados Onboarding',
	            data: getDataRegistro("plenoOnboarding","#datosRegistro"),
	            backgroundColor: 'rgba(254, 241, 96, 0.3)',
	            borderColor: 'rgba(254, 241, 96, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'Registro Completo',
	            data: getDataRegistro("registroCompleto","#datosRegistro"),
	            backgroundColor: 'rgba(46, 204, 113, 0.3)',
	            borderColor: 'rgba(46, 204, 113, 1)',
	            borderWidth: 2
	        }]
	    },
	    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero: true,
	                    min:0,
	                    callback: function(value, index, values) {
			                if (Math.floor(value) === value) {
			                    return value;
			                }
			            }
	                }
	            }]
	        }
	    }
	});

	var ctx5 = document.getElementById('chartRegistroTiendaNube').getContext('2d');
	var chartRegistroTiendaNube = new Chart(ctx5, {
	    type: 'bar',
	    data: {
	        labels: getPeriodoAnual(),
	        datasets: [
	        {
	        	label: 'Varados Onboarding',
	            data: getDataRegistro("plenoOnboarding","#datosRegistroTiendaNube"),
	            backgroundColor: 'rgba(254, 241, 96, 0.4)',
	            borderColor: 'rgba(254, 241, 96, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'Registro Completo',
	            data: getDataRegistro("registroCompleto","#datosRegistroTiendaNube"),
	            backgroundColor: 'rgba(46, 204, 113, 0.4)',
	            borderColor: 'rgba(46, 204, 113, 1)',
	            borderWidth: 2
	        }]
	    },
	    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero: true,
	                    min:0,
	                    callback: function(value, index, values) {
			                if (Math.floor(value) === value) {
			                    return value;
			                }
			            }
	                }
	            }]
	        }
	    }
	});

	var ctx6 = document.getElementById('chartRegistroDelivery').getContext('2d');
	var chartRegistroDelivery = new Chart(ctx6, {
	    type: 'bar',
	    data: {
	        labels: getPeriodoAnual(),
	        datasets: [
	        {
	        	label: 'Varados Onboarding',
	            data: getDataRegistro("plenoOnboarding","#datosRegistroDelivery"),
	            backgroundColor: 'rgba(254, 241, 96, 0.4)',
	            borderColor: 'rgba(254, 241, 96, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'Registro Completo',
	            data: getDataRegistro("registroCompleto","#datosRegistroDelivery"),
	            backgroundColor: 'rgba(46, 204, 113, 0.4)',
	            borderColor: 'rgba(46, 204, 113, 1)',
	            borderWidth: 2
	        }]
	    },
	    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero: true,
	                    min:0,
	                    callback: function(value, index, values) {
			                if (Math.floor(value) === value) {
			                    return value;
			                }
			            }
	                }
	            }]
	        }
	    }
	});

	var ctx7 = document.getElementById('chartContactos').getContext('2d');
	var chartContactos = new Chart(ctx7, {
	    type: 'bar',
	    data: {
	        labels: getPeriodoAnual(),
	        datasets: [{
	            label: 'Contactos',
	            data: getDataContactos(),
	            backgroundColor: 'rgba(46, 204, 113, 0.4)',
	            borderColor: 'rgba(46, 204, 113, 1)',
	            borderWidth: 2
	        }]
	    },
	    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero: true,
	                    min:0,
	                    callback: function(value, index, values) {
			                if (Math.floor(value) === value) {
			                    return value;
			                }
			            }
	                }
	            }]
	        }
	    }
	});

	jQuery(document).ready(function() {
		//getPerformanceVendedoresHTML();

		$('input:radio[name=responsable]').change(function(){
			updateChart(chartServiciosEspeciales);
			updateChartTasaSE(chartTasaEfectividadSE)
		})

	});

	function getDataServicios(codigo,mensuales){
		var servicios = getServicios(mensuales)
		var myObject = JSON.parse(servicios);
		myObject = myObject.filter(sm => sm.codigo == codigo)
	
		return myObject
	}

	function getDataPerformanceVendedor(codigo,responsable,tipo){
		var servicios = getServicios(false)
		var myObject = JSON.parse(servicios);
		if(responsable == "todos"){
			myObject = myObject.filter(sm => sm.codigo == codigo)
			if (tipo == "Vendidos")
				myObject = myObject.map(sm => sm.cantidad = sm['pagados'])
			else
				myObject = myObject.map(sm => sm.cantidad)
		return myObject
		}
		else
			return myObject.filter(sm => sm.codigo == codigo).map(sm => sm.cantidad = sm['responsable'+responsable+tipo])
	}

	function getDataContactos(){
		var contactos = $("#datosContactos").val()
		var myObject = JSON.parse(contactos)

		return myObject.map(co => co.cantidad)
	}
	/*function getPerformanceVendedoresHTML(){
		var vendedores = $("#nombresVendedores").val().replace('[','').replace(']','').split(', ')
		var vendidos
		vendedores.forEach((vendedor) => 
			vendidos = getServiciosVendidos(vendedor)
			document.getElementById("div"+vendedor).innerHTML = "Performance SE01"+aa+" </br> Performance SE02"
			)
		return 0
	}

	function getServiciosVendidos(vendedor){
		var servicios = getServicios(false)
		var myObject = JSON.parse(servicios);

		var meses = getPeriodoAnual()
		var vendidosPorMes = []
		meses.forEach((mes) =>
			vendidosPorMes.push(myObject.filter(se => se.mes == mes).map(s => s['responsable'+vendedor+'Vendidos']).reduce((a,b) => a+b, 0)))
		console.log(vendidosPorMes)
		return "ss"
	}*/

	function getMaxDataVisible(chart){
		var hiddenDatasets = [];
		for(var i=0; i<chart.data.datasets.length; i++) {
		    if (chart.isDatasetVisible(i)) {
		        hiddenDatasets.push(chart.data.datasets[i].data);
		    }
		 }
		var max = hiddenDatasets.map(da => da.reduce((a,b) => Math.max(a,b))).reduce(((a,b) => Math.max(a,b)))
		 console.log(max);
		 return max
	}

	function getValorMax(atributo,mensuales){
		var servicios = getServicios(mensuales);
		var myObject = JSON.parse(servicios);
		if(atributo == "enviados")
			myObject = myObject.map(sm => sm.cantidad)
		else
			myObject = myObject.map(sm => sm.pagados)

		return myObject.reduce((a,b) => Math.max(a,b))
	}

	function tasasEfectividadServicios(mensual){
		var responsable = getResponsableSeleccionado();
		var servicios = getServicios(mensual);
		var myObject = JSON.parse(servicios);
		var meses = getPeriodoAnual()
		var cobradosPorMes = []
		var totalPorMes = []
		var cobradosMensual
		var totalMensual
		for(i=0;i<12;i++){
			cobradosMensual = 0
			totalMensual = 0
			if(responsable == "todos"){
				cobradosMensual = myObject.filter(sm => sm.mes == parseInt(meses[i])).map(sm => sm.pagados).reduce((a,b) => a+b, 0)
				totalMensual = myObject.filter(sm => sm.mes == parseInt(meses[i])).map(sm => sm.cantidad).reduce((a,b) => a+b, 0)
			}
			else{
				cobradosMensual= myObject.filter(sm => sm.mes == parseInt(meses[i])).map(sm => sm.cantidad = sm['responsable'+responsable+"Vendidos"]).reduce((a,b) => a+b,0)
				totalMensual= myObject.filter(sm => sm.mes == parseInt(meses[i])).map(sm => sm.cantidad = sm['responsable'+responsable+"Enviados"]).reduce((a,b) => a+b,0)
			}
			cobradosPorMes.push(cobradosMensual)
			totalPorMes.push(totalMensual)
		}
		var efectividadPorMes = []
		var resultEfectividad
		for(i=0;i<12;i++){
			resultEfectividad = 0
			if(totalPorMes[i] != 0)
				resultEfectividad = (cobradosPorMes[i]/totalPorMes[i]) * 100
			efectividadPorMes.push(resultEfectividad)
		}

		return efectividadPorMes
	}

	function getServicios(mensuales){
		if(mensuales)
			return $("#datosServiciosMensuales").val()
		return $("#datosServiciosEspeciales").val()
	}

	function getDataRegistro(stage, dataSource){
		var data = $(dataSource).val()
		var datosRegistro = JSON.parse(data);
		datosRegistro = datosRegistro.filter(re => re.stage == stage).map(re => re.cantidad)
	
		return datosRegistro
	}

	function getValorMaxRegistro(dataSource){
		var data = $(dataSource).val()
		var datosRegistro = JSON.parse(data);
		var cantidadMaxima = datosRegistro.map(re => re.cantidad).reduce((a,b) => Math.max(a,b))

		return cantidadMaxima
	}

	function getResponsableSeleccionado(){
		 var ele = document.getElementsByName('responsable'); 
              
            for(i = 0; i < ele.length; i++) { 
                if(ele[i].checked) 
               		return(ele[i].value)
            } 
	}

	function getPeriodoAnual(){
		var periodo = $("#periodoAnual").val().replace('[','').replace(']','').split(', ')
		var periodoStrings = Array.from(periodo, x => convertirAStringMes(x))


		return periodoStrings

	}

	function convertirAStringMes(x){
		var mes = x.toString()
		if((x - 10) < 0)
			mes = "0" + mes
		return mes
	}

	function updateChart(chart){

		chart.data = {
	        labels: getPeriodoAnual(),
	        datasets:[{ 
	        	label: 'SE00-Presentación DDJJ',
	            data: getDataPerformanceVendedor("SE00",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(32, 158, 162, 0.3)',
	            borderColor: 'rgba(32, 158, 162, 1)',
	            borderWidth: 2
	        },{
	            label: 'SE01-Moratoria',
	            data: getDataPerformanceVendedor("SE01",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(245, 230, 83, 0.3)',
	            borderColor: 'rgba(245, 230, 83, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE02-Moratoria Ejec. Fiscal',
	            data: getDataPerformanceVendedor("SE02",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(60, 60, 162, 0.3)',
	            borderColor: 'rgba(60, 60, 162, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE03-Alta AFIP',
	            data: getDataPerformanceVendedor("SE03",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(0, 100, 0, 0.3)',
	            borderColor: 'rgba(0, 100, 0, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE04-Alta Rentas IIBB',
	            data: getDataPerformanceVendedor("SE04",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(140, 0, 0, 0.3)',
	            borderColor: 'rgba(140, 0, 0, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE05-Constitución domicilio',
	            data: getDataPerformanceVendedor("SE05",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(248, 148, 6, 0.3)',
	            borderColor: 'rgba(248, 148, 6, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE06-Baja Monotrib.',
	            data: getDataPerformanceVendedor("SE06",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(32, 0, 0, 0.3)',
	            borderColor: 'rgba(32, 0, 0, 100)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE07-Baja IIBB',
	            data: getDataPerformanceVendedor("SE07",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(219, 10, 91, 0.3)',
	            borderColor: 'rgba(219, 10, 91, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE08-Conv.Multilateral',
	            data: getDataPerformanceVendedor("SE08",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(0, 100, 162, 0.3)',
	            borderColor: 'rgba(0, 100, 162, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE09-Alta AFIP + Alta IIBB',
	            data: getDataPerformanceVendedor("SE09",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(0, 230, 64, 0.3)',
	            borderColor: 'rgba(0, 230, 64, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE10-Generación VEP',
	            data: getDataPerformanceVendedor("SE10",getResponsableSeleccionado(),"Vendidos"),
	            backgroundColor: 'rgba(171, 183, 183, 0.3)',
	            borderColor: 'rgba(171, 183, 183, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'SE00 Enviados',
	            data: getDataPerformanceVendedor("SE00",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(32, 158, 162, 0.1)',
	            borderColor: 'rgba(32, 158, 162, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },{
	            label: 'SE01 Enviados',
	            data: getDataPerformanceVendedor("SE01",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(245, 230, 83, 0.1)',
	            borderColor: 'rgba(245, 230, 83, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE02 Enviados',
	            data: getDataPerformanceVendedor("SE02",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(60, 60, 162, 0.1)',
	            borderColor: 'rgba(60, 60, 162, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE03 Enviados',
	            data: getDataPerformanceVendedor("SE03",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(0, 100, 0, 0.1)',
	            borderColor: 'rgba(0, 100, 0, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE04 Enviados',
	            data: getDataPerformanceVendedor("SE04",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(140, 0, 0, 0.1)',
	            borderColor: 'rgba(140, 0, 0, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE05 Enviados',
	            data: getDataPerformanceVendedor("SE05",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(248, 148, 6, 0.1)',
	            borderColor: 'rgba(248, 148, 6, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE06 Enviados',
	            data: getDataPerformanceVendedor("SE06",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(32, 0, 0, 0.1)',
	            borderColor: 'rgba(32, 0, 0, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE07 Enviados',
	            data: getDataPerformanceVendedor("SE07",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(219, 10, 91, 0.1)',
	            borderColor: 'rgba(219, 10, 91, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE08 Enviados',
	            data: getDataPerformanceVendedor("SE08",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(0, 100, 162, 0.1)',
	            borderColor: 'rgba(0, 100, 162, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE09 Enviados',
	            data: getDataPerformanceVendedor("SE09",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(0, 230, 64, 0.1)',
	            borderColor: 'rgba(0, 230, 64, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        },
	        {
	        	label: 'SE10 Enviados',
	            data: getDataPerformanceVendedor("SE10",getResponsableSeleccionado(),"Enviados"),
	            backgroundColor: 'rgba(171, 183, 183, 0.1)',
	            borderColor: 'rgba(171, 183, 183, 0.3)',
	            borderWidth: 2,
	            hidden: true
	        }]
	    }

	    chart.update();
	}

	function updateChartTasaSE(chart){
		chart.data = {
	        labels: getPeriodoAnual(),
	        datasets: [{
	        	label: 'SE Enviados / SE Vendidos',
	            data: tasasEfectividadServicios(false),
	            backgroundColor: 'rgba(255, 255, 255, 0)',
	            borderColor: 'rgba(32, 158, 162, 1)',
	            borderWidth: 2
	        }]
	    }
	    chart.update();
	}
</script>
</body>
</html>