<g:hiddenField name="montoConceptoDeducibleGananciaId" value="${montoConceptoDeducibleGananciaInstance?.montoConceptoDeducibleGananciaId}" />
<g:hiddenField name="id" value="${montoConceptoDeducibleGananciaInstance?.montoConceptoDeducibleGananciaId}" />
<g:hiddenField name="version" value="${montoConceptoDeducibleGananciaInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: montoConceptoDeducibleGananciaInstance, field: 'ano', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Año</label>
	<div class="col-sm-10">
		<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${montoConceptoDeducibleGananciaInstance.ano}"/>
	</div>
</div>
<div class="form-group ${hasErrors(bean: montoConceptoDeducibleGananciaInstance, field: 'concepto', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Concepto</label>
	<div class="col-sm-10">
		<select id="concepto" name="concepto" class="form-control">
		</select>
	</div>
</div>
<div class="form-group ${hasErrors(bean: montoConceptoDeducibleGananciaInstance, field: 'valor', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Valor</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="valor" name="valor" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${montoConceptoDeducibleGananciaInstance?.valor}">
		</div>
	</div>
</div>

<script type="text/javascript">
var conceptos = [{
	id:0,
	text: 'Conyuge'
},{
	id:1,
	text: 'Hijo/a'
},{
	id:2,
	text: 'Ganancia no imponible'
},{
	id:3,
	text: 'Deduccion especial'
}];

$(document).ready(function () {
	/*** Tipo de pariente ***/
	$("#concepto").select2({
		placeholder: '<g:message code="zifras.Localidad.placeHolder" default="Seleccione un concepto"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		data: conceptos
	});
	$("#concepto").val(${montoConceptoDeducibleGananciaInstance?.concepto.toString()}).trigger("change");

	if($("#create").val()=="false"){
		$("#ano").attr("readonly", true);
		toggleReadOnlyCombo('concepto');
	}else{
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
	}
});
</script>