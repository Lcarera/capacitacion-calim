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
		                    <h4><g:message code="zifras.cuenta.Cuenta.list.label" default="Buscar Cuentas"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_USER,ROLE_VENTAS,ROLE_SM,ROLE_SE,ROLE_COBRANZA">
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
					<div class="row">
						<div class="col-sm-5 col-md-7">
							<input id="busqueda" type="text" class="form-control" value="" placeholder="Nombre, email ó CUIT a buscar...">
						</div>
						
						<div class="col-sm-6 col-md-1" style="text-align:right; margin-top: 6px;">
							<label>Filtro:</label>
						</div>
						<div class="col-sm-6 col-md-3">
							<select id="cbFiltro" name="filtro" class="form-control">
								<option value="todos" selected="true">Todos</option>
								<option value="cuit">CUIT</option>								
								<option value="razon_social">Razón Social</option>
								<option value="email">Email</option>
								<option value="telefono">Telefono</option>
							</select>
						</div>

						<div class="col-sm-1">
							<button type="button" id="btnBuscar" class="btn btn-primary waves-effect waves-light " onclick="buscar()">Buscar</button>
						</div>
					</div>
				</div>
			</div>

			<div id="divListCuentas" class="card" style="display:none;">
				<div class="card-block">
					<div class="dt-responsive table-responsive">
						<table id="listCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>CUIT</th>
									<th>Razón Social</th>
									<th>Email</th>
									<th>Teléfono</th>
									<th>Etiqueta</th>
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
		$("#busqueda").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#btnBuscar").click()
			}
		});
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
				sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay resultados.')}</a>",
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
					window.open($('#urlShow').text() + '/' + aData['id'], '_blank');
				});
			}
		});

		$('#loaderCuenta').fadeOut('slow', function() {
	        $(this).hide();
	    });
		
		/*$('#global_filter').keyup(function() {
			tabla.search($('#global_filter').val()).draw();
		});*/
	});

	function buscar(){
		$('#divListCuentas').show()
		$('#loaderCuenta').show()
		tabla.clear().draw();
		let campo
		if ($("#cbFiltro").val() == "todos")
			campo = "todos"
		else if ($("#cbFiltro").val() == "cuit")
			campo = "cuit"
		else if ($("#cbFiltro").val() == "email")
			campo = "email"
		else if ($("#cbFiltro").val() == "razon_social")
			campo = "razon_social"
		else if ($("#cbFiltro").val() == "telefono")
			campo = "telefono"
		$.ajax("${createLink(action:'ajaxBuscarSQL')}", {
			dataType: "json",
			data: {
				campo: campo,
				filtro: $("#busqueda").val()
			}
		}).done(function(data) {
			if (data.length == 1){
				window.location.href = $('#urlShow').text() + '/' + data[0].id;
				return
			}
			for(key in data){
				tabla.row.add(data[key]);
			}
			$('#loaderCuenta').fadeOut('slow', function() {
		        $(this).hide();
		    });
			tabla.draw();
		});
	}
</script>
</body>
</html>