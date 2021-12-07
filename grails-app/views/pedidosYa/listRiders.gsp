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
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-10">
					<div class="page-header-title">
						<div class="d-inline">
							<h4>Listado de Riders</h4>
						</div>
					</div>
				</div>
				<div class="col-md-2">
					<div class="card-header-right" style="text-align:right;">
						<button type="button" class="btn btn-primary" id="btnImportarRiders" onclick="$('#modalImport').modal('show');">Importar Riders</button>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block">
					<div class="dt-responsive table-responsive" id="divRiders">
						<table id="listRiders" class="table table-striped table-bordered nowrap">
							<thead>
								<tr>
									<th>Rider ID</th>
									<th>CUIT</th>
									<th>Email</th>
									<th>Nombre Apellido</th>
									<th>Teléfono</th>
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
				<h4 class="modal-title">Importar Riders</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:uploadForm name="importarRiders" action="importarRiders">
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
				<button id="buttonLocalAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="$('#importarRiders').submit();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalFallidos" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Importaciones Fallidas</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">

				<div class="col-md-12">
					<table id="listFallidos" class="table table-striped table-bordered nowrap" style="width: 100%;">
						<thead>
							<tr>
								<th>Rider ID</th>
								<th>Nombre</th>
								<th>CUIT</th>
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
		tabla = $('#listRiders').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Todavía no se han importado Riders.')}</a>",
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
							"mData": "email"
						},{
							"aTargets": [3],
							"mData": "nombreApellido"
						},{
							"aTargets": [4],
							"mData": "telefono"
						}],
			buttons: [{
					extend: 'excelHtml5',
					title: function () {
							var nombre = "Riders Calim";
							return nombre;
					}
				},{
					extend: 'pdfHtml5',
					orientation: 'landscape',
					title: function () {
						var nombre = "Riders Calim";
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

		llenarList()

		tablaFallidos = $('#listFallidos').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No ocurrieron errores.')}</a>",
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
			       			"mData": "id",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [1],
			       			"mData": "nombre"
						},{
			       			"aTargets": [2],
			       			"mData": "cuit"
			       		}],
  			buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Importaciones Fallidas";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Importaciones Fallidas";
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

		$('#modalArchivo').filer({
					uploadFile: {
						url: "${raw(createLink(controller:'importacion', action:'importacionRiders'))}",
						type: 'POST', //The type of request {String}
						enctype: 'multipart/form-data', //Request enctype {String}
						synchron: true,
						beforeSend: function () {
							$('#loaderGrande').show()
						},
						success: function (resultado) {
							if (resultado.ok)
								window.location.reload()
							else if (resultado.error)
								swal("Error", resultado.error, "error");
							else{
								for(key in resultado.errores)
									tablaFallidos.row.add(resultado.errores[key]);
								tablaFallidos.draw();
								$("#modalFallidos").modal('show');
							}
							llenarList()
							$('#modalImport').modal('hide');
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
	});

	function llenarList(){
		tabla.clear()
		$.ajax("${createLink(action:'ajaxGetRiders')}", {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			for(key in data){
				tabla.row.add(data[key]);
			}
			$("#divListRiders").show();
			tabla.draw();
			$('#loaderGrande').hide()
		});
	}
</script>
</body>
</html>