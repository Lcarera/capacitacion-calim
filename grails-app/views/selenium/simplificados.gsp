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
				<div class="col-lg-4">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4>VEPs simplificado/unificado</h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div style="text-align:right;">
						<input id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
						<!--<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Liquidacion']"/></g:link>-->
					</div>
				</div>
				<div class="col-lg-4">
					<div style="text-align:right;">
						<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block">
					<div class="dt-responsive table-responsive">
						<button style="margin-bottom:20px;" type="button" class="btn btn-primary waves-effect waves-light" onclick="$('#modalAcciones').modal('show')">Acciones</button>
						<table id="listCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th id="listTh1"></th>
									<th>CUIT</th>
									<th>Local</th>
									<th>Razón Social</th>
									<th>Cond. IVA</th>
									<th>Reg. IIBB</th>
									<th>Vep Cargado</th>
									<th>Ok</th>
									<th>Error</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>

		<div class="modal fade" id="modalResultadoImportacion" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document" style="width:100%;max-width:1250px">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">Reporte</h4>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body" style="padding:0px;">

						<div class="col-md-12">
							<table id="listaResultado" class="table table-striped table-bordered nowrap" style="width: 100%;">
								<thead>
									<tr>
										<th>Cuenta</th>
										<th>Vep</th>
									</tr>
								</thead>
							</table>
						</div>

					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Continuar</button>
					</div>
				</div>
			</div>
		</div>

		<div class="modal fade" id="modalAcciones" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-sm" role="document" style="width:100%;max-width:625px">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">Acciones</h4>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body" style="padding:0px;">
						<br/>

						<div class="col-md-12">
							<div class="checkbox-fade fade-in-primary">
								<label class="check-task">
									<input id="vep" name="vep" type="checkbox">
									<span class="cr">
										<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
									</span>
									<span>Bajar vep</span>
								</label>
							</div>
						</div>

						<div class="col-md-12">
							<div class="checkbox-fade fade-in-primary">
								<label class="check-task">
									<input id="forzarOk" name="forzarOk" type="checkbox">
									<span class="cr">
										<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
									</span>
									<span>Marcar como OK</span>
								</label>
							</div>
						</div>

						<br/>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal" onclick="accion();">Aceptar</button>
						<button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Cancelar</button>
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
var tablaResultado;
var todoSeleccionado = false;

	jQuery(document).ready(function() {
		$('#listTh1').click(function() {
			if(todoSeleccionado===true){
				$('#listTh1').parent().removeClass("selected");
				todoSeleccionado = false;
				tabla.rows().deselect();
			}else{
				$('#listTh1').parent().addClass("selected");
				todoSeleccionado = true;
				tabla.rows({ filter: 'applied' }).select();
			}
		});
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

		$("#mes").change(function () {
			llenarDatoslistCuentas()
		});

		$("#ano").change(function () {
			llenarDatoslistCuentas()
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
				sZeroRecords: "Ninguna cuenta completó la etapa 1.",
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
				},
				buttons: {
					selectAll: "Todos",
					selectNone: "Ninguno"
				}
			},
			//iDisplayLength: 100,
			//scrollX: true,
			aaSorting: [
				[7, 'desc'],
				[4, 'asc'],
				[5, 'asc'],
				[1, 'asc']
			],
			aoColumnDefs: [
					{
						"aTargets": [0],
			   			'orderable': false,
			   			'className': 'select-checkbox',
			   			"mData": "selected"
					},{
						"aTargets": [1],
						"mData": "cuit",
						'sClass': 'bold'
					}, {
						"aTargets": [2],
						"mData": "local",
						"visible": "${com.zifras.User.get(session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id)?.userTenantId}" == "1"
					}, {
						"aTargets": [3],
						"mData": "razonSocial"
					}, {
						"aTargets": [4],
						"mData": "condicionIva"
					}, {
						"aTargets": [5],
						"mData": "regimenIibb"
					}, {
						"aTargets": [6],
						"mData": "log.vepIibb",
						"mRender": function ( data, type, full ) {
							if (data == null)
								return "-"
							return data ? ' <i class="icofont icofont-ui-check"></i>' : '<i class="icofont icofont-error"></i>';
						}
					},{
						"aTargets": [7],
						"mData": "log.etapa2",
						"mRender": function ( data, type, full ) {
							return data ? ' <i class="icofont icofont-ui-check"></i>' : '<i class="icofont icofont-error"></i>';
						}
					},{
						"aTargets": [8],
						"mData": "log.errorVepIibb"
					}
				],
  			buttons: [
	  			'selectAll',
	  			'selectNone',
	  			{
  	  				extend: 'excelHtml5',
  	  				className: 'fred',
 					title: function () {
 							var nombre = "Cuentas";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	className: 'fred',
   	            	orientation: 'landscape',
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
   			select: {
   		         style: 'multi',
   		         selector: 'td:first-child'
   		    },
       		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					// window.location.href = $('#urlShow').text() + '/' + aData['id'];
				});
			}
		});
		tablaResultado = $('#listaResultado').DataTable({
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "No hubo errores",
				sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
				sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
				sInfoPostFix: "",
				sUrl: "",
				sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
				oPaginate: {
					"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
					"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
					"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
					"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
				}
			},
			aaSorting: [
				[0, 'asc']
			],
			aoColumnDefs: [{
				"aTargets": [0],
				"mData": "cuenta"
			}, {
				"aTargets": [1],
				"mData": "vep"
			}],
			"scrollX": true,
			sPaginationType: 'simple',
			buttons: [
				$.extend(true, {}, {
					exportOptions: {
						columns: [0, 1],
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
						var nombre = "Reporte Selenium"
						return nombre;
					}
				}),
				{
					extend: 'pdfHtml5',
					orientation: 'landscape',
					title: function () {
						var nombre = "Reporte Selenium"
						return nombre;
					}
				},
				{
					extend: 'copyHtml5'
				}
			],
			sDom: "lBfrtip"
		});

		$(document).on('shown.bs.modal', '#modalResultadoImportacion', function () {
			tablaResultado.columns.adjust().draw();
		});

		llenarDatoslistCuentas();
		
		/*$('#global_filter').keyup(function() {
			tabla.search($('#global_filter').val()).draw();
		});*/
	});

	function accion(){
		var cuentasIds = "";
		for(i=0; i < tabla.rows('.selected').data().length ; i++){
			cuentasIds += tabla.rows('.selected').data()[i].id;

			if(i != (tabla.rows('.selected').data().length - 1)){
				cuentasIds += ',';
			}
		}
		if (!cuentasIds){
			swal("Error","No hay cuentas seleccionadas","error")
			return
		}
		$('#loaderCuenta').show()
		$.ajax("${createLink(action:'ejecutarEtapaVep')}", {
			dataType: "json",
			method: "POST",
			data: {
				cuentas: cuentasIds,
				mes: $("#mes").val(),
				ano: $("#ano").val(),
				vep: $("#vep").prop('checked'),
				forzarOk: $("#forzarOk").prop('checked')
			}
		}).done(function(data) {
			tablaResultado.clear()
			for(key in data){
				tablaResultado.row.add(data[key]);
			}
			$('#modalResultadoImportacion').modal('show');
			llenarDatoslistCuentas();
		});
	}

	function llenarDatoslistCuentas(){
		$('#loaderCuenta').show()
		tabla.clear()
		$.ajax("${createLink(controller:'cuenta', action:'ajaxListEtapasSelenium')}", {
			dataType: "json",
			data: {
				mes: $("#mes").val(),
				ano: $("#ano").val(),
				cuentaId: null,
				etapa: 2,
				simplificado:true,
				etiqueta: "Verde"
			}
		}).done(function(data) {
			$('#loaderCuenta').fadeOut('slow', function() {
		        $(this).hide();
		    });
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
			$('#loaderCuenta').show()
		});
	}
</script>
</body>
</html>