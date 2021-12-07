<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlDelete">
		<g:createLink controller="declaracionJurada" action="delete" />
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
		                    <h4><g:message code="default.show.label" default="Mostrar {0}" args="['Declaracion Jurada']"/></h4>
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
				<div class="col-md-12 col-xl-8 ">
					<div class="card">
						<div class="card-block user-detail-card">
							<div class="row">
								<div class="col-sm-12 user-detail">
									<g:if test="${declaracionJuradaInstance?.cuentaId}">
									<div class="row">
										<div class="col-sm-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.documento.DeclaracionJurada.cuenta.label" default="Cuenta" /></h6>
										</div>
										<div class="col-sm-7">
											<h6 class="m-b-30">${declaracionJuradaInstance?.cuentaId}</h6>
										</div>
									</div>
									</g:if>
								</div>
							</div>

							<div class="row">
								<div class="col-sm-12 user-detail">
									<g:if test="${declaracionJuradaInstance?.fecha}">
									<div class="row">
										<div class="col-sm-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.documento.DeclaracionJurada.fecha.label" default="Fecha de Pago" /></h6>
										</div>
										<div class="col-sm-7">
											<h6 class="m-b-30">${declaracionJuradaInstance?.fecha}</h6>
										</div>
									</div>
									</g:if>
								</div>
							</div>

							<div class="row">
								<div class="col-sm-12 user-detail">
									<g:if test="${declaracionJuradaInstance?.descripcion}">
									<div class="row">
										<div class="col-sm-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.documento.DeclaracionJurada.descripcion.label" default="Descripcion" /></h6>
										</div>
										<div class="col-sm-7">
											<h6 class="m-b-30">${declaracionJuradaInstance?.descripcion}</h6>
										</div>
									</div>
									</g:if>
								</div>
							</div>

							<div class="row">
								<div class="col-sm-12 user-detail">
									<g:if test="${declaracionJuradaInstance?.nombreArchivo}">
									<div class="row">
										<div class="col-sm-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.documento.DeclaracionJurada.nombreArchivo.label" default="Archivo" /></h6>
										</div>
										<div class="col-sm-7">
											<h6 class="m-b-30">${declaracionJuradaInstance?.nombreArchivo}</h6>
										</div>
									</div>
									</g:if>
								</div>
							</div>

							<div class="row">
								<div class="col-sm-12">
									<h4 class="sub-title"></h4>
									<g:link class="btn btn-primary m-b-0" action="edit" id="${actividadInstance?.id}"><g:message code="default.button.edit.label" default="Editar" /></g:link>
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
			text: "<g:message code='zifras.documento.DeclaracionJurada.delete.message' default='La declaración se eliminará'/>",
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
				window.location.href = $('#urlDelete').text() + '/' + ${declaracionJuradaInstance?.id};
			}
		});
	};
});
</script>
</body>
</html>