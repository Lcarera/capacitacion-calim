<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-sm-6">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.cuenta.facturaCuenta.usuario.list.label" default="Listado de Facturas"/></h4>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->

		<div class="page-body tab-icon">
			 <div class="row">
			 	<div class="col-sm-12">
			 		<div class="card">

			 			<div class="card-block tab-icon">
			 				<div class="row">
			 					<div class="col-lg-12 col-xl-12">
										<div class="tab-pane" id="facturas" role="tabpanel">
											<div class="dt-responsive table-responsive">
												<div id="preloaderFacturas" class="preloader3" style="display:none;height:50px;">
													<div class="circ1 loader-primary"></div>
													<div class="circ2 loader-primary"></div>
													<div class="circ3 loader-primary"></div>
													<div class="circ4 loader-primary"></div>
												</div>
												<table id="listFacturas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
													<thead>
														<tr>
															<th>Fecha</th>
															<th>Descripción</th>
															<th>Importe</th>
															<th>PDF</th>
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
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var tablaFacturas;

jQuery(document).ready(function() {
    var buttonCommon = {
        exportOptions: {
        	columns: [ 0, 1, 2, 3],
            format: {
            	body: function ( data, row, column, node ) {
                	data = $('<p>' + data + '</p>').text();
                	data = data.replace(/\./g, '');
                	return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
                }
            }
        }
    };

	tablaFacturas = $('#listFacturas').DataTable({
		"ordering": true,
		"searching": true,
		"order": [[ 0, "desc" ]],
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay facturas')}</a>",
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
		aoColumnDefs: [{
			   			"aTargets": [0],
			   			'orderable': false,
			   			"mData": "fecha",
		       			"type": "date-eu"
					},{
		       			"aTargets": [1],
		       			"mData": "descripcion",
			   			'sClass': 'bold'
					},{
		       			"aTargets": [2],
		       			"mData": "importe"
		       		},{
		       			"aTargets": [3],
		       			"mData": "nombreArchivo",
		       			"mRender":function ( data, type, full ) {
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
    	buttons: [
   	            $.extend( true, {}, buttonCommon, {
					extend: 'excelHtml5',
					exportOptions: {
   	            		columns: [ 0, 1, 2, 3]
   	            	},
   	            	title: function () {
							var nombre = "Facturas Calim ";
							return nombre;
						}
				} ),
   	            {
   	            	extend: 'pdfHtml5',
   	            	exportOptions: {
   	            		columns: [ 0, 1, 2, 3]
   	            	},
   	            	orientation: 'landscape',
   	            	title: function () {
						var nombre = "Facturas Calim ";
						return nombre;
					}
				},
				{
					extend: 'copyHtml5',
					exportOptions: {
   	            		columns: [0, 1, 2, 3]
   	            	},
				}
   	        ],
		sPaginationType: 'simple',
		sDom: "lBfrtip",
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
   	   		$(nRow).on('click', function() {
				window.location.href = '${createLink(controller:"miCuenta", action:"downloadFactura")}' + '/' + aData['id'];
			});
		}
	});

	llenarDatoslistFacturas();
});

function llenarDatoslistFacturas(){
	tablaFacturas.clear().draw();
	$("#preloaderFacturas").show();
	$.ajax('${createLink(controller:"miCuenta", action:"ajaxGetFacturasList")}', {
		dataType: "json",
		method: "POST",
		data: {
		}
	}).done(function(data) {
		$("#preloaderFacturas").hide();
		for(key in data){
			tablaFacturas.row.add(data[key]);
		}
		tablaFacturas.draw();
	});
}
</script>
</body>
</html>