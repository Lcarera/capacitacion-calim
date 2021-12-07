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
                                <h5 class="b-b-default text-left txt-primary m-b-20 ttl-login">Términos y condiciones</h5>
                                    <div class="row m-t-25 text-left">
                                        <div class="col-md-12" style="color:#303548;">
                                            <strong>TÉRMINOS Y CONDICIONES GENERALES DE CONTRATACIÓN</strong><br/><br/>
                                                El presente establece los Términos y Condiciones Generales de Contratación (los “Términos y Condiciones”) que regirán la relación contractual por la cual ______________ (“CALIM”), con domicilio en _____________________________,  Ciudad Autónoma de Buenos Aires, prestará los servicios que específicamente sean contratados por terceros que reúnan las características aquí mencionadas, a través de los medios disponibles.<br/><br/>
                                            <strong>1. Aceptación de los Términos y Condiciones</strong><br/><br/>
                                                1.1. Estos Términos y Condiciones deben ser previa y expresamente aceptados por quienes tuvieren la intención de ser considerados Clientes (conforme este término se define más adelante), gozar de los servicios ofrecidos por CALIM que se indican en el presente, en la forma aquí indicada y/o a través de las formas que CALIM ponga a disposición a tales efectos, y para que exista una relación contractual entre el Cliente y CALIM bajo estos Términos y Condiciones. Para ello, quien desee ser considerado Cliente de CALIM bajo estos Términos y Condiciones, deberá aceptar los mismos  clickeando al lado de los respectivos cuadros que figuran al lado de las siguientes  frases “He leído los Términos y Condiciones” y “Acepto los Términos y Condiciones” [ver si se ponen esas frases u otras]. Dicha aceptación implicará conformidad del Cliente con todas y cada una de las cláusulas y disposiciones de estos Términos y Condiciones.<br/><br/>
                                                1.2. El Cliente (conforme este término se define más adelante) acepta expresamente que estos Términos y Condiciones serán los que regirán la relación contractual entre él y CALIM en virtud de los cuales CALIM le prestará servicios bajo los mismos y que es de su exclusiva responsabilidad asesorarse respecto de los mismos en caso que lo entienda pertinente. Al aceptar los Términos y Condiciones se entenderá que el aceptante de los mismos habrá tenido la oportunidad de recurrir al asesoramiento profesional que estimare pertinente.<br/><br/>
                                            <strong>2. Objeto</strong><br/><br/>
                                                Estos Términos y Condiciones regirán la relación entre CALIM y los Clientes (conforme este término se define más adelante) que contraten a través de los Medios Electrónicos Disponibles (conforme este término se define más adelante), servicios de liquidación de impuestos y presentación de declaraciones juradas de impuestos ofrecidos por CALIM en la forma aquí estipulada.<br/><br/>
                                            <strong>3. Clientes</strong><br/><br/>
                                                3.1. Se entenderá por “Clientes” (e individualmente cada uno un “Cliente”) a todos aquellos que efectivamente contraten servicios de CALIM a través de los Medios Electrónicos Disponibles (conforme este término se define más adelante) que permitan la contratación y siguiendo los pasos requeridos para que se considere que habrán celebrado un contrato con CALIM.<br/><br/>
                                                3.2. Sólo podrán ser Clientes personas físicas mayores de dieciocho (18) años que tengan Clave Única de Identificación Tributaria (“CUIT”), tributen en la Ciudad Autónoma de Buenos Aires o en la Provincia de Buenos Aires, estén inscriptos en la Administración Federal de Ingresos Públicos (“AFIP”) como contribuyentes unipersonales responsables inscriptos o monotributistas, y/o en las administraciones provinciales o de la Ciudad Autónoma de Buenos Aires como contribuyentes directos o convenio multilateral de ingresos brutos, y no tengan empleados a su cargo, ni sean importadores, exportadores, agentes de retención y/o percepción de ningún tipo tanto nacional como provincial, y/o grandes contribuyentes, ni encuadrados en regímenes especiales de ningún tipo. Estos requisitos deberán permanecer vigentes, siendo obligación del Cliente informar inmediatamente a CALIM cualquier cambio con relación a los mismos.<br/><br/>
                                                3.3. Serán considerados Clientes sólo quienes reciban una notificación de CALIM informándoles su aceptación como tales. Ello implicará también que los Clientes habrán previamente aceptado en su totalidad los Términos y Condiciones conforme lo establecido en el presente.<br/><br/>
                                                3.4. CALIM podrá, sin necesidad de expresión de causa alguna, aceptar o no como Clientes a quienes deseen serlo y/o hubieren manifestado ello iniciando el trámite de registración y solicitud a través de los Medios Electrónicos Disponibles (conforme este término se defines más adelante).<br/><br/>
                                            <strong>4. Partes</strong><br/><br/>
                                                Se entenderá que CALIM y una persona que sea aceptada como Cliente por CALIM serán considerados las partes de un contrato de prestación de servicios que vinculará a ambos, y cada uno de ellos será identificado como una “Parte” y ambos conjuntamente como las “Partes”, a los fines de dicho contrato y de los presentes Términos y Condiciones.<br/><br/>
                                            <strong>5. Medios Electrónicos Disponibles</strong><br/><br/>
                                                5.1. Serán considerados “Medios Electrónicos Disponibles” (y cada uno individualmente un “Medio Electrónico Disponible”) a la plataforma web www.calim.com.ar, a la aplicación (app) Calim, y/o a cualquier otro medio de comunicación apto para que los Clientes contraten servicios ofrecidos por CALIM y/o interactúen con CALIM a través de los mismos.<br/><br/>
                                                5.2. CALIM puede en cualquier momento actualizar los Medios Electrónicos Disponibles como su funcionalidad, disposición y/o apariencia.<br/><br/>
                                                5.3. CALIM puede a su libre criterio variar los Medios Electrónicos Disponibles cuando lo considere pertinentes.<br/><br/>
                                                5.4. Si bien puede haber más de un Medio Electrónico Disponible, no necesariamente todas las funciones y actos podrán hacerse en todos y cada uno de los Medios Electrónicos Disponibles. Ello será a opción exclusiva de CALIM, debiendo adaptarse y adecuarse el Cliente en todo momento a lo que CALIM disponga al respecto, como requisito para que CALIM le provea los servicios contratados.<br/><br/>
                                            <strong>6. Requisitos para contratar</strong><br/><br/>
                                                6.1. A los efectos de poder contratar servicios ofrecidos por CALIM, el potencial Cliente deberá cumplir todos los requisitos que surjan tanto del presente como de los Medios Electrónicos Disponibles. A modo de ejemplo, y sin que la siguiente enunciación sea taxativa, el potencial Cliente deberá brindar su número de CUIT y un correo electrónico de contacto. Este último podrá ser provisto en forma expresa (en cuyo caso el potencial Cliente deberá crear e ingresar también una clave de identificación o contraseña, la cual CALIM puede solicitar que sea modificada en cualquier momento) o mediante vinculación a redes sociales disponibles de las cuales surja automáticamente el email del potencial Cliente.<br/><br/>
                                                6.2. Asimismo, cada Cliente deberá autorizar a CALIM y/o al Contador Asignado (conforme este término se define más adelante) y/o delegar en ellos en la forma pertinente, para que CALIM y/o el Contador Asignado (conforme este término se define más adelante) pueda, por cuenta y orden del Cliente, presentar ante las autoridades pertinentes las declaraciones juradas de impuestos respecto de los cuales el Cliente haya contratado los servicios de CALIM, como también para generar los volantes de pago y abonar los mismos.<br/><br/>
                                                6.3. Los Clientes deberán proveer a CALIM toda la información que CALIM les solicite y se comprometen a mantener actualizada la misma e informa cualquier cambio a CALIM.<br/><br/>
                                                6.4. CALIM podrá, en caso de estimarlo pertinente, chequear la información brindada por el Cliente.<br/><br/>
                                            <strong>7. Servicios</strong><br/><br/>
                                                7.1. CALIM sólo brindará al Cliente los servicios específicamente contratados por el Cliente, sin perjuicio de que también se ofrezcan otros servicios en los Medios Electrónicos Disponibles.<br/><br/>
                                                7.2. Al contratar, el Cliente deberá indicar expresamente qué servicio de los ofrecidos por CALIM en los Medios Electrónicos Disponibles desea contratar. De ello surgirán los impuestos respecto de los cuales CALIM prestará servicios al Cliente. Tales servicios incluirán preparación de liquidación de impuestos, presentación de declaraciones juradas y pago de los impuestos incluidos en los servicios, como también asesoramiento básico y limitado con relación a los mismos [esto es así], previo cumplimiento por parte del Cliente de todos los requisitos y obligaciones a su cargo conforme lo establecido en el presente y en los Medios Electrónicos Disponibles.<br/><br/>
                                                7.3. El Cliente podrá modificar el tipo de servicio contratado por otro ofrecido por CALIM en los Medios Electrónicos Disponibles, debiéndolo informar a CALIM por cualquier Medio Electrónico Disponible habilitado a tales efectos, y el cambio de servicio tendrá validez luego de transcurridos ______ (___) días de ser solicitado por el Cliente.<br/><br/>
                                                7.4. La contratación bajo los Términos y Condiciones se entenderá que permanecerá vigente hasta que alguna de las Partes pusiere fin a la misma conforme lo estipulado en los mismos.<br/><br/>
                                                7.5. La prestación de servicios es y será siempre entendida como una obligación de medios, no asegurando CALIM en ningún caso ni circunstancia resultado alguno de dicha prestación.<br/><br/>
                                            <strong>8. Asignación de contador</strong><br/><br/>
                                                8.1. CALIM informará a cada Cliente el contador público nacional que le asignará (el “Contador Asignado”). Dicho profesional podrá ser modificado en cualquier momento por CALIM sin previo aviso.<br/><br/>
                                                8.2 El Contador Asignado se encargará de la liquidación de impuestos y presentación de declaraciones juradas de impuestos por cuenta y orden del Cliente.<br/><br/>
                                                8.3. La actividad prestada por el Contador Asignado se entenderá brindada por CALIM.<br/><br/>
                                                8.4. Tanto CALIM cono el Contador Asignado no prestarán asesoramiento en forma presencial. Todo se realizará a través de Medios Electrónicos Disponibles, salvo que CALIM eventualmente establezca y/o acepte lo contario.<br/><br/>
                                            <strong>9. Liquidación de impuestos</strong><br/><br/>
                                                9.1. CALIM liquidará los impuestos cuya liquidación y presentación de declaraciones juradas hubiera sido contratada por el Cliente y siempre y cuándo éste cumpliera con los requisitos exigidos por CALIM.<br/><br/>
                                                9.2. CALIM utilizará la información que se encuentre disponible en los sistemas y(o plataformas de la AFIP, de la Administración Gubernamental de Ingresos Públicos del Gobierno de la Ciudad Autónoma de Buenos Aires (AGIP) y/o de la Agencia de Recaudación de la Provincia de Buenos Aires (ARBA), y/o de la agencia gubernamental correspondiente cuando CALIM pueda, en virtud de los servicios contratados por el Cliente, liquidar impuestos y presentar declaraciones juradas de impuestos en otras jurisdicciones.<br/><br/>
                                                 9.3. CALIM utilizará también la información que en forma adicional le provea el Cliente por los medios, en la forma y dentro del plazo que CALIM lo indique, siendo obligación del Cliente cumplir en tiempo y forma con lo que CALIM le solicite.<br/><br/>
                                            <strong>10. Presentación de declaraciones juradas de impuestos</strong><br/><br/>
                                                10.1. CALIM realizará por cuenta y orden del Cliente las presentaciones de las declaraciones juradas de los impuestos contratados por el Cliente, previa validación y aprobación del Cliente de la liquidación de impuestos, del contenido de la declaración jurada, y del monto a ser abonado respecto de cada impuesto correspondiente de acuerdo al servicio contratado por el Cliente, puesta a disposición por CALIM.<br/><br/>
                                                10.2. Tanto la puesta a disposición de la liquidación de impuestos como de la declaración jurada a ser presentada y del monto a pagar por parte de CALIM como la validación y aprobación por parte del Cliente se realizará través de los Medios Electrónicos Disponibles, salvo que CALIM habilite otra opción.<br/><br/>
                                            <strong>11. Pago de impuestos</strong><br/><br/>
                                                11.1. Según CALIM lo disponga, el pago de las sumas que cada Cliente deba abonar con relación a los impuestos contratados será realizada por el Cliente o por CALIM por cuenta y orden del Cliente, quedando autorizado CALIM y/o el Contador Asignado a efectuarlo, y comprometiéndose el Cliente a tomar previamente todas las medidas y actos necesarios para que CALIM y/o el Contador Asignado puedan realizarlo.<br/><br/>
                                                11.2. En los casos que CALIM y/o el Contador Asignado pague por cuenta y orden del Cliente, será requisito previo para que se efectúe tal pago, que el Cliente previamente, y con una antelación no menor a ____ (__) hábiles ponga a disposición de CALIM la totalidad de fondos necesarios para el pago de la totalidad del impuesto en cuestión, como también que el Cliente hubiere abonado la totalidad de las facturas emitidas por CALIM, no debiendo suma alguna a CALIM por ningún concepto. Todo ello se realizará a través de los medios de pago que CALIM indique.<br/><br/>
                                                11.3. Sin perjuicio de lo señalado precedentemente, CALIM podrá, a su libre criterio, abonar, o hacer que el Contador Asignado abone, uno a más impuestos del Cliente a pesar de que el Cliente no hubiere cumplido con lo previsto en la cláusula 11.2. del presente. En tal caso, ello no será interpretado en modo alguno como una obligación a futuro de CALIM y/o del Contador Asignado en cuanto a pagar impuestos por cuenta y orden del Cliente sin que éste hubiere cumplido lo previsto en la cláusula 11.2. del presente.<br/><br/>
                                            <strong>12. Precio de los servicios</strong><br/><br/>
                                                12.1. CALIM cobrará al Cliente por los servicios contratados los precios que publique a través de cualquiera de los Medios Electrónicos Disponibles, según el servicio contratado por el Cliente.<br/><br/>
                                                12.2. Los precios de los servicios podrán ser modificados en cualquier momento por CALIM. Dicha modificación será informada a través de los Medios Electrónicos Disponibles y entrará en vigencia dentro de los cinco (5) días siguientes a su publicación por tales medios, entendiéndose que el Cliente estará informado por la simple publicación de la forma indicada, sin perjuicio de que el Cliente hubiera efectivamente accedido a la publicación. Sin perjuicio de ello, CALIM también podrá informarlo de otra modo cuando lo estime pertinente.<br/><br/>
                                                12.3. CALIM facturará los servicios a mes vencido y el precio por los servicios deberá ser abonado por el Cliente dentro de los primeros cinco (5) días del mes calendario inmediato siguiente al mes respecto del cual se habrán facturado servicios.<br/><br/>
                                            <strong>13. Gastos</strong><br/><br/>
                                                13.1. El Cliente deberá abonar a CALIM los gastos que le indique CALIM dentro de los cinco (5) días de serle requeridos.<br/><br/>
                                                13.2. CALIM cobrará los gastos incurridos en la preparación y liquidación de impuestos como la generación de volantes de pago y el pago de los mismos, incluyendo sin limitación los impuestos y comisiones que en su caso deba abonar CALIM a las entidades financieras y/o a los administradores de medios de pago que sean utilizados por los créditos y débitos de fondos.<br/><br/>
                                                13.3. CALIM podrá solicitar anticipo de gastos al Cliente cuando lo estime pertinente.<br/><br/>
                                            <strong>14. Pagos</strong><br/><br/>
                                                14.1. El Cliente sólo podrá efectuar pagos a CALIM a través de los medios disponibles que en cada caso CALIM informe, y se compromete el Cliente a cumplir con todos los requisitos a tales fines, como, a modo de ejemplo, registrarse ante administradores de medios de pago.<br/><br/>
                                                14.2. Ante el incumplimiento del pago en término de cualquier pago por parte del Cliente, se producirá la mora en forma automática y de pleno derecho por el mero vencimiento del plazo, sin necesidad de interpelación judicial y/o extrajudicial alguna, y se devengarán intereses punitorios en forma diaria desde la mora y hasta el efectivo pago a la tasa del _____% mensual, sin perjuicio de los intereses compensatorios que CALIM tendrá derecho a cobrar en forma adicional.<br/><br/>
                                            <strong>15. Suspensión y/o interrupción de servicios</strong><br/><br/>
                                                Ante el incumplimiento de cualquiera de las obligaciones a cargo del Cliente, incluyendo sin limitación la falta de pago en término de cualquier suma y por cualquier concepto (facturación de servicios, gastos, reintegro de sumas abonadas por CALIM, etc.), incumplimiento en término de la provisión de documentación e información, de la realización de validaciones, de la provisión de fondos para aplicar a pagos, etc.,  y/o en caso de falsedad y/o inexactitud total o parcial de cualquiera de las manifestaciones y declaraciones efectuadas por el Cliente, CALIM podrá establecer de inmediato la suspensión y/o interrupción de la prestación de uno o más servicios al Cliente.<br/><br/>
                                            <strong>16. Reconocimientos del Cliente y exenciones de responsabilidad</strong><br/><br/>
                                                16.1. El Cliente reconoce y acepta que tanto para la vinculación entre CALIM y el Cliente como para que CALIM pueda realizar sus tareas y brindar los servicios contratados –por sí y/o a través de Contador Asignado-, se dependerá de sistemas y/o plataformas, de cualquiera de las Partes y/o de terceros, y que los mismos podrían estar inactivos temporalmente, no funcionar correctamente, no ser compatibles, haber demoras de acceso o procesamiento, como también podría suceder que la información cargada no se cargue y/o no se cargue correctamente y en forma completa, y/o no esté disponible o no sea visualizada correctamente.<br/><br/>
                                                16.2. El Cliente reconoce y acepta que CALIM y/o el Contador Asignado no serán responsables en forma alguna por la información disponible en los sistemas y plataformas de las entidades gubernamentales pertinentes.<br/><br/>
                                                16.3. El Cliente reconoce y acepta que la información que brinde a CALIM como la que esté disponible en lo sistemas y plataformas de entidades gubernamentales, puede no ser veraz o ser incompleta, incorrecta, errónea y/o inconsistente, siendo dicha información responsabilidad exclusiva del Cliente, reconociendo y aceptando el Cliente que CALIM no tendrá responsabilidad alguno por es uso de la base y/o por las consecuencias del uso.<br/><br/>
                                                16.4. El Cliente reconoce y acepta que CALIM brindará sus servicios en base a la información disponible en los sistemas y plataformas de las entidades gubernamentales pertinentes y en la información brindada por el Cliente, sin tener responsabilidad de confirmar la validez, veracidad, exactitud, completitud o consistencia de la misma. Consecuentemente, el Cliente renuncia a efectuar reclamo alguno por daños y perjuicios y/o por cualquier otro concepto a CALIM y/o al Contador Asignado con relación a la mencionada información y/o al uso de la misma por parte de CALIM y/o el Contador Asignado. El Cliente garantiza la veracidad, exactitud, completitud y consistencia de tal información y autoriza a CALIM y al Contador Asignado el uso de la misma sobre la base de tal garantía expresada por el Cliente.<br/><br/>
                                                16.5. El Cliente reconoce y acepta que cualquier falla de cualquier sistema y/o plataforma y/o la existencia de problemas de conexión y/o la demora en el acceso, y/o en el envió de la información pertinente en la forma adecuada, y/o el procesamiento de la misma en los sistemas y/o plataformas, podrá ocasionar que declaraciones juradas de impuestos y/o pagos de impuestos se terminen efectuando fuera de término, y que CALIM y/o el Contador Asignado no serán responsables en forma alguna, renunciando el Cliente a efectuar reclamo alguno por daños y perjuicios y/o por cualquier otro concepto a CALIM y/o al Contador Asignado.<br/><br/>
                                                16.6. El Cliente reconoce y acepta que CALIM podrá utilizar y utilizará sistemas y plataformas de terceros y que no será responsable en forma alguna frente al Cliente por cualquier problema que pudieran presentar las mismas y/o por las consecuencia de ello.<br/><br/>
                                                16.7. En ningún momento CALIM y/o el Contador Asignado serán responsables frente al Cliente y/o cualquier tercero en supuestos de caso fortuito y/o fuerza mayor, quedando incluido dentro de los mismos, sin limitación, a todas las fallas técnicas y/o de sistemas y/o de plataformas, de CALIM y/o de cualquier tercero, y/o demoras existentes por el funcionamiento de tales sistemas y/o por la compatibilidad de los mismos.<br/><br/>
                                                16.8. El Cliente reconoce y acepta que será de su exclusiva responsabilidad el control de la contraseña, del correo electrónico y/o de cualquier forma electrónica que le permita acceder a sistemas y/o plataformas y/o comunicarse con CALIM, y que CALIM confiará en la veracidad de lo informado, manifestado y/o comunicado a través de cualquier medio electrónico que hubiere sido escogido, informado y/o utilizado por el Cliente, como también por todo lo actuado en los sistemas de CALIM a los cuales se accede previa identificación en forma electrónica (como ser, a modo de ejemplo y no taxativo, la utilización de contraseña y/o mediante vinculación a través de una casilla de correo electrónico). El Cliente reconoce y acepta también que CALIM no puede asegurar la no intrusión de terceros en el sistema y/o la plataforma y/o la realización de actos ilegales efectuados por los mismos. Consecuentemente, el Cliente libera de toda responsabilidad a CALIM en caso de que terceros, sea que fueren intrusos que vulneren los sistemas de seguridad, o fueren personas que de alguna manera hubieren tenido acceso a contraseña del Cliente y/o medio de identificación electrónica del mismo, tuvieren acceso a información y/o realicen acción alguna que perjudique en forma alguna al Cliente, renunciando el Cliente a efectuar reclamo por daños y/o perjuicios por cualquier concepto a CALIM ante la eventualidad del acaecimiento de cualquiera de dichas circunstancias.<br/><br/>
                                                16.9. El Cliente reconoce y acepta que todo lo actuado por el Contador Asignado se entenderá realizado por CALIM a los efectos del presente, salvo dolo o culpa grave del Contador Asignado.<br/><br/>
                                            <strong>17. Indemnidad</strong><br/><br/>
                                                El Cliente indemnizará y mantendrá indemne a CALIM, sus directores, funcionarios y accionistas, y a quienes hubieren sido Contador Asignado, por todos los daños y/o perjuicios, directos, indirectos, mediatos y/o mediatos, incluyendo sin limitacis de cualqueuira de los Medios vs tambiones y/o notificaciones que las partes se cursen.nte en el domiiclio en el que sea su domón gastos, costas, reclamos de terceros, honorarios legales y de profesionales, que cualquiera de ellos pudiere sufrir en virtud y/o como consecuencia del contrato entre CALIM y el Cliente y/o de los servicios prestados en función del mismo, y/o de las liquidaciones de impuestos, presentaciones de declaraciones juradas, generación de volates de pago, y/o pago de los mismos,  excepto que la persona en cuestión hubiere actuado con dolo y/o culpa grave,<br/><br/>
                                            <strong>18. Terminación de la prestación de servicios</strong><br/><br/>
                                                18.1. Ante el incumplimiento por parte del Cliente de cualquiera de las obligaciones a su cargo, la mora se producirá en forma automática y de pleno derecho sin necesidad de interpelación judicial y/o extrajudicial alguna por el mero vencimiento del plazo y/o el incumplimiento, y CALIM podrá exigir el cumplimiento o dar por terminada la relación contractual entre las Partes y rescindir el contrato por culpa exclusiva del Cliente, y, asimismo, en cualquiera de dichos casos, CALIM podrá, además, reclamar los daños y perjuicios directos, indirectos, inmediatos y mediatos sufridos en virtud del incumplimiento y/o como consecuencia del mismo.<br/><br/>
                                                18.2. CALIM podrá dar por finalizada la prestación de servicios y por concluido el contrato entre las Partes si el Cliente dejare de cumplir los requisitos necesarios para que CALIM le preste los servicios, incluyendo sin limitación los previstos en la cláusula 3.2. del presente. El Cliente no tendrá derecho a reclamar daño y/o perjuicio alguno en virtud de tal terminación del contrato y/o como consecuencia de la misma.<br/><br/>
                                                18.3. CALIM podrá en cualquier momento y sin necesidad de expresión de causa alguna, rescindir la relación contractual entre las Partes, con efectos a partir del primer día del mes calendario que CALIM indique. El Cliente no tendrá derecho a reclamar daño y/o perjuicio alguno en virtud de tal terminación del contrato y/o como consecuencia de la misma.<br/><br/>
                                                18.4. El Cliente podrá en cualquier momento y sin necesidad de expresión de causa alguna, rescindir la relación contractual entre las Partes, con efectos a partir del primer día del mes calendario que el Cliente indique. CALIM no tendrá derecho a reclamar daño y/o perjuicio alguno en virtud de tal terminación del contrato y/o como consecuencia de la misma, sin perjuicio de que el Cliente deberá pagar a CALIM todas las sumas que en su caso le adeude por cualquier concepto.<br/><br/>
                                            <strong>19. Datos de los Clientes</strong><br/><br/>
                                                19.1. El Cliente reconoce y acepta que CALIM tendrá acceso a determinados datos del Cliente y que ello es indispensable para que pueda brindar los servicios.<br/><br/>
                                                19.2. CALIM queda expresa e irrevocablemente autorizado por el Cliente para almacenar y usar los datos de los Clientes con relación a los servicios que prestará, como también a fin de brindarle información y ofrecerle nuevos servicios, y, a tales efectos, tanto quien sea Contador Asignado y/o los empleados y/o asesores de CALIM y/o del Contador Asignado podrán tener acceso a los mismos y usarlos a los efectos mencionados en el presente, prestando en consecuencia el Cliente, con la aceptación de los Términos y Condiciones, su consentimiento expreso respecto de la recolección, uso y tratamiento de sus datos que realizará CALIM conforme lo estipulado en el presente.<br/><br/>
                                                19.3. A los datos que CALIM obtenga del Cliente se le otorgará la protección y el tratamiento que la normativa aplicable establezca.<br/><br/>
                                            <strong>20. Propiedad intelectual</strong><br/><br/>
                                                20.1. Los sistemas y plataformas puestos a disposición de los Clientes por CALIM, incluyendo sin limitación, la plataforma web www.calim.com.ar y la aplicación (app) Calim, como la disposición general de los mismos, el software utilizado, los textos, logos e imágenes contenidos en los mismos, son de exclusiva propiedad intelectual de CALIM y no se autoriza el uso de los mismos, en forma total o parcial,  a ningún Cliente ni a ningún tercero.<br/><br/>
                                                20.2. Las marcas y nombres comerciales utilizados por CALIM son de su exclusiva propiedad y no se autoriza a ningún Cliente y/o a ningún otro tercero el uso en forma alguna de los mismos.<br/><br/>
                                                20.3. El Cliente no podrá reproducir, total o parcialmente, en forma alguna contenido de propiedad intelectual y/o intelectual de CALIM.<br/><br/>
                                            <strong>21. Comunicaciones y notificaciones</strong><br/><br/>
                                                21.1. Para todos los efectos legales derivados del presente, CALIM constituye domicilio especial en el indicado en el encabezamiento (o en el que en su caso comunique en el futuro) y cada Cliente en el domicilio en el que sea su domicilio fiscal registrado ante la AFIP, en los cuales se tendrán por válidas y vinculantes todas las comunicaciones y/o notificaciones que las Partes se cursen.<br/><br/>
                                                21.2. Sin perjuicio de lo establecido en la cláusula 21.1. del presente, las Partes también podrán entablar comunicaciones a través de cualquiera de los Medios Electrónicos Disponibles que CALIM disponga a tales efectos, incluyendo sin limitación correo electrónico y whats app, y las mismas serán tenidas por válidas y vinculantes y como aptas para la transmisión de documentación e información con relación a los servicios que brindará CALIM.<br/><br/>
                                                22. Ley aplicable y resolución de conflictos<br/><br/>
                                                22.1. Estos Términos y Condiciones, como también la celebración, validez, interpretación y ejecutabilidad de la relación entre CALIM y los Clientes en virtud de los mismos, se regirán por la ley de la República Argentina.<br/><br/>
                                                22.2. En caso de controversia o diferendo entre las Partes, todo conflicto será dirimido por los Tribunales Nacionales Ordinarios en lo Comercial de la Ciudad Autónoma de Buenos Aires, con expresa renuncia de cada Parte a cualquier otro fuero y/o jurisdicción que en su caso pudiera corresponder.<br/><br/>
                                            <strong>23. Principio de validez y vigencia</strong><br/><br/>
                                                23.1. En caso de que cualquier disposición de estos Términos y Condiciones fuere total o parcialmente inválida, ilegal, nula, inoponible y/o inejecutable, ello no  obstará la validez, legalidad, vigencia, oponibilidad y ejecutabilidad de la otra parte de la disposición en cuestión y/o de las demás disposiciones de estos Términos y Condiciones. Ante cualquier duda, siempre prevalecerá la vigencia de las disposiciones de estos Términos y Condiciones.<br/><br/>
                                                23.2. Cualquier acuerdo que en su caso tenga un Cliente con CALIM y/o con un Contador Asignado no será aplicable a los servicios que contratará el Cliente en virtud de lo establecido en estos Términos y Condiciones, salvo que expresamente se establezca lo contrario.<br/><br/>
                                            <strong>24. Modificación y complementación de los Términos y Condiciones</strong><br/><br/>                                                 
                                                24.1. Estos Términos y Condiciones pueden ser modificados en cualquier momento por CALIM, En tal caso, deben ser aceptados por el Cliente como requisito para que CALIM le siga brindando los servicios. Ante la falta de aceptación de los nuevos Términos y Condiciones (que reemplazarán a los anteriormente vigentes en cada caso), CALIM podrá suspender o interrumpir la prestación de servicios y/o dar por concluida la relación entra las Partes, sin que de ello derive derecho alguno a favor del Cliente de reclamar daño y/o perjuicio alguno por ningún concepto.<br/><br/>
                                                24.2. Estos Términos y Condiciones podrán ser complementados por los términos y condiciones y/o requisitos adicionales que CALIM en cualquier momento disponga y que sean informados a trav aceptado, salvo que de por concluido el contrato ci, nto disponga y que sean comunicaos por n el domiiclio en el que sea su domés aceptado, salvo que de por concluido el contrato ci, nto disponga y que sean comunicaos por n el domiiclio en el que sea su dom de cualquier Medio Electrónico Disponible, sea de alcance particular o general. El Cliente acepta que se lo tendrá por notificado de los mismos por la mera comunicación efectuada de tal modo y que se entenderá que los habrá aceptado, salvo que de por concluido el contrato sin que de ello derive a favor del Cliente derecho a ser indemnizado de daño y/o perjuicio alguno por ningún concepto. La vigencia de las disposiciones tendrá efectos en forma inmediata a partir de su información y/o publicación en la forma mencionada.<br/><br/>
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
