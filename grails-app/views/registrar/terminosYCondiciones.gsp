<!DOCTYPE html>
<html lang="en">

<head>
    <title>Registro</title>
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
                        <g:form action="registerMail" class="md-float-material">
                            <div class="text-center">
                                <asset:image src="auth/logo-dark.png"/>
                            </div>
                            <div class="auth-box">
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login">T??rminos y condiciones</h5>
                                    <div class="row m-t-25 text-left">
                                        <div class="col-md-12" style="color:#303548;">
                                            <strong>T??RMINOS Y CONDICIONES GENERALES DE CONTRATACI??N</strong><br/><br/>
                                                El presente establece los T??rminos y Condiciones Generales de Contrataci??n (los ???T??rminos y Condiciones???) que regir??n la relaci??n contractual por la cual ______________ (???CALIM???), con domicilio en _____________________________,  Ciudad Aut??noma de Buenos Aires, prestar?? los servicios que espec??ficamente sean contratados por terceros que re??nan las caracter??sticas aqu?? mencionadas, a trav??s de los medios disponibles.<br/><br/>
                                            <strong>1. Aceptaci??n de los T??rminos y Condiciones</strong><br/><br/>
                                                1.1. Estos T??rminos y Condiciones deben ser previa y expresamente aceptados por quienes tuvieren la intenci??n de ser considerados Clientes (conforme este t??rmino se define m??s adelante), gozar de los servicios ofrecidos por CALIM que se indican en el presente, en la forma aqu?? indicada y/o a trav??s de las formas que CALIM ponga a disposici??n a tales efectos, y para que exista una relaci??n contractual entre el Cliente y CALIM bajo estos T??rminos y Condiciones. Para ello, quien desee ser considerado Cliente de CALIM bajo estos T??rminos y Condiciones, deber?? aceptar los mismos  clickeando al lado de los respectivos cuadros que figuran al lado de las siguientes  frases ???He le??do los T??rminos y Condiciones??? y ???Acepto los T??rminos y Condiciones??? [ver si se ponen esas frases u otras]. Dicha aceptaci??n implicar?? conformidad del Cliente con todas y cada una de las cl??usulas y disposiciones de estos T??rminos y Condiciones.<br/><br/>
                                                1.2. El Cliente (conforme este t??rmino se define m??s adelante) acepta expresamente que estos T??rminos y Condiciones ser??n los que regir??n la relaci??n contractual entre ??l y CALIM en virtud de los cuales CALIM le prestar?? servicios bajo los mismos y que es de su exclusiva responsabilidad asesorarse respecto de los mismos en caso que lo entienda pertinente. Al aceptar los T??rminos y Condiciones se entender?? que el aceptante de los mismos habr?? tenido la oportunidad de recurrir al asesoramiento profesional que estimare pertinente.<br/><br/>
                                            <strong>2. Objeto</strong><br/><br/>
                                                Estos T??rminos y Condiciones regir??n la relaci??n entre CALIM y los Clientes (conforme este t??rmino se define m??s adelante) que contraten a trav??s de los Medios Electr??nicos Disponibles (conforme este t??rmino se define m??s adelante), servicios de liquidaci??n de impuestos y presentaci??n de declaraciones juradas de impuestos ofrecidos por CALIM en la forma aqu?? estipulada.<br/><br/>
                                            <strong>3. Clientes</strong><br/><br/>
                                                3.1. Se entender?? por ???Clientes??? (e individualmente cada uno un ???Cliente???) a todos aquellos que efectivamente contraten servicios de CALIM a trav??s de los Medios Electr??nicos Disponibles (conforme este t??rmino se define m??s adelante) que permitan la contrataci??n y siguiendo los pasos requeridos para que se considere que habr??n celebrado un contrato con CALIM.<br/><br/>
                                                3.2. S??lo podr??n ser Clientes personas f??sicas mayores de dieciocho (18) a??os que tengan Clave ??nica de Identificaci??n Tributaria (???CUIT???), tributen en la Ciudad Aut??noma de Buenos Aires o en la Provincia de Buenos Aires, est??n inscriptos en la Administraci??n Federal de Ingresos P??blicos (???AFIP???) como contribuyentes unipersonales responsables inscriptos o monotributistas, y/o en las administraciones provinciales o de la Ciudad Aut??noma de Buenos Aires como contribuyentes directos o convenio multilateral de ingresos brutos, y no tengan empleados a su cargo, ni sean importadores, exportadores, agentes de retenci??n y/o percepci??n de ning??n tipo tanto nacional como provincial, y/o grandes contribuyentes, ni encuadrados en reg??menes especiales de ning??n tipo. Estos requisitos deber??n permanecer vigentes, siendo obligaci??n del Cliente informar inmediatamente a CALIM cualquier cambio con relaci??n a los mismos.<br/><br/>
                                                3.3. Ser??n considerados Clientes s??lo quienes reciban una notificaci??n de CALIM inform??ndoles su aceptaci??n como tales. Ello implicar?? tambi??n que los Clientes habr??n previamente aceptado en su totalidad los T??rminos y Condiciones conforme lo establecido en el presente.<br/><br/>
                                                3.4. CALIM podr??, sin necesidad de expresi??n de causa alguna, aceptar o no como Clientes a quienes deseen serlo y/o hubieren manifestado ello iniciando el tr??mite de registraci??n y solicitud a trav??s de los Medios Electr??nicos Disponibles (conforme este t??rmino se defines m??s adelante).<br/><br/>
                                            <strong>4. Partes</strong><br/><br/>
                                                Se entender?? que CALIM y una persona que sea aceptada como Cliente por CALIM ser??n considerados las partes de un contrato de prestaci??n de servicios que vincular?? a ambos, y cada uno de ellos ser?? identificado como una ???Parte??? y ambos conjuntamente como las ???Partes???, a los fines de dicho contrato y de los presentes T??rminos y Condiciones.<br/><br/>
                                            <strong>5. Medios Electr??nicos Disponibles</strong><br/><br/>
                                                5.1. Ser??n considerados ???Medios Electr??nicos Disponibles??? (y cada uno individualmente un ???Medio Electr??nico Disponible???) a la plataforma web www.calim.com.ar, a la aplicaci??n (app) Calim, y/o a cualquier otro medio de comunicaci??n apto para que los Clientes contraten servicios ofrecidos por CALIM y/o interact??en con CALIM a trav??s de los mismos.<br/><br/>
                                                5.2. CALIM puede en cualquier momento actualizar los Medios Electr??nicos Disponibles como su funcionalidad, disposici??n y/o apariencia.<br/><br/>
                                                5.3. CALIM puede a su libre criterio variar los Medios Electr??nicos Disponibles cuando lo considere pertinentes.<br/><br/>
                                                5.4. Si bien puede haber m??s de un Medio Electr??nico Disponible, no necesariamente todas las funciones y actos podr??n hacerse en todos y cada uno de los Medios Electr??nicos Disponibles. Ello ser?? a opci??n exclusiva de CALIM, debiendo adaptarse y adecuarse el Cliente en todo momento a lo que CALIM disponga al respecto, como requisito para que CALIM le provea los servicios contratados.<br/><br/>
                                            <strong>6. Requisitos para contratar</strong><br/><br/>
                                                6.1. A los efectos de poder contratar servicios ofrecidos por CALIM, el potencial Cliente deber?? cumplir todos los requisitos que surjan tanto del presente como de los Medios Electr??nicos Disponibles. A modo de ejemplo, y sin que la siguiente enunciaci??n sea taxativa, el potencial Cliente deber?? brindar su n??mero de CUIT y un correo electr??nico de contacto. Este ??ltimo podr?? ser provisto en forma expresa (en cuyo caso el potencial Cliente deber?? crear e ingresar tambi??n una clave de identificaci??n o contrase??a, la cual CALIM puede solicitar que sea modificada en cualquier momento) o mediante vinculaci??n a redes sociales disponibles de las cuales surja autom??ticamente el email del potencial Cliente.<br/><br/>
                                                6.2. Asimismo, cada Cliente deber?? autorizar a CALIM y/o al Contador Asignado (conforme este t??rmino se define m??s adelante) y/o delegar en ellos en la forma pertinente, para que CALIM y/o el Contador Asignado (conforme este t??rmino se define m??s adelante) pueda, por cuenta y orden del Cliente, presentar ante las autoridades pertinentes las declaraciones juradas de impuestos respecto de los cuales el Cliente haya contratado los servicios de CALIM, como tambi??n para generar los volantes de pago y abonar los mismos.<br/><br/>
                                                6.3. Los Clientes deber??n proveer a CALIM toda la informaci??n que CALIM les solicite y se comprometen a mantener actualizada la misma e informa cualquier cambio a CALIM.<br/><br/>
                                                6.4. CALIM podr??, en caso de estimarlo pertinente, chequear la informaci??n brindada por el Cliente.<br/><br/>
                                            <strong>7. Servicios</strong><br/><br/>
                                                7.1. CALIM s??lo brindar?? al Cliente los servicios espec??ficamente contratados por el Cliente, sin perjuicio de que tambi??n se ofrezcan otros servicios en los Medios Electr??nicos Disponibles.<br/><br/>
                                                7.2. Al contratar, el Cliente deber?? indicar expresamente qu?? servicio de los ofrecidos por CALIM en los Medios Electr??nicos Disponibles desea contratar. De ello surgir??n los impuestos respecto de los cuales CALIM prestar?? servicios al Cliente. Tales servicios incluir??n preparaci??n de liquidaci??n de impuestos, presentaci??n de declaraciones juradas y pago de los impuestos incluidos en los servicios, como tambi??n asesoramiento b??sico y limitado con relaci??n a los mismos [esto es as??], previo cumplimiento por parte del Cliente de todos los requisitos y obligaciones a su cargo conforme lo establecido en el presente y en los Medios Electr??nicos Disponibles.<br/><br/>
                                                7.3. El Cliente podr?? modificar el tipo de servicio contratado por otro ofrecido por CALIM en los Medios Electr??nicos Disponibles, debi??ndolo informar a CALIM por cualquier Medio Electr??nico Disponible habilitado a tales efectos, y el cambio de servicio tendr?? validez luego de transcurridos ______ (___) d??as de ser solicitado por el Cliente.<br/><br/>
                                                7.4. La contrataci??n bajo los T??rminos y Condiciones se entender?? que permanecer?? vigente hasta que alguna de las Partes pusiere fin a la misma conforme lo estipulado en los mismos.<br/><br/>
                                                7.5. La prestaci??n de servicios es y ser?? siempre entendida como una obligaci??n de medios, no asegurando CALIM en ning??n caso ni circunstancia resultado alguno de dicha prestaci??n.<br/><br/>
                                            <strong>8. Asignaci??n de contador</strong><br/><br/>
                                                8.1. CALIM informar?? a cada Cliente el contador p??blico nacional que le asignar?? (el ???Contador Asignado???). Dicho profesional podr?? ser modificado en cualquier momento por CALIM sin previo aviso.<br/><br/>
                                                8.2 El Contador Asignado se encargar?? de la liquidaci??n de impuestos y presentaci??n de declaraciones juradas de impuestos por cuenta y orden del Cliente.<br/><br/>
                                                8.3. La actividad prestada por el Contador Asignado se entender?? brindada por CALIM.<br/><br/>
                                                8.4. Tanto CALIM cono el Contador Asignado no prestar??n asesoramiento en forma presencial. Todo se realizar?? a trav??s de Medios Electr??nicos Disponibles, salvo que CALIM eventualmente establezca y/o acepte lo contario.<br/><br/>
                                            <strong>9. Liquidaci??n de impuestos</strong><br/><br/>
                                                9.1. CALIM liquidar?? los impuestos cuya liquidaci??n y presentaci??n de declaraciones juradas hubiera sido contratada por el Cliente y siempre y cu??ndo ??ste cumpliera con los requisitos exigidos por CALIM.<br/><br/>
                                                9.2. CALIM utilizar?? la informaci??n que se encuentre disponible en los sistemas y(o plataformas de la AFIP, de la Administraci??n Gubernamental de Ingresos P??blicos del Gobierno de la Ciudad Aut??noma de Buenos Aires (AGIP) y/o de la Agencia de Recaudaci??n de la Provincia de Buenos Aires (ARBA), y/o de la agencia gubernamental correspondiente cuando CALIM pueda, en virtud de los servicios contratados por el Cliente, liquidar impuestos y presentar declaraciones juradas de impuestos en otras jurisdicciones.<br/><br/>
                                                 9.3. CALIM utilizar?? tambi??n la informaci??n que en forma adicional le provea el Cliente por los medios, en la forma y dentro del plazo que CALIM lo indique, siendo obligaci??n del Cliente cumplir en tiempo y forma con lo que CALIM le solicite.<br/><br/>
                                            <strong>10. Presentaci??n de declaraciones juradas de impuestos</strong><br/><br/>
                                                10.1. CALIM realizar?? por cuenta y orden del Cliente las presentaciones de las declaraciones juradas de los impuestos contratados por el Cliente, previa validaci??n y aprobaci??n del Cliente de la liquidaci??n de impuestos, del contenido de la declaraci??n jurada, y del monto a ser abonado respecto de cada impuesto correspondiente de acuerdo al servicio contratado por el Cliente, puesta a disposici??n por CALIM.<br/><br/>
                                                10.2. Tanto la puesta a disposici??n de la liquidaci??n de impuestos como de la declaraci??n jurada a ser presentada y del monto a pagar por parte de CALIM como la validaci??n y aprobaci??n por parte del Cliente se realizar?? trav??s de los Medios Electr??nicos Disponibles, salvo que CALIM habilite otra opci??n.<br/><br/>
                                            <strong>11. Pago de impuestos</strong><br/><br/>
                                                11.1. Seg??n CALIM lo disponga, el pago de las sumas que cada Cliente deba abonar con relaci??n a los impuestos contratados ser?? realizada por el Cliente o por CALIM por cuenta y orden del Cliente, quedando autorizado CALIM y/o el Contador Asignado a efectuarlo, y comprometi??ndose el Cliente a tomar previamente todas las medidas y actos necesarios para que CALIM y/o el Contador Asignado puedan realizarlo.<br/><br/>
                                                11.2. En los casos que CALIM y/o el Contador Asignado pague por cuenta y orden del Cliente, ser?? requisito previo para que se efect??e tal pago, que el Cliente previamente, y con una antelaci??n no menor a ____ (__) h??biles ponga a disposici??n de CALIM la totalidad de fondos necesarios para el pago de la totalidad del impuesto en cuesti??n, como tambi??n que el Cliente hubiere abonado la totalidad de las facturas emitidas por CALIM, no debiendo suma alguna a CALIM por ning??n concepto. Todo ello se realizar?? a trav??s de los medios de pago que CALIM indique.<br/><br/>
                                                11.3. Sin perjuicio de lo se??alado precedentemente, CALIM podr??, a su libre criterio, abonar, o hacer que el Contador Asignado abone, uno a m??s impuestos del Cliente a pesar de que el Cliente no hubiere cumplido con lo previsto en la cl??usula 11.2. del presente. En tal caso, ello no ser?? interpretado en modo alguno como una obligaci??n a futuro de CALIM y/o del Contador Asignado en cuanto a pagar impuestos por cuenta y orden del Cliente sin que ??ste hubiere cumplido lo previsto en la cl??usula 11.2. del presente.<br/><br/>
                                            <strong>12. Precio de los servicios</strong><br/><br/>
                                                12.1. CALIM cobrar?? al Cliente por los servicios contratados los precios que publique a trav??s de cualquiera de los Medios Electr??nicos Disponibles, seg??n el servicio contratado por el Cliente.<br/><br/>
                                                12.2. Los precios de los servicios podr??n ser modificados en cualquier momento por CALIM. Dicha modificaci??n ser?? informada a trav??s de los Medios Electr??nicos Disponibles y entrar?? en vigencia dentro de los cinco (5) d??as siguientes a su publicaci??n por tales medios, entendi??ndose que el Cliente estar?? informado por la simple publicaci??n de la forma indicada, sin perjuicio de que el Cliente hubiera efectivamente accedido a la publicaci??n. Sin perjuicio de ello, CALIM tambi??n podr?? informarlo de otra modo cuando lo estime pertinente.<br/><br/>
                                                12.3. CALIM facturar?? los servicios a mes vencido y el precio por los servicios deber?? ser abonado por el Cliente dentro de los primeros cinco (5) d??as del mes calendario inmediato siguiente al mes respecto del cual se habr??n facturado servicios.<br/><br/>
                                            <strong>13. Gastos</strong><br/><br/>
                                                13.1. El Cliente deber?? abonar a CALIM los gastos que le indique CALIM dentro de los cinco (5) d??as de serle requeridos.<br/><br/>
                                                13.2. CALIM cobrar?? los gastos incurridos en la preparaci??n y liquidaci??n de impuestos como la generaci??n de volantes de pago y el pago de los mismos, incluyendo sin limitaci??n los impuestos y comisiones que en su caso deba abonar CALIM a las entidades financieras y/o a los administradores de medios de pago que sean utilizados por los cr??ditos y d??bitos de fondos.<br/><br/>
                                                13.3. CALIM podr?? solicitar anticipo de gastos al Cliente cuando lo estime pertinente.<br/><br/>
                                            <strong>14. Pagos</strong><br/><br/>
                                                14.1. El Cliente s??lo podr?? efectuar pagos a CALIM a trav??s de los medios disponibles que en cada caso CALIM informe, y se compromete el Cliente a cumplir con todos los requisitos a tales fines, como, a modo de ejemplo, registrarse ante administradores de medios de pago.<br/><br/>
                                                14.2. Ante el incumplimiento del pago en t??rmino de cualquier pago por parte del Cliente, se producir?? la mora en forma autom??tica y de pleno derecho por el mero vencimiento del plazo, sin necesidad de interpelaci??n judicial y/o extrajudicial alguna, y se devengar??n intereses punitorios en forma diaria desde la mora y hasta el efectivo pago a la tasa del _____% mensual, sin perjuicio de los intereses compensatorios que CALIM tendr?? derecho a cobrar en forma adicional.<br/><br/>
                                            <strong>15. Suspensi??n y/o interrupci??n de servicios</strong><br/><br/>
                                                Ante el incumplimiento de cualquiera de las obligaciones a cargo del Cliente, incluyendo sin limitaci??n la falta de pago en t??rmino de cualquier suma y por cualquier concepto (facturaci??n de servicios, gastos, reintegro de sumas abonadas por CALIM, etc.), incumplimiento en t??rmino de la provisi??n de documentaci??n e informaci??n, de la realizaci??n de validaciones, de la provisi??n de fondos para aplicar a pagos, etc.,  y/o en caso de falsedad y/o inexactitud total o parcial de cualquiera de las manifestaciones y declaraciones efectuadas por el Cliente, CALIM podr?? establecer de inmediato la suspensi??n y/o interrupci??n de la prestaci??n de uno o m??s servicios al Cliente.<br/><br/>
                                            <strong>16. Reconocimientos del Cliente y exenciones de responsabilidad</strong><br/><br/>
                                                16.1. El Cliente reconoce y acepta que tanto para la vinculaci??n entre CALIM y el Cliente como para que CALIM pueda realizar sus tareas y brindar los servicios contratados ???por s?? y/o a trav??s de Contador Asignado-, se depender?? de sistemas y/o plataformas, de cualquiera de las Partes y/o de terceros, y que los mismos podr??an estar inactivos temporalmente, no funcionar correctamente, no ser compatibles, haber demoras de acceso o procesamiento, como tambi??n podr??a suceder que la informaci??n cargada no se cargue y/o no se cargue correctamente y en forma completa, y/o no est?? disponible o no sea visualizada correctamente.<br/><br/>
                                                16.2. El Cliente reconoce y acepta que CALIM y/o el Contador Asignado no ser??n responsables en forma alguna por la informaci??n disponible en los sistemas y plataformas de las entidades gubernamentales pertinentes.<br/><br/>
                                                16.3. El Cliente reconoce y acepta que la informaci??n que brinde a CALIM como la que est?? disponible en lo sistemas y plataformas de entidades gubernamentales, puede no ser veraz o ser incompleta, incorrecta, err??nea y/o inconsistente, siendo dicha informaci??n responsabilidad exclusiva del Cliente, reconociendo y aceptando el Cliente que CALIM no tendr?? responsabilidad alguno por es uso de la base y/o por las consecuencias del uso.<br/><br/>
                                                16.4. El Cliente reconoce y acepta que CALIM brindar?? sus servicios en base a la informaci??n disponible en los sistemas y plataformas de las entidades gubernamentales pertinentes y en la informaci??n brindada por el Cliente, sin tener responsabilidad de confirmar la validez, veracidad, exactitud, completitud o consistencia de la misma. Consecuentemente, el Cliente renuncia a efectuar reclamo alguno por da??os y perjuicios y/o por cualquier otro concepto a CALIM y/o al Contador Asignado con relaci??n a la mencionada informaci??n y/o al uso de la misma por parte de CALIM y/o el Contador Asignado. El Cliente garantiza la veracidad, exactitud, completitud y consistencia de tal informaci??n y autoriza a CALIM y al Contador Asignado el uso de la misma sobre la base de tal garant??a expresada por el Cliente.<br/><br/>
                                                16.5. El Cliente reconoce y acepta que cualquier falla de cualquier sistema y/o plataforma y/o la existencia de problemas de conexi??n y/o la demora en el acceso, y/o en el envi?? de la informaci??n pertinente en la forma adecuada, y/o el procesamiento de la misma en los sistemas y/o plataformas, podr?? ocasionar que declaraciones juradas de impuestos y/o pagos de impuestos se terminen efectuando fuera de t??rmino, y que CALIM y/o el Contador Asignado no ser??n responsables en forma alguna, renunciando el Cliente a efectuar reclamo alguno por da??os y perjuicios y/o por cualquier otro concepto a CALIM y/o al Contador Asignado.<br/><br/>
                                                16.6. El Cliente reconoce y acepta que CALIM podr?? utilizar y utilizar?? sistemas y plataformas de terceros y que no ser?? responsable en forma alguna frente al Cliente por cualquier problema que pudieran presentar las mismas y/o por las consecuencia de ello.<br/><br/>
                                                16.7. En ning??n momento CALIM y/o el Contador Asignado ser??n responsables frente al Cliente y/o cualquier tercero en supuestos de caso fortuito y/o fuerza mayor, quedando incluido dentro de los mismos, sin limitaci??n, a todas las fallas t??cnicas y/o de sistemas y/o de plataformas, de CALIM y/o de cualquier tercero, y/o demoras existentes por el funcionamiento de tales sistemas y/o por la compatibilidad de los mismos.<br/><br/>
                                                16.8. El Cliente reconoce y acepta que ser?? de su exclusiva responsabilidad el control de la contrase??a, del correo electr??nico y/o de cualquier forma electr??nica que le permita acceder a sistemas y/o plataformas y/o comunicarse con CALIM, y que CALIM confiar?? en la veracidad de lo informado, manifestado y/o comunicado a trav??s de cualquier medio electr??nico que hubiere sido escogido, informado y/o utilizado por el Cliente, como tambi??n por todo lo actuado en los sistemas de CALIM a los cuales se accede previa identificaci??n en forma electr??nica (como ser, a modo de ejemplo y no taxativo, la utilizaci??n de contrase??a y/o mediante vinculaci??n a trav??s de una casilla de correo electr??nico). El Cliente reconoce y acepta tambi??n que CALIM no puede asegurar la no intrusi??n de terceros en el sistema y/o la plataforma y/o la realizaci??n de actos ilegales efectuados por los mismos. Consecuentemente, el Cliente libera de toda responsabilidad a CALIM en caso de que terceros, sea que fueren intrusos que vulneren los sistemas de seguridad, o fueren personas que de alguna manera hubieren tenido acceso a contrase??a del Cliente y/o medio de identificaci??n electr??nica del mismo, tuvieren acceso a informaci??n y/o realicen acci??n alguna que perjudique en forma alguna al Cliente, renunciando el Cliente a efectuar reclamo por da??os y/o perjuicios por cualquier concepto a CALIM ante la eventualidad del acaecimiento de cualquiera de dichas circunstancias.<br/><br/>
                                                16.9. El Cliente reconoce y acepta que todo lo actuado por el Contador Asignado se entender?? realizado por CALIM a los efectos del presente, salvo dolo o culpa grave del Contador Asignado.<br/><br/>
                                            <strong>17. Indemnidad</strong><br/><br/>
                                                El Cliente indemnizar?? y mantendr?? indemne a CALIM, sus directores, funcionarios y accionistas, y a quienes hubieren sido Contador Asignado, por todos los da??os y/o perjuicios, directos, indirectos, mediatos y/o mediatos, incluyendo sin limitacis de cualqueuira de los Medios vs tambiones y/o notificaciones que las partes se cursen.nte en el domiiclio en el que sea su dom??n gastos, costas, reclamos de terceros, honorarios legales y de profesionales, que cualquiera de ellos pudiere sufrir en virtud y/o como consecuencia del contrato entre CALIM y el Cliente y/o de los servicios prestados en funci??n del mismo, y/o de las liquidaciones de impuestos, presentaciones de declaraciones juradas, generaci??n de volates de pago, y/o pago de los mismos,  excepto que la persona en cuesti??n hubiere actuado con dolo y/o culpa grave,<br/><br/>
                                            <strong>18. Terminaci??n de la prestaci??n de servicios</strong><br/><br/>
                                                18.1. Ante el incumplimiento por parte del Cliente de cualquiera de las obligaciones a su cargo, la mora se producir?? en forma autom??tica y de pleno derecho sin necesidad de interpelaci??n judicial y/o extrajudicial alguna por el mero vencimiento del plazo y/o el incumplimiento, y CALIM podr?? exigir el cumplimiento o dar por terminada la relaci??n contractual entre las Partes y rescindir el contrato por culpa exclusiva del Cliente, y, asimismo, en cualquiera de dichos casos, CALIM podr??, adem??s, reclamar los da??os y perjuicios directos, indirectos, inmediatos y mediatos sufridos en virtud del incumplimiento y/o como consecuencia del mismo.<br/><br/>
                                                18.2. CALIM podr?? dar por finalizada la prestaci??n de servicios y por concluido el contrato entre las Partes si el Cliente dejare de cumplir los requisitos necesarios para que CALIM le preste los servicios, incluyendo sin limitaci??n los previstos en la cl??usula 3.2. del presente. El Cliente no tendr?? derecho a reclamar da??o y/o perjuicio alguno en virtud de tal terminaci??n del contrato y/o como consecuencia de la misma.<br/><br/>
                                                18.3. CALIM podr?? en cualquier momento y sin necesidad de expresi??n de causa alguna, rescindir la relaci??n contractual entre las Partes, con efectos a partir del primer d??a del mes calendario que CALIM indique. El Cliente no tendr?? derecho a reclamar da??o y/o perjuicio alguno en virtud de tal terminaci??n del contrato y/o como consecuencia de la misma.<br/><br/>
                                                18.4. El Cliente podr?? en cualquier momento y sin necesidad de expresi??n de causa alguna, rescindir la relaci??n contractual entre las Partes, con efectos a partir del primer d??a del mes calendario que el Cliente indique. CALIM no tendr?? derecho a reclamar da??o y/o perjuicio alguno en virtud de tal terminaci??n del contrato y/o como consecuencia de la misma, sin perjuicio de que el Cliente deber?? pagar a CALIM todas las sumas que en su caso le adeude por cualquier concepto.<br/><br/>
                                            <strong>19. Datos de los Clientes</strong><br/><br/>
                                                19.1. El Cliente reconoce y acepta que CALIM tendr?? acceso a determinados datos del Cliente y que ello es indispensable para que pueda brindar los servicios.<br/><br/>
                                                19.2. CALIM queda expresa e irrevocablemente autorizado por el Cliente para almacenar y usar los datos de los Clientes con relaci??n a los servicios que prestar??, como tambi??n a fin de brindarle informaci??n y ofrecerle nuevos servicios, y, a tales efectos, tanto quien sea Contador Asignado y/o los empleados y/o asesores de CALIM y/o del Contador Asignado podr??n tener acceso a los mismos y usarlos a los efectos mencionados en el presente, prestando en consecuencia el Cliente, con la aceptaci??n de los T??rminos y Condiciones, su consentimiento expreso respecto de la recolecci??n, uso y tratamiento de sus datos que realizar?? CALIM conforme lo estipulado en el presente.<br/><br/>
                                                19.3. A los datos que CALIM obtenga del Cliente se le otorgar?? la protecci??n y el tratamiento que la normativa aplicable establezca.<br/><br/>
                                            <strong>20. Propiedad intelectual</strong><br/><br/>
                                                20.1. Los sistemas y plataformas puestos a disposici??n de los Clientes por CALIM, incluyendo sin limitaci??n, la plataforma web www.calim.com.ar y la aplicaci??n (app) Calim, como la disposici??n general de los mismos, el software utilizado, los textos, logos e im??genes contenidos en los mismos, son de exclusiva propiedad intelectual de CALIM y no se autoriza el uso de los mismos, en forma total o parcial,  a ning??n Cliente ni a ning??n tercero.<br/><br/>
                                                20.2. Las marcas y nombres comerciales utilizados por CALIM son de su exclusiva propiedad y no se autoriza a ning??n Cliente y/o a ning??n otro tercero el uso en forma alguna de los mismos.<br/><br/>
                                                20.3. El Cliente no podr?? reproducir, total o parcialmente, en forma alguna contenido de propiedad intelectual y/o intelectual de CALIM.<br/><br/>
                                            <strong>21. Comunicaciones y notificaciones</strong><br/><br/>
                                                21.1. Para todos los efectos legales derivados del presente, CALIM constituye domicilio especial en el indicado en el encabezamiento (o en el que en su caso comunique en el futuro) y cada Cliente en el domicilio en el que sea su domicilio fiscal registrado ante la AFIP, en los cuales se tendr??n por v??lidas y vinculantes todas las comunicaciones y/o notificaciones que las Partes se cursen.<br/><br/>
                                                21.2. Sin perjuicio de lo establecido en la cl??usula 21.1. del presente, las Partes tambi??n podr??n entablar comunicaciones a trav??s de cualquiera de los Medios Electr??nicos Disponibles que CALIM disponga a tales efectos, incluyendo sin limitaci??n correo electr??nico y whats app, y las mismas ser??n tenidas por v??lidas y vinculantes y como aptas para la transmisi??n de documentaci??n e informaci??n con relaci??n a los servicios que brindar?? CALIM.<br/><br/>
                                                22. Ley aplicable y resoluci??n de conflictos<br/><br/>
                                                22.1. Estos T??rminos y Condiciones, como tambi??n la celebraci??n, validez, interpretaci??n y ejecutabilidad de la relaci??n entre CALIM y los Clientes en virtud de los mismos, se regir??n por la ley de la Rep??blica Argentina.<br/><br/>
                                                22.2. En caso de controversia o diferendo entre las Partes, todo conflicto ser?? dirimido por los Tribunales Nacionales Ordinarios en lo Comercial de la Ciudad Aut??noma de Buenos Aires, con expresa renuncia de cada Parte a cualquier otro fuero y/o jurisdicci??n que en su caso pudiera corresponder.<br/><br/>
                                            <strong>23. Principio de validez y vigencia</strong><br/><br/>
                                                23.1. En caso de que cualquier disposici??n de estos T??rminos y Condiciones fuere total o parcialmente inv??lida, ilegal, nula, inoponible y/o inejecutable, ello no  obstar?? la validez, legalidad, vigencia, oponibilidad y ejecutabilidad de la otra parte de la disposici??n en cuesti??n y/o de las dem??s disposiciones de estos T??rminos y Condiciones. Ante cualquier duda, siempre prevalecer?? la vigencia de las disposiciones de estos T??rminos y Condiciones.<br/><br/>
                                                23.2. Cualquier acuerdo que en su caso tenga un Cliente con CALIM y/o con un Contador Asignado no ser?? aplicable a los servicios que contratar?? el Cliente en virtud de lo establecido en estos T??rminos y Condiciones, salvo que expresamente se establezca lo contrario.<br/><br/>
                                            <strong>24. Modificaci??n y complementaci??n de los T??rminos y Condiciones</strong><br/><br/>                                                 
                                                24.1. Estos T??rminos y Condiciones pueden ser modificados en cualquier momento por CALIM, En tal caso, deben ser aceptados por el Cliente como requisito para que CALIM le siga brindando los servicios. Ante la falta de aceptaci??n de los nuevos T??rminos y Condiciones (que reemplazar??n a los anteriormente vigentes en cada caso), CALIM podr?? suspender o interrumpir la prestaci??n de servicios y/o dar por concluida la relaci??n entra las Partes, sin que de ello derive derecho alguno a favor del Cliente de reclamar da??o y/o perjuicio alguno por ning??n concepto.<br/><br/>
                                                24.2. Estos T??rminos y Condiciones podr??n ser complementados por los t??rminos y condiciones y/o requisitos adicionales que CALIM en cualquier momento disponga y que sean informados a trav aceptado, salvo que de por concluido el contrato ci, nto disponga y que sean comunicaos por n el domiiclio en el que sea su dom??s aceptado, salvo que de por concluido el contrato ci, nto disponga y que sean comunicaos por n el domiiclio en el que sea su dom de cualquier Medio Electr??nico Disponible, sea de alcance particular o general. El Cliente acepta que se lo tendr?? por notificado de los mismos por la mera comunicaci??n efectuada de tal modo y que se entender?? que los habr?? aceptado, salvo que de por concluido el contrato sin que de ello derive a favor del Cliente derecho a ser indemnizado de da??o y/o perjuicio alguno por ning??n concepto. La vigencia de las disposiciones tendr?? efectos en forma inmediata a partir de su informaci??n y/o publicaci??n en la forma mencionada.<br/><br/>
                                        </div>
                                    </div>
                                    <hr/>

                                    <div class="row m-t-15">
                                        <div class="col-md-12">
                                            <g:link controller='registrar' action='registerMail' class="btn btn-primary btn-md btn-block waves-effect text-center m-b-10" style="color: #FFFFFF; text-decoration: none;">Aceptar</g:link>
                                        </div>
                                    </div>
                            </div>
                        </g:form>
                        <!-- end of form -->
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
            if(!$("#checkTyC").prop("checked")){
                alert("Acepte terminos y condiciones antes de continuar");
                event.preventDefault();
            }
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
