<g:hiddenField name="tipoPatrimonioGananciaId" value="${tipoPatrimonioGananciaInstance?.tipoPatrimonioGananciaId}" />
<g:hiddenField name="id" value="${tipoPatrimonioGananciaInstance?.tipoPatrimonioGananciaId}" />
<g:hiddenField name="version" value="${tipoPatrimonioGananciaInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: tipoPatrimonioGananciaInstance, field: 'nombre', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Nombre</label>
	<div class="col-sm-10">
		<input name="nombre" type="text" class="form-control ${hasErrors(bean: tipoPatrimonioGananciaInstance, field: 'nombre', 'form-control-danger')}" value="${tipoPatrimonioGananciaInstance.nombre}">
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	
});
</script>