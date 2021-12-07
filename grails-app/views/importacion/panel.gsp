<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlGetItems">
		<g:createLink controller="importacion" action="ajaxGetListaImportaciones" />
	</div>
	<div id="urlGetCuentas">
		<g:createLink controller="cuenta" action="ajaxGetCuentasNombresSQL" />
	</div>
	<div id="urlImport">
		<g:createLink controller="importacion" action="ajaxImportar" />
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
		                    <h4><g:message code="zifras.importacion.LogImportacion.importaciones.list.label" default="Panel de control"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="card-header-right" style="text-align:right;">
						<button id="buttonImportar" type="button" class="btn btn-primary" onclick="$('#modalImportRPB').modal('show');">Importar Ret/Per</button>

						<button type="button" class="btn btn-success" onclick="$('#modalImportFacturas').modal('show');">Importar Facturas</button>
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
						<h4 style="margin-bottom:20px;"><g:message code="zifras.facturacion.estado.list.label" default="Estado de Importaciones"/></h4>
						<table id="listItems" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Cliente</th> 
									<th>Compra</th>
									<th>Venta</th>
									<th>Ret. IVA</th>
									<th>Per. IVA</th>
									<th>Ret. IIBB</th>
									<th>Per. IIBB</th>
									<th>Ret.Banc. IIBB</th>
									<th>Dirección</th>
									<th>Zona</th>
									<th>Locales</th>
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

<div class="modal fade" id="modalImportFacturas" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Importar Facturas</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">
				<div id="divPadreFacturas" class="card-block">
                    <input type="file" name="files" id="archivos_importar" multiple="multiple">
                </div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalImportPorPanel" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title" id="modalTitle"></h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">
				<div class="form-group row col-sm-12" style="margin-top: 20px;">
					<label class="col-sm-1 col-form-label">Cuenta:</label>
					<div class="col-sm-8">
						<div class="input-group">
							<select id="cuentaIdModalPanel" name="cuentaIdModalPanel"></select>
						</div>
					</div>
				</div>
				<div id="divPadrePanel" class="card-block">
                    <input type="file" name="files" id="archivos_panel" multiple="multiple">
                </div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalImportRPB" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Importar Retenciones o Percepciones</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">
				<div class="form-group row col-sm-12" style="margin-top: 20px;">
					<label class="col-sm-1 col-form-label">Cuenta:</label>
					<div class="col-sm-8">
						<div class="input-group">
							<select id="modalCuenta" name="cuentaIdModal"></select>
						</div>
					</div>
				</div>
				<div id="divPadreRPB" class="card-block">
                    <input type="file" name="files" id="archivos_importar_rpb" multiple="multiple">
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
								<th>Archivo</th>
								<th>Periodo</th>
								<th>Tipo</th>
								<th>Cuenta</th>
								<th>Cantidad Ok</th> 
								<th>Cantidad Ignoradas</th>
								<th>Cantidad Mal</th>
								<th>Nuevos Clie./Prov.</th>
								<th>Estado.</th>
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
	var esRPB;
	var banderaBeforeSend = true;
	var celdaSeleccionadaData;
	var filaSeleccionada;

	jQuery(document).ready(function() {
		// Combos:
			$("#modalCuenta").select2({
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
				},
    			dropdownParent: $("#modalImportRPB")
			});
			llenarCombo({
				comboId : "modalCuenta",
				ajaxUrlDiv : 'urlGetCuentas',
				idDefault : '${cuentaId}',
				atributo : 'toString'
			});
			$("#modalCuenta").change(function () {
				inicializarFilerRPB();
			});

			$("#cuentaIdModalPanel").select2({
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
				comboId : "cuentaIdModalPanel",
				readOnly: true,
				ajaxUrlDiv : 'urlGetCuentas',
				atributo : 'toString'
			});

		// File inputs: 

			inicializarFilerFacturas();

			inicializarFilerRPB();

			inicializarFilerPanel();

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
					[0, 'asc']
				],
				aoColumnDefs: [{
				       			"aTargets": [0],
				       			"mData": "cliente"
							},{
				       			"aTargets": [1],
				       			"mData": "compra",
								"mRender": function ( data, type, full ) {
					       			if(data == "Importado")
										return '<i class="icofont icofont-ui-check"></i>';
					       			else if(data == "Error")
					       				return "rip"
					       			else
						       			return "-";
					   	       	}
							},{
				       			"aTargets": [2],
				       			"mData": "venta",
								"mRender": function ( data, type, full ) {
					       			if(data == "Importado")
										return '<i class="icofont icofont-ui-check"></i>';
					       			else if(data == "Error")
					       				return "rip"
					       			else
						       			return "-";
					   	       	}
							},{
				       			"aTargets": [3],
				       			"mData": "retencionesIva",
								"mRender": function ( data, type, full ) {
					       			if(data == "Importado")
										return '<i class="icofont icofont-ui-check"></i>';
					       			else if(data == "Error")
					       				return "rip"
					       			else
						       			return "-";
					   	       	}
							},{
				       			"aTargets": [4],
				       			"mData": "percepcionesIva",
								"mRender": function ( data, type, full ) {
					       			if(data == "Importado")
										return '<i class="icofont icofont-ui-check"></i>';
					       			else if(data == "Error")
					       				return "rip"
					       			else
						       			return "-";
					   	       	}
							},{
				       			"aTargets": [5],
				       			"mData": "retencionesIibb",
								"mRender": function ( data, type, full ) {
					       			if(data == "Importado")
										return '<i class="icofont icofont-ui-check"></i>';
					       			else if(data == "Error")
					       				return "rip"
					       			else
						       			return "-";
					   	       	}
							},{
				       			"aTargets": [6],
				       			"mData": "percepcionesIibb",
								"mRender": function ( data, type, full ) {
					       			if(data == "Importado")
										return '<i class="icofont icofont-ui-check"></i>';
					       			else if(data == "Error")
					       				return "rip"
					       			else
						       			return "-";
					   	       	}
							},{
				       			"aTargets": [7],
				       			"mData": "bancarias",
								"mRender": function ( data, type, full ) {
					       			if(data == "Importado")
										return '<i class="icofont icofont-ui-check"></i>';
					       			else if(data == "Error")
					       				return "rip"
					       			else
						       			return "-";
					   	       	}
							},{
				       			"aTargets": [8],
				       			"mData": "direcciones"
							},{
				       			"aTargets": [9],
				       			"mData": "zonas"
							},{
				       			"aTargets": [10],
				       			"mData": "locales"
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

			$('#listItems').on('click', 'tbody td', function() {
				celdaSeleccionadaData = tablaItems.row(this).data();
				filaSeleccionada = tablaItems.row(this).index();
				var columna = this.cellIndex;
				esRPB = [3,4,5,6,7].includes(columna);
				$("#cuentaIdModalPanel").val(celdaSeleccionadaData.clienteId).trigger('change');
				$("#divcuentaIdModalPanelText").text($("#cuentaIdModalPanel").select2('data')[0].text);
				inicializarFilerPanel();
				$('#modalTitle').text("Importar " + (esRPB ? "Retenciones/Percepciones" : "Facturas"));
				$('#modalImportPorPanel').modal('show');
			})

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
		       			"mData": "fecha",
		       			"type": "date-eu"
					},{
		       			"aTargets": [2],
		       			"mData": "tipo"
					},{
		       			"aTargets": [3],
		       			"mData": "cuentaNombre"
					},{
		       			"aTargets": [4],
		       			"mData": "cantidadOk"
					},{
		       			"aTargets": [5],
		       			"mData": "cantidadIgnoradas"
					},{
		       			"aTargets": [6],
		       			"mData": "cantidadMal"
					},{
		       			"aTargets": [7],
		       			"mData": "nuevasPersonas"
					},{
		       			"aTargets": [8],
		       			"mData": "estado"
					},{
		       			"aTargets": [9],
		       			"mData": "detalle"
		            }
		        ],
	        	"scrollX": true,
	       		sPaginationType: 'simple',
		   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
		   			if(aData['estado']!='Activo'){
		   	   			$(nRow).css({"background-color":"red","color":"white"});
		   	   	   	}
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

	function inicializarFilerFacturas(){
		var padre = $('#divPadreFacturas');
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
			    data: {
			    	retenciones: false
			    },
			    type: 'POST', //The type of request {String}
			    enctype: 'multipart/form-data', //Request enctype {String}
			    synchron: true,
			    beforeSend: function(){
			    	if (banderaBeforeSend){
						tablaResultados.clear();
						banderaBeforeSend = false;
						$('#modalLoading').modal('show');
						$('#modalImportFacturas').modal('hide');
					}
			    },
			    success: function(resultado){
			    	$('#listaResultados').dataTable().fnAddData(resultado[0]); //El Resultado siempre va a ser un array de un elemento
			    },
			    onProgress: function(data){
			    	// Barra de porcentaje de subida de archivo
			    },
			    onComplete: function(){
			    	llenarDatoslistItems();
					$("#archivos_importar").prop("jFiler").reset();
					$("#modalLoading").modal('hide');
					$("#modalResultadoImportacion").modal('show');
					tablaResultados.columns([5,6,7]).visible(!esRPB);
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

	function inicializarFilerRPB(){
		var padre = $('#divPadreRPB');
		padre.empty();
		$("<input/>", {
		  id: "archivos_importar_rpb",
		  "type": "file",
		  "name": "files",
		  "multiple": "multiple",
		  appendTo: padre
		});
		$('#archivos_importar_rpb').filer({
			uploadFile: {
				 url: $('#urlImport').text(), //URL to which the request is sent {String}
			    data: {
			    	retenciones: true,
			    	cuentaId: $('#modalCuenta').val()
			    },
			    type: 'POST', //The type of request {String}
			    enctype: 'multipart/form-data', //Request enctype {String}
			    synchron: true,
			    beforeSend: function(){
			    	if (banderaBeforeSend){
						tablaResultados.clear();
						banderaBeforeSend = false;
						$('#modalLoading').modal('show');
						$('#modalImportRPB').modal('hide');
					}
			    },
			    success: function(resultado){
			    	$('#listaResultados').dataTable().fnAddData(resultado[0]); //El Resultado siempre va a ser un array de un elemento
			    },
			    onProgress: function(data){
			    	// Barra de porcentaje de subida de archivo
			    },
			    onComplete: function(){
			    	llenarDatoslistItems();
					$("#archivos_importar_rpb").prop("jFiler").reset();
					$("#modalLoading").modal('hide');
					$("#modalResultadoImportacion").modal('show');
					tablaResultados.columns([5,6,7]).visible(!esRPB);
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

	function inicializarFilerPanel(){
		var padre = $('#divPadrePanel');
		padre.empty();
		$("<input/>", {
		  id: "archivos_panel",
		  "type": "file",
		  "name": "files",
		  "multiple": "multiple",
		  appendTo: padre
		});
		$('#archivos_panel').filer({
			uploadFile: {
				 url: $('#urlImport').text(), //URL to which the request is sent {String}
			    data: {
			    	retenciones: esRPB,
			    	cuentaId: $('#cuentaIdModalPanel').val()
			    },
			    type: 'POST', //The type of request {String}
			    enctype: 'multipart/form-data', //Request enctype {String}
			    synchron: true,
			    beforeSend: function(){
			    	if (banderaBeforeSend){
						tablaResultados.clear();
						banderaBeforeSend = false;
						$('#modalLoading').modal('show');
						$('#modalImportPorPanel').modal('hide');
					}
			    },
			    success: function(resultado){
			    	var log = resultado[0];//El Resultado siempre va a ser un array de un elemento porque seguimos usando la función de importación masiva aunque sea de a uno
			    	$('#listaResultados').dataTable().fnAddData(log);
			    	//Lógica para actualizar el check de la tabla en vivo:
			    	var fechaArray = log.fecha.split("/");
					if (log.estado == 'Activo' && fechaArray[1] == $('#mes').val() && fechaArray[2] == $('#ano').val()){
						if (log.tipo == 'Factura venta')
							celdaSeleccionadaData.venta = 'Importado';
						else if (log.tipo == 'Factura compra')
							celdaSeleccionadaData.compra = 'Importado';
						else if (log.tipo == 'Retención IVA')
							celdaSeleccionadaData.retencionesIva = 'Importado';
						else if (log.tipo == 'Percepción IVA')
							celdaSeleccionadaData.percepcionesIva = 'Importado';
						else if (log.tipo == 'Retención IIBB')
							celdaSeleccionadaData.retencionesIibb = 'Importado';
						else if (log.tipo == 'Percepción IIBB')
							celdaSeleccionadaData.percepcionesIibb = 'Importado';
						else if (log.tipo == 'Retención bancaria IIBB')
							celdaSeleccionadaData.bancarias = 'Importado';

						tablaItems.row(filaSeleccionada).data(celdaSeleccionadaData).draw();
					}
			    },
			    onProgress: function(data){
			    	// MENOR: Barra de porcentaje de subida de archivo (En los tres filers)
			    },
			    onComplete: function(){
					$("#archivos_panel").prop("jFiler").reset();
					$("#modalLoading").modal('hide');
					$("#modalResultadoImportacion").modal('show');
					tablaResultados.columns([5,6,7]).visible(!esRPB);
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