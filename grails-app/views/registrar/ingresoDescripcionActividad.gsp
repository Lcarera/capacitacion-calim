<!DOCTYPE html>
<html lang="en">
<div style="display:none;">
    <div id="urlVolver">
        <g:createLink controller="registrar" action="pasosRegistro" params="[accion:'volver']"/>
    </div>
    <div id="urlGetProvincias">
        <g:createLink controller="provincia" action="ajaxGetProvincias" />
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
                        <g:form action="pasosRegistro" class="md-float-material" name="formIngresoDescripcion">
                            <g:hiddenField name="pasoActual" value="ingresoDescripcionActividad"/>
                            <g:hiddenField name="mobile" value="false"/>
                            <g:hiddenField name="volver" value="false"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 70%" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">                              
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>¿Podrías explicarnos más de qué trata tu actividad?</h5>
                                <div class="form-group row">
                                    <div class="col-12">
                                        <textarea name="descripcion" rows="4" cols="5" class="form-control" placeholder="Descripcion"></textarea>
                                    </div>
                                </div>
                            
                                <hr/>
                                <div class="row">
                                    <div class="col-6">
                                        <button id="volverBtn" type="button" style="width:100%" class="formBtn btn btn-default block waves-effect">Volver</button>
                                    </div>
                                    <div class="col-6">
                                        <button id="submitBtn" type="submit" style="width:100%" class="formBtn btn btn-primary block waves-effect">Siguiente</button>
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
            $(".formBtn").attr("disabled", true);
            $("#formIngresoDescripcion").submit();
        };  
        document.getElementById("submitBtn").onclick = function() {
            $(".formBtn").attr("disabled", true);
            $("#formIngresoDescripcion").submit();
        };  
    });    
    </script>
</body>

</html>
