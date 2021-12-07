<!DOCTYPE html>
<html lang="en">

<%@ page import="com.zifras.User" %>
<div style="display: none;">
	<div id="urlEnviarNotificaciones">
		<g:createLink controller="notificacion" action="ajaxEnviarNotificacionesPersonalizadas" />
	</div>
</div>
<g:hiddenField name="notificacionTemplateId" value="${notificacionTemplateInstance?.notificacionTemplateId}" />
<g:hiddenField name="version" value="${notificacionTemplateInstance?.version}" />

<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px"><label style="font-size: 12px; margin-bottom:10px;">(*)</label> Nombre:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <input id="nombre" name="nombre" class="form-control-primary form-control" placeholder="Nombre" value="${notificacionTemplateInstance?.nombre}" style="align-self: left; margin-left: 10px"></input>
    </div>
</div>
<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px"><label style="font-size: 12px; margin-bottom:10px;">(*)</label> Asunto Mail:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <input id="asuntoEmail" name="asuntoEmail" class="form-control-primary form-control" placeholder="Asunto" value="${notificacionTemplateInstance?.asuntoEmail}"  style="align-self: left; margin-left: 10px"></input>
    </div>
</div>
<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px"><label style="font-size: 12px; margin-bottom:10px;">(*)</label> Html Mail:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <textarea id="cuerpoEmail" name="cuerpoEmail" rows="8" cols="6" class="form-control-primary form-control" placeholder="Html" style="align-self: left; margin-left: 10px">${notificacionTemplateInstance?.cuerpoEmail}</textarea>
        <button id="btnHtml" name="btnHtml" type="button" style="margin-left: 10px; margin-top: 10px;"> Visualizar HTML </button>
    </div>
</div>
<div class="form-group row">
	<div class="col-sm-10">
		<div class="results" id="results" style="display:none; border:1px solid blue; overflow:hidden; width:1200px; height:500px; margin-left: 10px; overflow-y: scroll;"></div>
	</div>
</div>
<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Titulo App:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <input id="tituloApp" name="tituloApp" class="form-control-primary form-control" placeholder="Titulo" value="${notificacionTemplateInstance?.tituloApp}" style="align-self: left; margin-left: 10px"></input>
    </div>
</div>
<div class="d-inline">
    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Texto App:</h5>
</div>
<div class="form-group row">
    <div class="col-sm-10">
        <input id="textoApp" name="textoApp" class="form-control-primary form-control" placeholder="Texto" value="${notificacionTemplateInstance?.textoApp}" style="align-self: left; margin-left: 10px"></input>
    </div>
</div>

<div class="col-sm-10">
	(*) Campos Obligatorios
</div>
<br></br>

<script type="text/javascript">

	var actionName = "${actionName}";

	jQuery(document).ready(function() {

		if(actionName == "editTemplate"){
			$("#nombre").attr('readonly', true);
		}

		 window.onload = function(){
			var button = document.getElementById("btnHtml");
			const compileMarkup = () => {
				var markUp = $("#cuerpoEmail").val();
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
