<!DOCTYPE html>
<html lang="en">

<div style="display: none;">
    <div id="urlGetObrasSociales">
        <g:createLink controller="cuenta" action="ajaxGetObrasSociales" />
    </div>
</div>

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
    <!-- Google font--><link href="https://fonts.googleapis.com/css?family=Open+Sans:400,600,800" rel="stylesheet">
    <!-- Required Fremwork -->

    <asset:stylesheet src="register" />
    <asset:javascript src="register" />
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
                        <g:form action="pasosRegistro" class="md-float-material" name="formIngresoProv">
                            <g:hiddenField name="pasoActual" value="seleccionObraSocial"/>
                            <g:hiddenField name="mobile" value="false"/>
                            <g:hiddenField name="volver" value="false"/>
                            <g:hiddenField name="idOsdepym" value="${idOsdepym}"/>
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <br/>
                            <div class="col-md-12">
                                <div class="progress">
                                    <div class="progress-bar progress-bar-primary" role="progressbar" style="width: 95%" aria-valuenow="95" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"/>El monotributo tiene una obra social</h5>
                                    <h5 class="text-left txt-primary m-b-20 ttl-login">¿Qué obra social querés?</h5>
                                    <div class="input-group input-group-register">
                                        <select id="cbObraSocial" name="obraSocialId" class="form-control input-register"></select>
                                    </div>
                                    <br>
                                    <h5 class="text-left txt-primary m-b-20 ttl-login">Algunas obras sociales no aceptan monotributistas. <br><br> Nosotros te sugerimos OSDEPYM</h5>
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
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
    <a id="wpp" class="float" target="_blank">
    <i class="fa fa-whatsapp my-float"></i>
    </a>
   <script type="text/javascript">
    $(document).ready(function () {


         function llenarCombo(params){
            var comboId = params.comboId;
            var ajaxUrlDiv = params.hasOwnProperty("ajaxUrlDiv") ? params.ajaxUrlDiv : null;
            var ajaxLink = params.hasOwnProperty("ajaxLink") ? params.ajaxLink : null;
            var idDefault = params.hasOwnProperty("idDefault") ? params.idDefault : null;
            var datosPasar = params.hasOwnProperty("parametros") ? params.parametros : null;
            var atributo = params.hasOwnProperty("atributo") ? params.atributo : "nombre";
            var readOnly = params.hasOwnProperty("readOnly") ? params.readOnly : false;

            var combo = $("#"+comboId)
            combo.children('option').remove();
            var urlDestino = ajaxLink != null ? ajaxLink : $('#' + ajaxUrlDiv).text();

            $.ajax(urlDestino, {
                dataType: "json",
                data:datosPasar
            }).done(function(data) {
                $.map(data, function(item) {
                    var seleccionado = item.id==idDefault
                    if(item["sigla"] == null)
                        combo.append(new Option(item["nombre"], item.id, seleccionado, seleccionado));
                    else
                        combo.append(new Option(item["sigla"], item.id, seleccionado, seleccionado));
                });

                if(idDefault!=null)
                    combo.val(idDefault);
                if (combo.val())
                    combo.trigger("change");

                if (readOnly)
                    toggleReadOnlyCombo(comboId);
            });
        }
        
        function toggleReadOnlyCombo(comboId, valorAbsoluto = null){
            var combo = $('#' + comboId);
            var divId = "div" + comboId + "Text";
            var divConLabel = $("#" + divId);
            if(divConLabel.length){ // El div con texto ya existía, así que en lugar de volverlo a crear muestro y oculto respectivamente el combo y el div.
                var texto = (combo.select2('data')[0]!=null) ? combo.select2('data')[0].text : ''
                divConLabel.text(texto);
                if (valorAbsoluto == null){
                    combo.next(".select2-container").toggle();
                    divConLabel.toggle();
                }else if (valorAbsoluto == true){
                    combo.next(".select2-container").hide();
                    divConLabel.show();
                }else{
                    combo.next(".select2-container").show();
                    divConLabel.hide();
                }
            }else if (valorAbsoluto == null || valorAbsoluto == true) // Creo el div con el texto
                setTimeout(function() {
                    var texto = (combo.select2('data')[0]!=null) ? combo.select2('data')[0].text : ''
                    $("<div/>", {
                      text: texto,
                      id: divId,
                      "class": "texto-select2-readonly",
                      "style": "display:none",
                      appendTo: combo.parent()
                    });
                    combo.next(".select2-container").hide(); // Oculto el combo
                }, 200);
        }

        document.getElementById("volverBtn").onclick = function() {
            $("#volver").val("true");
            $(".formBtn").attr("disabled", true);
            $("#formIngresoProv").submit();
        };

        document.getElementById("submitBtn").onclick = function() {
            $(".formBtn").attr("disabled", true);
            $("#formIngresoProv").submit();
        };

        llenarCombo({
        comboId : "cbObraSocial",
        ajaxUrlDiv : 'urlGetObrasSociales',
        idDefault : $("#idOsdepym").val(),
        readOnly:'true'
    });
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
