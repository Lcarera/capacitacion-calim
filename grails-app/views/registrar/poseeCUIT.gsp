<!DOCTYPE html>
<html lang="en">

<div style="display: none;">
    <div id="urlIngresoDocumento">
            <g:createLink controller="Registrar" action="ingresoDNI" />
    </div>
    <div id="urlIngresoDatos">
        <g:createLink controller="Registrar" action="ingresoCUIT" />
    </div>
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
                        <g:form action="pasosRegistro" class="md-float-material" name="formPoseeCUIT">
                            <g:hiddenField name="pasoActual" value="poseeCUIT"/>
                            <g:hiddenField name="volver" value="false"/>
                            <g:hiddenField name="inscriptoAfip" value="false"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 35%" aria-valuenow="35" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/> ¿Estás inscripto en AFIP?</h5>
                                    <div class="input-group input-group-register">
                                        <div class="col-md-12">
                                            <button id="siBtn" type="button" class= "formBtn btn btn-primary btn-md btn-block waves-effect text-center m-b-10">SI</button>
                                            <button id="noBtn" type="button" class= "formBtn btn btn-inverse btn-md btn-block waves-effect text-center m-b-10">NO</button>
                                        </div>
                                    </div>
                                    <hr/>
                                    <div class="row">
                                        <div class="col">
                                            <button id="volverBtn" type="button" style="width:100%" class="formBtn btn btn-default block waves-effect">Volver</button>
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

        var siButton = document.getElementById("siBtn");
        var noButton = document.getElementById("noBtn");

        var volverButton = document.getElementById("volverBtn");

         siButton.onclick = function() {
            $("#inscriptoAfip").val("true");
            $(".formBtn").attr("disabled", true);
            $("#formPoseeCUIT").submit();
        };  

        noButton.onclick = function() {
            $("#inscriptoAfip").val("false");
            $("#formPoseeCUIT").submit();
            $(".formBtn").attr("disabled", true);
        };  

        volverButton.onclick = function() {
            $("#volver").val("true");
            $(".formBtn").attr("disabled", true);
            $("#formPoseeCUIT").submit();
        };  
    });    
    </script>
</body>

</html>