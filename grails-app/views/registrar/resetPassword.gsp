<!DOCTYPE html>
<html lang="en">

<head>
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
    <asset:stylesheet src="forgotPassword" />
	<asset:javascript src="forgotPassword" />

    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=UA-149778516-1"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', 'UA-149778516-1');
    </script>

    <!-- Hotjar Tracking Code for https://app.calim.com.ar -->
    <script>
        (function(h,o,t,j,a,r){
            h.hj=h.hj||function(){(h.hj.q=h.hj.q||[]).push(arguments)};
            h._hjSettings={hjid:1537189,hjsv:6};
            a=o.getElementsByTagName('head')[0];
            r=o.createElement('script');r.async=1;
            r.src=t+h._hjSettings.hjid+j+h._hjSettings.hjsv;
            a.appendChild(r);
        })(window,document,'https://static.hotjar.com/c/hotjar-','.js?sv=');
    </script>
</head>

<body class="fix-menu">
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
                    <div class="login-card card-block auth-body mr-auto ml-auto">
                    	<g:form class="md-float-material" controller='registrar' action='resetPassword' method='POST' name="resetPasswordForm" autocomplete='off'>
                        	<div class="text-center">
								<asset:image src="auth/logo-dark.png"/>
                            </div>
                            <div class="auth-box">
                            	<div class="row m-b-20">
                                    <div class="col-md-12">
                                        <h3 class="text-left txt-primary"><g:message code='zifras.security.enterNewPassword' default='Ingresar nuevo password'/></h3>
                                    </div>
                                </div>
                                <hr/>
                                <g:if test="${flash.error}">
								<div class="alert alert-danger background-danger">
									<button type="button" class="close" data-dismiss="alert" aria-label="Close">
										<i class="icofont icofont-close-line-circled text-white"></i>
									</button>
									<strong>${flash.error}</strong>
								</div>
								</g:if>
								<g:hiddenField name='t' value='${token}'/>
                                <div class="input-group">
                                    <input name="password" id="password" type="password" class="form-control form-control-alto" placeholder="<g:message code='zifras.security.password' default='Password'/>">
                                    <span class="md-line"></span>
                                </div>
                                <div class="input-group">
                                    <input name="password2" id="password2" type="password" class="form-control form-control-alto" placeholder="<g:message code='zifras.security.passwordAgain' default='Password (nuevamente)'/>">
                                    <span class="md-line"></span>
                                </div>
                                <div class="row m-t-30">
                                    <div class="col-md-12">
                                        <button type="submit" class="btn btn-primary btn-md btn-block waves-effect text-center m-b-20"><g:message code='zifras.security.updatePassword' default='Actualizar password'/></button>
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
    <!-- Warning Section Starts -->
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
    <a id="wpp" class="float" target="_blank">
    <i class="fa fa-whatsapp my-float"></i>
    </a>
<script>
	$(document).ready(function() {
		$('#password').focus();

        var redirijirAndroid = function() {
            window.location.replace('https://play.google.com/store/apps/details?id=com.calim.micontador'); //Reemplazar con url del store
        };


        var redirijirIos = function() {
            window.location.replace('market://details?id=com.myapp.package'); //Reemplazar con url del store
        };

        var openApp = function() {
            console.log('calimapp://calimapp.com.ar/reset-password/' + '${token}');
            window.location.replace('calimapp://calimapp.com.ar/reset-password/' + '${token}');
        };

        var triggerAppOpen = function(esAndroid) {
            openApp();
            if(esAndroid){
                setTimeout(redirijirAndroid, 250);
            }else {
                setTimeout(redirijirIos, 250);
            }
        };

        if( /Android|webOS|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
            console.log('Es android');
            triggerAppOpen(true);
        }else{
            if(/iPhone|iPad|iPod/i.test(navigator.userAgent) ){
                console.log('Es iphone');
                triggerAppOpen(false);
            }
            console.log('No es mobile');
        }
        getNumeroVendedor();

    });
    function getNumeroVendedor(){
        var d = new Date();
        var n = d.getHours();
        var wpp = document.getElementById("wpp")
        if(n >= 14 && n < 22)
            wpp.href="https://api.whatsapp.com/send?phone=5491121806766&text=Hola%21%20Necesito%20ayuda." 
        else
            wpp.href="https://api.whatsapp.com/send?phone=5491162230023&text=Hola%21%20Necesito%20ayuda."
    }
	</script>
</body>
</html>
