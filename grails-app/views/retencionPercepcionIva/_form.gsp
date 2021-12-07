<g:hiddenField name="retencionPercepcionId" value="${retencionPercepcionInstance?.retencionPercepcionId}" />
<g:hiddenField name="id" value="${retencionPercepcionInstance?.retencionPercepcionId}" />
<g:hiddenField name="version" value="${retencionPercepcionInstance?.version}" />

<div style="display: none;">
	<div id="urlGetCuentas">
		<g:createLink controller="cuenta" action="ajaxGetCuentasNombresSQL" />
	</div>
	<div id="urlGetCuenta">
		<g:createLink controller="cuenta" action="ajaxGetCuenta" />
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Cuenta *</label>
	<div class="col-sm-10">
		<select id="cbCuenta" name="cuentaId" class="form-control"></select>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Fecha *</label>
	<div class="col-sm-10">
		<input name="fecha" id="fecha" required="" type="text" class="form-control" data-format="d/m/Y" placeholder="Seleccione un día" value="${retencionPercepcionInstance?.fecha?.toString('dd/MM/yyyy')}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Tipo *</label>
	<div class="col-sm-10">
		<input id="cbTipo" name="tipo" type="hidden" class="" value="${retencionPercepcionInstance?.tipo}" required=""/>
	</div>
</div>
<div id="divPercepcion" style="display: none;">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Tipo y letra comprobante</label>
		<div class="col-sm-2">
			<input id="tipoComprobante"style="text-transform:uppercase;" maxlength="1" name="tipoComprobante" type="text" class="form-control ${hasErrors(bean: retencionPercepcionInstance, field: 'tipoComprobante', 'form-control-danger')}" value="${retencionPercepcionInstance?.tipoComprobante}">
		</div> 
		<div class="col-sm-2">
			<input id="letraComprobante"style="text-transform:uppercase;" maxlength="1" name="letraComprobante" type="text" class="form-control ${hasErrors(bean: retencionPercepcionInstance, field: 'letraComprobante', 'form-control-danger')}" value="${retencionPercepcionInstance?.letraComprobante}">
		</div>
	</div>
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Punto Venta y Número</label>
		<div class="col-sm-2">
			<input id="facturaParteA" name="facturaParteA" type="text" class="form-control ${hasErrors(bean: retencionPercepcionInstance, field: 'facturaParteA', 'form-control-danger')}" onkeypress='return isNumberKey(event)' value="${retencionPercepcionInstance?.facturaParteA}">
		</div> 
		<div class="col-sm-8">
			<input id="facturaParteB" name="facturaParteB" type="text" class="form-control ${hasErrors(bean: retencionPercepcionInstance, field: 'facturaParteB', 'form-control-danger')}" onkeypress='return isNumberKey(event)' value="${retencionPercepcionInstance?.facturaParteB}">
		</div>
	</div>
</div>
<div id="divRetencion">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Comprobante</label>
		<div class="col-sm-10">
			<div class="input-group">
				<input id="comprobante" name="comprobante" type="text" class="form-control ${hasErrors(bean: retencionPercepcionInstance, field: 'comprobante', 'form-control-danger')}" value="${retencionPercepcionInstance?.comprobante}">
			</div>
		</div>
	</div>
</div>
<div id="divBancaria" style="display: none;">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Tipo de Cuenta y CBU</label>
		<div class="col-sm-2">
			<input id="tipoCuenta" name="tipoCuenta" type="text" class="form-control ${hasErrors(bean: retencionPercepcionInstance, field: 'tipoCuenta', 'form-control-danger')}" value="${retencionPercepcionInstance?.tipoCuenta}">
		</div> 
		<div class="col-sm-8">
			<input id="cbu" name="cbu" type="text" class="form-control ${hasErrors(bean: retencionPercepcionInstance, field: 'cbu', 'form-control-danger')}" value="${retencionPercepcionInstance?.cbu}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">CUIT del agente</label>
	<div class="col-sm-10">
		<div class="input-group">
			<input id="cuit" name="cuit" type="text" class="form-control ${hasErrors(bean: retencionPercepcionInstance, field: 'cuit', 'form-control-danger')}" value="${retencionPercepcionInstance?.cuit}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Monto Base</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="montoBase" name="montoBase" type="text" class="form-control autonumber ${hasErrors(bean: retencionPercepcionInstance, field: 'montoBase', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${retencionPercepcionInstance?.montoBase}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Monto *</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="monto" required="" name="monto" type="text" class="form-control autonumber ${hasErrors(bean: retencionPercepcionInstance, field: 'monto', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${retencionPercepcionInstance?.monto}">
		</div>
	</div>
</div>

<script type="text/javascript">
	var iva;
	var iva27;
	var iva21;
	var iva10;
	var netoNoGravado;
	var netoNoGravado21;
	var netoNoGravado27;
	var netoNoGravado10;
	var netoGravado;
	var exento;
	var total;

$(document).ready(function () {
	var actionName = "${actionName}";
	
	/*** CBO CUENTAS ***/
	$("#cbCuenta").select2({
		placeholder: '<g:message code="zifras.cuenta.Cuenta.placeHolder" default="Seleccione una cuenta"/>',
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
		comboId : "cbCuenta",
		ajaxUrlDiv : 'urlGetCuentas',
		idDefault : '${retencionPercepcionInstance?.cuentaId}',
		atributo : 'toString',
		readOnly : (actionName == "edit")
	});

	/*** CBO TIPO ***/
	$("#cbTipo").select2({
		placeholder: '<g:message code="zifras.liquidacion.tipoRetPer.placeHolder" default="Seleccionar..."/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: 1,
		data: [
		    {
		        id: 'percepcion',
		        text: 'Percepción'
		    },
		    {
		        id: 'retencion',
		        text: 'Retención'
		    },
		    {
		        id: 'bancaria',
		        text: 'Retención Bancaria'
		    }
		]
	});
	
	$('#cbTipo').change(function(){
		$('#divPercepcion').hide();
		$('#divRetencion').hide();
		$('#divBancaria').hide();
		if ($('#cbTipo').val() == "percepcion")
			$('#divPercepcion').show();
		else if ($('#cbTipo').val() == "retencion")
			$('#divRetencion').show();
		else
			$('#divBancaria').show();
	});
	
	//Para el datePicker
    
    $("#fecha").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "d/m/Y",
		lang: "es"
    });
	
	$('#cbTipo').change(); //Muestra los campos correctos al entrar en edit
});
</script>