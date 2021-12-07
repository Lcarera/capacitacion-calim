<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>
<body>
<div class="main-body">
	<div class="page-wrapper">
	
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="page-header-title">
					<div class="d-inline">
	                    <h4>Factura de Venta</h4>
					</div>
				</div>
			</div>
		</div>
		<div class="page-body">
			<div class="row">
				<div class="col-sm-12">
					<div class="card">
						<div class="card-block">
							<g:form action="save">
								<g:render template="form"/>
								<div class="row">
									<div class="col-sm-1"></div>
									<div class="col-sm-8">
										<button id="botonAceptar" type="submit" class="btn btn-primary m-b-0">Aceptar</button>
										<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
									</div>
								</div>
							</g:form>
							<div class="modal fade" id="modalCliente" tabindex="-1" role="dialog">
								<g:form name="modalForm" action="save" controller="agenda" id="${cuentaId}">
								<g:hiddenField name="cliente" value="true"/>
								<g:hiddenField name="proveedor" value="false"/>
								<g:hiddenField name="path" value="factura"/>
								<g:hiddenField name="condicionIvaId" value=""/>
								<g:hiddenField name="alias" value="${clienteProveedorInstance?.alias}"/>
								<div class="modal-dialog modal-lg" role="document">
									<div class="modal-content">
											<div class="modal-header">
												<h4 class="modal-title">Añadir cliente</h4>
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
</div>
</body>
</html>
