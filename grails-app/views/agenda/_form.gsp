<g:hiddenField name="clienteProveedorId" value="${clienteProveedorInstance?.clienteProveedorId}" />
<g:hiddenField name="version" value="${clienteProveedorInstance?.version}" />
<g:hiddenField name="path" value="${path}"/>
<g:hiddenField name="alias" value="${clienteProveedorInstance?.alias}"/>
<g:hiddenField name="condicionIvaId" value="${clienteProveedorInstance?.condicionIvaId}"/>

<div style="display: none;">
	<div id="urlBuscarCuit">
	   <g:createLink controller="agenda" action="ajaxGetDatosClienteProveedor"/>
	</div> 
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">CUIT (*)</label>
	<div class="col-sm-4">
		<input id="cuit" name="cuit" type="text" class="form-control ${hasErrors(bean: clienteProveedorInstance, field: 'cuit', 'form-control-danger')}" onkeypress='return isNumberKey(event)' value="${clienteProveedorInstance?.cuit}" maxlength="11">
	</div>
	<div class="col-sm-4" style="align-self: left;">
		<div  id="cuitNotFound" style="display:none;">
			<label style="color:red; font-size: 18px; font-weight: bold;">X </label>
			<label class="col-form-label"> &nbsp;No se ha encontrado el CUIT ingresado</label>
		</div>
        <div class="wrapper" style="position:relative;">
	        <div id="cuitFound" style="position:absolute; height: 15px; width:15px; display: none; margin-top: 7px;">
	        	<i class="fa fa-check" style="color:green; font-size: 18px;"></i>
	        </div>
			<div id="submitLoader" style="position:absolute; height: 15px; width:15px; display: none; margin-top:6px;">
	            <div class="double-bounce1" style="height: 15px; width:15px; margin-top:6px;"></div>
	            <div class="double-bounce2" style="height: 15px; width:15px; margin-top:6px;"></div>
	        </div>
	    </div>
	</div>
</div>

<div class="form-group ${hasErrors(bean: clienteProveedorInstance, field: 'razonSocial', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Razón social (*)</label>
	<div class="col-sm-10">
		<input id="razonSocial" name="razonSocial" type="text" class="form-control ${hasErrors(bean: clienteProveedorInstance, field: 'razonSocial', 'form-control-danger')}" value="${clienteProveedorInstance?.razonSocial}" readonly>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Domicilio (*)</label>
	<div class="col-sm-10">
		<input id="domicilio" name="domicilio" type="text" class="form-control ${hasErrors(bean: clienteProveedorInstance, field: 'domicilio', 'form-control-danger')}" value="${clienteProveedorInstance?.domicilio}" readonly>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Email</label>
	<div class="col-sm-10">
		<input id="email" name="email" type="text" class="form-control ${hasErrors(bean: clienteProveedorInstance, field: 'email', 'form-control-danger')}" value="${clienteProveedorInstance?.email}">
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Nota</label>
	<div class="col-sm-10">
		<textarea class="form-control" id="nota" name="nota" rows="2" class="form-control ${hasErrors(bean: clienteProveedorInstance, field: 'nota', 'form-control-danger')}">${clienteProveedorInstance?.nota}</textarea>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Tipo</label>
	<div class="col-sm-10">
		<input type="checkbox" name="cliente" id="cliente" ${clienteProveedorInstance?.cliente ? 'checked' : ''}> Cliente
 		<input type="checkbox" name="proveedor" ${clienteProveedorInstance?.proveedor ? 'checked' : ''}> Proveedor
	</div>
</div>
<br>
<div class="form-group row">
	<label class="col-sm-2 col-form-label" style="color:grey">(*) Obligatorio</label>
</div>

<script>

$(document).ready(function () {
	if($("#path").val() == 'factura')
		$("#cliente").prop("checked",true);
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
    	if(data['razonSocial'].includes("&#209;"))
    		data['razonSocial'] = data['razonSocial'].replace("&#209;","Ñ")
        $('#razonSocial').val(data['razonSocial']);
        if(data['domicilio'].includes("&#209;"))
    		data['domicilio'] = data['domicilio'].replace("&#209;","Ñ")
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

$('#cuit').change();
</script>