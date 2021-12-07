<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
	<div class="theme-loader" id="loaderGrande" style="display:none">
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
<div style="display: none;">
	<div id="urlGetComprobantes">
		<g:createLink controller="comprobante" action="ajaxGetComprobantesPorCuenta" />
	</div>
	<div id="urlDescargarComprobante">
		<g:createLink controller="comprobante" action="descargarComprobante" />
	</div>
	<div id="createFacturaVenta">
		<g:createLink controller="FacturaVentaUsuario" action="create" />
	</div>
	<div id="urlGetFacturasCuentaList">
		<g:createLink controller="miCuenta" action="ajaxGetFacturasPorCuenta" />
	</div>
	<div id="urlDescargarFacturaCuenta">
		<g:createLink controller="facturaCuenta" action="bajarPdf" />
	</div>
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-sm-6">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras" default="Constancias"/></h4>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->

		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listComprobantes" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Tipo</th>
									<th>Fecha</th>
									<th>Archivo</th>
								</tr>
							</thead>
						</table>
					</div>
				</div>
				<!-- Statistics and revenue End -->
			</div>
		</div>

		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-sm-6">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras" default="Facturas Calim"/></h4>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listFacturasCuenta" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Fecha</th>
									<th>Descripcion</th>
									<th>Importe</th>
									<th>Avisos</th>
									<th>Pagada</th>
									<th>Archivo</th>
									<th>Responsable</th>
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
var tablaFacturaCuenta;

	jQuery(document).ready(function() {
		tabla = $('#listComprobantes').DataTable({
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "<i class='ti-search'></i>",
				sLengthMenu: "_MENU_",
				sZeroRecords: "${message(code: 'zifras.Comprobante.list.agregar', default: 'No se registran constancias')}</a>",
				sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
				sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
				sInfoPostFix: "",
				sUrl: "",
				sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
				oPaginate: {
					"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
					"sPrevious":"<",
					"sNext":	">",
					"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
				}
			},
			aaSorting: [
				[0, 'asc']
			],
			aoColumnDefs: [{
						"aTargets": [0],
						"mData": "tipo"
					}, {
						"aTargets": [1],
						"mData": "fecha",
						"type": "date-eu"
					},{
						"aTargets": [2],
						"mData": "nombreArchivo",
						"mRender": function (data, type, full) {
							if (full['tipoArchivo'] == "pdf") {
								return '<i class="icofont icofont-file-pdf"></i>' + '   ' + data
							}
							else {
								if (full['tipoArchivo'] == "doc") {
									return '<i class="icofont-file-word"></i>' + '   ' + data
								}
								else {
									return '<i class="icofont icofont-file-text"></i>' + '   ' + data
								}
							}
						}
					}],
       		sPaginationType: 'simple',
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				$(nRow).on('click', function() {
					window.location.href = $('#urlDescargarComprobante').text() + '/' + aData['id'];
				});
			},
			dom:"<'row'<'col-xs-12 col-sm-12 col-md-12'f>><'row'<'col-xs-12 col-sm-12'tr>><'row datatable-paginado'<'d-inline datatable-desde-hasta'i><'d-inline'p>>"
		});

		llenarDatoslistComprobantes();

		tablaFacturaCuenta = $('#listFacturasCuenta').DataTable({
					"ordering": true,
					"searching": true,
					oLanguage: {
						sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
						sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
						sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
						sZeroRecords: "${message(code: 'zifras.documento.FacturaCuenta.list.agregar', default: 'No hay Facturas de Cuentas')}</a>",
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
						[0, 'desc'],
						[4, 'desc']
					],
					aoColumnDefs: [{
						"aTargets": [0],
						"mData": "fecha",
						"type": "date-eu"
					}, {
						"aTargets": [1],
						"mData": "descripcion"
					}, {
						"aTargets": [2],
						"mData": "importe",
						"sClass": "text-right"
					},{
						"aTargets": [3],
						"mData": "cantidadAvisos"
					},{
						"aTargets": [4],
						"mData": "pagadaCheck"
					},{
						"aTargets": [5],
						"mData": "nombreArchivo",
						"mRender": function (data, type, full) {
							if (full['tipoArchivo'] == "pdf") {
								return '<i class="icofont icofont-file-pdf"></i>' + '   ' + data
							}
							else {
								if (full['tipoArchivo'] == "doc") {
									return '<i class="icofont-file-word"></i>' + '   ' + data
								}
								else {
									return '<i class="icofont icofont-file-text"></i>' + '   ' + data
								}
							}
						}
					},{
						"aTargets": [6],
						"mData": "responsable"
					}],
					sPaginationType: 'simple',
					fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
						// Row click
						$(nRow).on('click', function () {
							if(aData['pagadaCheck'] != '-'){
								$('#loaderGrande').show()
								window.location.href = $('#urlDescargarFacturaCuenta').text() + '/' + aData['id'];
							}else{
								swal("Atencion","Esta factura todavía no ha sido pagada","warning");
							}
						});
					}
				});

				llenarDatoslistFacturasCuenta();

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
			llenarDatoslistComprobantes();
		});

		$("#mes").change(function () {
			llenarDatoslistComprobantes();
		});

		$("#modalPuntoVenta_puntoVenta").select2({
			placeholder: '<g:message code="zifras.facturacion.PuntoVenta.placeHolder" default="Seleccione un punto de venta"/>',
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
	});

	function llenarDatoslistComprobantes(){
		tabla.clear()
		$.ajax($('#urlGetComprobantes').text(), {
			dataType: "json",
			data: {
				cuentaId: "${cuentaId}"
			}
		}).done(function(data) {
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
		});
	}

	function llenarDatoslistFacturasCuenta() {
		tablaFacturaCuenta.clear().draw();
		$.ajax($('#urlGetFacturasCuentaList').text(), {
			dataType: "json",
			data: {
				id: "${cuentaId}"
			}
		}).done(function (data) {
			for (key in data) {
				tablaFacturaCuenta.row.add(data[key]);
			}
			tablaFacturaCuenta.draw();
		});
	}

	function createFacturaVenta(){
		window.location.href = $("#createFacturaVenta").text()
	}

	function showModalPuntoVenta(){
		$.ajax("${createLink(controller: 'puntoVenta', action:'obtenerDeAfip')}", {
			dataType: "json",
			data: {cuentaId:"${cuentaId}"}
		}).done(function(data) {
			if (data.length){
				if(data.length == 1){
					window.location.href = $("#createFacturaVenta").text() + "?puntoVenta=" + data['numero']
				}
				$("#modalPuntoVenta_puntoVenta").children('option').remove();
				let primero = true
				for (var i = data.length - 1; i >= 0; i--) {
					$("#modalPuntoVenta_puntoVenta").append(new Option(data[i], data[i], primero, primero));
					primero = false
				}
				$("#modalPuntoVenta").modal('show')
			}
			else
				swal("No pueden generarse facturas","No de detectaron puntos de venta autorizados","error")
		});
	}
</script>
</body>
</html>