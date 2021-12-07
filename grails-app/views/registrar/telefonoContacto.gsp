<!DOCTYPE html>
<html lang="en">

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
                        <g:form name="formPasos" action= "pasosRegistro" class="md-float-material">
                            <g:hiddenField name="pasoActual" value="telefonoContacto"/>
                            <g:hiddenField name="mobile" value="false"/>
                            <g:hiddenField name="volver" value="false"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 8%" aria-valuenow="8" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/><i class="icofont icofont-brand-whatsapp"></i>  ¿Cual es tu celular?<br/>Lo usaremos para ayudarte</h5>
                                    <div class="input-group input-group-register">
                                        <input type="text" name="celular" id="celular" value="${celularCuenta}" class="form-control input-register" placeholder="Ingresa tu número sin guiones">
                                        <span class="md-line"></span>
                                    </div>
                                    
                                    <div class="row m-t-15">
                                        <div class="col-md-12">
                                            <button type="submit" id="submitBtn" class="btn btn-primary btn-md btn-block waves-effect text-center m-b-10">Siguiente</button>
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
    <script>
    $(document).ready(() => {
        var submitButton = document.getElementById("submitBtn");

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

        setInputFilter(document.getElementById("celular"), function(value) {
          return /^\d*\.?\d*$/.test(value); // Allow digits and '.' only, using a RegExp
        });


        document.getElementById("submitBtn").addEventListener("click", function(event){
                if($("#celular").val()=="")
                    alert("Tenes que ingresar tu telefono celular para continuar")
                else{
                    $("#formPasos").submit()
                    $("#submitBtn").attr("disabled", true);
                }
                event.preventDefault();
        });


    });    
    </script>
</body>

</html>
