<!DOCTYPE html>
<html lang="en">

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
                        <g:form action="register" class="md-float-material">
                            <div style="display: none;">
                                <div id="urlUserExists">
                                   <g:createLink controller="registrar" action="ajaxExisteUsuario"/>
                                </div> 
                            </div>
    
                            <g:hiddenField name="cuit" value="${datos.cuit}"/>
                            <g:hiddenField name="tipo" value="${datos.tipo}"/>
                            <g:hiddenField name="localidad" value="${datos.localidad}"/>
                            <g:hiddenField name="domicilio" value="${datos.domicilio}"/>
                            <g:hiddenField name="tipoIva" value="${datos.tipoIva}"/>
                            <g:hiddenField name="actividad" value="${datos.actividad}"/>
                            <g:hiddenField name="categoria" value="${datos.categoria}"/>

                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login">Registro con email</h5>

                                    <div class="input-group input-group-register">
                                        <input type="text" name="nombre" value="${datos?.nombre}" class="form-control input-register" placeholder="Nombre">
                                        <span class="md-line"></span>
                                    </div>
                                    <div class="input-group input-group-register">
                                        <input type="text" name="apellido" value="${datos?.apellido}" class="form-control input-register" placeholder="Apellido">
                                        <span class="md-line"></span>
                                    </div>
                                    <div class="input-group input-group-register">
                                        <input type="email" name="username" id="inputEmail" style="text-transform: lowercase;" class="form-control input-register" placeholder="Correo electrónico">
                                        <span class="md-line" style="margin-top: 1.25em;"></span>
                                    </div>
                                    <div class="input-group input-group-register">
                                        <input type="password" name="password" id="psw" class="form-control input-register" placeholder="Contraseña">
                                        <span class="md-line"></span>
                                    </div>

                                    <div class="input-group input-group-register">
                                        <input type="password" name="password2" id="psw2" class="form-control input-register" placeholder="Repita la contraseña">
                                        <span class="md-line"></span>
                                    </div>
                                    <hr/>
                                    <div class="row m-t-15">
                                        <div class="col-md-12">
                                            <button type="submit" id="submitBtn" class="btn btn-primary btn-md btn-block waves-effect text-center m-b-10">Registrate</button>
                                        </div>
                                    </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <p class="text-inverse text-left m-b-0">¿Ya estás registrado?<b><g:link controller="login" action="auth" style="color:#303548!important;"> Ingresá acá</g:link></b></p>
                                    </div>
                                </div>
                            </div>
                        </g:form>
                        <!-- end of form -->
                    </div>
                    <div class="text-center">
                        <div class="preloader3" id="submitLoader" style="height:10px; padding-top:1px; display: none;">
                            <div class="circ1"></div>
                            <div class="circ2"></div>
                            <div class="circ3"></div>
                            <div class="circ4"></div>
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

        var pswInput = document.getElementById("psw");
        var pswInput2 = document.getElementById("psw2");
        var sumbitButton = document.getElementById("submitBtn");
        pswInput.classList.remove("is-invalid");
        pswInput2.classList.remove("is-invalid");

        // When the user starts to type something inside the password field
        pswInput.onkeyup = function() {
            // Validate lowercase letters
            var lowerCaseLetters = /[a-z]/g;
            if (pswInput.value.match(lowerCaseLetters)) {
              pswInput.classList.remove("is-invalid");
            } else {
              pswInput.classList.add("is-invalid");
            }
            //psw matchs psw2
            if (pswInput.value == pswInput2.value) {
              pswInput2.classList.remove("is-invalid");
            } else {
              pswInput2.classList.add("is-invalid");
            }

            // Validate capital letters
            var upperCaseLetters = /[A-Z]/g;
            if (pswInput.value.match(upperCaseLetters)) {
              pswInput.classList.remove("is-invalid");
            } else {
              pswInput.classList.add("is-invalid");
            }

            // Validate numbers
            var numbers = /[0-9]/g;
            if (pswInput.value.match(numbers)) {
              pswInput.classList.remove("is-invalid");
            } else {
              pswInput.classList.add("is-invalid");
            }

            // Validate length
            if (pswInput.value.length >= 8) {
              pswInput.classList.remove("is-invalid");
            } else {
              pswInput.classList.add("is-invalid");
            }
        };

        pswInput2.onkeyup = function() {
            //psw matchs psw2
            if (pswInput.value == pswInput2.value) {
                pswInput2.classList.remove("is-invalid");
            } else {
                pswInput2.classList.add("is-invalid");
            }
        };

        sumbitButton.onclick = function() {
            var pswOK = !$("#psw").hasClass("is-invalid") && $("#psw").val() != "";
            var psw2OK = !$("#psw2").hasClass("is-invalid") && $("#psw2").val() != "";
            var userOK = !$("#inputEmail").hasClass("is-invalid") && $("#inputEmail").val() != "";

            if (!pswOK || !psw2OK || !userOK) {
                event.preventDefault();
            }
            if ($("#psw").val() != $("#psw2").val()) event.preventDefault();

            $("#submitLoader").css('display','block');


        };  

        $("#inputEmail").keyup(function() {
            var url = $('#urlUserExists').text().replace(/\s/g, '');
            $.ajax(url, {
                dataType: "json",
                data: {
                    email: $("#inputEmail").val(),
                }
            }).done(function(data) {
                if(data){
                    $("#inputEmail").removeClass("is-valid");
                    $("#inputEmail").addClass("is-invalid");
                }else{
                    $("#inputEmail").removeClass("is-invalid");
                    $("#inputEmail").addClass("is-valid");    
                }
            });        
        });
    });    
    </script>
</body>

</html>
