<!DOCTYPE html>
<html lang="en">

<head>
  <div class="theme-loader" id="loaderGrande" style="display: none;">
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
	<div id="urlGetProformas">
		<g:createLink controller="pedidosYa" action="ajaxGetProformas" />
	</div>
	<div id="urlNotificarRiders">
		<g:createLink controller="pedidosYa" action="ajaxNotificarRiders" />
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
		                    <h4>Listado de Proformas</h4>
						</div>
					</div>
				</div>
				<div class="col-md-1">
					<input id="fechaInicio" type="text" name="fechaInicio" class="form-control fechaDateDropper" data-format="d/m/Y" placeholder="Seleccione un día" value="${fechaHoy}">
				</div>
				<div class="col-md-1">
					<div class="card-header-right" style="text-align:right; margin-left: 30px;">
						<button type="button" class="btn btn-primary" id="btnNotificarRiders">Notificar Riders</button>
					</div>
				</div>
				<div class="col-md-2">
					<div class="card-header-right" style="text-align:right;">
						<button type="button" class="btn btn-primary" id="btnImportarProformas" onclick="$('#modalImport').modal('show');">Importar Proformas</button>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block">
					<div class="dt-responsive table-responsive" id="divListProformas" style="cursor:pointer;">
						<table id="listProformas" class="table table-striped table-bordered nowrap">
							<thead>
								<tr>
									<th>Rider ID</th>
									<th>CUIT</th>
									<th>Importe</th>
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

<div class="modal fade" id="modalImport" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Importar Proformas</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:uploadForm name="importarProformas" action="importarProformas">
				<fieldset>
				<div class="form-group row">
					<div class="col-sm-12">
						<input id="modalArchivo" name="file" type="file" class="form-control">
					</div>
				</div>
				</fieldset>
				</g:uploadForm>
			</div>
			<div class="modal-footer">
				<button id="buttonLocalVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonLocalAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="$('#importarProformas').submit();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalFallidos" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Proformas Fallidas</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">

				<div class="col-md-12">
					<table id="listProformasFallidas" class="table table-striped table-bordered nowrap" style="width: 100%;">
						<thead>
							<tr>
								<th>Rider ID</th>
								<th>Importe</th>
								<th>Error</th>
							</tr>
						</thead>
					</table>
				</div>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var tabla;

	jQuery(document).ready(function() {

		
		document.getElementById("btnNotificarRiders").onclick = function(){
			let riders = [];
			var i;
			for(i=0;i<tabla.column(0).data().length;i++){
				riders.push(tabla.column(0).data()[i]);
			}
			$.ajax($('#urlNotificarRiders').text(), {
				dataType: "json",
				data: {
					riders : riders.toString()
				}
			}).done(function(resultado) {
				if(resultado.ok){
					swal("Exito!", resultado.ok, "success");
					llenarDatoslistProformas();
				}
				else
					swal("Error", resultado.error, "error");
			});
		}

		tabla = $('#listProformas').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay Proformas')}</a>",
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
				[0, 'asc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "riderId",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [1],
			       			"mData": "cuit"
						},{
			       			"aTargets": [2],
			       			"mData": "importe",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [3],
			       			"mData": "estadoDetallado"
			       		}],
  			buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Proformas";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Proformas";
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
					if (aData.facturaId)
						window.location.href = '${createLink(controller:"facturaVentaUsuario", action:"bajarPdf")}/' + aData.facturaId
				});
			}
		});

		tablaFallidos = $('#listProformasFallidas').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay Proformas')}</a>",
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
				[0, 'asc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "riderId",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [1],
			       			"mData": "importe",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [2],
			       			"mData": "error"
			       		}],
  			buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Proformas Fallidas";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Proformas Fallidas";
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
				});
			}
		});

		$(".fechaDateDropper").dateDropper({
				dropWidth: 200,
				dropPrimaryColor: "#1abc9c",
				dropBorder: "1px solid #1abc9c",
				dropBackgroundColor: "#FFFFFF",
				format: "d/m/Y",
				lang: "es",
				maxYear: '2022'
			});

		$("#fechaInicio").change(function () {
   			llenarDatoslistProformas();
   		});

		llenarDatoslistProformas();

		$('#modalArchivo').filer({
					uploadFile: {
						url: "${raw(createLink(controller:'importacion', action:'importacionProformas'))}",
						type: 'POST', //The type of request {String}
						data:{
							fechaInicio: $("#fechaInicio").val()
						},
						enctype: 'multipart/form-data', //Request enctype {String}
						synchron: true,
						beforeSend: function () {
						},
						success: function (resultado) {
							if (resultado.ok){
								$('#modalImport').modal('hide');
								if(resultado.data.fallidos.length == 0)
									swal("Exito!", "Todas las proformas fueron generadas correctamente","success");
								else{
									setTimeout(function() {
					    				swal("Atencion!", "Hubo errores al generar algunas proformas", "warning");
					    			}, 400);
									for(key in resultado.data.fallidos){
										tablaFallidos.row.add(resultado.data.fallidos[key]);
									}
									tablaFallidos.draw();
									$("#modalFallidos").modal('show');
								}
								tabla.clear();
								for(key in resultado.data.exitos){
									tabla.row.add(resultado.data.exitos[key]);
								}
								tabla.draw();
							}
							else{
								$('#modalImport').modal('hide');
								swal("Error", resultado.error, "error");
							}
						},
						onProgress: function (data) {},
						onComplete: function () {}
					},
					limit: 1,
					maxSize: null,
					extensions: null,
					changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Arrastrá tu archivo acá</h3> <span style="display:inline-block; margin: 15px 0">ó</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Seleccionar</a></div></div>',
					showThumbs: true,
					theme: "dragdropbox",
					templates: {
						box: '<ul class="jFiler-items-list jFiler-items-grid"></ul>',
						item: '<li class="jFiler-item">\
										<div class="jFiler-item-container">\
											<div class="jFiler-item-inner">\
												<div class="jFiler-item-assets jFiler-row" style="margin-top:0px;">\
													<ul class="list-inline pull-right">\
														<li><span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span></li>\
														<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
													</ul>\
												</div>\
											</div>\
										</div>\
									</li>',
						itemAppend: '<li class="jFiler-item">\
											<div class="jFiler-item-container">\
												<div class="jFiler-item-inner">\
													<div class="jFiler-item-thumb">\
														<div class="jFiler-item-status"></div>\
														<div class="jFiler-item-info">\
															<span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
															<span class="jFiler-item-others">{{fi-size2}}</span>\
														</div>\
														{{fi-image}}\
													</div>\
													<div class="jFiler-item-assets jFiler-row">\
														<ul class="list-inline pull-left">\
															<li><span class="jFiler-item-others">{{fi-icon}}</span></li>\
														</ul>\
														<ul class="list-inline pull-right">\
															<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
														</ul>\
													</div>\
												</div>\
											</div>\
										</li>',
						itemAppendToEnd: false,
						removeConfirmation: true
					},
					dragDrop: {
						dragEnter: null,
						dragLeave: null,
						drop: null,
					},
					addMore: false,
					clipBoardPaste: true,
					excludeName: null,
					beforeRender: null,
					afterRender: null,
					beforeShow: null,
					beforeSelect: null,
					onSelect: null,
					afterShow: null,
					onEmpty: null,
					options: null,
					captions: {
						button: "Elegir archivo",
						feedback: "Elegir archivo para subir",
						feedback2: "archivo elegido",
						drop: "Arrastrá un archivo para subirlo",
						removeConfirmation: "¿Está seguro de que desea descartar este archivo?",
						errors: {
							filesLimit: "Pueden subirse hasta {{fi-limit}} archivos.",
							filesSize: "{{fi-name}} excede el tamaño máximo de {{fi-maxSize}} MB.",
							filesSizeAll: "Los archivos elegidos exceden el tamaño máximo de {{fi-maxSize}} MB."
						}
					}
				});
		
		/*$('#global_filter').keyup(function() {
			tabla.search($('#global_filter').val()).draw();
		});*/
	});

	function llenarDatoslistProformas(){
		tabla.clear();
		$.ajax($('#urlGetProformas').text(), {
			dataType: "json",
			data: {
				fechaInicio : $("#fechaInicio").val()
			}
		}).done(function(data) {
			$('#loaderCuenta').fadeOut('slow', function() {
		        $(this).remove();
		    });
			for(key in data){
				tabla.row.add(data[key]);
			}
			$("#divListProformas").show();
			tabla.draw();
			
		});
	}
</script>
</body>
</html>