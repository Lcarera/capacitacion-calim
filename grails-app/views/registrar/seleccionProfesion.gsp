<!DOCTYPE html>
<html lang="en">

<div style="display: none;">
    <div id="urlSeleccionarApps">
            <g:createLink controller="Registrar" action="seleccionApps" />
    </div>
    <div id="urlPoseeCuit">
        <g:createLink controller="Registrar" action="poseeCUIT" />
    </div>
    <div id="urlTelefonoContacto">
        <g:createLink controller="Registrar" action="telefonoContacto" />
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
                        <g:form name="formStep" action="pasosRegistro" class="md-float-material">
                            <g:hiddenField name="pasoActual" value="seleccionProfesion"/>
                            <g:hiddenField id="volver" name="volver" value="false"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 14%" aria-valuenow="14" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/> Contanos de qué trabajás para brindarte mejor servicio</h5>
                                    <div class="input-group input-group-register">
                                        <div class="form-radio">
                                            <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="profesion" id="mercadolibre" value="mercadolibre" checked="checked">
                                                        <i class="helper"></i>Cobro con MercadoPago / Vendo por MercadoLibre
                                                    </label>
                                                </div>
                                                <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="profesion" id="app" value="app">
                                                        <i class="helper"></i>Trabajo para una APP (Rappi, PedidosYa, UBER, etc.)
                                                    </label>
                                                </div>
                                                <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="profesion" id="profesional" value="profesional">
                                                        <i class="helper"></i>Soy profesional independiente
                                                    </label>
                                                </div>
                                                <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="profesion" id="oficio" value="oficio">
                                                        <i class="helper"></i>Tengo un oficio independiente
                                                    </label>
                                                </div>
                                                <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="profesion" id="comercio" value="comercio">
                                                        <i class="helper"></i>Tengo un comercio (local)
                                                    </label>
                                                </div>
                                                <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="profesion" id="otro" value="otro">
                                                        <i class="helper"></i>Otro
                                                    </label>
                                                </div>
                                        </div>
                                        <span class="md-line"></span>
                                    </div>
                                    <hr/>
                                    <div class="row">
                                        <div class="col-6">
                                            <button id="volverBtn" type="button" style="width:100%" class="btn btn-default block waves-effect" onclick="volver();">Volver</button>
                                        </div>
                                        <div class="col-6">
                                            <button id="submitBtn" type="submit" style="width:100%" class="btn btn-primary block waves-effect">Siguiente</button>
                                        </div>
                                    </div>
                            </div>
                            </g:form>
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
        document.getElementById("volverBtn").onclick = function() {
            $("#volver").val("true");
            $("#volverBtn").attr("disabled", true);
            $("#submitBtn").attr("disabled", true);
            $("#formStep").submit();
        };

        document.getElementById("submitBtn").onclick = function() {
            $("#volverBtn").attr("disabled", true);
            $("#submitBtn").attr("disabled", true);
            $("#formStep").submit();
        };
    });
    </script>
</body>

</html>
