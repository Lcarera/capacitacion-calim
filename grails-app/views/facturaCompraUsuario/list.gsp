<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetFacturasCompra">
		<g:createLink controller="FacturaCompra" action="ajaxGetFacturasCompra" />
	</div><!-- 
	<div id="urlShow">
		<g:createLink controller="FacturaCompra" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="FacturaCompra" action="edit" />
	</div>	 -->
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-sm-6">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.FacturaCompra.list.label" default="Lista de Facturas de Compra"/></h4>
						</div>
					</div>
				</div>
				<div class="col-sm-6 filtro-busqueda">
					<div style="" class="d-inline">
						<input id="mes" name="mes" style="width:90px;text-align:center;" class="form-control d-inline" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
						<input id="ano" name="ano" style="width:90px;text-align:center;margin-left:10px;" class="form-control d-inline" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listFacturasCompra" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Fecha</th>
									<th>Proveedor</th>
									<th>Tipo</th>
									<th>Numero</th>
									<th>Neto</th>
									<th>Iva</th>
									<th>Total</th>
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
		tabla = $('#listFacturasCompra').DataTable({
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "<i class='ti-search'></i>",
				sLengthMenu: "_MENU_",
				sZeroRecords: "${message(code: 'zifras.FacturaCompra.list.agregar', default: 'No se registran facturas para el mes seleccionado')}</a>",
				sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
				sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
				sInfoPostFix: "",
				sUrl: "",
				sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
				oPaginate: {
					"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
					"sPrevious":"<",
					"sNext":	">",
					"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
				}
			},
			aaSorting: [
				[0, 'asc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "fecha",
			       			"type": "date-eu"
			       		},{
			       			"aTargets": [1],
			       			"mData": "personaNombre"
						},{
			       			"aTargets": [2],
			       			"mData": "tipoComprobante"
						},{
			       			"aTargets": [3],
			       			"mData": "numeroFactura"
						},{
			       			"aTargets": [4],
			       			"mData": "neto",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [5],
			       			"mData": "iva",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [6],
			       			"mData": "total",
			       			"sClass" : "text-right"
						}],

       		sPaginationType: 'simple',
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				if(aData['advertencia']!=''){
	   	   			$(nRow).css({"background-color":"red","color":"white"});
	   	   	   	}
				$(nRow).on('click', function() {
					// window.location.href = $('#urlShow').text() + '/' + aData['id'];
				});
			},
			dom:"<'row'<'col-xs-12 col-sm-12 col-md-12'f>><'row'<'col-xs-12 col-sm-12'tr>><'row datatable-paginado'<'d-inline datatable-desde-hasta'i><'d-inline'p>>"
		});

		llenarDatoslistFacturasCompra();

		$("#mes").dateDropper( {
	        dropWidth: 200,
	        dropPrimaryColor: "#1abc9c", 
	        dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "m",
			lang: "es"
	    });

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
			llenarDatoslistFacturasCompra();
		});

		$("#mes").change(function () {
			llenarDatoslistFacturasCompra();
		});
	});

	function llenarDatoslistFacturasCompra(){
		tabla.clear()
		$.ajax($('#urlGetFacturasCompra').text(), {
			dataType: "json",
			data: {
				ano: $("#ano").val(),
				cuentaId: "${cuentaId}",
				mes: $("#mes").val()
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