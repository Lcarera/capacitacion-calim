<!DOCTYPE html>
<html lang="en">

<head>
	<!-- Google Tag Manager -->
	<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-NPFKM22');
	</script>
	<!-- End Google Tag Manager -->

    <title>Calim</title>
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
    <asset:stylesheet src="application" />
	<asset:javascript src="application" />
	
	<g:layoutHead/>
</head>
<!-- Menu sidebar static layout -->

<body>
	<!-- Google Tag Manager (noscript) -->
	<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-NPFKM22" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
	<!-- End Google Tag Manager (noscript) -->

<%@ page import="com.zifras.User" %>
<%@ page import="com.zifras.Estudio" %>
<%@ page import="com.zifras.ItemMenu" %>
<%@ page import="com.zifras.Role" %>
<%@ page import="com.zifras.cuenta.Cuenta" %>

	<g:set var="userLogged" value="${User.get(session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id)}"/>
	<g:set var="estudio" value="${Estudio.get(userLogged?.userTenantId.toString())}"/>
	<g:set var="cuenta" value="${userLogged?.cuenta}"/>
	<g:hiddenField id="flashMessage" name="flashMessage" value="${flash.message}"/>
	<g:hiddenField id="flashError" name="flashError" value="${flash.error}"/>
	<sec:ifAnyGranted roles="ROLE_CUENTA, ROLE_RIDER_PY, ROLE_ADMIN_PY">
		<g:hiddenField id="perfil" name="perfil" value="esconder_lateral"/>
	</sec:ifAnyGranted>
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
	
	<!-- Validation js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.6/moment.min.js"></script>
	
	<!-- Pre-loader end -->
    <div id="pcoded" class="pcoded">
        <div class="pcoded-overlay-box"></div>
        <div class="pcoded-container navbar-wrapper">

            <nav class="navbar header-navbar pcoded-header">
                <div class="navbar-wrapper">

                    <div class="navbar-logo">
                        <a class="mobile-menu" id="mobile-collapse" href="#">
                            <i class="ti-menu"></i>
                        </a>
                        <a class="mobile-search morphsearch-search" href="#">
                            <i class="ti-search"></i>
                        </a>
                        <g:link controller="start" action="index">
                            <img class="img-fluid" src="${resource(dir: 'assets/guru/assets/images', file: 'logo-dark.png')}" alt="Theme-Logo" />
                        </g:link>
                    </div>

                    <div class="navbar-container container-fluid">
                    	<sec:ifAnyGranted roles="ROLE_CUENTA">
							<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_CUENTA'), 'SUPERIOR', null))?.hijos }" var="itemMenu" status="i">
								<ul class="nav-left">
									<li id="" class="">
										<g:link controller="${itemMenu.controller}" action="${itemMenu.action}">
											<span class="pcoded-micon"><i class="${itemMenu.icono}"></i></span>
											<span id="span${itemMenu.controller}${itemMenu.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
												${itemMenu.nombre}
												<g:if test="${(itemMenu.nombre == 'Liquidaciones') && (cuenta.poseeLiquidacionNoAutorizada() > 0)}">
													<label class="badge badge-danger">${cuenta.poseeLiquidacionNoAutorizada()}</label>
												</g:if>
												<g:if test="${(itemMenu.nombre == 'Notificaciones') && (cuenta.poseeNotificacionesNoLeidas())}">
													<label id="badgeNotificaciones" class="badge badge-danger">${cuenta.notificacionesNoLeidas()}</label>
												</g:if>
											</span>
											<span class="pcoded-mcaret"></span>
										</g:link>
									</li>
								</ul>
							</g:each>
						
	                        <ul class="nav-right">
	                        	<li class="user-profile header-notification">
                                    <img class="img-80 img-radius" src="${resource(dir: 'assets/guru/assets/images', file: 'avatar-5.jpg')}" alt="User-Profile-Image">
                                    <div class="info-user">
                                    	<div>${cuenta?.razonSocial}</div>
                                        <div style="font-size: 12px;">${cuenta?.condicionIva?.nombre}<i class="ti-angle-down"></i></div>
                                        <!--<div style="font-size: 12px;">${userLogged?.username}</div>-->
                                    </div>
	                                <ul class="show-notification profile-notification">
	                                    <li>
	                                        <g:link controller="cuentaUsuario" action="show">
	                                            <i class="ti-user"></i> Mi Perfil
	                                        </g:link>
	                                    </li>
	                                    <li>
	                                        <g:link controller="miCuenta" action="show">
	                                            <i class="ti-wallet"></i> Mi cuenta Calim
	                                        </g:link>
	                                    </li>
	                                    <li>
	                                    <g:link controller="logout" action="index">
	                                        <i class="ti-power-off"></i> Salir
	                                    </g:link>
	                                	</li>
	                                </ul>
                            	</li>
	                        </ul>
                        </sec:ifAnyGranted>
                    	<sec:ifAnyGranted roles="ROLE_ADMIN_PY">
							<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_ADMIN_PY'), 'SUPERIOR', null))?.hijos }" var="itemMenu" status="i">
								<ul class="nav-left">
									<li id="" class="">
										<g:link controller="${itemMenu.controller}" action="${itemMenu.action}">
											<span class="pcoded-micon"><i class="${itemMenu.icono}"></i></span>
											<span id="span${itemMenu.controller}${itemMenu.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
												${itemMenu.nombre}
											</span>
											<span class="pcoded-mcaret"></span>
										</g:link>
									</li>
								</ul>
							</g:each>
                        </sec:ifAnyGranted>
                    	<sec:ifAnyGranted roles="ROLE_RIDER_PY">
							<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_RIDER_PY'), 'SUPERIOR', null))?.hijos }" var="itemMenu" status="i">
								<ul class="nav-left">
									<li id="" class="">
										<g:link controller="${itemMenu.controller}" action="${itemMenu.action}">
											<span class="pcoded-micon"><i class="${itemMenu.icono}"></i></span>
											<span id="span${itemMenu.controller}${itemMenu.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
												${itemMenu.nombre}
											</span>
											<span class="pcoded-mcaret"></span>
										</g:link>
									</li>
								</ul>
							</g:each>
                        </sec:ifAnyGranted>
                        <sec:ifNotGranted roles="ROLE_CUENTA">
                        	<ul class="nav-right">
                        		<li id="" class="">
                        			<g:link controller="logout" action="index">
                        				<span class="pcoded-micon"><i class="ti-power-off"></i></span>
                        				<span class="pcoded-mtext" data-i18n="nav.dash.main">
                        					Salir
                        				</span>
                        			</g:link>
                        		</li>
                        	</ul>
                    	</sec:ifNotGranted>
                    </div>
                </div>
            </nav>

            <div class="pcoded-main-container">
                <div class="pcoded-wrapper">
                    <nav class="pcoded-navbar" id="menuPrincipal">
                        <div class="sidebar_toggle"><a href="#"><i class="icon-close icons"></i></a></div>
                        <div class="pcoded-inner-navbar main-menu">
                            <div class="">
                                <div class="main-menu-header">
                                    <img class="img-40 img-radius" src="${resource(dir: 'assets/guru/assets/images', file: 'avatar-4.jpg')}" alt="User-Profile-Image">
                                    <div class="user-details">
                                    	<g:link controller="usuario" action="show" id="${userLogged?.id}">
	                                        <span id="more-details" style="text-transform:none;">${userLogged?.username}</span>
	                                        <sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_USER, ROLE_LECTURA">
											<span id="more-details" style="text-transform:none;">Estudio: ${estudio?.nombre}</span>
											</sec:ifAnyGranted>
											<sec:ifAnyGranted roles="ROLE_CUENTA">
											<span id="more-details" style="text-transform:none;">${cuenta?.condicionIva?.nombre}</span>
											</sec:ifAnyGranted>
										</g:link>
                                    </div>
                                </div>
                            </div>
							
							<sec:ifAnyGranted roles="ROLE_ADMIN">
								<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_ADMIN'), 'PRINCIPAL', null))?.hijos }" var="itemMenu" status="i">
									<ul class="pcoded-item pcoded-left-item">
										<li id="" class="pcoded-hasmenu ${(controllerName == itemMenu.controller)?'active pcoded-trigger':''}">
											<a href="javascript:void(0)">
												<span class="pcoded-micon"><i class="${itemMenu.icono}"></i></span>
												<span class="pcoded-mtext" data-i18n="nav.basic-components.main">${itemMenu.nombre}</span>
												<span class="pcoded-mcaret"></span>
											</a>
											<ul class="pcoded-submenu">
												<g:each in="${itemMenu.hijos}" var="itemMenuHijo" status="j">
													<li id="li${itemMenuHijo.controller}${itemMenuHijo.action}" class="">
														<g:link controller="${itemMenuHijo.controller}" action="${itemMenuHijo.action}">
															<span id="span${itemMenuHijo.controller}${itemMenuHijo.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
																${itemMenuHijo.nombre}
															</span>
														</g:link>
													</li>
												</g:each>
											</ul>
										</li>
									</ul>
								</g:each>
							</sec:ifAnyGranted>
							
							<sec:ifAnyGranted roles="ROLE_USER">
								<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_USER'), 'PRINCIPAL', null))?.hijos }" var="itemMenu" status="i">
									<ul class="pcoded-item pcoded-left-item">
										<li id="" class="pcoded-hasmenu ${(controllerName == itemMenu.controller)?'active pcoded-trigger':''}">
											<a href="javascript:void(0)">
												<span class="pcoded-micon"><i class="${itemMenu.icono}"></i></span>
												<span class="pcoded-mtext" data-i18n="nav.basic-components.main">${itemMenu.nombre}</span>
												<span class="pcoded-mcaret"></span>
											</a>
											<ul class="pcoded-submenu">
												<g:each in="${itemMenu.hijos}" var="itemMenuHijo" status="j">
													<li id="li${itemMenuHijo.controller}${itemMenuHijo.action}" class="">
														<g:link controller="${itemMenuHijo.controller}" action="${itemMenuHijo.action}">
															<span id="span${itemMenuHijo.controller}${itemMenuHijo.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
																${itemMenuHijo.nombre}
															</span>
														</g:link>
													</li>
												</g:each>
											</ul>
										</li>
									</ul>
								</g:each>
							</sec:ifAnyGranted>
							
							<sec:ifAnyGranted roles="ROLE_LECTURA">
								<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_LECTURA'), 'PRINCIPAL', null))?.hijos }" var="itemMenu" status="i">
									<ul class="pcoded-item pcoded-left-item">
										<li id="" class="pcoded-hasmenu ${(controllerName == itemMenu.controller)?'active pcoded-trigger':''}">
											<a href="javascript:void(0)">
												<span class="pcoded-micon"><i class="${itemMenu.icono}"></i></span>
												<span class="pcoded-mtext" data-i18n="nav.basic-components.main">${itemMenu.nombre}</span>
												<span class="pcoded-mcaret"></span>
											</a>
											<ul class="pcoded-submenu">
												<g:each in="${itemMenu.hijos}" var="itemMenuHijo" status="j">
													<li id="li${itemMenuHijo.controller}${itemMenuHijo.action}" class="">
														<g:link controller="${itemMenuHijo.controller}" action="${itemMenuHijo.action}">
															<span id="span${itemMenuHijo.controller}${itemMenuHijo.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
																${itemMenuHijo.nombre}
															</span>
														</g:link>
													</li>
												</g:each>
											</ul>
										</li>
									</ul>
								</g:each>
							</sec:ifAnyGranted>

							<sec:ifAnyGranted roles="ROLE_CUENTA">
								<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_CUENTA'), 'PRINCIPAL', null))?.hijos }" var="itemMenu" status="i">
									<ul class="pcoded-item">
										<li id="" class="">
											<g:link controller="${itemMenu.controller}" action="${itemMenu.action}">
												<span class="pcoded-micon" style="color:#2091a2;font-size:18px; margin-right: 0px;"><i class="${itemMenu.icono}"></i></span>
												<span id="span${itemMenu.controller}${itemMenu.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
													${itemMenu.nombre}
												</span>
												<span class="pcoded-mcaret"></span>
											</g:link>
										</li>
									</ul>
								</g:each>
							</sec:ifAnyGranted>
							<sec:ifAnyGranted roles="ROLE_SM">
								<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_SM'), 'PRINCIPAL', null))?.hijos }" var="itemMenu" status="i">
									<ul class="pcoded-item pcoded-left-item">
										<li id="" class="pcoded-hasmenu ${(controllerName == itemMenu.controller)?'active pcoded-trigger':''}">
											<a href="javascript:void(0)">
												<span class="pcoded-micon"><i class="${itemMenu.icono}"></i></span>
												<span class="pcoded-mtext" data-i18n="nav.basic-components.main">${itemMenu.nombre}</span>
												<span class="pcoded-mcaret"></span>
											</a>
											<ul class="pcoded-submenu">
												<g:each in="${itemMenu.hijos}" var="itemMenuHijo" status="j">
													<li id="li${itemMenuHijo.controller}${itemMenuHijo.action}" class="">
														<g:link controller="${itemMenuHijo.controller}" action="${itemMenuHijo.action}">
															<span id="span${itemMenuHijo.controller}${itemMenuHijo.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
																${itemMenuHijo.nombre}
															</span>
														</g:link>
													</li>
												</g:each>
											</ul>
										</li>
									</ul>
								</g:each>
							</sec:ifAnyGranted>
							<sec:ifAnyGranted roles="ROLE_SE">
								<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_SE'), 'PRINCIPAL', null))?.hijos }" var="itemMenu" status="i">
									<ul class="pcoded-item pcoded-left-item">
										<li id="" class="pcoded-hasmenu ${(controllerName == itemMenu.controller)?'active pcoded-trigger':''}">
											<a href="javascript:void(0)">
												<span class="pcoded-micon"><i class="${itemMenu.icono}"></i></span>
												<span class="pcoded-mtext" data-i18n="nav.basic-components.main">${itemMenu.nombre}</span>
												<span class="pcoded-mcaret"></span>
											</a>
											<ul class="pcoded-submenu">
												<g:each in="${itemMenu.hijos}" var="itemMenuHijo" status="j">
													<li id="li${itemMenuHijo.controller}${itemMenuHijo.action}" class="">
														<g:link controller="${itemMenuHijo.controller}" action="${itemMenuHijo.action}">
															<span id="span${itemMenuHijo.controller}${itemMenuHijo.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
																${itemMenuHijo.nombre}
															</span>
														</g:link>
													</li>
												</g:each>
											</ul>
										</li>
									</ul>
								</g:each>
							</sec:ifAnyGranted>
							<sec:ifAnyGranted roles="ROLE_VENTAS">
								<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_VENTAS'), 'PRINCIPAL', null))?.hijos }" var="itemMenu" status="i">
									<ul class="pcoded-item pcoded-left-item">
										<li id="" class="pcoded-hasmenu ${(controllerName == itemMenu.controller)?'active pcoded-trigger':''}">
											<a href="javascript:void(0)">
												<span class="pcoded-micon"><i class="${itemMenu.icono}"></i></span>
												<span class="pcoded-mtext" data-i18n="nav.basic-components.main">${itemMenu.nombre}</span>
												<span class="pcoded-mcaret"></span>
											</a>
											<ul class="pcoded-submenu">
												<g:each in="${itemMenu.hijos}" var="itemMenuHijo" status="j">
													<li id="li${itemMenuHijo.controller}${itemMenuHijo.action}" class="">
														<g:link controller="${itemMenuHijo.controller}" action="${itemMenuHijo.action}">
															<span id="span${itemMenuHijo.controller}${itemMenuHijo.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
																${itemMenuHijo.nombre}
															</span>
														</g:link>
													</li>
												</g:each>
											</ul>
										</li>
									</ul>
								</g:each>
							</sec:ifAnyGranted>
							<sec:ifAnyGranted roles="ROLE_COBRANZA">
								<g:each in="${(ItemMenu.findByRoleAndTipoAndPadre(Role.findByAuthority('ROLE_COBRANZA'), 'PRINCIPAL', null))?.hijos }" var="itemMenu" status="i">
									<ul class="pcoded-item pcoded-left-item">
										<li id="" class="pcoded-hasmenu ${(controllerName == itemMenu.controller)?'active pcoded-trigger':''}">
											<a href="javascript:void(0)">
												<span class="pcoded-micon"><i class="${itemMenu.icono}"></i></span>
												<span class="pcoded-mtext" data-i18n="nav.basic-components.main">${itemMenu.nombre}</span>
												<span class="pcoded-mcaret"></span>
											</a>
											<ul class="pcoded-submenu">
												<g:each in="${itemMenu.hijos}" var="itemMenuHijo" status="j">
													<li id="li${itemMenuHijo.controller}${itemMenuHijo.action}" class="">
														<g:link controller="${itemMenuHijo.controller}" action="${itemMenuHijo.action}">
															<span id="span${itemMenuHijo.controller}${itemMenuHijo.action}" class="pcoded-mtext" data-i18n="nav.dash.main">
																${itemMenuHijo.nombre}
															</span>
														</g:link>
													</li>
												</g:each>
											</ul>
										</li>
									</ul>
								</g:each>
							</sec:ifAnyGranted>
                    </nav>
                    
                    <div class="pcoded-content">
                    	<div class="pcoded-inner-content">
                    		<g:layoutBody/>
                    	</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<sec:ifAnyGranted roles="ROLE_CUENTA">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
  	<a id="wpp" class="float" target="_blank" onclick="getNumeroVendedor()" href="" >
  	<i class="fa fa-whatsapp my-float"></i>
 	</a>
</sec:ifAnyGranted>
<script type="text/javascript">
var spanName = "span${controllerName}${actionName}";

$(document).ready(function () {
	if(($("#menuPrincipal").css('margin-left') == "0px") && ($("#perfil").val() == "esconder_lateral")){
		$('#mobile-collapse').trigger("click");
		$('#mobile-collapse').hide();
	}

	var url = "${request.getRequestURL()}"
	if(url.includes("notificacion/list"))
		$('#badgeNotificaciones').hide();

	$("#li${controllerName}${actionName}").parent('ul').parent('li').addClass( "active pcoded-trigger" );
	$("#span${controllerName}${actionName}").css({ 'font-weight': 'bold' });

});
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
