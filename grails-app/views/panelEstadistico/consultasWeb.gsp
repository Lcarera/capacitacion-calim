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
	<div id="urlGetConsultasWeb">
		<g:createLink controller="panelEstadistico" action="ajaxGetConsultasWeb" />
	</div>
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<div class="page-header card">
						<div class="row align-items-end">
							<div class="col-lg-8">
								<h3>Mensual</h3>
							</div>
							<div class="col-lg-2">
								<div style="text-align:right;">
									<input id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
								</div>
							</div>
							<div class="col-lg-2">
								<div style="text-align:right;">
									<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
								</div>
							</div>
						</div>
					</div>
				</br>
					<canvas id="chartConsultasWebMensual" width="200" height="100"></canvas>
				</br>
			</div>
		</div>
		</br>
		</br>
		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<div class="page-header card">
						<div class="row align-items-end">
							<div class="col-lg-10">
								<h3>Diario</h3>
							</div>
							<div class="col-lg-2">
								<div style="text-align:right;">
									<input id="dia" name="dia" class="form-control" type="text" data-format="D" placeholder="Seleccione un dia" value="${dia}"/>
								</div>
							</div>
						</div>
					</div>
				</br>
					<canvas id="chartConsultasWebDiario" width="200" height="100"></canvas>
				</br>
			</div>
		</div>
		</br>
		</br>
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-6">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.documento.ConsultaWeb.list.label" default="Lista de Consultas Web"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-2">
					<div style="text-align:right;">
						<input id="mesList" name="mesList" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}" data-dd-fx="false"/>
						<!--<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Liquidacion']"/></g:link>-->
					</div>
				</div>
				<div class="col-lg-2">
					<div style="text-align:right;">
						<input id="anoList" name="anoList" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}" data-dd-fx="false"/>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listConsultasWeb" class="table table-striped table-bordered nowrap">
							<thead>
								<tr>
									<th>Fecha</th>
									<th>Nombre y Apellido</th>
									<th>Nombre</th>
									<th>Apellido</th>
									<th>Teléfono</th>
									<th>Email</th>
									<th>Tag</th>
									<th>Vendedor Asignado</th>
									<th>URL</th>
									<th>Parámetros</th>
									<th>Cuenta Existente</th>
									<th>Mensual Activo</th>
									<th>Pagó Algún Servicio</th>
									<th>Bitrix Contact Id</th>
									<th>Bitrix Deal Id</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Statistics and revenue End -->
			</div>
		</div>
		
	</div>
</div>

<g:hiddenField name="periodoAnual" id="periodoAnual" value="${periodoAnual}"/>
<g:hiddenField name="datosConsultasDiaria" id="datosConsultasDiaria" value="${consultasDiarias}"/>
<g:hiddenField name="datosConsultasMensual" id="datosConsultasMensual" value="${consultasMensuales}"/>

<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
<script type="text/javascript">
var tabla;
	
	var ctxMensual = document.getElementById('chartConsultasWebMensual').getContext('2d');
	var chartMensual = new Chart(ctxMensual, {
	    type: 'bar',
	    data: {
	        labels:["Semana 1","Semana 2","Semana 3","Semana 4"],
	        datasets: [{
	            label: 'Lunes',
	            data: getDataConsultasSemana("1"),
	            backgroundColor: 'rgba(32, 158, 162, 0.3)',
	            borderColor: 'rgba(32, 158, 162, 1)',
	            borderWidth: 2
	        },{
	            label: 'Martes',
	            data: getDataConsultasSemana("2"),
	            backgroundColor: 'rgba(245, 230, 83, 0.3)',
	            borderColor: 'rgba(245, 230, 83, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'Miercoles',
	            data: getDataConsultasSemana("3"),
	            backgroundColor: 'rgba(60, 60, 162, 0.3)',
	            borderColor: 'rgba(60, 60, 162, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'Jueves',
	            data: getDataConsultasSemana("4"),
	            backgroundColor: 'rgba(0, 100, 0, 0.3)',
	            borderColor: 'rgba(0, 100, 0, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'Viernes',
	            data: getDataConsultasSemana("5"),
	            backgroundColor: 'rgba(246, 105, 105, 0.3)',
	            borderColor: 'rgba(246, 105, 105, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'Sabado',
	            data: getDataConsultasSemana("6"),
	            backgroundColor: 'rgba(153, 102, 102, 0.3)',
	            borderColor: 'rgba(153, 102, 102, 1)',
	            borderWidth: 2
	        },
	        {
	        	label: 'Domingo',
	            data: getDataConsultasSemana("7"),
	            backgroundColor: 'rgba(153, 102, 102, 0.3)',
	            borderColor: 'rgba(153, 102, 102, 1)',
	            borderWidth: 2
	        }]
	    },
	    options: {
	        scales: {
	            y: {
	                beginAtZero: true
	            }
	        }
	    }
	});

	var ctxDiario = document.getElementById('chartConsultasWebDiario').getContext('2d');
	var chartDiario = new Chart(ctxDiario, {
	    type: 'line',
	    data: {
	    	labels:["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"],
	        datasets: [{
	        	label:"Cantidad de Consultas Web",
	            data: getDataConsultasDiaria(true).map(c => c.cantidad),
	            backgroundColor: 'rgba(32, 158, 162, 0.4)',
	            borderColor: 'rgba(32, 158, 162, 1)',
	            borderWidth: 2
	        }
	    
	        ]
	    },
	    options: {
	        scales: {
	            y: {
	                beginAtZero: true
	            }
	        }
	    }
	});

	jQuery(document).ready(function() {
		tabla = $('#listConsultasWeb').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			iDisplayLength: 50,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.documento.FacturaCuenta.list.agregar', default: 'No hay Consultas')}</a>",
				sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
				sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
				sInfoPostFix: "",
				sUrl: "",
				sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
				oPaginate: {
					"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
					"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
					"sNext":	"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
					"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
				}
			},
			aaSorting: [
				[0, 'desc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "fecha",
			       			"type": "datetime"
						},{
			       			"aTargets": [1],
			       			"mData": "nombreApellido",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [2],
			       			"mData": "nombre",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [3],
			       			"mData": "apellido",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [4],
			       			"mData": "telefono"
						},{
			       			"aTargets": [5],
			       			"mData": "email"
						},{
			       			"aTargets": [6],
			       			"mData": "tag"
			       		},{
			       			"aTargets": [7],
			       			"mData": "vendedorAsignado"
			       		},{
			       			"aTargets": [8],
			       			"mData": "urlOrigen"
			       		},{
			       			"aTargets": [9],
			       			"mData": "getParameters"
			       		},{
			       			"aTargets": [10],
			       			"mData": "cuentaExistente",
			       			"mRender": function ( data, type, full ) {
			       				const link = "${createLink(controller:'cuenta', action:'show', id:'varId')}".replace("varId", full['cuentaId']);
				       			return data ? '<a href="'+link+'">Posee Cuenta</a>' : '-';
				       		}
			       		},{
			       			"aTargets": [11],
			       			"mData": "mensualActivo",
			       			"mRender": function ( data, type, full ) {
				       			return data ? 'Posee SM' : '-';
				       		}
			       		},{
			       			"aTargets": [12],
			       			"mData": "algunServicioPagado",
			       			"mRender": function ( data, type, full ) {
				       			return data ? 'Pagó servicio' : '-';
				       		}
				       	},{
			       			"aTargets": [13],
			       			"mData": "contactId",
			       			"mRender": function ( data, type, full ) {
			       				const link = "https://calim.bitrix24.com/crm/contact/details/varId/".replace("varId", full['contactId'])
				       			return data ? '<a href="'+link+'">'+full["contactId"]+'</a>' : '-';
				       		}
				       	},{
			       			"aTargets": [14],
			       			"mData": "dealId",
			       			"mRender": function ( data, type, full ) {
			       				const link = "https://calim.bitrix24.com/crm/deal/details/varId/".replace("varId", full['dealId']);
				       			return data ? '<a href="'+link+'">'+full["dealId"]+'</a>' : '-';
				       		}
			       		}],
			buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Consultas Web";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Consultas Web";
							return nombre;
 					}
 				},{
 					extend: 'copyHtml5'
 				}],
       		sPaginationType: 'simple',
       		sDom: "lBfrtip",
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					//window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistConsultasWeb();

		$("#mes").dateDropper( {
	        dropWidth: 200,
	        dropPrimaryColor: "#1abc9c", 
	        dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "m",
			lang: "es",
			fx: false
	    });

		$("#ano").dateDropper( {
	        dropWidth: 200,
	        dropPrimaryColor: "#1abc9c", 
	        dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "Y",
			minYear: 2010,
			maxYear: 2040,
			lang: "es",
			fx: false
	    });

		$("#dia").dateDropper({
			dropWidth: 200,
			dropPrimaryColor: "#1abc9c",
			dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format:"d",
			lang: "es"
		});

		$("#ano").change(function () {
			cambiarFecha();
		});

		$("#mes").change(function () {
			cambiarFecha();
		});

		$("#dia").change(function () {
			cambiarFecha();
		});
	});

	function cambiarFecha() {
		$("#loaderGrande").show()
		const base = "${raw(createLink(action:'consultasWeb', params:[dia:'vardia', mes:'varmes', ano:'varano']))}"
		window.location.href = base.replace('vardia', $("#dia").val()).replace('varmes', $("#mes").val()).replace('varano', $("#ano").val())
	}

	function convertirAStringMes(x){
			var mes = x.toString()
			if((x - 10) < 0)
				mes = "0" + mes
			return mes
		}

	function llenarDatoslistConsultasWeb(){
		$('#loaderGrande').fadeIn("slow");
		var ano = $("#ano").val();
		var mes = $("#mes").val();
		tabla.clear().draw();
		$.ajax($('#urlGetConsultasWeb').text(), {
			dataType: "json",
			data: {
				ano: ano,
				mes: mes
			}
		}).done(function(data) {
			$('#loaderGrande').fadeOut('slow');
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
		});
	}

	function getDataConsultasSemana(diaBusq){
		var consultas = getConsultas(false);
		var myObject = JSON.parse(consultas);
		myObject = myObject.filter(con => con.dia == diaBusq)
		return myObject.map(con => con.cantidad)
	}

	function getDataConsultasDiaria(){
		var consultas = getConsultas(true);
		var myObject = JSON.parse(consultas);
		return myObject
	}

	function getConsultas(diaria){
		if(diaria)
			return $("#datosConsultasDiaria").val()
		return $("#datosConsultasMensual").val()
	}

	function getPeriodoAnual(){
		var periodo = $("#periodoAnual").val().replace('[','').replace(']','').split(', ')
		var periodoStrings = Array.from(periodo, x => convertirAStringMes(x))


		return periodoStrings
	}

</script>
</body>
</html>
