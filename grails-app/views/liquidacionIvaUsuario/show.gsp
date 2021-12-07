<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page body start -->
		<div class="page-body">
			<div class="page-header card">
				<div class="row align-items-end">
					<div class="col-lg-12">
						<div class="page-header-title">
							<div class="d-inline">
								<h4>Período ${liquidacionIvaInstance?.fecha.toString('MMMM YYYY')}</h4>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<!-- Sho Map Start -->
				<div class="col-md-6">
					<div class="card widget-statstic-card">
						<div class="card-header">
							<div class="card-header-left">
								<h4>Liquidación IVA</h4>
								<h6 class="p-t-10 m-b-0 text-c-blue">Impuesto al Valor Agregado</h6>
							</div>
						</div>
						<div class="card-block">
							<g:if test="${liquidacionIvaInstance?.estadoUsuario == 'Presentada'}">
								<i class="ti-check st-icon bg-c-green"></i>
							</g:if>
							<g:else>
								<i class="ti-more-alt st-icon bg-c-blue"></i>
							</g:else>
							<div class="text-left">
								<h3 class="d-inline-block">${(liquidacionIvaInstance?.estadoUsuario == 'Sin liquidar') ? "-" : formatNumber(number: liquidacionIvaInstance?.saldoDdjj, type:'currency', currencySymbol:'$')}</h3>
							</div>
                        </div>
						
						<div class="row">
							<div class="col-md-12">
								<table class="table table-striped table-framed" style="text-align:right;width: 100%;margin-bottom:0px!important;">
									<tbody>
										<tr>
											<td style="text-align:left;">IVA Ventas</td>
											<td>
												<div class=""><i class="ti-plus"></i> ${formatNumber(number: liquidacionIvaInstance?.debitoFiscal, , type:'currency', currencySymbol:'$')}</div>
											</td>
										</tr>
										<tr>
											<td style="text-align:left;">IVA Compras</td>
											<td>
												<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIvaInstance?.creditoFiscal, , type:'currency', currencySymbol:'$')}</div>
											</td>
										</tr>
										<g:if test="${liquidacionIvaInstance?.saldoTecnicoAFavorPeriodoAnterior!=null}">
										<tr>
											<td style="text-align:left;"><g:message code="zifras.liquidacion.LiquidacionIva.saldoTecnicoAFavorPeriodoAnterior.label" default="A favor período ant." /></td>
											<td>
												<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIvaInstance?.saldoTecnicoAFavorPeriodoAnterior, , type:'currency', currencySymbol:'$')}</div>
											</td>
										</tr>
										</g:if>
										<g:if test="${liquidacionIvaInstance?.saldoTecnicoAFavor!=null}">
										<tr>
											<td style="text-align:left;"><g:message code="zifras.liquidacion.LiquidacionIva.saldoTecnicoAFavor.label" default="A favor período" /></td>
											<td>
												<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIvaInstance?.saldoTecnicoAFavor, , type:'currency', currencySymbol:'$')}</div>
											</td>
										</tr>
										</g:if>

										<g:if test="${liquidacionIvaInstance?.retencion!=null}">
										<tr>
											<td style="text-align:left;"><g:message code="zifras.liquidacion.LiquidacionIva.retencion.label" default="Retenciones" />
											</td>
											<td>
												<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIvaInstance?.retencion, , type:'currency', currencySymbol:'$')}</div>
											</td>
										</tr>
										</g:if>
										<g:if test="${liquidacionIvaInstance?.percepcion!=null}">
										<tr>
											<td style="text-align:left;"><g:message code="zifras.liquidacion.LiquidacionIva.percepcion.label" default="Percepciones" /></td>
											<td>
												<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIvaInstance?.percepcion, , type:'currency', currencySymbol:'$')}</div>
											</td>
										</tr>
										</g:if>
										<g:if test="${liquidacionIvaInstance?.saldoLibreDisponibilidad!=null}">
										<tr>
											<td style="text-align:left;"><g:message code="zifras.liquidacion.LiquidacionIva.saldoLibreDisponibilidad.label" default="Saldo libre disp." /></td>
											<td>
												<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIvaInstance?.saldoLibreDisponibilidad, , type:'currency', currencySymbol:'$')}</div>
											</td>
										</tr>
										</g:if>
										<g:if test="${liquidacionIvaInstance?.saldoLibreDisponibilidadPeriodoAnterior!=null}">
										<tr>
											<td style="text-align:left;"><g:message code="zifras.liquidacion.LiquidacionIva.saldoLibreDisponibilidadPeriodoAnterior.label" default="Saldo libre disp. ant." /></td>
											<td>
												<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIvaInstance?.saldoLibreDisponibilidadPeriodoAnterior, , type:'currency', currencySymbol:'$')}</div>
											</td>
										</tr>
										</g:if>

										<g:if test="${liquidacionIvaInstance?.saldoDdjj!=null}">
										<tr>
											<td style="text-align:left;"><g:message code="zifras.liquidacion.LiquidacionIva.saldoDdjj.label" default="Saldo a pagar" /></td>
											<td>
												<div class="f-w-700"><i class="ti-line-double"></i> ${formatNumber(number: liquidacionIvaInstance?.saldoDdjj, , type:'currency', currencySymbol:'$')}</div>
											</td>
										</tr>
										</g:if>
									</tbody>
								</table>
							</div>
							
							<g:if test="${(liquidacionIvaInstance?.nota!=null)}">
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Nota</h4>
									<div class="row">
										<div class="col-md-12">
											<div class="row">
												<div class="col-2">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.nota.label" default="Nota" /></h6>
												</div>
												<div class="col-10">
													<h6 class="m-b-30">${liquidacionIvaInstance?.nota}</h6>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							</g:if>
						</div>

						<div class="b-t-default">
							<div class="row m-0">
								<a href="#!" id="btn-presentar-iva" style="${(liquidacionIvaInstance?.estadoUsuario != 'Liquidado') ? 'display: none;' : ''}" class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar"><!-- Siempre se crea el botón para evitar errores, pero si es estado es diferente a liquidado lo ocultamos para que no puedan interactuar con él. -->
								<p class="m-0 text-uppercase d-inline-block">Autorizar</p>
							</a>
							<g:if test="${liquidacionIvaInstance?.estadoUsuario == 'Presentada'}">
								<div class="col-12 text-center p-t-15 p-b-15 btn-presentar ok" style="font-weight: 600;">
									<p class="m-0 text-uppercase d-inline-block">Presentada</p>
									<i class="icon-emotsmile"></i>
								</div>
							</g:if>
							<g:elseif test="${liquidacionIvaInstance?.estadoUsuario == 'Autorizada' || liquidacionIvaInstance?.estadoUsuario == 'Sin liquidar'}">
								<div class="col-12 text-center p-t-15 p-b-15 btn-presentar" style="font-weight: 600;">
									<p class="m-0 text-uppercase d-inline-block">${(liquidacionIvaInstance?.estadoUsuario == 'Autorizada') ? "Pendiente" : "Sin liquidar"}</p>
								</div>
							</g:elseif>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function () {
	// Presentar IVA:
	document.querySelector('#btn-presentar-iva').onclick = function(){
		swal({
				title: "<g:message code='default.button.autorizar.confirm.message' default='¿Estás seguro que desea autorizar la presentación de IVA?'/>",
				text: '${"Total: " + formatNumber(number: liquidacionIvaInstance?.saldoDdjj, type:"currency", currencySymbol:"\$")}',
				type: "warning",
				showCancelButton: true,
				confirmButtonClass: "btn-danger",
				confirmButtonText: "<g:message code='zifras.presentar.ok' default='Si, autorizar'/>",
				cancelButtonText: "<g:message code='zifras.presentar.cancel' default='No, cancelar'/>",
				closeOnConfirm: true,
				closeOnCancel: true
			},
			function(isConfirm) {
				if (isConfirm) {
					window.location.href = "${raw( createLink(controller:'notificacion', action: 'autorizarLiquidaciones', params:[uId: userId, cId:liquidacionIvaInstance.cuenta.id, mes:liquidacionIvaInstance.fecha.toString('MM'), ano:liquidacionIvaInstance.fecha.toString('YYYY')]) )}";
				}
			});
		};
});
</script>
</body>
</html>