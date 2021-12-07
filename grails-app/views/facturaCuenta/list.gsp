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
	<div id="urlGetFacturasCuenta">
		<g:createLink controller="facturaCuenta" action="ajaxGetFacturasCuenta" />
	</div>
	<div id="urlShow">
		<g:createLink controller="facturaCuenta" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="facturaCuenta" action="edit" />
	</div>	
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-6">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.documento.FacturaCuenta.list.label" default="Lista de Facturas Cuenta"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-2">
					<div style="text-align:right;">
						<input id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}" data-dd-fx="false"/>
						<!--<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Liquidacion']"/></g:link>-->
					</div>
				</div>
				<div class="col-lg-2">
					<div style="text-align:right;">
						<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}" data-dd-fx="false"/>
					</div>
				</div>
				<div class="col-lg-2">
					<div class="card-header-right" style="text-align:right;">
						<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Factura']"/></g:link>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listFacturasCuenta" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Fecha</th>
									<th>Cuenta</th>
									<th>Local</th>
									<th>Descripcion</th>
									<th>Importe</th>
									<th>Avisos</th>
									<th>Pagada</th>
									<th>Responsable</th>
									<th>Fecha Pago</th>
									<th>Fecha aviso MP</th>
									<th>CAE</th>
									<th>Profesión</th>
									<th>email MP</th>
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

<script type="text/javascript">
var tabla;

	jQuery(document).ready(function() {
		tabla = $('#listFacturasCuenta').DataTable({
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
				sZeroRecords: "${message(code: 'zifras.documento.FacturaCuenta.list.agregar', default: 'No hay Facturas de Cuentas')}</a>",
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
				[2, 'desc'], // Fecha
				[0, 'desc'], // Nombre
				[6, 'desc'] // Pagada
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "fecha",
			       			"type": "date-eu"
						},{
			       			"aTargets": [1],
			       			"mData": "cuentaNombre",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [2],
			       			"mData": "local",
			       			"visible": "${com.zifras.User.get(session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id)?.userTenantId}" == "1"
						},{
			       			"aTargets": [3],
			       			"mData": "descripcion"
						},{
			       			"aTargets": [4],
			       			"mData": "importe",
			       			"sClass" : "text-right"
			       		},{
			       			"aTargets": [5],
			       			"mData": "cantidadAvisos"
			       		},{
			       			"aTargets": [6],
			       			"mData": "pagadaCheck"
			       		},{
			       			"aTargets": [7],
			       			"mData": "responsable"
			       		},{
			       			"aTargets": [8],
			       			"mData": "fechaPago"
			       		},{
			       			"aTargets": [9],
			       			"mData": "fechaNotificacion"
			       		},{
			       			"aTargets": [10],
			       			"mData": "cae"
			       		},{
			       			"aTargets": [11],
			       			"mData": "profesion"
			       		},{
			       			"aTargets": [12],
			       			"mData": "mailMercadoPago"
			       		}],
			buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Facturas Cuenta";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Facturas Cuenta";
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
					window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistFacturasCuenta();

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

		$("#ano").change(function () {
			llenarDatoslistFacturasCuenta();
		});

		$("#mes").change(function () {
			llenarDatoslistFacturasCuenta();
		});
	});

	function llenarDatoslistFacturasCuenta(){
		$('#loaderGrande').fadeIn("slow");
		var ano = $("#ano").val();
		var mes = $("#mes").val();
		tabla.clear().draw();
		$.ajax($('#urlGetFacturasCuenta').text(), {
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
</script>
</body>
</html>
