<!DOCTYPE html>
<html lang="en">

<head>
	<div class="theme-loader" id="loaderGrande" style="display: none;">
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
	<meta name="layout" content="main">
	<style>
		.resaltadoTabla{
			background-color: #E6F4F4!important;
			color: black!important;
		}
	</style>
</head>

<body>
	<%@ page import="com.zifras.User" %>
	<div style="display: none;">
		<div id="urlDelete">
			<g:createLink controller="cuenta" action="delete" />
		</div>
		<div id="urlRecuperar">
			<g:createLink controller="cuenta" action="recuperar" />
		</div>
		<div id="urlSuspenderCuenta">
			<g:createLink controller="cuenta" action="suspender" />
		</div>
		<div id="urlResolverErrorAFIP">
			<g:createLink controller="cuenta" action="resolverErrorAfip" />
		</div>
		<div id="urlGetLiquidacionesIvaCuentaList">
			<g:createLink controller="liquidacionIva" action="ajaxGetLiquidacionesIvaCuentaList" />
		</div>
		<div id="urlGetLiquidacionesIibbCuentaList">
			<g:createLink controller="liquidacionIibb" action="ajaxGetLiquidacionesIibbCuentaList" />
		</div>
		<div id="urlGetLiquidacionesGananciaCuentaList">
			<g:createLink controller="liquidacionGanancia" action="ajaxGetLiquidacionesGananciaCuentaList" />
		</div>
		<div id="urlShowGanancia">
			<g:createLink controller="liquidacionGanancia" action="show" />
		</div>
		<div id="urlEditGanancia">
			<g:createLink controller="liquidacionGanancia" action="edit" />
		</div>
		<div id="urlDeleteGanancia">
			<g:createLink controller="liquidacionGanancia" action="ajaxDelete" />
		</div>
		<div id="urlCreateGanancia">
			<g:createLink controller="liquidacionGanancia" action="create" />
		</div>
		<div id="urlShowIIBB">
			<g:createLink controller="liquidacionIibb" action="show" />
		</div>
		<div id="urlEditIIBB">
			<g:createLink controller="liquidacionIibb" action="edit" />
		</div>
		<div id="urlDeleteIIBB">
			<g:createLink controller="liquidacionIibb" action="ajaxDelete" />
		</div>
		<div id="urlCreateIIBB">
			<g:createLink controller="liquidacionIibb" action="create" />
		</div>
		<div id="urlShowIVA">
			<g:createLink controller="liquidacionIva" action="show" />
		</div>
		<div id="urlEditIVA">
			<g:createLink controller="liquidacionIva" action="edit" />
		</div>
		<div id="urlDeleteIVA">
			<g:createLink controller="liquidacionIva" action="ajaxDelete" />
		</div>
		<div id="urlCreateIVA">
			<g:createLink controller="liquidacionIva" action="create" />
		</div>
		<div id="urlGetListaImportacionesPorCuenta">
			<g:createLink controller="importacion" action="ajaxGetListaImportacionesPorCuenta" />
		</div>
		<div id="urlBloquearDesbloquearUsuario">
			<g:createLink controller="usuario" action="ajaxBloquearDesbloquear" />
		</div>
		<div id="urlEditDDJJ">
			<g:createLink controller="declaracionJurada" action="edit" />
		</div>
		<div id="urlGetDeclaracionesJuradas">
			<g:createLink controller="declaracionJurada" action="ajaxGetDeclaracionesJuradasPorCuenta" />
		</div>
		<div id="urlGetFacturasCuentaList">
			<g:createLink controller="miCuenta" action="ajaxGetFacturasPorCuenta" />
		</div>
		<div id="urlEditFacturaCuenta">
			<g:createLink controller="facturaCuenta" action="edit" />
		</div>
		<div id="urlShowComprobante">
			<g:createLink controller="comprobante" action="show" />
		</div>
		<div id="urlImportarComprobante">
			<g:createLink controller="comprobante" action="ajaxImportarComprobante" />
		</div>
		<div id="urlGetComprobantes">
			<g:createLink controller="comprobante" action="ajaxGetComprobantesPorCuenta" />
		</div>
		<div id="urlGetTiposComprobante">
			<g:createLink controller="comprobante" action="ajaxGetTiposComprobante" />
		</div>
		<div id="urlShowVep">
			<g:createLink controller="vep" action="show" />
		</div>
		<div id="urlGetVeps">
			<g:createLink controller="vep" action="ajaxGetVepsPorCuenta" />
		</div>
		<div id="urlEditVolante">
			<g:createLink controller="vep" action="editVolanteSimplificado" />
		</div>
		<div id="urlGetVolantesPago">
			<g:createLink controller="vep" action="ajaxGetVolantesSimplificado" params="[cuentaId:"${cuentaInstance.id}"]"/>
		</div>
	</div>
	<div class="main-body">
		<div class="page-wrapper">
			<!-- Page-header start -->
			<div class="page-header card">
				<div class="row align-items-end">
					<div class="col-lg-8">
						<div class="page-header-title">
							<div class="d-inline">
								<h4>Cuenta ${cuentaInstance?.cuit}</h4>
							</div>
						</div>
					</div>
					<div class="col-lg-4">
					</div>
				</div>
			</div>
			<!-- Page-header end -->
			<!-- Page body start -->
			<div class="page-body">
				<div class="row">
					<!-- Sho Map Start -->
					<div class="col-md-12">
						<div class="card">
							<div class="card-block user-detail-card">
								<div class="row">
									<div class="col-sm-3">
										<asset:image src="widget/Group-user.jpg" class="img-fluid p-b-10"/>
										<div class="contact-icon" style="display:none;">
											<button class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="View" ><i class="icofont icofont-eye m-0"></i></button>
											<button class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Print" ><i class="icofont icofont-printer m-0"></i></button>
											<button class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Download" ><i class="icofont icofont-download-alt m-0"></i></button>
											<button class="btn btn-default" data-toggle="tooltip" data-placement="bottom" title="Share" ><i class="icofont icofont-share m-0"></i></button>
										</div>
										<div class="form-radio m-b-30">
											<form>
												<div class="radio radiofill radio-success radio-inline" style="width:100%;">
													<label>
													<input type="radio" name="radio" ${cuentaInstance.etiqueta == 'Verde' ? 'checked=checked':''} onclick="cambiarEtiqueta('Verde');">
													<i class="helper"></i>Cliente
													</label>
												</div>
												<div class="radio radiofill radio-success radio-inline" style="width:100%;">
													<label>
													<input type="radio" name="radio" ${cuentaInstance.etiqueta == 'Naranja' ? 'checked=checked':''} onclick="cambiarEtiqueta('Naranja');">
													<i class="helper"></i>Cliente Naranja
													</label>
												</div>
												<div class="radio radiofill radio-warning radio-inline" style="width:100%;">
													<label>
													<input type="radio" name="radio" ${cuentaInstance.etiqueta == 'Amarillo' ? 'checked=checked':''} onclick="cambiarEtiqueta('Amarillo');">
													<i class="helper"></i>En proceso
													</label>
												</div>
												<div class="radio radiofill radio-danger radio-inline" style="width:100%;">
													<label>
													<input type="radio" name="radio" ${cuentaInstance.etiqueta == 'Rojo' ? 'checked=checked':''} onclick="cambiarEtiqueta('Rojo');">
													<i class="helper"></i>Baja
													</label>
												</div>
												<div class="radio radiofill radio-default radio-inline" style="width:100%;">
													<label>
													<input type="radio" name="radio" ${!(cuentaInstance.etiqueta) ? 'checked=checked':''} onclick="cambiarEtiqueta('');">
													<i class="helper"></i>Sin etiqueta
													</label>
												</div>
											</form>
										</div>
									</div>
									<div class="col-sm-9 user-detail">
										<g:if test="${cuentaInstance?.riderId}">
											<div class="row">
												<div class="col-sm-7">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-bicycle-alt-2"></i>
														<b>Esta cuenta es Rider para PedidosYa</b>
													</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.registroConErrorAFIP == true}">
											<div class="row">
												<div class="col-sm-7">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-error"></i>
														<b>Esta cuenta obtuvo error de AFIP al momento de registro</b>
														<button id="btnResolverErrorAFIP" class="btn btn-success" style="margin-left: 16px">Resuelto</button>
													</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.cuit}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-web"></i>
														<g:message code="zifras.cuenta.Cuenta.cuit.label" default="CUIT" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.cuit}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.cuitAdministrador}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-web"></i>
														<g:message code="zifras.cuenta.Cuenta.cuitAdministrador.label" default="CUIT Administrador" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.cuitAdministrador}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.cuitRepresentante}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-web"></i>
														<g:message code="zifras.cuenta.Cuenta.cuitRepresentante.label" default="CUIT Representante" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.cuitRepresentante}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.cuitGeneradorVep}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-web"></i>
														<g:message code="zifras.cuenta.Cuenta.cuitGeneradorVep.label" default="CUIT Generador de VEPs" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.cuitGeneradorVep}</h6>
												</div>
											</div>
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-web"></i>
														<g:message code="zifras.cuenta.Cuenta.claveVeps.label" default="Clave Generadora de VEPs" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.claveVeps}</h6>
												</div>
											</div>
										</g:if>
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30">
													<i class="icofont icofont-web"></i>
													Estado
												</h6>
											</div>
											<div class="col-sm-9">
												<h6 class="m-b-30">${cuentaInstance.estado.nombre}</h6>
											</div>
										</div>
										<g:if test="${cuentaInstance?.tipoClave}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-web"></i>
														<g:message code="zifras.cuenta.Cuenta.clave.label" default="Tipo Clave" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.tipoClave} (${cuentaInstance?.estadoClave?.nombre})</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.razonSocial}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-fax"></i>
														<g:message code="zifras.cuenta.Cuenta.razonSocial.label" default="Razón Social" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.razonSocial}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.with{claveFiscal || claveArba || claveAgip}}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Claves</h6>
												</div>
												<div class="col-sm-9">
													<g:if test="${cuentaInstance?.claveFiscal}">
														<h6 class="m-b-30">FISCAL: ${cuentaInstance?.claveFiscal}</h6>
													</g:if>
													<g:if test="${cuentaInstance?.claveArba}">
														<h6 class="m-b-30">Arba: ${cuentaInstance?.claveArba}</h6>
													</g:if>
													<g:if test="${cuentaInstance?.claveAgip}">
														<h6 class="m-b-30">Agip: ${cuentaInstance?.claveAgip}</h6>
													</g:if>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.nombreApellido}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-ui-user"></i>
														<g:message code="zifras.cuenta.Cuenta.nombreApellido.label" default="Nombre" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.nombreApellido}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.tipoDocumento}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-id-card"></i>Tipo Documento</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.tipoDocumento}</h6>
												</div>
											</div>
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-id-card"></i>Nro Documento</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30"> ${cuentaInstance?.documento}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.inscriptoAfip}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-list"></i>Inscripto en AFIP</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30"> ${cuentaInstance?.inscriptoAfip ? "Si" : "No"}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.tipoPersona}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-web"></i>
														<g:message code="zifras.cuenta.Cuenta.tipoPersona.label" default="Tipo Persona" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.tipoPersona?.nombre}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.fechaContratoSocial}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-fax"></i>
														<g:message code="zifras.cuenta.Cuenta.fechaContratoSocial.label" default="Contrato Social" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.fechaContratoSocial?.toString('dd/MM/yyyy')}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.mesCierre}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-fax"></i>
														<g:message code="zifras.cuenta.Cuenta.mesCierre.label" default="Mes de cierre" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.mesCierreString}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.fechaAlta}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-fax"></i>
														<g:message code="zifras.cuenta.Cuenta.fechaAlta.label" default="Fecha de Alta" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.fechaAlta?.toString('dd/MM/YYYY HH:mm')}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.fechaAlta}">
											<!-- El test lo hace por fechaAlta para mostrar el guión si tiene alta pero no confirmación -->
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<i class="icofont icofont-fax"></i>
														<g:message code="zifras.cuenta.Cuenta.fechaConfirmacion.label" default="Fecha de Confirmacion" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.fechaConfirmacion?.toString('dd/MM/YYYY HH:mm')?: '-'}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.telefono}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-touch-phone"></i>Teléfono</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.telefono}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.email}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-email"></i>Email</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30"><a href="mailto:${cuentaInstance?.email}">${cuentaInstance?.email}</a></h6>
												</div>
											</div>
										</g:if>
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-email"></i>Mails MercadoPago:</h6>
											</div>
											<div class="col-sm-9">
												<h6 class="m-b-30">${cuentaInstance?.getMailsMercadoPago()}</h6>
											</div>
										</div>
										<g:if test="${cuentaInstance?.wechat}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-touch-phone"></i>Wechat</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.wechat}</h6>
												</div>
											</div>
										</g:if>
										
										<g:if test="${cuentaInstance?.bitrixId}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-touch-phone"></i>Id Bitrix:</h6>
												</div>
												<div class="col-sm-9">
													<a class="m-b-30" href="https://calim.bitrix24.com/crm/contact/details/${cuentaInstance?.bitrixId}/" target="_blank">${cuentaInstance?.bitrixId}</a>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.bitrixDealId}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-touch-phone"></i>Id Deal Bitrix:</h6>
												</div>
												<div class="col-sm-9">
													<a class="m-b-30" href="https://calim.bitrix24.com/crm/deal/details/${cuentaInstance?.bitrixDealId}/" target="_blank">${cuentaInstance?.bitrixDealId}</a>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.bitrixTaskId}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-touch-phone"></i>Id Task Bitrix:</h6>
												</div>
												<div class="col-sm-9">
													<a class="m-b-30" href="https://calim.bitrix24.com/company/personal/user/1/tasks/task/view/${cuentaInstance.bitrixTaskId}/" target="_blank">${cuentaInstance?.bitrixTaskId}</a>
												</div>
											</div>
										</g:if>
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-brand-whatsapp"></i>Whatsapp</h6>
											</div>
											<div class="col-sm-9">
												<h6 class="m-b-30">${cuentaInstance?.whatsapp}</h6>
											</div>
										</div>
										<g:if test="${cuentaInstance?.profesion}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-businessman"></i>Profesión</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30"> ${cuentaInstance?.profesion} <g:if test="${cuentaInstance?.descripcionActividad}"> | ${cuentaInstance?.descripcionActividad}</g:if></h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.relacionDependencia != null}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-businessman"></i></i>Relacion de Dependencia</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30"> ${cuentaInstance?.relacionDependencia ? "Si" : "No"}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.obraSocial}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-businessman"></i>Obra Social</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30"> ${cuentaInstance?.obraSocial}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.with{fotoFrenteDni || fotoDorsoDni || fotoSelfie}}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-businessman"></i>Fotos AFIP</h6>
												</div>
												<div class="col-sm-9">
													<a href="/cuenta/bajarFotos/${cuentaInstance.id}"><h6 class="m-b-30"> Descargar </h6></a>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.rangoFacturacion}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-cur-dollar"></i>Rango de Facturación</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30"> ${cuentaInstance?.rangoFacturacion}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.condicionIva}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Condición IVA</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.condicionIva?.nombre}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.regimenIibb}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Régimen IIBB</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.regimenIibb?.nombre}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance.getAlicuotasIIBBActivas().size()!=0}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Alícuotas IIBB</h6>
												</div>
												<div class="col-sm-9">
													<g:each in="${cuentaInstance.getAlicuotasIIBBActivas()}" var="alicuotaIIBB">
														<h6 class="m-b-30">${alicuotaIIBB?.provincia?.nombre} ${alicuotaIIBB.valor} - ${alicuotaIIBB.porcentaje}%</h6>
													</g:each>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance.getPorcentajesProvinciaIIBBActivos().size()!=0}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Distribucion IIBB por provincia</h6>
												</div>
												<div class="col-sm-9">
													<g:each in="${cuentaInstance.getPorcentajesProvinciaIIBBActivos()}" var="distribucionProvincia">
														<h6 class="m-b-30">${distribucionProvincia.toString()}</h6>
													</g:each>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.actividad}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Actividad</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.actividad?.toString()}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance.getPorcentajesActividadIIBBActivos().size()!=0}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Distribucion IIBB por actividad</h6>
												</div>
												<div class="col-sm-9">
													<g:each in="${cuentaInstance.getPorcentajesActividadIIBBActivos()}" var="distribucionActividad">
														<h6 class="m-b-30">${distribucionActividad.toString()}</h6>
													</g:each>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance.impuestos.size()!=0}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Impuestos</h6>
												</div>
												<div class="col-sm-9">
													<g:each in="${cuentaInstance.impuestosUnicos}" var="impuesto">
														<h6 class="m-b-30">${impuesto?.nombre}</h6>
													</g:each>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance.categoriaMonotributo}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Monotributo</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">Categoría: ${cuentaInstance.categoriaMonotributo}</h6>
													<h6 class="m-b-30">Periodo: ${cuentaInstance.periodoMonotributo?.toString("dd/MM/yyyy")}</h6>
													<h6 class="m-b-30">Impuesto: ${cuentaInstance.impuestoMonotributo}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance.categoriaAutonomo}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Autónomo</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">Categoría: ${cuentaInstance.categoriaAutonomo}</h6>
													<h6 class="m-b-30">Periodo: ${cuentaInstance.periodoAutonomo?.toString("dd/MM/yyyy")}</h6>
													<h6 class="m-b-30">Impuesto: ${cuentaInstance.impuestoAutonomo}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.numeroSicol}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">
														<g:message code="zifras.cuenta.Cuenta.numeroSicol.label" default="Número Sicol" />
													</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.numeroSicol}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.detalle}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Detalle</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.detalle}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance.domicilioFiscal}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-home"></i>Domicilio Fiscal</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.domicilioFiscal}</h6>
												</div>
											</div>
										</g:if>
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-businessman"></i>Responsable</h6>
											</div>
											<div class="col-sm-9">
												<h6 class="m-b-30">${cuentaInstance?.responsable?.nombre ?: "-"}</h6>
											</div>
										</div>
										<g:if test="${cuentaInstance.locales.size()!=0}">
											<div class="row">
												<div class="col-sm-12">
													<h6 class="f-w-400 m-b-30" style="padding-bottom:20px;"><i class="icofont icofont-ui-home"></i>Locales</h6>
													<style>table, th, td {
																border: 1px solid black;
															}
															th {
																cursor: pointer;
															}
													</style>
													<table t id="listLocales" class="table table-striped table-bordered nowrap">
														<thead>
															<tr>
																<th style="font-weight:normal;">Nº</th>
																<th style="font-weight:normal;">Dirección</th>
																<th style="font-weight:normal;">Email</th>
																<th style="font-weight:normal;">Whatsapp</th>
																<th style="font-weight:normal;">Cant.Empleados</th>
																<th style="font-weight:normal;">Localidad</th>
																<th style="font-weight:normal;">Zona</th>
																<th style="font-weight:normal;">Provincia</th>
																<th style="font-weight:normal;">IVA %</th>
																<th style="font-weight:normal;">IIBB %</th>
																<th style="font-weight:normal;">Estado</th>
															</tr>
														<tbody>
														<g:each in="${locales}" var="local">
															<tr>
																<th style="font-weight:normal;">${local.numeroLocal}</th>
																<th style="font-weight:normal;">${local.direccion}</th>
																<th style="font-weight:normal;">${local.email}</th>
																<g:if test="${local.telefono!=null}">
																<th style="font-weight:normal;"><a href="https://api.whatsapp.com/send?phone=${local.telefono}" target="_blank">${local.telefono}</a></th>
																</g:if>
																<g:else>
																<th style="font-weight:normal;"></th>
																</g:else>
																<g:if test="${local.cantidadEmpleados!=null}">
																<th style="font-weight:normal;">${local.cantidadEmpleados}</th>
																</g:if>
																<g:else>
																<th style="font-weight:normal;">0</th>
																</g:else>
																<th style="font-weight:normal;">${local.localidad?.nombre}</th>
																<th style="font-weight:normal;">${local.zona?.nombre}</th>
																<th style="font-weight:normal;">${local.provincia?.nombre}</th>
																<th style="font-weight:normal;">${local.porcentaje}</th>
																<th style="font-weight:normal;">${local.porcentajeIIBB}</th>
																<th style="font-weight:normal;">${local.estado?.nombre}</th>
															</tr>
														</g:each>
														</tbody>
														</thead>
													</table>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance.parientes.size()!=0}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-home"></i>Parientes</h6>
												</div>
												<div class="col-sm-9">
													<g:each in="${cuentaInstance.parientes}" var="pariente">
														<g:if test="${pariente?.estado?.nombre!='Borrado'}">
															<g:if test="${pariente.tipoId==0}">
																<h6 class="m-b-30">Conguye: ${pariente?.nombre} ${pariente?.apellido}</h6>
																<h6 class="m-b-30">(CUIL: ${pariente.cuil} - Casamiento: ${pariente.fechaCasamiento.toString("dd/MM/yyyy")})</h6>
															</g:if>
															<g:else>
																<h6 class="m-b-30">Hijo/a - ${pariente?.nombre} ${pariente?.apellido}</h6>
																<h6 class="m-b-30">(CUIL: ${pariente.cuil} - Nacimiento: ${pariente.fechaNacimiento.toString("dd/MM/yyyy")})</h6>
															</g:else>
														</g:if>
													</g:each>
												</div>
											</div>
										</g:if>
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-cyclist"></i>Trabaja con App Delivery</h6>
											</div>
											<div class="col-sm-9">
												<h6 class="m-b-30"> ${cuentaInstance?.profesion == "app" ? "Si" : "No"}<g:if test="${cuentaInstance.profesion == 'app'}"> | ${cuentaInstance?.apps.each{i->i.toString()}.toString().replace("[","").replace("]","")}</h6></g:if>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-touch-phone"></i>App Calim descargada</h6>
											</div>
											<div class="col-sm-9">
												<h6 class="m-b-30"> ${cuentaInstance?.appCalimDescargada() ? "Si" : "No"}</h6>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-credit-card"></i>Debito Automatico</h6>
											</div>
											<div class="col-sm-9">
												<h6 class="m-b-30"> ${cuentaInstance?.tarjetaDebitoAutomatico ? "Si" : "No"}</h6>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30">Servicios</h6>
											</div>
											<div class="col-sm-9">
												<h6 class="m-b-30">${raw(cuentaInstance?.serviciosString)}</h6>
											</div>
										</div>
										<g:if test="${cuentaInstance?.medioPago}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Medio de Pago para VEP</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.medioPago?.nombre}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.medioPagoIva}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Medio de Pago para IVA</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.medioPagoIva?.nombre}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.medioPagoIibb}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Medio de Pago para IIBB</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.medioPagoIibb?.nombre}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.cbu}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">CBU</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance?.cbu}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.aplicaIva}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Máximo autoautorizar IVA</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance.maximoAutorizarIva.with{ it != null ? '$' + it : '-'}}</h6>
												</div>
											</div>
										</g:if>
										<g:if test="${cuentaInstance?.aplicaIIBB}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Máximo autoautorizar IIBB</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30">${cuentaInstance.maximoAutorizarIIBB.with{ it != null ? '$' + it : '-'}}</h6>
												</div>
											</div>
										</g:if>
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30">Deuda CCMA</h6>
											</div>
											<div class="col-sm-9">
												<g:if test="${ultimaDeudaCCMA}">
													<h6 class="m-b-30">Fecha de consulta: ${ultimaDeudaCCMA.fechaString}</h6>
													<h6 class="m-b-30">Saldo deudor: ${ultimaDeudaCCMA.deudaString}</h6>
													<h6 class="m-b-30">Mes corriente: ${ultimaDeudaCCMA.mesCorrienteString}</h6>
													<h6 class="m-b-30">Saldo acreedor: ${ultimaDeudaCCMA.favorString}</h6>
													<h6 class="m-b-30">Ùltimos 3 meses pagos: ${ultimaDeudaCCMA.ultimos3MesesPagos ? "Sí" : "No"}</h6>
												</g:if>
												<g:else>
													<!-- <div class="row"> -->
														<h6 class="m-b-30" style="margin-right: 15px">Sin información</h6>
													<!-- </div> -->
												</g:else>
												<g:link class="btn btn-primary m-b-0" onclick="\$('#loaderGrande').show()" action="consultarCCMA" id="${cuentaInstance?.id}">Consultar</g:link>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-3">
												<h6 class="f-w-400 m-b-30">Punto de Venta</h6>
											</div>
											<div class="col-sm-9">
												<g:if test="${cuentaInstance?.puntoVentaCalim}">
													<h6 class="m-b-30">Sí</h6>
												</g:if>
												<g:else>
													<div class="row">
														<h6 class="m-b-30" style="margin-right: 15px">No</h6>
														<g:link class="btn btn-primary m-b-0" onclick="\$('#loaderGrande').show()" action="generarPuntoVentaSelenium" id="${cuentaInstance?.id}">Generar</g:link>
													</div>
												</g:else>
											</div>
										</div>
										<g:if test="${cuentaInstance.contadorDisparosError > 0}">
											<div class="row">
												<div class="col-sm-3">
													<h6 class="f-w-400 m-b-30">Errores Notificados</h6>
												</div>
												<div class="col-sm-9">
													<h6 class="m-b-30"> ${cuentaInstance?.contadorDisparosError}</h6>
												</div>
											</div>
										</g:if>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12">
										<h4 class="sub-title"></h4>
										<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_VENTAS,ROLE_SM,ROLE_SE,ROLE_COBRANZA, ROLE_USER">
											<g:if test="${cuentaInstance?.estado?.nombre!='Borrado'}">
												<g:link class="btn btn-primary m-b-0" action="edit" id="${cuentaInstance?.id}">
													<g:message code="default.button.edit.label" default="Editar" />
												</g:link>
											</g:if>
										</sec:ifAnyGranted>
										<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_VENTAS,ROLE_SM,ROLE_SE,ROLE_COBRANZA">
											<g:if test="${cuentaInstance?.estado?.nombre!='Borrado'}">
												<button type="button" class="btn btn-danger alert-success-cancel m-b-0" >
													<g:message code="default.button.delete.label" default="Eliminar" />
												</button>
											</g:if>
											<g:else>
												<button type="button" class="btn btn-danger alert-success-cancel m-b-0 recuperar">
													<g:message code="default.button.recuperar.label" default="Recuperar"/>
												</button>
											</g:else>
											<button type="button" id="btnBloqUser" class="btn btn-danger bloqUser m-b-0">${((User.findByUsername(cuentaInstance.email)?.enabled) ? 'B' : 'Desb') + 'loquear usuario'}</button>
											<g:if test="${cuentaInstance?.estado?.nombre == 'Sin verificar'}">
												<g:if test="${User.findByUsername(cuentaInstance.email)?.accountLocked}">
													<button type="button" class="btn btn-danger alert-success-cancel m-b-0" onclick="reenviarMailBienvenida()">Reenviar mail Bienvenida</button>
												</g:if>
												<button type="button" class="btn btn-danger alert-success-cancel m-b-0" onclick="$('#modalIngresarCuit').modal('show');">Activar manualmente</button>
											</g:if>
											<g:if test="${cuentaInstance?.estado?.nombre != 'Suspendido'}">
												<button type="button" id="btnSuspenderCuenta" class="btn btn-danger suspenderCuenta m-b-0"> Suspender cuenta</button>
											</g:if>
											<g:else>
												<button type="button" class="btn btn-success reactivarCuenta m-b-0">Reactivar Cuenta</button>
											</g:else>
											<g:if test="${cuentaInstance?.tenantId == 2}">
												<g:link class="btn btn-primary m-b-0" action="servicios" id="${cuentaInstance?.id}">Servicios</g:link>
												<button class="btn btn-danger m-b-0" type="button" onclick="$('#modalNotificarError').modal('show')">Notificar Error</button>
											</g:if>
										</sec:ifAnyGranted>
										<sec:ifAnyGranted roles="ROLE_ADMIN,ROLE_SM,ROLE_SE,ROLE_COBRANZA">
											<g:link class="btn btn-primary m-b-0" onclick="\$('#loaderGrande').show()" action="selenium" id="${cuentaInstance?.id}">Acciones Masivas</g:link>
										</sec:ifAnyGranted>
										<g:if test="${cuentaInstance?.estado.nombre == 'Suspendido'}">
											<g:link class="btn btn-inverse m-b-0" action="listSuspendidas">
												<g:message code="default.button.back.label" default="Volver" />
											</g:link>
										</g:if>
										<g:else>
											<g:if test="${cuentaInstance?.estado.nombre == 'Sin verificar'}">
												<g:link class="btn btn-inverse m-b-0" action="listPendientes">
													<g:message code="default.button.back.label" default="Volver" />
												</g:link>
											</g:if>
											<g:else>
												<g:link class="btn btn-inverse m-b-0" action="list">
													<g:message code="default.button.back.label" default="Volver" />
												</g:link>
											</g:else>
										</g:else>
									</div>
								</div>
							</div>
						</div>
					</div>
					<g:if test="${cuentaInstance?.estado?.nombre!='Sin verificar'}">
						<g:if test="${cuentaInstance?.tenantId == 2}">
							<div class="col-md-12 col-xl-12 ">
								<div class="card">
									<div class="card-block">
										<div class="dt-responsive table-responsive">
											<h4 style="margin-bottom:20px;">Permisos concedidos</h4>
											<table class="table table-striped table-bordered nowrap" style="cursor:pointer;">
												<thead>
													<tr>
														<th>AFIP</th>
														<th>IIBB</th>
														<th>Info.Revisada</th>
														<th>Punto Venta Calim</th>
														<th>C.F. Delegada</th>
													</tr>
													<tr>
														<td>
															<div class="checkbox-fade fade-in-primary">
																<label class="check-task">
																<input type="checkbox" ${cuentaInstance.afipMiscomprobantes ? 'checked' : ''} onclick="cambiarBooleanoPasos('afipMiscomprobantes');">
																<span class="cr">
																<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
																</span>
																</label>
															</div>
														</td>
														<td>
															<div class="checkbox-fade fade-in-primary">
																<label class="check-task">
																<input type="checkbox" ${cuentaInstance.ingresosBrutos ? 'checked' : ''} onclick="cambiarBooleanoPasos('ingresosBrutos');">
																<span class="cr">
																<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
																</span>
																</label>
															</div>
														</td>
														<td>
															<div class="checkbox-fade fade-in-primary">
																<label class="check-task">
																<input type="checkbox" ${cuentaInstance.infoRevisada ? 'checked' : ''} onclick="cambiarBooleanoPasos('infoRevisada');">
																<span class="cr">
																<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
																</span>
																</label>
															</div>
														</td>
														<td>
															<div class="checkbox-fade fade-in-primary">
																<label class="check-task">
																<input type="checkbox" ${cuentaInstance.puntoVentaCalim ? 'checked' : ''} onclick="cambiarBooleanoPasos('puntoVentaCalim');">
																<span class="cr">
																<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
																</span>
																</label>
															</div>
														</td>
														<td>
															<div class="checkbox-fade fade-in-primary">
																<label class="check-task">
																<input type="checkbox" ${cuentaInstance.claveAfipDelegada ? 'checked' : ''} onclick="cambiarBooleanoPasos('claveAfipDelegada');">
																<span class="cr">
																<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
																</span>
																</label>
															</div>
														</td>
													</tr>
												</thead>
												<tbody>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</g:if>

						<div class="col-md-12 col-xl-12 ">
							<div class="card">
								<div class="card-block">
									<div class="dt-responsive table-responsive">
										<div style="float:right;">
											<label style="float:left;padding-top:5px;margin-right:10px;">Año</label>
											<input style="width:80px;" id="ano" name="ano" class="form-control txtAno" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
										</div>
										<h4 style="margin-bottom:20px;">Facturación</h4>
										<table id="listFacturacion" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
											<thead>
												<tr>
													<th>Mes</th>
													<th>Venta total</th>
													<th>Cant. Facturas</th>
													<th>Listado</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
											<tfoot>
											    <tr>
											       	<th></th>
					            					<th></th>
					            					<th></th>
					            					<th></th>
											    </tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
						</div>

						<div class="col-md-12 col-xl-12" style="${cuentaInstance.aplicaIva ? ' ' : 'display:none;'}">
							<div class="card">
								<div id="preloaderIva" class="preloader3" style="display:none;">
									<div class="circ1 loader-primary"></div>
									<div class="circ2 loader-primary"></div>
									<div class="circ3 loader-primary"></div>
									<div class="circ4 loader-primary"></div>
								</div>
								<div class="card-block" id="divListIva">
									<div class="dt-responsive table-responsive">
										<div style="float:right;">
											<label style="float:left;padding-top:5px;margin-right:10px;">Año</label>
											<input style="width:80px;" id="ano" name="ano" class="form-control txtAno" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
										</div>
										<h4 style="margin-bottom:20px;">
											<g:message code="zifras.liquidacion.LiquidacionIva.list.label" default="Liquidaciones de IVA"/>
										</h4>
										<table id="listLiquidaciones" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
											<thead>
												<tr>
													<th></th>
													<th>Mes</th>
													<th>Estado</th>
													<th>FV</th>
													<th>FC</th>
													<th>%D/C</th>
													<th>S DDJJ</th>
													<th>D.F.</th>
													<th>D.F.2</th>
													<th>D.F.5</th>
													<th>D.F.10</th>
													<th>D.F.21</th>
													<th>D.F.27</th>
													<th>C.F.</th>
													<th>C.F.2</th>
													<th>C.F.5</th>
													<th>C.F.10</th>
													<th>C.F.21</th>
													<th>C.F.27</th>
													<th>ST</th>
													<th>ST Ant.</th>
													<th>SLD</th>
													<th>SLD Ant.</th>
													<th>Per.</th>
													<th>Ret.</th>
													<th>Locales</th>
													<th>Advertencia</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-12 col-xl-12 ">
							<div class="card">
								<div id="preloaderIIBB" class="preloader3" style="display:none;">
									<div class="circ1 loader-primary"></div>
									<div class="circ2 loader-primary"></div>
									<div class="circ3 loader-primary"></div>
									<div class="circ4 loader-primary"></div>
								</div>
								<g:if test="${!['Simplificado', 'Simplificado Provincial', 'Unificado'].contains(cuentaInstance?.regimenIibb?.nombre)}">
									<div class="card-block" id="divListIIBB">
										<div class="dt-responsive table-responsive">
											<div style="float:right;">
												<label style="float:left;padding-top:5px;margin-right:10px;margin-left: 10px;">Año</label>
												<input style="width:80px;" name="ano" class="form-control txtAno" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
											</div>
											<div style="float:right;">
												<select id="mesIIBB"></select>
											</div>
											<div style="float:right;">
												<label style="float:left;padding-top:5px;margin-right:10px;">Mes</label>
											</div>
											<h4 style="margin-bottom:20px;">
												<g:message code="zifras.liquidacion.LiquidacionIIBB.list.label" default="Liquidaciones de IIBB"/>
											</h4>
											<table id="listLiquidacionesIIBB" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
												<thead>
													<tr>
														<th></th>
														<th>Mes</th>
														<th>Estado</th>
														<th>Prov.</th>
														<th>S DDJJ</th>
														<th>Neto Total</th>
														<th>% Prov.</th>
														<th>Neto</th>
														<th>Impuesto</th>
														<th>Ret.</th>
														<th>Sircreb</th>
														<th>Per.</th>
														<th>SAF</th>
														<th>SAF Ant.</th>
														<th>Nota</th>
														<th>Locales</th>
														<th>Advertencia</th>
													</tr>
												</thead>
												<tbody>
												</tbody>
												<tfoot>
													<tr>
														<th colspan="4"></th>
														<th></th>
														<th colspan="12"></th>
													</tr>
												</tfoot>
											</table>
										</div>
									</div>
								</g:if>
								<g:else>
									<div class="card-block" id="divListVolantesPago">
										<div class="dt-responsive table-responsive">
											<h4 style="margin-bottom:20px;">
												<g:message code="zifras.liquidacion.Volantes.list.label" default="Volantes Pago Simplificado"/>
											</h4>
											<table id="listVolantesPago" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
												<thead>
													<tr>
														<th>Periodo</th>
														<th>Descripción</th>
														<th>Vencimiento</th>
														<th>Archivo</th>
													</tr>
												</thead>
												<tbody>
												</tbody>
											</table>
										</div>
									</div>	
							</div>
						</div>
								</g:else>		
							</div>
						</div>
						<g:if test="${!['Simplificado', 'Simplificado Provincial', 'Unificado'].contains(cuentaInstance?.regimenIibb?.nombre)}">
							<div class="col-md-12 col-xl-12 ">
								<div class="card">
									<div id="preloaderGanancia" class="preloader3" style="display:none;">
										<div class="circ1 loader-primary"></div>
										<div class="circ2 loader-primary"></div>
										<div class="circ3 loader-primary"></div>
										<div class="circ4 loader-primary"></div>
									</div>
									<div class="card-block" id="divListGanancia">
										<div class="dt-responsive table-responsive">
											<h4 style="margin-bottom:20px;">
												<g:message code="zifras.liquidacion.LiquidacionGanancia.list.label" default="Liquidaciones de Ganancias"/>
											</h4>
											<table id="listLiquidacionesGanancia" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
												<thead>
													<tr>
														<th></th>
														<th>Ano</th>
														<th>Cuit</th>
														<th>Razón Social</th>
														<th>Estado</th>
														<th>Renta imp.</th>
														<th>Imp. det.</th>
														<th>Ret.</th>
														<th>Per.</th>
														<th>Anticipos</th>
														<th>Impuesto</th>
														<th>Nota</th>
														<th>Zona</th>
														<th>Direccion</th>
														<th>Cant. Locales</th>
														<th>Locales</th>
														<th>Advertencia</th>
													</tr>
												</thead>
												<tbody>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
							<div class="col-md-12 col-xl-12">
								<div class="card">
									<div class="card-block ">
										<div class="dt-responsive table-responsive">
											<h4 style="margin-bottom:20px;">
												<g:message code="zifras.documento.DeclaracionJurada.list.label" default="Declaraciones Juradas"/>
											</h4>
											<table id="listDeclaracionesJuradas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
												<thead>
													<tr>
														<th>Fecha</th>
														<th>Descripcion</th>
														<th>Archivo</th>
													</tr>
												</thead>
												<tbody>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
						</g:if>
						<div class="col-md-12 col-xl-12">
							<div class="card">
								<div class="card-block ">
									<div class="dt-responsive table-responsive">
										<div style="float:right;">
											<label class="btn btn-primary" onclick="$('#modalImportarComprobante').modal('show');" style="float:left;padding-top:8px;margin-right:10px;margin-bottom:2px;text-transform: none">Importar comprobante</label>
											<label class="btn btn-success" id="btnNotificarMonotributo" style="float:left;padding-top:8px;margin-right:30px;margin-bottom:2px;text-transform: none">Notificar Monotributo</label>
										</div>
										<h4 style="margin-bottom:20px;">
											Comprobantes
										</h4>
										<table id="listComprobantes" class="table table-striped table-bordered nowrap" style="cursor:pointer">
											<thead>
												<tr>
													<th style="padding: 2px;"></th>
													<th>Tipo</th>
													<th>Fecha</th>
													<th>Archivo</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-12 col-xl-12 ">
							<div class="card">
								<div id="preloaderImportaciones" class="preloader3" style="display:none;">
									<div class="circ1 loader-primary"></div>
									<div class="circ2 loader-primary"></div>
									<div class="circ3 loader-primary"></div>
									<div class="circ4 loader-primary"></div>
								</div>
								<div class="card-block" id="divListImportaciones">
									<div class="dt-responsive table-responsive">
										<div style="float:right;">
											<label style="float:left;padding-top:5px;margin-right:10px;">Año</label>
											<input style="width:80px;" name="ano" class="form-control txtAno" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
										</div>
										<h4 style="margin-bottom:20px;">
											<g:message code="zifras.importacion.LogImportacion.list.label" default="Estado de las importaciones"/>
										</h4>
										<table id="listEstadoImportaciones" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
											<thead>
												<tr>
													<th>Mes</th>
													<th>Fac. Venta</th>
													<th>Fac. Compra</th>
													<th>Ret. IVA</th>
													<th>Perc. IVA</th>
													<th>Ret. IIBB</th>
													<th>Perc. IIBB</th>
													<th>R.Banc. IIBB</th>
													<th>Cant. FV</th>
													<th>Cant. FC</th>
													<th>Cant. Ret. IVA</th>
													<th>Cant. Per. IVA</th>
													<th>Cant. Ret. IIBB</th>
													<th>Cant. Per. IIBB</th>
													<th>Cant. R.Banc. IIBB</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>
					</g:if>
					<div class="col-md-12 col-xl-12 ">
						<div class="card">
							<div class="card-block">
								<div class="dt-responsive table-responsive" id="cuentaCorriente">
									<div id="preloaderMovimientos" class="preloader3" style="display:none;">
										<div class="circ1 loader-primary"></div>
										<div class="circ2 loader-primary"></div>
										<div class="circ3 loader-primary"></div>
										<div class="circ4 loader-primary"></div>
									</div>
									<div style="float:right;">
										<label class="btn btn-primary" onclick="generarPagoManual();" style="float:left;padding-top:8px;margin-right:10px;margin-bottom:2px;text-transform: none">Pagar Manualmente Seleccionadas</label>
									</div>
									<h4 style="margin-bottom:20px;">Cuenta Corriente</h4>
									<table id="listMovimientoCuenta" class="table table-striped table-bordered nowrap" style="cursor:pointer">
										<thead>
											<tr>
												<th id="listMovimientoCuentaTh1"></th>
												<th>ID</th>
												<th>Fecha</th>
												<th>Tipo</th>
												<th>Pagado</th>
												<th>Importe</th>
												<th>Descripción</th>
												<th>Saldo</th>
												<th>Responsable</th>
												<th>Milisegundos</th>
											</tr>
										</thead>
										<tbody>
										</tbody>
									</table>
								</div>
							</div>
							<h3 style="padding-bottom:15px; padding-left: 20px;">Deuda: $${cuentaInstance.deudaMovimientosImpagos()}</h3>
						</div>
					</div>
					<div class="col-md-12 col-xl-12">
						<div class="card">
							<div class="card-block ">
								<div class="dt-responsive table-responsive">
									<h4 style="margin-bottom:20px;">
										<g:message code="zifras.documento.FacturaCuenta.list.label" default="Facturas Calim"/>
									</h4>
									<table id="listFacturasCuenta" class="table table-striped table-bordered nowrap" style="cursor:pointer">
										<thead>
											<tr>
												<th>Fecha</th>
												<th>Descripcion</th>
												<th>Importe</th>
												<th>Avisos</th>
												<th>Pagada</th>
												<th>Archivo</th>
												<th>Responsable</th>
											</tr>
										</thead>
										<tbody>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-12 col-xl-12">
						<div class="card">
							<div class="card-block ">
								<div class="dt-responsive table-responsive">
									<h4 style="margin-bottom:20px;">
										VEP's
									</h4>
									<table id="listVeps" class="table table-striped table-bordered nowrap" style="cursor:pointer">
										<thead>
											<tr>
												<th>Fecha Emision</th>
												<th>Numero</th>
												<th>Importe</th>
												<th>Descripcion</th>
												<th>Tipo</th>
												<th>Archivo</th>
											</tr>
										</thead>
										<tbody>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="modalPresentarDDJJ" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="modalDdjjTitulo">Presentar Declaración Jurada</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<g:uploadForm name="declaracionForm">
						<g:hiddenField name="liquidacionId"/>
						<g:hiddenField name="cuentaId" value="${cuentaInstance.id}" />
						<g:hiddenField name="volverCuentaShow" value="true"/>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Fecha</label>
							<div class="col-sm-10">
								<input id="modalDdjjFecha" name="fecha" required="" class="form-control fechaDateDropper" type="text" data-format="d/m/Y" placeholder="Seleccione un día" value="${fechaHoy}" />
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Descripcion</label>
							<div class="col-sm-10">
								<textarea class="form-control" id="modalDdjjDescripcion" name="descripcion" rows="3"></textarea>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label"></label>
							<div class="col-sm-10">
								<input type="file" name="archivo" id="modalDdjjArchivo">
							</div>
						</div>
					</g:uploadForm>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
					<button class="btn btn-primary waves-effect waves-light " onclick="$('#declaracionForm').submit();">Presentar</button>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="modalAjusteConvenio" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="modalDdjjTitulo">Ajustar liquidación con archivo</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<g:uploadForm name="ajusteConvenioForm" controller="importacion" action="ajusteConvenio">
						<g:hiddenField name="convenioMes"/>
						<g:hiddenField name="convenioAno"/>
						<g:hiddenField name="cuentaId" value="${cuentaInstance.id}" />
						<div class="form-group row">
							<label class="col-sm-2 col-form-label"></label>
							<div class="col-sm-10">
								<input type="file" name="convenioArchivo" id="convenioArchivo">
							</div>
						</div>
					</g:uploadForm>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
					<button class="btn btn-primary waves-effect waves-light " onclick="$('#loaderGrande').show();$('#ajusteConvenioForm').submit();">Subir</button>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="modalImportarComprobante" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Importar Comprobante</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<br>
				<div class="modal-body" style="padding:0px;">
					<div class="form-group row">
						<label class="col-sm-1 col-form-label" style="margin-left: 16px">Tipo</label>
						<div class="col-md-4">
							<select id="cbTipoComprobante" name="tipoComprobante" class="form-control"></select>
						</div>
					</div>
					<div id="divPadreComprobante" class="card-block">
						<input type="file" name="comprobante" id="comprobante_importar" multiple="multiple">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="modalDDJJVep" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4>Adjuntar VEP a DDJJ</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<g:uploadForm name="declaracionFormVep" controller="vep" action="subirPorLiquidacion">
						<g:hiddenField name="esIva"/>
						<g:hiddenField name="liqId"/>
						<g:hiddenField name="cuentaId" value="${cuentaInstance.id}" />
						<div class="form-group row">
							<div class="col-sm-12">
								<input type="file" name="archivo" id="modalVepArchivo">
							</div>
						</div>
					</g:uploadForm>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
					<button class="btn btn-primary waves-effect waves-light " onclick="$('#declaracionFormVep').submit();">Adjuntar</button>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="modalIngresarCuit" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Activación manual</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="form-group row col-sm-12">
						<label class="col-sm-2 col-form-label">CUIT:</label>
						<div class="col-sm-10">
							<input
								type="number"
								id="modalIngresarCuit_cuit"
								class="form-control is-invalid"
								placeholder="Ingresá el CUIT sin guiones"
								onkeypress="var charCode = (event.which) ? event.which : event.keyCode;
								return !(charCode > 31 && (charCode < 48 || charCode > 57));"
								onkeyup="
								const valor = $(this).val();
								if (valor.length != 11 || !(['20', '23', '24', '27', '30', '33', '34'].includes(valor.slice(0,2)))){
								$(this).addClass('is-invalid');
								return;
								}
								$(this).removeClass('is-invalid');
								return;
								"
								>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
					<button type="button" class="btn btn-primary waves-effect waves-light " onclick="$('#modalIngresarCuit_cuit').hasClass('is-invalid') ? swal('CUIT Inválido', '', 'error') : obtenerDatosAfip();">Aceptar</button>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="modalNotificarError" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">¿Cuáles son los campos con error?</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="form-group row">
						<div class="col-sm-10">
							<div class="border-checkbox-section">
								<div class="border-checkbox-group border-checkbox-group-primary">
									<input class="border-checkbox" type="checkbox" name="fotos" id="checkFotos">
									<label class="border-checkbox-label" for="checkFotos">Fotos</label>
									<br>
									<input class="border-checkbox" type="checkbox" name="clavefiscal" id="checkClaveFiscal">
									<label class="border-checkbox-label" for="checkClaveFiscal">Clave Fiscal</label>
									<br>
									<input class="border-checkbox" type="checkbox" name="direccion" id="checkDireccion">
									<label class="border-checkbox-label" for="checkDireccion">Direccion</label>
									<br>
									<input class="border-checkbox" type="checkbox" name="codigoPostal" id="checkCodigoPostal">
									<label class="border-checkbox-label" for="checkCodigoPostal">Codigo Postal</label>
									<br>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button id="buttonVolverNotificarError" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
					<button id="buttonNotificarError" type="button" class="btn btn-primary waves-effect waves-light " onclick="notificarError();">Notificar</button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="modal fade" id="modalDatosAfip" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="modalDatosAfip_razonSocial"></h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="table-responsive">
						<table class="table m-0">
							<tbody>
								<tr>
									<th style="white-space:normal;" scope="row">Persona</th>
									<td style="white-space:normal;width:60%;" id="modalDatosAfip_tipo"></td>
								</tr>
								<tr>
									<th style="white-space:normal;" scope="row">Domicilio</th>
									<td style="white-space:normal;width:60%;" id="modalDatosAfip_domicilio"></td>
								</tr>
								<tr>
									<th style="white-space:normal;" scope="row">Localidad</th>
									<td style="white-space:normal;width:60%;" id="modalDatosAfip_localidad"></td>
								</tr>
								<tr>
									<th style="white-space:normal;" scope="row">Impuestos</th>
									<td style="white-space:normal;width:60%;">
										<label id="modalDatosAfip_impuestos" style="white-space: pre;"></label>
								</tr>
								<tr id="modalDatosAfip_categoriaTr">
									<th style="white-space:normal;" scope="row">Categoría</th>
									<td style="white-space:normal;width:60%;" id="modalDatosAfip_categoria"></td>
								</tr>
								<tr>
									<th style="white-space:normal;" scope="row">Actividad</th>
									<td style="white-space:normal;width:60%;" id="modalDatosAfip_actividad"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default waves-effect " onclick="$('#modalDatosAfip').modal('hide');$('#modalIngresarCuit').modal('show');">Volver</button>
					<button type="button" class="btn btn-primary waves-effect waves-light " onclick="activacionManual();">Confirmar</button>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript">
	var tablaIva;
	var tablaIIBB;
	var tablaGanancia;
	var tablaEstadoImportaciones;
	var tablaFacturacion;
	var varCbTipoComprobante = "Constancia_monotributo";
	var tablaMovimientoCuenta;
	var todoSeleccionadoMovimientos = false;
	var tablaDDJJ;
	var tablaFacturaCuenta;
	var datosIIBB
	var banderaBeforeSend = true;
	$(document).ready(function () {

		$("#mesIIBB").select2({
			placeholder: 'Seleccione un mes',
			minimumResultsForSearch: -1,
			data: [
				'Todos',
				'01',
				'02',
				'03',
				'04',
				'05',
				'06',
				'07',
				'08',
				'09',
				'10',
				'11',
				'12'		
			]
		});
		$("#mesIIBB").change(function () {
			tablaIIBB.clear().draw();
			for (key in datosIIBB)
				if (this.value == "Todos" || this.value == datosIIBB[key].mes)
					tablaIIBB.row.add(datosIIBB[key]).draw();
			tablaIIBB.draw();
		});
		$("#mesIIBB").val('${mes}')

		$("#cbTipoComprobante").change(function(){
			varCbTipoComprobante = $("#cbTipoComprobante option:selected").text();
		})
		var cuentaVerificada = ("${cuentaInstance?.estado?.nombre=='Sin verificar'}" == "false")
		//Success or cancel alert
		if (document.querySelector('.alert-success-cancel') != null) {
			document.querySelector('.alert-success-cancel').onclick = function () {
				swal({
						title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
						text: "<g:message code='zifras.cuenta.Cuenta.delete.message' default='La cuenta se eliminará'/>",
						type: "warning",
						showCancelButton: true,
						confirmButtonClass: "btn-danger",
						confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, eliminar'/>",
						cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
						closeOnConfirm: true,
						closeOnCancel: true
					},
					function (isConfirm) {
						if (isConfirm) {
							window.location.href = $('#urlDelete').text() + '/' + ${cuentaInstance?.id};
						}
						/*if (isConfirm) {
							swal("Deleted!", "Your imaginary file has been deleted.", "success");
						} else {
							swal("Cancelled", "Your imaginary file is safe :)", "error");
						}*/
					});
			};
		}
		//Bloquear usuario
		if (document.querySelector('.bloqUser') != null) {
			document.querySelector('.bloqUser').onclick = function () {
				var estabaDesbloqueado = ${User.findByUsername(cuentaInstance.email)?.enabled}
				swal({
						title: "<g:message code='default.button.block.confirm.message' default='¿Estás seguro?'/>",
						text: "El usuario se " + ((estabaDesbloqueado) ? "" : "des") + "bloqueará.",
						type: "warning",
						showCancelButton: true,
						confirmButtonClass: "btn-danger",
						confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, eliminar'/>",
						cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
						closeOnConfirm: true,
						closeOnCancel: true
					},
					function (isConfirm) {
						if (isConfirm) {
							$.ajax($('#urlBloquearDesbloquearUsuario').text(), {
								dataType: "json",
								data: {
									id: "${User.findByUsername(cuentaInstance.email)?.id}"
								}
							}).done(function (data) {
								swal("El usuario se ha " + ((estabaDesbloqueado) ? "" : "des") + "bloqueado.");
								$('#btnBloqUser').text((!estabaDesbloqueado ? 'B' : 'Desb') + 'loquear usuario')
							});
						}
					});
			};
		}

		//Suspender cuenta
		if (document.querySelector('.suspenderCuenta') != null) {
			document.querySelector('.suspenderCuenta').onclick = function () {
				swal({
						title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
						text: "<g:message code='zifras.cuenta.Cuenta.delete.message' default='La cuenta se suspenderá'/>",
						type: "warning",
						showCancelButton: true,
						confirmButtonClass: "btn-danger",
						confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, suspender'/>",
						cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
						closeOnConfirm: true,
						closeOnCancel: true
					},
					function (isConfirm) {
						if (isConfirm) {
							window.location.href = $('#urlSuspenderCuenta').text() + '/' + ${cuentaInstance?.id};
						}
						/*if (isConfirm) {
							swal("Deleted!", "Your imaginary file has been deleted.", "success");
						} else {
							swal("Cancelled", "Your imaginary file is safe :)", "error");
						}*/
					});
			};
		}

		//Reactivar cuenta
		if (document.querySelector('.reactivarCuenta') != null) {
			document.querySelector('.reactivarCuenta').onclick = function () {
				swal({
						title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
						text: "<g:message code='zifras.cuenta.Cuenta.recuperar.message' default='La cuenta se reactivará'/>",
						type: "warning",
						showCancelButton: true,
						confirmButtonClass: "btn-danger",
						confirmButtonText: "<g:message code='zifras.recuperar.ok' default='Si, reactivar'/>",
						cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
						closeOnConfirm: true,
						closeOnCancel: true
					},
					function (isConfirm) {
						if (isConfirm) {
							window.location.href = $('#urlRecuperar').text() + '/' + ${cuentaInstance?.id};
						}
						/*if (isConfirm) {
							swal("Deleted!", "Your imaginary file has been deleted.", "success");
						} else {
							swal("Cancelled", "Your imaginary file is safe :)", "error");
						}*/
					});
			};
		}

		//Success or cancel alert
		if (document.querySelector('.recuperar') != null) {
			document.querySelector('.recuperar').onclick = function () {
				swal({
						title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
						text: "<g:message code='zifras.cuenta.Cuenta.recuperar.message' default='La cuenta se recuperará'/>",
						type: "warning",
						showCancelButton: true,
						confirmButtonClass: "btn-danger",
						confirmButtonText: "<g:message code='zifras.recuperar.ok' default='Si, recuperar'/>",
						cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
						closeOnConfirm: true,
						closeOnCancel: true
					},
					function (isConfirm) {
						if (isConfirm) {
							window.location.href = $('#urlRecuperar').text() + '/' + ${cuentaInstance?.id};
						}
						/*if (isConfirm) {
							swal("Deleted!", "Your imaginary file has been deleted.", "success");
						} else {
							swal("Cancelled", "Your imaginary file is safe :)", "error");
						}*/
					});
			};
		}

		if (cuentaVerificada) {
			var buttonCommon = {
				exportOptions: {
					format: {
						body: function (data, row, column, node) {
							data = $('<p>' + data + '</p>').text();
							data = data.replace(/\./g, '');
							return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
						}
					}
				}
			};

			$("#btnResolverErrorAFIP").click(function(){
				window.location.href = $("#urlResolverErrorAFIP").text() + '/' + ${cuentaInstance?.id};
			});

			tablaIva = $('#listLiquidaciones').DataTable({
				"ordering": false,
				"searching": true,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando liquidaciones')}</a>",
					sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
					sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
					sInfoPostFix: "",
					sUrl: "",
					sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
					oPaginate: {
						"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
						"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
						"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
						"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
					}
				},
				iDisplayLength: 22,
				//scrollX: true,
				aaSorting: [
					[1, 'asc']
				],
				aoColumnDefs: [{
					"aTargets": [0],
					'orderable': false,
					"mData": "selected",
					"mRender": function (data, type, full) {
						var salida;

						var link1;
						var link2;

						salida = '<a class="dropdown-toggle addon-btn" data-toggle="dropdown" aria-expanded="true">' +
							'<i class="icofont icofont-ui-settings"></i>' +
							'</a>';
						if (full['id'] != '' && full['id'] != null) {
							link1 = $('#urlShowIVA').text() + '/' + full['id'];
							link2 = $('#urlEditIVA').text() + '/' + full['id'];
							var idMandar = full['id']
							salida += '<div class="dropdown-menu dropdown-menu-right">' +
								'<a target="_blank" class="dropdown-item" href="' + link1 + '"><i class="icofont icofont-attachment"></i>Mostrar</a>'

							if (full['estado'] == 'Autorizada')
								salida += '' +
								'<a target="_blank" class="dropdown-item" onclick="showModalDDJJ(\'Iva\', ' + idMandar + ',null,' + full['mes'] + ',' + full['ano'] + ');"><i class="icofont icofont-send-mail"></i>Presentar</a>'

							if (full['estado'] != 'Presentada'){
								salida +='<a target="_blank" class="dropdown-item" href="' +link2 + '"><i class="icofont icofont-ui-edit"></i>Editar</a>'
							
								salida += '<sec:ifAnyGranted roles="ROLE_ADMIN">' +
								'<button target="_blank" onclick="borrarElementoListaIVA(' + idMandar + ');" style="font-size: 14px; padding: 10px 16px;" class="dropdown-item"><i class="icofont icofont-ui-delete"></i>Eliminar</button>' +
								'</sec:ifAnyGranted>'

								if (full['estado'] != 'Autorizada'){
									salida += '<a target="_blank" class="dropdown-item" onclick="notificarLiq(' + full['mes'] + ',' + full['ano'] + ', true)"><i class="icofont icofont-send-mail"></i>Notificar</a>'
									salida += '<a class="dropdown-item" onclick="$(\'#loaderGrande\').show()" href="/cuenta/seleniumViejo/${cuentaInstance.id}?mes=' + full.mes + '&ano=' + full.ano + '"><i class="icofont icofont-upload"></i>Selenium</a>'
								}
							}else
								salida += '<a target="_blank" class="dropdown-item" onclick="showModalVepDDJJ(true, ' + idMandar + ');"><i class="icofont icofont-send-mail"></i>Subir VEP</a>'
							if (${cuentaInstance?.tenantId == 1})
								salida += '<a target="_blank" class="dropdown-item" href="/selenium/generarVepChino/' + full.id + '" ><i class="icofont icofont-send-mail"></i>Generar VEP</a>'

						}
						else {
							link1 = $('#urlCreateIVA').text() + '/?cuentaId=' + full['cuentaId'] + '&mes=' + full['mes'] + '&ano=' + full['ano'];

							salida += '<div class="dropdown-menu dropdown-menu-right">' +
								'<a target="_blank" class="dropdown-item" href="' + link1 + '"><i class="icofont icofont-ui-edit"></i>Editar</a>' 
							salida += '<a class="dropdown-item" onclick="$(\'#loaderGrande\').show()" href="/cuenta/seleniumViejo/${cuentaInstance.id}?mes=' + full.mes + '&ano=' + full.ano + '"><i class="icofont icofont-upload"></i>Selenium</a>'
						}
						salida += '</div>'
						return salida;
					}
				}, {
					"aTargets": [1],
					"mData": "mes",
					'sClass': 'bold'
				}, {
					"aTargets": [2],
					"mData": "estado"
				}, {
					"aTargets": [3],
					"mData": "facturasVentaImportadas",
					"mRender": function (data, type, full) {
						if (data == "Importado")
							return '<i class="icofont icofont-ui-check"></i>';
						else
							return "-";
					}
				}, {
					"aTargets": [4],
					"mData": "facturasCompraImportadas",
					"mRender": function (data, type, full) {
						if (data == "Importado")
							return '<i class="icofont icofont-ui-check"></i>';
						else
							return "-";
					}
				}, {
					"aTargets": [5],
					"mData": "porcentajeDebitoCredito",
					"sClass": "text-right"
				}, {
					"aTargets": [6],
					"mData": "saldoDdjj",
					"sClass": "text-right"
				}, {
					"aTargets": [7],
					"mData": "debitoFiscal",
					"sClass": "text-right"
				}, {
					"aTargets": [8],
					"mData": "debitoFiscal2",
					"sClass": "text-right",
					"visible":false
				}, {
					"aTargets": [9],
					"mData": "debitoFiscal5",
					"sClass": "text-right",
					"visible":false
				}, {
					"aTargets": [10],
					"mData": "debitoFiscal10",
					"sClass": "text-right",
					"visible":false
				}, {
					"aTargets": [11],
					"mData": "debitoFiscal21",
					"sClass": "text-right",
					"visible":false
				}, {
					"aTargets": [12],
					"mData": "debitoFiscal27",
					"sClass": "text-right",
					"visible":false
				}, {
					"aTargets": [13],
					"mData": "creditoFiscal",
					"sClass": "text-right"
				}, {
					"aTargets": [14],
					"mData": "creditoFiscal2",
					"sClass": "text-right",
					"visible":false
				}, {
					"aTargets": [15],
					"mData": "creditoFiscal5",
					"sClass": "text-right",
					"visible":false
				}, {
					"aTargets": [16],
					"mData": "creditoFiscal10",
					"sClass": "text-right",
					"visible":false
				}, {
					"aTargets": [17],
					"mData": "creditoFiscal21",
					"sClass": "text-right",
					"visible":false
				}, {
					"aTargets": [18],
					"mData": "creditoFiscal27",
					"sClass": "text-right",
					"visible":false
				}, {
					"aTargets": [19],
					"mData": "saldoTecnicoAFavor",
					"sClass": "text-right"
				}, {
					"aTargets": [20],
					"mData": "saldoTecnicoAFavorPeriodoAnterior",
					"sClass": "text-right"
				}, {
					"aTargets": [21],
					"mData": "saldoLibreDisponibilidad",
					"sClass": "text-right"
				}, {
					"aTargets": [22],
					"mData": "saldoLibreDisponibilidadPeriodoAnterior",
					"sClass": "text-right"
				}, {
					"aTargets": [23],
					"mData": "percepcion",
					"sClass": "text-right"
				}, {
					"aTargets": [24],
					"mData": "retencion",
					"sClass": "text-right"
				}, {
					"aTargets": [25],
					"mData": "locales",
					"sClass": "text-right"
				}, {
					"aTargets": [26],
					"mData": "advertencia"
				}],
				select: {
					style: 'os',
					selector: 'td:first-child',
					style: 'multi'
				},
				sPaginationType: 'simple',
				sDom: "Br",
				buttons: [
					$.extend(true, {}, buttonCommon, {
						extend: 'excelHtml5',
						title: function () {
							var nombre = "${cuentaInstance?.cuit} ${cuentaInstance?.razonSocial} ";
							nombre = nombre + "Liquidacion IVA " + $("#ano").val();
							return nombre;
						}
					}),
					{
						extend: 'pdfHtml5',
						title: function () {
							var nombre = "${cuentaInstance?.cuit} ${cuentaInstance?.razonSocial} ";
							nombre = nombre + "Liquidacion IVA " + $("#ano").val();
							return nombre;
						}
					},
					'copyHtml5',
					{
						text: 'Desglose CF y DB',
						action: function ( e, dt, node, config ) {
							tablaIva.columns([8,9,10,11,12,14,15,16,17,18]).visible(!tablaIva.column(8).visible())
						}
					}
				],
				fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
					if (aData['advertencia'] != '') {
						$(nRow).css({
							"background-color": "red",
							"color": "white"
						});
					}
				}
			});

			llenarDatoslistLiquidacionesIva();

			tablaIIBB = $('#listLiquidacionesIIBB').DataTable({
				//bAutoWidth: false,
				//bSortCellsTop: true,
				//BProcessing: true,
				"ordering": true,
				"searching": true,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando liquidaciones')}</a>",
					sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
					sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
					sInfoPostFix: "",
					sUrl: "",
					sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
					oPaginate: {
						"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
						"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
						"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
						"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
					}
				},
				iDisplayLength: 288,
				aaSorting: [
					[1, 'asc'],
					[3, 'asc']
				],
				aoColumnDefs: [{
					"aTargets": [0],
					'orderable': false,
					"mData": "selected",
					"mRender": function (data, type, full) {
						var salida;

						var link1;
						var link2;

						salida = '<a class="dropdown-toggle addon-btn" data-toggle="dropdown" aria-expanded="true">' +
							'<i class="icofont icofont-ui-settings"></i>' +
							'</a>';

						if (full['id'] != '' && full['id'] != null) {
							link1 = $('#urlShowIIBB').text() + '/' + full['id'];
							link2 = $('#urlEditIIBB').text() + '/' + full['id'];
							var idMandar = full['id']

							salida += '<div class="dropdown-menu dropdown-menu-right">' +
								'<a class="dropdown-item" target="_blank" href="' + link1 + '"><i class="icofont icofont-attachment"></i>Mostrar</a>'

							if (full['estado'] == 'Autorizada')
								salida += '' +
								'<a target="_blank" class="dropdown-item" onclick="showModalDDJJ(\'Iibb\', ' + idMandar + ',\'' + full['provinciaNombre'] + '\',' + full['mes'] + ',' + full['ano'] + ');"><i class="icofont icofont-send-mail"></i>Presentar</a>'

							if (full['estado'] != 'Presentada'){
								salida += '<a class="dropdown-item" target="_blank" href="' + link2 + '"><i class="icofont icofont-ui-edit"></i>Editar</a>'

								salida += '<sec:ifAnyGranted roles="ROLE_ADMIN">' +
								'<button target="_blank" onclick="borrarElementoListaIIBB(' + idMandar + ');" style="font-size: 14px; padding: 10px 16px;" class="dropdown-item"><i class="icofont icofont-ui-delete"></i>Eliminar</button>' +
								'</sec:ifAnyGranted>'

								if (full['estado'] != 'Autorizada'){
									salida += '<a target="_blank" class="dropdown-item" onclick="notificarLiq(' + full['mes'] + ',' + full['ano'] + ', false)"><i class="icofont icofont-send-mail"></i>Notificar</a>'
									salida += '<a class="dropdown-item" onclick="$(\'#loaderGrande\').show()" href="/cuenta/seleniumViejo/${cuentaInstance.id}?mes=' + full.mes + '&ano=' + full.ano + '"><i class="icofont icofont-upload"></i>Selenium</a>'

									if ("${cuentaInstance?.regimenIibb?.nombre}" == "Convenio Multilateral")
										salida += '<a target="_blank" class="dropdown-item" onclick="ajustarConvenioArchivo(' + full.mes + ', ' + full.ano + ');"><i class="icofont icofont-upload"></i>Corregir con Archivo</a>'
									salida += '<a class="dropdown-item" href="/retencionPercepcionIIBB/limpiarMes?mes=' + full['mes'] + '&ano=' + full['ano'] + '&cuentaId=' + full['cuentaId'] + '"><i class="icofont icofont-ui-delete"></i>Eliminar deducciones</a>'
								}

							}else
								salida += '<a target="_blank" class="dropdown-item" onclick="showModalVepDDJJ(false, ' + idMandar + ');"><i class="icofont icofont-send-mail"></i>Subir VEP</a>'
						}
						else {
							link1 = $('#urlCreateIIBB').text() + '/?cuentaId=' + full['cuentaId'] + '&mes=' + full['mes'] + '&ano=' + full['ano'] + '&provinciaId=' + full['provinciaId'];

							salida += '<div class="dropdown-menu dropdown-menu-right">' +
								'<a class="dropdown-item" target="_blank" href="' + link1 + '"><i class="icofont icofont-ui-edit"></i>Editar</a>'
							salida += '<a class="dropdown-item" onclick="$(\'#loaderGrande\').show()" href="/cuenta/seleniumViejo/${cuentaInstance.id}?mes=' + full.mes + '&ano=' + full.ano + '"><i class="icofont icofont-upload"></i>Selenium</a>'
						}
						salida += '</div>'
						return salida;
					}
				}, {
					"aTargets": [1],
					"mData": "mes",
					'sClass': 'bold'
				}, {
					"aTargets": [2],
					"mData": "estado"
				}, {
					"aTargets": [3],
					"mData": "provinciaNombre"
				}, {
					"aTargets": [4],
					"mData": "saldoDdjj",
					"sClass": "text-right"
				}, {
					"aTargets": [5],
					"mData": "netoTotal",
					"sClass": "text-right"
				}, {
					"aTargets": [6],
					"mData": "porcentajeProvincia",
					"sClass": "text-right"
				}, {
					"aTargets": [7],
					"mData": "neto",
					"sClass": "text-right"
				}, {
					"aTargets": [8],
					"mData": "impuesto",
					"sClass": "text-right"
				}, {
					"aTargets": [9],
					"mData": "retencion",
					"sClass": "text-right"
				}, {
					"aTargets": [10],
					"mData": "sircreb",
					"sClass": "text-right"
				}, {
					"aTargets": [11],
					"mData": "percepcion",
					"sClass": "text-right"
				}, {
					"aTargets": [12],
					"mData": "saldoAFavor",
					"sClass": "text-right"
				}, {
					"aTargets": [13],
					"mData": "saldoAFavorPeriodoAnterior",
					"sClass": "text-right"
				}, {
					"aTargets": [14],
					"mData": "nota",
					"sClass": "text-right"
				}, {
					"aTargets": [15],
					"mData": "locales",
					"sClass": "text-right"
				}, {
					"aTargets": [16],
					"mData": "advertencia"
				}],
				buttons: [
					$.extend(true, {}, buttonCommon, {
						extend: 'excelHtml5',
						exportOptions: {
							columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
						},
						title: function () {
							var nombre = "Liquidaciones IIBB " + $("#ano").val();
							return nombre;
						}
					}),
					{
						extend: 'pdfHtml5',
						exportOptions: {
							columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
						},
						orientation: 'landscape',
						title: function () {
							var nombre = "Liquidaciones IIBB " + $("#ano").val();
							return nombre;
						}
					},
					{
						extend: 'copyHtml5',
						exportOptions: {
							columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
						},
					}
				],
				sPaginationType: 'simple',
				sDom: "Brf",
				fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
					if (aData['advertencia'] != '') {
						$(nRow).css({
							"background-color": "red",
							"color": "white"
						});
					}
					// Row click
					/*$(nRow).on('click', function() {
						if(aData['estado']!='Sin liquidar'){
							window.location.href = $('#urlShow').text() + '/' + aData['id'];
						}else{
							window.location.href = $('#urlCreate').text() + '/?cuentaId=' + aData['cuentaId'];
						}				
					});*/
				},
				"footerCallback": function (row, data, start, end, display) {
					var api = this.api(),
						data;

					// Total over all pages
					total = api
						.column(4, {
								page: 'current'
							})
						.data()
						.reduce(function (a, b) {
							const numA = typeof a === 'number' ? a : a == undefined || a == "" ? 0 : parsearFloat(a)
							const numB = typeof b === 'number' ? b : b == undefined || b == "" ? 0 : parsearFloat(b)
							return numA + numB
						}, 0);

					
					// Update footer
					$(api.column(4).footer()).html(
						'$' + total.toFixed(2)
					);
				},
			});

			llenarDatoslistLiquidacionesIIBB();

			tablaVolantes = $('#listVolantesPago').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.comprobantePago.ComprobantePago.list.agregar', default: 'No hay Comprobantes de Pago')}</a>",
				sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
				sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
				sInfoPostFix: "",
				sUrl: "",
				sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
				oPaginate: {
					"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
					"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
					"sNext":	"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
					"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
				}
			},
			aaSorting: [
				[1, 'desc']
			],
			aoColumnDefs: [{
							"aTargets": [0],
							"mData": "periodo",
							'sClass': 'bold'
						},{
							"aTargets": [1],
							"mData": "descripcion"			       			
						},{
							"aTargets": [2],
							"mData": "vencimientoSimplificado"	       			
						},{
							"aTargets": [3],
							"mData": "nombreArchivo"
						}],
			buttons: [{
					extend: 'excelHtml5',
					title: function () {
							var nombre = "Volantes de pago";
							return nombre;
					}
				},{
					extend: 'pdfHtml5',
					orientation: 'landscape',
					title: function () {
						var nombre = "Volantes de pago";
							return nombre;
					}
				},{
					extend: 'copyHtml5'
				}],
			sPaginationType: 'simple',
			sDom: "Bfrtip",
			fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlEditVolante').text() + '/' + aData['id'];
				});
			}
			});

			llenarDatoslistVolantesPago();

			tablaGanancia = $('#listLiquidacionesGanancia').DataTable({
				//bAutoWidth: false,
				//bSortCellsTop: true,
				//BProcessing: true,
				"ordering": true,
				"searching": true,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay liquidaciones')}</a>",
					sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
					sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
					sInfoPostFix: "",
					sUrl: "",
					sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
					oPaginate: {
						"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
						"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
						"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
						"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
					}
				},
				//iDisplayLength: 100,
				//scrollX: true,
				aaSorting: [
					[1, 'asc']
				],
				aoColumnDefs: [{
					"aTargets": [0],
					'orderable': false,
					"mData": "selected",
					"mRender": function (data, type, full) {
						var salida;

						var link1;
						var link2;

						salida = '<a class="dropdown-toggle addon-btn" data-toggle="dropdown" aria-expanded="true">' +
							'<i class="icofont icofont-ui-settings"></i>' +
							'</a>';

						if (full['id'] != '' && full['id'] != null) {
							link1 = $('#urlShowGanancia').text() + '/' + full['id'];
							link2 = $('#urlEditGanancia').text() + '/' + full['id'];
							var idMandar = full['id']

							salida += '<div class="dropdown-menu dropdown-menu-right">' +
								'<a class="dropdown-item" href="' + link1 + '" target="_blank"><i class="icofont icofont-attachment"></i>Mostrar</a>' +
								'<a class="dropdown-item" href="' + link2 + '" target="_blank"><i class="icofont icofont-ui-edit"></i>Editar</a>'
							/*if (full['estado'] == 'Autorizada')
								salida += '' +
											'<a target="_blank" class="dropdown-item" onclick="showModalDDJJ(\'Ganancia\', ' + idMandar + ');"><i class="icofont icofont-send-mail"></i>Presentar</a>'*/
							salida += '' +
								'<sec:ifAnyGranted roles="ROLE_ADMIN">' +
								'<button target="_blank" onclick="borrarElementoListaGanancia(' + idMandar + ');" style="font-size: 14px; padding: 10px 16px;" class="dropdown-item"><i class="icofont icofont-ui-delete"></i>Eliminar</button>' +
								'</sec:ifAnyGranted>' +
								'</div>';
						}
						else {
							link1 = $('#urlCreateGanancia').text() + '/?cuentaId=' + full['cuentaId'] + '&ano=' + full['ano'];

							salida += '<div class="dropdown-menu dropdown-menu-right">' +
								'<a class="dropdown-item" href="' + link1 + '" target="_blank"><i class="icofont icofont-ui-edit"></i>Editar</a>' +
								'</div>';
						}
						return salida;
					}
				}, {
					"aTargets": [1],
					"mData": "ano",
					'sClass': 'bold'
				}, {
					"aTargets": [2],
					"mData": "cuentaCuit",
					'sClass': 'bold'
				}, {
					"aTargets": [3],
					"mData": "cuentaNombre"
				}, {
					"aTargets": [4],
					"mData": "estado"
				}, {
					"aTargets": [5],
					"mData": "rentaImponible",
					"sClass": "text-right"
				}, {
					"aTargets": [6],
					"mData": "impuestoDeterminado",
					"sClass": "text-right"
				}, {
					"aTargets": [7],
					"mData": "retencion",
					"sClass": "text-right"
				}, {
					"aTargets": [8],
					"mData": "percepcion",
					"sClass": "text-right"
				}, {
					"aTargets": [9],
					"mData": "anticipos",
					"sClass": "text-right"
				}, {
					"aTargets": [10],
					"mData": "impuesto",
					"sClass": "text-right"
				}, {
					"aTargets": [11],
					"mData": "nota",
					"sClass": "text-right"
				}, {
					"aTargets": [12],
					"mData": "zonas"
				}, {
					"aTargets": [13],
					"mData": "direcciones"
				}, {
					"aTargets": [14],
					"mData": "cantidadLocales",
					"sClass": "text-right"
				}, {
					"aTargets": [15],
					"mData": "locales",
					"sClass": "text-right"
				}, {
					"aTargets": [16],
					"mData": "advertencia",
					"sClass": "text-right"
				}],
				buttons: [
					$.extend(true, {}, buttonCommon, {
						extend: 'excelHtml5',
						exportOptions: {
							columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
						},
						title: function () {
							var nombre = "Liquidaciones Ganancias " + $("#ano").val();
							return nombre;
						}
					}),
					{
						extend: 'pdfHtml5',
						exportOptions: {
							columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
						},
						orientation: 'landscape',
						title: function () {
							var nombre = "Liquidaciones Ganancias " + $("#ano").val();
							return nombre;
						}
					},
					{
						extend: 'copyHtml5',
						exportOptions: {
							columns: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
						},
					}
				],
				sPaginationType: 'simple',
				sDom: "Br",
				fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
					if (aData['advertencia'] != '') {
						$(nRow).css({
							"background-color": "red",
							"color": "white"
						});
					}
					// Row click
					/*$(nRow).on('click', function() {
						if(aData['estado']!='Sin liquidar'){
							window.location.href = $('#urlShow').text() + '/' + aData['id'];
						}else{
							window.location.href = $('#urlCreate').text() + '/?cuentaId=' + aData['cuentaId'];
						}				
					});*/
				}
			});

			llenarDatoslistLiquidacionesGanancia();

			tablaEstadoImportaciones = $('#listEstadoImportaciones').DataTable({
				"ordering": false,
				"searching": true,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando importaciones')}</a>",
					sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
					sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
					sInfoPostFix: "",
					sUrl: "",
					sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
					oPaginate: {
						"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
						"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
						"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
						"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
					}
				},
				iDisplayLength: 12,
				//scrollX: true,
				aaSorting: [
					[0, 'asc']
				],
				aoColumnDefs: [{
					"aTargets": [0],
					"mData": "fecha",
					"type": "date-eu"
				}, {
					"aTargets": [1],
					"mData": "venta",
					"mRender": function (data, type, full) {
						if (data == "Importado")
							return '<i class="icofont icofont-ui-check"></i>';
						else
							return "-";
					}
				}, {
					"aTargets": [2],
					"mData": "compra",
					"mRender": function (data, type, full) {
						if (data == "Importado")
							return '<i class="icofont icofont-ui-check"></i>';
						else
							return "-";
					}
				}, {
					"aTargets": [3],
					"mData": "retencionesIva",
					"mRender": function (data, type, full) {
						if (data == "Importado")
							return '<i class="icofont icofont-ui-check"></i>';
						else
							return "-";
					}
				}, {
					"aTargets": [4],
					"mData": "percepcionesIva",
					"mRender": function (data, type, full) {
						if (data == "Importado")
							return '<i class="icofont icofont-ui-check"></i>';
						else
							return "-";
					}
				}, {
					"aTargets": [5],
					"mData": "retencionesIibb",
					"mRender": function (data, type, full) {
						if (data == "Importado")
							return '<i class="icofont icofont-ui-check"></i>';
						else
							return "-";
					}
				}, {
					"aTargets": [6],
					"mData": "percepcionesIibb",
					"mRender": function (data, type, full) {
						if (data == "Importado")
							return '<i class="icofont icofont-ui-check"></i>';
						else
							return "-";
					}
				}, {
					"aTargets": [7],
					"mData": "bancarias",
					"mRender": function (data, type, full) {
						if (data == "Importado")
							return '<i class="icofont icofont-ui-check"></i>';
						else
							return "-";
					}
				}, {
					"aTargets": [8],
					"mData": "cantidadFacturasVenta",
					"sClass": "text-right"
				}, {
					"aTargets": [9],
					"mData": "cantidadFacturasCompra",
					"sClass": "text-right"
				}, {
					"aTargets": [10],
					"mData": "cantidadRetencionesIva",
					"sClass": "text-right"
				}, {
					"aTargets": [11],
					"mData": "cantidadPercepcionesIva",
					"sClass": "text-right"
				}, {
					"aTargets": [12],
					"mData": "cantidadRetencionesIibb",
					"sClass": "text-right"
				}, {
					"aTargets": [13],
					"mData": "cantidadPercepcionesIibb",
					"sClass": "text-right"
				}, {
					"aTargets": [14],
					"mData": "cantidadBancarias",
					"sClass": "text-right"
				}],
				select: {
					style: 'os',
					selector: 'td:first-child',
					style: 'multi'
				},
				sPaginationType: 'simple',
				sDom: "Br",
				buttons: []
			});

			tablaFacturacion = $('#listFacturacion').DataTable({
				"footerCallback": function (row, data, start, end, display) {
					var api = this.api(),
						data;

					// Total over all pages
					factTotal = api
						.column(1, {
								page: 'current'
							})
						.data()
						.reduce(function (a, b) {
							const numA = typeof a === 'number' ? a : a == undefined || a == "" ? 0 : parsearFloat(a)
							const numB = typeof b === 'number' ? b : b == undefined || b == "" ? 0 : parsearFloat(b)
							return numA + numB
						}, 0);
					cantTotal = api
						.column(2, {
								page: 'current'
							})
						.data()
						.reduce(function (a, b) {
							const numA = typeof a === 'number' ? a : a == undefined || a == "" ? 0 : parsearFloat(a)
							const numB = typeof b === 'number' ? b : b == undefined || b == "" ? 0 : parsearFloat(b)
							return numA + numB
						}, 0);

					
					// Update footer
					$(api.column(1).footer()).html(
						'$' + factTotal.toFixed(2)
					);
					$(api.column(2).footer()).html(
						cantTotal
					);
				},
				"ordering": true,
				"searching": false,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando ventas')}</a>",
					sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
					sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
					sInfoPostFix: "",
					sUrl: "",
					sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
					oPaginate: {
						"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
						"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
						"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
						"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
					}
				},
				lengthMenu: [[4,6,12], [4,6,12]],
				iDisplayLength: 12,
				buttons: [
					$.extend(true, {}, buttonCommon, {
						extend: 'excelHtml5',
						exportOptions: {
							columns: [0, 1, 2,]
						},
						title: function () {
							var nombre = "Facturación " + $("#ano").val() + " ${cuentaInstance.cuit}";
							return nombre;
						}
					}),
					{
						extend: 'pdfHtml5',
						exportOptions: {
							columns: [0, 1, 2,]
						},
						orientation: 'landscape',
						title: function () {
							var nombre = "Facturación " + $("#ano").val() + " ${cuentaInstance.cuit}";
							return nombre;
						}
					},
					{
						extend: 'copyHtml5',
						exportOptions: {
							columns: [0, 1, 2,]
						},
					}
				],
				//scrollX: true,
				aaSorting: [
					[0, 'asc']
				],
				aoColumnDefs: [{
					"aTargets": [0],
					"mData": "mes"
				}, {
					"aTargets": [1],
					"mData": "ventaTotal",
					"sClass": "text-right"
				}, {
					"aTargets": [2],
					"mData": "cantidad",
					"sClass": "text-right"
				}, {
					"aTargets": [3],
					"mData": "link",
					"sClass": "text-right"
				}],
				/*select: {
					style: 'os',
					selector: 'td:first-child',
					style: 'multi'
				},*/
				sPaginationType: 'simple',
	       		sDom: "lBfrtip",
			});

			llenarDatoslistImportacionesFacturas();
			llenarDatoslistFacturacionAnual();

			$('#listMovimientoCuentaTh1').click(function() {
				if(todoSeleccionadoMovimientos===true){
					$('#listMovimientoCuentaTh1').parent().removeClass("selected");
					todoSeleccionadoMovimientos = false;
					tablaMovimientoCuenta.rows().deselect();
				}else{
					$('#listMovimientoCuentaTh1').parent().addClass("selected");
					todoSeleccionadoMovimientos = true;
					tablaMovimientoCuenta.rows( function (index, data, nodo) {
						return ! data.pagado;
					} ).select();
				}
			});

			tablaDDJJ = $('#listDeclaracionesJuradas').DataTable({
				//bAutoWidth: false,
				//bSortCellsTop: true,
				//BProcessing: true,
				"ordering": true,
				"searching": true,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "${message(code: 'zifras.declaracionJurada.DeclaracionJurada.list.agregar', default: 'No hay Declaraciones Juradas')}</a>",
					sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
					sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
					sInfoPostFix: "",
					sUrl: "",
					sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
					oPaginate: {
						"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
						"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
						"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
						"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
					}
				},
				aaSorting: [
					[0, 'desc']
				],
				aoColumnDefs: [{
					"aTargets": [0],
					"mData": "fecha",
					"type": "date-eu"
				}, {
					"aTargets": [1],
					"mData": "descripcion"
				}, {
					"aTargets": [2],
					"mData": "nombreArchivo",
					"mRender": function (data, type, full) {
						var icono;
						if (full['tipoArchivo'] == "pdf")
							icono = '<i class="icofont icofont-file-pdf"></i>'
						else if (full['tipoArchivo'] == "doc")
							icono = '<i class="icofont-file-word"></i>'
						else
							icono = '<i class="icofont icofont-file-text"></i>'
						return icono + "   <a href=/declaracionJurada/download/" + full.id + ">" + data + "</a>"
					}
				}],
				sPaginationType: 'simple',
				fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
					// Row click
					$(nRow).on('click', function () {
						window.location.href = $('#urlEditDDJJ').text() + '/' + aData['id'];
					});
				}
			});

			llenarDatoslistDeclaracionesJuradas();

			$('#modalDdjjArchivo').filer({
				limit: 1,
				maxSize: null,
				extensions: null,
				changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Arrastrá tu archivo acá</h3> <span style="display:inline-block; margin: 15px 0">ó</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Seleccionar</a></div></div>',
				showThumbs: true,
				theme: "dragdropbox",
				templates: {
					box: '<ul class="jFiler-items-list jFiler-items-grid"></ul>',
					item: '<li class="jFiler-item">\
								<div class="jFiler-item-container">\
									<div class="jFiler-item-inner">\
										<div class="jFiler-item-assets jFiler-row" style="margin-top:0px;">\
											<ul class="list-inline pull-right">\
												<li><span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span></li>\
												<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
											</ul>\
										</div>\
									</div>\
								</div>\
							</li>',
					itemAppend: '<li class="jFiler-item">\
									<div class="jFiler-item-container">\
										<div class="jFiler-item-inner">\
											<div class="jFiler-item-thumb">\
												<div class="jFiler-item-status"></div>\
												<div class="jFiler-item-info">\
													<span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
													<span class="jFiler-item-others">{{fi-size2}}</span>\
												</div>\
												{{fi-image}}\
											</div>\
											<div class="jFiler-item-assets jFiler-row">\
												<ul class="list-inline pull-left">\
													<li><span class="jFiler-item-others">{{fi-icon}}</span></li>\
												</ul>\
												<ul class="list-inline pull-right">\
													<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
												</ul>\
											</div>\
										</div>\
									</div>\
								</li>',
					itemAppendToEnd: false,
					removeConfirmation: true
				},
				dragDrop: {
					dragEnter: null,
					dragLeave: null,
					drop: null,
				},
				addMore: false,
				clipBoardPaste: true,
				excludeName: null,
				beforeRender: null,
				afterRender: null,
				beforeShow: null,
				beforeSelect: null,
				onSelect: null,
				afterShow: null,
				onEmpty: null,
				options: null,
				captions: {
					button: "Elegir archivo",
					feedback: "Elegir archivo para subir",
					feedback2: "archivo elegido",
					drop: "Arrastrá un archivo para subirlo",
					removeConfirmation: "¿Está seguro de que desea descartar este archivo?",
					errors: {
						filesLimit: "Pueden subirse hasta {{fi-limit}} archivos.",
						filesSize: "{{fi-name}} excede el tamaño máximo de {{fi-maxSize}} MB.",
						filesSizeAll: "Los archivos elegidos exceden el tamaño máximo de {{fi-maxSize}} MB."
					}
				}
			});

			$('#convenioArchivo').filer({
				limit: 1,
				maxSize: null,
				extensions: null,
				changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Arrastrá tu archivo acá</h3> <span style="display:inline-block; margin: 15px 0">ó</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Seleccionar</a></div></div>',
				showThumbs: true,
				theme: "dragdropbox",
				templates: {
					box: '<ul class="jFiler-items-list jFiler-items-grid"></ul>',
					item: '<li class="jFiler-item">\
								<div class="jFiler-item-container">\
									<div class="jFiler-item-inner">\
										<div class="jFiler-item-assets jFiler-row" style="margin-top:0px;">\
											<ul class="list-inline pull-right">\
												<li><span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span></li>\
												<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
											</ul>\
										</div>\
									</div>\
								</div>\
							</li>',
					itemAppend: '<li class="jFiler-item">\
									<div class="jFiler-item-container">\
										<div class="jFiler-item-inner">\
											<div class="jFiler-item-thumb">\
												<div class="jFiler-item-status"></div>\
												<div class="jFiler-item-info">\
													<span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
													<span class="jFiler-item-others">{{fi-size2}}</span>\
												</div>\
												{{fi-image}}\
											</div>\
											<div class="jFiler-item-assets jFiler-row">\
												<ul class="list-inline pull-left">\
													<li><span class="jFiler-item-others">{{fi-icon}}</span></li>\
												</ul>\
												<ul class="list-inline pull-right">\
													<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
												</ul>\
											</div>\
										</div>\
									</div>\
								</li>',
					itemAppendToEnd: false,
					removeConfirmation: true
				},
				dragDrop: {
					dragEnter: null,
					dragLeave: null,
					drop: null,
				},
				addMore: false,
				clipBoardPaste: true,
				excludeName: null,
				beforeRender: null,
				afterRender: null,
				beforeShow: null,
				beforeSelect: null,
				onSelect: null,
				afterShow: null,
				onEmpty: null,
				options: null,
				captions: {
					button: "Elegir archivo",
					feedback: "Elegir archivo para subir",
					feedback2: "archivo elegido",
					drop: "Arrastrá un archivo para subirlo",
					removeConfirmation: "¿Está seguro de que desea descartar este archivo?",
					errors: {
						filesLimit: "Pueden subirse hasta {{fi-limit}} archivos.",
						filesSize: "{{fi-name}} excede el tamaño máximo de {{fi-maxSize}} MB.",
						filesSizeAll: "Los archivos elegidos exceden el tamaño máximo de {{fi-maxSize}} MB."
					}
				}
			});

			$('#modalVepArchivo').filer({
				limit: 1,
				maxSize: null,
				extensions: null,
				changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Arrastrá tu archivo acá</h3> <span style="display:inline-block; margin: 15px 0">ó</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Seleccionar</a></div></div>',
				showThumbs: true,
				theme: "dragdropbox",
				templates: {
					box: '<ul class="jFiler-items-list jFiler-items-grid"></ul>',
					item: '<li class="jFiler-item">\
								<div class="jFiler-item-container">\
									<div class="jFiler-item-inner">\
										<div class="jFiler-item-assets jFiler-row" style="margin-top:0px;">\
											<ul class="list-inline pull-right">\
												<li><span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span></li>\
												<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
											</ul>\
										</div>\
									</div>\
								</div>\
							</li>',
					itemAppend: '<li class="jFiler-item">\
									<div class="jFiler-item-container">\
										<div class="jFiler-item-inner">\
											<div class="jFiler-item-thumb">\
												<div class="jFiler-item-status"></div>\
												<div class="jFiler-item-info">\
													<span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
													<span class="jFiler-item-others">{{fi-size2}}</span>\
												</div>\
												{{fi-image}}\
											</div>\
											<div class="jFiler-item-assets jFiler-row">\
												<ul class="list-inline pull-left">\
													<li><span class="jFiler-item-others">{{fi-icon}}</span></li>\
												</ul>\
												<ul class="list-inline pull-right">\
													<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
												</ul>\
											</div>\
										</div>\
									</div>\
								</li>',
					itemAppendToEnd: false,
					removeConfirmation: true
				},
				dragDrop: {
					dragEnter: null,
					dragLeave: null,
					drop: null,
				},
				addMore: false,
				clipBoardPaste: true,
				excludeName: null,
				beforeRender: null,
				afterRender: null,
				beforeShow: null,
				beforeSelect: null,
				onSelect: null,
				afterShow: null,
				onEmpty: null,
				options: null,
				captions: {
					button: "Elegir archivo",
					feedback: "Elegir archivo para subir",
					feedback2: "archivo elegido",
					drop: "Arrastrá un archivo para subirlo",
					removeConfirmation: "¿Está seguro de que desea descartar este archivo?",
					errors: {
						filesLimit: "Pueden subirse hasta {{fi-limit}} archivos.",
						filesSize: "{{fi-name}} excede el tamaño máximo de {{fi-maxSize}} MB.",
						filesSizeAll: "Los archivos elegidos exceden el tamaño máximo de {{fi-maxSize}} MB."
					}
				}
			});
		}
				tablaMovimientoCuenta = $('#listMovimientoCuenta').DataTable({
					"ordering": true,
					"searching": true,
					"pageLength": 100,
					oLanguage: {
						sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
						sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
						sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
						sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay movimientos')}</a>",
						sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
						sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
						sInfoPostFix: "",
						sUrl: "",
						sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
						oPaginate: {
							"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
							"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
							"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
							"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
						}
					},
					aaSorting: [
						[1, 'desc']
					],
					aoColumnDefs: [{
						"aTargets": [0],
						'orderable': false,
						'className': 'select-checkbox',
						"mData": "selected"
					},{
						"aTargets": [1],
						'orderable': false,
						"mData": "id"
					}, {
						"aTargets": [2],
						'orderable': false,
						"mData": "fechaHora",
						"type": "date-eu"
					}, {
						"aTargets": [3],
						"mData": "tipo",
						'orderable': false,
						'sClass': 'bold'
					}, {
						"aTargets": [4],
						'orderable': false,
						"mRender": function (data, type, full) {
							return full.pagado ? '<i class="icofont icofont-ui-check"></i>' : '-';
						}
					}, {
						"aTargets": [5],
						'orderable': false,
						"mData": "importe",
						"sClass": "text-right"
					}, {
						"aTargets": [6],
						'orderable': false,
						"mData": "descripcionEstudio"
					}, {
						"aTargets": [7],
						'orderable': false,
						"mData": "saldo",
						"sClass": "text-right"
					}, {
						"aTargets": [8],
						'orderable': false,
						"mData": "responsable",
					}, {
						"aTargets": [9],
						"mData": "milisegundos",
						visible: false
					}],
					select: {
						style: 'multi',
						selector: 'td:first-child'
					},
					buttons: [
						$.extend(true, {}, buttonCommon, {
							extend: 'excelHtml5',
							exportOptions: {
								columns: [1, 2, 3, 4, 5, 6, 7, 8]
							},
							title: function () {
								var nombre = "Movimientos Cuenta Corrinete ";
								return nombre;
							}
						}),
						{
							extend: 'pdfHtml5',
							exportOptions: {
								columns: [1, 2, 3, 4, 5, 6, 7, 8]
							},
							orientation: 'landscape',
							title: function () {
								var nombre = "Movimientos Cuenta Corriente ";
								return nombre;
							}
						},
						{
							extend: 'copyHtml5',
							exportOptions: {
								columns: [1, 2, 3, 4, 5, 6, 7, 8]
							},
						}
					],
					sPaginationType: 'simple',
					sDom: "lBfrtip",
					fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
						if (aData['positivo']){
							const color = aData['tipo'] == 'Pago Reembolsado' ? "#CD6155" : "#b1c91e"
							$(nRow).css({
								"color": color,
								"font-weight": "bold"
							})
						}
						$(nRow).on('click', function () {
							// Despinto todas
							tablaMovimientoCuenta.rows().every(function (rowIdx, tableLoop, rowLoop) {
								$(this.node()).removeClass('resaltadoTabla');
							});
							// Pinto las que corresponden
							tablaMovimientoCuenta.rows(function (index, data, nodo) {
								return aData.movimientosRelacionados.includes(data.id);
							}).every(function (rowIdx, tableLoop, rowLoop) {
								$(this.node()).addClass('resaltadoTabla');
							});
							$(nRow).addClass('resaltadoTabla')
						});
					}
				});

				tablaMovimientoCuenta.on( 'user-select', function ( e, dt, type, cell, originalEvent ) {
					const data = dt.row( cell.index().row ).data();
					if (data.pagado) {
						e.preventDefault();
					}
				} );

				$("#preloaderMovimientos").show();
				$.ajax('${createLink(controller:"miCuenta", action:"ajaxGetMovimientosList")}', {
					dataType: "json",
					method: "POST",
					data: {
						"cuentaId": "${cuentaInstance.id}"
					}
				}).done(function (data) {
					$("#preloaderMovimientos").hide();
					for (key in data) {
						tablaMovimientoCuenta.row.add(data[key]);
					}
					tablaMovimientoCuenta.draw();
				});

				tablaFacturaCuenta = $('#listFacturasCuenta').DataTable({
					"ordering": true,
					"searching": true,
					oLanguage: {
						sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
						sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
						sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
						sZeroRecords: "${message(code: 'zifras.documento.FacturaCuenta.list.agregar', default: 'No hay Facturas de Cuentas')}</a>",
						sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
						sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
						sInfoPostFix: "",
						sUrl: "",
						sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
						oPaginate: {
							"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
							"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
							"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
							"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
						}
					},
					aaSorting: [
						[0, 'desc'],
						[4, 'desc']
					],
					aoColumnDefs: [{
						"aTargets": [0],
						"mData": "fecha",
						"type": "date-eu"
					}, {
						"aTargets": [1],
						"mData": "descripcion"
					}, {
						"aTargets": [2],
						"mData": "importe",
						"sClass": "text-right"
					},{
						"aTargets": [3],
						"mData": "cantidadAvisos"
					},{
						"aTargets": [4],
						"mData": "pagadaCheck"
					},{
						"aTargets": [5],
						"mData": "nombreArchivo",
						"mRender": function (data, type, full) {
							if (full['tipoArchivo'] == "pdf") {
								return '<i class="icofont icofont-file-pdf"></i>' + '   ' + data
							}
							else {
								if (full['tipoArchivo'] == "doc") {
									return '<i class="icofont-file-word"></i>' + '   ' + data
								}
								else {
									return '<i class="icofont icofont-file-text"></i>' + '   ' + data
								}
							}
						}
					},{
						"aTargets": [6],
						"mData": "responsable"
					}],
					sPaginationType: 'simple',
					fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
						// Row click
						$(nRow).on('click', function () {
							window.location.href = $('#urlEditFacturaCuenta').text() + '/' + aData['id'];
						});
					}
				});

				llenarDatoslistFacturasCuenta();

				tablaComprobantes = $('#listComprobantes').DataTable({
					"ordering": true,
					"searching": true,
					oLanguage: {
						sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
						sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
						sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
						sZeroRecords: "${message(code: 'zifras.documento.FacturaCuenta.list.agregar', default: 'No hay Comprobantes')}</a>",
						sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
						sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
						sInfoPostFix: "",
						sUrl: "",
						sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
						oPaginate: {
							"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
							"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
							"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
							"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
						}
					},
					aaSorting: [
						[2, 'desc']
					],
					aoColumnDefs: [{
						"aTargets": [0],
						'orderable': false,
						"mRender": function (data, type, full) {
							return '<i class="icofont icofont-trash" onclick="borrarComprobante(' + full['id'] + ')"></i>'
						}
					},{
						"aTargets": [1],
						"mData": "tipo"
					}, {
						"aTargets": [2],
						"mData": "fecha",
						"type": "date-eu"
					},{
						"aTargets": [3],
						"mData": "nombreArchivo",
						"mRender": function (data, type, full) {
							var icono;
							if (full['tipoArchivo'] == "pdf")
								icono = '<i class="icofont icofont-file-pdf"></i>'
							else if (full['tipoArchivo'] == "doc")
								icono = '<i class="icofont-file-word"></i>'
							else
								icono = '<i class="icofont icofont-file-text"></i>'
							return icono + "   <a href=/comprobante/descargarComprobante/" + full.id + ">" + data + "</a>"
						}
					}],
					sPaginationType: 'simple',
					fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
						// Row click
						$(nRow).on('click', function () {
							//window.location.href = $('#urlShowComprobante').text() + '/' + aData['id'];
						});
					}
				});

				llenarDatoslistComprobantes();

				$("#cbTipoComprobante").select2({
					placeholder: 'Tipo Comprobante',
					formatNoMatches: function() {
						return 'No hay comprobantes';
					},
					formatSearching: function() {
						return 'Buscando...';
					},
					minimumResultsForSearch: 1,
					formatSelection: function(item) {
						return item.text;
					}
				});
				
				llenarCombo({
					comboId : "cbTipoComprobante",
					ajaxUrlDiv : 'urlGetTiposComprobante'
				});

				tablaVeps = $('#listVeps').DataTable({
					"ordering": true,
					"searching": true,
					oLanguage: {
						sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
						sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
						sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
						sZeroRecords: "${message(code: 'zifras.documento.FacturaCuenta.list.agregar', default: 'No hay VEPs')}</a>",
						sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
						sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
						sInfoPostFix: "",
						sUrl: "",
						sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
						oPaginate: {
							"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
							"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
							"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
							"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
						}
					},
					aaSorting: [
						[0, 'desc']
					],
					aoColumnDefs: [{
						"aTargets": [0],
						"mData": "fechaEmision",
						"type": "date-eu"
					}, {
						"aTargets": [1],
						"mData": "numero"
					}, {
						"aTargets": [2],
						"mData": "importe",
						"sClass": "text-right"
					},{
						"aTargets": [3],
						"mData": "descripcion"
					},{
						"aTargets": [4],
						"mData": "tipo"
					},{
						"aTargets": [5],
						"mData": "nombreArchivo",
						"mRender": function (data, type, full) {
							var icono;
							if (full['tipoArchivo'] == "pdf")
								icono = '<i class="icofont icofont-file-pdf"></i>'
							else if (full['tipoArchivo'] == "doc")
								icono = '<i class="icofont-file-word"></i>'
							else
								icono = '<i class="icofont icofont-file-text"></i>'
							return icono + "   <a href=/vep/download/" + full.id + ">" + data + "</a>"
						}
					}],
					sPaginationType: 'simple',
					fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
						// Row click
						$(nRow).on('click', function () {
							window.location.href = $('#urlShowVep').text() + '/' + aData['id'];
						});
					}
				});

				llenarDatoslistVeps();

				$('#comprobante_importar').filer({
					uploadFile: {
						url: $('#urlImportarComprobante').text(), //URL to which the request is sent {String}
						type: 'POST', //The type of request {String}
						data:{
							tipoComprobante: varCbTipoComprobante,
							cuentaId:"${cuentaInstance.id}"
						},
						enctype: 'multipart/form-data', //Request enctype {String}
						synchron: true,
						beforeSend: function(){
							if (banderaBeforeSend){
								banderaBeforeSend = false;
								$('#modalImportarComprobante').modal('hide');
							}
						},
						success: function(resultado){
							console.log(resultado);
							console.log(resultado[0]);
						},
						onProgress: function(data){
							// Barra de porcentaje de subida de archivo
						},
						onComplete: function(){
							llenarDatoslistComprobantes();
							$("#comprobante_importar").prop("jFiler").reset();
							banderaBeforeSend = true;
						}
					},
					limit: null,
					maxSize: null,
					extensions: null,
					changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Arrastrá los archivos acá</h3> <span style="display:inline-block; margin: 15px 0">ó</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Seleccionar archivos</a></div></div>',
					showThumbs: true,
					theme: "dragdropbox",
					templates: {
						box: '<ul class="jFiler-items-list jFiler-items-grid"></ul>',
						item: '<li class="jFiler-item">\
									<div class="jFiler-item-container">\
										<div class="jFiler-item-inner">\
											<div class="jFiler-item-assets jFiler-row" style="margin-top:0px;">\
												<ul class="list-inline pull-right">\
													<li><span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span></li>\
													<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
												</ul>\
											</div>\
										</div>\
									</div>\
								</li>',
						itemAppend: '<li class="jFiler-item">\
										<div class="jFiler-item-container">\
											<div class="jFiler-item-inner">\
												<div class="jFiler-item-thumb">\
													<div class="jFiler-item-status"></div>\
													<div class="jFiler-item-info">\
														<span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
														<span class="jFiler-item-others">{{fi-size2}}</span>\
													</div>\
													{{fi-image}}\
												</div>\
												<div class="jFiler-item-assets jFiler-row">\
													<ul class="list-inline pull-left">\
														<li><span class="jFiler-item-others">{{fi-icon}}</span></li>\
													</ul>\
													<ul class="list-inline pull-right">\
														<li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
													</ul>\
												</div>\
											</div>\
										</div>\
									</li>',
						itemAppendToEnd: false,
						removeConfirmation: true
					},
					dragDrop: {
						dragEnter: null,
						dragLeave: null,
						drop: null,
					},
					addMore: false,
					clipBoardPaste: true,
					excludeName: null,
					beforeRender: null,
					afterRender: null,
					beforeShow: null,
					beforeSelect: null,
					onSelect: null,
					afterShow: null,
					onEmpty: null,
					options: null,
					captions: {
						button: "Elegir archivos",
						feedback: "Elegir archivos para subir",
						feedback2: "archivos elegidos",
						drop: "Arrastrá un archivo para subirlo",
						removeConfirmation: "¿Está seguro de que desea descartar este archivo?",
						errors: {
							filesLimit: "Pueden subirse hasta {{fi-limit}} archivos.",
							filesSize: "{{fi-name}} excede el tamaño máximo de {{fi-maxSize}} MB.",
							filesSizeAll: "Los archivos elegidos exceden el tamaño máximo de {{fi-maxSize}} MB."
						}
					}
				});

		document.getElementById("btnNotificarMonotributo").onclick = function(){
			swal({
				title: "¿Estás seguro/a?",
				text: "Se notificará al usuario que ya tiene su Monotributo realizado",
				type: "warning",
				showCancelButton: true,
				confirmButtonClass: "btn-danger",
				confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, notificar'/>",
				cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
				closeOnConfirm: true,
				closeOnCancel: true
			},
			function(isConfirm) {
				if (isConfirm) {
					notificarMonotributo();
				}
			});

		}
	});

	$(".txtAno").dateDropper({
		dropWidth: 200,
		dropPrimaryColor: "#1abc9c",
		dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "Y",
		minYear: 2010,
		maxYear: 2040,
		lang: "es"
	});

	$(".txtAno").change(function () {
		$(".txtAno").val(this.value)
		llenarDatoslistLiquidacionesIva();
		llenarDatoslistLiquidacionesIIBB();
		llenarDatoslistImportacionesFacturas();
		llenarDatoslistFacturacionAnual();
	});

	$(".fechaDateDropper").dateDropper({
		dropWidth: 200,
		dropPrimaryColor: "#1abc9c",
		dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "d/m/Y",
		lang: "es"
	});

	function llenarDatoslistDeclaracionesJuradas() {
		$.ajax($('#urlGetDeclaracionesJuradas').text(), {
			dataType: "json",
			data: {
				cuentaId: "${cuentaInstance?.id}"
			}
		}).done(function (data) {
			for (key in data) {
				tablaDDJJ.row.add(data[key]);
			}
			tablaDDJJ.draw();
		});
	}

	function llenarDatoslistFacturasCuenta() {
		tablaFacturaCuenta.clear().draw();
		$.ajax($('#urlGetFacturasCuentaList').text(), {
			dataType: "json",
			data: {
				id: "${cuentaInstance?.id}"
			}
		}).done(function (data) {
			for (key in data) {
				tablaFacturaCuenta.row.add(data[key]);
			}
			tablaFacturaCuenta.draw();
		});
	}

	function llenarDatoslistComprobantes() {
		tablaComprobantes.clear().draw();
		$.ajax($('#urlGetComprobantes').text(), {
			dataType: "json",
			data: {
				cuentaId: "${cuentaInstance?.id}"
			}
		}).done(function (data) {
			for (key in data){
				tablaComprobantes.row.add(data[key]);
			}
			tablaComprobantes.draw();
		});
	}

	function llenarDatoslistVeps() {
		tablaVeps.clear().draw();
		$.ajax($('#urlGetVeps').text(), {
			dataType: "json",
			data: {
				cuentaId: "${cuentaInstance?.id}"
			}
		}).done(function (data) {
			for (key in data) {
				tablaVeps.row.add(data[key]);
			}
			tablaVeps.draw();
		});
	}

	function llenarDatoslistLiquidacionesIva() {
		var ano = $("#ano").val();
		tablaIva.clear().draw();
		$("#preloaderIva").show();
		$("#divListIva").hide();
		$.ajax($('#urlGetLiquidacionesIvaCuentaList').text(), {
			dataType: "json",
			data: {
				cuentaId: '${cuentaInstance?.id}',
				ano: ano
			}
		}).done(function (data) {
			$("#preloaderIva").hide();
			$("#divListIva").show();
			for (key in data) {
				tablaIva.row.add(data[key]);
			}
			tablaIva.draw();
		});
	}

	function llenarDatoslistLiquidacionesIIBB() {
		var ano = $("#ano").val();
		$("#preloaderIIBB").show();
		$("#divListIIBB").hide();
		$.ajax($('#urlGetLiquidacionesIibbCuentaList').text(), {
			dataType: "json",
			data: {
				cuentaId: '${cuentaInstance?.id}',
				ano: ano
			}
		}).done(function (data) {
			datosIIBB = data;
			$("#mesIIBB").trigger('change')
			$("#preloaderIIBB").hide();
			$("#divListIIBB").show();
		});
	}

	function llenarDatoslistVolantesPago(){
		tablaVolantes.clear().draw();
		$.ajax($('#urlGetVolantesPago').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			for(key in data){
				tablaVolantes.row.add(data[key]);
			}
			tablaVolantes.draw();
		});
	}

	function llenarDatoslistLiquidacionesGanancia() {
		var ano = $("#ano").val();
		tablaGanancia.clear().draw();
		$("#preloaderGanancia").show();
		$("#divListGanancia").hide();
		$.ajax($('#urlGetLiquidacionesGananciaCuentaList').text(), {
			dataType: "json",
			method: "POST",
			data: {
				cuentaId: '${cuentaInstance?.id}'
			}
		}).done(function (data) {
			$("#preloaderGanancia").hide();
			$("#divListGanancia").show();
			for (key in data) {
				tablaGanancia.row.add(data[key]);
			}
			tablaGanancia.draw();
		});
	}

	function llenarDatoslistImportacionesFacturas() {
		var ano = $("#ano").val();
		var cuentaId = ${cuentaInstance?.id};
		var url;
		tablaEstadoImportaciones.clear().draw();
		$("#preloaderImportaciones").show();
		$("#divListImportaciones").hide();
		$.ajax($('#urlGetListaImportacionesPorCuenta').text(), {
			dataType: "json",
			data: {
				ano: ano,
				cuentaId: cuentaId
			}
		}).done(function (data) {
			$("#preloaderImportaciones").hide();
			$("#divListImportaciones").show();
			for (key in data) {
				tablaEstadoImportaciones.row.add(data[key]);
			}
			tablaEstadoImportaciones.draw();
		});
	}

	function llenarDatoslistFacturacionAnual() {
		tablaFacturacion.clear().draw();
		// $("#preloaderImportaciones").show();
		// $("#divListImportaciones").hide();
		$.ajax("${createLink(controller: 'facturaVenta', action: 'ajaxObtenerFacturacionAnual')}", {
			dataType: "json",
			data: {
				ano: $("#ano").val(),
				cuentaId: ${cuentaInstance?.id}
			}
		}).done(function (data) {
			// $("#preloaderImportaciones").hide();
			// $("#divListImportaciones").show();
			for (key in data) {
				tablaFacturacion.row.add(data[key]);
			}
			tablaFacturacion.draw();
		});
	}

	function borrarElementoListaIVA(idRecibido) {
		swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
			text: "<g:message code='zifras.liquidacionGanancia.LiquidacionGanancia.delete.message' default='La liquidación se eliminará'/>",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, eliminar'/>",
			cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		}, function () {
			$.ajax($('#urlDeleteIVA').text(), {
				dataType: "json",
				data: {
					id: idRecibido,
				}
			}).done(function (data) {
				llenarDatoslistLiquidacionesIva();
			});
		});
	}

	function borrarElementoListaIIBB(idRecibido) {
		swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
			text: "<g:message code='zifras.liquidacionGanancia.LiquidacionGanancia.delete.message' default='La liquidación se eliminará'/>",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, eliminar'/>",
			cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		}, function () {
			$.ajax($('#urlDeleteIIBB').text(), {
				dataType: "json",
				data: {
					id: idRecibido,
				}
			}).done(function (data) {
				llenarDatoslistLiquidacionesIIBB();
			});
		});
	}

	function borrarElementoListaGanancia(idRecibido) {
		swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
			text: "<g:message code='zifras.liquidacionGanancia.LiquidacionGanancia.delete.message' default='La liquidación se eliminará'/>",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, eliminar'/>",
			cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		}, function () {
			$.ajax($('#urlDeleteGanancia').text(), {
				dataType: "json",
				data: {
					id: idRecibido,
				}
			}).done(function (data) {
				llenarDatoslistLiquidacionesGanancia();
			});
		});
	}

	function borrarComprobante(id) {
		swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
			text: "El comprobante se eliminará definitivamente.",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, eliminar'/>",
			cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		},
		function(isConfirm) {
			if (isConfirm) {
				window.location.href = "${createLink(controller:'comprobante', action:'eliminar')}" + '/' + id
			}
		});
	}

	function reenviarMailBienvenida() {
		swal({
			title: "¿Volver a enviar mail de bienvenida?",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.ok' default='Sí'/>",
			cancelButtonText: "<g:message code='zifras.cancel' default='No'/>",
			closeOnConfirm: false,
			closeOnCancel: false
		}, function () {
			$.ajax("${createLink(action: 'ajaxReenviarMailBienvenida')}", {
				dataType: "json",
				data: {
					'cuentaId': '${cuentaInstance?.id}',
				}
			}).done(function (data) {
				swal({
					title: "Mail enviado",
					type: "success"
				}, function () {
					$.ajax("${createLink(action: 'reenviarMailBienvenida')}", {
						dataType: "json",
						data: {
							'cuentaId': '${cuentaInstance?.id}',
						}
					}).done(function (data) {
						swal()
					});
				})
			});
		});
	}

	function activacionManual() {
		window.location.href = '${raw(createLink(action: "activacionManual", params:["cuentaId": cuentaInstance.id, "cuit":"VARIABLECUIT"]))}'.replace("VARIABLECUIT", $("#modalIngresarCuit_cuit").val());
	}

	function cambiarBooleanoPasos(nombreBooleano) {
		$.ajax("${createLink(action: 'ajaxCambiarBooleanoPasos')}", {
			dataType: "json",
			data: {
				'cuentaId': '${cuentaInstance?.id}',
				'nombreBooleano': nombreBooleano
			}
		});
	}

	function cambiarEtiqueta(nuevoColor) {
		const url = '${raw(createLink(action: "cambiarEtiqueta", params:["cuentaId": cuentaInstance.id, "color":"VARIABLECOLOR"]))}'
		window.location.href = url.replace("VARIABLECOLOR", nuevoColor)
	}

	function notificarMonotributo(){
		$.ajax('${createLink(controller:"notificacion",action:"ajaxNotificarMonotributo")}', {
			dataType: "json",
			data: {
				cuentaId: "${cuentaInstance.id}"
			}
		}).done(function(data) {
			if(data.error)
				setTimeout(function() {
					swal("Error","Ocurrió un error notificando al usuario","error");
				},400);
			else{
				setTimeout(function() {
					swal({
						title: "Éxito!",
						text: "Usuario notificado correctamente!",
						type: "success",
						showCancelButton: false,
						confirmButtonClass: "btn-primary",
						confirmButtonText: "Aceptar",
						closeOnConfirm: true
					},
					function(isConfirm) {
						if (isConfirm) {
						}
					});
				},400);
			}
		});
	}

	function ajustarConvenioArchivo(mes, ano) {
		$("#convenioMes").val(mes)
		$("#convenioAno").val(ano)
		$('#modalAjusteConvenio').modal('show');
	}

	function showModalDDJJ(tipo, id, provincia, mes, ano) {
		$("#liquidacionId").val(id);
		const tipoExtendido = tipo == "Ganancia" ? "Ganancias" : tipo == "Iva" ? "IVA" : "Ingresos Brutos";
		$("#modalDdjjDescripcion").val(tipoExtendido + " " + (provincia ? provincia + " " : '') + mes + "/" + ano)
		$("#modalDdjjTitulo").text("Presentar " + tipoExtendido);
		$('#modalPresentarDDJJ').modal('show');
		$('#declaracionForm')[0].action = '${createLink(controller: "declaracionJurada", action:"VARIABLEACTION")}'.replace("VARIABLEACTION", "savePorLiquidacion" + tipo); //Cambio a dónde redirige el form según el tipo de liquidación
	}

	function showModalVepDDJJ(iva, id) {
		$("#liqId").val(id);
		$("#esIva").val(iva);
		$('#modalDDJJVep').modal('show');
	}

	function obtenerDatosAfip() {
		$.ajax("${createLink(action: 'ajaxObtenerDatosAfip')}", {
			dataType: "json",
			data: {
				'cuit': $("#modalIngresarCuit_cuit").val()
			}
		}).done(function (respuesta) {
			if (respuesta.hasOwnProperty('error'))
				swal("Error", respuesta.error, "error");
			else {
				if (respuesta.idExistente && respuesta.idExistente != ${cuentaInstance.id}){
					swal("Error", "Ya existe una cuenta (ID " + respuesta.idExistente + ") con ese CUIT.", "error");
					return
				}
				$("#modalDatosAfip_razonSocial").text(respuesta.razonSocial);
				$("#modalDatosAfip_tipo").text(respuesta.tipo);
				$("#modalDatosAfip_domicilio").text(respuesta.domicilio);
				$("#modalDatosAfip_actividad").text(respuesta.actividad);
				if (respuesta.categoria)
					$("#modalDatosAfip_categoriaTr").show()
				else
					$("#modalDatosAfip_categoriaTr").hide()
				$("#modalDatosAfip_categoria").text(respuesta.categoria);
				$("#modalDatosAfip_localidad").text(respuesta.localidad);
				$("#modalDatosAfip_impuestos").text(respuesta.tipoIva);
				if (respuesta.impuestos)
					$("#modalDatosAfip_impuestos").text($("#modalDatosAfip_impuestos").text() + respuesta.impuestos.replace(/<br\/>/g, "\n"));
				$('#modalIngresarCuit').modal('hide');
				$('#modalDatosAfip').modal('show');
			}
		});
	}

	function cancelarPago(id){ // Esta función es llamada desde los items de la lista MovimientoCuenta, que se construyen junto al ID desde el JsonInicialización
		swal({
			title: "¿Cancelar pago?",
			text: "Todos los movimientos relacionados pasarán a estar impagos, y se eliminará el movimiento positivo.",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.generar.ok' default='Sí'/>",
			cancelButtonText: "<g:message code='zifras.generar.cancel' default='No'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		},
		function(isConfirm) {
			if (isConfirm)
				window.location.href = "${createLink(controller:'pagoCuenta', action:'cancelar')}/" + id
		})
	}

	function acreditarPago(id){ // Esta función es llamada desde los items de la lista MovimientoCuenta, que se construyen junto al ID desde el JsonInicialización
		swal({
			title: "¿Acreditar pago?",
			text: "Se generarán movimientos, se enviarán mails internos y si algún movimiento cumple las condiciones se lo facturará.",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.generar.ok' default='Sí'/>",
			cancelButtonText: "<g:message code='zifras.generar.cancel' default='No'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		},
		function(isConfirm) {
			if (isConfirm)
				window.location.href = "${createLink(controller:'pagoCuenta', action:'pagarAMano')}/" + id
		})
	}

	function generarPagoManual(){
		let total = 0;
		let listaIds = [];
		for(i=0; i < tablaMovimientoCuenta.rows('.selected').data().length ; i++){
			const data = tablaMovimientoCuenta.rows('.selected').data()[i];
			total+=parseFloat(data.importe.replace(".", "").replace(",", "."));
			listaIds.push(data.id);
		}
		if (total == 0){
			swal("Debe seleccionar los movimientos a cancelar", "El importe del pago es 0.", "error");
			return
		}
		swal({
			title: "¿Generar movimiento positivo?",
			text: 'La suma total de los ' + listaIds.length + ' movimientos a cancelar es de \$' + total.toFixed(2).replace(".", ","),
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.generar.ok' default='Si, generar'/>",
			cancelButtonText: "<g:message code='zifras.generar.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		},
		function(isConfirm) {
			if (isConfirm){
				const urlBase = "${raw(createLink(controller: 'pagoCuenta', action: 'createManual', params:['cuentaId':cuentaInstance.id, 'movimientos': 'variableListaIds']))}"
				window.location.href = urlBase.replace('variableListaIds', escape(listaIds));
			}
		});
	}



	function notificarLiq(mes, ano, iva){
		swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
			text: "<g:message code='zifras.liquidacion.notificaciones.message' default='Se enviarán las notificaciones de liquidación lista a los usuarios'/>",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.enviar.ok' default='Si, enviar'/>",
			cancelButtonText: "<g:message code='zifras.enviar.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		},
		function(isConfirm) {
			if (isConfirm){
				const linkIva = "${createLink(controller:'liquidacionIva', action: 'ajaxEnviarNotificaciones')}"
				const linkIibb = "${createLink(controller:'liquidacionIibb', action: 'ajaxEnviarNotificaciones')}"
				$.ajax((iva ? linkIva : linkIibb), {
					dataType: "json",
					method: "POST",
					data: {
						ano: ano,
						mes: mes,
						cuentasIds: "${cuentaInstance.id}"
					}
				}).done(function(data) {					
					swal("Notificaciones enviadas!", "El cliente ha recibido el mail correspondiente.", "success");
					if (iva)
						llenarDatoslistLiquidacionesIva();
					else
						llenarDatoslistLiquidacionesIIBB();
				});
			}
		})
	}

	function notificarError(){
		$.ajax('${createLink(controller:"notificacion",action:"ajaxNotificarErrorUsuario")}', {
			dataType: "json",
			data: {
				fotos: $("#checkFotos").is(":checked"),
				claveFiscal: $("#checkClaveFiscal").is(":checked"),
				direccion: $("#checkDireccion").is(":checked"),
				codigoPostal: $("#checkCodigoPostal").is(":checked"),
				cuentaId: "${cuentaInstance.id}"
			}
		}).done(function(data) {
			$("#modalNotificarError").modal("hide");
			if(data.error)
				swal("Error","Ocurrió un error notificando al usuario","error");
			else{
				swal({
					title: "Éxito!",
					text: "Error/es notificados correctamente!",
					type: "success",
					showCancelButton: false,
					confirmButtonClass: "btn-primary",
					confirmButtonText: "Aceptar",
					closeOnConfirm: true
				},
				function(isConfirm) {
					if (isConfirm) {
						console.log("Aceptado");
					}
				});
			}
		});
	}

</script>
</body>
</html>
