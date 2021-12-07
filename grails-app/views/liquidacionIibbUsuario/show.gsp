<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlDelete">
		<g:createLink controller="liquidacionIibb" action="delete" />
	</div>
	<div id="urlGetAlicuotas">
		<g:createLink controller="liquidacionIibb" action="ajaxGetAlicuotas" />
	</div>
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page body start -->
		<!div class="page-body">
			<div class="page-header card">
				<div class="row align-items-end">
					<div class="col-lg-12">
						<div class="page-header-title">
							<div class="d-inline">
								<h4>Período ${mes} / ${ano}</h4>
							</div>
						</div>
					</div>
				</div>
			</div>
			<g:each var="liquidacionIIBBInstance" in="${liquidacionesBuscadas}">
			<div class="row">
				<!-- Sho Map Start -->
				<div class="col-md-7">
					<div class="card widget-statstic-card">
						<div class="card-header">
							<div class="card-header-left">
								<h4>Liquidación IIBB</h4>
								<h6 class="p-t-10 m-b-0 text-c-blue">Ingresos Brutos</h6>
							</div>
						</div>
						<div class="card-block">
							<g:if test="${liquidacionIIBBInstance?.estadoUsuario == 'Presentada'}">
								<i class="ti-check st-icon bg-c-green"></i>
							</g:if>
							<g:else>
								<i class="ti-more-alt st-icon bg-c-blue"></i>
							</g:else>
							<div class="text-left">
							<h3 class="d-inline-block">${(liquidacionIIBBInstance?.estadoUsuario == 'Sin liquidar') ? "-" : formatNumber(number: liquidacionIIBBInstance?.saldoDdjj, type:'currency', currencySymbol:'$')}</h3>
							</div>
						</div>

						<div class="row">
							<div class="col-md-12">
									<table class="table table-striped table-framed" style="text-align:right;">
										<thead>
											<tr>
												<th></th>
												<th style="text-align:right;">${liquidacionIIBBInstance?.provincia?.nombre}</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td style="text-align:left;">Neto</td>
												<td>
													<div class="">${formatNumber(number: liquidacionIIBBInstance?.neto, , type:'currency', currencySymbol:'$')}</div>
												</td>
											</tr>
											<tr>
												<td style="text-align:left;">Impuesto</td>
												<td>
													<div class=""><i class="ti-plus"></i> ${formatNumber(number: liquidacionIIBBInstance?.impuesto, , type:'currency', currencySymbol:'$')}</div>
												</td>
											</tr>
											<g:if test="${liquidacionIIBBInstance?.retencion!=null}">
											<tr>
												<td style="text-align:left;">Retenciones</td>
												<td>
													<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIIBBInstance?.retencion, , type:'currency', currencySymbol:'$')}</div>
												</td>
											</tr>
											</g:if>
											<g:if test="${liquidacionIIBBInstance?.percepcion!=null}">
											<tr>
												<td style="text-align:left;">Percepciones</td>
												<td>
													<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIIBBInstance?.percepcion, , type:'currency', currencySymbol:'$')}</div>
												</td>
											</tr>
											</g:if>
											<g:if test="${liquidacionIIBBInstance?.sircreb!=null}">
											<tr>
												<td style="text-align:left;">Sircreb</td>
												<td>
													<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIIBBInstance?.sircreb, , type:'currency', currencySymbol:'$')}</div>
												</td>
											</tr>
											</g:if>
											<g:if test="${liquidacionIIBBInstance?.saldoAFavorPeriodoAnterior!=null}">
											<tr>
												<td style="text-align:left;">Saldo a favor anterior</td>
												<td>
													<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIIBBInstance?.saldoAFavorPeriodoAnterior, , type:'currency', currencySymbol:'$')}</div>
												</td>
											</tr>
											</g:if>
											<g:if test="${liquidacionIIBBInstance?.saldoAFavor!=null}">
											<tr>
												<td style="text-align:left;">Saldo a favor</td>
												<td>
													<div class=""><i class="ti-minus"></i> ${formatNumber(number: liquidacionIIBBInstance?.saldoAFavor, , type:'currency', currencySymbol:'$')}</div>
												</td>
											</tr>
											</g:if>
											<g:if test="${liquidacionIIBBInstance?.saldoDdjj!=null}">
											<tr>
												<td style="text-align:left;">A pagar</td>
												<td>
													<div class="f-w-700"><i class="ti-line-double"></i> ${formatNumber(number: liquidacionIIBBInstance?.saldoDdjj, , type:'currency', currencySymbol:'$')}</div>
												</td>
											</tr>
											</g:if>
										</tbody>
									</table>
								</div>
							</div>
							
							<g:if test="${(liquidacionIIBBInstance?.nota!=null)}">
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Nota</h4>
									<div class="row">
										<div class="col-md-12">
											<div class="row">
												<div class="col-2">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.nota.label" default="Nota" /></h6>
												</div>
												<div class="col-10">
													<h6 class="m-b-30">${liquidacionIIBBInstance?.nota}</h6>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							</g:if>			
						</div>
					</div>
				</div>
				</g:each>

			</div>
			<div class="b-t-default">
								<div class="row m-0">
									<a href="#!" id="btn-presentar-iibb" style="${(liquidacionesBuscadas.first().estadoUsuario != 'Liquidado') ? 'display: none;' : ''}" class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar"><!-- Siempre se crea el botón para evitar errores, pero si es estado es diferente a liquidado lo ocultamos para que no puedan interactuar con él. -->
									<p class="m-0 text-uppercase d-inline-block">Autorizar liquidacion ${mes}/${ano}</p>
									</a>
									<g:if test="${liquidacionesBuscadas.first()?.estadoUsuario == 'Presentada'}">
										<div class="col-12 text-center p-t-15 p-b-15 btn-presentar ok" style="font-weight: 600;">
											<p class="m-0 text-uppercase d-inline-block">Presentada</p>
											<i class="icon-emotsmile"></i>
										</div>
									</g:if>
								<g:elseif test="${liquidacionesBuscadas.first()?.estadoUsuario == 'Autorizada' || liquidacionesBuscadas.first()?.estadoUsuario == 'Sin liquidar'}">
									<div class="col-12 text-center p-t-15 p-b-15 btn-presentar" style="font-weight: 600;">
										<p class="m-0 text-uppercase d-inline-block">${(liquidacionesBuscadas.first()?.estadoUsuario == 'Autorizada') ? "Pendiente" : "Sin liquidar"}</p>
									</div>
								</g:elseif>
								</div>
							</div>
		</div>
	</div>

<script type="text/javascript">
$(document).ready(function () {
	document.querySelector('#btn-presentar-iibb').onclick = function(){
        swal({
            title: "<g:message code='default.button.autorizar.confirm.message' default='¿Estás seguro que desea autorizar la presentación de IIBB?'/>",
            text: '${"Total: " + formatNumber(number: sumaTotal, type:"currency", currencySymbol:"\$")}',
            type: "warning",
            showCancelButton: true,
            confirmButtonClass: "btn-danger",
            confirmButtonText: "<g:message code='zifras.autorizar.ok' default='Si, autorizar'/>",
            cancelButtonText: "<g:message code='zifras.autorizar.cancel' default='No, cancelar'/>",
            closeOnConfirm: true,
            closeOnCancel: true
        },
        function(isConfirm) {
            if (isConfirm) {
                window.location.href = "${raw( createLink(controller:'notificacion', action: 'autorizarLiquidaciones', params:[uId: userId, cId:cuentaId, mes:mes, ano:ano]) )}";
            }
           }
        )
    }
});
</script>
</body>
</html>