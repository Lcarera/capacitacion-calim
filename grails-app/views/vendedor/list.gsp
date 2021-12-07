<!DOCTYPE html>

<html lang="en">
	<head>
		<meta name="layout" content="main">
	</head>
	<body>
	<g:hiddenField id="cuentaDebitoAutomatico" name="cuentaDebitoAutomatico" value="${cuentaDebitoAutomatico}"/>
		<div class="main-body">
			<div class="page-wrapper">
				<div class="page-header card">
					<div class="row align-items-end">
						<div class="col-lg-8">
							<div class="page-header-title">
								<div class="d-inline">
									<h4>Administración de Vendedores</h4>
								</div>
							</div>
						</div>
						<div class="col-lg-4">
						</div>
					</div>
				</div>
				<div class="page-body">
					<div class="row">
						<div class="col-md-12 col-xl-12 ">
							<div class="card">
								<div class="card-block">
									<h4 style="margin-bottom:20px;">Lista de Vendedores
										<div style="float:right;">
											<button type="button" class="btn btn-success" onclick="$('#modalAgregarVendedor').modal('show');">Agregar</button>
										</div>
									</h4>
									<div id="preloaderVendedores" class="preloader3" style="display:none;">
										<div class="circ1 loader-primary"></div>
										<div class="circ2 loader-primary"></div>
										<div class="circ3 loader-primary"></div>
										<div class="circ4 loader-primary"></div>
									</div>
									<div id="divListVendedores" class="dt-responsive table-responsive">
										<table id="listaVendedores" class="table table-striped table-bordered nowrap" style="cursor:pointer">
											<thead>
												<tr>
													<th>Nombre</th>
													<th>Email</th>
													<th>Celular</th>
													<th>Cuenta Google</th>
													<th>Vacaciones</th>
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
					<div class="row">
						<div class="col-md-12 col-xl-12 ">
							<div class="card">
								<div class="card-block">
									<h4 style="margin-bottom:20px;">Lista de Horarios
									</h4>
									<div id="preloaderHorarios" class="preloader3" style="display:none;">
										<div class="circ1 loader-primary"></div>
										<div class="circ2 loader-primary"></div>
										<div class="circ3 loader-primary"></div>
										<div class="circ4 loader-primary"></div>
									</div>
									<div id="divListHorarios" class="dt-responsive table-responsive">
										<table id="listaHorarios" class="table table-striped table-bordered nowrap" style="cursor:pointer">
											<thead>
												<tr>
													<th>Vendedor</th>
													<th>Lunes</th>
													<th>Martes</th>
													<th>Miercoles</th>
													<th>Jueves</th>
													<th>Viernes</th>
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
					<div class="row">
						<div class="col-md-12 col-xl-12 ">
							<div class="card">
								<div class="card-block user-detail-card">
									<h4>Dias Extra</h4>
									<table id="listDiasExtra" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
										<thead>
											<tr>
												<th>Fecha</th>
												<th>Detalle</th>
												<th>Vendedor asignado</th>
											</tr>
										</thead>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="modal fade" id="modalAgregarVendedor" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title">Agregar Vendedor</h4>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Nombre</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalAgregarVendedor_nombre" name="nombre" type="text" class="form-control">
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Email</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalAgregarVendedor_email" name="email" type="text" class="form-control">
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Celular</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalAgregarVendedor_celular" name="celular" type="text" class="form-control">
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Cuenta Google</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalAgregarVendedor_cuentaGoogle" name="cuentaGoogle" type="text" class="form-control">
									</div>
								</div>
							</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
							<button type="button" class="btn btn-primary waves-effect waves-light " onclick="agregarVendedor()">Confirmar</button>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="modal fade" id="modalEditarVendedor" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title">Editar Vendedor</h4>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<div class="form-group row" style="display: none;">
								<label class="col-sm-2 col-form-label">ID</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalEditarVendedor_id" name="vendedorId" type="text" class="form-control">
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Nombre</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalEditarVendedor_nombre" name="nombre" type="text" class="form-control">
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Email</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalEditarVendedor_email" name="email" type="text" class="form-control">
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Celular</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalEditarVendedor_celular" name="celular" type="text" class="form-control">
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Cuenta Google</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalEditarVendedor_cuentaGoogle" name="cuentaGoogle" type="text" class="form-control">
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Vacaciones</label>
								<div class="col-sm-10">
									<div class="checkbox-fade fade-in-primary">
									<label class="check-task">
										<input id="modalEditarVendedor_vacaciones" name="vacaciones" type="checkbox" value="true">
										<span class="cr">
											<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
										</span>
									</label>
								</div>
								</div>
							</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
							<button type="button" class="btn btn-danger waves-effect waves-light " onclick="eliminarVendedor()">Eliminar</button>
							<button type="button" class="btn btn-primary waves-effect waves-light " onclick="editarVendedor()">Confirmar</button>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="modal fade" id="modalEditarHorario" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title">Editar Horario</h4>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<div class="form-group row" style="display: none;">
								<label class="col-sm-2 col-form-label">ID Vendedor</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalEditarHorario_vendedorId" name="horarioVendedorId" type="text" class="form-control" readonly>
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Vendedor</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalEditarHorario_vendedorNombre" name="horarioVendedorNombre" type="text" class="form-control" readonly>
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Lunes</label>
								<div class="col-sm-10">
									<div class="input-group">
										<label style="margin-top: 6px">Entrada &nbsp</label>
										<select id="modalEditarHorario_lunesEntrada" name="lunesEntrada" type="text" class="form-control" style="margin-right: 10px">
											<g:each in="${(8..21)}">
												<option value="${it}">${it}</option>
											</g:each>
										</select>
										<label style="margin-top: 6px">Salida &nbsp</label>
										<select id="modalEditarHorario_lunesSalida" name="lunesSalida" type="text" class="form-control" style="margin-right: 10px">
											<g:each in="${(8..21)}">
												<option value="${it}">${it}</option>
											</g:each>
										</select>

									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Martes</label>
								<div class="col-sm-10">
									<div class="input-group">
										<label style="margin-top: 6px">Entrada &nbsp</label>
										<select id="modalEditarHorario_martesEntrada" name="martesEntrada" type="text" class="form-control" style="margin-right: 10px">
											<g:each in="${(8..21)}">
												<option value="${it}">${it}</option>
											</g:each>
										</select>
										<label style="margin-top: 6px">Salida &nbsp</label>
										<select id="modalEditarHorario_martesSalida" name="martesSalida" type="text" class="form-control" style="margin-right: 10px">
											<g:each in="${(8..21)}">
												<option value="${it}">${it}</option>
											</g:each>
										</select>
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Miercoles</label>
								<div class="col-sm-10">
									<div class="input-group">
										<label style="margin-top: 6px">Entrada &nbsp</label>
										<select id="modalEditarHorario_miercolesEntrada" name="miercolesEntrada" type="text" class="form-control" style="margin-right: 10px">
											<g:each in="${(8..21)}">
												<option value="${it}">${it}</option>
											</g:each>
										</select>
										<label style="margin-top: 6px">Salida &nbsp</label>
										<select id="modalEditarHorario_miercolesSalida" name="miercolesSalida" type="text" class="form-control" style="margin-right: 10px">
											<g:each in="${(8..21)}">
												<option value="${it}">${it}</option>
											</g:each>
										</select>
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Jueves</label>
								<div class="col-sm-10">
									<div class="input-group">
										<label style="margin-top: 6px">Entrada &nbsp</label>
										<select id="modalEditarHorario_juevesEntrada" name="juevesEntrada" type="text" class="form-control" style="margin-right: 10px">
											<g:each in="${(8..21)}">
												<option value="${it}">${it}</option>
											</g:each>
										</select>
										<label style="margin-top: 6px">Salida &nbsp</label>
										<select id="modalEditarHorario_juevesSalida" name="juevesSalida" type="text" class="form-control" style="margin-right: 10px">
											<g:each in="${(8..21)}">
												<option value="${it}">${it}</option>
											</g:each>
										</select>
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Viernes</label>
								<div class="col-sm-10">
									<div class="input-group">
										<label style="margin-top: 6px">Entrada &nbsp</label>
										<select id="modalEditarHorario_viernesEntrada" name="viernesEntrada" type="text" class="form-control" style="margin-right: 10px">
											<g:each in="${(8..21)}">
												<option value="${it}">${it}</option>
											</g:each>
										</select>
										<label style="margin-top: 6px">Salida &nbsp</label>
										<select id="modalEditarHorario_viernesSalida" name="viernesSalida" type="text" class="form-control" style="margin-right: 10px">
											<g:each in="${(8..21)}">
												<option value="${it}">${it}</option>
											</g:each>
										</select>
									</div>
								</div>
							</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
							<button type="button" class="btn btn-primary waves-effect waves-light " onclick="editarHorario()">Confirmar</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	
		<script type="text/javascript">
			var tablaVendedores;
			var tablaHorarios;
			var tablaDiasExtra;

			$(document).ready(function () {

					tablaVendedores = $('#listaVendedores').DataTable({
						bAutoWidth: true,
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
							"mData": "nombre"
						}, {
							"aTargets": [1],
							"mData": "email"
						}, {
							"aTargets": [2],
							"mData": "celular"
						}, {
							"aTargets": [3],
							"mData": "cuentaGoogle"
						}, {
							"aTargets": [4],
							"mData": "vacaciones",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
						}],
						sPaginationType: 'simple',
						fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
							$(nRow).on('click', function() {
								toggleEditarVendedor(aData);
							});
						}
					});
				llenarDatoslistVendedores();

				tablaHorarios = $('#listaHorarios').DataTable({
						bAutoWidth: true,
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
							"mData": "nombre"
						}, {
							"aTargets": [1],
							"mData": "lunes"
						}, {
							"aTargets": [2],
							"mData": "martes"
						}, {
							"aTargets": [3],
							"mData": "miercoles"
						}, {
							"aTargets": [4],
							"mData": "jueves"
						}, {
							"aTargets": [5],
							"mData": "viernes"
						}],
						sPaginationType: 'simple',
						fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
							$(nRow).on('click', function() {
								toggleEditarHorario(aData);
							});
						}
					});
				llenarDatoslistHorarios();

				tablaDiasExtra = $('#listDiasExtra').DataTable({
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
					[0, 'asc']
				],
				aoColumnDefs: [{
					"aTargets": [0],
					"mData": "fecha",
					"type": "date-eu"
				}, {
					"aTargets": [1],
					"mData": "detalle"
				}, {
					"aTargets": [2],
					"mData": "vendedor"
				}],
				buttons: [
					$.extend(true, {}, {
						exportOptions: {
							columns: [0, 1, 2],
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
							var nombre = "Dias Extra"
							return nombre;
						}
					}),
					{
						extend: 'pdfHtml5',
						orientation: 'landscape',
						title: function () {
							var nombre = "Dias Extra"
							return nombre;
						}
					},
					{
						extend: 'copyHtml5'
					}
				],
				sPaginationType: 'simple',
				sDom: "lBfrtip",
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
					// Row click
					/*$(nRow).on('click', function() {
						asignarDiaExtra(aData['id']);
					});*/
				}
			});

			llenarDatoslistDiasExtra();
			});	

			function llenarDatoslistVendedores() {
				$("#preloaderVendedores").show()
				$("#divListVendedores").hide()
				tablaVendedores.clear();
				$.ajax("${createLink(controller: 'vendedor', action: 'ajaxGetVendedores')}", {
					dataType: "json",
					data: {
					}
				}).done(function (data) {
					for (key in data) {
						tablaVendedores.row.add(data[key]);
					}
					$("#preloaderVendedores").hide()
					$("#divListVendedores").show()
					tablaVendedores.draw();
				});
			}

			function llenarDatoslistHorarios() {
				$("#preloaderHorarios").show()
				$("#divListHorarios").hide()
				tablaHorarios.clear();
				$.ajax("${createLink(controller: 'vendedor', action: 'ajaxGetVendedores')}", {
					dataType: "json",
					data: {
					}
				}).done(function (data) {
					for (key in data) {
						tablaHorarios.row.add(data[key]);
					}
					$("#preloaderHorarios").hide()
					$("#divListHorarios").show()
					tablaHorarios.draw();
				});
			}

			function llenarDatoslistDiasExtra(){
				tablaDiasExtra.clear().draw();
					$("#preloader").show();
					$.ajax("${createLink(controller: 'vendedor', action: 'ajaxGetListaDiasExtra')}" , {
						dataType: "json",
						data: {
						}
					}).done(function(data) {
						$("#preloader").hide();
						for(key in data){
							tablaDiasExtra.row.add(data[key]);
						}
						tablaDiasExtra.draw();
					});
			}

			function agregarVendedor(){
				$.ajax("${createLink(controller: 'vendedor', action: 'ajaxCrearVendedor')}", {
					dataType: "json",
					data: {
						nombre: $("#modalAgregarVendedor_nombre").val(),
						email: $("#modalAgregarVendedor_email").val(),
						celular: $("#modalAgregarVendedor_celular").val(),
						cuentaGoogle: $("#modalAgregarVendedor_cuentaGoogle").val()
					}
				}).done(function (respuesta) {
					if (respuesta.hasOwnProperty('error'))
						swal("Error", respuesta.error, "error");
					else{
						swal("Exito!", respuesta.ok, "success");
						$("#modalAgregarVendedor").modal('hide');
						llenarDatoslistVendedores();
						llenarDatoslistHorarios();
					}
				});
			}

			function toggleEditarVendedor(aData){
				$("#modalEditarVendedor_id").val(aData['id']);
				$("#modalEditarVendedor_nombre").val(aData['nombre']);
				$("#modalEditarVendedor_email").val(aData['email']);
				$("#modalEditarVendedor_celular").val(aData['celular']);
				$("#modalEditarVendedor_cuentaGoogle").val(aData['cuentaGoogle']);
				if(aData['vacaciones']==true)
					$("#modalEditarVendedor_vacaciones").prop("checked",true);
				else
					$("#modalEditarVendedor_vacaciones").prop("checked",false);
				$("#modalEditarVendedor").modal('show');
			}

			function toggleEditarHorario(aData){
				$("#modalEditarHorario_vendedorId").val(aData['id'])
				$("#modalEditarHorario_vendedorNombre").val(aData['nombre'])
				document.getElementById("modalEditarHorario_lunesEntrada").value = aData['lunes'].split(" ")[0]
				document.getElementById("modalEditarHorario_lunesSalida").value = aData['lunes'].split(" ")[2]
				document.getElementById("modalEditarHorario_martesEntrada").value = aData['martes'].split(" ")[0]
				document.getElementById("modalEditarHorario_martesSalida").value = aData['martes'].split(" ")[2]
				document.getElementById("modalEditarHorario_miercolesEntrada").value = aData['miercoles'].split(" ")[0]
				document.getElementById("modalEditarHorario_miercolesSalida").value = aData['miercoles'].split(" ")[2]
				document.getElementById("modalEditarHorario_juevesEntrada").value = aData['jueves'].split(" ")[0]
				document.getElementById("modalEditarHorario_juevesSalida").value = aData['jueves'].split(" ")[2]
				document.getElementById("modalEditarHorario_viernesEntrada").value = aData['viernes'].split(" ")[0]
				document.getElementById("modalEditarHorario_viernesSalida").value = aData['viernes'].split(" ")[2]
				$("#modalEditarHorario").modal("show");
			}

			function editarVendedor(){
				$.ajax("${createLink(controller: 'vendedor', action: 'ajaxEditarVendedor')}", {
					dataType: "json",
					data: {
						vendedorId: $("#modalEditarVendedor_id").val(),
						nombre: $("#modalEditarVendedor_nombre").val(),
						email: $("#modalEditarVendedor_email").val(),
						celular: $("#modalEditarVendedor_celular").val(),
						cuentaGoogle: $("#modalEditarVendedor_cuentaGoogle").val(),
						vacaciones: $("#modalEditarVendedor_vacaciones").prop('checked')
					}
				}).done(function (respuesta) {
					if (respuesta.hasOwnProperty('error'))
						swal("Error", respuesta.error, "error");
					else{
						swal("Exito!", respuesta.ok, "success");
						$("#modalEditarVendedor").modal('hide');
						llenarDatoslistVendedores();
						llenarDatoslistHorarios();
					}
				});
			}

			function eliminarVendedor(){
				$.ajax("${createLink(controller: 'vendedor', action: 'ajaxDeshabilitarVendedor')}", {
					dataType: "json",
					data: {
						id: $("#modalEditarVendedor_id").val()
					}
				}).done(function (respuesta) {
					if (respuesta.hasOwnProperty('error'))
						swal("Error", respuesta.error, "error");
					else{
						swal("Exito!", respuesta.ok, "success");
						$("#modalEditarVendedor").modal('hide');
						llenarDatoslistVendedores();
						llenarDatoslistHorarios();
					}
				});
			}

			function editarHorario(){
				$.ajax("${createLink(controller: 'vendedor', action: 'ajaxEditarHorario')}", {
					dataType: "json",
					data: {
						vendedorId: $("#modalEditarHorario_vendedorId").val(),
						lunesEntrada: $("#modalEditarHorario_lunesEntrada").val(),
						lunesSalida:$("#modalEditarHorario_lunesSalida").val(),
						martesEntrada: $("#modalEditarHorario_martesEntrada").val(),
						martesSalida:$("#modalEditarHorario_martesSalida").val(),
						miercolesEntrada: $("#modalEditarHorario_miercolesEntrada").val(),
						miercolesSalida:$("#modalEditarHorario_miercolesSalida").val(),
						juevesEntrada: $("#modalEditarHorario_juevesEntrada").val(),
						juevesSalida:$("#modalEditarHorario_juevesSalida").val(),
						viernesEntrada: $("#modalEditarHorario_viernesEntrada").val(),
						viernesSalida:$("#modalEditarHorario_viernesSalida").val()
					}
				}).done(function (respuesta) {
					if (respuesta.hasOwnProperty('error'))
						swal("Error", respuesta.error, "error");
					else{
						swal("Exito!", respuesta.ok, "success");
						$("#modalEditarHorario").modal('hide');
						llenarDatoslistVendedores();
						llenarDatoslistHorarios();
					}
				});
			}

			function asignarDiaExtra(diaExtraId){
				$.ajax({
					url : "${createLink(controller:'vendedor', action:'ajaxAsignarDiaExtra')}",
					data : {
						'id' : diaExtraId
					},
					success : function(resultado){
						if (resultado.hasOwnProperty('error'))
							swal("Error", resultado.error, "error");
						else{
							swal("Exito!",resultado.ok , "success");
							llenarDatoslistDiasExtra();
						}
					}
				});
			}

		</script>
	</body>
</html>