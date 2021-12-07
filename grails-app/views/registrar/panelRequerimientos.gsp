<!DOCTYPE html>
<html lang="en">
<div style="display: none;">
    <div id="urlIngresoDocumento">
        <g:createLink controller="registrar" action="ingresoDNI" params="[path:'preguntaCUIT']" />
    </div>
    <div id="urlAccesoDashboard">
        <g:createLink controller="registrar" action="accesoDashboard" />
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
                         <g:hiddenField name="path" value="${path}"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 80%" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>Requisitos para inscripción monotributo</h5>
                                    <ul class="basic-list" style="color:black">
                                        <li class="">
                                            <h3 style="text-align: left">1) CUIT</h3>
                                        </li>
                                        <li class="">
                                            <h3 style="text-align: left">2) Clave Fiscal</h3>
                                        </li>
                                        <li class="">
                                            <h3 style="text-align: left">3) Datos sobre tus aportes</h3>
                                            <h5 style="color:grey; margin-right: 105px;">(Obra social y/o jubilación)</h5>
                                        </li>
                                    
                                        <hr/>
                                        <li class="">
                                            <h5 style="text-align: left;">Te enviamos un mail con instrucciones paso a paso para sacar el CUIT y clave fiscal en el sitio web de la AFIP</h5>
                                        </li>
                                    </ul>
                                    <hr/>
                                    <div class="row m-t-15">
                                        <div class="col-md-12">
                                            <button id="volverBtn" type="button" style="margin-right:100px" class="btn btn-default block waves-effect">Volver</button>
                                            <button id="submitBtn" type="button" style="margin-left:100px" class="btn btn-primary block waves-effect">Ingresar</button>
                                       </div>
                                    </div>
                            </div>
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
        var sigButton = document.getElementById("submitBtn");

        volverButton.onclick = function() {
            window.location.href = $("#urlIngresoDocumento").text();
        };  

        sigButton.onclick = function() {
            window.location.href = $("#urlAccesoDashboard").text();
        };  
    });    
    </script>
</body>

</html>
