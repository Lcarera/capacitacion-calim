<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetDeclaracionesJuradas">
		<g:createLink controller="declaracionJurada" action="ajaxGetDeclaracionesJuradasPorCuenta" />
	</div>
	<div id="urlShow">
		<g:createLink controller="declaracionJurada" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="declaracionJurada" action="edit" />
	</div>
	<div id="urlDownload">
		<g:createLink controller="declaracionJuradaUsuario" action="download" />
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
		                    <h4><g:message code="zifras.documento.DeclaracionJurada.list.label" default="Declaraciones Juradas"/></h4>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listDeclaracionesJuradas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Fecha</th>
									<th>Período</th>
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
		tabla = $('#listDeclaracionesJuradas').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.declaracionJurada.DeclaracionJurada.list.agregar', default: 'No hay Declaraciones Juradas')}</a>",
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
			       			"type": "date-eu"
						},{
			       			"aTargets":[1],
			       			"mData": "periodo"
						},{
			       			"aTargets": [2],
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
					window.location.href = $('#urlDownload').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistDeclaracionesJuradas();
	});

	function llenarDatoslistDeclaracionesJuradas(){
		$.ajax($('#urlGetDeclaracionesJuradas').text(), {
			dataType: "json",
			data: {
				cuentaId: "${cuentaId}"
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
