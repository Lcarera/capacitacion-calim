<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetRetencionesPercepciones">
		<g:createLink controller="RetencionPercepcionIva" action="ajaxGetRetencionesPercepciones" />
	</div>
	<div id="urlShow">
		<g:createLink controller="RetencionPercepcionIva" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="RetencionPercepcionIva" action="edit" />
	</div>	
	<div id="urlGetCuentas">
		<g:createLink controller="cuenta" action="ajaxGetCuentasNombresSQL" />
	</div>
	<div id="urlGetCuenta">
		<g:createLink controller="cuenta" action="ajaxGetCuenta" />
	</div>
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-sm-7">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.RetencionPercepcion.list.label" default="Percepciones/Retenciones IVA"/></h4>
						</div>
					</div>
				</div>
				<div class="col-sm-5" style="text-align:right;">
					<button id="buttonImportar" type="button" class="btn btn-primary" onclick="$('#modalImport').modal('show');">Importar Ret/Per</button>					
					<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Ret/Per']"/></g:link>
				</div>
			</div>
			<div class="row" style="margin-top:20px;">
				<div class="col-lg-2">
					<div style="text-align:right;">
						<input id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
					</div>
				</div>
				<div class="col-lg-2">
					<div style="text-align:right;">
						<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
					</div>
				</div>
				<div class="col-lg-8">
					<select id="cbCuenta" name="cuentaId" class="form-control"></select>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listRetencionesPercepciones" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Tipo</th>
									<th>Código</th>
									<th>Fecha</th>
									<th>Comprobante</th>
									<th>Cuit</th>
									<th>Monto</th>
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

<div class="modal fade" id="modalImport" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Importar Retenciones o Percepciones</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">
				<g:uploadForm name="importacionMasiva" controller="importacion" action="importacionMasivaRetPer">
				<div class="form-group row col-sm-12" style="margin-top: 20px;">
					<label class="col-sm-1 col-form-label">Cuenta:</label>
					<div class="col-sm-8">
						<div class="input-group">
							<select id="modalCuenta" name="cuentaIdModal" class="form-control"></select>
						</div>
					</div>
				</div>
					<div class="card-block">
                        <input type="file" name="files" id="archivos_importar" multiple="multiple">
                    </div>
                </g:uploadForm>
			</div>
			<div class="modal-footer">
				<button id="buttonLocalVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonLocalAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="$('#importacionMasiva').submit();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var tabla;

	jQuery(document).ready(function() {
		$('#archivos_importar').filer({
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
		/*** CBO CUENTAS ***/
			$("#cbCuenta").select2({
				placeholder: '<g:message code="zifras.cuenta.Cuenta.placeHolder" default="Seleccione una cuenta"/>',
				formatNoMatches: function() {
					return '<g:message code="default.no.elements" default="No hay elementos"/>';
				},
				formatSearching: function() {
					return '<g:message code="default.searching" default="Buscando..."/>';
				},
				minimumResultsForSearch: 1,
				formatSelection: function(item) {
					return item.text;
				}
			});
			llenarCombo({
				comboId : "cbCuenta",
				ajaxUrlDiv : 'urlGetCuentas',
				idDefault : '${cuentaId}',
				atributo : 'toString'
			});

			$("#modalCuenta").select2({
				placeholder: '<g:message code="zifras.cuenta.Cuenta.placeHolder" default="Seleccione una cuenta"/>',
				formatNoMatches: function() {
					return '<g:message code="default.no.elements" default="No hay elementos"/>';
				},
				formatSearching: function() {
					return '<g:message code="default.searching" default="Buscando..."/>';
				},
				formatSelection: function(item) {
					return item.text;
				}
			});
			llenarCombo({
				comboId : "modalCuenta",
				ajaxUrlDiv : 'urlGetCuentas',
				atributo : 'toString'
			});

		//Fin cuentas
		tabla = $('#listRetencionesPercepciones').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.RetencionPercepcion.list.agregar', default: 'No hay retenciones ni percepciones')}</a>",
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
			       			"mData": "tipo"
						},{
			       			"aTargets": [1],
			       			"mData": "codigo",
			       		},{
			       			"aTargets": [2],
			       			"mData": "fecha",
			       			"type": "date-eu"
						},{
			       			"aTargets": [3],
			       			"mData": "comprobante"
						},{
			       			"aTargets": [4],
			       			"mData": "cuit"
						},{
			       			"aTargets": [5],
			       			"mData": "monto",
			       			"sClass" : "text-right"
						}],

       		buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Percepciones/Retenciones IVA Cuenta: " + $('#cbCuenta').val();
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Percepciones/Retenciones IVACuenta: " + $('#cbCuenta').val();
							return nombre;
 					}
 				},{
 					extend: 'copyHtml5'
 				}],
       		sPaginationType: 'simple',
       		sDom: "Blfrtip",
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row color
				/*if(aData['advertencia']!=''){
	   	   			$(nRow).css({"background-color":"red","color":"white"});
	   	   	   	}*/
	   	   	   	// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlShow').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistRetencionesPercepciones();

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
			llenarDatoslistRetencionesPercepciones();
		});

		$("#mes").change(function () {
			llenarDatoslistRetencionesPercepciones();
		});

		$("#cbCuenta").change(function () {
			llenarDatoslistRetencionesPercepciones();
			$("#modalCuenta").val($("#cbCuenta").val());
		});
	});

	function llenarDatoslistRetencionesPercepciones(){
		var ano = $("#ano").val();
		var mes = $("#mes").val();
		var cuentaId = $("#cbCuenta").val();
		tabla.clear();
		$.ajax($('#urlGetRetencionesPercepciones').text(), {
			dataType: "json",
			data: {
				ano: ano,
				cuentaId: cuentaId,
				mes: mes
			}
		}).done(function(data) {
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
		});
	}
</script>
</body>
</html>