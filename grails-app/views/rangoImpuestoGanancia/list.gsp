<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetRangoImpuestoGananciaList">
		<g:createLink controller="rangoImpuestoGanancia" action="ajaxGetRangoImpuestoGananciaList" />
	</div>
	<div id="urlShow">
		<g:createLink controller="rangoImpuestoGanancia" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="rangoImpuestoGanancia" action="edit" />
	</div>
	<div id="urlCreate">
		<g:createLink controller="rangoImpuestoGanancia" action="create" />
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
		                    <h4><g:message code="zifras.liquidacion.RangoImpuestoGanancia.list.label" default="Rango de ganancias"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div style="text-align:right;">
						<sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_USER">
						<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Rango']"/></g:link>
						</sec:ifAnyGranted>
					</div>
				</div>
				<div class="col-lg-2">
					<div style="text-align:right;">
						<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<div id="preloader" class="preloader3" style="display:none;height:50px;">
							<div class="circ1 loader-primary"></div>
							<div class="circ2 loader-primary"></div>
							<div class="circ3 loader-primary"></div>
							<div class="circ4 loader-primary"></div>
						</div>
						<table id="listCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Año</th>
									<th>Desde</th>
									<th>Hasta</th>
									<th>Fijo</th>
									<th>%</th>
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
	var buttonCommon = {
        exportOptions: {
        	columns: [ 1, 2, 3, 4, 5]
            /*format: {
            	body: function ( data, row, column, node ) {
                	data = $('<p>' + data + '</p>').text();
                	data = data.replace(/\./g, '');
                	return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
                }
            }*/
        }
    };
    
	tabla = $('#listCuentas').DataTable({
		//bAutoWidth: false,
		//bSortCellsTop: true,
		//BProcessing: true,
		"ordering": true,
		"searching": true,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando rangos')}</a>",
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
		//iDisplayLength: 100,
		//scrollX: true,
		aaSorting: [
			[1, 'asc']
		],
		aoColumnDefs: [{
			   			"aTargets": [0],
						"mData": "ano"
					},{
		       			"aTargets": [1],
		       			"mData": "desde",
			   			'sClass': 'bold',
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [2],
		       			"mData": "hasta",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [3],
		       			"mData": "fijo",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [4],
		       			"mData": "porcentaje",
		       			"sClass" : "text-right"
		       		}],
    	buttons: [
   	            $.extend( true, {}, buttonCommon, {
					extend: 'excelHtml5',
					title: function () {
							var nombre = "Rango Ganancias " + $("#ano").val();
							return nombre;
						}
				} ),
   	            {
   	            	extend: 'pdfHtml5',
   	            	exportOptions: {
   	            		columns: [ 1, 2, 3, 4, 5]
   	            	},
   	            	orientation: 'landscape',
   	            	title: function () {
						var nombre = "Rango Ganancias " + $("#ano").val();
						return nombre;
					}
				},
				{
					extend: 'copyHtml5',
					exportOptions: {
   	            		columns: [ 1, 2, 3, 4, 5]
   	            	},
				}
   	        ],
		sPaginationType: 'simple',
		sDom: "lBfrtip",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).on('click', function() {
				window.location.href = $('#urlEdit').text() + '/' + aData['id'];
			});
		}
	});

	llenarDatoslistRangosImpuestosGanancias();

	$("#ano").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "Y",
		minYear: 2010,
		maxYear: 2040,
		lang: "es"
    });

	$("#ano").change(function () {
		llenarDatoslistRangosImpuestosGanancias();
	});
});

function llenarDatoslistRangosImpuestosGanancias(){
	var ano = $("#ano").val();
	tabla.clear().draw();
	$("#preloader").show();
	$.ajax($('#urlGetRangoImpuestoGananciaList').text(), {
		dataType: "json",
		method: "POST",
		data: {
			ano: ano
		}
	}).done(function(data) {
		$("#preloader").hide();
		for(key in data){
			tabla.row.add(data[key]);
		}
		tabla.draw();
	});
}
</script>
</body>
</html>