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
	<div id="urlGetPagoCuentas">
		<g:createLink controller="PagoCuenta" action="ajaxGetPagoCuentas" />
	</div>
	<div id="urlShow">
		<g:createLink controller="PagoCuenta" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="PagoCuenta" action="edit" />
	</div>	
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-8">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.PagoCuenta.PagoCuenta.list.label" default="Lista de PagoCuentas"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['PagoCuenta']"/></g:link>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listPagoCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Fecha de Pago</th>
									<th>Cuenta</th>
									<th>Estado</th>
									<th>Importe</th>
									<th>Descripcion</th>
									<th>Fecha Aviso MP</th>
									<th>Archivo</th>
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
		tabla = $('#listPagoCuentas').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.PagoCuenta.PagoCuenta.list.agregar', default: 'No hay PagoCuentas')}</a>",
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
			       			"aTargets": [1],
			       			"mData": "cuentaNombre",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [2],
			       			"mData": "estadoNombre",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [3],
			       			"mData": "importe",
			       			"sClass" : "text-right"
			       		},{
			       			"aTargets": [4],
			       			"mData": "descripcion",
			       			"sClass" : "bold"
			       		},{
			       			"aTargets": [0],
			       			"mData": "fechaPago",
			       			"type": "date-eu",
			       			"sClass" : "bold"
			       		},{
			       			"aTargets":[5],
			       			"mData":"fechaNotificacion",
			       			"type":"date-eu"
			       		},{
			       			"aTargets": [6],
			       			"mData": "nombreArchivo",
			       			"mRender": function ( data, type, full ) {
			       				if(full['tipoArchivo'] == "pdf"){
			       					return '<i class="icofont icofont-file-pdf"></i>' + '   ' + data
			       				}else{
			       					if(full['tipoArchivo'] == "doc"){
			       						return '<i class="icofont-file-word"></i>' + '   ' + data
			       					}else{
			       						if(full['tipoArchivo'] == "")
			       							return "-"
			       						else
			       							return '<i class="icofont icofont-file-text"></i>' + '   ' + data
			       					}
			       				}
			       			}
			       		}],
			 buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Pagos Cuenta";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Pagos Cuenta";
							return nombre;
 					}
 				},{
 					extend: 'copyHtml5'
 				}],
       		sPaginationType: 'simple',
       		sDom: "lBfrtip"/*,
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}*/
		});

		llenarDatoslistPagoCuentas();
	});

	function llenarDatoslistPagoCuentas(){
		$.ajax($('#urlGetPagoCuentas').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
			$('#loaderGrande').fadeOut('slow', function() {
				$(this).hide();
			});
		});
	}
</script>
</body>
</html>
