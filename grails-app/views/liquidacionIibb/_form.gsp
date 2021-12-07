<%@ page import="com.zifras.liquidacion.LiquidacionIva" %>

<g:hiddenField name="liquidacionIIBBId" value="${liquidacionIIBBInstance?.liquidacionIIBBId}" />
<g:hiddenField name="id" value="${liquidacionIIBBInstance?.liquidacionIIBBId}" />
<g:hiddenField name="version" value="${liquidacionIIBBInstance?.version}" />
<g:hiddenField name="alicuotas"/>

<div style="display: none;">
	<div id="urlGetEstados">
		<g:createLink controller="estado" action="ajaxGetLiquidacionIIBBEstados" />
	</div>
	<div id="urlGetProvincias">
		<g:createLink controller="provincia" action="ajaxGetProvincias" />
	</div>
	<div id="urlGetCuentas">
		<g:createLink controller="cuenta" action="ajaxGetCuentasNombresSQL" />
	</div>
	<div id="urlGetAlicuotas">
		<g:createLink controller="liquidacionIibb" action="ajaxGetAlicuotas" />
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Mes</label>
	<div class="col-sm-4">
		<input id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${liquidacionIIBBInstance?.mes}" readonly=""/>
	</div>
	<label class="col-sm-2 col-form-label">Año</label>
	<div class="col-sm-4">
		<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${liquidacionIIBBInstance?.ano}" readonly=""/>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Cuenta</label>
	<div class="col-sm-4">
		<select id="cbCuenta" name="cuentaId" class="form-control"></select>
	</div>
	<label class="col-sm-2 col-form-label">Provincia</label>
	<div class="col-sm-4">
		<select id="cbProvincia" name="provinciaId" class="form-control"></select>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Estado</label>
	<div class="col-sm-4">
		<select id="cbEstado" name="estadoId" class="form-control"></select>
	</div>
	<label class="col-sm-2 col-form-label">Vencimiento</label>
	<div class="col-sm-4">
		<input id="fechaVencimiento" name="fechaVencimiento" class="form-control" type="text" data-format="d/m/Y" placeholder="Seleccione un día" value="${liquidacionIIBBInstance?.fechaVencimiento?.toString('dd/MM/yyyy')}"/>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Saldo DDJJ</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="saldoDdjj" name="saldoDdjj" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${liquidacionIIBBInstance?.saldoDdjj}">
		</div>
	</div>
</div>
<h4 class="sub-title">Venta</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Neto Total</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="netoTotal" name="netoTotal" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${liquidacionIIBBInstance?.netoTotal}">
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Provincia</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">%</span>
			<input id="porcentajeProvincia" name="porcentajeProvincia" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${liquidacionIIBBInstance?.porcentajeProvincia}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Neto</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="neto" name="neto" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${liquidacionIIBBInstance?.neto}">
		</div>
	</div>
</div>
<h4 class="sub-title">Impuesto IIBBB</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Alícuotas</label>
	<div class="col-sm-10">
		<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showAlicuotaIIBB('crear', null, null, null, null, null, null, null, null);">Agregar</button>
		<div class="table-responsive">
			<table id="listAlicuotas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
				<thead>
					<tr>
						<th>Alícuota</th>
						<th>%</th>
						<th>Base imponible</th>
						<th>Impuesto</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Impuesto Total</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="impuesto" name="impuesto" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${liquidacionIIBBInstance?.impuesto}">
		</div>
	</div>
</div>
<h4 class="sub-title">Deducciones</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Retenciones</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="retencion" name="retencion" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIIBBInstance, field: 'retencion', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIIBBInstance?.retencion}" title="Importado: ${formatNumber(number: liquidacionIIBBInstance?.retencionSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Retenciones Sircreb</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="sircreb" name="sircreb" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIIBBInstance, field: 'sircreb', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIIBBInstance?.sircreb}"  title="Importado: ${formatNumber(number: liquidacionIIBBInstance?.bancariaSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Percepciones</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="percepcion" name="percepcion" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIIBBInstance, field: 'percepcion', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIIBBInstance?.percepcion}"  title="Importado: ${formatNumber(number: liquidacionIIBBInstance?.percepcionSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
		</div>
	</div>
</div>
<h4 class="sub-title">Saldos a favor del contribuyente</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Período actual</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="saldoAFavor" name="saldoAFavor" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIIBBInstance, field: 'saldoAFavor', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIIBBInstance?.saldoAFavor}" readonly>
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Período anterior</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="saldoAFavorPeriodoAnterior" name="saldoAFavorPeriodoAnterior" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIIBBInstance, field: 'saldoAFavorPeriodoAnterior', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIIBBInstance?.saldoAFavorPeriodoAnterior}">
		</div>
	</div>
</div>

<h4 class="sub-title">Notas</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Nota</label>
	<div class="col-sm-10">
		<textarea name="nota" class="form-control" rows="3" placeholder="Nota...">${liquidacionIIBBInstance?.nota}</textarea>
	</div>
</div>

<div class="modal fade" id="modalAlicuotaIIBB" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Alícuota IIBB</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:hiddenField name="modalLiquidacionIIBBAlicuotaId" value="" />
				<g:hiddenField name="modalAlicuotaIIBBIndex" value="" />
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Alícuota</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalAlicuotaIIBBAlicuota" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Porcentaje</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">%</span>
							<input id="modalAlicuotaIIBBPorcentaje" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Neto</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalAlicuotaIIBBNeto" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="" readonly>
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Base imponible</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalAlicuotaIIBBBaseImponible" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="" readonly>
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Impuesto</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalAlicuotaIIBBImpuesto" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="" readonly>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttonAlicuotaIIBBVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonAlicuotaIIBBEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deleteAlicuotaIIBB();">Eliminar</button>
				<button id="buttonAlicuotaIIBBAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addAlicuotaIIBB();">Aceptar</button>
				<button id="buttonAlicuotaIIBBModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updateAlicuotaIIBB();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var saldoDdjj;

var netoTotal;
var porcentajeProvincia;
var neto;

var impuesto;

var retencion;
var sircreb;
var percepcion;

var saldoAFavor;
var saldoAFavorPeriodoAnterior;


var tablaAlicuotas;

$(document).ready(function () {
	var actionName = "${actionName}";

	$("#fechaVencimiento").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "d/m/Y",
		lang: "es"
    });
	
	/*** CUENTAS ***/
	$("#cbCuenta").select2({
		placeholder: '<g:message code="zifras.cuenta.Cuenta.placeHolder" default="Seleccione una cuenta"/>',
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
		comboId : "cbCuenta",
		ajaxUrlDiv : 'urlGetCuentas',
		idDefault : '${liquidacionIIBBInstance?.cuentaId}',
		atributo : 'toString',
		readOnly : true
	});
	
	tablaAlicuotas = $('#listAlicuotas').DataTable({
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay alícuotas')}</a>",
			sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
			sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
			sInfoPostFix: "",
			sUrl: "",
			sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
			oPaginate: {
				"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
				"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
				"sNext":	"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
				"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
			}
		},
		//iDisplayLength: 100,
		//scrollX: true,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
						"mData": "alicuota"
					},{
						"aTargets": [1],
						"mData": "porcentaje"
					},{
						"aTargets": [2],
						"mData": "baseImponible",
						"sClass" : "text-right"
					},{
						"aTargets": [3],
						"mData": "impuesto",
						"sClass" : "text-right"
					}],
		sPaginationType: 'simple',
		sDom: "rt",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showAlicuotaIIBB('modificar', $('#listAlicuotas').dataTable().fnGetPosition(nRow), aData.alicuotaIIBBId, aData.alicuota, aData.porcentaje, aData.baseImponible, aData.impuesto, $('#neto').val());
			});
		}
	});
	
	getAlicuotas();
	
	/*** ESTADOS ***/
	$("#cbEstado").select2({
		placeholder: '<g:message code="zifras.Localidad.placeHolder" default="Seleccione un estado"/>',
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
		comboId : "cbEstado",
		ajaxUrlDiv : 'urlGetEstados',
		idDefault : '${liquidacionIIBBInstance?.estadoId}'
	});
	
	/*** PROVINCIAS ***/
	$("#cbProvincia").select2({
		placeholder: '<g:message code="zifras.Localidad.placeHolder" default="Seleccione una provincia',
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
		comboId : "cbProvincia",
		ajaxUrlDiv : 'urlGetProvincias',
		idDefault : '${liquidacionIIBBInstance?.provinciaId}',
		readOnly : true
	});
	
	if($("#mes").val()==''){
	    $("#mes").dateDropper( {
	        dropWidth: 200,
	        dropPrimaryColor: "#1abc9c", 
	        dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "m",
			lang: "es"
	    });
	}

	if($("#ano").val()==''){
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
	
	$("#modalAlicuotaIIBBAlicuota").change(function(){
		cambiaAlicuotaOPorcentaje();
	});
	
	$("#modalAlicuotaIIBBPorcentaje").change(function(){
		cambiaAlicuotaOPorcentaje();
	});
	
	$("#modalAlicuotaIIBBAlicuota").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#modalAlicuotaIIBBPorcentaje").focus().select();
		}
	});
	
	$("#modalAlicuotaIIBBPorcentaje").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#buttonAlicuotaIIBBModificar").focus().select();
		}
	});
	
	$("#impuesto").change(function(){
		calcularSaldos();
	});
	
	$("#retencion").change(function(){
		calcularSaldos();
	});
	
	$("#sircreb").change(function(){
		calcularSaldos();
	});
	
	$("#percepcion").change(function(){
		calcularSaldos();
	});
	
	$("#neto").change(function(){
		if( ($('#neto').val()!="") && ($('#neto').val()!=null) &&
			($('#porcentajeProvincia').val()!="") && ($('#porcentajeProvincia').val()!=null)	){
			neto = leerFloat('neto')
			netoTotal = leerFloat('netoTotal')
			porcentajeProvincia = netoTotal != 0 ? (Math.round((neto / netoTotal) * 100 * 100) / 100) : 0;
			$('#porcentajeProvincia').val(porcentajeProvincia.toFixed(2).replace(".", ","));
		}
		
		getAlicuotas()
		calcularImpuesto()
	});
	
	$("#porcentajeProvincia").change(function(){
		if( ($('#netoTotal').val()!="") && ($('#netoTotal').val()!=null) &&
			($('#porcentajeProvincia').val()!="") && ($('#porcentajeProvincia').val()!=null)	){
			netoTotal = parseFloat($('#netoTotal').val().replace(",", "."));
			porcentajeProvincia = parseFloat($('#porcentajeProvincia').val().replace(",", "."));
			
			neto = Math.round(netoTotal * porcentajeProvincia) / 100 ;
			
			$('#neto').val(neto.toFixed(2).replace(".", ","));
		}
		
		getAlicuotas()
		calcularImpuesto()
	});
	
	$("#netoTotal").change(function(){
		if( ($('#netoTotal').val()!="") && ($('#netoTotal').val()!=null) &&
			($('#porcentajeProvincia').val()!="") && ($('#porcentajeProvincia').val()!=null)	){
			netoTotal = parseFloat($('#netoTotal').val().replace(",", "."));
			porcentajeProvincia = parseFloat($('#porcentajeProvincia').val().replace(",", "."));
			
			neto = Math.round(netoTotal * porcentajeProvincia) / 100 ;
			
			$('#neto').val(neto.toFixed(2).replace(".", ","));
		}
		
		getAlicuotas()
		calcularImpuesto()
	});

	$("#saldoDdjj").change(function(){
		if(($('#saldoDdjj').val()!="") && ($('#saldoDdjj').val()!=null)){
			saldoDdjj = parseFloat($('#saldoDdjj').val().replace(",", "."));
		}else{
			saldoDdjj = 0;
		}
		
		if(($('#impuesto').val()!="") && ($('#impuesto').val()!=null)){
			impuesto = parseFloat($('#impuesto').val().replace(",", "."));
		}else{
			impuesto = 0;
		}
		
		if(($('#retencion').val()!="") && ($('#retencion').val()!=null)){
			retencion = parseFloat($('#retencion').val().replace(",", "."));
		}else{
			retencion = 0;
		}
		
		if(($('#sircreb').val()!="") && ($('#sircreb').val()!=null)){
			sircreb = parseFloat($('#sircreb').val().replace(",", "."));
		}else{
			sircreb = 0;
		}
		
		if(($('#saldoAFavorPeriodoAnterior').val()!="") && ($('#saldoAFavorPeriodoAnterior').val()!=null)){
			saldoAFavorPeriodoAnterior = parseFloat($('#saldoAFavorPeriodoAnterior').val().replace(",", "."));
		}else{
			saldoAFavorPeriodoAnterior = 0;
		}
		
		percepcion = Math.round((impuesto - retencion - sircreb - saldoDdjj - saldoAFavorPeriodoAnterior) * 100) / 100 ;
	
		$('#percepcion').val(percepcion.toFixed(2).replace(".", ","));
	});
	
	//Lógica de focus al presionar enter
	$("#saldoDdjj").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#debitoFiscal").focus().select();
		}
	});

	$("#debitoFiscal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoVenta").focus().select();
		}
	});
	
	$("#netoVenta").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalVenta").focus().select();
		}
	});
	
	$("#totalVenta").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#creditoFiscal").focus().select();
		}
	});
	
	$("#creditoFiscal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoCompra").focus().select();
		}
	});
	
	$("#netoCompra").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalCompra").focus().select();
		}
	});
	
	$("#totalCompra").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#saldoTecnicoAFavorPeriodoAnterior").focus().select();
		}
	});
	
	$("#saldoTecnicoAFavorPeriodoAnterior").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#retencion").focus().select();
		}
	});
	
	$("#retencion").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#percepcion").focus().select();
		}
	});
	
	$("#percepcion").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#saldoLibreDisponibilidadPeriodoAnterior").focus().select();
		}
	});
	
	$("#saldoLibreDisponibilidadPeriodoAnterior").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#botonAceptar").focus();
		}
	});
});

function getAlicuotas(){
	var liquidacionIIBBId = $('#liquidacionIIBBId').val();
	var cuentaId = $('#cbCuenta').val();
	var mes = $('#mes').val();
	var ano = $('#ano').val();
	var provinciaId = $('#cbProvincia').val();
	var neto = $("#neto").val();
	
	$.ajax({
		url : $('#urlGetAlicuotas').text(),
		data : {
			'liquidacionIIBBId' : liquidacionIIBBId,
			'cuentaId' : '${liquidacionIIBBInstance?.cuentaId}',
			'ano' : ano,
			'mes' : mes,
			'provinciaId' : '${liquidacionIIBBInstance?.provinciaId}',
			'neto': neto
		},
		success : function(data) {
			$('#listAlicuotas').DataTable().clear()
			for(key in data){
				$('#listAlicuotas').dataTable().fnAddData(data[key], false);
			}
			$('#listAlicuotas').dataTable().fnDraw();
			
			$('#alicuotas').val(JSON.stringify($('#listAlicuotas').dataTable().fnGetData()));
		},
		error : function() {
		}
	});
}

function calcularSaldoDdjj(){
	if(($('#debitoFiscal').val()!="") && ($('#debitoFiscal').val()!=null)){
		debitoFiscal = parseFloat($('#debitoFiscal').val().replace(",", "."));
	}else{
		debitoFiscal = 0;
	}
	
	if(($('#creditoFiscal').val()!="") && ($('#creditoFiscal').val()!=null)){
		creditoFiscal = parseFloat($('#creditoFiscal').val().replace(",", "."));
	}else{
		creditoFiscal = 0;
	}
	
	if(($('#saldoTecnicoAFavorPeriodoAnterior').val()!="") && ($('#saldoTecnicoAFavorPeriodoAnterior').val()!=null)){
		saldoTecnicoAFavorPeriodoAnterior = parseFloat($('#saldoTecnicoAFavorPeriodoAnterior').val().replace(",", "."));
	}else{
		saldoTecnicoAFavorPeriodoAnterior = 0;
	}
	
	if(($('#retencion').val()!="") && ($('#retencion').val()!=null)){
		retencion = parseFloat($('#retencion').val().replace(",", "."));
	}else{
		retencion = 0;
	}
	
	if(($('#percepcion').val()!="") && ($('#percepcion').val()!=null)){
		percepcion = parseFloat($('#percepcion').val().replace(",", "."));
	}else{
		percepcion = 0;
	}
	
	if(($('#saldoLibreDisponibilidadPeriodoAnterior').val()!="") && ($('#saldoLibreDisponibilidadPeriodoAnterior').val()!=null)){
		saldoLibreDisponibilidadPeriodoAnterior = parseFloat($('#saldoLibreDisponibilidadPeriodoAnterior').val().replace(",", "."));
	}else{
		saldoLibreDisponibilidadPeriodoAnterior = 0;
	}
	
	saldoDdjj = Math.round((debitoFiscal - creditoFiscal - saldoTecnicoAFavorPeriodoAnterior - retencion - percepcion - saldoLibreDisponibilidadPeriodoAnterior) * 100) / 100 ;
	if(saldoDdjj<0){
		saldoDdjj = 0;
	}
	
	$('#saldoDdjj').val(saldoDdjj.toFixed(2).replace(".", ","));
}

function showAlicuotaIIBB(modalidad, index, alicuotaIIBBId, alicuota, porcentaje, baseImponible, impuesto, neto){
	//Carga de datos de la fila
	$('#modalLiquidacionIIBBAlicuotaId').val(alicuotaIIBBId);
	
	if(modalidad!='modificar'){
		$('#modalAlicuotaIIBBIndex').val('');
		
		neto = $('#neto').val();
		
		$("#modalAlicuotaIIBBAlicuota").val('0,00');
		$("#modalAlicuotaIIBBPorcentaje").val('100,00');
		$("#modalAlicuotaIIBBNeto").val(neto);
		$("#modalAlicuotaIIBBBaseImponible").val(neto);
		$("#modalAlicuotaIIBBImpuesto").val('0,00');
		
		$("#buttonAlicuotaIIBBAgregar").show();
		$("#buttonAlicuotaIIBBEliminar").hide();
		$("#buttonAlicuotaIIBBModificar").hide();

		$("#buttonAlicuotaIIBBAgregar").prop('disabled', false);
		$("#buttonAlicuotaIIBBModificar").prop('disabled', true);
	}else{
		$('#modalAlicuotaIIBBIndex').val(index);
		
		$("#modalAlicuotaIIBBAlicuota").val(alicuota);
		$("#modalAlicuotaIIBBPorcentaje").val(porcentaje);
		$("#modalAlicuotaIIBBNeto").val(neto);
		$("#modalAlicuotaIIBBBaseImponible").val(baseImponible);
		$("#modalAlicuotaIIBBImpuesto").val(impuesto);
		
		$("#buttonAlicuotaIIBBAgregar").hide();
		$("#buttonAlicuotaIIBBEliminar").show();
			
		$("#buttonAlicuotaIIBBModificar").show();

		$("#buttonAlicuotaIIBBAgregar").prop('disabled', true);
		$("#buttonAlicuotaIIBBModificar").prop('disabled', false);
	}
	
	$('#modalAlicuotaIIBB').modal('show');
}

function updateAlicuotaIIBB(){
	var liquidacionIIBBAlicuotaId = $('#modalLiquidacionIIBBAlicuotaId').val();
	var index2 = parseInt($('#modalAlicuotaIIBBIndex').val());
	
	var alicuota = $("#modalAlicuotaIIBBAlicuota").val();
	var porcentaje = $("#modalAlicuotaIIBBPorcentaje").val();
	var baseImponible = $("#modalAlicuotaIIBBBaseImponible").val();
	var impuesto = $("#modalAlicuotaIIBBImpuesto").val();
	
	$('#listAlicuotas').dataTable().fnUpdate({
		liquidacionIIBBAlicuotaId: liquidacionIIBBAlicuotaId, 
		baseImponible: baseImponible,
		impuesto: impuesto,
		alicuota: alicuota,
		porcentaje: porcentaje		
	},index2);
	$('#alicuotas').val(JSON.stringify($('#listAlicuotas').dataTable().fnGetData()));
	
	$('#modalAlicuotaIIBB').modal('hide');
	
	calcularImpuesto()
}

function addAlicuotaIIBB(){
	var liquidacionIIBBAlicuotaId = '-1';
	
	var alicuota = $("#modalAlicuotaIIBBAlicuota").val();
	var porcentaje = $("#modalAlicuotaIIBBPorcentaje").val();
	var baseImponible = $("#modalAlicuotaIIBBBaseImponible").val();
	var impuesto = $("#modalAlicuotaIIBBImpuesto").val();
	
	$('#listAlicuotas').dataTable().fnAddData({
		liquidacionIIBBAlicuotaId: liquidacionIIBBAlicuotaId, 
		baseImponible: baseImponible,
		impuesto: impuesto,
		alicuota: alicuota,
		porcentaje: porcentaje		
	});
	$('#alicuotas').val(JSON.stringify($('#listAlicuotas').dataTable().fnGetData()));
	
	$('#modalAlicuotaIIBB').modal('hide');
	
	calcularImpuesto()
}

function deleteAlicuotaIIBB(){
	var index2 = parseInt($('#modalAlicuotaIIBBIndex').val());
	
	/*if($('#modalAlicuotaIIBBId').val()!=0){
		alicuotasIIBBBorradas.push(JSON.parse(JSON.stringify($('#listAlicuotasIIBB').dataTable().fnGetData(index2))));
		$('#alicuotasIIBBBorradas').val(JSON.stringify(alicuotasIIBBBorradas));
	}*/
	 
	$('#listAlicuotas').dataTable().fnDeleteRow(index2);
	$('#alicuotas').val(JSON.stringify($('#listAlicuotas').dataTable().fnGetData()));
	$('#modalAlicuotaIIBB').modal('hide');
}

function cambiaAlicuotaOPorcentaje(){
	var alicuota;
	var porcentaje;
	var neto;
	
	var baseImponible;
	var impuesto;
	
	if(($('#modalAlicuotaIIBBAlicuota').val()!="") && 
		($('#modalAlicuotaIIBBAlicuota').val()!=null) &&
		($('#modalAlicuotaIIBBPorcentaje').val()!=null) &&
		($('#modalAlicuotaIIBBPorcentaje').val()!=null)){
		alicuota = parseFloat($('#modalAlicuotaIIBBAlicuota').val().replace(",", "."));
		porcentaje = parseFloat($('#modalAlicuotaIIBBPorcentaje').val().replace(",", "."));
		neto = parseFloat($('#neto').val().replace(",", "."));
		
		baseImponible = Math.round(neto*porcentaje) / 100;
		impuesto =  Math.round(baseImponible*alicuota) / 100;
		
		$('#modalAlicuotaIIBBAlicuota').val(alicuota.toFixed(2).replace(".", ","));
		$('#modalAlicuotaIIBBPorcentaje').val(porcentaje.toFixed(2).replace(".", ","));
		$('#modalAlicuotaIIBBBaseImponible').val(baseImponible.toFixed(2).replace(".", ","));
		$('#modalAlicuotaIIBBImpuesto').val(impuesto.toFixed(2).replace(".", ","));
	}else{
		$('#modalAlicuotaIIBBAlicuota').val("0,00");
		$('#modalAlicuotaIIBBPorcentaje').val("0,00");
		$('#modalAlicuotaIIBBBaseImponible').val("0,00");
		$('#modalAlicuotaIIBBImpuesto').val("0,00");
	}
}

function calcularImpuesto(){
	if(($('#neto').val()!="") && ($('#neto').val()!=null)){
		neto = parseFloat($('#neto').val().replace(",", "."));
	}else{
		neto = 0;
	}
	
	var rows = tablaAlicuotas.rows().data();
	var indexesAlicuotas = tablaAlicuotas.rows().indexes();
	var indexTable=null;
	
	var impuestoTotal = 0;
	
	var alicuotasIIBB = $('#listAlicuotas').dataTable().fnGetData();
	
	for(var i=0; i < rows.length; i++) {
		var baseImponibleAux = parseFloat(rows[i].baseImponible.replace(",", "."));
		var impuestoAux = parseFloat(rows[i].impuesto.replace(",", "."));
		
		var alicuota = parseFloat(rows[i].alicuota.replace(",", "."));
		var porcentaje = parseFloat(rows[i].porcentaje.replace(",", "."));
		
		baseImponibleAux = Math.round(neto * porcentaje) / 100 ;
		impuestoAux = Math.round(baseImponibleAux * alicuota) / 100 ;
		
		impuestoTotal += impuestoAux;
		 
		var baseImponibleNueva = baseImponibleAux.toFixed(2).replace(".", ",");
		var impuestoNuevo = impuestoAux.toFixed(2).replace(".", ",");
		
		var liquidacionIIBBAlicuotaId;
		if (typeof rows[i].liquidacionIIBBAlicuotaId === 'undefined' || !rows[i].liquidacionIIBBAlicuotaId)
			liquidacionIIBBAlicuotaId = "";
		else
			liquidacionIIBBAlicuotaId = rows[i].liquidacionIIBBAlicuotaId;
		
		$('#listAlicuotas').dataTable().fnUpdate({
			liquidacionIIBBAlicuotaId: rows[i].liquidacionIIBBAlicuotaId, 
			baseImponible: baseImponibleNueva,
			impuesto: impuestoNuevo,
			alicuota: rows[i].alicuota,
			porcentaje: rows[i].porcentaje
		}, indexesAlicuotas[i]);	
	}
	
	$('#alicuotas').val(JSON.stringify($('#listAlicuotas').dataTable().fnGetData()));
	
	impuestoTotal = Math.round(impuestoTotal * 100) / 100;
	$('#impuesto').val(impuestoTotal.toFixed(2).replace(".", ","));
	
	alicuotasIIBB = $('#listAlicuotas').dataTable().fnGetData();
	
	calcularSaldos();
}

function calcularSaldos(){
	if(($('#impuesto').val()!="") && ($('#impuesto').val()!=null)){
		impuesto = parseFloat($('#impuesto').val().replace(",", "."));
	}else{
		impuesto = 0;
	}
	
	if(($('#retencion').val()!="") && ($('#retencion').val()!=null)){
		retencion = parseFloat($('#retencion').val().replace(",", "."));
	}else{
		retencion = 0;
	}
	
	if(($('#sircreb').val()!="") && ($('#sircreb').val()!=null)){
		sircreb = parseFloat($('#sircreb').val().replace(",", "."));
	}else{
		sircreb = 0;
	}
	
	if(($('#percepcion').val()!="") && ($('#percepcion').val()!=null)){
		percepcion = parseFloat($('#percepcion').val().replace(",", "."));
	}else{
		percepcion = 0;
	}
	
	if(($('#saldoAFavorPeriodoAnterior').val()!="") && ($('#saldoAFavorPeriodoAnterior').val()!=null)){
		saldoAFavorPeriodoAnterior = parseFloat($('#saldoAFavorPeriodoAnterior').val().replace(",", "."));
	}else{
		saldoAFavorPeriodoAnterior = 0;
	}
	
	saldoDdjj = Math.round((impuesto - retencion - sircreb - percepcion - saldoAFavorPeriodoAnterior) * 100) / 100 ;
	saldoAFavor = 0;
	if(saldoDdjj<0){
		saldoAFavor -= saldoDdjj;
		saldoDdjj = 0;
	}
	
	$('#saldoDdjj').val(saldoDdjj.toFixed(2).replace(".", ","));
	$('#saldoAFavor').val(saldoAFavor.toFixed(2).replace(".", ","));
}
</script>