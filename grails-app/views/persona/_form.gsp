<g:hiddenField name="personaId" value="${personaInstance?.personaId}" />
<g:hiddenField name="id" value="${personaInstance?.personaId}" />
<g:hiddenField name="version" value="${personaInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: personaInstance, field: 'razonSocial', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Razón social</label>
	<div class="col-sm-10">
		<input name="razonSocial" type="text" class="form-control ${hasErrors(bean: personaInstance, field: 'razonSocial', 'form-control-danger')}" value="${personaInstance?.razonSocial}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Tipo de documento</label>
	<div class="col-sm-4">
		<input name="tipoDocumento" type="text" class="form-control ${hasErrors(bean: personaInstance, field: 'tipoDocumento', 'form-control-danger')}" value="${personaInstance?.tipoDocumento}">
	</div>
	<label class="col-sm-2 col-form-label">Número</label>
	<div class="col-sm-4">
		<input id="cuit" name="cuit" type="text" class="form-control ${hasErrors(bean: personaInstance, field: 'cuit', 'form-control-danger')}" onkeypress='return isNumberKey(event)' value="${personaInstance?.cuit}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Domicilio</label>
	<div class="col-sm-10">
		<input id="domicilio" name="domicilio" type="text" class="form-control ${hasErrors(bean: proveedorInstance, field: 'domicilio', 'form-control-danger')}" on value="${proveedorInstance?.domicilio}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Email</label>
	<div class="col-sm-10">
		<input id="email" name="email" type="text" class="form-control ${hasErrors(bean: proveedorInstance, field: 'email', 'form-control-danger')}" on value="${proveedorInstance?.email}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Alias</label>
	<div class="col-sm-10">
		<input id="alias" name="alias" type="text" class="form-control ${hasErrors(bean: proveedorInstance, field: 'alias', 'form-control-danger')}" on value="${proveedorInstance?.alias}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Tipo</label>
	<div class="col-sm-10">
		<input type="radio" name="tipo" value="cliente"> Cliente
 		<input type="radio" name="tipo" value="proveedor"> Proveedor
	</div>
</div>