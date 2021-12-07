<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetDeclaracionesJuradas">
		<g:createLink controller="declaracionJurada" action="ajaxGetDeclaracionesJuradas" />
	</div>
	<div id="urlShow">
		<g:createLink controller="declaracionJurada" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="declaracionJurada" action="edit" />
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
		                    <h4><g:message code="zifras.documento.DeclaracionJurada.list.label" default="Lista de Declaraciones Juradas"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<label class="btn btn-success" onclick="$('#modalImport').modal('show');"><g:message code="default.import.label" default="Importar {0}" args="['Declaraciones Juradas']"/></label>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listDeclaracionesJuradas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Cuenta</th>
									<th>Fecha presentación</th>
									<th>Estado</th>
									<th>Tipo</th>
									<th>Periodo</th>
									<th>Descripción</th>
									<th>Comprobante</th>
									<th>Archivo</th>
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

		<div class="modal fade" id="modalImport" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">Importar Declaraciones Juradas</h4>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body" style="padding:0px;">
						<div class="card-block">
		                    <input type="file" name="archivo" id="archivos_importar" multiple="multiple">
		                </div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
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

						<div class="col-md-12" style="margin-top: 20px;">
							<table id="listaResultados" class="table table-striped table-bordered nowrap" style="width: 100%;">
								<thead>
									<tr>
										<th>Archivo</th>
										<th>Periodo</th>
										<th>Cuenta</th>
										<th>Tipo</th>
										<th>Estado</th>
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
	</div>
</div>

<script type="text/javascript">
var tablaDDJJ;
var tablaResultados;
var banderaBeforeSend = true;

	jQuery(document).ready(function() {
		tablaDDJJ = $('#listDeclaracionesJuradas').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.declaracionJurada.DeclaracionJurada.list.agregar', default: 'No hay Declaraciones Juradas')}</a>",
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
				[1, 'desc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "cuentaNombre",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [1],
			       			"mData": "fecha",
			       			"type": "date-eu"
						},{
			       			"aTargets": [2],
			       			"mData": "estadoNombre"
						},{
			       			"aTargets": [3],
			       			"mData": "tipo"
						},{
			       			"aTargets": [4],
			       			"mData": "periodo",
			       			"type": "date-eu"
						},{
			       			"aTargets": [5],
			       			"mData": "descripcion"
						},{
			       			"aTargets": [6],
			       			"mData": "comprobante"			       			
			       		},{
			       			"aTargets": [7],
			       			"mData": "nombreArchivo"
			       		}],
       		buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Declaraciones Juradas";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Declaraciones Juradas";
							return nombre;
 					}
 				},{
 					extend: 'copyHtml5'
 				}],
       		sPaginationType: 'simple',
       		sDom: "Bflrtip",
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistDeclaracionesJuradas();

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
	       			"mData": "nombreArchivo"
				},{
	       			"aTargets": [1],
	       			"mData": "periodo"
				},{
	       			"aTargets": [2],
	       			"mData": "cuenta"
				},{
	       			"aTargets": [3],
	       			"mData": "tipo"
				},{
	       			"aTargets": [4],
	       			"mData": "estado"
	            }
	        ],
        	"scrollX": true,
       		sPaginationType: 'simple',
	   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
	   			if(aData['estado']!='OK'){
	   	   			if(aData['estado']=='La liquidación no estaba Autorizada.')
	   	   				$(nRow).css({"background-color":"#F4D03F","color":"black"});
	   	   			else
	   	   				$(nRow).css({"background-color":"red","color":"white"});
	   	   	   	}
			}
		});

		$('#archivos_importar').filer({
			uploadFile: {
				 url: "${createLink(action: 'ajaxImportar')}", //URL to which the request is sent {String}
			    type: 'POST', //The type of request {String}
			    enctype: 'multipart/form-data', //Request enctype {String}
			    synchron: true,
			    beforeSend: function(){
			    	if (banderaBeforeSend){
			    		// Contar archivos: $('#archivos_importar')[0].jFiler.files_list
						tablaResultados.clear();
						banderaBeforeSend = false;
						$('#modalLoading').modal('show');
						$('#modalImport').modal('hide');
					}
			    },
			    success: function(resultado){
			    	$('#listaResultados').dataTable().fnAddData(resultado);
			    },
			    onComplete: function(){
			    	llenarDatoslistDeclaracionesJuradas();
					$("#archivos_importar").prop("jFiler").reset();
					$("#modalResultadoImportacion").modal('show');
					setTimeout(function(){
						tablaResultados.draw();
						$("#modalLoading").modal('hide');
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
	});

	function llenarDatoslistDeclaracionesJuradas(){
		tablaDDJJ.clear().draw();
		$.ajax($('#urlGetDeclaracionesJuradas').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			for(key in data){
				tablaDDJJ.row.add(data[key]);
			}
			tablaDDJJ.draw();
		});
	}
</script>
</body>
</html>
