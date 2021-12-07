<g:hiddenField name="servicioId" value="${servicioInstance?.servicioId}" />
<g:hiddenField name="version" value="${servicioInstance?.version}" />

<div class="form-group ${hasErrors(bean: servicioInstance, field: 'codigo', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Código</label>
	<div class="col-sm-10">
		<input name="codigo" type="text" class="form-control ${hasErrors(bean: servicioInstance, field: 'codigo', 'form-control-danger')}" value="${servicioInstance.codigo}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: servicioInstance, field: 'subcodigo', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Subcódigo</label>
	<div class="col-sm-10">
		<input name="subcodigo" type="text" class="form-control ${hasErrors(bean: servicioInstance, field: 'subcodigo', 'form-control-danger')}" value="${servicioInstance.subcodigo}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: servicioInstance, field: 'nombre', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Nombre</label>
	<div class="col-sm-10">
		<input name="nombre" type="text" class="form-control ${hasErrors(bean: servicioInstance, field: 'nombre', 'form-control-danger')}" value="${servicioInstance.nombre}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: servicioInstance, field: 'precio', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Precio Neto</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon">$</span>
			<input id="precioNeto" type="text" class="form-control autonumber ${hasErrors(bean: servicioInstance, field: 'precio', 'form-control-danger')}" value="0" data-a-sep="" data-a-dec=",">
		</div>
	</div>
</div>

<div class="form-group ${hasErrors(bean: servicioInstance, field: 'alicuotaId', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Alicuota IVA</label>
	<div class="col-sm-10">
		<select id="cbAlicuota" name="alicuotaId"></select>
	</div>
</div>

<div class="form-group ${hasErrors(bean: servicioInstance, field: 'precio', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Precio Final</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon">$</span>
			<input name="precio" id="precio" type="text" class="form-control autonumber ${hasErrors(bean: servicioInstance, field: 'precio', 'form-control-danger')}" value="${servicioInstance?.precio ?: '0,00'}" data-a-sep="" data-a-dec=",">
		</div>
	</div>
</div>

<div class="form-group ${hasErrors(bean: servicioInstance, field: 'mensual', 'has-danger')} row">
	<label class="col-sm-2 col-form-label"> </label>
	<div class="col-sm-10">
		<div class="checkbox-fade fade-in-primary">
			<label class="check-task">
				<input name="mensual" type="checkbox"  ${servicioInstance?.mensual ? 'checked' : ''}>
				<span class="cr">
					<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
				</span>
				<span>Mensual</span>
			</label>
		</div>
	</div>
</div>

<script type="text/javascript">
	var valorIva;
	$(document).ready(function () {
		/*** CBO ALICUOTA ***/
		$("#cbAlicuota").select2({
			placeholder: '<g:message code="zifras.facturacion.AlicuotaIva.placeHolder" default="Seleccione la alicuota del Item"/>',
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
			comboId : "cbAlicuota",
			ajaxLink : '${createLink(controller: "facturaVenta", action: "ajaxGetAlicuotas")}',
			atributo : 'caption',
			idDefault : '${servicioInstance?.alicuotaId ?: 49025}'
		});
		$("#cbAlicuota").change(function(){
			$.ajax('${createLink(controller: "facturaVenta", action: "ajaxGetAlicuota")}', {
				dataType: "json",
				data: {
					id: $("#cbAlicuota").val()
				}
			}).done(function(data) {
				valorIva = data.valor / 100;
				$("#precio").trigger('change');
			});
		});
		$("#precio").change(function(){
			const neto = Math.round(100 * leerFloat("precio") / (1 + valorIva)) / 100;
			$("#precioNeto").val(neto.toFixed(2).replace(".", ","))
		});
		$("#precioNeto").change(function(){
			const total = Math.round(100 * leerFloat("precioNeto") * (1 + valorIva)) / 100;
			$("#precio").val(total.toFixed(2).replace(".", ","))
		});
	});
</script>