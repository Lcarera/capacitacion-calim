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
		                    <h4><g:message code="zifras.cuenta.Cuenta.list.label" default="Lista de Cuentas"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_USER,ROLE_VENTAS,ROLE_SM,ROLE_SE,ROLE_COBRANZA">
						<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Cuenta']"/></g:link>
						<button style="display:none;" id="buttonImportar" type="button" class="btn btn-primary waves-effect waves-light " onclick="$('#modalImport').modal('show');">Importar</button>
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

<div class="modal fade" id="modalImport" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Cuentas a importar</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:uploadForm name="importarCuentas" action="importarCuentas">
				<fieldset>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Archivo</label>
					<div class="col-sm-10">
						<input id="file" name="file" type="file" class="form-control">
					</div>
				</div>
				</fieldset>
				</g:uploadForm>
			</div>
			<div class="modal-footer">
				<button id="buttonLocalVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonLocalAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="$('#importarCuentas').submit();">Aceptar</button>
			</div>
		</div>
	</div>
</div>
<sec:ifAnyGranted roles="ROLE_ADMIN">
	<style type="text/css">
		.fred {
		  height: 36px;
		  width: 65px;
		  text-align: center; 
		}
	</style>
</sec:ifAnyGranted>
<sec:ifAnyGranted roles="ROLE_USER,ROLE_VENTAS,ROLE_COBRANZA,ROLE_SM,ROLE_SE">
	<style type="text/css">
		.fred {
			visibility: hidden;
		}
	</style>
</sec:ifAnyGranted>
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
  			buttons: [{
  	  				extend: 'excelHtml5',
  	  				className: 'fred',
 					title: function () {
 							var nombre = "Cuentas";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	className: 'fred',
   	            	title: function () {
   	            		var nombre = "Cuentas";
							return nombre;
 					}
 				},{
 					extend: 'copyHtml5',
 					className: 'fred'
 				}],
       		sPaginationType: 'simple',
       		sDom: "lBfrtip",
       		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
       			if (! "${etiqueta}"){
	       			if (aData['etiqueta']=='Rojo')
	       				$(nRow).css({"background-color":"#CD6155","color":"white"});
	       			else if (aData['etiqueta']=='Verde')
	       				$(nRow).css({"background-color":"#73C6B6","color":"white"});
	       			else if (aData['etiqueta']=='Amarillo')
	       				$(nRow).css({"background-color":"#F4D03F","color":"black"});
       			else if (aData['etiqueta']=='Naranja')
       				$(nRow).css({"background-color":"#FC7600","color":"black"});
       			}
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlShow').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistCuentas();
		
		/*$('#global_filter').keyup(function() {
			tabla.search($('#global_filter').val()).draw();
		});*/
	});

	function llenarDatoslistCuentas(){
		$.ajax("${createLink(action:'ajaxGetCuentasSQL')}", {
			dataType: "json",
			data: {
				etiqueta: "${etiqueta}"
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