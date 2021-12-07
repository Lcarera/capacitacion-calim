<!DOCTYPE html>
<html lang="en">

<head>
    <div class="theme-loader" id="loaderCuenta">
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
	<meta name="layout" content="main">	
</head>

<body>
<%@ page import="com.zifras.User" %>
<div style="display: none;">
	<div id="urlGetCuentasList">
		<g:createLink controller="cuenta" action="ajaxGetListDeudasCcma" />
	</div>
	<div id="urlShow">
		<g:createLink controller="cuenta" action="show" />
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
		                    <h4>Lista de Deudas CCMA</h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_USER">
						<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Cuenta']"/></g:link>
						</sec:ifAnyGranted>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block">
					<div class="dt-responsive table-responsive" id="divListCuentas">
						<table id="listCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>CUIT</th>
									<th>Razón Social</th>
									<th>Email</th>
									<th>Teléfono</th>
									<th>Estado</th>
									<th>Abono Activo</th>
									<th>Cond. IVA</th>
									<th>Fecha de Consulta</th>
									<th>Saldo Deudor</th>
									<th>Saldo Acreedor</th>
									<th>Ùltimos 3 meses pagos</th>
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
				sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay cuentas ¡Agrega una cuenta!')}</a>",
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
			//scrollX: true,
			aaSorting: [
				[8, 'desc'],
				[9, 'asc'],
				[0, 'desc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "cuit",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [1],
			       			"mData": "razonSocial"
			       		},{
			       			"aTargets": [2],
			       			"mData": "email"
			       		},{
			       			"aTargets": [3],
			       			"mData": "telefono"
			       		},{
			       			"aTargets": [4],
			       			"mData": "estado"
			       		},{
			       			"aTargets": [5],
			       			"mData": "abonoActivo"
						},{
			       			"aTargets": [6],
			       			"mData": "condicionIva"
						},{
			       			"aTargets": [7],
			       			"mData": "fechaConsulta",
  	 						"type": "date-eu"
						},{
			       			"aTargets": [8],
			       			"mData": "deuda",
  	 						"sClass" : "text-right",
							"sType": "numeric-comma"
						},{
			       			"aTargets": [9],
			       			"mData": "aFavor",
  	 						"sClass" : "text-right",
							"sType": "numeric-comma"
						},{
			       			"aTargets": [10],
			       			"mData": "ultimos3MesesPagos"
			       		}],
  			buttons: [
						$.extend(true, {}, {
							exportOptions: {
								// columns: [0, 1, 2, 3, 4, 5, 6],
								format: {
									body: function (data, row, column, node) {
										data = $('<p>' + data + '</p>').text();
										const dataNumerica = data.replace(/\./g, '').replace(',', '.');
										return $.isNumeric(dataNumerica) ? dataNumerica : data;
									}
								}
							}
						}, {
							extend: 'excelHtml5',
							title: function () {
								var nombre = "Deudas CCMA"
								return nombre;
							}
						}),
						{
							extend: 'pdfHtml5',
							orientation: 'landscape',
							title: function () {
								var nombre = "Deudas CCMA"
								return nombre;
							}
						},
						{
							extend: 'copyHtml5'
						}
					],
       		sPaginationType: 'simple',
       		sDom: "lBfrtip",
       		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
       			if (aData['etiqueta']=='Rojo')
       				$(nRow).css({"background-color":"#CD6155","color":"white"});
       			else if (aData['etiqueta']=='Verde')
       				$(nRow).css({"background-color":"#73C6B6","color":"white"});
       			else if (aData['etiqueta']=='Amarillo')
       				$(nRow).css({"background-color":"#F4D03F","color":"black"});
       			else if (aData['etiqueta']=='Naranja')
       				$(nRow).css({"background-color":"#FC7600","color":"black"});
				// Row click
				$(nRow).on('click', function() {
					// window.location.href = $('#urlShow').text() + '/' + aData['id'];
					window.open($('#urlShow').text() + '/' + aData['id'], '_blank');
				});
			}
		});

		llenarDatoslistCuentas();
		
		/*$('#global_filter').keyup(function() {
			tabla.search($('#global_filter').val()).draw();
		});*/
	});

	function llenarDatoslistCuentas(){
		$.ajax($('#urlGetCuentasList').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			$('#loaderCuenta').fadeOut('slow', function() {
		        $(this).remove();
		    });
			for(key in data){
				tabla.row.add(data[key]);
			}
			$("#divListCuentas").show();
			tabla.draw();
			
		});
	}
</script>
</body>
</html>