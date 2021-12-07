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
    <asset:stylesheet src="forgotPassword" />
	<asset:javascript src="forgotPassword" />
</head>

<body class="fix-menu">
    <!-- Google Tag Manager (noscript) -->
    <noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-NPFKM22" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
    <!-- End Google Tag Manager (noscript) -->
    
    <section class="login p-fixed d-flex text-center bg-primary common-img-bg">
        <!-- Container-fluid starts -->
        <div class="container">
            <div class="row">
                <div class="col-sm-12">
                    <!-- Authentication card start -->
                    <div class="login-card card-block auth-body mr-auto ml-auto">
                    	<g:form class="md-float-material" controller='registrar' action='forgotPassword' method='POST' name="loginForm" autocomplete='off'>
                        	<div class="text-center">
								<asset:image src="auth/logo-dark.png"/>
                            </div>
                            <div class="auth-box">
                            	<div class="row m-b-20">
                                    <div class="col-md-12">
                                        <h3 class="text-left txt-primary"><g:message code='zifras.security.forgotPassword' default='¿Olvidaste tu password?'/></h3>
                                    </div>
                                </div>
                                <hr/>
                                <g:if test='${emailSent}'>
                                <div class="alert alert-success background-success">
									<strong>Te enviamos un email para que resetees tu password</strong>
								</div>
								</g:if>
								<g:else>
								<g:if test="${flash.error}">
								<div class="alert alert-danger background-danger">
									<button type="button" class="close" data-dismiss="alert" aria-label="Close">
										<i class="icofont icofont-close-line-circled text-white"></i>
									</button>
									<strong>${flash.error}</strong>
								</div>
								</g:if>
                                <div class="input-group">
                                    <input name="username" style="text-transform: lowercase;" id="username" type="email" class="form-control form-control-alto" placeholder="<g:message code='zifras.security.email' default='email'/>">
                                    <span class="md-line"></span>
                                </div>
                                <div class="row m-t-30">
                                    <div class="col-md-12">
                                        <button type="submit" class="btn btn-primary btn-md btn-block waves-effect text-center m-b-20"><g:message code='zifras.security.resetPassword' default='Resetear password'/></button>
                                    </div>
                                </div>
                                <div class="row m-t-25 text-left">
                                    <div class="col-12">
                                        <div class="forgot-phone text-right f-right">
                                        	<g:link controller='login' action='auth' class="text-right f-w-600 text-inverse"><g:message code='zifras.security.backLogin' default='Volver a login'/></g:link>
                                        </div>
                                    </div>
                                </div>
                                </g:else>
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
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
    <a id="wpp" class="float" target="_blank">
    <i class="fa fa-whatsapp my-float"></i>
    </a>
  <script>
		$(document).ready(function() {
			$('#username').focus();
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
