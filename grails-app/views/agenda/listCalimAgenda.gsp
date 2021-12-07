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
		<g:createLink controller="cuenta" action="ajaxGetCuentasSQL" />
	</div>
	<div id="urlShowClientesProveedores">
		<g:createLink controller="agenda" action="clientesProveedoresBack" />
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
		                    <h4><g:message code="zifras.cuenta.Cuenta.list.label" default="Selecciona una cuenta"/><br></h4>
						</div>
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
									<th>Teléfono</th>
									<th>Cond. IVA</th>
									<th>AppCalim</th>
									<th>Delivery</th>
									<th>Provincia IIBB</th>
									<th>Reg. IIBB</th>
									<th>Email</th>
									<th>Cat. Mono.</th>
									<th>Punto Venta</th>
									<th>AFIP</th>
									<th>IIBB</th>
									<th>Info.Revisada</th>
									<th>Etiqueta</th>
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
				[8, 'desc']
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
			       			"mData": "telefono"
						},{
			       			"aTargets": [3],
			       			"mData": "condicionIva"
						},{
							"aTargets": [4],
			       			"mData": "appCalimDescargada",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				       		}
						},{
			       			"aTargets": [5],
			       			"mData": "trabajaConApp",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
						},{
			       			"aTargets": [6],
			       			"mData": "porcentajesProvinciaIIBB"
						},{
			       			"aTargets": [7],
			       			"mData": "regimenIibb"
			       		},{
			       			"aTargets": [8],
			       			"mData": "email"
			       		},{
			       			"aTargets": [9],
			       			"mData": "categoriaMonotributo"
						},{
					    	"aTargets": [10],
			       			"mData": "puntoVenta",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
			       		},{
			       			"aTargets": [11],
			       			"mData": "afipMiscomprobantes",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
			       		},{
			       			"aTargets": [12],
			       			"mData": "ingresosBrutos",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
			       		},{
			       			"aTargets": [13],
			       			"mData": "infoRevisada",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
			       		},{
			       			"aTargets": [14],
			       			"mData": "etiqueta"
			       		}],

			       		buttons: [],
       		sPaginationType: 'simple',
       		sDom: "Bfrtipl",
       		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlShowClientesProveedores').text() + '/' + aData['id'];
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
			console.log(data)
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