<!DOCTYPE html>

<html lang="en">
	<head>
		<meta name="layout" content="main">
	</head>
	<body>
		<div style="display: none">
			<div id="urlGetCuentasSinTarjeta">
				<g:createLink controller="debitoAutomatico" action="ajaxGetCuentasSinTarjeta"/>
			</div>
		</div>
		<div class="main-body">
			<div class="page-wrapper">
				<div class="page-header card">
					<div class="row align-items-end">
						<div class="col-lg-8">
							<div class="page-header-title">
								<div class="d-inline">
									<h4>Cuentas sin tarjeta</h4>
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
						}],
						sPaginationType: 'simple',
						fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
							$(nRow).on('click', function() {
								window.location.href = "${createLink(controller:'cuenta',action:'edit')}" + '/' + aData['id'];
							});
						}
					});
					llenarDatoslistCuentas();
					});
				function llenarDatoslistCuentas(){
					tablaCuentas.clear().draw();
					$("#preloader").show();
					$.ajax($('#urlGetCuentasSinTarjeta').text(), {
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

		</script>
	</body>
</html>