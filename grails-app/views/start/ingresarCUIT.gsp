<!DOCTYPE html>
<html lang="en">

<head>
    <meta name="layout" content="registroLayout">

    <script>
        var cuitValido = false;
        function validarCuit(elemento){
            var valor = elemento.val();
            if (valor.length != 11){
                elemento.addClass('is-invalid');
                cuitValido = false;
                return;
            }
            if (!(['20', '23', '24', '27', '30', '33', '34'].includes(valor.slice(0,2)))){
                elemento.addClass('is-invalid');
                cuitValido = false;
                return;
            }
            elemento.removeClass('is-invalid');
            cuitValido = true;
            return;
        }

        function submitearForm(){
            if (cuitValido){
                if($('#telefono').val()!='')
                    $("#formShowDatos").submit();
                else
                    alert('Por favor ingresá tu número de celular');    
            }else
                alert('El CUIT es inválido');
        }
    </script>
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
                    <div class="login-card auth-body mr-auto ml-auto">
                        <g:form action="showDatos" class="md-float-material" name="formShowDatos">
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <div class="auth-box">
                                <g:if test="${flash.error}">
                                    <div class="alert alert-danger background-danger">
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <i class="icofont icofont-close-line-circled text-white"></i>
                                        </button>
                                        <strong>${flash.error}</strong>
                                    </div>
                                </g:if>
                                
                                <h5 class="b-b-default text-left txt-primary ttl-login">Ingresá tu CUIT y celular</h5>

                                <div class="row m-t-10">
                                    <div class="col-md-10">
                                        <p class="text-inverse text-left m-b-0">Lo utilizaremos para obtener tus datos fiscales</p>
                                    </div>
                                </div>

                                <div class="row m-t-10">
                                    <div class="col-md-12">
                                        <div class="input-group">
                                            <input
                                                type="number"
                                                name="cuit"
                                                class="form-control"
                                                placeholder="Ingresá tu CUIT sin guiones"
                                                onkeypress="var charCode = (event.which) ? event.which : event.keyCode;
                                                            return !(charCode > 31 && (charCode < 48 || charCode > 57));"
                                                onkeyup="validarCuit($(this));"
                                            >
                                            <span class="md-line"></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="row m-t-10">
                                    <div class="col-md-10">
                                        <p class="text-inverse text-left m-b-0">Lo utilizaremos para ayudarte</p>
                                    </div>
                                </div>

                                <div class="row m-t-10">
                                    <div class="col-md-12">
                                        <div class="input-group">
                                            <input
                                                type="number"
                                                id="telefono"
                                                name="telefono"
                                                class="form-control"
                                                placeholder="Ingresá tu número de celular"
                                                onkeypress="var charCode = (event.which) ? event.which : event.keyCode;
                                                            return !(charCode > 31 && (charCode < 48 || charCode > 57));"
                                            >
                                            <span class="md-line"></span>
                                        </div>
                                    </div>
                                </div>

                                <div class="row m-t-10">
                                    <div class="col-md-12" style="text-align:left;">
                                        <div class="checkbox-fade fade-in-primary">
                                            <label class="check-task">
                                                <input type="checkbox" checked onclick="">
                                                <span class="cr">
                                                    <i class="cr-icon icofont icofont-ui-check txt-primary"></i>

                                                </span>
                                                <span class="text-inverse">Quiero recibir contenido promocional</span>
                                            </label>
                                        </div>                                        
                                    </div>
                                </div>
                                    
                                <div class="row m-t-20">
                                    <div class="col-md-12">
                                        <button
                                            type="button"
                                            class="btn btn-primary btn-md btn-block waves-effect text-center m-b-10"
                                            onclick="submitearForm();"
                                        >Siguiente</button>
                                    </div>
                                </div>
                                <!--<div class="row m-t-10">
                                    <div class="col-md-10">
                                        <p class="text-inverse text-left m-b-0">Si no tenés CUIT te asesoramos como obtenerlo.<br/><b><a href="#">Contactate con nosotros</a></b></p>
                                    </div>
                                </div> -->
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
<script>fbq('track', 'CompleteRegistration');</script>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
  <a href="https://api.whatsapp.com/send?phone=17199418172&text=Hola%21%20Necesito%20ayuda." class="float" target="_blank">
  <i class="fa fa-whatsapp my-float"></i>
  </a>
</body>
</html>
