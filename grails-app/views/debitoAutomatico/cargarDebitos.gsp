<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlGetItems">
		<g:createLink controller="debitoAutomatico" action="ajaxGetListaDebitos" />
	</div>
	<div id="urlImport">
		<g:createLink controller="importacion" action="ajaxImportarDebitos" />
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
		                    <h4>Carga de Débitos</h4>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="card-header-right" style="text-align:right;">
						<button type="button" class="btn btn-success" onclick="$('#modalImportDebitos').modal('show');">Importar Debitos</button>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->

		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div id="preloader" class="preloader3" style="display:none;">
						<div class="circ1 loader-primary"></div>
						<div class="circ2 loader-primary"></div>
						<div class="circ3 loader-primary"></div>
						<div class="circ4 loader-primary"></div>
					</div>
					<div id="divListItems" class="dt-responsive table-responsive">
						<div style="float:right;">
							<label style="float:left;padding-top:5px;margin-right:10px;">Mes</label>
							<input style="width:80px;" id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
						</div>
						<div style="float:right;margin-right: 20px;">
							<label style="float:left;padding-top:5px;margin-right:10px;">Año</label>
							<input style="width:80px;" id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año"data-min-year="2010"  value="${ano}"/>
						</div>
						<h4 style="margin-bottom:20px;">Estado de Débitos</h4>
						<table id="listItems" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Cuenta</th> 
									<th>Factura</th>
									<th>Creacion</th>
									<th>Importe</th>
									<th>Estado</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
			<div class="col-sm-4">
			<div class="wrapper" style="position:relative;">
				 <div id="cuitFound" style="position:absolute; height: 15px; width:15px; margin-top: 7px;">
					<i class="fa fa-warning" style="font-size: 18px;"></i>
				</div>
			</div>
		</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalLoading" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Importando...</h4>
			</div>
			<div class="modal-body" style="padding:0px;">
				<div class="loader-block">
                    <svg id="loader2" viewBox="0 0 100 100">
                        <circle id="circle-loader2" cx="50" cy="50" r="45"></circle>
                    </svg>
                </div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalImportDebitos" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Importar Débitos</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">
				<div id="divPadreDebitos" class="card-block">
                    <input type="file" name="files" id="archivos_importar" multiple="multiple">
                </div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalResultadoImportacion" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Resultados</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">

				<div class="col-md-12">
					<table id="listaResultados" class="table table-striped table-bordered nowrap" style="width: 100%;">
						<thead>
							<tr>
								<th>Cuenta</th> 
								<th>Factura</th>
								<th>Importe</th>
								<th>Pagado</th>
								<th>Detalle</th>
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
	var tablaItems;
	var tablaResultados;
	var banderaBeforeSend = true;
	var celdaSeleccionadaData;
	var filaSeleccionada;

	jQuery(document).ready(function() {
		
		// File inputs: 

			inicializarFilerDebitos();

		// Tables: 

			tablaItems = $('#listItems').DataTable({
				//bAutoWidth: false,
				//bSortCellsTop: true,
				//BProcessing: true,
				"ordering": true,
				"searching": true,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "${message(code: 'zifras.DebitoAutomatico.list.agregar', default: 'No hay Débitos')}</a>",
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
					[0, 'asc']
				],
				aoColumnDefs: [{
				       			"aTargets": [0],
				       			"mData": "cuentaId"
							},{
				       			"aTargets": [1],
				       			"mData": "facturaId"
				       		},{
				       			"aTargets": [2],
				       			"mData": "fechaCreacion",
				       			"type": "date-eu"
							},{
				       			"aTargets": [3],
				       			"mData": "importe",
				       			"sClass" : "text-right"
							},{
				       			"aTargets": [4],
				       			"mData": "estado"
							}],
	       		sPaginationType: 'simple',
	    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
					// Row click
					$(nRow).on('click', function() {
						//window.location.href = $('#urlEdit').text() + '/' + aData['id'];
					});
				}
			});

			llenarDatoslistItems();

			tablaResultados = $('#listaResultados').DataTable({
				"ordering": true,
				"searching": true,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "${message(code: 'zifras.importacion.LogImportacion.list.agregar', default: 'No hay Importaciones')}</a>",
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
					[1, 'asc']
				],
				aoColumnDefs: [
		            {
		       			"aTargets": [0],
		       			"mData": "cuenta"
					},{
		       			"aTargets": [1],
		       			"mData": "factura"
					},{
		       			"aTargets": [2],
		       			"mData": "importe",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [3],
		       			"mData": "pagado",
		       			"mRender": function ( data, type, full ) {
		       				return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
		   	      	 	}
		            },{
		            	"aTargets": [4],
		       			"mData": "detalleCobro"
		            }
		        ],
	        	"scrollX": true,
	       		sPaginationType: 'simple',
		   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
		   			
		   	   	   	}
			});

		// Dates: 

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


			$("#ano").change(function () {
				llenarDatoslistItems();
			});

			$("#mes").change(function () {
				llenarDatoslistItems();
			});
	});

	function llenarDatoslistItems(){
		var ano = $('#ano').val();
		var mes = $('#mes').val();

		tablaItems.clear().draw();
		$("#preloader").show();
		$("#divListItems").hide();
		$.ajax($('#urlGetItems').text(), {
			dataType: "json",
			data: {
				ano: ano,
				mes: mes
			}
		}).done(function(data) {
			$("#preloader").hide();
			$("#divListItems").show();
			for(key in data){
				tablaItems.row.add(data[key]);
			}
			tablaItems.draw();
		});
	}

	function inicializarFilerDebitos(){
		var padre = $('#divPadreDebitos');
		padre.empty();
		$("<input/>", {
		  id: "archivos_importar",
		  "type": "file",
		  "name": "files",
		  "multiple": "multiple",
		  appendTo: padre
		});
		$('#archivos_importar').filer({
			uploadFile: {
				url: $('#urlImport').text(), //URL to which the request is sent {String}
			    type: 'POST', //The type of request {String}
			    enctype: 'multipart/form-data', //Request enctype {String}
			    synchron: true,
			    beforeSend: function(){
			    	if (banderaBeforeSend){
						banderaBeforeSend = false;
						//$('#modalLoading').modal('show');
						$('#modalImportDebitos').modal('hide');
					}
			    },
			    success: function(resultado){
			    	console.log(resultado);
			    	console.log(resultado[0]);
			    	$('#listaResultados').dataTable().fnAddData(resultado);
			    },
			    onProgress: function(data){
			    	// Barra de porcentaje de subida de archivo
			    },
			    onComplete: function(){
			    	llenarDatoslistItems();
					$("#archivos_importar").prop("jFiler").reset();
					$("#modalResultadoImportacion").modal('show');
					//$("#modalLoading").modal('hide');
					//tablaResultados.columns([5,6,7]).visible(!esRPB);
					setTimeout(function(){
						tablaResultados.draw();
					}, 500);
					banderaBeforeSend = true;
			    }
			},
			limit: null,
			maxSize: null,
			extensions: null,
			changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Arrastrá los archivos acá</h3> <span style="display:inline-block; margin: 15px 0">ó</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Seleccionar archivos</a></div></div>',
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
				button: "Elegir archivos",
				feedback: "Elegir archivos para subir",
				feedback2: "archivos elegidos",
				drop: "Arrastrá un archivo para subirlo",
				removeConfirmation: "¿Está seguro de que desea descartar este archivo?",
				errors: {
					filesLimit: "Pueden subirse hasta {{fi-limit}} archivos.",
					filesSize: "{{fi-name}} excede el tamaño máximo de {{fi-maxSize}} MB.",
					filesSizeAll: "Los archivos elegidos exceden el tamaño máximo de {{fi-maxSize}} MB."
				}
			}
		});
	}

</script>
</body>
</html>