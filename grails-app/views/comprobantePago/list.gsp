<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetComprobantesPago">
		<g:createLink controller="comprobantePago" action="ajaxGetComprobantesPago" />
	</div>
	<div id="urlShow">
		<g:createLink controller="comprobantePago" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="comprobantePago" action="edit" />
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
		                    <h4><g:message code="zifras.documento.ComprobantePago.list.label" default="Lista de Comprobantes de Pago"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Comprobante de Pago']"/></g:link>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listComprobantesPago" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Cuenta</th>
									<th>Fecha presentación</th>
									<th>Declaracion</th>
									<th>Importe</th>
									<th>Periodo</th>
									<th>Descripción</th>
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
var tablaComprobantes;
var banderaBeforeSend = true;

	jQuery(document).ready(function() {
		tablaComprobantes = $('#listComprobantesPago').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.comprobantePago.ComprobantePago.list.agregar', default: 'No hay Comprobantes de Pago')}</a>",
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
			       			"mData": "cuentaNombre",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [1],
			       			"mData": "fecha",
			       			"type": "date-eu"
						},{
			       			"aTargets": [2],
			       			"mData": "declaracionDescripcion"			       			
						},{
			       			"aTargets": [3],
			       			"mData": "importe"	       			
						},{
			       			"aTargets": [4],
			       			"mData": "periodo",
			       			"type": "date-eu"
						},{
			       			"aTargets": [5],
			       			"mData": "descripcion"
						},{
			       			"aTargets": [6],
			       			"mData": "nombreArchivo"
			       		}],
       		buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Comprobantes de Pago";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Comprobantes de Pago";
							return nombre;
 					}
 				},{
 					extend: 'copyHtml5'
 				}],
       		sPaginationType: 'simple',
       		sDom: "Bflrtip",
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistComprobantesPago();
	});

	function llenarDatoslistComprobantesPago(){
		tablaComprobantes.clear().draw();
		$.ajax($('#urlGetComprobantesPago').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			for(key in data){
				tablaComprobantes.row.add(data[key]);
			}
			tablaComprobantes.draw();
		});
	}
</script>
</body>
</html>