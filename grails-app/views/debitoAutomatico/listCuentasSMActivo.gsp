<!DOCTYPE html>

<html lang="en">
	<head>
		<meta name="layout" content="main">
	</head>
	<body>
		<div style="display: none">
			<div id="urlGetCuentasSMActivo">
				<g:createLink controller="cuenta" action="ajaxGetCuentasSMActivo"/>
			</div>
			<div id="urlCuentaShow">
				<g:createLink controller="cuenta" action="show" />
			</div>
		</div>
		<div class="main-body">
			<div class="page-wrapper">
				<div class="page-header card">
					<div class="row align-items-end">
						<div class="col-lg-8">
							<div class="page-header-title">
								<div class="d-inline">
									<h4>Cuentas con SM activo</h4>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="page-body">
					<div class="row">
						<div class="col-md-12 col-xl-12 ">
							<div class="card">
								<div class="card-block">
									<div id="preloader" class="preloader3" style="display:none;">
										<div class="circ1 loader-primary"></div>
										<div class="circ2 loader-primary"></div>
										<div class="circ3 loader-primary"></div>
										<div class="circ4 loader-primary"></div>
									</div>
									<div id="divListCuentas" class="dt-responsive table-responsive">
										<table id="listaCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
											<thead>
												<tr>
													<th>ID</th>
													<th>CUIT</th>
													<th>Razon Social</th>
													<th>Email</th>
													<th>Tarjeta</th>
													<th>SM Debito Automatico</th>
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
				<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
			</div>
		</div>

		<div class="modal fade" id="modalTarjeta" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">Ingresar Tarjeta</h4>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div id="divTarjeta">
							<div class="form-group row">
								<label class="col-sm-3 col-form-label">Cuenta Id</label>
								<div class="col-sm-9">
									<input id="modalIdCuenta" name="modlIdCuenta" type="text" class="form-control" readonly>
								</div>
							</div>
					        <div class="form-group row">
								<label class="col-sm-3 col-form-label">Nº Tarjeta Crédito</label>
								<div class="col-sm-9">
									<input id="modalNumeroTarjeta" name="modalNumeroTarjeta" type="text" class="form-control" maxlength="16">
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button id="buttonVolverTarjeta" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
						<button id="buttonVerCuenta" type="button" class="btn btn-primary waves-effect waves-light " onclick="verCuenta();">Ver cuenta</button>
						<button id="buttonIngresarTarjeta" type="button" class="btn btn-success waves-effect waves-light " onclick="ingresarTarjeta();">Aceptar</button>
					</div>
				</div>
			</div>
		</div>
		
						
		<script type="text/javascript">
			var tablaCuentas;

			$(document).ready(function () {
			
					tablaCuentas = $('#listaCuentas').DataTable({
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
							[1,'desc']
						],
						aoColumnDefs: [{
							"aTargets": [0],
							"mData":"id"
						}, {
							"aTargets": [1],
							"mData": "cuit",
							'sClass': 'bold'
						}, {
							"aTargets": [2],
							"mData": "razonSocial"
						}, {
							"aTargets": [3],
							"mData": "email"
						},{
							"aTargets": [4],
							"mData": "tarjeta",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
				   	    },{
							"aTargets": [5],
							"mData": "debito",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
						}],
						sPaginationType: 'simple',
						fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
							$(nRow).on('click', function() {
								$("#modalTarjeta").modal('show');
								$("#modalIdCuenta").val(aData['id']);
								$("#modalNumeroTarjeta").val(aData['tarjeta']);
							});
						}
					});
					llenarDatoslistCuentas();
					});
				function llenarDatoslistCuentas(){
					tablaCuentas.clear().draw();
					$("#preloader").show();
					$.ajax($('#urlGetCuentasSMActivo').text(), {
						dataType: "json",
						data: {
						}
					}).done(function(data) {
						$("#preloader").hide();
						for(key in data){
							tablaCuentas.row.add(data[key]);
						}
						tablaCuentas.draw();
					});
				}
		function ingresarTarjeta(){
			$.ajax('${createLink(controller:"debitoAutomatico",action:"ajaxCargarTarjeta")}', {
				dataType: "json",
				data: {
					cuentaId: $("#modalIdCuenta").val(),
					numeroTarjeta: $("#modalNumeroTarjeta").val(),
					tarjetaCredito: $('#credito').is(':checked')
				}
			}).done(function(data) {
				if(data.error)
					swal("Hay un problema con la tarjeta ingresada",data.error,"error");
				else{
					swal({
						title: "Exito!",
						text: "Tarjeta guardada correctamente",
						type: "success",
						showCancelButton: false,
						confirmButtonClass: "btn-primary",
						confirmButtonText: "<g:message code='zifras.autorizar.ok' default='Siguiente'/>",
						closeOnConfirm: true
					},
					function(isConfirm) {
						$("#modalTarjeta").modal("hide");
						$("#modalNumeroTarjeta").val("");
						llenarDatoslistCuentas();
					});
				}
			});
		}

		function verCuenta(){
			let cuentaId = $("#modalIdCuenta").val();
			window.open(
				$("#urlCuentaShow").text() + "/"+cuentaId,
				"_blank"
			)
		}

		</script>
	</body>
</html>