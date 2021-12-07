<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlShowRecibos">
		<g:createLink controller="reciboSueldo" action="show" />
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
		                    <h4>Estados de VEPs</h4>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="card-header-right" style="text-align:right;">
						<button type="button" class="btn btn-success" onclick="$('#modalImport').modal('show');">Importar</button>
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
						<h4 style="margin-bottom:20px;"><g:message code="zifras.facturacion.estado.list.label" default="Importaciones"/></h4>
						<table id="listItems" class="table table-striped table-bordered nowrap">
							<thead>
								<tr>
									<th>Cliente</th> 
									<th>Local</th>
									<th>Monotributo</th>
									<th>Autonomo</th>
									<th>IVA</th>
									<th>Seguridad e Higiene</th>
									<th>IIBB</th>
									<th>931</th>
									<th>Recibos Sueldo</th>
									<th>Mes Pagado</th>
									<th>WhatsApp</th>
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

<div class="modal fade" id="modalImport" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Importar VEPs</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">
				<div id="divPadreImport" class="card-block">
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
								<th>Periodo</th>
								<th>Cuenta</th>
								<th>Local</th>
								<th>Tipo</th>
								<th>Archivo</th>
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

<script type="text/javascript">
	var tablaItems;
	var tablaResultados;
	var banderaBeforeSend = true;

	jQuery(document).ready(function() {
		// File inputs: 
			var padre = $('#divPadreImport');
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
					 url: "${createLink(controller:'importacion', action: 'ajaxImportarVeps')}", //URL to which the request is sent {String}
				    data: {},
				    type: 'POST', //The type of request {String}
				    enctype: 'multipart/form-data', //Request enctype {String}
				    synchron: true,
				    beforeSend: function(){
				    	if (banderaBeforeSend){
							tablaResultados.clear();
							banderaBeforeSend = false;
							$('#modalLoading').modal('show');
							$('#modalImport').modal('hide');
						}
				    },
				    success: function(resultado){
				    	$('#listaResultados').dataTable().fnAddData(resultado);
				    },
				    onProgress: function(data){
				    	// Barra de porcentaje de subida de archivo
				    },
				    onComplete: function(){
				    	llenarDatoslistItems();
						$("#archivos_importar").prop("jFiler").reset();
						$("#modalLoading").modal('hide');
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
				       			"mData": "cuenta"
							},{
				       			"aTargets": [1],
				       			"mData": "local",
				       			"mRender": function( data,type,full ){
				       				if(data)
				       					return data
				       				else
				       					return "-"
				       			}
							},{
				       			"aTargets": [2],
				       			"mData": "monotributo",
								"sClass": "text-center",
								"mRender": function ( data, type, full ) {
					       			if(data == 0)
										return "-";
					       			else if(data == -1)
					       				return "X"
					       			else{
					       				const link = "${createLink(action:'download', id:'varId')}".replace("varId", data);
						       			return '<a href="' + link + '"><i class="icofont icofont-download-alt"></i></a>';
					       			}
					   	       	}
							},{
				       			"aTargets": [3],
				       			"mData": "responsable",
								"sClass": "text-center",
								"mRender": function ( data, type, full ) {
					       			if(data == 0)
										return "-";
					       			else if(data == -1)
					       				return "X"
					       			else{
					       				const link = "${createLink(action:'download', id:'varId')}".replace("varId", data);
						       			return '<a href="' + link + '"><i class="icofont icofont-download-alt"></i></a>';
					       			}
					   	       	}
							},{
				       			"aTargets": [4],
				       			"mData": "iva",
								"sClass": "text-center",
								"mRender": function ( data, type, full ) {
					       			if(data == 0)
										return "-";
					       			else if(data == -1)
					       				return "X"
					       			else{
					       				const link = "${createLink(action:'download', id:'varId')}".replace("varId", data);
						       			return '<a href="' + link + '"><i class="icofont icofont-download-alt"></i></a>';
					       			}
					   	       	}
							},{
				       			"aTargets": [5],
				       			"mData": "seguridad",
								"sClass": "text-center",
								"mRender": function ( data, type, full ) {
					       			if(data == 0)
										return "-";
					       			else if(data == -1)
					       				return "X"
					       			else{
					       				const link = "${createLink(action:'download', id:'varId')}".replace("varId", data);
						       			return '<a href="' + link + '"><i class="icofont icofont-download-alt"></i></a>';
					       			}
					   	       	}
							},{
				       			"aTargets": [6],
				       			"mData": "iibb",
								"sClass": "text-center",
								"mRender": function ( data, type, full ) {
					       			if(data == 0)
										return "-";
					       			else if(data == -1)
					       				return "X"
					       			else{
					       				const link = "${createLink(action:'download', id:'varId')}".replace("varId", data);
						       			return '<a href="' + link + '"><i class="icofont icofont-download-alt"></i></a>';
					       			}
					   	       	}
							},{
				       			"aTargets": [7],
				       			"mData": "931",
								"sClass": "text-center",
								"mRender": function ( data, type, full ) {
					       			if(data == 0)
										return "-";
					       			else if(data == -1)
					       				return "X"
					       			else{
					       				const link = "${createLink(action:'download', id:'varId')}".replace("varId", data);
						       			return '<a href="' + link + '"><i class="icofont icofont-download-alt"></i></a>';
					       			}
					   	       	}
							},{
				       			"aTargets": [8],
				       			"mData": "recibosString",
								"sClass": "text-center",
								"mRender": function ( data, type, row ) {
									if (data==-1)
										return "X"
									else
										if(data.substring(0,1) != "0")
											return '<a target="_blank" href="' + $("#urlShowRecibos").text() + '?id=' + row.idLocal + '&cantRecibos=' + row.cantidadRecibos + '&ano=' + $("#ano").val() + '&mes=' + $("#mes").val() + '">'+data+'</a>' 
										else
											return data
								}
							},{
				       			"aTargets": [9],
				       			"mData": "mesPago",
								"sClass": "text-center",
								"mRender": function ( data, type, full ) {
					       			if(data)
										return '<i class="icofont icofont-ui-check"></i>';
					       			else
						       			return "-";
					   	       	}
							},{
				       			"aTargets": [10],
				       			"mData": "telefono",
								"sClass": "text-center",
								"mRender": function ( data, type, full ) {
					       			if(data)
										return '<a target="_blank" href="https://api.whatsapp.com/send?phone=' + data + '"><i class="icofont icofont-brand-whatsapp"/></a>'
					       			else
						       			return '-';
					   	       	}
							}],
	       		sPaginationType: 'simple',
	       		buttons: [
					$.extend(true, {}, {
						exportOptions: {
							format: {
								body: function (data, row, column, node) {
									if ([2,3,4,5,6,7,9].includes(column)){
										if (data == "X")
											return "N/A"
										else if (data == "-")
											return "No"
										else
											return "Sí"
									}
									data = $('<p>' + data + '</p>').text();
									data = data.replace(/\./g, '');
									return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
								}
							}
						}
					}, {
						extend: 'excelHtml5',
						title: function () {
							var nombre = "Estado Importaciones Veps ${mes}${ano}"
							return nombre;
						}
					}),
					{
						extend: 'pdfHtml5',
						orientation: 'landscape',
						title: function () {
							var nombre = "Estado Importaciones Veps ${mes}${ano}"
							return nombre;
						}
					},
					{
						extend: 'copyHtml5'
					}
				],
				sDom: "lBfrtip",
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
					[5, 'asc']
				],
				aoColumnDefs: [
		            {
		       			"aTargets": [0],
		       			"mData": "periodo",
		       			"type": "date-eu"
					},{
		       			"aTargets": [1],
		       			"mData": "cuenta"
					},{
		       			"aTargets": [2],
		       			"mData": "local"
					},{
		       			"aTargets": [3],
		       			"mData": "tipo"
					},{
		       			"aTargets": [4],
		       			"mData": "archivo"
					},{
		       			"aTargets": [5],
		       			"mData": "estado"
		            }
		        ],
	        	"scrollX": true,
	       		sPaginationType: 'simple',
		   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
		   			if(aData['estado']=='Error'){
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
		$.ajax("${createLink(action:'ajaxGenerarMatriz')}", {
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
</script>
</body>
</html>