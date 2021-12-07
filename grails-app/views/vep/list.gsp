<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetVeps">
		<g:createLink controller="vep" action="ajaxGetVeps" />
	</div>
	<div id="urlShow">
		<g:createLink controller="vep" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="vep" action="edit" />
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
		                    <h4><g:message code="zifras.vep.Vep.list.label" default="Lista de Veps"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Vep']"/></g:link>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listVeps" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Cuenta</th>
									<th>Numero</th>
									<th>Estado</th>
									<th>Importe</th>
									<th>Descripcion</th>
									<th>Fecha de Pago</th>
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
		tabla = $('#listVeps').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.vep.Vep.list.agregar', default: 'No hay veps')}</a>",
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
				[0, 'asc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "cuentaNombre",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [1],
			       			"mData": "numero",
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
			       			"aTargets": [5],
			       			"mData": "fechaPago",
			       			"type": "date-eu",
			       			"sClass" : "bold"
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
			       						return '<i class="icofont icofont-file-text"></i>' + '   ' + data
			       					}
			       				}
			       			}
			       		}],
       		sPaginationType: 'simple',
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlShow').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistVeps();
	});

	function llenarDatoslistVeps(){
		$.ajax($('#urlGetVeps').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
		});
	}
</script>
</body>
</html>
