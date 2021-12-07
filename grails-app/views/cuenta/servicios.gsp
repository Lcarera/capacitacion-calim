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
									<h4>Cuenta ${cuentaNombre}</h4>
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
									<h4 style="margin-bottom:20px;">Servicios Mensuales
										<div style="float:right;">
											<button type="button" class="btn btn-success" onclick="$('#modalServicioMensual').modal('show')">Agregar</button>
										</div>
									</h4>
									<div id="preloaderServiciosMensuales" class="preloader3" style="display:none;">
										<div class="circ1 loader-primary"></div>
										<div class="circ2 loader-primary"></div>
										<div class="circ3 loader-primary"></div>
										<div class="circ4 loader-primary"></div>
									</div>
									<div id="divListServiciosMensuales" class="dt-responsive table-responsive">
										<table id="listaServiciosMensuales" class="table table-striped table-bordered nowrap" style="cursor:pointer">
											<thead>
												<tr>
													<th style="padding: 2px;"></th>
													<th>Fecha Alta</th>
													<th>Fecha Baja</th>
													<th>Código</th>
													<th>Nombre</th>
													<th>Importe</th>
													<th>Descuento</th>
													<th>Responsable</th>
													<th>Debito Automatico</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-12 col-xl-12 ">
							<div class="card">
								<div class="card-block">
									<h4 style="margin-bottom:20px;">Servicios Especiales
										<div style="float:right;">
											<button type="button" class="btn btn-success" onclick="$('#modalServicioEspecial').modal('show')">Agregar</button>
										</div>
									</h4>
									<div id="preloaderServiciosEspeciales" class="preloader3" style="display:none;">
										<div class="circ1 loader-primary"></div>
										<div class="circ2 loader-primary"></div>
										<div class="circ3 loader-primary"></div>
										<div class="circ4 loader-primary"></div>
									</div>
									<div id="divListServiciosEspeciales" class="dt-responsive table-responsive">
										<table id="listaServiciosEspeciales" class="table table-striped table-bordered nowrap" style="cursor:pointer">
											<thead>
												<tr>
													<th style="padding: 2px;"></th>
													<th>Fecha</th>
													<th>Código</th>
													<th>Nombre</th>
													<th>Importe</th>
													<th>Cuota</th>
													<th>Estado</th>
													<th>Responsable</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								</div>
							</div>
								<g:link class="btn btn-inverse m-b-0" action="show" id="${cuentaId}"><g:message code="default.button.back.label" default="Volver" /></g:link>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="modal fade" id="modalServicioEspecial" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title">Adherir servicios especiales</h4>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<g:if test="${profesion == 'mercadolibre'}">
								<div class="alert alert-info icons-alert">
		                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
		                                <i class="icofont icofont-close-line-circled"></i>
		                            </button>
		                            <p><strong>Info!</strong> Esta cuenta posee descuento por comerciar con MercadoPago / MercadoLibre</p>
		                        </div>
		                    </g:if>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Servicios</label>
								<div class="col-sm-10">
									<select id="modalServicioEspecial_cbServicio" name="servicios" multiple></select>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Importe</label>
								<div class="col-sm-10">
									<div class="input-group">
										<span class="input-group-addon" id="basic-addon1">$</span>
										<input id="modalServicioEspecial_importe" name="importe" type="text" class="form-control autonumber" value="0,00" data-a-sep="" data-a-dec=",">
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Descuento</label>
								<div class="col-sm-10">
									<div class="input-group">
										<span class="input-group-addon" id="basic-addon1">%</span>
										<input id="modalServicioEspecial_descuento" type="text" class="form-control autonumber" value="0,00" data-a-sep="" data-a-dec=",">
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Comentario</label>
								<div class="col-sm-10">
									<input id="modalServicioEspecial_comentario" type="text" name="comentarioServicio" class="form-control" placeholder="Detalle sobre el/los trámites a realizar">
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Cuotas</label>
								<div class="col-sm-10">
									<div class="input-group">
										<input id="modalServicioEspecial_cuotas" name="cuotas" type="text" class="form-control" value="1" onkeypress='return isNumberKey(event)'>
									</div>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Primer pago</label>
								<div class="col-sm-10">
									<input id="modalServicioEspecial_fecha" type="text" name="fecha" class="form-control fechaDateDropper" data-format="d/m/Y" placeholder="Seleccione un día" value="${fechaHoy}">
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
							<button type="button" class="btn btn-primary waves-effect waves-light " onclick="adherirServEspecial()">Confirmar</button>
						</div>
				</div>
			</div>
		</div>
		<div class="modal fade" id="modalServicioMensual" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">Adherir servicio Mensual</h4>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<g:if test="${profesion == 'mercadolibre'}">
							<div class="alert alert-info icons-alert">
	                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
	                                <i class="icofont icofont-close-line-circled"></i>
	                            </button>
	                            <p><strong>Info!</strong> A esta cuenta se le aplicará un descuento por comerciar con MercadoPago / MercadoLibre</p>
	                        </div>
	                    </g:if>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Servicio</label>
							<div class="col-sm-10">
								<select id="modalServicioMensual_cbServicio"></select>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Fecha Alta</label>
							<div class="col-sm-10">
								<input id="modalServicioMensual_fecha" type="text" name="fecha" class="form-control fechaDateDropper" data-format="d/m/Y" placeholder="Seleccione un día" value="${fechaHoy}">
								<div id="modalServicioMensual_advertencia" class="has-warning col-form-label" style="color: #ffb41f;">La facturación mensual se realiza los días <b>${com.zifras.Estudio.get(2).diaFacturacionMensual}</b>.<br/>La fecha marcada se facturará en el mes siguiente al seleccionado.
								</div>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Debito Automático</label>
							<div class="col-sm-10">
								<label>
						            <input type="radio" name="debitoAutomatico" id="siDebito" value="true"> Si
						        </label>
						        <label>
						            <input type="radio" name="debitoAutomatico" id="noDebito" value="false"> No
						        </label>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Descuento</label>
							<div class="col-sm-10">
								<div class="input-group">
									<span class="input-group-addon" id="basic-addon1">%</span>
									<input id="modalServicioMensual_descuento" type="text" class="form-control autonumber" value="0,00" data-a-sep="" data-a-dec=",">
								</div>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Cant. Periodos</label>
							<div class="col-sm-10">
								<div class="input-group">
									<input id="modalServicioMensual_periodos" type="text" class="form-control" placeholder="Hasta nueva modificación" onkeypress='return isNumberKey(event)'>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
						<button type="button" class="btn btn-primary waves-effect waves-light " onclick="adherirServMensual()">Confirmar</button>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			var tablaServiciosEspeciales;
			var tablaServiciosMensuales;
			var importeEspecialTotal;

			$(document).ready(function () {
				$("#noDebito").prop("checked",true);
				// Servicios especiales:
					tablaServiciosEspeciales = $('#listaServiciosEspeciales').DataTable({
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
							[1, 'desc'],
							[5, 'desc']
						],
						aoColumnDefs: [{
							"aTargets": [0],
							'orderable': false,
							"mRender": function (data, type, full) {
								if (full['estado'] != "Pagado" && full['estado'] != "Reembolsado"){
									return '<i class="icofont icofont-trash" onclick="borrarServicio(' + full['id'] + ')"></i>'
								}else{
									return ""
								}
							}
						}, {
							"aTargets": [1],
							"mData": "fecha",
							'type':"date-eu"
						}, {
							"aTargets": [2],
							"mData": "codigo"
						}, {
							"aTargets": [3],
							"mData": "nombre"
						}, {
							"aTargets": [4],
							"mData": "precio",
							"sClass": "text-right"
						}, {
							"aTargets": [5],
							"mData": "cuota",
							"sClass": "text-right"
						}, {
							"aTargets": [6],
							"mRender": function (data, type, full) {
								let salida = full.estado
								if (salida == "Pendiente"){
									salida += " <a href='/servicio/adelantar/" + full.id + "'>(adelantar)</a>"
								}
								return salida
							}
						},{
							"aTargets": [7],
							"mData": "responsable"
						}],
						sPaginationType: 'simple',
						fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
							/*$(nRow).on('click', function() {
								window.location.href = "${createLink(action:'edit')}" + '/' + aData['id'];
							});*/
						}
					});
					llenarDatoslistServiciosEspeciales();
					$("#modalServicioEspecial_cbServicio").select2({
						placeholder: '<g:message code="zifras.servicio.Servicio.placeHolder" default="Ningún servicio seleccionado"/>',
						formatNoMatches: function () {
							return '<g:message code="default.no.elements" default="No hay elementos"/>';
						},
						formatSearching: function () {
							return '<g:message code="default.searching" default="Buscando..."/>';
						},
						minimumResultsForSearch: 1,
						allowClear: false,
						formatSelection: function (item) {
							return item.text;
						}
					});
					llenarCombo({
						comboId : "modalServicioEspecial_cbServicio",
						ajaxLink : '${createLink(controller:"servicio", action:"ajaxGetServiciosEspeciales")}',
						atributo : 'toString',
						idDefault: '' //Lo paso vacío porque si no se selecciona el primero
					});
					$("#modalServicioEspecial_cbServicio").change(function () {
						if ($("#modalServicioEspecial_cbServicio").val().length){
							$.ajax("${createLink(controller:'servicio', action:'ajaxGetServiciosPorId')}", {
								dataType: "json",
								data: {ids: $("#modalServicioEspecial_cbServicio").val()}
							}).done(function(servicios) {
								let sumatoria = 0;
								for (index in servicios){
									sumatoria += servicios[index].precio
								}
								$("#modalServicioEspecial_importe").val(sumatoria.toFixed(2).replace(".", ","))
								importeEspecialTotal = sumatoria;
								$("#modalServicioEspecial_importe").trigger("change");
							});
							
						}
					});

					$("#modalServicioEspecial_importe").change(function(){
						$("#modalServicioEspecial_descuento").val((100- (parseFloat($("#modalServicioEspecial_importe").val()) *100 / importeEspecialTotal)).toFixed(2).replace(".", ","));
					})
					$("#modalServicioEspecial_descuento").change(function(){
						$("#modalServicioEspecial_importe").val((importeEspecialTotal - parseFloat($("#modalServicioEspecial_descuento").val()) * importeEspecialTotal / 100).toFixed(2).replace(".",","));
					})
				// Servicios Mensuales:
					tablaServiciosMensuales = $('#listaServiciosMensuales').DataTable({
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
							[1,'desc'],
							[5, 'desc']
						],
						aoColumnDefs: [{
							"aTargets": [0],
							'orderable': false,
							"mRender": function (data, type, full) {
								return '<i class="icofont icofont-trash" onclick="borrarServicio(' + ( full['borrable'] ? full['id'] : "null") + ')"></i>'
							}
						}, {
							"aTargets": [1],
							"mData": "fechaAlta",
							'type':"date-eu"
						}, {
							"aTargets": [2],
							"mData": "fechaBaja",
							'type':"date-eu"
						}, {
							"aTargets": [3],
							"mData": "codigo",
							"sClass": "text-right"
						}, {
							"aTargets": [4],
							"mData": "nombre",
							"sClass": "text-right"
						}, {
							"aTargets": [5],
							"mData": "precio",
							"sClass": "text-right"
						}, {
							"aTargets": [6],
							"mData": "descuento"
						},{
							"aTargets": [7],
							"mData": "responsable"
						},{
							"aTargets": [8],
							"mData": "debitoAutomatico",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
						}],
						sPaginationType: 'simple',
						fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
							/*$(nRow).on('click', function() {
								window.location.href = "${createLink(action:'edit')}" + '/' + aData['id'];
							});*/
						}
					});
					llenarDatoslistServiciosMensuales();
					$("#modalServicioMensual_cbServicio").select2({
						placeholder: '<g:message code="zifras.servicio.Servicio.placeHolder" default="Ningún servicio seleccionado"/>',
						formatNoMatches: function () {
							return '<g:message code="default.no.elements" default="No hay elementos"/>';
						},
						formatSearching: function () {
							return '<g:message code="default.searching" default="Buscando..."/>';
						},
						minimumResultsForSearch: 1,
						allowClear: false,
						dropdownParent: $("#modalServicioMensual"),
						formatSelection: function (item) {
							return item.text;
						}
					});
					llenarCombo({
						comboId: "modalServicioMensual_cbServicio",
						ajaxLink: '${createLink(controller:"servicio", action:"ajaxGetServiciosMensuales")}',
						atributo: 'toString'
					});

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
			$("#modalServicioMensual_fecha").change(function(){
				const dia = parseInt(this.value.slice(0,2))
				if (dia < parseInt("${com.zifras.Estudio.get(2).diaFacturacionMensual}"))
					$("#modalServicioMensual_advertencia").hide()
				else
					$("#modalServicioMensual_advertencia").show()
			});
			$("#modalServicioMensual_fecha").trigger('change')
			function llenarDatoslistServiciosEspeciales() {
				$("#preloaderServiciosEspeciales").show()
				$("#divListServiciosEspeciales").hide()
				tablaServiciosEspeciales.clear();
				$.ajax("${createLink(controller: 'servicio', action: 'ajaxGetEspecialesDeCuenta')}", {
					dataType: "json",
					data: {
						cuentaId: '${cuentaId}'
					}
				}).done(function (data) {
					for (key in data) {
						tablaServiciosEspeciales.row.add(data[key]);
					}
					$("#preloaderServiciosEspeciales").hide()
					$("#divListServiciosEspeciales").show()
					tablaServiciosEspeciales.draw();
				});
			}

			function llenarDatoslistServiciosMensuales() {
				$("#preloaderServiciosMensuales").show()
				$("#divListServiciosMensuales").hide()
				tablaServiciosMensuales.clear();
				$.ajax("${createLink(controller: 'servicio', action: 'ajaxGetMensualesDeCuenta')}", {
					dataType: "json",
					data: {
						cuentaId: '${cuentaId}'
					}
				}).done(function (data) {
					for (key in data) {
						tablaServiciosMensuales.row.add(data[key]);
					}
					$("#preloaderServiciosMensuales").hide()
					$("#divListServiciosMensuales").show()
					tablaServiciosMensuales.draw();
				});
			}

			function adherirServEspecial() {
				$('#modalServicioEspecial').modal('hide');
				$("#preloaderServiciosEspeciales").show()
				$.ajax("${createLink(controller: 'servicio', action: 'ajaxAdherirEspecial')}", {
					dataType: "json",
					data: {
						servicios: JSON.stringify($("#modalServicioEspecial_cbServicio").val()),
						importe: leerFloat('modalServicioEspecial_importe'),
						cuotas: leerInt('modalServicioEspecial_cuotas'),
						comentarioServicio: $("#modalServicioEspecial_comentario").val(),
						fecha: $("#modalServicioEspecial_fecha").val(),
						cuentaId: "${cuentaId}"
					}
				}).done(function (respuesta) {
					$("#preloaderServiciosEspeciales").hide()
					if (respuesta.hasOwnProperty('error'))
						swal("Error", respuesta.error, "error");
					else
						llenarDatoslistServiciosEspeciales();
				});
			}

			function adherirServMensual() {
				$('#modalServicioMensual').modal('hide');
				$.ajax("${createLink(controller: 'servicio', action: 'ajaxAdherirMensual')}", {
					dataType: "json",
					data: {
						servicioId: $("#modalServicioMensual_cbServicio").val(),
						fechaAlta: $("#modalServicioMensual_fecha").val(),
						descuento: leerFloat('modalServicioMensual_descuento'),
						periodos: leerInt('modalServicioMensual_periodos'),
						debitoAutomatico: $('#siDebito').prop('checked'),
						cuentaId: "${cuentaId}"
					}
				}).done(function (respuesta) {
					if (respuesta.hasOwnProperty('error'))
						swal("Error", respuesta.error, "error");
					else{
						llenarDatoslistServiciosMensuales();
						if($('#siDebito').prop('checked') == true){
							if($("#cuentaDebitoAutomatico").val() == "false")
								swal("Atención!","Esta cuenta todavía no tiene tarjeta asociada, hay que asignarle una cuanto antes.", "warning");
							else
								swal("Servicio adherido", "Se debitará automáticamente de la tarjeta cargada en la cuenta", "success");
						}
						else{
							const mensajeSwal = respuesta.hasOwnProperty('linkPago') ? "El siguiente link de pago se envió al cliente por mail: " + respuesta.linkPago : "Se facturará el día correspondiente"
							swal("Servicio adherido", mensajeSwal, "success")
						}
					}
				});
			}

			function borrarServicio(id) {
				if (id == null){
						swal("Error", "El SM seleccionado ya fue dado de baja previamente.", "error");
					return
				}
				swal({
					title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
					text: "El servicio se desasociará de la cuenta",
					type: "warning",
					showCancelButton: true,
					confirmButtonClass: "btn-danger",
					confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, eliminar'/>",
					cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
					closeOnConfirm: true,
					closeOnCancel: true
				},
				function(isConfirm) {
					if (isConfirm) {
						window.location.href = "${createLink(controller:'servicio', action:'deleteItemServicio')}" + '/' + id
					}
				});
			}
		</script>
	</body>
</html>