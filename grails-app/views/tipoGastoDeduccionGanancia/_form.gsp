<g:hiddenField name="tipoGastoDeduccionGananciaId" value="${tipoGastoDeduccionGananciaInstance?.tipoGastoDeduccionGananciaId}" />
<g:hiddenField name="id" value="${tipoGastoDeduccionGananciaInstance?.tipoGastoDeduccionGananciaId}" />
<g:hiddenField name="version" value="${tipoGastoDeduccionGananciaInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: tipoGastoDeduccionGananciaInstance, field: 'nombre', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Nombre</label>
	<div class="col-sm-10">
		<input name="nombre" type="text" class="form-control ${hasErrors(bean: tipoGastoDeduccionGananciaInstance, field: 'nombre', 'form-control-danger')}" value="${tipoGastoDeduccionGananciaInstance.nombre}">
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	
});
</script>