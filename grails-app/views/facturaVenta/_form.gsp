<g:hiddenField name="facturaVentaId" value="${facturaVentaInstance?.facturaVentaId}" />
<g:hiddenField name="id" value="${facturaVentaInstance?.facturaVentaId}" />
<g:hiddenField name="version" value="${facturaVentaInstance?.version}" />
<g:hiddenField name="ivaDefaultId" value="${facturaVentaInstance?.ivaDefaultId}" />
<g:hiddenField name="itemsFactura"/>
<!-- TOFIX: El modal crashea -->
<div style="display: none;">
	<div id="urlGetCuentas">
		<g:createLink controller="cuenta" action="ajaxGetCuentasNombresSQL" />
	</div>
	<div id="urlGetPersonas">
		<g:createLink controller="persona" action="ajaxGetClientesPorCuenta" />
	</div>
	<div id="urlGetTiposFactura">
		<g:createLink controller="tipoComprobante" action="ajaxGetTiposComprobante" />
	</div>
	<div id="urlGetConceptos">
		<g:createLink controller="facturaVenta" action="ajaxGetConceptos" />
	</div>
	<div id="urlGetAlicuotas">
		<g:createLink controller="facturaVenta" action="ajaxGetAlicuotas" />
	</div>
	<div id="urlGetAlicuota">
		<g:createLink controller="facturaVenta" action="ajaxGetAlicuota" />
	</div>
	<div id="urlGetPuntosVenta">
		<g:createLink controller="puntoVenta" action="ajaxGetPuntosVenta" />
	</div>
	<div id="urlGetUnidadesMedida">
		<g:createLink controller="facturaVenta" action="ajaxGetUnidadesMedida" />
	</div>
	<div id="urlGetListItems">
		<g:createLink controller="facturaVenta" action="ajaxGetListItems" />
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Cuenta</label>
	<div class="col-sm-10">
		<select id="cbCuenta" name="cuentaId"></select>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Fecha</label>
	<div class="col-sm-10">
		<input name="fecha" id="fecha" type="text" class="form-control" data-format="d/m/Y" placeholder="Seleccione un día" value="${facturaVentaInstance?.fecha?.toString('dd/MM/yyyy')}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Unidad</label>
	<div class="col-sm-5">
		<select id="cbUnidad"></select>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Cliente</label>
	<div class="col-sm-10">
		<select id="cbCliente" name="clienteId"></select>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Tipo</label>
	<div class="col-sm-10">
		<select id="cbTipo" name="tipoId"></select>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Concepto</label>
	<div class="col-sm-10">
		<select id="cbConcepto" name="conceptoId"></select>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Punto Venta - Número</label>
	<div class="col-sm-5">
		<select id="cbPuntoVenta" name="puntoVentaId"></select>
	</div> 
	<div class="col-sm-5">
		<input id="numero" name="numero" type="text" class="form-control ${hasErrors(bean: facturaVentaInstance, field: 'numero', 'form-control-danger')}" onkeypress='return isNumberKey(event)' value="${facturaVentaInstance?.numero}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Items</label>
	<div class="col-sm-10">
		<button type="button" id="btnAddItem" style="float:right;" class="btn btn-primary waves-effect" onclick="showItems();">Agregar</button>
		<div class="table-responsive">
			<table id="listItems" class="table table-striped table-bordered nowrap" style="cursor:pointer">
				<thead>
					<tr>
						<th>Código</th>
						<th>Detalle</th>
						<th>Cantidad</th>
						<th>Neto</th>
						<th>% IVA</th>
						<th>Total</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="modal fade" id="modalItems" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Item</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:hiddenField name="modalItemId" value="" />
				<g:hiddenField name="modalItemsIndex" value="" />
					<!-- //BODY  -->
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Código</label>
					<div class="col-sm-5">
						<div class="input-group">
							<input id="modalCodigo" name="modalCodigo" type="text" class="form-control" onkeypress='return isNumberKey(event)'>
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Detalle</label>
					<div class="col-sm-5">
						<div class="input-group">
							<input id="modalDetalle" name="modalDetalle" type="text" class="form-control">
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Cantidad</label>
					<div class="col-sm-5">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1"></span>
							<input id="modalCantidad" name="modalCantidad" type="text" class="form-control autonumber" data-a-sep="" data-a-dec=",">
						</div>
					</div>
				</div>
				
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Neto</label>
					<div class="col-sm-5">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalNeto" name="modalNeto" type="text" class="form-control autonumber" data-a-sep="" data-a-dec=",">
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Alicuota IVA</label>
					<div class="col-sm-5">
						<select id="cbAlicuota" name="modalAlicuota"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Total:</label>
					<div class="col-sm-5">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalTotal" name="modalTotal" type="text" class="form-control autonumber" data-a-sep="" data-a-dec=",">
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttonItemVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonItemEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deleteItem();">Eliminar</button>
				<button id="buttonItemAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addItem();">Aceptar</button>
				<button id="buttonItemModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updateItem();">Aceptar</button>
			</div>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Totales de factura:</label>
	<div class="col-sm-3">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">Neto $</span>
			<input id="neto" name="neto" type="text" class="form-control autonumber ${hasErrors(bean: facturaVentaInstance, field: 'neto', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaVentaInstance?.neto}" readonly="">
		</div>
	</div>
	<div class="col-sm-3">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">IVA $</span>
			<input id="iva" name="iva" type="text" class="form-control autonumber ${hasErrors(bean: facturaVentaInstance, field: 'iva', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaVentaInstance?.iva}" readonly="">
		</div>
	</div>
	<div class="col-sm-3">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">Total $</span>
			<input id="total" name="total" type="text" class="form-control autonumber ${hasErrors(bean: facturaVentaInstance, field: 'total', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaVentaInstance?.total}" readonly="">
		</div>
	</div>
</div>

<script type="text/javascript">
	var tablaItems;
	var ivaSeleccionado;
	var netoTotal=0;
	var ivaTotal=0;
	var netoSeleccionado;
	var totalSeleccionado;
	var totalTotal=0;

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
		idDefault : '${facturaVentaInstance?.cuentaId}',
		atributo : 'toString',
		readOnly: (actionName == "edit")
	});
	
	$("#cbCuenta").change(function(){
		llenarCombo({
			comboId : "cbCliente",
			ajaxUrlDiv : 'urlGetPersonas',
			atributo : 'toString',
			parametros : {
				'id': $("#cbCuenta").val()
			}
		});

		llenarCombo({
			comboId : "cbPuntoVenta",
			ajaxUrlDiv : 'urlGetPuntosVenta',
			atributo : 'caption',
			parametros: {
				cuentaId : $("#cbCuenta").val()
			}
		});
	});
	
	/*** CBO CLIENTE ***/
	$("#cbCliente").select2({
		placeholder: '<g:message code="zifras.facturacion.Persona.placeHolder" default="Seleccione un cliente"/>',
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
		comboId : "cbCliente",
		ajaxUrlDiv : 'urlGetPersonas',
		idDefault : '${facturaVentaInstance?.clienteId}',
		atributo : 'toString',
		parametros : {
			'id': '${facturaVentaInstance?.cuentaId}'
		}
	});

	/*** CBO TIPO ***/
	$("#cbTipo").select2({
		placeholder: '<g:message code="zifras.facturacion.tipoComprobante.placeHolder" default="Seleccione un tipo de factura"/>',
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
		comboId : "cbTipo",
		ajaxUrlDiv : 'urlGetTiposFactura',
		idDefault : '${facturaVentaInstance?.tipoId}'
	});

	/*** CBO CONCEPTO ***/
	$("#cbConcepto").select2({
		placeholder: '<g:message code="zifras.facturacion.TipoConcepto.placeHolder" default="Seleccione un concepto para la factura"/>',
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
		comboId : "cbConcepto",
		ajaxUrlDiv : 'urlGetConceptos',
		idDefault : '${facturaVentaInstance?.conceptoId}'
	});

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
		ajaxUrlDiv : 'urlGetAlicuotas',
		atributo : 'caption'
	});

	/*** CBO PV ***/
	$("#cbPuntoVenta").select2({
		placeholder: '<g:message code="zifras.facturacion.PuntoVenta.placeHolder" default="Seleccione un punto de venta para la factura"/>',
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
		comboId : "cbPuntoVenta",
		ajaxUrlDiv : 'urlGetPuntosVenta',
		idDefault : '${facturaVentaInstance?.puntoVenta}',
		atributo : 'caption',
		parametros: {
			cuentaId : '${facturaVentaInstance?.cuentaId}'
		}
	});
	
	/*** CBO Unidad medida ***/
	$("#cbUnidad").select2({
		placeholder: '<g:message code="zifras.facturacion.UnidadMedida.placeHolder" default="Seleccione una unidad"/>',
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
		comboId : "cbUnidad",
		ajaxUrlDiv : 'urlGetUnidadesMedida'
	});

	
	tablaItems = $('#listItems').DataTable({
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay items')}</a>",
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
						"mData": "codigo"
					},{
						"aTargets": [1],
						"mData": "detalle"
					},{
						"aTargets": [2],
						"mData": "cantidad"
					},{
						"aTargets": [3],
						"mData": "neto"
					},{
						"aTargets": [4],
						"mData": "iva"
					},{
						"aTargets": [5],
						"mData": "total"
					}],
		sPaginationType: 'simple',
		sDom: "rt",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showItems($('#listItems').dataTable().fnGetPosition(nRow), aData.codigo, aData.detalle, aData.neto, aData.ivaId, aData.total);
			});
		}
	});

	llenarDatoslistItems();
	
	//Para el datePicker
    
    $("#fecha").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "d/m/Y",
		lang: "es"
    });

    //Autocompletado de campos
	
		$("#cbAlicuota").change(function(){
			$.ajax($('#urlGetAlicuota').text(), {
				dataType: "json",
				data: {
					id: $("#cbAlicuota").val()
				}
			}).done(function(data) {
				ivaSeleccionado=data;
				$("#modalNeto").change();
			});
		});
	
		$("#modalNeto").change(function(){
			if(($('#modalNeto').val()!="") && ($('#modalNeto').val()!=null)){
				neto = parseFloat($('#modalNeto').val().replace(",", "."));
			}else{
				neto = 0;
			}
			var porcentajeIva = (ivaSeleccionado.valor/100);
			var iva = (Math.round((neto * porcentajeIva) * 100) / 100);
			var total = neto + iva;
			$('#modalTotal').val(total.toFixed(2).replace(".", ","));
		});
	
		$("#modalTotal").change(function(){
			if(($('#modalTotal').val()!="") && ($('#modalTotal').val()!=null)){
				total = parseFloat($('#modalTotal').val().replace(",", "."));
			}else{
				total = 0;
			}
			var iva = (ivaSeleccionado.valor/100)+1; // Esto es porque la división debe ser, por ejemplo, sobre 1.21; pero nosotros tenemos 21 así que lo dividimos por 100 y le sumamos 1. Además, evita dividir por cero en el caso de exento.
			var neto = (Math.round((total / iva) * 100) / 100);
			$('#modalNeto').val(neto.toFixed(2).replace(".", ","));
		});
	
	//Lógica de focus al presionar enter
		$("#cuenta").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#fecha").focus().select();
			}
		});
		$("#fecha").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#clienteId").focus().select();
			}
		});
		$("#clienteId").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#tipoId").focus().select();
			}
		});
		$("#tipoId").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#conceptoId").focus().select();
			}
		});
		$("#conceptoId").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#puntoVentaId").focus().select();
			}
		});
		$("#puntoVentaId").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#numero").focus().select();
			}
		});
		$("#numero").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#btnAddItem").focus();
			}
		});
		$("#modalCodigo").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#modalDetalle").focus().select();
			}
		});
		$("#modalDetalle").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#modalNeto").focus().select();
			}
		});
		$("#modalNeto").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#cbAlicuota").focus().select();
			}
		});
		$("#cbAlicuota").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#modalTotal").focus().select();
			}
		});
		$("#modalTotal").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				//$("#buttonItemAgregar").focus(); ¿Y si es modificar?
			}
		});
});
function llenarDatoslistItems(){
	if(($('#facturaVentaId').val()!="") && ($('#facturaVentaId').val()!=null)){
		$.ajax($('#urlGetListItems').text(), {
			dataType: "json",
			data: {
				facturaId: $('#facturaVentaId').val()
			}
		}).done(function(data) {
			for(key in data){
				tablaItems.row.add(data[key]);
			}
			tablaItems.draw();
		});
	}
}
function showItems(index=null, codigo=0, detalle="", neto="0,00", ivaId=0, total="0,00"){
	//Se muestran u ocultan botones
		if(index!=null){ //MODIFICAR
			$('#modalItemsIndex').val(index);
			
			$("#buttonItemAgregar").hide();
			$("#buttonItemEliminar").show();
			$("#buttonItemModificar").show();
			$("#buttonItemAgregar").prop('disabled', true);
			$("#buttonItemModificar").prop('disabled', false);
		}else{ //AGREGAR
			$('#modalItemsIndex').val('');
			
			$("#buttonItemAgregar").show();
			$("#buttonItemEliminar").hide();
			$("#buttonItemModificar").hide();
			$("#buttonItemAgregar").prop('disabled', false);
			$("#buttonItemModificar").prop('disabled', true);
		}
	//Se inicializan los campos:
		$("#modalTotal").val(total);
		$("#modalNeto").val(neto);
		if (ivaId==0)
			ivaId = $('#ivaDefaultId').val();
		$("#cbAlicuota").val(ivaId).trigger('change');
		$("#modalCodigo").val(codigo);
		$("#modalDetalle").val(detalle);
	
	netoSeleccionado = parseFloat($('#modalNeto').val().replace(",", "."));
	totalSeleccionado = parseFloat($('#modalTotal').val().replace(",", "."));
	$('#modalItems').modal('show');
}

function deleteItem(){
	var index2 = parseInt($('#modalItemsIndex').val());
	$('#listItems').dataTable().fnDeleteRow(index2);
	$('#itemsFactura').val(JSON.stringify($('#listItems').dataTable().fnGetData()));
	$('#modalItems').modal('hide');
	
	recalcularTotales(true);
}

function addItem(){
	if (modalNotNull()) {
		//Verificar not nulls
		var itemId = -1;
		var codigo = $('#modalCodigo').val();
		var detalle = $('#modalDetalle').val();
		var neto = $('#modalNeto').val();
		var iva = ivaSeleccionado.caption;
		var ivaId = ivaSeleccionado.id;
		var total = $('#modalTotal').val();
		$('#listItems').dataTable().fnAddData({
			id: itemId,
			itemId: itemId,
			codigo: codigo, 
			detalle: detalle,
			neto: neto,
			iva: iva,
			ivaId: ivaId,
			total: total
		});
		$('#itemsFactura').val(JSON.stringify($('#listItems').dataTable().fnGetData()));
		$('#modalItems').modal('hide');
		
		recalcularTotales();
	}else{
		//Mostrar error
	}
}

function modalNotNull(){
	if(($('#modalCodigo').val()!="") && ($('#modalCodigo').val()!=null))
		if(($('#modalDetalle').val()!="") && ($('#modalDetalle').val()!=null))
			if(($('#modalNeto').val()!="") && ($('#modalNeto').val()!=null))
				if(($('#modalTotal').val()!="") && ($('#modalTotal').val()!=null))
					return true;
	return false;
}

function updateItem(){
	if (modalNotNull()) {
		var itemId = $('#modalItemId').val();
		var index2 = parseInt($('#modalItemsIndex').val());
		var codigo = $('#modalCodigo').val();
		var detalle = $('#modalDetalle').val();
		var neto = $('#modalNeto').val();
		var iva = ivaSeleccionado.caption;
		var ivaId = ivaSeleccionado.id;
		var total = $('#modalTotal').val();
		
		$('#listItems').dataTable().fnUpdate({
			id: itemId,
			itemId: itemId,
			codigo: codigo, 
			detalle: detalle,
			neto: neto,
			iva: iva,
			ivaId: ivaId,
			total: total
		},index2);
		$('#itemsFactura').val(JSON.stringify($('#listItems').dataTable().fnGetData()));
		
		$('#modalItems').modal('hide');
		
		recalcularTotales();
	}else{
		//Mostrar error
	}
}

function recalcularTotales(borrar = false){
	neto = parseFloat($('#modalNeto').val().replace(",", "."));
	total = parseFloat($('#modalTotal').val().replace(",", "."));
	iva = total - neto;
	if (netoSeleccionado>0 && totalSeleccionado>0) {
		netoTotal= netoTotal - netoSeleccionado;
		ivaTotal = ivaTotal - (totalSeleccionado - netoSeleccionado);
		totalTotal = totalTotal - totalSeleccionado;
	}
	if (!borrar) {
		netoTotal= netoTotal + neto;
		ivaTotal = ivaTotal + iva;
		totalTotal = totalTotal + total;
	}

	$('#neto').val(netoTotal.toFixed(2).replace(".", ","));
	$('#iva').val(ivaTotal.toFixed(2).replace(".", ","));
	$('#total').val(totalTotal.toFixed(2).replace(".", ","));
}
</script>