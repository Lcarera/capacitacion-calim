<!DOCTYPE html>
<html lang="en">
<head>
	 <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-NPFKM22');
    </script>
    <!-- End Google Tag Manager -->

    <title>Registro Calim</title>
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
    <!-- Google font-->
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:400,600,800" rel="stylesheet">
    <!-- Required Fremwork -->

    <asset:stylesheet src="register" />
    <asset:javascript src="register" />
    <g:layoutHead/>
</head>
<body>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
  	<a id="wpp" class="float" target="_blank">
  	<i class="fa fa-whatsapp my-float"></i>
 	</a>
<script>
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
<g:layoutBody/>
</body>
</html>