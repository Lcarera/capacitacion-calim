<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>	
<div style="display: none;">
	<div id="urlGetClientes">
		<g:createLink controller="agenda" action="ajaxGetClientesOProveedoresList" />
	</div>

	<div id="urlShowClientes">
		<g:createLink controller="agenda" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="agenda" action="edit" />
	</div>
</div>

<div class="main-body">
	
	<div class="page-wrapper">	
		<div class="col-sm-6">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.agendaClientes.list.label" default="Lista de proveedores"/></h4><br>
						</div>
					</div>
				</div>
		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<div class="dt-responsive table-responsive">
						<div id="preloader" class="preloader3" style="display:none;">
							<div class="circ1 loader-primary"></div>
							<div class="circ2 loader-primary"></div>
							<div class="circ3 loader-primary"></div>
							<div class="circ4 loader-primary"></div>
						</div>
						<div id="divTablaProveedoresId">
							<table id="listProveedores" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
								<thead>
									<tr>
										<th>Razon Social</th>
										<th>CUIT</th>
										<th>Domicilio</th>
										<th>Email</th>
										<th>Alias</th>
										<th>Nota</th>
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

<script type="text/javascript">
var tablaProveedores;


jQuery(document).ready(function() {

    tablaProveedores = $('#listProveedores').DataTable({
		"ordering": true,
		"searching": true,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay proveedores')}</a>",
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
		iDisplayLength: 100,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
			   			"mData": "razonSocial",
			   			'sClass': 'bold'
					},{
		       			"aTargets": [1],
		       			"mData": "cuit",
		       			'sClass': 'text-right'
		       		},{
		       			"aTargets": [2],
		       			"mData": "domicilio",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [3],
		       			"mData": "email",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [4],
		       			"mData": "alias",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [5],
		       			"mData": "nota",
		       			"sClass" : "text-right"
					}],
    	select: {
             style: 'os',
             selector: 'td:first-child',
             style: 'multi'
        },
		sPaginationType: 'simple',
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlEdit').text() + '?id=' + aData['id'] + '&tipo=proveedores';
				});
			}
		
	});
	llenarDatoslistProveedores();
	});
	

	function llenarDatoslistProveedores(){	
	tablaProveedores.clear().draw();
	$("#preloader").show();
	$.ajax($('#urlGetClientes').text(), {
		dataType: "json",
		data: {
			cuentaId: "${cuentaId}",
			tipo: "proveedor"
		}
	}).done(function(data) {
		$("#preloader").hide();
		for(key in data){
			tablaProveedores.row.add(data[key]).draw();
		}
		tablaProveedores.draw();
	});
	}
</script>
</body>
</html>