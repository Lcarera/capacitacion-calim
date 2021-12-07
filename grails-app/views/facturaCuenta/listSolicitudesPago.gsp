<!DOCTYPE html>
<html lang="en">

<head>
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
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetFacturasCuenta">
		<g:createLink controller="facturaCuenta" action="ajaxGetSolicitudesPago" />
	</div>
	<div id="urlGetCuentasList">
		<g:createLink controller="cuenta" action="ajaxGetCuentasList" />
	</div>
	<div id="urlShow">
		<g:createLink controller="facturaCuenta" action="show" />
	</div>
	<div id="urlServiciosCuenta">
		<g:createLink controller="cuenta" action="servicios" />
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
		                    <h4><g:message code="zifras.documento.FacturaCuenta.list.label" default="Lista de Solicitudes de Pago"/></h4>
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
						<button type="button" class="btn btn-success" onclick="$('#modalListCuentas').modal('show');">Agregar</button>
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
									<th>Descripcion</th>
									<th>Importe</th>
									<th>Pagada</th>
									<th>Fecha Pago</th>
									<th>Responsable</th>
									<th>Link Pago</th>
									<th>Importe crudo</th>
									<th>Cobrado crudo</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
							<tfoot>
							    <tr>
							       	<th colspan="3"></th>
                					<th></th>
                					<th colspan="4"></th>
                					<th></th>
							    </tr>
							</tfoot>
						</table>
					</div>
				</div>
				<!-- Statistics and revenue End -->
			</div>
		</div>

		<div class="modal fade" id="modalListCuentas" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">Cuentas</h4>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body" style="padding:0px;">
						<div class="card">
							<div class="card-block">
								<div class="dt-responsive table-responsive" id="divListCuentas">
									<table id="listCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
										<thead>
											<tr>
												<th>CUIT</th>
												<th>Razón Social</th>
												<th>Teléfono</th>
												<th>Cond. IVA</th>
												<th>Tr.App</th>
												<th>Provincia IIBB</th>
												<th>Reg. IIBB</th>
												<th>Email</th>
												<th>Actividad IIBB</th>
												<th>Fecha Confirmación</th>
											</tr>
										</thead>
										<tbody>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
					<!-- Statistics and revenue End -->
				</div>
			</div>
		</div>
	</div>
</div>

<script src="https://cdn.datatables.net/plug-ins/1.10.19/api/sum().js"></script>`
<script type="text/javascript">
var tabla;
var tablaCuentas;

	jQuery(document).ready(function() {

		tabla = $('#listFacturasCuenta').DataTable({
			"footerCallback": function ( row, data, start, end, display ) {
	            var api = this.api(), data;
	 
	            // Remove the formatting to get integer data for summation
	            var intVal = function ( i ) {
	                return typeof i === 'string' ?
	                    i.replace(/[\$,]/g, '')*1 :
	                    typeof i === 'number' ?
	                        i : 0;
	            };
	 
	            // Total over all pages
	            total = api
	                .column( 8 )
	                .data()
	                .reduce( function (a, b) {
	                    return intVal(a) + intVal(b);
	                }, 0 );
	 
	            // Total over this page
	            pageTotal = api
	                .column( 8, { page: 'current'} )
	                .data()
	                .reduce( function (a, b) {
	                    return intVal(a) + intVal(b);
	                }, 0 );

	             cobradoPageTotal = api
	             	.column(9,{page: 'current'})
	             	.data()
	             	.reduce(function (a,b){
	             		return intVal(a) + intVal(b);
	             	}, 0 );

	             cobradoTotal = api
	                .column(9)
	                .data()
	                .reduce( function (a, b) {
	                    return intVal(a) + intVal(b);
	                }, 0 );
	 			
	            // Update footer
	            $( api.column( 3 ).footer() ).html(
	                '$'+pageTotal.toFixed(2) +' ($'+ total.toFixed(2) +' total)'
	            );
	            $(api.column(4).footer()).html(
	            	'$'+cobradoPageTotal.toFixed(2) + ' ($'+ cobradoTotal.toFixed(2) +' total)'
	            );
	        },
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
			       			'type': 'date-eu'
						},{
			       			"aTargets": [1],
			       			"mData": "cuentaEmail"
						},{
			       			"aTargets": [2],
			       			"mData": "descripcion"
						},{
			       			"aTargets": [3],
			       			"mData": "importe",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [4],
			       			"mData": "pagadaCheck"
			       		},{
			       			"aTargets": [5],
			       			"mData": "fechaPago",
			       			'type': 'date-eu'
			       		},{
			       			"aTargets": [6],
			       			"mData": "responsable"
			       		},{
			       			"aTargets": [7],
			       			"mData": "linkPago",
			       			"visible": false
			       		},{
			       			"aTargets":[8],
			       			"mData":"importeCrudo",
			       			"visible":false
			       		},{
			       			"aTargets":[9],
			       			"mData":"cobradoCrudo",
			       			"visible":false
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
					window.location.href = $('#urlShow').text() + '?id=' + aData['id'] + '&path=ventas';
				});
			}
		});

		llenarDatoslistFacturasCuenta();

		tablaCuentas = $('#listCuentas').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay cuentas ¡Agrega una cuenta!')}</a>",
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
			iDisplayLength: 100,
			//scrollX: true,
			aaSorting: [
				[8, 'desc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "cuit",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [1],
			       			"mData": "razonSocial"
						},{
			       			"aTargets": [2],
			       			"mData": "telefono"
						},{
			       			"aTargets": [3],
			       			"mData": "condicionIva"
						},{
			       			"aTargets": [4],
			       			"mData": "trabajaConApp",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
						},{
			       			"aTargets": [5],
			       			"mData": "porcentajesProvinciaIIBB"
						},{
			       			"aTargets": [6],
			       			"mData": "regimenIibb"
			       		},{
			       			"aTargets": [7],
			       			"mData": "email"
						},{
			       			"aTargets": [8],
			       			"mData": "porcentajesActividadIIBB"
			       		},{
			       			"aTargets": [9],
			       			"mData": "fechaConfirmacion",
					       	"type": "date-eu"
			       		}],
  			buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Cuentas";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Cuentas";
							return nombre;
 					}
 				},{
 					extend: 'copyHtml5'
 				}],
       		sPaginationType: 'simple',
       		sDom: "lBfrtip",
       		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				$(nRow).on('click', function() {
					window.location.href = $('#urlServiciosCuenta').text() + '/' + aData['id'];
				});
			}
		});


		llenarDatoslistCuentas();

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
		var ano = $("#ano").val();
		var mes = $("#mes").val();
		tabla.clear().draw();
		$('#loaderGrande').fadeIn("fast");
		$.ajax($('#urlGetFacturasCuenta').text(), {
			dataType: "json",
			data: {
				ano: ano,
				mes: mes
			}
		}).done(function(data) {
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
			$('#loaderGrande').fadeOut('slow');
		});
	}

	function llenarDatoslistCuentas(){
		$.ajax($('#urlGetCuentasList').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			for(key in data){
				tablaCuentas.row.add(data[key]);
			}
			$("#divListCuentas").show();
			tablaCuentas.draw();
			
		});
	}

</script>
</body>
</html>
