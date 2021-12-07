<!DOCTYPE html>
<html lang="en">

<head>
    <meta name="layout" content="registroLayout">
    <script type="text/javascript">
    var cuitValido = false;

        function chequearLength(elemento){
            var valor = elemento.val();
            if (valor.length == 4){
                $("#codigoDescuento2").focus();
                return;
            }
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
                        <g:form name="formPasos" action= "pasosRegistro" class="md-float-material">
                            <g:hiddenField name="pasoActual" value="poseeCodigoDescuento"/>
                            <g:hiddenField name="mobile" value="false"/>
                            <g:hiddenField name="volver" value="false"/>
                            <g:hiddenField name="error" value="${error}"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 8%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>¿Tenés un código de descuento?</h5>
                                <div class="input-group input-group-register">
                                    <input type="text" style="text-transform: uppercase;" name="codigoDescuento1" id="codigoDescuento1" class="form-control input-register" maxlength="4" placeholder="XXXX" onkeyup="chequearLength($(this));">
                                    <h4 style="color: grey; margin-top: 8px;">&nbsp - &nbsp</h4>
                                    <input type="text" style="text-transform: uppercase;" name="codigoDescuento2" id="codigoDescuento2" class="form-control input-register" maxlength="4" placeholder="XXXX">
                                    <span class="md-line"></span>
                                </div>
                                
                                <br>
                                <div class="row">
                                    <div class="col-6">
                                        <button id="volverBtn" type="button" style="width:100%" class="formBtn btn btn-default block waves-effect">Volver</button>
                                    </div>
                                    <div class="col-6">
                                        <button id="submitBtn" type="submit" style="width:100%" class="formBtn btn btn-primary block waves-effect">Siguiente</button>
                                    </div>
                                </div>
                                <br>
                                <div class="row">
                                    <div class="col-12">
                                        <button id="omitirBtn" type="submit" style="width:100%" class="formBtn btn btn-danger block waves-effect">Omitir</button>
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
    $(document).ready(() => {
        var error = $("#error").val()
        if(error != ""){
            //swal("error",error,"error");
            alert(error);
        }
    });    
    </script>
</body>

</html>
