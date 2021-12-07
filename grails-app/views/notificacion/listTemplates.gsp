<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetTemplates">
		<g:createLink controller="notificacion" action="ajaxGetTemplates" />
	</div>
	<div id="urlShow">
		<g:createLink controller="notificacion" action="showTemplate" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="notificacion" action="editTemplate" />
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
		                    <h4><g:message code="zifras.documento.ComprobantePago.list.label" default="Lista de Plantillas de Notificaciones"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<g:link action="createTemplate" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Plantilla']"/></g:link>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listTemplates" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Nombre</th>
									<th>Asunto Mail</th>
									<th>Titulo App</th>
									<th>Texto App</th>
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
var tablaTemplates;
var banderaBeforeSend = true;

	jQuery(document).ready(function() {
		tablaTemplates = $('#listTemplates').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			"pageLength": 25,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.comprobantePago.ComprobantePago.list.agregar', default: 'No hay Plantillas')}</a>",
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
				[1, 'desc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "nombre",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [1],
			       			"mData": "asuntoEmail"
						},{
			       			"aTargets": [2],
			       			"mData": "tituloApp"			       			
						},{
			       			"aTargets": [3],
			       			"mData": "textoApp"	       			
			       		}],
       		sPaginationType: 'simple',
       		sDom: "flrtip",
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistNotificacionTemplates();
	});

	function llenarDatoslistNotificacionTemplates(){
		tablaTemplates.clear().draw();
		$.ajax($('#urlGetTemplates').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			console.log(data)
			for(key in data){
				tablaTemplates.row.add(data[key]);
			}
			tablaTemplates.draw();
		});
	}
</script>
</body>
</html>