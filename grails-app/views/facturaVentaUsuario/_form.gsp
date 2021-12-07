<g:hiddenField name="facturaVentaId" value="${facturaVentaInstance?.facturaVentaId}" />
<g:hiddenField name="id" value="${facturaVentaInstance?.facturaVentaId}" />
<g:hiddenField name="cuentaId" value="${cuentaId}" />
<g:hiddenField name="version" value="${facturaVentaInstance?.version}" />
<g:hiddenField name="ivaDefaultId" value="${facturaVentaInstance?.ivaDefaultId}" />
<g:hiddenField name="puntosVenta" value="${puntosVenta}" />
<g:hiddenField name="limiteVentaProducto" value="${limiteVentaProducto}" />
<g:hiddenField name="productoId" value="${productoId}" />
<g:hiddenField name="proformaId" value="${proforma?.id}" />
<g:hiddenField name="itemsFactura"/>

<div style="display: none;">
	<div id="urlBuscarCuit">
	   <g:createLink controller="agenda" action="ajaxGetDatosClienteProveedor"/>
	</div> 
</div>

<div class="form-group row">
	<label class="col-sm-1 col-form-label">Número</label>
		<div class="col-sm-3">
			<select id="cbPuntosVenta" name="puntoVenta" >
				<g:each in="${puntosVenta}">
				 	<option value="${it}">${String.format("%05d",it)}</option>
				</g:each>
			</select>
		</div>
		<div class="col-sm-5">
			<input id="numero" name="numero" type="text" class="form-control" readonly placeholder="Seleccione comprobante y punto de venta">
		</div>
</div>
<div class="form-group row">
	<label class="col-sm-1 col-form-label">Comprobante</label>
	<div class="col-sm-8">
		<select id="cbTipo" name="tipoId"></select>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-1 col-form-label">Fecha</label>
	<div class="col-sm-8">
		<input name="fecha" id="fecha" type="text" class="form-control" data-format="d/m/Y" placeholder="Seleccione un día" value="${facturaVentaInstance?.fecha?.toString('dd/MM/yyyy') ?: proforma?.fecha?.toString('dd/MM/yyyy') ?: hoy.toString('dd/MM/yyyy')}" ${proforma ? 'readonly' : ''}>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-1 col-form-label">Cliente</label>
	<div class="col-sm-8">
		<select id="cbCliente" name="clienteId"></select>
	</div>
	<button style="${proforma ? 'display: none;' : ''}" type="button" class="btn btn-success" onclick="$('#modalCliente').modal('show')">+</button>
</div>
<div class="form-group row">
	<label class="col-sm-1 col-form-label">Concepto</label>
	<div class="col-sm-8">
		<select id="cbConcepto" name="conceptoId"></select>
	</div>
</div>
<div id="divCbu" class="form-group row" style="display: none;">
	<label class="col-sm-1 col-form-label">CBU Emisor</label>
	<div class="col-sm-8">
		<input id="cbuEmisor" type="text" class="form-control" name="cbuEmisor"></input>
	</div>
</div>
<div id="divIdioma" class="form-group row" style="display: none;">
	<label class="col-sm-1 col-form-label">Idioma</label>
	<div class="col-sm-8">
		<select id="cbIdioma" name="idiomaId"></select>
	</div>
</div>
<div id="divMoneda" class="form-group row" style="display: none;">
	<label class="col-sm-1 col-form-label">Moneda</label>
	<div class="col-sm-8">
		<select id="cbMoneda" name="monedaId"></select>
	</div>
</div>
<div id="divPais" class="form-group row" style="display: none;">
	<label class="col-sm-1 col-form-label">Pais Destino</label>
	<div class="col-sm-8">
		<select id="cbPaisCodigo" name="paisCodigoId"></select>
	</div>
</div>
<div id="divCuitPais" class="form-group row" style="display: none;">
	<label class="col-sm-1 col-form-label">Cuit Pais</label>
	<div class="col-sm-3">
		<select id="cbPaisCuit" name="paisCuitId"></select>
	</div>
	<div class="col-sm-5 row">
		<div class="col-sm-2 form-radio m-b-30 ">
			<div class="radio radiofill radio-success radio-inline" style="width:100%;">
				<label>
				<input name="tipoCuitPais" id="cuitFisica" value="cuitFisica" type="radio" name="radio" checked >
				<i class="helper"></i>Física
				</label>
			</div>
		</div>
		<div class="col-sm-2 form-radio m-b-30 ">
			<div class="radio radiofill radio-success radio-inline" style="width:100%;">
				<label>
				<input name="tipoCuitPais" id="cuitJuridica" value="cuitJuridica" type="radio" name="radio">
				<i class="helper"></i>Jurídica
				</label>
			</div>
		</div>
		<div class="col-sm-3 form-radio m-b-30 ">
			<div class="radio radiofill radio-success radio-inline" style="width:100%;">
				<label>
				<input name="tipoCuitPais" id="cuitOtraEntidad" value="cuitOtraEntidad" type="radio" name="radio">
				<i class="helper"></i>Otra Entidad
				</label>
			</div>
		</div>
	</div>
</div>
<div class="form-group row" id="divFechasServicio" style="display: none;">
	<label class="col-sm-1 col-form-label">Inicio Servicio</label>
	<div class="col-sm-2">
		<input name="fechaInicioServicios" id="fechaInicioServicios" type="text" class="form-control" data-format="d/m/Y" placeholder="Seleccione un día" value="${facturaVentaInstance?.fechaInicioServicios?.toString('dd/MM/yyyy') ?: proforma?.fecha?.minusWeeks(1)?.toString('dd/MM/yyyy') ?: hoy.toString('dd/MM/yyyy')}" ${proforma ? 'readonly' : ''}>
	</div>
	<label class="col-sm-1 col-form-label" style="text-align: center">Fin Servicio</label>
	<div class="col-sm-2">
		<input name="fechaFinServicios" id="fechaFinServicios" type="text" class="form-control" data-format="d/m/Y" placeholder="Seleccione un día" value="${facturaVentaInstance?.fechaFinServicios?.toString('dd/MM/yyyy') ?: proforma?.fecha?.toString('dd/MM/yyyy') ?: hoy.toString('dd/MM/yyyy')}" ${proforma ? 'readonly' : ''}>
	</div>
	<label class="col-sm-1 col-form-label" style="font-size: 13.8px; text-align: center;">Vencimiento Pago</label>
	<div class="col-sm-2">
		<input name="fechaVencimientoPagoServicio" id="fechaVencimientoPagoServicio" type="text" class="form-control" data-format="d/m/Y" placeholder="Seleccione un día" value="${facturaVentaInstance?.fechaVencimientoPagoServicio?.toString('dd/MM/yyyy') ?: proforma?.fecha?.plusWeeks(1)?.toString('dd/MM/yyyy') ?: hoy.plusMonths(1).toString('dd/MM/yyyy')}" ${proforma ? 'readonly' : ''}>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-1 col-form-label">Items</label>
	<div class="col-sm-8">
		<div class="table-responsive">
			<table id="listItems" class="table table-striped table-bordered nowrap" style="cursor:pointer; width: 100%">
				<thead>
					<tr>
						<th>Detalle</th>
						<th>Precio Unitario</th>
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
	<button type="button" id="btnAddItem" style="float:right; height: 40px; margin-top: 5px; ${proforma ? 'display: none;' : ''}" class="btn btn-success" onclick="showItems();">+</button>
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
				<g:hiddenField name="modalItemsIndex" value="" />
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Detalle</label>
					<div class="col-sm-5">
						<div class="input-group">
							<input id="modalDetalle" name="modalDetalle" type="text" class="form-control">
						</div>
					</div>
				</div>

				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Precio Unitario</label>
					<div class="col-sm-5">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalPrecioUnitario" class="form-control autonumber" data-a-sep="" data-a-dec=",">
						</div>
					</div>
				</div>

				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Cantidad</label>
					<div class="col-sm-5">
						<div class="input-group">
							<input id="modalCantidad" name="modalCantidad" type="text" class="form-control" onkeypress='return isNumberKey(event)'>
						</div>
					</div>
				</div>

				<div class="form-group row" ${esMonotributista ? raw('style="display: none"') : ''}>
					<label class="col-sm-2 col-form-label">Neto</label>
					<div class="col-sm-5">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalNeto" name="modalNeto" type="text" class="form-control autonumber" data-a-sep="" data-a-dec=",">
						</div>
					</div>
				</div>

				<div class="form-group row" ${esMonotributista ? raw('style="display: none"') : ''}>
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
<div class="form-group row" ${esMonotributista ? raw('style="display: none"') : ''}>
	<label class="col-sm-1">Neto</label>
	<div class="col-sm-2" >
		<div class="input-group">
			<input id="neto" name="neto" type="text" class="form-control autonumber ${hasErrors(bean: facturaVentaInstance, field: 'neto', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaVentaInstance?.neto}" readonly="" style="display:none">
			<label id=labelNeto name="labelNeto">$${facturaVentaInstance?.neto}</label>
		</div>
	</div>
</div>
<div class="form-group row" ${esMonotributista ? raw('style="display: none"') : ''}>
	<label class="col-sm-1">No Gravado</label>
	<div class="col-sm-2" >
		<div class="input-group">
			<label id=labelNoGravado name="labelNeto">$${facturaVentaInstance?.netoNoGravado}</label>
			<input id="netoNoGravado" name="netoNoGravado" type="text" class="form-control autonumber ${hasErrors(bean: facturaVentaInstance, field: 'netoNoGravado', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaVentaInstance?.neto}" readonly="" style="display:none">
		</div>
	</div>
</div>
<div class="form-group row" ${esMonotributista ? raw('style="display: none"') : ''}>
	<label class="col-sm-1">Exento</label>
	<div class="col-sm-2" >
		<div class="input-group">
			<label id=labelExento name="labelExento">$${facturaVentaInstance?.exento}</label>
			<input id="exento" name="exento" type="text" class="form-control autonumber ${hasErrors(bean: facturaVentaInstance, field: 'exento', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaVentaInstance?.exento}" readonly="" style="display:none">
		</div>
	</div>
</div>
<div class="form-group row" ${esMonotributista ? raw('style="display: none"') : ''}>
	<label class="col-sm-1">IVA</label>
	<div class="col-sm-2" >
		<div class="input-group">
			<label id=labelIva name="labelIva">$${facturaVentaInstance?.iva}</label>
			<input id="iva" name="iva" type="text" class="form-control autonumber ${hasErrors(bean: facturaVentaInstance, field: 'iva', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaVentaInstance?.iva}" readonly="" style="display:none">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-1">Total</label>
	<div class="col-sm-2">
		<div class="input-group">
			<input id="total" name="total" type="text" class="form-control autonumber ${hasErrors(bean: facturaVentaInstance, field: 'total', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaVentaInstance?.total}" readonly="" style= "display: none">
			<label id=labelTotal name="labelTotal">$${facturaVentaInstance?.total}</label>
		</div>
	</div>
</div>

<script type="text/javascript">
	var tablaItems;
	var ivaSeleccionado;
	var itemSeleccionado;
	const hayProforma = ${!!proforma}
	var comprobanteC = false;

$(document).ready(function () {

	document.getElementById("btnSubmitModal").addEventListener("click", function(event){
	    $.ajax({
	        url:'/agenda/save?id='+$("#cuentaId").val(),
	        type:'post',
	        data:$('#modalForm').serialize(),
	        success:function(){
	           location.reload();
	        }
	    });
	});

	$("#modalPrecioUnitario").keyup(function(){
		if( ($("#modalPrecioUnitario").val() > parseInt($("#limiteVentaProducto").val())) && ${esMonotributista} && ($("#cbConcepto").val() == $("#productoId").val()) ){
			alert("El precio ingresado para el producto supera el limite para pertenecer a la categoria monotributo ($"+$("#limiteVentaProducto").val()+")")
		}
		$("#modalTotal").val($("#modalPrecioUnitario").val() * $("#modalCantidad").val())
	})

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
		ajaxLink : '${createLink(controller: "persona", action:"ajaxGetClientesPorCuenta")}',
		idDefault : '${facturaVentaInstance?.clienteId ?: pedidosYaId}',
		readOnly: hayProforma,
		atributo : 'toString',
		parametros : {
			'id': '${cuentaId}'
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
		ajaxLink : '${createLink(controller: "tipoComprobante", action:"ajaxGetTiposComprobante")}',
		idDefault : '${facturaId}',
		parametros : {
			'cuentaId': "${cuentaId}"
		},
		readOnly : hayProforma
	});

	/*** CBO PUNTOS VENTA ***/
	$("#cbPuntosVenta").select2({
		placeholder: '<g:message code="zifras.facturacion.puntoVenta.placeHolder" default="Seleccione un punto de venta"/>',
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
		ajaxLink : '${createLink(controller: "facturaVenta", action:"ajaxGetConceptos")}',
		idDefault : '${servicioId}',
		readOnly : hayProforma
	});

	$("#cbIdioma").select2({
		placeholder: 'Seleccione un idioma para la factura',
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
		comboId : "cbIdioma",
		ajaxLink : '${createLink(controller: "facturaVenta", action:"ajaxGetIdiomas")}',
		idDefault : '${idiomaId}',
		readOnly : hayProforma
	});

	$("#cbMoneda").select2({
		placeholder: 'Seleccione una moneda para la factura',
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
		comboId : "cbMoneda",
		ajaxLink : '${createLink(controller: "facturaVenta", action:"ajaxGetMonedas")}',
		idDefault : '${monedaId}',
		readOnly : hayProforma
	});

	$("#cbPaisCodigo").select2({
		placeholder: 'Seleccione un pais destino para la factura',
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
		comboId : "cbPaisCodigo",
		ajaxLink : '${createLink(controller: "facturaVenta", action:"ajaxGetCodigosPaises")}',
		atributo: 'pais',
		idDefault : '${paisCodigoId}',
		readOnly : hayProforma
	});

	$("#cbPaisCuit").select2({
		placeholder: 'Seleccione un cuit del pais destino para la factura',
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
		comboId : "cbPaisCuit",
		ajaxLink : '${createLink(controller: "facturaVenta", action:"ajaxGetCuitPaises")}',
		atributo: 'pais',
		idDefault : '${paisCuitId}',
		readOnly : hayProforma
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
		ajaxLink : '${createLink(controller: "facturaVenta", action:"ajaxGetAlicuotas")}',
		atributo : 'caption'
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
						"mData": "detalle"
					},{
						"aTargets": [1],
						"mData": "precioUnitario"
					},{
						"aTargets": [2],
						"mData": "cantidad"
					},{
						"aTargets": [3],
						"mData": "neto",
						"visible": (${! esMonotributista})
					},{
						"aTargets": [4],
						"mData": "ivaNombre",
						"visible": (${! esMonotributista})
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
				showItems($('#listItems').dataTable().fnGetPosition(nRow), aData);
			});
		}
	});

	llenarDatoslistItems();

	//Para el datePicker
	if (hayProforma)
		setTimeout(function() {
			const totalProforma = ${proforma?.importe ?: 0}
			const totalProformaString = totalProforma.toFixed(2).replace(".", ",")
			$('#listItems').dataTable().fnAddData({
				detalle: "Servicio Delivery",
				cantidad: 1,
				neto: totalProformaString,
				precioUnitario: totalProformaString,
				ivaNombre: ivaSeleccionado.caption,
				ivaId: ivaSeleccionado.id,
				total: totalProformaString
			});
			$('#itemsFactura').val(JSON.stringify($('#listItems').dataTable().fnGetData()));
			$("#total").val(totalProformaString)
			$("#neto").val(totalProformaString)
			$('#labelTotal').text("$" + totalProformaString);
		}, 375);
	else{
		$("#fecha").dateDropper( {
			dropWidth: 200,
			dropPrimaryColor: "#1abc9c", 
			dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "d/m/Y",
			lang: "es",
			minDate: "${fecMinServ}",
			maxDate: "${fecMaxServ}"
		});

		$("#fechaInicioServicios").dateDropper( {
			dropWidth: 200,
			dropPrimaryColor: "#1abc9c", 
			dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "d/m/Y",
			lang: "es"
		});

		$("#fechaFinServicios").dateDropper( {
			dropWidth: 200,
			dropPrimaryColor: "#1abc9c", 
			dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "d/m/Y",
			maxYear: "${yearMaxFinServ}",
			lang: "es"
		});

		$("#fechaVencimientoPagoServicio").dateDropper( {
			dropWidth: 200,
			dropPrimaryColor: "#1abc9c", 
			dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "d/m/Y",
			lang: "es"
		});
	}

	$("#cbTipo").change(function(){

		if($("#cbTipo").val() == "563091"){
			$("#divIdioma").show();
			$("#divMoneda").show();
			$("#divPais").show();
			$("#divCuitPais").show();
		}else{
			$("#divIdioma").hide();
			$("#divMoneda").hide();
			$("#divPais").hide();
			$("#divCuitPais").hide();
		}

		if($("#cbTipo").val() == "2637465" || $("#cbTipo").val() == "4305867")
			$("#divCbu").show();
		else
			$("#divCbu").hide();
		
		if ($("#cbTipo").val()){
			// Restrinjo el IVA
			comprobanteC = $("#cbTipo").select2('data')[0].text.slice(-1) == 'C'
			if (comprobanteC){
				$("#cbAlicuota").val("${iva0}").trigger('change');
				toggleReadOnlyCombo('cbAlicuota',true)
			}else
				toggleReadOnlyCombo('cbAlicuota',false)
			// Obtengo el número de comprobante:
			$.ajax('${createLink(action:"ajaxGetProximoNumero")}', {
				data: {
					puntoVenta: $("#cbPuntosVenta").val(),
					tipoComprobanteId: $("#cbTipo").val()
				}
			}).done(function(data) {
				$("#numero").val(data)
			});
		}
	});

	$("#cbPuntosVenta").change(function(){
		$("#cbTipo").change();
	});

	$("#cbPaisCodigo").change(function(){
		console.log($("#cbPaisCodigo option:selected").text());
	});

	$("#cbConcepto").change(function(){
		if ($("#cbConcepto").val())
			if ($("#cbConcepto").select2('data')[0].text == "Producto")
				$("#divFechasServicio").hide()
			else
				$("#divFechasServicio").show()
	});

	//Autocompletado de campos

		$("#cbAlicuota").change(function(){
			const alicuotaId = $("#cbAlicuota").val()
			if (alicuotaId){
				$.ajax('${createLink(controller: "facturaVenta", action:"ajaxGetAlicuota")}', {
					dataType: "json",
					data: {
						id: alicuotaId
					}
				}).done(function(data) {
					ivaSeleccionado=data;
					$("#modalNeto").trigger('change');
				});
			}
		});

		$("#modalNeto").change(function(){
			const neto = leerFloat('modalNeto')
			const iva = neto * ivaSeleccionado.valor / 100
			const total = neto + iva;
			$('#modalTotal').val(total.toFixed(2).replace(".", ","));
			const cantidad = leerInt('modalCantidad', 1)
			const unitario = neto / cantidad;
			$('#modalPrecioUnitario').val(unitario.toFixed(2).replace(".", ","));
		});

		$("#modalTotal").change(function(){
			const total = leerFloat('modalTotal')
			const neto = total / (1 + (ivaSeleccionado.valor / 100))
			$('#modalNeto').val(neto.toFixed(2).replace(".", ","));

			const cantidad = leerInt('modalCantidad', 1)
			const unitario = neto / cantidad;
			$('#modalPrecioUnitario').val(unitario.toFixed(2).replace(".", ","));
		});

		$("#modalCantidad").change(function(){
			const cantidad = leerInt('modalCantidad', 1)
			const unitario = leerFloat('modalPrecioUnitario')
			const neto = cantidad*unitario;
			$('#modalNeto').val(neto.toFixed(2).replace(".", ","));

			const iva = neto * ivaSeleccionado.valor / 100
			const total = neto + iva;
			$('#modalTotal').val(total.toFixed(2).replace(".", ","));
		});

		$("#modalPrecioUnitario").change(function(){
			$("#modalCantidad").trigger('change');
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
		$("#numero").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#btnAddItem").focus();
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

		$('#cuit').keyup(function(){

		var key = event.keyCode || event.charCode;
	    if( key == 8 || key == 46 ){
	    	$("#cuitNotFound").hide();
	    	$("#cuitFound").hide();
	        return;
	    }
	  	if (($('#cuit').val().length) >= 11){
		  	var url = $('#urlBuscarCuit').text();
		  	$("#cuitNotFound").hide();
	  		$("#submitLoader").show();
		    $.ajax(url, {
		        dataType: "json",
		        data: {
		            cuit: $("#cuit").val(),
		        }
		    }).done(function(data) {
		    	$("#submitLoader").hide();
		        $('#razonSocial').val(data['razonSocial']);
		        $('#domicilio').val(data['domicilio']);
		        if(data['domicilio'] == null && data['razonSocial'] == null){
		        	$('#alias').val('');
		        	$("#cuitNotFound").show();
		        }
		        else{
		        	$('#alias').val(data['razonSocial']);
	        		$("#cuitFound").show();
	        		$("#cuitNotFound").hide();
        			$("#condicionIvaId").val(data.condicionIvaId)
		        }
		    }); 
	 	}
	});
});

function llenarDatoslistItems(){
	if(($('#facturaVentaId').val()!="") && ($('#facturaVentaId').val()!=null)){
		$.ajax('${createLink(controller: "facturaVenta", action:"ajaxGetListItems")}', {
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
function showItems(index=null, item = null){
	if (!$("#cbTipo").val()){
		swal("","Por favor ingrese el tipo de comprobante antes de seleccionar los items","warning")
		return
	}
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
		$("#modalDetalle").val(item ? item.detalle : "");
		$("#modalNeto").val(item ? item.neto : "0,00");
		$("#modalCantidad").val(item ? item.cantidad : "1");
		if (!comprobanteC)
			$("#cbAlicuota").val(item ? item.ivaId : $('#ivaDefaultId').val()).trigger('change');
	itemSeleccionado = item;
	$('#modalItems').modal('show');
}

function deleteItem(){
	var index2 = leerInt('modalItemsIndex')
	$('#listItems').dataTable().fnDeleteRow(index2);
	$('#itemsFactura').val(JSON.stringify($('#listItems').dataTable().fnGetData()));
	$('#modalItems').modal('hide');

	$('#modalNeto').val("0").trigger('change'); // Para que no sume valores nuevos
	recalcularTotales();
}

function addItem(){
	if ($('#modalDetalle').val()) {
		var cantidad = $('#modalCantidad').val();
		var detalle = $('#modalDetalle').val();
		var neto = $('#modalNeto').val();
		var ivaNombre = ivaSeleccionado.caption;
		var ivaId = ivaSeleccionado.id;
		var total = $('#modalTotal').val();
		const precioUnitario = $('#modalPrecioUnitario').val();
		$('#listItems').dataTable().fnAddData({
			detalle: detalle,
			cantidad: cantidad,
			neto: neto,
			precioUnitario: precioUnitario,
			ivaNombre: ivaNombre,
			ivaId: ivaId,
			total: total
		});
		$('#itemsFactura').val(JSON.stringify($('#listItems').dataTable().fnGetData()));
		
		$('#modalItems').modal('hide');

		recalcularTotales();
		$('#modalPrecioUnitario').val(0);
		$('#modalTotal').val(0);
	}else
		swal("Faltan datos", "Por favor complete el detalle", "error")
}

function updateItem(){
	if ($('#modalDetalle').val()) {
		var index2 = leerInt('modalItemsIndex')
		var detalle = $('#modalDetalle').val();
		var neto = $('#modalNeto').val();
		var cantidad = $('#modalCantidad').val();
		var ivaNombre = ivaSeleccionado.caption;
		var ivaId = ivaSeleccionado.id;
		var total = $('#modalTotal').val();
		const precioUnitario = $('#modalPrecioUnitario').val();
		$('#listItems').dataTable().fnUpdate({
			detalle: detalle,
			cantidad: cantidad,
			neto: neto,
			precioUnitario: precioUnitario,
			ivaNombre: ivaNombre,
			ivaId: ivaId,
			total: total
		},index2);
		$('#itemsFactura').val(JSON.stringify($('#listItems').dataTable().fnGetData()));

		$('#modalItems').modal('hide');

		recalcularTotales();
	}else
		swal("Faltan datos", "Por favor complete el detalle", "error")
}

function recalcularTotales(){
	// Leo los datos actuales:
	let netoActual = leerFloat('neto')
	let ivaActual = leerFloat('iva')
	let netoNoGravadoActual = leerFloat('netoNoGravado')
	let exentoActual = leerFloat('exento')
	let totalActual = leerFloat('total')
	// Si estamos en update o en delete, primero necesitamos deshacer lo que había
	if (itemSeleccionado){
		if (itemSeleccionado.ivaNombre == "No gravado")
			netoNoGravadoActual -= parseFloat(itemSeleccionado.neto.replace(",", "."))
		else if(itemSeleccionado.ivaNombre == "Exento")
			exentoActual -= parseFloat(itemSeleccionado.neto.replace(",", "."))
		else{
			netoActual -= parseFloat(itemSeleccionado.neto.replace(",", "."))
			ivaActual -= (parseFloat(itemSeleccionado.total.replace(",", ".")) - parseFloat(itemSeleccionado.neto.replace(",", ".")))
		}
		totalActual -= parseFloat(itemSeleccionado.total.replace(",", "."))
	}
	// Luego aplicamos los nuevos valores (que si es delete habremos hardcodeado a 0)
	const netoModal = leerFloat('modalNeto')
	const totalModal = leerFloat('modalTotal')
	if (ivaSeleccionado.caption == "No gravado")
		netoNoGravadoActual += netoModal
	else if(ivaSeleccionado.caption == "Exento")
		exentoActual += netoModal
	else{
		netoActual += netoModal
		ivaActual += (totalModal - netoModal)
	}
	totalActual += totalModal
	// Guardamos los resultados en los input
	$('#neto').val(netoActual.toFixed(2).replace(".", ","));
	$('#iva').val(ivaActual.toFixed(2).replace(".", ","));
	$('#netoNoGravado').val(netoNoGravadoActual.toFixed(2).replace(".", ","));
	$('#exento').val(exentoActual.toFixed(2).replace(".", ","));
	$('#total').val(totalActual.toFixed(2).replace(".", ","));

	$('#labelTotal').text('$'+$('#total').val());
	$('#labelNeto').text('$'+$('#neto').val());
	$('#labelIva').text('$'+$('#iva').val());
	$('#labelNoGravado').text('$'+$('#netoNoGravado').val());
	$('#labelExento').text('$'+$('#exento').val());

}
</script>