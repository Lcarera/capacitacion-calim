<g:hiddenField name="tipoComprobanteId" value="${tipoComprobanteInstance?.tipoComprobanteId}" />
<g:hiddenField name="id" value="${tipoComprobanteInstance?.tipoComprobanteId}" />
<g:hiddenField name="version" value="${tipoComprobanteInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: tipoComprobanteInstance, field: 'nombre', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Nombre</label>
	<div class="col-sm-10">
		<input name="nombre" type="text" class="form-control ${hasErrors(bean: tipoComprobanteInstance, field: 'nombre', 'form-control-danger')}" value="${tipoComprobanteInstance.nombre}">
	</div>
</div><div class="form-group ${hasErrors(bean: tipoComprobanteInstance, field: 'codigoAfip', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Código AFIP</label>
	<div class="col-sm-10">
		<input name="codigoAfip" type="text" class="form-control ${hasErrors(bean: tipoComprobanteInstance, field: 'codigoAfip', 'form-control-danger')}" value="${tipoComprobanteInstance.codigoAfip}">
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	
});
</script>