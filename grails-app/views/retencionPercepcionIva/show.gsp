<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlDelete">
		<g:createLink controller="retencionPercepcionIva" action="delete" />
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
							<g:if test="${retencionPercepcionInstance?.tipo == 'percepcion'}">
								<h4>Ver Percepción IVA</h4>
							</g:if>
							<g:if test="${retencionPercepcionInstance?.tipo == 'retencion'}">
								<h4>Ver Retención IVA</h4>
							</g:if>
							<g:if test="${retencionPercepcionInstance?.tipo == 'bancaria'}">
								<h4>Ver Retención Bancaria IVA</h4>
							</g:if>
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

									<g:if test="${retencionPercepcionInstance?.cuenta}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.retencionPercepcion.cuenta.label" default="Cuenta:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${retencionPercepcionInstance?.cuenta.toString()}</h6>
										</div>
									</div>
									</g:if>

									<g:if test="${retencionPercepcionInstance?.fecha}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.retencionPercepcion.fecha.label" default="Fecha:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${retencionPercepcionInstance?.fecha.toString('dd/MM/yyyy')}</h6>
										</div>
									</div>
									</g:if>

									<g:if test="${retencionPercepcionInstance?.codigo}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.retencionPercepcion.codigo.label" default="Código:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${retencionPercepcionInstance?.codigo}</h6>
										</div>
									</div>
									</g:if>

									<g:if test="${retencionPercepcionInstance?.cuit}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.retencionPercepcion.cuit.label" default="Cuit:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${retencionPercepcionInstance?.cuit}</h6>
										</div>
									</div>
									</g:if>

									<g:if test="${retencionPercepcionInstance?.comprobante}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.retencionPercepcion.comprobante.label" default="Comprobante:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${retencionPercepcionInstance?.comprobante}</h6>
										</div>
									</div>
									</g:if>

									<g:if test="${retencionPercepcionInstance?.facturaParteA}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.retencionPercepcion.facturaParteA.label" default="Factura:" /></h6>
										</div>
										<div class="col-sm-9">
											<g:if test="${retencionPercepcionInstance?.letraComprobante}">
												<h6 class="m-b-30">${retencionPercepcionInstance?.tipoComprobante}${retencionPercepcionInstance?.letraComprobante}  ${retencionPercepcionInstance?.facturaParteA} - ${retencionPercepcionInstance?.facturaParteB}</h6>
											</g:if>
											<g:else>
												<h6 class="m-b-30">${retencionPercepcionInstance?.facturaParteA} - ${retencionPercepcionInstance?.facturaParteB}</h6>
											</g:else>
										</div>
									</div>
									</g:if>

									<g:if test="${retencionPercepcionInstance?.cbu}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.retencionPercepcion.cbu.label" default="Información Bancaria:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${retencionPercepcionInstance?.tipoCuenta} - CBU: ${retencionPercepcionInstance?.cbu}</h6>
										</div>
									</div>
									</g:if>

									<g:if test="${retencionPercepcionInstance?.monto}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.retencionPercepcion.monto.label" default="Monto:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${formatNumber(number: retencionPercepcionInstance?.monto, , type:'currency', currencySymbol:'$')}</h6>
										</div>
									</div>
									</g:if>

									<g:if test="${retencionPercepcionInstance?.montoBase}">
									<div class="row">
										<div class="col-sm-3">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.retencionPercepcion.montoBase.label" default="Monto Base:" /></h6>
										</div>
										<div class="col-sm-9">
											<h6 class="m-b-30">${formatNumber(number: retencionPercepcionInstance?.montoBase, , type:'currency', currencySymbol:'$')}</h6>
										</div>
									</div>
									</g:if>
								</div>
							</div>
							
							<div class="row">
								<div class="col-sm-12">
									<h4 class="sub-title"></h4>
									<g:link class="btn btn-primary m-b-0" action="edit" id="${retencionPercepcionInstance?.id}"><g:message code="default.button.edit.label" default="Editar" /></g:link>
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
			text: "<g:message code='zifras.liquidacion.retencionPercepcion.delete.message' default='La retención o percepción se eliminará'/>",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.liquidacion.delete.ok' default='Sí, eliminar'/>",
			cancelButtonText: "<g:message code='zifras.liquidacion.delete.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		},
		function(isConfirm) {
			if (isConfirm) {
				window.location.href = $('#urlDelete').text() + '/' + ${retencionPercepcionInstance?.id};
			}
		});
	};
});
</script>
</body>
</html>