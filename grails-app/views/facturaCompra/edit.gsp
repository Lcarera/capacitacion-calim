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
		                    <h4><g:message code="default.edit.label" default="Editar {0}" args="['facturaCompra']"/></h4>
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
				<div class="col-sm-12">
					<!-- Basic Form Inputs card start -->
					<div class="card">
						<div class="card-block">
							<h4 class="sub-title">facturaCompra</h4>
							<g:form action="update">
								<g:render template="form"/>
								<div class="row">
									<label class="col-sm-2"></label>
									<div class="col-sm-10">
										<button type="submit" class="btn btn-primary m-b-0">Aceptar</button>
										<button type="button" class="btn btn-danger alert-success-cancel m-b-0" ><g:message code="default.button.delete.label" default="Eliminar" /></button>
										<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
									</div>
								</div>
							</g:form>
							<div class="modal fade" id="modalAgregarProveedor" tabindex="-1" role="dialog">
								<g:form name="modalForm" action="save" controller="agenda" id="${facturaCompraInstance.cuentaId}">
								<g:hiddenField name="cliente" value="false"/>
								<g:hiddenField name="proveedor" value="true"/>
								<g:hiddenField name="path" value="factura"/>
								<g:hiddenField name="condicionIvaId" value=""/>
								<g:hiddenField name="alias" value=""/>
								<div class="modal-dialog modal-lg" role="document">
									<div class="modal-content">
											<div class="modal-header">
												<h4 class="modal-title">Añadir proveedor</h4>
												<button type="button" class="close" data-dismiss="modal" aria-label="Close">
												<span aria-hidden="true">&times;</span>
												</button>
											</div>
											<div class="modal-body">
												<div class="form-group row">
													<label class="col-sm-2 col-form-label">CUIT (*)</label>
													<div class="col-sm-4">
														<input id="cuit" name="cuit" type="text" class="form-control ${hasErrors(bean: clienteProveedorInstance, field: 'cuit', 'form-control-danger')}" onkeypress='return isNumberKey(event)' value="${clienteProveedorInstance?.cuit}" maxlength="11">
													</div>
													<div class="col-sm-4" style="align-self: left;">
														<div  id="cuitNotFound" style="display:none;">
															<label style="color:red; font-size: 18px; font-weight: bold;">X </label>
															<label class="col-form-label"> &nbsp;No se encontró el CUIT </label>
														</div>
												        <div class="wrapper" style="position:relative;">
													        <div id="cuitFound" style="position:absolute; height: 15px; width:15px; display: none; margin-top: 7px;">
													        	<i class="fa fa-check" style="color:green; font-size: 18px;"></i>
													        </div>
															<div id="submitLoader" style="position:absolute; height: 15px; width:15px; display: none; margin-top:6px;">
													            <div class="double-bounce1" style="height: 15px; width:15px; margin-top:6px;"></div>
													            <div class="double-bounce2" style="height: 15px; width:15px; margin-top:6px;"></div>
													        </div>
													    </div>
													</div>
												</div>
												<div class="form-group ${hasErrors(bean: clienteProveedorInstance, field: 'razonSocial', 'has-danger')} row">
													<label class="col-sm-2 col-form-label">Razón social (*)</label>
													<div class="col-sm-10">
														<input id="razonSocial" name="razonSocial" type="text" class="form-control ${hasErrors(bean: clienteProveedorInstance, field: 'razonSocial', 'form-control-danger')}" value="${clienteProveedorInstance?.razonSocial}" readonly>
													</div>
												</div>

												<div class="form-group row">
													<label class="col-sm-2 col-form-label">Domicilio</label>
													<div class="col-sm-10">
														<input id="domicilio" name="domicilio" type="text" class="form-control ${hasErrors(bean: clienteProveedorInstance, field: 'domicilio', 'form-control-danger')}" value="${clienteProveedorInstance?.domicilio}" readonly>
													</div>
												</div>

												<div class="form-group row">
													<label class="col-sm-2 col-form-label">Email</label>
													<div class="col-sm-10">
														<input id="email" name="email" type="text" class="form-control ${hasErrors(bean: clienteProveedorInstance, field: 'email', 'form-control-danger')}" value="${clienteProveedorInstance?.email}">
													</div>
												</div>

												<div class="form-group row">
													<label class="col-sm-2 col-form-label">Nota</label>
													<div class="col-sm-10">
														<textarea class="form-control" id="nota" name="nota" rows="2" class="form-control ${hasErrors(bean: clienteProveedorInstance, field: 'nota', 'form-control-danger')}">${clienteProveedorInstance?.nota}</textarea>
													</div>
												</div>
												<br>
												<div class="form-group row">
													<label class="col-sm-2 col-form-label" style="color:grey">(*) Obligatorio</label>
												</div>
											</div>
											<div class="modal-footer">
												<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
												<button type="button" id="btnSubmitModal" name="btnSubmitModal" class="btn btn-primary waves-effect waves-light">Confirmar</button>
											</div>
										</div>
									</div>
								</g:form>
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
			text: "<g:message code='zifras.facturaCompra.delete.message' default='La Factura se eliminará'/>",
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
				window.location.href = $('#urlDelete').text() + '/' + ${facturaCompraInstance?.facturaCompraId};
			}
		});
	};
});
</script>
</body>
</html>