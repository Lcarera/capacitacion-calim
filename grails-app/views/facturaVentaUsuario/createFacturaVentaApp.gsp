<!DOCTYPE html>
<html lang="en">

<head>
	<div class="theme-loader" id="loaderGrande" style="display: none;">
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
	<meta name="layout" content="main">
</head>

<body>
<div class="main-body">
	<div class="page-wrapper">
		<div class="container">
			<div class="row">
				<div class="col-md-12">
					<!-- Authentication card start -->
					<div class="signup-card auth-body mr-auto ml-auto">
						<div class="auth-box">
							<h5 class="b-b-default text-left txt-primary m-b-20 ttl-login divApps"/>¿A quién emitirás la factura?</h5>
							<h5 class="b-b-default text-left txt-primary m-b-20 ttl-login divMontos" style="display: none;"/>¿Qué importe vas a facturar?</h5>

							<div class="row row-apps divApps">
								<g:each in="${apps}">
								<div class="col-md-4 col-xs-6 col-apps">
									<button id="button${it.id}" type="button" class="btn apps" onclick="cambiarApp('${it.nombre}', ${it.id});"><asset:image src="${it.logo}"/></button>
								</div>
								</g:each>
							</div>

							<div class="divMontos" style="display: none;">
								<div class="input-group col-12">
									<span class="input-group-addon" id="basic-addon1">$</span>
									<input id="importe1" type="text" data-a-sep="" data-a-dec="," class="form-control autonumber" placeholder="Importe"></input>
								</div>
							</div>

							<div class="divMontos pedidosYaDiv" style="display: none; margin-top: 10px;">
								<div class="input-group col-12">
									<span class="input-group-addon" id="basic-addon1">$</span>
									<input id="importe2" type="text" data-a-sep="" data-a-dec="," class="form-control autonumber" placeholder="Exhibición de material publicitario"></input>
								</div>
							</div>

							<div class="pedidosYaDiv divMontos" style="display: none; margin-top: 10px;">
								<div class="input-group col-12">
									<span class="input-group-addon" id="basic-addon1"><i class="icofont icofont-calendar"></i></span>
									<input id="fecha" class="form-control" name="fecha" type="text" data-format="d/m/Y" placeholder="Inicio y Fin de Servicios"/>
								</div>
							</div>

							<span class="md-line"></span>
							<hr/>

							<div class="row">
								<div class="col-6">
									<button id="volverBtn" onclick="volver()" type="button" style="width:100%" class="btn btn-default block waves-effect">Volver</button>
							   </div>
							   <div class="col-6">
									<button id="submitBtn" type="button" onclick="siguiente()" style="width:100%" class="btn btn-primary block waves-effect">Siguiente</button>
							   </div>
							</div>
						</div>
					</div>
					<!-- Authentication card end -->
				</div>
				<!-- end of col-sm-12 -->
			</div>
			<!-- end of row -->
		</div>
	</div>
<script>
	var appSeleccionada;
	var appSeleccionadaId;

	$(document).ready(function () {
		$('input[name="fecha"]').daterangepicker({
			startDate: moment().startOf('month'),
			endDate: moment().endOf('month'),
			// minDate: '30/02/2021',
			maxDate: moment(),
			"alwaysShowCalendars": true,
			autoUpdateInput: false,
			showDropdowns: true,
			opens: 'left',
			locale: {
				format: 'DD/MM/YYYY',
				cancelLabel: 'Cancelar',
				"customRangeLabel": "Personalizado",
				applyLabel: "Aplicar",
				daysOfWeek: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa"],
				monthNames: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
			},
			ranges: {
				'Hoy': [moment(), moment()],
				'Ayer': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
				'Últ. 7 días': [moment().subtract(6, 'days'), moment()],
				'Últ. 30 días': [moment().subtract(29, 'days'), moment()],
				'Este mes': [moment().startOf('month'), moment().endOf('month')],
				'Mes pasado': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]//,
				// 'MAT': [moment().subtract(366, 'days'), moment().subtract(1, 'days')],
				// 'QTD': [moment().startOf('quarter'), moment().subtract(1, 'days')],
				// 'YTD': [moment().startOf('year'), moment()]
			 }
		});
		$('input[name="fecha"]').on('apply.daterangepicker', function(ev, picker) {
			$(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
			// $('#fechaDesde').val(picker.startDate.format('YYYY-MM-DD'));
			// $('#fechaHasta').val(picker.endDate.format('YYYY-MM-DD'));
		});
	});

	function cambiarApp(nombreApp, id){
		appSeleccionada = nombreApp
		appSeleccionadaId = id
		if (nombreApp == 'Otro')
			redirigir("create?otros=true")
		$(".divApps").hide()
		$(".divMontos").show()
		if (nombreApp == "Rappi"){
			$(".pedidosYaDiv").hide()
			$("#importe1").attr("placeholder", "No puede superar $15,380.00");
		}else
			$("#importe1").attr("placeholder", "Servicio Logístico");
	}

	function volver(){
		if (! appSeleccionada)
			redirigir('index')
		appSeleccionada = ""
		$(".divApps").show()
		$(".divMontos").hide()
	}

	function siguiente(){
		const importe1 = leerFloat("importe1")
		const importe2 = leerFloat("importe2")
		if (appSeleccionada == "Rappi" && importe1 > 15380)
				swal("Monto Inválido","Rappi no permite facturar montos mayores a $15,380.00\nPor favor, ingresá otro importe.","error")
		else if (!appSeleccionada)
			swal("","Por favor, seleccioná el receptor de la factura","error")
		else{
			var urlBase = "${raw(createLink(action:'facturarApp', params:[mobile:false,monto:'Var1',monto2:'Var2',appId:'Var3',fecha:'Var4']))}"
			urlBase = urlBase.replace('Var1', importe1)
			urlBase = urlBase.replace('Var2', importe2)
			urlBase = urlBase.replace('Var3', appSeleccionadaId)
			urlBase = urlBase.replace('Var4', $("#fecha").val())
			redirigir(urlBase)
		}
	}

	function redirigir(url){
		$("#loaderGrande").show()
		window.location.href = url
	}
</script>
</body>
</html>