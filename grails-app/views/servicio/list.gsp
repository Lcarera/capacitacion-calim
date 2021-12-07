<!DOCTYPE html>
<html lang="en">
	<head>
		<meta name="layout" content="main">
	</head>
	<body>
		<div class="main-body">
			<div class="page-wrapper">
				<!-- Page-header start -->
				<div class="page-header card">
					<div class="row align-items-end">
						<div class="col-lg-7">
							<div class="page-header-title">
								<div class="d-inline">
									<h4>Servicios</h4>
								</div>
							</div>
						</div>
						<div class="col-lg-5">
							<div class="card-header-right" style="text-align:right;">
								<g:link action="create" class="btn btn-success">
									<g:message code="default.add.label" default="Agregar {0}" args="['Servicio']"/>
								</g:link>
							</div>
						</div>
					</div>
				</div>
				<div class="page-body">
					<div class="card">
						<div class="card-block ">
							<div class="dt-responsive table-responsive">
								<table id="lista" class="table table-striped table-bordered nowrap" style="cursor:pointer">
									<thead>
										<tr>
											<th>Código</th>
											<th>Subcódigo</th>
											<th>Nombre</th>
											<th>Último Precio</th>
											<th>Último Precio + IVA</th>
											<th>Mensual</th>
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
		<script type="text/javascript">
			var tabla;
			jQuery(document).ready(function() {
				tabla = $('#lista').DataTable({
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
							"sFirst":"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
							"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
							"sNext":"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
							"sLast":"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
						}
					},
					aaSorting: [
						[5, 'desc'],
						[0, 'asc'],
						[1, 'asc'],
						[4, 'desc']
					],
					aoColumnDefs: [{
									"aTargets": [0],
									"mData": "codigo",
									'sClass': 'bold'
								},{
									"aTargets": [1],
									"mData": "subcodigo"
								},{
									"aTargets": [2],
									"mData": "nombre"
								},{
									"aTargets": [3],
									"mData": "precioNetoString",
									"sClass" : "text-right"
								},{
									"aTargets": [4],
									"mData": "precioString",
									"sClass" : "text-right"
								},{
									"aTargets": [5],
									"mData": "mensualCheck"
								}],
					buttons: [
								$.extend(true, {}, {
									exportOptions: {
										columns: [0, 1, 2, 3, 4, 5],
										format: {
											body: function (data, row, column, node) {
												if (column == 5){
													if (tabla.row(node).data().mensualCheck != "-")
														return "Sí"
													else
														return "No"
												}
												data = $('<p>' + data + '</p>').text();
												const dataNumerica = data.replace(/\./g, '').replace(/\$/g, '').replace(',', '.');
												return $.isNumeric(dataNumerica) ? dataNumerica : data;
											}
										}
									}
								}, {
									extend: 'excelHtml5',
									title: function () {
										return "Servicios";
									}
								}),
								{
									extend: 'pdfHtml5',
									orientation: 'landscape',
									title: function () {
										return "Servicios";
									}
								},
								{
									extend: 'copyHtml5'
								}
							],
       		sPaginationType: 'simple',
       		sDom: "Bflrtip",
					fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
						// Row click
						$(nRow).on('click', function() {
							window.location.href = "${createLink(action:'edit')}" + '/' + aData['id'];
						});
					}
				});
				$.ajax("${createLink(action: 'ajaxGetList')}", {
					dataType: "json",
					data: {
					}
				}).done(function(data) {
					for(key in data){
						tabla.row.add(data[key]);
					}
					tabla.draw();
				});
			});
		</script>
	</body>
</html>