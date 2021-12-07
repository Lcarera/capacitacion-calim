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
	<div id="urlGetLiquidacionesGananciaList">
		<g:createLink controller="liquidacionGanancia" action="ajaxGetLiquidacionesGananciaList" />
	</div>
	<div id="urlShow">
		<g:createLink controller="liquidacionGanancia" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="liquidacionGanancia" action="edit" />
	</div>
	<div id="urlCreate">
		<g:createLink controller="liquidacionGanancia" action="create" />
	</div>
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-10">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.liquidacion.LiquidacionGanancia.list.label" default="Liquidaciones de Ganancias"/></h4>
		                    <button style="display:none;" id="buttonImportar" type="button" class="btn btn-primary waves-effect waves-light " onclick="$('#modalImport').modal('show');">Importar</button>
						</div>
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
						<table id="listCuentas" class="table table-striped table-bordered nowrap" style="">
							<thead>
								<tr>
									<th></th>
									<th>Direccion</th>
									<th>Cuit</th>
									<th>Razón Social</th>
									<th>Estado</th>
									<th>Renta imp.</th>
									<th>Imp. det.</th>
									<th>Consumido</th>
									<th>Impuesto</th>
									<th>Ret.</th>
									<th>Per.</th>
									<th>Ant.</th>
									<th>Imp.Deb/Cred</th>
									<th>Nota</th>
									<th>Zona</th>
									<th>Cant. Locales</th>
									<th>Locales</th>
									<th>Advertencia</th>
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
        	columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17],
            format: {
            	body: function ( data, row, column, node ) {
                	data = $('<p>' + data + '</p>').text();
                	data = data.replace(/\./g, '');
                	return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
                }
            }
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
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando liquidaciones')}</a>",
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
			   			'orderable': false,
			   			"mData": "selected",
			   			"mRender": function ( data, type, full ) {
			       			var salida;
			
							var link1;
							var link2;
							
			       			salida = '<a class="dropdown-toggle addon-btn" data-toggle="dropdown" aria-expanded="true">' +
			                '<i class="icofont icofont-ui-settings"></i>' +
			                '</a>';
			
			                if(full['id']){
			                	link1 = $('#urlShow').text() + '/' + full['id'];
			       				link2 = $('#urlEdit').text() + '/' + full['id'];
			       				
			                	salida+='<div class="dropdown-menu dropdown-menu-right">' +
			                    				'<a class="dropdown-item" href="' + link1 + '" target="_blank"><i class="icofont icofont-attachment"></i>Mostrar</a>' +
			                    				'<a class="dropdown-item" href="' + link2 + '" target="_blank"><i class="icofont icofont-ui-edit"></i>Editar</a>' +
			                			'</div>';
			                }else{
			                	link1 = $('#urlCreate').text() + '/?cuentaId=' + full['cuentaId'] + '&ano=' + full['ano'];
			
			                	salida+='<div class="dropdown-menu dropdown-menu-right">' +
			            					'<a class="dropdown-item" href="' + link1 + '" target="_blank"><i class="icofont icofont-ui-edit"></i>Editar</a>' +
			        					'</div>';
			                }
			   				return salida;
			   	       	}
					},{
		       			"aTargets": [1],
		       			"mData": "direcciones"
			       	},{
		       			"aTargets": [2],
		       			"mData": "cuentaCuit",
			   			'sClass': 'bold'
					},{
		       			"aTargets": [3],
		       			"mData": "cuentaNombre"
		       		},{
		       			"aTargets": [4],
		       			"mData": "estado"
		       		},{
		       			"aTargets": [5],
		       			"mData": "rentaImponible",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [6],
		       			"mData": "impuestoDeterminado",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [7],
		       			"mData": "consumido",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [8],
		       			"mData": "impuesto",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [9],
		       			"mData": "retencion",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [10],
		       			"mData": "percepcion",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [11],
		       			"mData": "anticipos",
		       			"sClass" : "text-right"
			       	},{
		       			"aTargets": [12],
		       			"mData": "impuestoDebitoCredito",
		       			"sClass" : "text-right"
			       	},{
		       			"aTargets": [13],
		       			"mData": "nota",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [14],
		       			"mData": "zonas"
					},{
		       			"aTargets": [15],
		       			"mData": "cantidadLocales",
		       			"sClass" : "text-right"
			       	},{
		       			"aTargets": [16],
		       			"mData": "locales",
		       			"sClass" : "text-right"
			       	},{
		       			"aTargets": [17],
		       			"mData": "advertencia",
		       			"sClass" : "text-right"
					}],
    	buttons: [
   	            $.extend( true, {}, buttonCommon, {
					extend: 'excelHtml5',
					exportOptions: {
   	            		columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]
   	            	},
					title: function () {
							var nombre = "Liquidaciones Ganancias " + $("#ano").val();
							return nombre;
						}
				} ),
   	            {
   	            	extend: 'pdfHtml5',
   	            	exportOptions: {
   	            		columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]
   	            	},
   	            	orientation: 'landscape',
   	            	title: function () {
						var nombre = "Liquidaciones Ganancias " + $("#ano").val();
						return nombre;
					}
				},
				{
					extend: 'copyHtml5',
					exportOptions: {
						columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]
   	            	},
				}
   	        ],
		sPaginationType: 'simple',
		sDom: "lBfrtip",
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
   	   		if(aData['advertencia']!=''){
   	   			$(nRow).css({"background-color":"red","color":"white"});
   	   	   	}
			// Row click
			/*$(nRow).on('click', function() {
				if(aData['estado']!='Sin liquidar'){
					window.location.href = $('#urlShow').text() + '/' + aData['id'];
				}else{
					window.location.href = $('#urlCreate').text() + '/?cuentaId=' + aData['cuentaId'];
				}				
			});*/
		}
	});

	llenarDatoslistLiquidacionesGanancia();

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
		llenarDatoslistLiquidacionesGanancia();
	});
});

function llenarDatoslistLiquidacionesGanancia(){
	var ano = $("#ano").val();
	tabla.clear().draw();
	$("#loaderGrande").show();
	$.ajax($('#urlGetLiquidacionesGananciaList').text(), {
		dataType: "json",
		method: "POST",
		data: {
			ano: ano
		}
	}).done(function(data) {
		for(key in data){
			tabla.row.add(data[key]);
		}
		$('#loaderGrande').fadeOut('slow', function() {
			$(this).hide();
		});
		tabla.draw();
	});
}
</script>
</body>
</html>