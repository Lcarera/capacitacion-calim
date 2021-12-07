<g:hiddenField name="mensajeId" value="${mensajeInstance?.mensajeId}" />
<g:hiddenField name="id" value="${mensajeInstance?.mensajeId}" />
<g:hiddenField name="version" value="${mensajeInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: mensajeInstance, field: 'asunto', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Asunto</label>
	<div class="col-sm-10">
		<input name="asunto" type="text" class="form-control ${hasErrors(bean: mensajeInstance, field: 'asunto', 'form-control-danger')}" value="${mensajeInstance?.asunto}">
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Mensaje</label>
	<div class="col-sm-10">
		<textarea class="form-control" id="mensaje" name="mensaje" rows="4" class="form-control ${hasErrors(bean: mensajeInstance, field: 'mensajeInstance', 'form-control-danger')}">${mensajeInstance?.mensaje}</textarea>
	</div>
</div>




