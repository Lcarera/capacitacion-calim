<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetVeps">
		<g:createLink controller="vep" action="ajaxGetVepsPorCuenta" />
	</div>
	<div id="urlGetVepsNoPagados">
		<g:createLink controller="vep" action="ajaxGetVepsPorCuentaNoPagos" />
	</div>
	<div id="urlDownload">
		<g:createLink controller="vep" action="download" />
	</div>	
	<input id="modalCuenta" name="cuentaIdModal" value="${cuentaId}"/>
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
				
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="row">
				<div class="col-lg-7">
					<div class="card">
						<div class="card-block">
							<div class="dt-responsive table-responsive">
								<table id="listVeps" class="table table-striped table-framed" style="cursor:pointer;width: 100%">
									<thead>
										<tr>
											<th style="border-top:0px;">Fecha Emitido</th>
											<th style="border-top:0px;">Tipo</th>
											<th style="border-top:0px;">Fecha Vencimiento</th>
										</tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
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
			"ordering": false,
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
			       			"mData": "fechaEmision",
			       			"type": "date-eu"
			       		},{
			       			"aTargets": [1],
			       			"mData": "tipo"
			       		},{
			       			"aTargets": [2],
			       			"mData": "vencimiento",
			       			"type": "date-eu"
			       		}],
       		sPaginationType: 'simple',
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlDownload').text() + '/' + aData['id'];
				});
			},
			dom:"<'row'<'col-xs-12 col-sm-12'tr>><'row datatable-paginado'<'d-inline'p>>"
		});

		llenarDatoslistVeps();
	});

	function llenarDatoslistVeps(){
		var cuentaId = $("#modalCuenta").val();

		if(${filtrarPorNoPagados}){
			$.ajax($('#urlGetVepsNoPagados').text(), {
				dataType: "json",
				data: {
					cuentaId: cuentaId,
				}
			}).done(function(data) {
				for(key in data){
					tabla.row.add(data[key]);
				}
				tabla.draw();
			});
		}else{
			$.ajax($('#urlGetVeps').text(), {
				dataType: "json",
				data: {
					cuentaId: cuentaId,
				}
			}).done(function(data) {
				for(key in data){
					tabla.row.add(data[key]);
				}
				tabla.draw();
			});
		}
	}
</script>
</body>
</html>
