<!DOCTYPE html>
<html lang="en">

<div style="display: none;">
    <div id="urlGetNacionalidades">
        <g:createLink controller="cuenta" action="ajaxGetNacionalidades" />
    </div>
    <div id="urlVolver">
        <g:createLink controller="registrar" action="pasosRegistro" params="[accion:'volver']"/>
    </div>
</div>

<head>
    <meta name="layout" content="registroLayout">
</head>

<body class="fix-menu">
     <!-- Google Tag Manager (noscript) -->
    <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-NPFKM22" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!-- End Google Tag Manager (noscript) -->
    
    <section class="login p-fixed d-flex text-center bg-primary common-img-bg">
        <!-- Pre-loader start -->
    <div class="theme-loader" id="loaderGeneral">
            <div class="ball-scale">
                <div class='contain'>
                    <div class="ring"><div class="frame"></div></div>
                    <div class="ring"><div class="frame"></div></div>
                    <div class="ring"><div class="frame"></div></div>
                    <div class="ring"><div class="frame"></div></div>
                    <div class="ring"><div class="frame"></div></div>
                    <div class="ring"><div class="frame"></div></div>
                    <div class="ring"><div class="frame"></div></div>
                    <div class="ring"><div class="frame"></div></div>
                    <div class="ring"><div class="frame"></div></div>
                    <div class="ring"><div class="frame"></div></div>
                </div>
            </div>
        </div>

        <!-- Container-fluid starts -->
        <div class="container">
            <div class="row">
                <div class="col-sm-12">
                    <!-- Authentication card start -->
                    <div class="signup-card auth-body mr-auto ml-auto">
                        <g:form action="pasosRegistro" class="md-float-material" name="formIngresoDNI">
                        <g:hiddenField name="mobile" value="false"/>
                        <g:hiddenField name="pasoActual" value="ingresoDNI"/>
                        <g:hiddenField name="volver" value="false"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 55%" aria-valuenow="55" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>¿Cuál es tu nacionalidad?</h5>
                                <div class="input-group input-group-register m-b-20">
                                    <select id="cbNacionalidad" name="nacionalidadId" class="form-control input-register"></select>
                                    <span class="md-line"></span>
                                </div>
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>¿Cúal es tu documento?</h5>
                                <div class="form-radio text-left m-b-20">
                                    <div class="radio radiofill radio-inline">
                                        <label style="color:black">
                                            <input type="radio" name="tipoDocumento" id="dni" value="dni" checked="checked">
                                            <i class="helper"></i>DNI
                                        </label>
                                    </div>
                                    <div class="radio radiofill radio-inline">
                                        <label style="color:black">
                                            <input type="radio" name="tipoDocumento" id="pasaporte" value="pasaporte">
                                            <i class="helper"></i>Pasaporte
                                        </label>
                                    </div>
                                    <div class="radio radiofill radio-inline">
                                        <label style="color:black">
                                            <input type="radio" name="tipoDocumento" id="precaria" value="precaria">
                                            <i class="helper"></i>Precaria
                                        </label>
                                    </div>
                                </div>
                                    <div class="input-group input-group-register m-b-20">
                                        <input type="text" name="documento" id="documento" value="${dniCuenta}" class="form-control input-register" placeholder="Numero Documento">
                                    </div>

                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>¿Cuál es tu sexo?</h5>
                                <div class="form-radio text-left m-b-20">
                                    <div class="radio radiofill radio-inline">
                                        <label style="color:black">
                                            <input type="radio" name="sexo" id="hombre" value="hombre" checked="checked">
                                            <i class="helper"></i>Masculino
                                        </label>
                                    </div>
                                    <div class="radio radiofill radio-inline">
                                        <label style="color:black">
                                            <input type="radio" name="sexo" id="mujer" value="mujer">
                                            <i class="helper"></i>Femenino
                                        </label>
                                    </div>
                                </div>
                                
                                <hr/>
                                <input type="hidden" id="provinciaId" name="provinciaId" value="19">
                                <div class="row">
                                    <div class="col-6">
                                        <button id="volverBtn" type="button" style="width:100%" class="formBtn btn btn-default block waves-effect">Volver</button>
                                   </div>
                                   <div class="col-6">
                                        <button id="submitBtn" type="submit" style="width:100%" class="formBtn btn btn-primary block waves-effect">Siguiente</button>
                                   </div>
                                </div>
                            </div>
                        </g:form>
                        <!-- end of form -->
                    </div>
                    <!-- Authentication card end -->
                </div>
                <!-- end of col-sm-12 -->
            </div>
            <!-- end of row -->
        </div>
        <!-- end of container-fluid -->
    </section>
   <script type="text/javascript">

    function llenarCombo(params){
        var comboId = params.comboId;
        var ajaxUrlDiv = params.hasOwnProperty("ajaxUrlDiv") ? params.ajaxUrlDiv : null;
        var ajaxLink = params.hasOwnProperty("ajaxLink") ? params.ajaxLink : null;
        var idDefault = params.hasOwnProperty("idDefault") ? params.idDefault : null;
        var datosPasar = params.hasOwnProperty("parametros") ? params.parametros : null;
        var atributo = params.hasOwnProperty("atributo") ? params.atributo : "nombre";
        var readOnly = params.hasOwnProperty("readOnly") ? params.readOnly : false;

        var combo = $("#"+comboId)
        combo.children('option').remove();
        var urlDestino = ajaxLink != null ? ajaxLink : $('#' + ajaxUrlDiv).text();

        $.ajax(urlDestino, {
            dataType: "json",
            data:datosPasar
        }).done(function(data) {
            $.map(data, function(item) {
                var seleccionado = item.id==idDefault
                combo.append(new Option(item[atributo], item.id, seleccionado, seleccionado));
            });

            if(idDefault!=null)
                combo.val(idDefault);
            if (combo.val())
                combo.trigger("change");

            if (readOnly)
                toggleReadOnlyCombo(comboId);
        });
    }
    
    function toggleReadOnlyCombo(comboId, valorAbsoluto = null){
        var combo = $('#' + comboId);
        var divId = "div" + comboId + "Text";
        var divConLabel = $("#" + divId);
        if(divConLabel.length){ // El div con texto ya existía, así que en lugar de volverlo a crear muestro y oculto respectivamente el combo y el div.
            var texto = (combo.select2('data')[0]!=null) ? combo.select2('data')[0].text : ''
            divConLabel.text(texto);
            if (valorAbsoluto == null){
                combo.next(".select2-container").toggle();
                divConLabel.toggle();
            }else if (valorAbsoluto == true){
                combo.next(".select2-container").hide();
                divConLabel.show();
            }else{
                combo.next(".select2-container").show();
                divConLabel.hide();
            }
        }else if (valorAbsoluto == null || valorAbsoluto == true) // Creo el div con el texto
            setTimeout(function() {
                var texto = (combo.select2('data')[0]!=null) ? combo.select2('data')[0].text : ''
                $("<div/>", {
                  text: texto,
                  id: divId,
                  "class": "texto-select2-readonly",
                  "style": "display:none",
                  appendTo: combo.parent()
                });
                combo.next(".select2-container").hide(); // Oculto el combo
            }, 200);
    }

    $(document).ready(function () {

        llenarCombo({
            comboId : "cbNacionalidad",
            ajaxLink : '${createLink(controller:"cuenta", action:"ajaxGetNacionalidades")}'
        });
        
        function forceKeyPressUppercase(e)
          {
            var charInput = e.keyCode;
            if((charInput >= 97) && (charInput <= 122)) { // lowercase
              if(!e.ctrlKey && !e.metaKey && !e.altKey) { // no modifier key
                var newChar = charInput - 32;
                var start = e.target.selectionStart;
                var end = e.target.selectionEnd;
                e.target.value = e.target.value.substring(0, start) + String.fromCharCode(newChar) + e.target.value.substring(end);
                e.target.setSelectionRange(start+1, start+1);
                e.preventDefault();
              }
            }
          }

        document.getElementById("documento").addEventListener("keypress", forceKeyPressUppercase, false);

        var volverButton = document.getElementById("volverBtn");
        volverButton.onclick = function() {
            $("#volver").val("true");
            $(".formBtn").attr("disabled", true);
            $("#formIngresoDNI").submit();
        };


        document.getElementById("submitBtn").addEventListener("click", function(event){
                if($("#documento").val()==""){
                    alert("Tenes que ingresar algún documento para continuar")
                }else{
                    $(".formBtn").attr("disabled", true);
                    $("#formIngresoDNI").submit();
                }
                event.preventDefault();
        });
    });    
    </script>
</body>

</html>
