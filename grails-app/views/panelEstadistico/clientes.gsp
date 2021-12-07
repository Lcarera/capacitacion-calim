<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
	<div class="theme-loader" id="loaderGrande">
		<div class="ball-scale">
			<div class='contain'>
				<div class="ring"><div class="frame"></div></div>
				<div class="ring"><div class="frame"></div></div>
				<div class="ring"><div class="frame"></div></div>
				<div class="ring"><div class="frame"></div></div>
				<div class="ring"><div class="frame"></div></div>
				<div class="ring"><div class="frame"></div></div>
				<div class="ring"><div class="frame"></div></div>
				<div class="ring"><div class="frame"></div></div>
				<div class="ring"><div class="frame"></div></div>
				<div class="ring"><div class="frame"></div></div>
			</div>
		</div>
	</div>
</head>
<body>	
<div style="display: none;">

</div>

<div class="main-body">
	
	<div class="page-wrapper">		
		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<h3 style="text-align: center;">Servicios Mensuales</h3>
				</br>
					<canvas id="chartEmitidosPagados" width="200" height="100"></canvas>
				</br>
			</div>
		</div>
		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<h3 style="text-align: center;">Crecimiento</h3>
				</br>
					<canvas id="chartCrecimiento" width="200" height="100"></canvas>
				</br>
			</div>
		</div>
</div>


<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
<script type="text/javascript">

	var ctxEmitidosPagados = document.getElementById('chartEmitidosPagados').getContext('2d');
	var chartEmitidosPagados;
	var ctxCrecimiento = document.getElementById('chartCrecimiento').getContext('2d');
	var chartCrecimiento;
	let nombreMeses = []
	let meses = []
	let emitidos = []
	let pagados = []
	let reembolsados = []
	let nuevosEmitidos = []
	let nuevosPagados = []
	let bajas = []

	jQuery(document).ready(function() {
		getData();
	});

	function getData(){
		$.ajax("${createLink(action: 'ajaxGetClientesMensuales')}", {
			dataType: "json",
			data: {
				cantMeses: "${cantMeses}"
			}
		}).done(function (data) {
			for(key in data){
				meses.push(key)
				emitidos.push(data[key].emitidos)
				nombreMeses.push(data[key].nombre)
				pagados.push(data[key].pagados)
				reembolsados.push(data[key].reembolsados)
				nuevosEmitidos.push(data[key].nuevosSinPagar)
				nuevosPagados.push(data[key].nuevosPagados)
			}
			construirGraficoEmitidos()
		});
		$.ajax("${createLink(action: 'ajaxGetBajasMensuales')}", {
			dataType: "json",
			data: {
				cantMeses: "${cantMeses}"
			}
		}).done(function (data) {
			for(key in data){
				bajas.push(data[key])
			}
		});
	}

	function construirGraficoEmitidos(){
		chartEmitidosPagados = new Chart(ctxEmitidosPagados, {
		    type: 'bar',
		    data: {
		        labels: nombreMeses,
		        datasets: [{
		            label: 'Emitidos',
		            data: emitidos,
	            	backgroundColor: 'rgba(60, 60, 162, 0.4)',
	            	borderColor: 'rgba(60, 60, 162, 1)',
		            borderWidth: 2
		        },
		        {
		            label: 'Emitidos (línea)',
		            hidden:true,
		            type:'line',
		            data: emitidos,
	            	backgroundColor: 'rgba(60, 60, 162, 0.4)',
	            	borderColor: 'rgba(60, 60, 162, 1)',
		            borderWidth: 2
		        },
		        {
		        	label: 'Pagados',
		            data: pagados,
	            	backgroundColor: 'rgba(0, 177, 106, 0.4)',
	            	borderColor: 'rgba(0, 177, 106, 1)',
		            borderWidth: 2
		        },
		        {
		        	label: 'Pagados (línea)',
		        	hidden:true,
		        	type:'line',
		            data: pagados,
	            	backgroundColor: 'rgba(0, 177, 106, 0.4)',
	            	borderColor: 'rgba(0, 177, 106, 1)',
		            borderWidth: 2
		        },
		        {
		        	label: 'Reembolsados',
		            data: reembolsados,
		            backgroundColor: 'rgba(140, 0, 0, 0.4)',
		            borderColor: 'rgba(140, 0, 0, 1)',
		            borderWidth: 2
		        },
		        {
		        	label: 'Reembolsados (línea)',
		        	type:'line',
		            data: reembolsados,
		            backgroundColor: 'rgba(140, 0, 0, 0.4)',
		            borderColor: 'rgba(140, 0, 0, 1)',
		            borderWidth: 2
		        },
		        {
		        	label: 'Efectividad de Cobro',
		        	type: 'line',
		            data: pagados.map(function (num, idx) {
		            	if (emitidos[idx] == 0)
		            		return 100;
		            	return Math.round(num / emitidos[idx] * 10000) / 100
		            }),
		            backgroundColor: 'rgba(254, 241, 96, 0)',
		            borderColor: 'rgba(254, 241, 96, 1)',
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
		construirGraficoCrecimiento();
	}

	function construirGraficoCrecimiento(){
		chartCrecimiento = new Chart(ctxCrecimiento, {
		    type: 'bar',
		    data: {
		        labels: nombreMeses,
		        datasets: [{
		        	label: 'Altas',
		            data: nuevosPagados,
	            	backgroundColor: 'rgba(0, 177, 106, 0.4)',
	            	borderColor: 'rgba(0, 177, 106, 1)',
		            borderWidth: 2
		        },
		        {
		        	label: 'Altas (línea)',
		        	hidden:true,
		        	type:'line',
		            data: nuevosPagados,
	            	backgroundColor: 'rgba(0, 177, 106, 0.4)',
	            	borderColor: 'rgba(0, 177, 106, 1)',
		            borderWidth: 2
		        },
		        {
		        	label: 'Bajas',
		            data: bajas,
		            backgroundColor: 'rgba(140, 0, 0, 0.4)',
		            borderColor: 'rgba(140, 0, 0, 1)',
		            borderWidth: 2
		        },
		        {
		        	label: 'Bajas (línea)',
		        	hidden:true,
		        	type:'line',
		            data: bajas,
		            backgroundColor: 'rgba(140, 0, 0, 0.4)',
		            borderColor: 'rgba(140, 0, 0, 1)',
		            borderWidth: 2
		        },
		        {
		        	label: 'Crecimiento',
		        	type: 'line',
		            data: nuevosPagados.map(function (num, idx) {return num - bajas[idx];}),
	            	backgroundColor: 'rgba(60, 60, 162, 0.4)',
	            	borderColor: 'rgba(60, 60, 162, 1)',
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
		$('#loaderGrande').fadeOut('slow');
	}
</script>
</body>
</html>