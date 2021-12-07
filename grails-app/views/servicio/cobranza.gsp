<!DOCTYPE html>
<html lang="en">
	<head>
		<meta name="layout" content="main">
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
	</head>
	<body>
		<div class="main-body">
			<div class="page-wrapper">
				<!-- Page-header start -->
				<div class="page-header card">
					<div class="dt-responsive table-responsive">
						<div style="float:right;">
							<label style="float:left;padding-top:5px;margin-right:10px;">Mes</label>
							<input style="width:80px;" id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
						</div>
						<div style="float:right;margin-right: 20px;">
							<label style="float:left;padding-top:5px;margin-right:10px;">Año</label>
							<input style="width:80px;" id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año"data-min-year="2010"  value="${ano}"/>
						</div>
						<table id="listaHeader" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Código</th>
									<th>Nombre</th>
									<th>Emitidos</th>
									<th>Pagados (Total)</th>
									<th>Pagos de meses anteriores</th>
									<th>Filtrar</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
							<tfoot>
								<tr>
									<th></th>
									<th></th>
									<th></th>
									<th></th>
									<th></th>
									<th></th>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
				<div class="page-body">
					<div class="card">
						<div class="card-block ">
							<div class="dt-responsive table-responsive">
								<table id="lista" class="table table-striped table-bordered nowrap" style="cursor:pointer">
									<thead>
										<tr>
											<th>Emisión</th>
											<th>Fecha Pago</th>
											<th>Servicio</th>
											<th>Subcódigo</th>
											<th>Cuenta</th>
											<th>Importe</th>
											<th>Importe MP</th>
											<th>Estado</th>
											<th>Avisos</th>
											<th>Factura</th>
											<th>Profesión</th>
											<th>Codigo MP</th>
											<th>Mail MP</th>
											<th>Nombre MP</th>
											<th>Responsable</th>
											<th>Primer Pago</th>
										</tr>
									</thead>
									<tbody>
									</tbody>
									<tfoot>
									    <tr>
									        <th colspan="6"></th>
									        <th></th>
									       	<th></th>
									       	<th></th>
									        <th colspan="5"></th>
									    </tr>
									</tfoot>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			var tabla;
			var tablaHeader;
			jQuery(document).ready(function() {
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
					lang: "es"
				});
				$("#mes").change(function () {
					$("#ano").trigger('change');
				});
				$("#ano").change(function () {
					redirigir('${filtro}')
				});
				tabla = $('#lista').DataTable({
					"footerCallback": function (row, data, start, end, display) {
						var api = this.api(),
							data;

						// Remove the formatting to get integer data for summation
						var intVal = function (i) {
							return typeof i === 'string' ?
								i.replace(/[\$,]/g, '') * 1 :
								typeof i === 'number' ?
								i : 0;
						};

						// Total over all pages
						total = api
							.column("precioCrudo:name")
							.data()
							.reduce(function (a, b) {
								return intVal(a) + intVal(b);
							}, 0);

						// Total over this page
						pageTotal = api
							.column("precioCrudo:name", {
								page: 'current'
							})
							.data()
							.reduce(function (a, b) {
								return intVal(a) + intVal(b);
							}, 0);

						cobradoPageTotal = api
							.column("cobradoCrudo:name", {
								page: 'current'
							})
							.data()
							.reduce(function (a, b) {
								return intVal(a) + intVal(b);
							}, 0);

						cobradoTotal = api
							.column("cobradoCrudo:name")
							.data()
							.reduce(function (a, b) {
								return intVal(a) + intVal(b);
							}, 0);

						var porcentajeTotal
						var porcentajePageTotal
						if (total != 0) {
							porcentajePageTotal = (cobradoPageTotal * 100 / pageTotal).toFixed(2)
							porcentajeTotal = (cobradoTotal * 100 / total).toFixed(2)
						}
						else {
							porcentajePageTotal = "0.00"
							porcentajeTotal = "0,00"
						}
						// Update footer
						$(api.column(5).footer()).html(
							'$' + pageTotal.toFixed(2) + ' ($' + total.toFixed(2) + ' total)'
						);
						$(api.column(7).footer()).html(
							'Cobrado: $' + cobradoPageTotal.toFixed(2) + ' ($' + cobradoTotal.toFixed(2) + ' total)'
						);
						$(api.column(8).footer()).html(
							porcentajePageTotal + '% (' + porcentajeTotal + '% total)'
						);
					},
					//bAutoWidth: false,
					//bSortCellsTop: true,
					//BProcessing: true,
					iDisplayLength: 100,
					"ordering": true,
					"searching": true,
					oLanguage: {
						sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
						sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
						sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
						sZeroRecords: "No hay registros",
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
						[2, 'asc'], // Servicio
						[3, 'asc'], // SubCódigo
						[7, 'desc'] // Pagado
					],
					aoColumnDefs: [{
							"aTargets": [0],
							"mData": "fechaFactura",
							"type": "date-eu"
						}, {
							"aTargets": [1],
							"mData": "fechaPago",
							"type": "date-eu"
						}, {
							"aTargets": [2],
							"mData": "servicio",
							'sClass': 'bold'
						}, {
							"aTargets": [3],
							"mData": "subcodigo"
						}, {
							"aTargets": [4],
							"mData": "cuenta"
						}, {
							"aTargets": [5],
							"mData": "precio",
							"sClass": "text-right",
							"sType": "numeric-comma"
						}, {
							"aTargets": [6],
							"mData": "precioMP",
							"sClass": "text-right",
							"sType": "numeric-comma"
						}, {
							"aTargets": [7],
							"mData": "pagado",
							"mRender": function (pagado, type, item) {
								if (pagado)
									return "Pagado"
								if (item['fechaPago'] != "-")
									return "Verificar"
								else
									return "Impago"
							}
						}, {
							"aTargets": [8],
							"mData": "avisos"
						}, {
							"aTargets": [9],
							"mData": "cae"
						}, {
							"aTargets": [10],
							"mData": "profesion"
						}, {
							"aTargets": [11],
							"mData": "codigoMP"
						},{
							"aTargets": [12],
							"mData": "mailMP"
						}, {
							"aTargets": [13],
							"mData": "nombreMP"
						}, {
							"aTargets": [14],
							"mData": "responsable"
						}, {
							"aTargets": [15],
							"mData": "primerSM"
						}, {
							"aTargets": [16],
							"mData": "precioCrudo",
							"name": "precioCrudo",
							"visible": false
						}, {
							"aTargets": [17],
							"mData": "cobradoCrudo",
							"name": "cobradoCrudo",
							"visible": false
						}
					],
					sPaginationType: 'simple',
					buttons: [
						$.extend(true, {}, {
							exportOptions: {
								// columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,14],
								format: {
									body: function (data, row, column, node) {
										if (data == '-')
											return ''
										data = $('<p>' + data + '</p>').text();
										if ((column == 5) || (column == 6)){
											data = data.replace(/\./g, '');
										}
											return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;

									}
								}
							}
						}, {
							extend: 'excelHtml5',
							title: function () {
								var nombre = "Listado Cobranzas ${filtro} ${mes}${ano}"
								return nombre;
							}
						}),
						{
							extend: 'pdfHtml5',
							orientation: 'landscape',
							title: function () {
								var nombre = "Listado Cobranzas ${filtro} ${mes}${ano}"
								return nombre;
							}
						},
						{
							extend: 'copyHtml5'
						}
					],
					sDom: "lBfrtip",
					fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
						if (aData['pagado']) // Verde, cliente pagó.
							$(nRow).css({
								"background-color": "#73C6B6",
								"color": "white"
							});
						else if (aData['fechaPago'] != "-") // Amarillo, cuando el cupón de pago fue generado y nunca hubo notificación. Verificar en MP.
							$(nRow).css({
								"background-color": "#F4D03F",
								"color": "black"
							});
						$(nRow).on('click', function () {
							window.location.href = "${createLink(controller: 'cuenta', action:'show')}" + '/' + aData['cuentaId'] + "#cuentaCorriente";
						});
					}
				});
				tablaHeader = $('#listaHeader').DataTable({
					//bAutoWidth: false,
					//bSortCellsTop: true,
					//BProcessing: true,
					iDisplayLength: 20,
					"ordering": true,
					"searching": true,
					oLanguage: {
						sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
						sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
						sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
						sZeroRecords: "No hay registros",
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
							"mData": "codigo"
						}, {
							"aTargets": [1],
							"mData": "nombre"
						}, {
							"aTargets": [2],
							"mData": "emitidos",
							"sClass": "text-right"
						}, {
							"aTargets": [3],
							"mData": "pagados",
							"sClass": "text-right"
						}, {
							"aTargets": [4],
							"mData": "pagadosAtrasados",
							"sClass": "text-right"
						}, {
							"aTargets": [5],
							"mData": "filtrar"
						}
					],
					sPaginationType: 'simple',
					"footerCallback": function (row, data, start, end, display) {
						var api = this.api(),
							data;

						// Total over all pages
						emitidosTotal = api
							.column(2, {
									page: 'current'
								})
							.data()
							.reduce(function (a, b) {
								const numA = typeof a === 'number' ? a : a == undefined || a == "" ? 0 : parsearFloat(a)
								const numB = typeof b === 'number' ? b : b == undefined || b == "" ? 0 : parsearFloat(b)
								return numA + numB
							}, 0);
						pagadosTotal = api
							.column(3, {
									page: 'current'
								})
							.data()
							.reduce(function (a, b) {
								const numA = typeof a === 'number' ? a : a == undefined || a == "" ? 0 : parsearFloat(a)
								const numB = typeof b === 'number' ? b : b == undefined || b == "" ? 0 : parsearFloat(b)
								return numA + numB
							}, 0);
						atrasadosTotal = api
							.column(4, {
									page: 'current'
								})
							.data()
							.reduce(function (a, b) {
								const numA = typeof a === 'number' ? a : a == undefined || a == "" ? 0 : parsearFloat(a)
								const numB = typeof b === 'number' ? b : b == undefined || b == "" ? 0 : parsearFloat(b)
								return numA + numB
							}, 0);

						
						// Update footer
						$(api.column(2).footer()).html(
							emitidosTotal
						);
						$(api.column(3).footer()).html(
							pagadosTotal
						);
						$(api.column(4).footer()).html(
							atrasadosTotal
						);
					},
					buttons: [
						$.extend(true, {}, {
							exportOptions: {
								format: {
									body: function (data, row, column, node) {
										if (data == '-')
											return ''
										data = $('<p>' + data + '</p>').text();
										if ((column == 5) || (column == 6)){
											data = data.replace(/\./g, '');
										}
											return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;

									}
								}
							}
						}, {
							extend: 'excelHtml5',
							title: function () {
								var nombre = "Listado Servicios emitidos ${filtro} ${mes}${ano}"
								return nombre;
							}
						}),
						{
							extend: 'pdfHtml5',
							orientation: 'landscape',
							title: function () {
								var nombre = "Listado Servicios emitidos ${filtro} ${mes}${ano}"
								return nombre;
							}
						},
						{
							extend: 'copyHtml5'
						}
					],
					sDom: "tB",
					// sDom: "lBfrtip",
					fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {}
				});
				llenarDatosListCobranzas();
			});

			function llenarDatosListCobranzas(){
				tabla.clear().draw();
				tablaHeader.clear().draw();
				$.ajax("${createLink(action: 'ajaxGetListCobranza')}", {
					dataType: "json",
					data: {
						filtro: "${filtro}",
						mes: $("#mes").val(),
						ano: $("#ano").val(),
						mensual: "${tipo}" == 'mensual'
					}
				}).done(function (data) {
					for (key in data.items) {
						tabla.row.add(data.items[key]);
					}
					for (key in data.servicios) {
						tablaHeader.row.add(data.servicios[key]);
					}
					tabla.draw();
					tablaHeader.draw();
					$('#loaderGrande').fadeOut('slow');
				});
			}
			
			function redirigir(filtro, borrarParametros = false) {
			    $('#loaderGrande').fadeIn("slow");
			    let link
			    if (borrarParametros)
			    	link = "${createLink(action:'cobranza', id:tipo)}"
			    else{
					const base = "${raw(createLink(action:'cobranza', id:tipo, params:[filtrar:'varFiltro', mes:'varMes',ano:'varAno']))}"
					const mes = $("#mes").val()
					const ano = $("#ano").val()
					link = base.replace('varFiltro',filtro).replace('varMes',mes).replace('varAno',ano)
				}
				window.location.href = link
			}
		</script>
	</body>
</html>