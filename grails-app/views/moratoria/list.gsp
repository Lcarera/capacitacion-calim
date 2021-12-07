<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetCuentasMoratoria">
		<g:createLink controller="moratoria" action="ajaxGetCuentasMoratoria" />
	</div>
	<div id="urlShow">
		<g:createLink controller="moratoria" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="moratoria" action="edit" />
	</div>	
	<div id="urlCreate">
		<g:createLink controller="moratoria" action="create" />
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
		                    <h4><g:message code="zifras.documento.FacturaCuenta.list.label" default="Lista de Cuentas con SE Moratoria pago"/></h4>
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
						<div id="preloader" class="preloader3" style="display:none;height:50px;">
							<div class="circ1 loader-primary"></div>
							<div class="circ2 loader-primary"></div>
							<div class="circ3 loader-primary"></div>
							<div class="circ4 loader-primary"></div>
						</div>
						<table id="listCuentasMoratoria" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Fecha Adquisicion SE</th>
									<th>Cuit</th>
									<th>Nombre</th>
									<th>Mail</th>
									<th>Fecha Inicio</th>
									<th>Fecha fin</th>
									<th>Importe total</th>
									<th>Cuotas totales</th>
									<th>Cuotas vencidas</th>
									<th>Estado</th>
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

		tabla = $('#listCuentasMoratoria').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			iDisplayLength: 50,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.documento.FacturaCuenta.list.agregar', default: 'No hay Facturas de Cuentas')}</a>",
				sEmptyTable: "No se encontraron cuentas con moratoria",
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
							"aTargets":[0],
							"mData": "fechaAdquisicionSE",
							"type": "date-eu"
						},{
			       			"aTargets": [1],
			       			"mData": "cuit"
						},{
			       			"aTargets": [2],
			       			"mData": "nombreApellido"
						},{
			       			"aTargets": [3],
			       			"mData": "email"
						},{
			       			"aTargets": [4],
			       			"mData": "fechaInicioMoratoria",
			       			"type" : "date-eu"
						},{
			       			"aTargets": [5],
			       			"mData": "fechaFinMoratoria",
			       			"type" : "date-eu"
			       		},{
			       			"aTargets": [6],
			       			"mData": "importeMoratoria",
			       			"sClass" : "text-right"
			       		},{
			       			"aTargets": [7],
			       			"mData": "cuotasTotalesMoratoria",
			       			"sClass" : "text-right"
			       		},{
			       			"aTargets": [8],
			       			"mData": "cuotasVencidasMoratoria",
			       			"sClass" : "text-right"
			       		},{
			       			"aTargets": [9],
			       			"mData":"estadoMoratoria"
			       		}],
			buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Facturas Cuenta";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Facturas Cuenta";
							return nombre;
 					}
 				},{
 					extend: 'copyHtml5'
 				}],
       		sPaginationType: 'simple',
       		sDom: "lBfrtip",
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					if(aData["estadoMoratoria"] == "-")
						window.location.href = $('#urlCreate').text() + '?cuentaId=' + aData['id']
					else
						window.location.href = $('#urlShow').text() + '?id=' + aData['id'] ;
				});	
			}
		});

		llenarDatoslistCuentasMoratoria();

	});
		function llenarDatoslistCuentasMoratoria(){
		tabla.clear().draw();
		$("#preloader").show();
		$.ajax($('#urlGetCuentasMoratoria').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			$("#preloader").hide();
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
			$('#loaderGrande').fadeOut('slow');
		});
	}
</script>
</body>
</html>
