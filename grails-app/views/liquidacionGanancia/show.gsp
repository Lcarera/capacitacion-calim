<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlDelete">
		<g:createLink controller="liquidacionGanancia" action="delete" />
	</div>
	<div id="urlGetGastosDeduccionesList">
		<g:createLink controller="liquidacionGanancia" action="ajaxGetGastosDeduccionesList" />
	</div>
	<div id="urlGetDeduccionesParientesList">
		<g:createLink controller="liquidacionGanancia" action="ajaxGetDeduccionesParientesList" />
	</div>
	<div id="urlGetPatrimoniosList">
		<g:createLink controller="liquidacionGanancia" action="ajaxGetPatrimoniosList" />
	</div>
</div>
<div class="main-body">
	<div class="page-wrapper">
		<div class="page-body">
			<div class="row">
				<!-- Sho Map Start -->
				<div class="col-md-12">
					<div class="card">
						<div class="card-block typography">
							<div class="row">
								<div class="col-md-6">
									<g:if test="${liquidacionGananciaInstance?.fecha}">
									<div class="row">
										<div class="col-8">
											<div class="f-w-400"><i class="icofont icofont-calendar"></i> <g:message code="zifras.liquidacion.LiquidacionGanancia.fecha.label" default="Fecha" /></div>
										</div>
										<div class="col-4">
											<div style="text-align:right;">${liquidacionGananciaInstance?.fecha?.toString('dd/MM/yyyy')}</div>
										</div>
									</div>
									</g:if>
									<g:if test="${liquidacionGananciaInstance?.cuenta}">
									<div class="row">
										<div class="col-4">
											<div class="f-w-400"><i class="icofont icofont-id"></i> <g:message code="zifras.liquidacion.LiquidacionGanancia.razonSocial.label" default="Razón Social" /></div>
										</div>
										<div class="col-8">
											<div style="text-align:right;">${liquidacionGananciaInstance?.cuenta?.cuit} - ${liquidacionGananciaInstance?.cuenta?.razonSocial}</div>
										</div>
									</div>
									</g:if>
								</div>
								<div class="col-md-6">
									<g:if test="${liquidacionGananciaInstance?.estado}">
									<div class="row">
										<div class="col-8">
											<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.estado.label" default="Estado" /></div>
										</div>
										<div class="col-4">
											<div style="text-align:right;">${liquidacionGananciaInstance?.estado?.nombre}</div>
										</div>
									</div>
									</g:if>
									<g:if test="${liquidacionGananciaInstance?.impuesto!=null}">
									<div class="row">
										<div class="col-8">
											<div class="f-w-400"><i class="icofont icofont-coins"></i> <g:message code="zifras.liquidacion.LiquidacionGanancia.impuesto.label" default="Impuesto" /></div>
										</div>
										<div class="col-4">
											<div class="f-w-700 text-primary" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.impuesto, , type:'currency', currencySymbol:'$')}</div>
										</div>
									</div>
									</g:if>
								</div>
							</div>
							<div class="row">
								<div class="col-md-6">
									<h4 class="sub-title" style="margin:10px 0px;">Ingresos</h4>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.totalIngresos!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.totalIngresos.label" default="Ingresos" /></div>
												</div>
												<div class="col-4">
													<div class="f-w-700 text-primary" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.totalIngresos, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.existenciaInicial!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.existenciaInicial.label" default="E. Inicial" /></div>
												</div>
												<div class="col-4">
													<div class="" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.existenciaInicial, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.netoCompra!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.netoCompra.label" default="Compra" /></div>
												</div>
												<div class="col-4">
													<div class="" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.netoCompra, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.existenciaFinal!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.existenciaFinal.label" default="E. Final" /></div>
												</div>
												<div class="col-4">
													<div class="" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.existenciaFinal, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.costoMercaderiaVendida!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.costoMercaderiaVendida.label" default="Costo mercadería vendida" /></div>
												</div>
												<div class="col-4">
													<div class="" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.costoMercaderiaVendida, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								
									<h4 class="sub-title" style="margin:10px 0px;">Gastos y Deducciones</h4>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.ingresosBrutos!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.ingresosBrutos.label" default="Ingresos Brutos" /></div>
												</div>
												<div class="col-4">
													<div class="" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.ingresosBrutos, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<g:each in="${liquidacionGananciaInstance.gastosDeducciones}">
									<div class="row">
										<div class="col-md-12">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400">${it.tipo.nombre}</div>
												</div>
												<div class="col-4">
													<div class="" style="text-align:right;">${formatNumber(number: it.valor, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
										</div>
									</div>
									</g:each>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.totalGastosDeducciones!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.totalGastosDeducciones.label" default="Total de gastos y ded." /></div>
												</div>
												<div class="col-4">
													<div class="f-w-700 text-primary" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.totalGastosDeducciones, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								
									<h4 class="sub-title" style="margin:10px 0px;">Cálculos</h4>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.costoTotal!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.costoTotal.label" default="Costo total" /></div>
												</div>
												<div class="col-4">
													<div class="" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.costoTotal, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.rentaImponible!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.rentaImponible.label" default="Renta imponible" /></div>
												</div>
												<div class="col-4">
													<div class="f-w-700 text-primary" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.rentaImponible, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.gananciaNoImponible!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.gananciaNoImponible.label" default="Ganancia no imponible" /></div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.gananciaNoImponible, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<g:each in="${liquidacionGananciaInstance.deduccionesParientes}">
									<div class="row">
										<div class="col-md-12">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:if test="${it.pariente.tipoId==0}">Conyuge</g:if><g:else>Hijo/a</g:else></div>
												</div>
												<div class="col-4">
													<div class="" style="text-align:right;">${formatNumber(number: it.valor, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
										</div>
									</div>
									</g:each>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.deduccionEspecial!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.deduccionEspecial.label" default="Deducción especial" /></div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.deduccionEspecial, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.subtotalGananciaImponible!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.subtotalGananciaImponible.label" default="Total deducciones personales" /></div>
												</div>
												<div class="col-4">
													<div class="f-w-700 text-primary" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.subtotalGananciaImponible, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.gananciaImponible!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.gananciaImponible.label" default="Ganancia Imponible" /></div>
												</div>
												<div class="col-4">
													<div class="f-w-700 text-primary" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.gananciaImponible, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.impuestoDeterminado!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.impuestoDeterminado.label" default="Impuesto determinado" /></div>
												</div>
												<div class="col-4">
													<div class="f-w-700 text-primary" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.impuestoDeterminado, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.retencion!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.retencion.label" default="Retenciones" /></div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.retencion, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.percepcion!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.percepcion.label" default="Percepciones" /></div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.percepcion, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.anticipos!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.anticipos.label" default="Anticipos" /></div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.anticipos, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.impuestoDebitoCredito!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.impuestoDebitoCredito.label" default="Impuesto Débito/Crédito" /></div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.impuestoDebitoCredito, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.impuesto!=null}">
											<div class="row">
												<div class="col-8">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.impuestoAIngresar.label" default="Impuesto a ingresar" /></div>
												</div>
												<div class="col-4">
													<div class="f-w-700 text-primary" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.impuesto, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								</div>
								
								<div class="col-md-6">
									<h4 class="sub-title" style="margin:10px 0px;">Patrimonio</h4>
									<g:each in="${liquidacionGananciaInstance.patrimonios}">
									<div class="row">
										<div class="col-md-12">
											<div class="row">
												<div class="col-4">
													<div class="f-w-400">${it.tipo.nombre}</div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: it.valorInicial, , type:'currency', currencySymbol:'$')}</div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: it.valorCierre, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
										</div>
									</div>
									</g:each>
									<h4 class="sub-title" style="margin:10px 0px;">Totales</h4>
									<div class="row">
										<div class="col-md-12">
											<div class="row">
												<div class="col-4">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.sumatoriaPatrimonio.label" default="Total" /></div>
												</div>
												<div class="col-4">
													<g:if test="${liquidacionGananciaInstance?.sumatoriaPatrimonioInicial!=null}">
													<div class="f-w-700 text-primary" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.sumatoriaPatrimonioInicial, , type:'currency', currencySymbol:'$')}</div>
													</g:if>
												</div>
												<div class="col-4">
													<g:if test="${liquidacionGananciaInstance?.sumatoriaPatrimonioFinal!=null}">
													<div class="f-w-700 text-primary" style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.sumatoriaPatrimonioFinal, , type:'currency', currencySymbol:'$')}</div>
													</g:if>
												</div>
											</div>
											
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.rentaImponible!=null}">
											<div class="row">
												<div class="col-4">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.rentaImponible.label" default="Renta Imponible" /></div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.rentaImponible, , type:'currency', currencySymbol:'$')}</div>
												</div>
												<div class="col-4">
													
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.consumido!=null}">
											<div class="row">
												<div class="col-4">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.consumido.label" default="Consumido" /></div>
												</div>
												<div class="col-4">
													
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.consumido, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-md-12">
											<g:if test="${liquidacionGananciaInstance?.totalPatrimonio!=null}">
											<div class="row">
												<div class="col-4">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.totalPatrimonio.label" default="Inicial+RI = Cierre+Cons." /></div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.totalPatrimonio, , type:'currency', currencySymbol:'$')}</div>
												</div>
												<div class="col-4">
													<div style="text-align:right;">${formatNumber(number: liquidacionGananciaInstance?.totalPatrimonio, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								</div>
							</div>
							
							<g:if test="${(liquidacionGananciaInstance?.nota!=null)}">
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title" style="margin:10px 0px;">Nota</h4>
									<div class="row">
										<div class="col-md-12">
											<div class="row">
												<div class="col-2">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.nota.label" default="Nota" /></div>
												</div>
												<div class="col-10">
													<div class="">${liquidacionGananciaInstance?.nota}</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							</g:if>
							
							<g:if test="${(liquidacionGananciaInstance?.ultimaModificacion!=null) || (liquidacionGananciaInstance?.ultimoModificador!=null)}">
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title" style="margin:10px 0px;">Última modificación</h4>
									<div class="row">
										<div class="col-md-6">
											<g:if test="${liquidacionGananciaInstance?.ultimaModificacion!=null}">
											<div class="row">
												<div class="col-6">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.ultimaModificacion.label" default="Fecha/hora" /></div>
												</div>
												<div class="col-6">
													<div style="text-align:right;">${liquidacionGananciaInstance?.ultimaModificacion?.toString('dd/MM/yyyy HH:mm')}</div>
												</div>
											</div>
											</g:if>
										</div>
										
										<div class="col-md-6">
											<g:if test="${liquidacionGananciaInstance?.ultimoModificador!=null}">
											<div class="row">
												<div class="col-4">
													<div class="f-w-400"><g:message code="zifras.liquidacion.LiquidacionGanancia.ultimoModificador.label" default="Responsable" /></div>
												</div>
												<div class="col-8">
													<div class="f-w-700 text-primary" style="text-align:right;">${liquidacionGananciaInstance?.ultimoModificador}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
									<div class="row">
											<div class="col-md-12">
												<h4 class="sub-title"></h4>
												<sec:ifAnyGranted roles="ROLE_ADMIN">
													<button type="button" class="btn btn-primary m-b-0" onclick="$('#modalPresentarDDJJ').modal('show');">Presentar</button>
													<button type="button" class="btn btn-danger alert-success-cancel m-b-0" ><g:message code="default.button.delete.label" default="Eliminar" /></button>
													<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
												</sec:ifAnyGranted>
												<sec:ifAnyGranted roles="ROLE_CUENTA">
													<g:link class="btn btn-inverse m-b-0" action="list" controller="liquidacionUsuario"><g:message code="default.button.back.label" default="Volver" /></g:link>
												</sec:ifAnyGranted>
											</div>
										</div>
								</div>
							</div>
							</g:if>
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
				<h4 class="modal-title">Presentar Declaración Jurada</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<g:uploadForm controller="declaracionJurada" action="savePorLiquidacionGanancia">
				<div class="modal-body">
					<g:hiddenField name="cuentaId" value="${liquidacionGananciaInstance?.cuenta.id}" />
					<g:hiddenField name="liquidacionId" value="${liquidacionGananciaInstance?.id}" />
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">Fecha</label>
						<div class="col-sm-10">
							<input id="modalDdjjFecha" name="fecha" required="" class="form-control" type="text" data-format="d/m/Y" placeholder="Seleccione un día" value="${fechaHoy}" />
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
							<input type="file" name="archivo" id="archivos_importar">
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
					<button class="btn btn-primary waves-effect waves-light " onclick="">Presentar</button>
				</div>
			</div>
		</g:uploadForm>
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	//Success or cancel alert
	if(document.querySelector('.alert-success-cancel')!=null){
		document.querySelector('.alert-success-cancel').onclick = function(){
			swal({
				title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
				text: "<g:message code='zifras.liquidacionGanancia.LiquidacionGanancia.delete.message' default='La liquidación de ganancia se eliminará'/>",
				type: "warning",
				showCancelButton: true,
				confirmButtonClass: "btn-danger",
				confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, eliminar'/>",
				cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
				closeOnConfirm: true,
				closeOnCancel: true
			},
			function(isConfirm) {
				if (isConfirm)
					window.location.href = $('#urlDelete').text() + '/' + ${liquidacionGananciaInstance?.id};
			});
		};
	}
	$("#modalDdjjFecha").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "d/m/Y",
		lang: "es"
    });


	$('#archivos_importar').filer({
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
});
</script>
</body>
</html>