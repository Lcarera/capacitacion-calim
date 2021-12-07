<!DOCTYPE html>
<html lang="en">
<div style="display: none;">

</div>
<g:hiddenField name="elementoId" value="${elementoFaqInstance?.elementoId}" />
<g:hiddenField name="version" value="${elementoFaqInstance?.version}" />

<div style="display: none;">
    <div id="urlGetCategoriasFaq">
        <g:createLink controller="elementoFaq" action="ajaxGetCategoriasFaq" />
    </div>
</div>

<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Titulo:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <input id="titulo" name="titulo" class="form-control-primary form-control" placeholder="Titulo" value="${elementoFaqInstance?.titulo}" style="align-self: left; margin-left: 10px"></input>
    </div>
</div>
<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Peso:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <input id="peso" name="peso" class="form-control-primary form-control" placeholder="(De 0 en adelante, 0 es más arriba)" value="${elementoFaqInstance?.peso}"  style="align-self: left; margin-left: 10px"></input>
    </div>
</div>
<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px"> Contenido Html:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <textarea id="contenidoHtml" name="contenidoHtml" rows="8" cols="6" class="form-control-primary form-control" placeholder="Html" style="align-self: left; margin-left: 10px">${elementoFaqInstance?.contenidoHtml}</textarea>
        <button id="btnHtml" name="btnHtml" type="button" style="margin-left: 10px; margin-top: 10px;"> Visualizar HTML </button>
    </div>
</div>
<div class="form-group row">
	<div class="col-sm-10">
		<div class="results" id="results" style="display:none; border:1px solid blue; overflow:hidden; width:1200px; height:500px; margin-left: 10px; overflow-y: scroll;"></div>
	</div>
</div>
<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Categoría:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <select id="cbCategoriaFaq" name="categoriaFaqId" class="form-control"></select>
    </div>
</div>
<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Cuentas Objetivo:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
    	<div class="border-checkbox-section">
	    	<div class="border-checkbox-group border-checkbox-group-primary">
	            <input class="border-checkbox" type="checkbox" name="monotributista" id="checkboxMonotributista" ${elementoFaqInstance?.monotributista ? raw('checked') : ''}>
	            <label class="border-checkbox-label" for="checkboxMonotributista">Monotributista</label>
	            <br>
	            <input class="border-checkbox" type="checkbox" name="respInscripto" id="checkboxRespInscripto" ${elementoFaqInstance?.respInscripto ? raw('checked') : ''}>
	       		<label class="border-checkbox-label" for="checkboxRespInscripto">Autónomo</label>
	            <br>
	            <input class="border-checkbox" type="checkbox" name="regimenSimplificado" id="checkboxSimplificado" ${elementoFaqInstance?.regimenSimplificado ? raw('checked') : ''}>
	            <label class="border-checkbox-label" for="checkboxSimplificado">Simplificado</label>
	            <br>
	            <input class="border-checkbox" type="checkbox" name="convenio" id="checkboxConvenio" ${elementoFaqInstance?.convenio ? raw('checked') : ''}>
	            <label class="border-checkbox-label" for="checkboxConvenio">Convenio</label>
	            <br>
	            <input class="border-checkbox" type="checkbox" name="local" id="checkboxLocal" ${elementoFaqInstance?.local ? raw('checked') : ''}>
	            <label class="border-checkbox-label" for="checkboxLocal">Local</label>
	        </div>
    	</div>
    </div>
</div>

<script type="text/javascript">

	var actionName = "${actionName}";

	jQuery(document).ready(function() {

        $("#cbCategoriaFaq").select2({
        placeholder: '<g:message code="zifras.cuenta.CategoriaFaq.placeHolder" default="Seleccione una categoría"/>',
        formatNoMatches: function() {
            return '<g:message code="default.no.elements" default="No hay elementos"/>';
        },
        formatSearching: function() {
            return '<g:message code="default.searching" default="Buscando..."/>';
        },
        minimumResultsForSearch: 1,
        allowClear: true,
        formatSelection: function(item) {
            return item.text;
        }
        });
        llenarCombo({
            comboId : "cbCategoriaFaq",
            ajaxUrlDiv : 'urlGetCategoriasFaq',
            idDefault : '${cuentaInstance?.categoriaFaqId}',
            atributo : 'nombre'
        });

		function setInputFilter(textbox, inputFilter) {
          ["input", "keydown", "keyup", "mousedown", "mouseup", "select", "contextmenu", "drop"].forEach(function(event) {
            textbox.addEventListener(event, function() {
              if (inputFilter(this.value)) {
                this.oldValue = this.value;
                this.oldSelectionStart = this.selectionStart;
                this.oldSelectionEnd = this.selectionEnd;
              } else if (this.hasOwnProperty("oldValue")) {
                this.value = this.oldValue;
                this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
              } else {
                this.value = "";
              }
            });
          });
        }

        setInputFilter(document.getElementById("peso"), function(value) {
          return /^\d*\.?\d*$/.test(value); // Allow digits and '.' only, using a RegExp
        });

		 window.onload = function(){
			var button = document.getElementById("btnHtml");
			const compileMarkup = () => {
				var markUp = $("#contenidoHtml").val();
				const resultsContainer = document.getElementById("results");
				$("#results").show();
				resultsContainer.innerHTML = markUp
			}
			button.addEventListener('click',compileMarkup,false);
		}
	});		
		
		/*$('#global_filter').keyup(function() {
			tabla.search($('#global_filter').val()).draw();
		});*/
</script>
