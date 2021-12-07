<!DOCTYPE html>
<html lang="en">
<div style="display: none;">

</div>
<g:hiddenField name="medioPagoId" value="${medioPagoInstance?.medioPagoId}" />
<g:hiddenField name="version" value="${medioPagoInstance?.version}" />

<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Nombre:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <input id="nombre" name="nombre" class="form-control-primary form-control" placeholder="Nombre" value="${medioPagoInstance?.nombre}" style="align-self: left; margin-left: 10px"></input>
    </div>
</div>
<div class="form-group row">
    <div class="col-sm-10">
    	<div class="border-checkbox-section">
	    	<div class="border-checkbox-group border-checkbox-group-primary">
	            <input class="border-checkbox" type="checkbox" name="afip" id="checkboxAfip" ${medioPagoInstance?.afip ? raw('checked') : ''}>
	            <label class="border-checkbox-label" for="checkboxAfip">AFIP</label>
	            <br>
	            <input class="border-checkbox" type="checkbox" name="agip" id="checkboxAgip" ${medioPagoInstance?.agip ? raw('checked') : ''}>
	       		<label class="border-checkbox-label" for="checkboxAgip">AGIP</label>
	            <br>
	            <input class="border-checkbox" type="checkbox" name="arba" id="checkboxArba" ${medioPagoInstance?.arba ? raw('checked') : ''}>
	            <label class="border-checkbox-label" for="checkboxArba">ARBA</label>
	            <br>
	        </div>
    	</div>
    </div>
</div>

<script type="text/javascript">

	var actionName = "${actionName}";

	jQuery(document).ready(function() {

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

		document.getElementById("submitBtn").addEventListener("click", function(event){
			if($("#nombrePlantilla").val() == ""){
				alert("Ingresa un nombre para la plantilla");
                event.preventDefault();
			}
			else{
				if($("#htmlMail").val()==""){
					alert("Ingresa el html del mail a notificar");
                	event.preventDefault();
				}
				else{
					if(($("#tituloApp").val()=="") && ($("#textoApp").val()!="")){
						alert("Ingrese un titulo para la notificacion push");
                		event.preventDefault();
					}
					else{
			            $("#formNotificaciones").submit();
					}
	        	}
	        }
        });
	});

       
		
		
		/*$('#global_filter').keyup(function() {
			tabla.search($('#global_filter').val()).draw();
		});*/
</script>
