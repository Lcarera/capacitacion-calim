<g:hiddenField name="rangoImpuestoGananciaId" value="${rangoImpuestoGananciaInstance?.rangoImpuestoGananciaId}" />
<g:hiddenField name="id" value="${rangoImpuestoGananciaInstance?.rangoImpuestoGananciaId}" />
<g:hiddenField name="version" value="${rangoImpuestoGananciaInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: rangoImpuestoGananciaInstance, field: 'ano', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Año</label>
	<div class="col-sm-10">
		<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${rangoImpuestoGananciaInstance.ano}"/>
	</div>
</div>
<div class="form-group ${hasErrors(bean: rangoImpuestoGananciaInstance, field: 'desde', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Desde</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="desde" name="desde" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${rangoImpuestoGananciaInstance?.desde}">
		</div>
	</div>
</div>
<div class="form-group ${hasErrors(bean: rangoImpuestoGananciaInstance, field: 'hasta', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Hasta</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="hasta" name="hasta" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${rangoImpuestoGananciaInstance?.hasta}">
		</div>
	</div>
</div>
<div class="form-group ${hasErrors(bean: rangoImpuestoGananciaInstance, field: 'fijo', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Fijo</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="fijo" name="fijo" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${rangoImpuestoGananciaInstance?.fijo}">
		</div>
	</div>
</div>
<div class="form-group ${hasErrors(bean: rangoImpuestoGananciaInstance, field: 'porcentaje', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Porcentaje</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">%</span>
			<input id="porcentaje" name="porcentaje" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${rangoImpuestoGananciaInstance?.porcentaje}">
		</div>
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	$("#ano").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "Y",
		minYear: 2010,
		maxYear: 2040,
		lang: "es"
    });
});
</script>