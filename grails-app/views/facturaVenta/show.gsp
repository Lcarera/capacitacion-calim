<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<g:hiddenField name="facturaVentaId" value="${facturaVentaInstance?.id}" />
<div style="display: none;">
	<div id="urlDelete">
		<g:createLink controller="facturaVenta" action="delete" />
	</div>	
	<div id="urlGetListItems">
		<g:createLink controller="facturaVenta" action="ajaxGetListItems" />
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
		                    <h4><g:message code="default.show.label" default="Mostrar {0}" args="['facturaVenta']"/></h4>
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
				<div class="col-md-12 col-xl-12 ">
					<div class="card">
						<div class="card-block user-detail-card">
							<div class="row">
								<div class="col-sm-12 user-detail">
									<g:if test="${facturaVentaInstance?.cuenta}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaVenta.cuenta.label" default="Cuenta:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaVentaInstance?.cuenta.toString()}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${facturaVentaInstance?.fecha}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaVenta.fecha.label" default="Fecha:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaVentaInstance?.fecha.toString('dd/MM/yyyy')}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${facturaVentaInstance?.cliente}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaVenta.cliente.label" default="Cliente:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaVentaInstance?.cliente.razonSocial}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${facturaVentaInstance?.tipoComprobante?.nombre}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaVenta.tipoComprobante.label" default="Tipo:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaVentaInstance?.tipoComprobante?.nombre}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${facturaVentaInstance?.concepto?.nombre}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaVenta.concepto.label" default="Concepto:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaVentaInstance?.concepto?.nombre}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${facturaVentaInstance?.numero}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaVenta.numero.label" default="Numero:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaVentaInstance?.puntoVenta.numero}-${facturaVentaInstance?.numero}</h6>
										</div>
									</div>
									</g:if>
									<div class="row">
										<div class="col-sm-12">
											<div class="table-responsive">
												<table id="listItems" class="table table-striped table-bordered nowrap" style="cursor:pointer">
													<thead>
														<tr>
															<th>Detalle</th>
															<th>Precio Unitario</th>
															<th>Cantidad</th>
															<th>Neto</th>
															<th>% IVA</th>
															<th>Total</th>
														</tr>
													</thead>
													<tbody>
													</tbody>
												</table>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaVenta.desglose.label" default="Totales de factura:" /></h6>
										</div>
										<div class="col-sm-3">
											<div class="row">
												<h6 class="m-b-30">Neto: ${formatNumber(number: facturaVentaInstance?.neto, type:'currency', currencySymbol:'$')}</h6>
											</div>
										</div>
										<div class="col-sm-3">
											<div class="row">
												<h6 class="m-b-30">Iva: ${formatNumber(number: facturaVentaInstance?.iva, type:'currency', currencySymbol:'$')}</h6>
											</div>
										</div>
										<div class="col-sm-3">
											<div class="row">
												<h6 class="m-b-30">Total: ${formatNumber(number: facturaVentaInstance?.total, type:'currency', currencySymbol:'$')}</h6>
											</div>
										</div>
									</div>
									<g:if test="${facturaVentaInstance?.bienImportado}">
									</g:if> 
									<g:else>
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaVenta.bienImportado.label" default="Bien importado:" /></h6>
										</div>
										<div class="col-sm-9">
													<h6 class="m-b-30">No, necesita revisión en alguno de sus campos.</h6>
										</div>
									</div>
									</g:else>
								</div>
							</div>
							
							<div class="row">
								<div class="col-sm-12">
									<h4 class="sub-title"></h4>
									<g:link class="btn btn-primary m-b-0" action="edit" id="${facturaVentaInstance?.id}"><g:message code="default.button.edit.label" default="Editar" /></g:link>
									<button type="button" class="btn btn-danger alert-success-cancel m-b-0" ><g:message code="default.button.delete.label" default="Eliminar" /></button>
									<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	var tablaItems;
$(document).ready(function () {
	//Success or cancel alert
	document.querySelector('.alert-success-cancel').onclick = function(){
		swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
			text: "<g:message code='zifras.facturacion.facturaVenta.delete.message' default='La facturaVenta se eliminará'/>",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.facturacion.delete.ok' default='Si, eliminar'/>",
			cancelButtonText: "<g:message code='zifras.facturacion.delete.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		},
		function(isConfirm) {
			if (isConfirm) {
				window.location.href = $('#urlDelete').text() + '/' + ${facturaVentaInstance?.id};
			}
		});
	};

	
	tablaItems = $('#listItems').DataTable({
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay items')}</a>",
			sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
			sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
			sInfoPostFix: "",
			sUrl: "",
			sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
			oPaginate: {
				"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
				"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
				"sNext":	"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
				"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
			}
		},
		//iDisplayLength: 100,
		//scrollX: true,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
						"mData": "detalle"
					},{
						"aTargets": [1],
						"mData": "precioUnitario"
					},{
						"aTargets": [2],
						"mData": "cantidad"
					},{
						"aTargets": [3],
						"mData": "neto"
					},{
						"aTargets": [4],
						"mData": "ivaNombre"
					},{
						"aTargets": [5],
						"mData": "total"
					}],
		sPaginationType: 'simple',
		sDom: "rt",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
		}
	});

	llenarDatoslistItems();
});
function llenarDatoslistItems(){
	$.ajax($('#urlGetListItems').text(), {
		dataType: "json",
		data: {
			facturaId: $('#facturaVentaId').val()
		}
	}).done(function(data) {
		for(key in data){
			tablaItems.row.add(data[key]);
		}
		tablaItems.draw();
	});
}
</script>
</body>
</html>