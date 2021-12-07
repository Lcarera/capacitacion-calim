<!DOCTYPE html>
<html lang="en">

<head>
    <meta name="layout" content="registroLayout">
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
                    <div class="login-card auth-body mr-auto ml-auto" style="color:#666666;">
                        <g:form action="confirmarCUIT" class="md-float-material">
                            
                            <g:hiddenField name="cuit" value="${datos.cuit}"/>
                            <g:hiddenField name="nombre" value="${datos.nombre}"/>
                            <g:hiddenField name="apellido" value="${datos.apellido}"/>
                            <g:hiddenField name="razonSocial" value="${datos.razonSocial}"/>
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
                                <div class="row m-b-20">
                                    <div class="col-md-12 m-t-20"><h2 class="text-left">¿Estos son tus datos?</h2></div>
                                    <div class="col-md-12">
                                        <h3 class="text-left txt-primary">${datos.razonSocial}</h3>
                                        <h5 class="text-left txt-primary cuit">CUIT: ${datos.cuit}</h5>
                                    </div>
                                </div>
                                
                                <div class="table-responsive">
                                    <table class="table m-0">
                                        <tbody>
                                            <tr>
                                                <th style="white-space:normal;" scope="row">Persona</th>
                                                <td style="white-space:normal;width:60%;">${datos.tipo}</td>
                                            </tr>
                                            <tr>
                                                <th style="white-space:normal;" scope="row">Domicilio</th>
                                                <td style="white-space:normal;width:60%;">${datos.domicilio}</td>
                                            </tr>
                                            <tr>
                                                <th style="white-space:normal;" scope="row">Localidad</th>
                                                <td style="white-space:normal;width:60%;">${datos.localidad}</td>
                                            </tr>
                                            <tr>
                                                <th style="white-space:normal;" scope="row">Impuestos</th>
                                                <td style="white-space:normal;width:60%;">
                                                    ${datos.tipoIva}
                                                    <g:if test="${datos.impuestos}">
                                                        ${raw(datos.impuestos)}
                                                    </g:if>
                                                </td>
                                            </tr>
                                            <g:if test="${datos.categoria}">
                                                <tr>
                                                    <th style="white-space:normal;" scope="row">Categoría</th>
                                                    <td style="white-space:normal;width:60%;">${datos.categoria}</td>
                                                </tr>
                                            </g:if>
                                            <tr>
                                                <th style="white-space:normal;" scope="row">Actividad</th>
                                                <td style="white-space:normal;width:60%;">${datos.actividad}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <div class="row m-t-20">
                                    <div class="col-md-12">
                                        <hr/>
                                        <p class="text-inverse text-left">Al continuar declaro que he leído y acepto los <a href="https://calim.com.ar/terminos-y-condiciones" target="_blank" style="color:#303548!important;"><b> términos y condiciones</b></a> de CALIM.</p>
                                   </div>
                                    <div class="col-xs-6">
                                    <g:link action="index">
                                        <button type="button" class="btn btn-primary btn-md btn-block waves-effect text-center m-b-20"><i class="icon-arrow-left arrow-left"></i>No</button>
                                    </g:link>
                                    </div>
                                    <div class="col-xs-6">
                                        <button type="submit" class="btn btn-primary btn-md btn-block waves-effect text-center m-b-20">Sí<i class="icon-arrow-right arrow-right"></i></button>
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
</body>

</html>
