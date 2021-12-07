<!DOCTYPE html>
<html lang="en">

<head>
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
	<meta name="layout" content="main">	
</head>

<body>
<%@ page import="com.zifras.User" %>
<div style="display: none;">
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
		                    <h4><g:message code="zifras.cuenta.Cuenta.list.label" default="Lista de Deliverys"/></h4>
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
									<th>Email</th>
									<th>Fecha Alta</th>
									<th>Paso Registro</th>
									<th>Pagado</th>
									<th>Inscripto Afip</th>
									<th>App Bajada</th>
									<th>Clave Fiscal</th>
									<th>Fotos</th>
									<th>PuntoVenta</th>
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
				[11, 'desc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "cuit",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [1],
			       			"mData": "nombre"
						},{
			       			"aTargets": [2],
			       			"mData": "email"
						},{
			       			"aTargets": [3],
			       			"mData": "fechaAlta",
			       			"type": "date-eu"
						},{
			       			"aTargets": [4],
			       			"mData": "pasoRegistro"
						},{
			       			"aTargets": [5],
			       			"mData": "sePagado"
						},{
							"aTargets": [6],
			       			"mData": "inscriptoAfip",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				       		}
						},{
			       			"aTargets": [7],
			       			"mData": "app",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
						},{
			       			"aTargets": [8],
			       			"mData": "claveFiscal",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
						},{
			       			"aTargets": [9],
			       			"mData": "fotos",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
						},{
			       			"aTargets": [10],
			       			"mData": "puntoVenta",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
						},{
			       			"aTargets": [11],
			       			"mData": "milisegundos",
			       			"visible": false
						}],
  			buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Cuentas";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Cuentas";
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
					window.location.href = $('#urlShow').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistCuentas();
		
	});

	function llenarDatoslistCuentas(){
		$.ajax("${createLink(action:'ajaxGetCuentasDeliverySQL')}", {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			$('#loaderGrande').fadeOut('slow', function() {
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