<g:hiddenField name="provinciaId" value="${provinciaInstance?.provinciaId}" />
<g:hiddenField name="id" value="${provinciaInstance?.provinciaId}" />
<g:hiddenField name="version" value="${provinciaInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: provinciaInstance, field: 'nombre', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Nombre</label>
	<div class="col-sm-10">
		<input name="nombre" type="text" class="form-control ${hasErrors(bean: provinciaInstance, field: 'nombre', 'form-control-danger')}" value="${provinciaInstance.nombre}">
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	
});
</script>