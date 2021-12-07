<!DOCTYPE html>
<html lang="en">
<div style="display: none;">
    <div id="urlResultadoMonotributo">
        <g:createLink controller="registrar" action="pasosRegistro" params="[accion:'resultadoMonotributo']" />
    </div>
    <div id="urlPago">
        <g:createLink controller="registrar" action="pasosRegistro" params="[accion:'linkDePago']" />
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
                        <g:form class="md-float-material" action="pasosRegistro" name="formResumen">
                            <g:hiddenField name="volver" value="false"/>
                            <g:hiddenField name="pasoActual" value="resumen"/>
                            <g:hiddenField name="mobile" value="false"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 98%" aria-valuenow="98" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>Valor del trámite de Alta Monotributo</h5>
                                <g:if test="${cuentaRappi}">
                                    <h6 style="color:grey">¡Somos partners de Rappi!, este trámite cuenta con un descuento del 30%</h6>
                                </g:if>
                                <h3 class="text-center"><g:formatNumber number="${importeCalim}" type="currency" currencySymbol="\$"/></h3>
                                <button id="submitBtn" type="submit" style="width:100%;margin: 20px 0px 10px 0px;" class="formBtn btn btn-primary block waves-effect">Pagar <asset:image width="35" height="30" src="mercado-pago.png"/></button>
                                <h6 style="color:grey"><asset:image width="40" height="40" src="tls.png"/> La transacción está protegida mediante el protocolo <u>TLS</u></h6>
                                <hr/>
                                <div class="row">
                                    <div class="col-md-12">
                                        <button id="volverBtn" type="button" style="width:100%;" class="formBtn btn-outline btn block waves-effect">Volver</button>
                                   </div>
                                </div>
                            </div>
                         </g:form>
                        </div>
                <!-- end of form -->
                  <div class="text-center">
                        <div class="preloader3" id="submitLoader" style="height:10px; padding-top:1px; display: none;">
                            <div class="circ1"></div>
                            <div class="circ2"></div>
                            <div class="circ3"></div>
                            <div class="circ4"></div>
                        </div>
                     </div>
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
        var sumbitButton = document.getElementById("submitBtn");

        sumbitButton.onclick = function() {
            $("#submitLoader").css('display','block');
            $(".formBtn").attr("disabled", true);
            $("#formResumen").submit();
        };

        volverButton.onclick = function() {
            $("#volver").val("true");
            $("#formResumen").submit();
            $(".formBtn").attr("disabled", true);
        };  
    });    
    </script>
</body>

</html>
