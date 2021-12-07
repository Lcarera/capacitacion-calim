<g:hiddenField name="zonaId" value="${zonaInstance?.zonaId}" />
<g:hiddenField name="id" value="${zonaInstance?.zonaId}" />
<g:hiddenField name="version" value="${zonaInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: zonaInstance, field: 'nombre', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Nombre</label>
	<div class="col-sm-10">
		<input name="nombre" type="text" class="form-control ${hasErrors(bean: zonaInstance, field: 'nombre', 'form-control-danger')}" value="${zonaInstance.nombre}">
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	
});
</script>