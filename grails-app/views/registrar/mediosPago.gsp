<!DOCTYPE html>
<html lang="en">
<div style="display: none;">
    <div id="urlResultado">
            <g:createLink controller="Registrar" action="resultadoMonotributo" />
    </div>
</div>
<head>
 <meta name="layout" content="registroLayout">  
    <div class="col-md-12">
        <div class="progress">
            <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 95%" aria-valuenow="95" aria-valuemin="0" aria-valuemax="100"></div>
        </div>
    </div>
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
                        <g:form action="actualizarCUIT" class="md-float-material">
                        <g:hiddenField name="pathVolver" value="${pathVolver}"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>Medios de pago:</h5>
                                    
                                    <hr/>
                                    <div class="row m-t-15">
                                        <div class="col-md-12">
                                            <button id="volverBtn" type="button" style="margin-right:100px" class="btn btn-default block waves-effect">Volver</button>
                                            <button id="submitBtn" type="submit" style="margin-left:100px" class="btn btn-primary block waves-effect">Siguiente</button>
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


        var volverButton = document.getElementById("volverBtn");

        volverButton.onclick = function() {
            window.location.href = $("#urlResultado").text();
        };  
    });    
    </script>
</body>

</html>
