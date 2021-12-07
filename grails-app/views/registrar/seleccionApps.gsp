<!DOCTYPE html>
<html lang="en">

<div style="display: none;">
    <div id="urlSeleccionProfesion">
         <g:createLink controller="Registrar" action="seleccionProfesion" />
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
                        <g:form action="pasosRegistro" class="md-float-material" name="formSeleccionApps">
                            <g:hiddenField name="pasoActual" value="seleccionApps"/>
                            <g:hiddenField name="mobile" value="false"/>
                            <g:hiddenField name="volver" value="false"/>
                            <g:each in="${apps}">
                                <g:if test="${it.nombre=='Rappi'}">
                                    <input type="hidden" name="app" id="app" value="${it.id}"/>
                                </g:if>
                            </g:each>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 30%" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>¿Cuál es la App con la que trabajás?</h5>
                                    <div class="row row-apps">
                                        <g:each in="${apps}">
                                        <div class="col-md-3 col-xs-6 col-apps">
                                            <button id="button${it.id}"" type="button" class="btn apps ${((it.nombre=='Rappi')?'active':'')}" onclick="cambiarApp(${it.id});"><asset:image src="${it.logo}"/></button>
                                        </div>
                                        </g:each>
                                    </div>
                                    <span class="md-line"></span>
                                    <hr/>
                                    <div class="row">
                                        <div class="col-6">
                                            <button id="volverBtn" type="button" style="width:100%" class="btn btn-default block waves-effect">Volver</button>
                                       </div>
                                       <div class="col-6">
                                            <button id="submitBtn" type="submit" style="width:100%" class="btn btn-primary block waves-effect">Siguiente</button>
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
        document.getElementById("volverBtn").onclick = function() {
            $("#volver").val("true");
            $("#volverBtn").attr("disabled", true);
            $("#submitBtn").attr("disabled", true);
            $("#formSeleccionApps").submit();
        };

        document.getElementById("submitBtn").onclick = function() {
            $("#volverBtn").attr("disabled", true);
            $("#submitBtn").attr("disabled", true);
            $("#formSeleccionApps").submit();
        };
    });

    function cambiarApp(idApp){
        $("#app").val(idApp);
        var idString = '#button' + idApp;
        $("button").removeClass('active');
        $(idString).addClass('active');
    }
    </script>
</body>

</html>
