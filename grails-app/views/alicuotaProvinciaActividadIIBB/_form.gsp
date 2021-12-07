<g:hiddenField name="alicuotaProvinciaActividadIIBBId" value="${alicuotaProvinciaActividadIIBBInstance?.alicuotaProvinciaActividadIIBBId}" />
<g:hiddenField name="id" value="${alicuotaProvinciaActividadIIBBInstance?.alicuotaProvinciaActividadIIBBId}" />
<g:hiddenField name="version" value="${alicuotaProvinciaActividadIIBBInstance?.version}" />

<div style="display: none;">
	<div id="urlGetProvincias">
		<g:createLink controller="provincia" action="ajaxGetProvincias" />
	</div>
	<div id="urlGetActividades">
		<g:createLink controller="actividad" action="ajaxGetActividades" />
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Provincia</label>
	<div class="col-sm-10">
		<select id="cbProvincia" name="provinciaId" class="form-control"></select>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Actividad</label>
	<div class="col-sm-10">
		<select id="cbActividad" name="actividadId" class="form-control"></select>
	</div>
</div>

<div class="form-group ${hasErrors(bean: alicuotaProvinciaActividadIIBBInstance, field: 'valor', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Valor</label>
	<div class="col-sm-10">
		<input class="form-control autonumber ${hasErrors(bean: alicuotaProvinciaActividadIIBBInstance, field: 'valor', 'form-control-danger')}"  data-a-sep="" data-a-dec="," type="text" name="valor" value="${alicuotaProvinciaActividadIIBBInstance?.valor}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: alicuotaProvinciaActividadIIBBInstance, field: 'ano', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Año</label>
	<div class="col-sm-10">		
		<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${alicuotaProvinciaActividadIIBBInstance.ano}"/>
	</div>
</div>

<div class="form-group ${hasErrors(bean: alicuotaProvinciaActividadIIBBInstance, field: 'baseImponibleDesde', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Base imponible desde</label>
	<div class="col-sm-10">
		<input class="form-control autonumber ${hasErrors(bean: alicuotaProvinciaActividadIIBBInstance, field: 'baseImponibleDesde', 'form-control-danger')}"  data-a-sep="" data-a-dec="," type="text" name="baseImponibleDesde" value="${alicuotaProvinciaActividadIIBBInstance?.baseImponibleDesde}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: alicuotaProvinciaActividadIIBBInstance, field: 'baseImponibleHasta', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Base imponible hasta</label>
	<div class="col-sm-10">
		<input class="form-control autonumber ${hasErrors(bean: alicuotaProvinciaActividadIIBBInstance, field: 'baseImponibleHasta', 'form-control-danger')}"  data-a-sep="" data-a-dec="," type="text" name="baseImponibleHasta" value="${alicuotaProvinciaActividadIIBBInstance?.baseImponibleHasta}">
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	var actionName = "${actionName}";

	/*** PROVINCIAS ***/
	$("#cbProvincia").select2({
		placeholder: '<g:message code="zifras.provincia.Provincia.placeHolder" default="Seleccione una provincia"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: 1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbProvincia",
		ajaxUrlDiv : 'urlGetProvincias',
		idDefault : '${alicuotaProvinciaActividadIIBBInstance?.provinciaId}',
		readOnly : (actionName == "edit")
	});


	/*** ACTIVIDADES ***/
	$("#cbActividad").select2({
		placeholder: '<g:message code="zifras.actividad.Actividad.placeHolder" default="Seleccione una actividad"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: 1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbActividad",
		ajaxUrlDiv : 'urlGetActividades',
		idDefault : '${alicuotaProvinciaActividadIIBBInstance?.actividadId}',
		atributo : 'toString',
		readOnly : (actionName == "edit")
	});

	$("#ano").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "Y",
		minYear: 2015,
		maxYear: 2040,
		lang: "es"
    });

});
</script>