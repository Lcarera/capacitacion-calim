<!DOCTYPE html>
<html lang="en">

<head>
    <meta name="layout" content="registroLayout">
</head>

<body class="fix-menu">
    <!-- Google Tag Manager (noscript) -->
    <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-NPFKM22" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!-- End Google Tag Manager (noscript) -->
    
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
    <!-- Pre-loader end -->

    <section class="login p-fixed d-flex text-center bg-primary common-img-bg">
        <!-- Container-fluid starts -->
        <div class="container">
            <div class="row">
                <div class="col-sm-12">
                    <!-- Authentication card start -->
                    <div class="login-card auth-body mr-auto ml-auto" style="color:#666666;">
                        <g:form action="pasosRegistro" class="md-float-material" name="formErrorCUIT">
                            
                            <g:hiddenField name="cuit" value="${cuit}"/>
                            <g:hiddenField name="volver" value="false"/>
                            <g:hiddenField name="mobile" value="false"/>
                            <g:hiddenField name="pasoActual" value="errorCUIT"/>

                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br/>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 80%" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <div class="row m-b-20">
                                    <div class="col-md-12"><h3 class="text-left">¿Es correcto el CUIT que ingresaste?</h3></div>
                                    <div class="col-md-12">
                                        <h3 class="text-left txt-primary cuit">CUIT: ${cuit}</h5>
                                    </div>

                                    <div class="col-md-12">
                                        <br/>
                                        <h5 class="text-left txt-primary"> Ocurrió un conflicto con el CUIT ingresado, si crees que lo ingresaste correctamente clickea SI para continuar con el registro o NO para volver a ingresarlo.</h5>
                                    </div>
                                </div>
                                
                                <div class="row m-t-20">
                                   <div class="col-xs-6">
                                        <button type="button" id="volverBtn" class="formBtn btn btn-primary btn-md btn-block waves-effect text-center m-b-20"><i class="icon-arrow-left arrow-left"></i>No</button>
                                    </div>
                                    <div class="col-xs-6">
                                        <button type="submit" id="submitBtn" class="formBtn btn btn-primary btn-md btn-block waves-effect text-center m-b-20">Sí<i class="icon-arrow-right arrow-right"></i></button>
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
    $(document).ready(function () {
        document.getElementById("volverBtn").onclick = function() {
            $("#volver").val("true");
            $(".formBtn").attr("disabled", true);
            $("#formErrorCUIT").submit();
        };
        document.getElementById("submitBtn").onclick = function() {
            $(".formBtn").attr("disabled", true);
            $("#formErrorCUIT").submit();
        };
    });    
    </script>
</body>

</html>