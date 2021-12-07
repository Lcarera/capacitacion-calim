<g:hiddenField name="regimenIibbId" value="${regimenIibbInstance?.regimenIibbId}" />
<g:hiddenField name="id" value="${regimenIibbInstance?.regimenIibbId}" />
<g:hiddenField name="version" value="${regimenIibbInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: regimenIibbInstance, field: 'nombre', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Nombre</label>
	<div class="col-sm-10">
		<input name="nombre" type="text" class="form-control ${hasErrors(bean: regimenIibbInstance, field: 'nombre', 'form-control-danger')}" value="${regimenIibbInstance.nombre}">
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	
});
</script>