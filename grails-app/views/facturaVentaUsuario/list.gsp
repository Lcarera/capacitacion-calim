<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlGetFacturasVenta">
		<g:createLink controller="FacturaVenta" action="ajaxGetFacturasVenta" />
	</div>
	<div id="urlDescargarFacturaPDF">
		<g:createLink controller="FacturaVentaUsuario" action="bajarPdf" />
	</div>
	<div id="createFacturaVenta">
		<g:createLink controller="FacturaVentaUsuario" action="create" />
	</div>
	<div id="urlGetFacturasCompra">
		<g:createLink controller="FacturaCompra" action="ajaxGetFacturasCompra" />
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
		                    <h4><g:message code="zifras" default="Facturas de venta"/></h4>
						</div>
					</div>
				</div>
				<div class="col-sm-6 filtro-busqueda">
					<div style="" class="d-inline">
						<input id="mes" name="mes" style="width:90px;text-align:center;" class="form-control d-inline" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
						<input id="ano" name="ano" style="width:90px;text-align:center;margin-left:10px;" class="form-control d-inline" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
						<button class="btn btn-success" onclick="createFacturaVenta()">Nueva Factura de Venta</button>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->

		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listFacturasVenta" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th style="padding: 2px;"></th>
									<th>Fecha</th>
									<th>Cliente</th>
									<th>Tipo</th>
									<th>Numero</th>
									<th>Neto</th>
									<th>Iva</th>
									<th>Total</th>
									<th>CAE</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Statistics and revenue End -->
			</div>
			<g:if test="${condicionIva == 'Responsable inscripto'}">
				<div class="page-header card">
					<div class="row align-items-end">
						<div class="col-sm-6">
							<div class="page-header-title">
								<div class="d-inline">
				                    <h4 style="margin-bottom: 40px"><g:message code="zifras" default="Facturas de compra"/></h4>
								</div>
							</div>
						</div>
						<div class="col-sm-6 filtro-busqueda">
							<div style="" class="d-inline">
								<input id="mesCompra" name="mesCompra" style="width:90px;text-align:center;" class="form-control d-inline" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
								<input id="anoCompra" name="anoCompra" style="width:90px;text-align:center;margin-left:10px;" class="form-control d-inline" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
								<button class="btn btn-success" onclick="createFacturaCompra()">Nueva Factura de Compra</button>
							</div>
						</div>
					</div>
				</div>
				<div class="card">
					<div class="card-block ">
						<div class="dt-responsive table-responsive">
							<table id="listFacturasCompra" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Fecha</th>
									<th>Proveedor</th>
									<th>Tipo</th>
									<th>Numero</th>
									<th>Neto</th>
									<th>Iva</th>
									<th>Total</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
						</div>
					</div>
					<!-- Statistics and revenue End -->
				</div>
			</g:if>

			<div class="modal fade" id="modalPuntoVenta" tabindex="-1" role="dialog">
				<div class="modal-dialog modal-lg" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title">Elegir Punto de Venta</h4>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Punto de venta</label>
								<div class="col-sm-10">
									<select id="modalPuntoVenta_puntoVenta" class="form-control"></select>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Cancelar</button>
							<button type="button" class="btn btn-primary waves-effect waves-light" onclick="
								const url = '${raw(createLink(action:'create', params:['puntoVenta': 'VARIABLE']))}'
								window.location.href = url.replace('VARIABLE', $('#modalPuntoVenta_puntoVenta').val())
							">Siguiente</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var tabla;
var tablaFacturasCompra;

	jQuery(document).ready(function() {
		tabla = $('#listFacturasVenta').DataTable({
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "<i class='ti-search'></i>",
				sLengthMenu: "_MENU_",
				sZeroRecords: "${message(code: 'zifras.FacturaVenta.list.agregar', default: 'No se registran facturas de venta para el mes seleccionado')}</a>",
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
							'orderable': false,
							"mRender": function (data, type, full) {
								if (full['estado'] != "Pagado" && !full['esFacturaCancelada'] && !full['esNotaDeCredito']){
									return '<i class="icofont icofont-trash"></i>'
								}else{
									return ""
								}
							}
						}, {
			       			"aTargets": [1],
			       			"mData": "fecha",
			       			"type": "date-eu",
			       			"mRender": function (data, type, full) {
								if (full['esFacturaCancelada']){
									return '<strike>'+full['fecha']+'</strike>'
								}else{
									return full['fecha']
								}
							}
			       		},{
			       			"aTargets": [2],
			       			"mData": "personaNombre",
			       			"mRender": function (data, type, full) {
								if (full['esFacturaCancelada']){
									return '<strike>'+full['personaNombre']+'</strike>'
								}else{
									return full['personaNombre']
								}
							}
						},{
			       			"aTargets": [3],
			       			"mData": "tipoComprobante",
			       			"mRender": function (data, type, full) {
								if (full['esFacturaCancelada']){
									return '<strike>'+full['tipoComprobante']+'</strike>'
								}else{
									return full['tipoComprobante']
								}
							}
						},{
			       			"aTargets": [4],
			       			"mData": "numeroFactura"
						},{
			       			"aTargets": [5],
			       			"mData": "neto",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [6],
			       			"mData": "iva",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [7],
			       			"mData": "total",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [8],
			       			"mData": "cae"
						}],

       		sPaginationType: 'simple',
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				if(aData['advertencia']!=''){
	   	   			$(nRow).css({"background-color":"red","color":"white"});
	   	   	   	}
				$(nRow).on('click', function() {
					//window.location.href = $('#urlDescargarFacturaPDF').text() + '/' + aData['id'];
				});
			},
			dom:"<'row'<'col-xs-12 col-sm-12 col-md-12'f>><'row'<'col-xs-12 col-sm-12'tr>><'row datatable-paginado'<'d-inline datatable-desde-hasta'i><'d-inline'p>>"
		});

		llenarDatoslistFacturasVenta();

		tablaFacturasCompra = $('#listFacturasCompra').DataTable({
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "<i class='ti-search'></i>",
				sLengthMenu: "_MENU_",
				sZeroRecords: "${message(code: 'zifras.FacturaCompra.list.agregar', default: 'No se registran facturas de compra para el mes seleccionado')}</a>",
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
			       			"mData": "fecha",
			       			"type": "date-eu"
			       		},{
			       			"aTargets": [1],
			       			"mData": "personaNombre"
						},{
			       			"aTargets": [2],
			       			"mData": "tipoComprobante"
						},{
			       			"aTargets": [3],
			       			"mData": "numeroFactura"
						},{
			       			"aTargets": [4],
			       			"mData": "neto",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [5],
			       			"mData": "iva",
			       			"sClass" : "text-right"
						},{
			       			"aTargets": [6],
			       			"mData": "total",
			       			"sClass" : "text-right"
						}],

       		sPaginationType: 'simple',
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				if(aData['advertencia']!=''){
	   	   			$(nRow).css({"background-color":"red","color":"white"});
	   	   	   	}
				$(nRow).on('click', function() {
					// window.location.href = $('#urlShow').text() + '/' + aData['id'];
				});
			},
			dom:"<'row'<'col-xs-12 col-sm-12 col-md-12'f>><'row'<'col-xs-12 col-sm-12'tr>><'row datatable-paginado'<'d-inline datatable-desde-hasta'i><'d-inline'p>>"
		});

		llenarDatoslistFacturasCompra();

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

		$("#mesCompra").dateDropper( {
	        dropWidth: 200,
	        dropPrimaryColor: "#1abc9c", 
	        dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "m",
			lang: "es"
	    });

		$("#anoCompra").dateDropper( {
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
			llenarDatoslistFacturasVenta();
		});

		$("#mes").change(function () {
			llenarDatoslistFacturasVenta();
		});

		$("#anoCompra").change(function () {
			llenarDatoslistFacturasCompra();
		});

		$("#mesCompra").change(function () {
			llenarDatoslistFacturasCompra();
		});

		$('#listFacturasVenta').on('click', 'tbody td', function() {
				var celdaSeleccionadaData = tabla.row(this).data();
				var filaSeleccionada = tabla.row(this).index();
				var columna = this.cellIndex;
				var esCancelar = columna == 0;
				if(!esCancelar)
					window.location.href = $('#urlDescargarFacturaPDF').text() + '/' + tabla.row(this).data()['id'];
				else
					if(!tabla.row(this).data()['esFacturaCancelada'] && !tabla.row(this).data()['esNotaDeCredito'])
						cancelarFactura(tabla.row(this).data()['id'])
		})			

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

	function llenarDatoslistFacturasVenta(){
		tabla.clear()
		$.ajax($('#urlGetFacturasVenta').text(), {
			dataType: "json",
			data: {
				ano: $("#ano").val(),
				cuentaId: "${cuentaId}",
				mes: $("#mes").val()
			}
		}).done(function(data) {
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
		});
	}

	function llenarDatoslistFacturasCompra(){
		tablaFacturasCompra.clear()
		$.ajax($('#urlGetFacturasCompra').text(), {
			dataType: "json",
			data: {
				ano: $("#ano").val(),
				cuentaId: "${cuentaId}",
				mes: $("#mes").val()
			}
		}).done(function(data) {
			for(key in data){
				tablaFacturasCompra.row.add(data[key]);
			}
			tablaFacturasCompra.draw();
		});
	}

	function createFacturaVenta(){
		window.location.href = $("#createFacturaVenta").text()
	}

	function createFacturaCompra(){
		var urlBase = "${raw(createLink(controller:'facturaCompraUsuario', action:'create', params:[cuentaId:'var']))}"
		urlBase = urlBase.replace('var', "${cuentaId}");
			
		window.location.href = urlBase
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

	function cancelarFactura(id) {
				if (id == null){
						swal("Error", "La factuar seleccionada ya fue cancelada previamente.", "error");
					return
				}
				swal({
					title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
					text: "Se generará una nota de crédito para cancelar la factura seleccionada.",
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
						var url = "${createLink(controller:'facturaVentaUsuario', action:'cancelarFactura', params:[facturaId:'var',mobile:false])}";
						url = url.replace('var',id);
						window.location.href = url;

					}
				});
			}
</script>
</body>
</html>