<!DOCTYPE html>
<html lang="en">

<head>
    <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-NPFKM22');
    </script>
    <!-- End Google Tag Manager -->

    <title><g:message code='calim.title' default='Calim'/></title>
    <!-- HTML5 Shim and Respond.js IE10 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 10]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
      <![endif]-->
    <!-- Meta -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimal-ui">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="description" content="#">
    <meta name="keywords" content="Admin , Responsive, Landing, Bootstrap, App, Template, Mobile, iOS, Android, apple, creative app">
    <meta name="author" content="#">
    <!-- Favicon icon -->
	<asset:link rel="shortcut icon" type="image/x-icon" href="favicon.ico"/>
    <!-- Google font-->
	<link href="https://fonts.googleapis.com/css?family=Open+Sans:400,600,800" rel="stylesheet">
    <asset:stylesheet src="login" />
	<asset:javascript src="login" />
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
                    	<form class="md-float-material" action='${postUrl}' method='POST' id="loginForm" name="loginForm" autocomplete='off'>
                        	<div class="text-center">
								<asset:image src="auth/logo-dark.png"/>
                            </div>
                            <div class="auth-box">



                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"><g:message code='zifras.security.signin' default='Ingreso con redes sociales'/></h5>
                                <div class="row m-b-10">
                                    <!--div class="col-md-6">
                                        <a style="color: #FFFFFF; text-decoration: none;" class="btn btn-md btn-block btn-linkedin m-b-15" href="/oauth/authenticate/linkedin"><i class="icofont icofont-social-linkedin"></i>Con Linkedin</a>
                                    </div-->
                                    <div class="col-md-12">
                                        <a style="color: #FFFFFF; text-decoration: none;" class="btn btn-md btn-block btn-google-plus m-b-15" href="/oauth/authenticate/google">
                                        <i class="icofont icofont-social-google-plus"></i>Con Google</a>
                                    </div>
                                </div>

                            	<h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"><g:message code='zifras.security.signin' default='Ingresar'/></h5>
                                <div class="input-group">
                                    <input name="username" id="username" type="email" class="form-control form-control-alto" placeholder="<g:message code='zifras.security.email' default='email'/>" style="text-transform: lowercase;">
                                    <span class="md-line"></span>
                                </div>
                                <div class="input-group" style="margin-top:1.25em!important;">
                                    <input name="password" id="password" type="password" class="form-control form-control-alto" placeholder="<g:message code='zifras.security.password' default='password'/>">
                                    <span class="md-line"></span>
                                </div>
                                <g:if test='${loginError!=null}'>
                                <div class="alert alert-danger background-danger">
									<button type="button" class="close" data-dismiss="alert" aria-label="Close">
										<i class="icofont icofont-close-line-circled text-white"></i>
									</button>
									<strong>¡Datos incorrectos!</strong>
								</div>
								</g:if>
                                <g:if test='${nuevoRegistro!=null}'>
                                <div class="alert alert-success background-success">
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <i class="icofont icofont-close-line-circled text-white"></i>
                                    </button>
                                    <strong>¡Verifique la cuenta en su mail!</strong>
                                </div>
                                </g:if>
                                <div class="row m-t-30">
                                    <div class="col-md-12">
                                        <button type="button" class="btn btn-primary btn-md btn-block waves-effect text-center m-b-20" onclick="document.forms.loginForm.submit();"><g:message code='zifras.security.signin' default='Ingresar'/></button>
                                    </div>
                                </div>
                                <div class="row text-center">
                                    <div class="col-12">
                                        <div class="forgot-phone text-center">
                                        	<g:link controller='registrar' action='forgotPassword' class="text-right f-w-600 text-inverse"><g:message code='zifras.security.forgotpassword' default='¿Olvidaste el password?'/></g:link>
                                        </div>
                                    </div>
                                </div>
                                <hr>
                                <div class="row">
                                    <div class="col-md-12">
                                        <p class="text-inverse text-center m-b-0 txt-login">¿No tenés cuenta?<b><g:link controller='registrar' action='index'> Registrate acá</g:link></b></p>
                                    </div>
                                </div>
                                <!--<div class="row m-t-30">
                                    <div class="col-md-12">
                                    	<oauth:connect provider="facebook" id="facebook-connect-link">Facebook</oauth:connect>
                                        <oauth:connect provider="google" id="google-connect-link">Google</oauth:connect>
                                        Logged with google?
										<s2o:ifLoggedInWith provider="google">yes</s2o:ifLoggedInWith>
										<s2o:ifNotLoggedInWith provider="google">no</s2o:ifNotLoggedInWith>
										Logged with facebook? <s2o:ifLoggedInWith provider="facebook">yes</s2o:ifLoggedInWith><s2o:ifNotLoggedInWith provider="facebook">no</s2o:ifNotLoggedInWith>
                                    </div>
                                </div>-->
                          </div>
                        </form>

                        <br>
                        <br>
                        
                        <!-- end of form -->
                    </div>
                    <!-- Authentication card end -->
                </div>
                <!-- end of col-sm-12 -->
            </div>
            <!-- end of row -->
        </div>
        <!-- end of container-fluid -->
        <!--div class="bottomFixedBar">
            <div class="row text-center">
                <h5 class="txt-primary m-b-20" style="width: 100%;color: #666666;">Bajá la app</h5>
                <div class="col-6">
                    <a style="color: #FFFFFF; text-decoration: none;" class="btn btn-md btn-block btn-google-plus m-b-15" href="/oauth/authenticate/google">
                    <i class="icofont icofont-social-google-plus"></i>Con Google</a>
                </div>
                <div class="col-6">
                    <a style="color: #FFFFFF; text-decoration: none;" class="btn btn-md btn-block btn-google-plus m-b-15" href="/oauth/authenticate/google">
                    <i class="icofont icofont-social-google-plus"></i>Con Google</a>
                </div>
            </div>
        </div-->
        
        <!--div id="cartelApp" style="position: fixed; z-index: 1000; bottom: 0px; left: 0px; right: 0px; background-color: rgb(255, 255, 255); padding: 16px; box-shadow: rgba(0, 0, 0, 0.1) 0px -8px 16px 0px;">
            <a style="font-weight: 600; font-size: 18px; color: rgba(0, 0, 0, 0.8); line-height: 24px; -webkit-font-smoothing: antialiased; text-decoration: none;">
                Bajá la app y ....
            </a>
            <div style="margin-top: 16px; display: flex; flex-direction: row-reverse;" >
                <a onclick="triggerAppOpen()" style="border: none; background-color: #2091a2; color: #fff; white-space: nowrap; padding: 6px 8px 8px;-webkit-font-smoothing: antialiased; font-size: 14px; font-weight: 600; display: flex; justify-content: center; align-items: center; flex: 1 1 0%; text-decoration: none;">
                    Bajar
                </a>
                <button onclick="hideCartelApp()" style="border: none; color: #000; padding: 6px 8px 8px; margin-right: 12px;-webkit-font-smoothing: antialiased; font-size: 14px; font-weight: 600; display: flex; justify-content: center; align-items: center; flex: 1 1 0%;">
                    Ahora no
                </button>
            </div>
        </div-->

    </section>
    <!-- Warning Section Starts -->
    <!-- Older IE warning message -->
    <!--[if lt IE 10]>
<div class="ie-warning">
    <h1>Warning!!</h1>
    <p>You are using an outdated version of Internet Explorer, please upgrade <br/>to any of the following web browsers to access this website.</p>
    <div class="iew-container">
        <ul class="iew-download">
            <li>
                <a href="http://www.google.com/chrome/">
                    <img src="assets/images/browser/chrome.png" alt="Chrome">
                    <div>Chrome</div>
                </a>
            </li>
            <li>
                <a href="https://www.mozilla.org/en-US/firefox/new/">
                    <img src="assets/images/browser/firefox.png" alt="Firefox">
                    <div>Firefox</div>
                </a>
            </li>
            <li>
                <a href="http://www.opera.com">
                    <img src="assets/images/browser/opera.png" alt="Opera">
                    <div>Opera</div>
                </a>
            </li>
            <li>
                <a href="https://www.apple.com/safari/">
                    <img src="assets/images/browser/safari.png" alt="Safari">
                    <div>Safari</div>
                </a>
            </li>
            <li>
                <a href="http://windows.microsoft.com/en-us/internet-explorer/download-ie">
                    <img src="assets/images/browser/ie.png" alt="">
                    <div>IE (9 & above)</div>
                </a>
            </li>
        </ul>
    </div>
    <p>Sorry for the inconvenience!</p>
</div>
<![endif]-->
    <!-- Warning Section Ends -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
     <a id="wpp" class="float" target="_blank" href="" onclick="getNumeroVendedor()">
    <i class="fa fa-whatsapp my-float"></i>
    </a>
   <script>
		$(document).ready(function() {
            $("#username").on('keydown', function(event) {
                if(event.key === "Enter") {
                    event.preventDefault();
                    document.forms.loginForm.submit();
                }
            });

            const toMatch = [
                /Android/i,
                /webOS/i,
                /iPhone/i,
                /iPad/i,
                /iPod/i,
                /BlackBerry/i,
                /Windows Phone/i
            ];

            
            $("#cartelApp").hide();
            toMatch.some((toMatchItem) => {
                if(navigator.userAgent.match(toMatchItem)){
                    $("#cartelApp").show();        //es mobile
                }
            });

            $("#password").on('keydown', function(event) {
                if(event.key === "Enter") {
                    event.preventDefault();
                    document.forms.loginForm.submit();
                }
            });

			$('#username').focus();
		});

       var redirigirAndroid = function() {
            window.location.replace('https://play.google.com/store/apps/details?id=com.calim.micontador'); //Reemplazar con url del store
        };

        var redirigirIos = function() {
            window.location.replace('https://apps.apple.com/us/app/calim-mi-contador/id1522233671'); //Reemplazar con url del store
        };

        var openApp = function() {
            window.location.replace('calimapp://calimapp.com.ar');
        };

        function triggerAppOpen() {
            openApp();

            if( /Android|webOS|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
                    setTimeout(redirigirAndroid, 250);
            }else{
                if(/iPhone|iPad|iPod/i.test(navigator.userAgent) ){
                    setTimeout(redirigirIos, 250);
                }
                console.log('No es mobile');
            }

        };

        function hideCartelApp(){
            $("#cartelApp").hide();
        }

        function getNumeroVendedor(){
            var wpp = document.getElementById("wpp")
            var URL="${createLink(controller:'registrar',action:'getVendedorNecesitoAyuda',params:['ayuda':true])}";
              $.ajax({
                        url:URL,
                        async: false,
                        success: function(resp){
                            wpp.href = resp.wsp;
                        }
                    });
        }

	</script>
</body>
</html>
