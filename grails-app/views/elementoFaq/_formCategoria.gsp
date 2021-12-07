<!DOCTYPE html>
<html lang="en">
<div style="display: none;">

</div>
<g:hiddenField name="categoriaId" value="${categoriaFaqInstance?.categoriaId}" />
<g:hiddenField name="version" value="${categoriaFaqInstance?.version}" />

<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Titulo:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <input id="nombre" name="nombre" class="form-control-primary form-control" placeholder="Nombre" value="${categoriaFaqInstance?.nombre}" style="align-self: left; margin-left: 10px"></input>
    </div>
</div>
<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Peso:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <input id="peso" name="peso" class="form-control-primary form-control" placeholder="(De 0 en adelante, 0 es más arriba)" value="${categoriaFaqInstance?.peso}"  style="align-self: left; margin-left: 10px"></input>
    </div>
</div>

<script type="text/javascript">

	var actionName = "${actionName}";

	jQuery(document).ready(function() {

        setInputFilter(document.getElementById("peso"), function(value) {
          return /^\d*\.?\d*$/.test(value); // Allow digits and '.' only, using a RegExp
        });
	});		
</script>
