<!DOCTYPE html>
<html lang="en">

<head>
    <title>Email de activación</title>
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

    <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon">
    <!-- Google font--><link href="https://fonts.googleapis.com/css?family=Open+Sans:400,600,800" rel="stylesheet">
    <!-- Required Fremwork -->

    <asset:stylesheet src="register" />
    <asset:javascript src="register" />

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
    <div style="display: none;">
        <div id="urlUserExists">
           <g:createLink controller="registrar" action="ajaxExisteUsuario"/>
        </div> 
    </div>
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
                <div class="col-md-2 col-sm-12">
                </div>
                <div class="col-md-8 col-sm-12">
                    <!-- Authentication card start -->
                    <div class="">
                        <div class="text-center">
                            <asset:image src="auth/logo-dark.png"/>
                        </div>
                        <br>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 3%" aria-valuenow="3" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                        <div class="auth-box">
                            <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login">¡Enviamos un email para activar tu cuenta!</h5>
                            <div class="row m-t-25 text-left">
                                <div class="col-md-12" style="color:#303548;">
                                    Revisá tu bandeja de entrada y el SPAM.<br/>
                                    Si no te llega escribinos por whatsapp o al mail info@calim.com.ar<br/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Authentication card end -->
                </div>
                <div class="col-md-2 col-sm-12">
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

  <script type="text/javascript">
      $(document).ready(() => {
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
