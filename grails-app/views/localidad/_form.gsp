<g:hiddenField name="localidadId" value="${localidadInstance?.localidadId}" />
<g:hiddenField name="id" value="${localidadInstance?.localidadId}" />
<g:hiddenField name="version" value="${localidadInstance?.version}" />

<div style="display: none;">
	<div id="urlGetProvincias">
		<g:createLink controller="provincia" action="ajaxGetProvincias" />
	</div>
	<div id="urlGetProvincia">
		<g:createLink controller="provincia" action="ajaxGetProvincia" />
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Provincia</label>
	<div class="col-sm-10">
		<select id="cbProvincia" name="provinciaId" class="form-control"></select>
	</div>
</div>
				
<div class="form-group ${hasErrors(bean: localidadInstance, field: 'nombre', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Nombre</label>
	<div class="col-sm-10">
		<input name="nombre" type="text" class="form-control ${hasErrors(bean: localidadInstance, field: 'nombre', 'form-control-danger')}" value="${localidadInstance.nombre}">
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	var actionName = "${actionName}";
	
	/*** PROVINCIAS ***/
	$("#cbProvincia").select2({
		placeholder: '<g:message code="zifras.Provincia.placeHolder" default="Seleccione una provincia"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId: "cbProvincia",
		ajaxUrlDiv: 'urlGetProvincias',
		idDefault: '${localidadInstance?.provinciaId.toString()}',
		readOnly: (actionName == "edit")
	});
});
</script>