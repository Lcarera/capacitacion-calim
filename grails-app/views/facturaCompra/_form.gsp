<g:hiddenField name="facturaCompraId" value="${facturaCompraInstance?.facturaCompraId}" />
<g:hiddenField name="id" value="${facturaCompraInstance?.facturaCompraId}" />
<g:hiddenField name="version" value="${facturaCompraInstance?.version}" />

<div style="display: none;">
	<div id="urlGetCuentas">
		<g:createLink controller="cuenta" action="ajaxGetCuentasNombresSQL" />
	</div>
	<div id="urlGetPersonas">
		<g:createLink controller="persona" action="ajaxGetProveedoresPorCuenta" />
	</div>
	<div id="urlBuscarCuit">
	   <g:createLink controller="agenda" action="ajaxGetDatosClienteProveedor"/>
	</div> 
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Cuenta</label>
	<div class="col-sm-10">
		<input id="cuentaId" name="cuentaId" type="text" class="form-control ${hasErrors(bean: facturaCompraInstance, field: 'puntoVenta', 'form-control-danger')}" value="${facturaCompraInstance?.cuentaId}" readonly="true">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Fecha</label>
	<div class="col-sm-10">
		<input name="fecha" id="fecha" type="text" class="form-control" data-format="d/m/Y" placeholder="Seleccione un día" value="${facturaCompraInstance?.fecha?.toString('dd/MM/yyyy')}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Proveedor</label>
	<div class="col-sm-9">
		<select id="cbProveedor" name="proveedorId"></select>
	</div>
	<div class="col-sm-1">
		<button id="btnAgregarProveedor" type="button" class="btn btn-success" onclick="$('#modalAgregarProveedor').modal('show')">+</button>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Tipo</label>
	<div class="col-sm-10">
		<select id="cbTipo" name="tipoId"></select>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Número</label>
	<div class="col-sm-2">
		<input id="puntoVenta" name="puntoVenta" type="text" class="form-control ${hasErrors(bean: facturaCompraInstance, field: 'puntoVenta', 'form-control-danger')}" onkeypress='return isNumberKey(event)' value="${facturaCompraInstance?.puntoVenta}">
	</div> 
	<div class="col-sm-8">
		<input id="numero" name="numero" type="text" class="form-control ${hasErrors(bean: facturaCompraInstance, field: 'numero', 'form-control-danger')}" onkeypress='return isNumberKey(event)' value="${facturaCompraInstance?.numero}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Neto Gravado</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="netoGravado" name="netoGravado" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'netoGravado', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.netoGravado}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Composición Neto</label>
	<div class="col-sm-3">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">21% $</span>
			<input id="netoGravado21" name="netoGravado21" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'netoGravado21', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.netoGravado21}">
		</div>
	</div>
	<div class="col-sm-3">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">10,5% $</span>
			<input id="netoGravado10" name="netoGravado10" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'netoGravado10', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.netoGravado10}">
		</div>
	</div>
	<div class="col-sm-3">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">27% $</span>
			<input id="netoGravado27" name="netoGravado27" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'netoGravado27', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.netoGravado27}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Neto No Gravado</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="netoNoGravado" name="netoNoGravado" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'netoNoGravado', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.netoNoGravado}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">IVA</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="iva" name="iva" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'iva', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.iva}">
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Exento</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="exento" name="exento" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'exento', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.exento}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Composición Iva</label>
	<div class="col-sm-3">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">21% $</span>
			<input id="iva21" name="iva21" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'iva21', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.iva21}">
		</div>
	</div>
	<div class="col-sm-3">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">10,5% $</span>
			<input id="iva10" name="iva10" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'iva10', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.iva10}">
		</div>
	</div>
	<div class="col-sm-3">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">27% $</span>
			<input id="iva27" name="iva27" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'iva27', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.iva27}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Total</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="total" name="total" type="text" class="form-control autonumber ${hasErrors(bean: facturaCompraInstance, field: 'total', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${facturaCompraInstance?.total}">
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
		idDefault : '${facturaCompraInstance?.cuentaId}',
		atributo : 'toString',
		readOnly: (actionName == "edit")
	});
	
	$("#cbCuenta").change(function(){
		llenarCombo({
			comboId : "cbProveedor",
			ajaxUrlDiv : 'urlGetPersonas',
			atributo : 'toString',
			parametros : {
				'id': $("#cbCuenta").val()
			}
		});
	});
	
	/*** CBO PROVEEDOR ***/
	$("#cbProveedor").select2({
		placeholder: '<g:message code="zifras.facturacion.Persona.placeHolder" default="Seleccione un proveedor"/>',
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
		comboId : "cbProveedor",
		ajaxUrlDiv : 'urlGetPersonas',
		idDefault : '${facturaCompraInstance?.proveedorId}',
		atributo : 'toString',
		parametros : {
			'id': '${facturaCompraInstance?.cuentaId}'
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
		ajaxLink : '${createLink(controller:"tipoComprobante", action:"ajaxGetTiposComprobante")}',
		idDefault : '${facturaCompraInstance?.tipoId}'
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

    //Autocompletado de campos
	
	$("#iva21").change(function(){
		leerTodo();
		calcularTodoPorIvas();
	});
	
	$("#iva27").change(function(){
		leerTodo();
		calcularTodoPorIvas();
	});
	
	$("#iva10").change(function(){
		leerTodo();
		calcularTodoPorIvas();
	});
	
	$("#exento").change(function(){
		leerTodo();
		calcularTotal();
	});
	
	$("#netoNoGravado").change(function(){
		leerTodo();
		calcularTotal();
	});
	
	$("#netoGravado21").change(function(){
		leerTodo();
		calcularTodoPorNetos();
	});
	
	$("#netoGravado27").change(function(){
		leerTodo();
		calcularTodoPorNetos();
	});
	
	$("#netoGravado10").change(function(){
		leerTodo();
		calcularTodoPorNetos();
	});

	$("#iva").change(function(){
		//Leo los datos
		leerTodo();
		//Calculo la diferencia entre los ivas para ver cuánto cambió el 21
		iva21= iva - iva10 - iva27;
		var pisarIva = false;
		if (iva21<0){ //Antes de asginarlo, me fijo que no sea negativo y si es negativo lo dejo en 0.
			iva21=0;
			pisarIva = true;
		}
		$('#iva21').val(iva21.toFixed(2).replace(".", ","));
		calcularTodoPorIvas(pisarIva);
	});

	$("#netoGravado").change(function(){
		leerTodo();
		//Calculo la diferencia entre los netos 
		netoGravado21 = netoGravado - netoGravado10 - netoGravado27;
		var pisarNeto = false;
		if (netoGravado21<0){ //Antes de asginarlo, me fijo que no sea negativo y si es negativo lo dejo en 0.
			netoGravado21=0;
			pisarNeto=true;
		}
		$('#netoGravado21').val(netoGravado21.toFixed(2).replace(".", ","));
		calcularTodoPorNetos(pisarNeto);
	});

	$('#cuit').keyup(function(){
		console.log("aaaaaaa");
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

	$("#total").change(function(){
		leerTodo();

		//La lógica de la cuenta es que agarra el total total, y le resta los Iva27 y Iva10, también le resta lo que vendrían a ser los netos de estos dos, el no gravado y el exento. Entonces nos quedaría como resultado lo que hubiera sido el total si sólo existiera el Iva21
		total21 = total - (Math.round((iva27 /0.27) * 100) / 100) - (Math.round((iva10 /0.105) * 100) / 100) - iva27 - iva10 - exento - netoNoGravado;
		//Entonces a partir de ese total le saco el iva para construir el neto
		netoGravado21 = (Math.round((total21 / 1.21) * 100) / 100);
		//Y al neto lo multiplico por 21% para obtener el iva con el que haremos el resto de los cálculos
		iva21 = (Math.round((netoGravado21 * 0.21) * 100) / 100);
		$('#iva21').val(iva21.toFixed(2).replace(".", ","));

		if (iva21<0){ //Si es negativo, lo pongo en 0 y hago todas las cuentas.
			iva21=0;
			$('#iva21').val(iva21.toFixed(2).replace(".", ","));
			calcularTodoPorIvas();
		}else{
			//Guardo el nuevo iva21
			$('#iva21').val(iva21.toFixed(2).replace(".", ","));
			//Piso el IVA
			calcularIva();
			//Piso el neto
			calcularNetosPorIvas();
		}
	});
	
	//Lógica de focus al presionar enter
		$("#fecha").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#proveedorId").focus().select();
			}
		});
		$("#proveedorId").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#tipo").focus().select();
			}
		});
		$("#tipo").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#puntoVenta").focus().select();
			}
		});
		$("#puntoVenta").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#numero").focus().select();
			}
		});
		$("#numero").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#netoGravado").focus().select();
			}
		});
		$("#netoGravado").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#netoGravado21").focus().select();
			}
		});
		$("#netoGravado21").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#netoGravado10").focus().select();
			}
		});
		$("#netoGravado10").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#netoGravado27").focus().select();
			}
		});
		$("#netoGravado27").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#netoNoGravado").focus().select();
			}
		});
		$("#netoNoGravado").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#iva").focus().select();
			}
		});
		$("#iva").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#exento").focus().select();
			}
		});
		$("#exento").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#iva21").focus().select();
			}
		});
		$("#iva21").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#iva10").focus().select();
			}
		});
		$("#iva10").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#iva27").focus().select();
			}
		});
		$("#iva27").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#total").focus().select();
			}
		});
		$("#total").on('keydown', function(event) {
			if(event.key === "Enter") {
				event.preventDefault();
				$("#botonAceptar").focus();
			}
		});
});
function leerTodo(){
	if(($('#iva').val()!="") && ($('#iva').val()!=null)){
		iva = parseFloat($('#iva').val().replace(",", "."));
	}else{
		iva = 0;
	}
	if(($('#iva27').val()!="") && ($('#iva27').val()!=null)){
		iva27 = parseFloat($('#iva27').val().replace(",", "."));
	}else{
		iva27 = 0;
	}
	if(($('#iva10').val()!="") && ($('#iva10').val()!=null)){
		iva10 = parseFloat($('#iva10').val().replace(",", "."));
	}else{
		iva10 = 0;
	}
	if(($('#iva21').val()!="") && ($('#iva21').val()!=null)){
		iva21 = parseFloat($('#iva21').val().replace(",", "."));
	}else{
		iva21 = 0;
	}
	if(($('#netoNoGravado').val()!="") && ($('#netoNoGravado').val()!=null)){
		netoNoGravado = parseFloat($('#netoNoGravado').val().replace(",", "."));
	}else{
		netoNoGravado = 0;
	}
	if(($('#netoGravado21').val()!="") && ($('#netoGravado21').val()!=null)){
		netoGravado21 = parseFloat($('#netoGravado21').val().replace(",", "."));
	}else{
		netoGravado21 = 0;
	}
	if(($('#netoGravado10').val()!="") && ($('#netoGravado10').val()!=null)){
		netoGravado10 = parseFloat($('#netoGravado10').val().replace(",", "."));
	}else{
		netoGravado10 = 0;
	}
	if(($('#netoGravado27').val()!="") && ($('#netoGravado27').val()!=null)){
		netoGravado27 = parseFloat($('#netoGravado27').val().replace(",", "."));
	}else{
		netoGravado27 = 0;
	}
	if(($('#netoGravado').val()!="") && ($('#netoGravado').val()!=null)){
		netoGravado = parseFloat($('#netoGravado').val().replace(",", "."));
	}else{
		netoGravado = 0;
	}
	if(($('#exento').val()!="") && ($('#exento').val()!=null)){
		exento = parseFloat($('#exento').val().replace(",", "."));
	}else{
		exento = 0;
	}
	if(($('#total').val()!="") && ($('#total').val()!=null)){
		total = parseFloat($('#total').val().replace(",", "."));
	}else{
		total = 0;
	}
}
function calcularTodoPorIvas(pisarIva = true){
	if (pisarIva) {
		calcularIva();
	}
	calcularNetosPorIvas();
	calcularTotal();
}

function calcularIva(){
	iva= iva10+iva27+iva21;
	$('#iva').val(iva.toFixed(2).replace(".", ","));	
}

function calcularTodoPorNetos(pisarNeto = true){
	if (pisarNeto) {
		calcularNeto();
	}
	calcularIvasPorNetos();
	calcularTotal();
}

function calcularNeto(){
	netoGravado = netoGravado21 + netoGravado27 + netoGravado10;
	$('#netoGravado').val(netoGravado.toFixed(2).replace(".", ","));
}

function calcularNetosPorIvas() {
	netoGravado21=(Math.round((iva21 / 0.21) * 100) / 100);
	$('#netoGravado21').val(netoGravado21.toFixed(2).replace(".", ","));
	netoGravado27=(Math.round((iva27 / 0.27) * 100) / 100);
	$('#netoGravado27').val(netoGravado27.toFixed(2).replace(".", ","));
	netoGravado10=(Math.round((iva10 / 0.105) * 100) / 100);
	$('#netoGravado10').val(netoGravado10.toFixed(2).replace(".", ","));
	calcularNeto();
}

function calcularIvasPorNetos() {
	iva21 = Math.round((netoGravado21 * 0.21) * 100) / 100 ;
	$('#iva21').val(iva21.toFixed(2).replace(".", ","));
	iva27 = Math.round((netoGravado27 * 0.27) * 100) / 100 ;
	$('#iva27').val(iva27.toFixed(2).replace(".", ","));
	iva10 = Math.round((netoGravado10 * 0.105) * 100) / 100 ;
	$('#iva10').val(iva10.toFixed(2).replace(".", ","));

	calcularIva();
}

function calcularTotal() {
	total = netoGravado + iva + netoNoGravado + exento;
	$('#total').val(total.toFixed(2).replace(".", ","));
}
</script>