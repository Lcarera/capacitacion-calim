<!DOCTYPE html>
<html lang="en">
<div style="display:none;">
    <div id="urlVolver">
        <g:createLink controller="registrar" action="pasosRegistro" params="[accion:'volver']"/>
    </div>
</div>
<head>
  <meta name="layout" content="registroLayout">
<script type="text/javascript">
    var cuitValido = false;

        function validarCuit(elemento){
            var valor = elemento.val();
            if (valor.length != 11){
                elemento.addClass('is-invalid');
                cuitValido = false;
                return;
            }
            if (!(['20', '23', '24', '27', '30', '33', '34'].includes(valor.slice(0,2)))){
                elemento.addClass('is-invalid');
                cuitValido = false;
                return;
            }
            elemento.removeClass('is-invalid');
            cuitValido = true;
            return;
        }
</script>
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
                        <g:form action="pasosRegistro" class="md-float-material" name="formIngresoCUIT">
                            <g:hiddenField name="pasoActual" value="ingresoCUIT"/>
                            <g:hiddenField name="mobile" value="false"/>
                            <g:hiddenField name="volver" value="false"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <g:if test="${flash.error}">
                                    <div class="alert alert-danger background-danger">
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <i class="icofont icofont-close-line-circled text-white"></i>
                                        </button>
                                        <strong>${flash.error}</strong>
                                    </div>
                                </g:if>
                                
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>¿Cual es tu CUIT?</h5>
                                    <div class="input-group input-group-register">
                                        <input onkeyup="validarCuit($(this));" type="text" name="cuit" id="cuit" class="form-control input-register" placeholder="Ingresa tu CUIT sin guiones">
                                        <span class="md-line"></span>
                                    </div>
                                    <hr/>
                                    <div class="row">
                                        <g:if test="${tiendaNube}">
                                            <div class="col-12">
                                                <button id="submitBtn" type="submit" style="width:100%" class="btn btn-primary block waves-effect">Siguiente</button>
                                                <button id="volverBtn" style="display: none;">Volver</button>
                                           </div>

                                       </g:if>
                                       <g:else>
                                            <div class="col-6">
                                                <button id="volverBtn" type="button" style="width:100%" class="formBtn btn btn-default block waves-effect">Volver</button>
                                            </div>
                                            <div class="col-6">
                                                <button id="submitBtn" type="submit" style="width:100%" class="formBtn btn btn-primary block waves-effect">Siguiente</button>
                                           </div>
                                       </g:else>
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
    <script>
    $(document).ready(() => {

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

        setInputFilter(document.getElementById("cuit"), function(value) {
          return /^\d*\.?\d*$/.test(value); // Allow digits and '.' only, using a RegExp
        });


        document.getElementById("submitBtn").addEventListener("click", function(event){
                if(!cuitValido){
                    alert("El CUIT es inválido");
                    event.preventDefault();
                }
                else{
                    $(".formBtn").attr("disabled", true);
                    $("#formIngresoCUIT").submit();
                }
        });

        var volverButton = document.getElementById("volverBtn");

        volverButton.onclick = function() {
            $("#volver").val("true");
            $("#formIngresoCUIT").submit();
            $(".formBtn").attr("disabled", true);
        };  
    });    
    </script>
</body>

</html>
