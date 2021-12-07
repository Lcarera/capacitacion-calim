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
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/morris.js/0.5.1/morris.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/morris.js/0.5.1/morris.min.js"></script>
</head>
<body>	
<div style="display: none;">

</div>

<div class="main-body">
	<div class="page-wrapper">		
		<!-- Header -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-8">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4>Gerencia</h4>
						</div>
					</div>
				</div>
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
			</div>
		</div>
		<!-- Fin: Header -->
		<!-- Importación de archivo (si no está ya cargado) -->
		<div class="page-body" id="divImportacion">
			<div class="card">
				<div class="card-block ">
					<g:uploadForm name="archivoForm" controller="importacion" action="ajaxGerenciaMP">
						<div class="form-group row">
							<div class="col-sm-12">
								<input type="file" name="archivo" id="filerArchivo">
							</div>
						</div>
					</g:uploadForm>
					<div style="text-align: center;">
						<button type="button" style="margin-top: 10px;" class="btn btn-danger alert-success-cancel m-b-0" onclick='window.location.href = "${raw(createLink(action:"gerencia", params:[mes:mes, ano:ano, forzarViewDatos:true]))}"'>Saltear importación</button>
					</div>
				</div>
			</div>
		</div>
		<!-- Fin: Importación de archivo -->
		<!-- Muestra de datos -->
		<div class="page-body" id="divMuestra" style="display: none;">

			<g:if test="${!!log?.id}">
				<div class="card">
					<div class="card-block">
						<div>
							<h4 style="margin-bottom:20px;">Detalles del Excel</h4>
							<label> ${log?.with{total - ignorados}} Facturas leídas</label>
							<br/>
							<label> Sumatoria de monton de las facturas acreditadas del excel: $${log?.sumatoriaString}</label>
							<br/>
							<button type="button" class="btn btn-primary m-b-0" onclick='$("#modalResultadoImportacion").modal("show");'>Ver Errores (${log?.with{total - correctos}})</button>
							<br/>
							<button type="button" style="margin-top: 10px;" class="btn btn-danger alert-success-cancel m-b-0" onclick='window.location.href = "${createLink(action:"cancelarLog")}/${log?.id}"'>Eliminar y volver a subir</button>
						</div>
					</div>
				</div>
			</g:if>

			<div class="card">
				<div class="card-block">
					<div class="row">
						<div class="col-sm-6">
							<div style="width:100%; text-align:center; font-size:18px;">Distribución de Servicios</div>
							<div id="donut_sm_se"></div>
						</div>
						<div class="col-sm-6">
							<div style="width:100%; text-align:center; font-size:18px;">Servicios Mensuales</div>
							<div id="donut_sm"></div>
						</div>
					</div>
				</div>
			</div>

			<div class="card">
				<div class="card-block">
					<div>
						<h4 style="margin-bottom:20px;">Distribución de Facturas</h4>
						<label id="cantidadEspeciales"> XX Servicios Especiales. ($xx.yy)</label>
						<br/>
						<label id="cantidadMensuales"> XX Servicios Mensuales (YY nuevos; XX atrasados). ($xx.yy)</label>
						<br/>
						<label id="importeTotal"> XX facturas cobradas, por un monto de $xx.yy</label>
						<br/>
						<label id="cantidadReembolsos"> XX Reembolsos (XX mensuales y XX especiales) por un monto de $xx.yy</label>
						<br/>
						<label id="finde">Se emitieron XX facturas en fines de semana, de las cuales XX están pagas y XX reembolsadas.</label>
					</div>
				</div>
			</div>

			<div class="card">
				<div class="card-block">
					<div class="row">
						<div class="col-sm-6">
							<div style="width:100%; text-align:center; font-size:18px;">S.E. por Vendedor</div>
							<div id="donut_se_vendedor"></div>
						</div>
						<div class="col-sm-6">
							<div style="width:100%; text-align:center; font-size:18px;">S.M. por Vendedor</div>
							<div id="donut_sm_vendedor"></div>
						</div>
					</div>
				</div>
			</div>

			<div class="card">
				<div class="card-block">
					<div class="dt-responsive table-responsive">
						<div style="float:right;">
							<select id="cbVendedor" style="float:left;padding-top:8px;margin-right:10px;margin-bottom:2px;text-transform: none"></select>
						</div>
						<h4 style="margin-bottom:20px;" id="nombreVendedor">Ventas de Vendedor</h4>
						<table id="listVendedores" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Emitida</th>
									<th>Pagada</th>
									<th>Importe</th>
									<th>Comisión</th>
									<th>Detalle</th>
									<th>Cliente</th>
									<th>Profesión</th>
									<th>MP</th>
									<th>Vendedor</th>
								</tr>
								<tfoot>
								    <tr>
								        <th colspan="2"></th>
								        <th id="totalVendedor"></th>
								       	<th id="comisionVendedor"></th>
								        <th colspan="4"></th>
								    </tr>
								</tfoot>
							</thead>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- Fin: Muestra de datos -->
		<!-- Modal Errores -->
		<div class="modal fade" id="modalResultadoImportacion" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document" style="width:100%;max-width:1250px">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">Errores</h4>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body" style="padding:0px;">

						<div class="col-md-12">
							<table id="listaErrores" class="table table-striped table-bordered nowrap" style="width: 100%;">
								<thead>
									<tr>
										<th>Error</th>
										<th>Notificación</th>
										<th>Email</th>
										<th>Fecha</th>
										<th>Descripción</th>
										<th>Estado Excel</th>
										<th>Estado Sistema</th>
										<th>Monto Excel</th>
										<th>Monto Sistema</th>
										<th>Cuenta</th>
										<th>Log de reconstrucción</th>
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
		<!-- Fin: Modal Errores -->
	</div>
</div>


<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
<script type="text/javascript">
	var tablaErrores;
	var tablaVendedores;
	var listadoGerencia;
	jQuery(document).ready(function () {

		tablaErrores = $('#listaErrores').DataTable({
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
				[0, 'asc'],
				[5, 'asc']
			],
			aoColumnDefs: [{
				"aTargets": [0],
				"mData": "tipoError"
			}, {
				"aTargets": [1],
				"mData": "notificacionId"
			}, {
				"aTargets": [2],
				"mData": "mailPagante"
			}, {
				"aTargets": [3],
				"mData": "fechaHora"
			}, {
				"aTargets": [4],
				"mData": "descripcion"
			}, {
				"aTargets": [5],
				"mData": "estado"
			}, {
				"aTargets": [6],
				"mData": "estadoSistema"
			}, {
				"aTargets": [7],
				"mData": "monto"
			}, {
				"aTargets": [8],
				"mData": "montoSistema"
			}, {
				"aTargets": [9],
				"mData": "cuenta"
			}, {
				"aTargets": [10],
				"mData": "logDisparo"
			}],
			"scrollX": true,
			sPaginationType: 'simple',
			buttons: [
				$.extend(true, {}, {
					exportOptions: {
						columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
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
						var nombre = "Errores Importacion MP ${mes} ${ano}"
						return nombre;
					}
				}),
				{
					extend: 'pdfHtml5',
					orientation: 'landscape',
					title: function () {
						var nombre = "Errores Importacion MP ${mes} ${ano}"
						return nombre;
					}
				},
				{
					extend: 'copyHtml5'
				}
			],
			sDom: "lBfrtip"
		});

		if (${!!log}) {
			$("#divImportacion").hide()
			$("#divMuestra").show()

			$.ajax("${createLink(controller:'importacion', action:'ajaxGetLogGerencia')}", {
				dataType: "json",
				data: {
					id: "${log?.id}"
				}
			}).done(function (resultado) {
				tablaErrores.rows.add(resultado.fallos).draw()
			});

			tablaVendedores = $('#listVendedores').DataTable({
				//bAutoWidth: false,
				//bSortCellsTop: true,
				//BProcessing: true,
				"ordering": true,
				"searching": true,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "No se encontraron ventas en el periodo.",
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
				// iDisplayLength: 100,
				//scrollX: true,
				aaSorting: [
					[0, 'desc'],
					[1, 'desc']
				],
				aoColumnDefs: [{
					"aTargets": [0],
					"mData": "fechaEmision",
					"type": "date-eu"
				}, {
					"aTargets": [1],
					"mData": "fechaPago",
					"type": "date-eu"
				}, {
					"aTargets": [2],
					"mData": "importe",
					"sClass": "text-right",
					"sType": "numeric-comma"
				}, {
					"aTargets": [3],
					"mData": "comision",
					"sClass": "text-right",
					"sType": "numeric-comma"
				}, {
					"aTargets": [4],
					"mData": "detalle"
				}, {
					"aTargets": [5],
					"mData": "cliente"
				}, {
					"aTargets": [6],
					"mData": "profesion"
				}, {
					"aTargets": [7],
					"mData": "emailMP"
				}, {
					"aTargets": [8],
					"mData": "vendedor"
				}],
				buttons: [
					$.extend(true, {}, {
						exportOptions: {
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
							var nombre = "Errores Importacion MP ${mes} ${ano}"
							return $("#nombreVendedor").text() + " ${mes} ${ano}";
						}
					}),
					{
						extend: 'pdfHtml5',
						orientation: 'landscape',
						title: function () {
							var nombre = "Errores Importacion MP ${mes} ${ano}"
							return $("#nombreVendedor").text() + " ${mes} ${ano}";
						}
					},
					{
						extend: 'copyHtml5'
					}
				],
				sPaginationType: 'simple',
				sDom: "lBfrtip"
			});

			$("#cbVendedor").select2({
				placeholder: '<g:message code="zifras.provincia.Provincia.placeHolder" default="Seleccione un vendedor"/>',
				formatNoMatches: function () {
					return '<g:message code="default.no.elements" default="No hay elementos"/>';
				},
				formatSearching: function () {
					return '<g:message code="default.searching" default="Buscando..."/>';
				},
				minimumResultsForSearch: 1,
				formatSelection: function (item) {
					return item.text;
				}
			});
			$("#cbVendedor").change(function () {
				const vendedor = listadoGerencia.vendedores[leerInt('cbVendedor')]
				tablaVendedores.clear()
				if (vendedor.nombre == "Todos") {
					for (var i = listadoGerencia.vendedores.length - 1; i >= 0; i--)
						tablaVendedores.rows.add(listadoGerencia.vendedores[i].ventas)
					tablaVendedores.draw()
				}
				else
					tablaVendedores.rows.add(vendedor.ventas).draw()
				$("#nombreVendedor").text("Ventas de " + vendedor.nombre);
				$("#totalVendedor").text("$" + vendedor.total);
				$("#comisionVendedor").text("$" + vendedor.comision);
			});

			$.ajax("${createLink(action:'ajaxGetListGerencia')}", {
				dataType: "json",
				data: {
					mes: "${mes}",
					ano: "${ano}"
				}
			}).done(function (data) {
				listadoGerencia = data;

				let dataVendedores = []
				let index = 0;
				listadoGerencia.vendedores.forEach(function (it) {
					dataVendedores.push({
						nombre: it.nombre,
						id: index
					})
					index++
				});
				llenarCombo({
					comboId: "cbVendedor",
					idDefault: '0',
					data: dataVendedores
				});
				const cantidadTotalServicios = listadoGerencia.cantidadSE + listadoGerencia.cantidadSM
				$("#cantidadEspeciales").text(listadoGerencia.cantidadSE + " Servicios Especiales, total de $" + listadoGerencia.importeSE)
				$("#cantidadMensuales").text(listadoGerencia.cantidadSM + " Servicios Mensuales (" + listadoGerencia.nuevosSM + " nuevos; " + listadoGerencia.atrasadosSM + " atrasados), total de $" + listadoGerencia.importeSM)
				$("#importeTotal").text(cantidadTotalServicios + " facturas cobradas, por un monto de $" + listadoGerencia.importeTotal)
				$("#finde").text("Se emitieron " + listadoGerencia.facturasFinde + " facturas en fines de semana, de las cuales " + listadoGerencia.facturasFindePagadas + " están pagas y " + listadoGerencia.facturasFindeReembolsadas + " reembolsadas.")
				$("#cantidadReembolsos").text(listadoGerencia.reembolsos + " Reembolsos (" + listadoGerencia.reembolsosSM + " mensuales y " + listadoGerencia.reembolsosSE + " especiales) por un monto de $" + listadoGerencia.importeReembolsado)
				$("#loaderGrande").hide()

				Morris.Donut({
					element: 'donut_sm_se',
					colors: [
						'#87CEEB',
						'#00FA9A'
					],
					data: [{
							label: "Mensuales",
							value: listadoGerencia.cantidadSM
						},
						{
							label: "Especiales",
							value: listadoGerencia.cantidadSE
						}
					],
					formatter: function (valor) {
						return "" + valor + "/" + cantidadTotalServicios + " (" + (100 * valor / cantidadTotalServicios).toFixed(2) + "%)"
					}
				});

				Morris.Donut({
					element: 'donut_sm',
					colors: [
						'#87CEEB',
						'#00FA9A',
						'#E50000'
					],
					data: [{
							label: "Nuevos",
							value: listadoGerencia.nuevosSM
						},
						{
							label: "A tiempo",
							value: listadoGerencia.cantidadSM - listadoGerencia.atrasadosSM - listadoGerencia.nuevosSM
						},
						{
							label: "Atrasados",
							value: listadoGerencia.atrasadosSM
						}
					],
					formatter: function (valor) {
						return "" + valor + " (" + (100 * valor / listadoGerencia.cantidadSM).toFixed(2) + "%)"
					}
				});

				var dataVendedor = []
				for (var i = listadoGerencia.vendedores.length - 1; i >= 0; i--) {
					const vendedor = listadoGerencia.vendedores[i]
					if (vendedor.nombre != "Todos")
						dataVendedor.push({
							label: vendedor.nombre,
							value: vendedor.cantMensuales
						})
				}

				Morris.Donut({
					element: 'donut_sm_vendedor',
					data: dataVendedor,
					formatter: function (valor) {
						return "" + valor + " (" + (100 * valor / listadoGerencia.nuevosSM).toFixed(2) + "%)"
					}
				});

				dataVendedor = []
				for (var i = listadoGerencia.vendedores.length - 1; i >= 0; i--) {
					const vendedor = listadoGerencia.vendedores[i]
					if (vendedor.nombre != "Todos")
						dataVendedor.push({
							label: vendedor.nombre,
							value: vendedor.cantEspeciales
						})
				}

				Morris.Donut({
					element: 'donut_se_vendedor',
					data: dataVendedor,
					formatter: function (valor) {
						return "" + valor + " (" + (100 * valor / listadoGerencia.cantidadSE).toFixed(2) + "%)"
					}
				});

				if (${!!log?.id} && listadoGerencia.importeTotal != "${log?.sumatoriaString}")
					swal("Advertencia", "El monto obtenido del excel (\$${log?.sumatoriaString}) difiere del monto calculado en sistema (\$" + listadoGerencia.importeTotal + ")", "error")
			});
		}
		else {
			$('#filerArchivo').filer({
				uploadFile: {
					url: "${raw(createLink(controller:'importacion', action:'ajaxGerenciaMP'))}",
					data: {
						mes: "${mes}",
						ano: "${ano}"
					},
					type: 'POST', //The type of request {String}
					enctype: 'multipart/form-data', //Request enctype {String}
					synchron: true,
					beforeSend: function () {
						$("#loaderGrande").show()
					},
					success: function (resultado) {
						$("#loaderGrande").hide()
						if (!resultado.mensajeError) {
							swal("Archivo cargado", resultado.detalle, "success")
							tablaErrores.rows.add(resultado.fallos).draw()
							$("#modalResultadoImportacion").modal('show');
						}
						else
							swal("Error de Archivo", resultado.mensajeError, "error")
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

			$('#modalResultadoImportacion').on('hidden.bs.modal', function (e) {
				$("#loaderGrande").show()
				window.location.reload();
			})

			$("#loaderGrande").hide()
		}

		$("#mes").dateDropper({
			dropWidth: 200,
			dropPrimaryColor: "#1abc9c",
			dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "m",
			lang: "es"
		});

		$("#ano").dateDropper({
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
			cambiarFecha();
		});

		$("#mes").change(function () {
			cambiarFecha();
		});
	});

	function cambiarFecha() {
		$("#loaderGrande").show()
		const base = "${raw(createLink(action:'gerencia', params:[mes:'varmes', ano:'varano']))}"
		window.location.href = base.replace('varmes', $("#mes").val()).replace('varano', $("#ano").val())
	}
</script>
</body>
</html>