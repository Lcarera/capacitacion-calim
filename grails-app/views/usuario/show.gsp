<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/morris.js/0.5.1/morris.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/morris.js/0.5.1/morris.min.js"></script>
</head>

<body>
<g:hiddenField name="usuarioId" id="usuarioId" value="${usuarioId}"/>
<%@ page import="com.zifras.Estudio" %>
<div style="display: none;">
	<div id="urlDelete">
		<g:createLink controller="usuario" action="delete" />
	</div>	
	<div id="urlResetPassword">
		<g:createLink controller="usuario" action="resetPassword" />
	</div>
	<div id="urlGetDiasExtra">
		<g:createLink controller="vendedor" action="ajaxGetListaDiasExtra" />
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
		                    <h4><g:message code="user.show.label" default="Perfil de Usuario"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<!-- Page body start -->
		<div class="page-body">
			<div class="row">
				<!-- Sho Map Start -->
				<div class="col-md-12">
					<div class="card">
						<div class="card-block user-detail-card">
							<div class="row">
								<div class="col-sm-12 user-detail">

									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.cuenta.Usuario.email.label" default="Email" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${usuarioInstance?.username}</h6>
										</div>
									</div>

									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.cuenta.Usuario.rol.label" default="Rol" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${usuarioInstance?.authorities.first()}</h6>
										</div>
									</div>

									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.cuenta.Usuario.estudio.label" default="Estudio" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${Estudio.get(usuarioInstance?.userTenantId.toString())}</h6>
										</div>
									</div>

									<g:if test="${usuarioInstance?.cuenta}">
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30"><g:message code="zifras.cuenta.Usuario.cuenta.label" default="Cuenta:" /></h6>
											</div>
											<div class="col-sm-9">
												<h6 class="m-b-30">${usuarioInstance?.cuenta.toString()}</h6>
											</div>
										</div>
									</g:if>

									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.cuenta.Usuario.enabled.label" default="Habilitado" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${(usuarioInstance?.enabled) ? "Sí." : "No."}</h6>
										</div>
									</div>


								</div>
							</div>
							
							<div class="row">
								<div class="col-sm-12">
									<h4 class="sub-title"></h4>
									
									<g:if test="${usuarioInstance?.id == session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id}"> 
										<!-- Este botón solamente aparece para tu propio usuario -->
										<g:link class="btn btn-primary m-b-0" action="cambiarTenant"><g:message code="user.changeTenant.label" default="Cambiar de Estudio" /></g:link>
									</g:if>
									<sec:ifAnyGranted roles="ROLE_ADMIN">
										<g:link class="btn btn-primary m-b-0" action="edit" id="${usuarioInstance?.id}"><g:message code="default.button.edit.label" default="Editar" /></g:link>

										<g:if test="${! usuarioInstance.passwordExpired}"> 
											<button type="button" class="btn btn-primary m-b-0" onclick="${usuarioInstance?.id == session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id} ? $('#modalPassword').modal('show') : cambiarPasswordAjeno();"><g:message code="user.resetPassword.label" default="Resetear contraseña" /></button>
										</g:if>

										<g:else> 
											<!-- Este botón NO aparecerá para tu propio usuario -->
											<button type="button" class="btn btn-danger alert-success-cancel m-b-0" ><g:message code="default.button.delete.label" default="Eliminar" /></button>
										</g:else>
									</sec:ifAnyGranted>
									<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
								</div>
							</div>
						</div>
					</div>
				<sec:ifAnyGranted roles="ROLE_VENTAS">
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

					<div class="card">
						<div id="preloaderComisiones" class="preloader3">
							<h4 style="color: #4680ff;margin-right: 20px;margin-bottom: 25px;" class="h4-loader">Cargando comisiones</h4>
							<br/>
							<div class="circ1 loader-primary"></div>
							<div class="circ2 loader-primary"></div>
							<div class="circ3 loader-primary"></div>
							<div class="circ4 loader-primary"></div>
						</div>
						<div id="divListComisiones" style="display:none;" class="card-block user-detail-card">
							<div class="row">
								<h4 style="margin-left:15px">Venta de servicios</h4>
								<div class="col-md-2">
									<div style="text-align:right;">
										<input id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
									</div>
								</div>
								<div class="col-md-2">
									<div style="text-align:right;">
										<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
									</div>
								</div>
							</div>
							<br>
							<br>
							<br>
							<div class="row">
								<div class="col-md-6">
									<div style="width:100%; text-align:center; font-size:18px;">Especiales</div>
									<div id="donut_se">
										
									</div>
								</div>
								<div class="col-md-6">
									<div style="width:100%; text-align:center; font-size:18px;">Mensuales</div>
									<div id="donut_sm">
									</div>
								</div>
							</div>
							<br>
							<br>
							<div class="dt-responsive table-responsive">
								<div id="preloader" class="preloader3" style="display:none;">
	    							<div class="circ1 loader-primary"></div>
	    							<div class="circ2 loader-primary"></div>
	    							<div class="circ3 loader-primary"></div>
	    							<div class="circ4 loader-primary"></div>
	    						</div>
								<table id="listVentas" class="table table-striped table-bordered nowrap" style="cursor:default;">
									<thead>
										<tr>
											<th>Emitida</th>
											<th>Pagada</th>
											<th>Importe</th>
											<th>Comisión</th>
											<th>Detalle</th>
											<th>Cliente</th>
										</tr>
									</thead>
									<tbody>
									</tbody>
									<tfoot>
									    <tr>
									        <th colspan="2"></th>
									        <th id="totalVendedor"></th>
									       	<th id="comisionVendedor"></th>
									        <th colspan="2"></th>
									    </tr>
									</tfoot>
								</table>
							</div>
						</div>
					</div>
					<div class="card">
						<div class="card-block user-detail-card">
							<h4>Progreso mensual</h4>
							</br>
							<canvas id="chartProgresoMensual" width="200" height="100"></canvas>
						</div>
					</div>
				</sec:ifAnyGranted>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalPassword" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Cambiar contraseña</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">
				<div class="card-block">
					<div id="divBtnContrasena" class="row">
						<div class="col-md-5 col-lg-4">
							<h6 id="contrasenaLabel" class="f-w-400 m-b-30">Contraseña</h6>
						</div>
						<div class="col-md-7 col-lg-8">
							<input id="contrasenaAnterior" type="password" class="form-control">
						</div>
					</div>

					<div class="row">
						<div class="col-md-5 col-lg-4">
							<h6 class="f-w-400 m-b-30">Nueva contraseña</h6>
						</div>
						<div class="col-md-7 col-lg-8">
							<input id="contrasenaNueva1" type="password" class="form-control">
						</div>
					</div>

					<div class="row">
						<div class="col-md-5 col-lg-4">
							<h6 class="f-w-400 m-b-30">Nueva contraseña (repetir)</h6>
						</div>
						<div class="col-md-7 col-lg-8">
							<input id="contrasenaNueva2" type="password" class="form-control">
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Cancelar</button>
				<button type="button" class="btn btn-primary waves-effect waves-light " onclick="savePassword();">Aceptar</button>
			</div>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
<script type="text/javascript">
$(document).ready(function () {
	var periodoAnual;
	var tablaDiasExtra;

	$.ajax("${createLink(controller:'panelEstadistico', action:'ajaxGetPeriodoAnual')}", {
		dataType: "json",
		data: {
		},
		success: function (data) {
		console.log(data)
		periodoAnual = data;
		}
	});

	var tablaVentas = $('#listVentas').DataTable({
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
				"oSearch": {"sSearch": " "},
				//scrollX: true,
				aaSorting: [
					[0, 'desc']
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
							return "Ventas" + " ${mes} ${ano}";
						}
					}),
					{
						extend: 'pdfHtml5',
						orientation: 'landscape',
						title: function () {
							return "Ventas" + " ${mes} ${ano}";
						}
					},
					{
						extend: 'copyHtml5'
					}
				],
				sPaginationType: 'simple',
				sDom: "lfBrtip"
			});

	$.ajax("${createLink(controller:'panelEstadistico', action:'ajaxGetDatosVendedor')}", {
				dataType: "json",
				data: {
					mes: "${mes}",
					ano: "${ano}"
				}
			}).done(function (data) {
				$("#preloaderComisiones").hide();
				$("#divListComisiones").show();
				let dataVendedor
				let index = 0;
				const cantidadTotalSE = data.cantSEVendidos + data.cantSENoCobrados + data.cantSEReembolsados
				const cantidadTotalSM = data.cantSMVendidos + data.cantSMNoCobrados + data.cantSMReembolsados

				$("#totalVendedor").text("$" + data.total);
				$("#comisionVendedor").text("$" + data.comision);
				tablaVentas.rows.add(data.ventas).draw()
				Morris.Donut({
					element: 'donut_se',
					colors: [
						'#33cc33',
						'#ccff99',
						'#FF0000'
					],
					data: [{
							label: "Vendidos",
							value: data.cantSEVendidos
						},
						{
							label: "No cobrados",
							value: data.cantSENoCobrados
						},
						{
							label: "Reembolsados",
							value: data.cantSEReembolsados
						}
					],
					formatter: function (valor) {
						return "" + valor + "/" + cantidadTotalSE + " (" + (100 * valor / cantidadTotalSE).toFixed(2) + "%)"
					}
				});

				Morris.Donut({
					element: 'donut_sm',
					colors: [
						'#0088ff',
						'#99ccff',
						'#FF0000'
					],
					data: [{
							label: "Vendidos",
							value: data.cantSMVendidos
						},
						{
							label: "No cobrados",
							value: data.cantSMNoCobrados
						},
						{
							label: "Reembolsados",
							value: data.cantSMReembolsados
						}
					],
					formatter: function (valor) {
						return "" + valor + "/" + cantidadTotalSM + " (" + (100 * valor / cantidadTotalSM).toFixed(2) + "%)"
					}
				});

			var ctx = document.getElementById('chartProgresoMensual').getContext('2d');
				var chartProgresoMensual = new Chart(ctx, {
				    type: 'bar',
				    data: {
				        labels: periodoAnual,
				        datasets: [{
				        	label: 'SE Vendidos',
				            data: data.ventasMesesSE,
				            backgroundColor: 'rgba(51, 204, 51, 0.4)',
				            borderColor: 'rgba(51, 204, 51, 1)',
				            borderWidth: 2
				        },
				        {
				        	label: 'SE Enviados',
				            data: data.enviadosMesesSE,
				            backgroundColor: 'rgba(51, 204, 51, 0.1)',
				            borderColor: 'rgba(51, 204, 51, 0.3)',
				            borderWidth: 2,
				            hidden: true
				        },
				        {
				        	label: 'SM Vendidos',
				            data: data.ventasMesesSM,
				            backgroundColor: 'rgba(0, 136, 255, 0.4)',
				            borderColor: 'rgba(0, 136, 255, 1)',
				            borderWidth: 2
				        },
				        {
				        	label: 'SM Enviados',
				            data: data.enviadosMesesSM,
				            backgroundColor: 'rgba(0, 136, 255, 0.1)',
				            borderColor: 'rgba(0, 136, 255, 0.3)',
				            borderWidth: 2,
				            hidden: true
				        }]
				    },
				    options: {
				        scales: {
				            yAxes: [{
				                ticks: {
				                    beginAtZero: true,
				                    min:0,
				                    callback: function(value, index, values) {
						                if (Math.floor(value) === value) {
						                    return value;
						                }
						            }
				                }
				            }]
				        }
				    }
				});
			});

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
					$(nRow).on('click', function() {
						asignarDiaExtra(aData['id']);
					});
				}
			});

		llenarDatoslistDiasExtra();

	//Success or cancel alert
	document.querySelector('.alert-success-cancel').onclick = function(){
		swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
			text: "<g:message code='zifras.cuenta.Usuario.delete.message' default='El usuario se eliminará'/>",
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
				window.location.href = $('#urlDelete').text() + '/' + ${usuarioInstance?.id};
			}
		});
	};
function llenarDatoslistDiasExtra(){
	tablaDiasExtra.clear().draw();
		$("#preloader").show();
		$.ajax($('#urlGetDiasExtra').text(), {
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

});

function cambiarFecha() {
	$("#loaderGrande").show()
	const base = "${raw(createLink(controller: 'usuario', action:'show', params:[id:'varid',mes:'varmes', ano:'varano']))}"
	window.location.href = base.replace('varmes', $("#mes").val()).replace('varano', $("#ano").val()).replace('varid',$("#usuarioId").val())
}

function cambiarPasswordAjeno(){
	swal({
		title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
		text: "<g:message code='zifras.cuenta.Usuario.resetPassword.message' default='El usuario deberá volver a generar su contraseña'/>",
		type: "warning",
		showCancelButton: true,
		confirmButtonClass: "btn-danger",
		confirmButtonText: "<g:message code='zifras.resetPassword.ok' default='Si, resetear'/>",
		cancelButtonText: "<g:message code='zifras.resetPassword.cancel' default='No, cancelar'/>",
		closeOnConfirm: true,
		closeOnCancel: true
	},
	function(isConfirm) {
		if (isConfirm) {
			window.location.href = $('#urlResetPassword').text() + '/' + ${usuarioInstance?.id};
		}
	});
}



function savePassword(){
	$.ajax({
		url : "${ createLink(action:'ajaxUpdatePassword') }",
		data : {
			'password' : $('#contrasenaNueva1').val(),
			'password2' : $('#contrasenaNueva2').val(),
			'passwordViejo' : $('#contrasenaAnterior').val(),
			'userId' : "${usuarioInstance?.id}"
		},
		success : function(resultado){
			if (resultado.hasOwnProperty('error'))
				swal("Error", resultado.error, "error");
			else{
				swal("Contraseña modificada", null, "success");
				$('#modalPassword').modal('hide');
			}
		}
	});
}
</script>
</body>
</html>