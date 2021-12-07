<!DOCTYPE html>
<html lang="en">

<div style="display: none;">
    
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
                            <g:hiddenField name="pasoActual" value="ingresoRangoFacturacion"/>
                            <g:hiddenField id="volver" name="volver" value="false"/>
                            <g:hiddenField name="mobile" value="false"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 78%" aria-valuenow="78" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>¿Qué rango de facturación mensual estimás que tendrás?</h5>
                                    <div class="input-group input-group-register">
                                        <div class="form-radio">
                                                <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="rangoFacturacion" id="rango1" value="Menos de 15000" checked="checked">
                                                        <i class="helper"></i>Menos de $15.000/mes
                                                    </label>
                                                </div>
                                                <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="rangoFacturacion" id="rango2" value="Entre 15000 y 50000">
                                                        <i class="helper"></i>Entre $15.000 - $50.000 /mes
                                                    </label>
                                                </div>
                                                <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="rangoFacturacion" id="rango3" value="Entre 50000 y 100000">
                                                        <i class="helper"></i>Entre $50.000 - $100.000 /mes
                                                    </label>
                                                </div>
                                                <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="rangoFacturacion" id="rango4" value="Entre 100000 y 500000">
                                                        <i class="helper"></i>Entre $100.000 - $500.000 /mes
                                                    </label>
                                                </div>
                                                <div class="radio radiofill">
                                                    <label>
                                                        <input type="radio" name="rangoFacturacion" id="rango5" value="Mas de 500000">
                                                        <i class="helper"></i>Más de $500.000/mes
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
        var volverButton = document.getElementById("volverBtn");

        volverButton.onclick = function() {
            $("#volver").val("true");
            $("#formStep").submit();
        };
    });
    </script>
</body>

</html>
