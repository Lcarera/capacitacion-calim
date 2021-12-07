<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlDelete">
		<g:createLink controller="reciboSueldo" action="delete" />
	</div>	
	<div id="urlDownloadRecibo">
		<g:createLink controller="reciboSueldo" action="download" />
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
		                    <h4><g:message code= "def" default="Mostrar {0} / Periodo: {1} - {2}" args="['Recibos de Sueldo', ano, mes]"/></h4>
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
									<g:if test="${localInstance?.cuenta.id}">
									<div class="row">
										<div class="col-sm-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.cuenta.Local.label" default="Cuenta" /></h6>
										</div>
										<div class="col-sm-7">
											<h6 class="m-b-30">${localInstance?.cuenta.toString()}</h6>
										</div>
									</div>
									</g:if>
								</div>
							</div>

							<div class="row">
								<div class="col-sm-12 user-detail">
									<g:if test="${localInstance}">
									<div class="row">
										<div class="col-sm-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.cuenta.Local.descripcion.label" default="Local" /></h6>
										</div>
										<div class="col-sm-7">
											<h6 class="m-b-30">${localInstance?.toString()}</h6>
										</div>
									</div>
									</g:if>
								</div>
							</div>

							<div class="row">
								<div class="col-sm-12 user-detail">
									<g:if test="${localInstance}">
									<div class="row">
										<div class="col-sm-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.cuenta.Local.cantidadEmpleados.label" default="Cantidad Empleados" /></h6>
										</div>
										<div class="col-sm-7">
											<h6 class="m-b-30">${localInstance?.cantidadEmpleados}</h6>
										</div>
									</div>
									</g:if>
								</div>
							</div>

							<div class="row">
								<div class="col-sm-12 user-detail">
									<g:if test="${localInstance}">
									<div class="row">
										<div class="col-sm-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.documento.DeclaracionJurada.nombreArchivo.label" default="Cantidad Recibos Cargados" /></h6>
										</div>
										<div class="col-sm-7">
											<h6 class="m-b-30">${cantidadRecibosCargados}</h6>
										</div>
									</div>
									</g:if>
								</div>
							</div>
							<br>
							<g:each status= "i" in="${recibosDelMes}" var="recibo">
								<div class="form-group row">
									<label class="col-sm-2 col-form-label">Recibo de Sueldo ${i+1} :</label>
									<div class="col-sm-10">
										<div class="input-group" onclick="">
											<span class="btn btn-primary" onclick="downloadRecibo(${recibo.id})">${recibo.nombreArchivo} <i class="icofont icofont-download-alt"></i> </span>
										</div>
									</div>
								</div>
							</g:each>

							<div class="row">
								<div class="col-sm-12">
									<h4 class="sub-title"></h4>
									<g:if test="${localInstance.recibosSueldo.size()>0}">
									<button type="button" class="btn btn-danger alert-success-cancel m-b-0" ><g:message code="a" default="Eliminar Recibos" /></button>
									</g:if>
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
			text: "<g:message code='zifras.documento.ReciboSueldo.delete.message' default='Se eliminaran los recibos del local'/>",
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
				window.location.href = $('#urlDelete').text() + '/' + ${localInstance.id};
			}
		});
	};
});
function downloadRecibo(id){
	window.location.href = $('#urlDownloadRecibo').text() + '/' + id;
}
</script>
</body>
</html>