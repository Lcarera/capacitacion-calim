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
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-12">
                    <!-- Authentication card start -->
                    <div class="signup-card auth-body mr-auto ml-auto">
                        <g:form action="registerMail" class="md-float-material">
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-center txt-primary m-b-20 ttl-login">¿Qué obtenés con Calim?</h5>
                                <div class="row m-b-25" style="margin-top:20px;">
                                    <div class="col-md-12 text-center">
                                        <ul class="m-b-20">
                                            <li class="text-inverse"><i class="ti-check"></i> Emití tus Facturas Electrónicas fácil</li>
                                            <li class="text-inverse"><i class="ti-check"></i> Contador matriculado que te asesora por Whatsapp</li>
                                            <li class="text-inverse"><i class="ti-check"></i> Liquidamos tus impuestos,<br/>(Monotributo, Ingresos Brutos, IVA, Ganancias)</li>
                                            <li class="text-inverse"><i class="ti-check"></i> Te notificamos de tus vencimientos</li>
                                        </ul>
                                    </div>
                            
                                    <div class="col-md-12">
                                        <a style="color: #FFFFFF; text-decoration: none;" class="btn btn-md btn-block btn-google-plus m-b-15" href="/oauth/authenticate/google">
                                        <i class="icofont icofont-social-google-plus"></i>Con Google</a>
                                    </div>
                                    <div class="col-md-12">
                                    <button type="submit" class="btn btn-primary btn-md btn-block waves-effect text-center"><i class="icofont icofont-envelope"></i>Con email</button>
                                    </div>
                                </div>
                                <hr/>

                                <div class="row">
                                    <div class="col-md-12">
                                        <p class="text-inverse text-left m-b-0">¿Ya estás registrado?<b><g:link controller="login" action="auth" style="color: #303548!important;"> Ingresá acá</g:link></b></p>
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
</body>

</html>
