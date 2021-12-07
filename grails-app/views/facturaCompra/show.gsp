<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlDelete">
		<g:createLink controller="facturaCompra" action="delete" />
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
		                    <h4><g:message code="default.show.label" default="Mostrar {0}" args="['facturaCompra']"/></h4>
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
									<g:if test="${facturaCompraInstance?.cuenta}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.cuenta.label" default="Cuenta:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaCompraInstance?.cuenta.toString()}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${facturaCompraInstance?.fecha}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.fecha.label" default="Fecha:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaCompraInstance?.fecha.toString('dd/MM/yyyy')}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${facturaCompraInstance?.proveedor}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.proveedor.label" default="Proveedor:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaCompraInstance?.proveedor.razonSocial}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${facturaCompraInstance?.tipoComprobante?.nombre}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.tipoComprobante.label" default="Tipo:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaCompraInstance?.tipoComprobante?.nombre}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${facturaCompraInstance?.numero}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.numero.label" default="Numero:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${facturaCompraInstance?.puntoVenta}-${facturaCompraInstance?.numero}</h6>
										</div>
									</div>
									</g:if>
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.netoGravado.label" default="Neto Gravado:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.netoGravado, type:'currency', currencySymbol:'$')}</h6>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-2">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.netoGravado21.label" default="21%:" /></h6>
										</div>
										<div class="col-sm-2">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.netoGravado21, type:'currency', currencySymbol:'$')}</h6>
										</div>
										<div class="col-sm-2">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.netoGravado10.label" default="10.5%:" /></h6>
										</div>
										<div class="col-sm-2">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.netoGravado10, type:'currency', currencySymbol:'$')}</h6>
										</div>
										<div class="col-sm-2">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.netoGravado27.label" default="27%:" /></h6>
										</div>
										<div class="col-sm-2">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.netoGravado27, type:'currency', currencySymbol:'$')}</h6>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.netoNoGravado.label" default="Neto No Gravado:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.netoNoGravado, type:'currency', currencySymbol:'$')}</h6>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.exento.label" default="Exento:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.exento, type:'currency', currencySymbol:'$')}</h6>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.iva.label" default="Iva Total:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.iva, type:'currency', currencySymbol:'$')}</h6>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-2">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.iva21.label" default="Iva 21%:" /></h6>
										</div>
										<div class="col-sm-2">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.iva21, type:'currency', currencySymbol:'$')}</h6>
										</div>
										<div class="col-sm-2">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.iva10.label" default="Iva 10.5%:" /></h6>
										</div>
										<div class="col-sm-2">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.iva10, type:'currency', currencySymbol:'$')}</h6>
										</div>
										<div class="col-sm-2">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.iva27.label" default="Iva 27%:" /></h6>
										</div>
										<div class="col-sm-2">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.iva27, type:'currency', currencySymbol:'$')}</h6>
										</div>
									</div>
									<g:if test="${facturaCompraInstance?.total}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.total.label" default="Total:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${formatNumber(number: facturaCompraInstance?.total, type:'currency', currencySymbol:'$')}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${facturaCompraInstance?.bienImportado}">
									</g:if> 
									<g:else>
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.facturacion.facturaCompra.bienImportado.label" default="Bien importado:" /></h6>
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
									<g:link class="btn btn-primary m-b-0" action="edit" id="${facturaCompraInstance?.id}"><g:message code="default.button.edit.label" default="Editar" /></g:link>
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
$(document).ready(function () {
	//Success or cancel alert
	document.querySelector('.alert-success-cancel').onclick = function(){
		swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
			text: "<g:message code='zifras.facturacion.facturaCompra.delete.message' default='La facturaCompra se eliminará'/>",
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
				window.location.href = $('#urlDelete').text() + '/' + ${facturaCompraInstance?.id};
			}
		});
	};
});
</script>
</body>
</html>