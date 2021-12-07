<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlDelete">
		<g:createLink controller="liquidacionIva" action="delete" />
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
		                    <h4><g:message code="default.show.label" default="Mostrar {0}" args="['Liquidación Iva']"/></h4>
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
						<div class="card-block typography">
							<div class="row">
								<div class="col-md-6">
									<g:if test="${liquidacionIvaInstance?.fecha}">
									<div class="row">
										<div class="col-5">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-calendar"></i> <g:message code="zifras.liquidacion.LiquidacionIva.fecha.label" default="Fecha" /></h6>
										</div>
										<div class="col-7">
											<h6 class="m-b-30">${liquidacionIvaInstance?.fecha?.toString('dd/MM/yyyy')}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${liquidacionIvaInstance?.cuenta}">
									<div class="row">
										<div class="col-5">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-id"></i> <g:message code="zifras.liquidacion.LiquidacionIva.razonSocial.label" default="Razón Social" /></h6>
										</div>
										<div class="col-7">
											<h6 class="m-b-30">${liquidacionIvaInstance?.cuenta?.cuit} - ${liquidacionIvaInstance?.cuenta?.razonSocial}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${liquidacionIvaInstance?.fechaVencimiento}">
										<div class="row">
											<div class="col-5">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-calendar"></i> <g:message code="zifras.liquidacion.LiquidacionIva.fechaVencimiento.label" default="Vencimiento" /></h6>
											</div>
											<div class="col-7">
												<h6 class="m-b-30">${liquidacionIvaInstance?.fechaVencimiento?.toString('dd/MM/yyyy')}</h6>
											</div>
										</div>
									</g:if>
								</div>
								<div class="col-md-6">
									<g:if test="${liquidacionIvaInstance?.estado}">
									<div class="row">
										<div class="col-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.estado.label" default="Estado" /></h6>
										</div>
										<div class="col-7">
											<h6 class="m-b-30">${liquidacionIvaInstance?.estado?.nombre}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${liquidacionIvaInstance?.saldoDdjj!=null}">
									<div class="row">
										<div class="col-5">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-coins"></i> <g:message code="zifras.liquidacion.LiquidacionIva.saldoDdjj.label" default="Saldo DDJJ" /></h6>
										</div>
										<div class="col-7">
											<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.saldoDdjj, type:'currency', currencySymbol:'$')}</div>
										</div>
									</div>
									</g:if>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<div class="row">
										<div class="col-md-12">
											<h4 class="sub-title" style="margin-bottom:0px;border-bottom:0px;">Venta</h4>
											<table id="listDebitoFiscal" class="table table-framed compact" style="text-align:right;">
												<thead>
													<tr>
														<th></th>
														<th style="text-align:right;">21%</th>
														<th style="text-align:right;">10,5%</th>
														<th style="text-align:right;">27%</th>
														<th style="text-align:right;">2,5%</th>
														<th style="text-align:right;">5%</th>
														<th style="text-align:right;">No grav</th>
														<th style="text-align:right;">Exento</th>
														<th style="text-align:right;">Total</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td style="text-align:left;">Neto</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoVenta21, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoVenta10, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoVenta27, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoVenta2, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoVenta5, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoNoGravadoVenta, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.exentoVenta, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.netoVenta, type:'currency', currencySymbol:'$')}</div>
														</td>
													</tr>
													<tr>
														<td style="text-align:left;">Débito Fiscal</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.debitoFiscal21, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.debitoFiscal10, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.debitoFiscal27, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.debitoFiscal2, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.debitoFiscal5, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
														</td>
														<td>
														</td>
														<td>
															<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.debitoFiscal, type:'currency', currencySymbol:'$')}</div>
														</td>
													</tr>
													<tr>
														<td style="text-align:left;">Total Venta</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalVenta21, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalVenta10, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalVenta27, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalVenta2, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalVenta5, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalNoGravadoVenta, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalExentoVenta, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.totalVenta, type:'currency', currencySymbol:'$')}</div>
														</td>
													</tr>
												</tbody>
											</table>
										</div>
										
										<div class="col-md-12">
											<h4 class="sub-title" style="margin-bottom:0px;border-bottom:0px;">Compra</h4>
											<table id="listCreditoFiscal" class="table table-framed compact" style="text-align:right;">
												<thead>
													<tr>
														<th></th>
														<th style="text-align:right;">21%</th>
														<th style="text-align:right;">10,5%</th>
														<th style="text-align:right;">27%</th>
														<th style="text-align:right;">2,5%</th>
														<th style="text-align:right;">5%</th>
														<th style="text-align:right;">No grav</th>
														<th style="text-align:right;">Exento</th>
														<th style="text-align:right;">Total</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td style="text-align:left;">Neto</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoCompra21, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoCompra10, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoCompra27, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoCompra2, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoCompra5, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.netoNoGravadoCompra, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.exentoCompra, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.netoCompra, type:'currency', currencySymbol:'$')}</div>
														</td>
													</tr>
													<tr>
														<td style="text-align:left;">Crédito Fiscal</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.creditoFiscal21, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.creditoFiscal10, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.creditoFiscal27, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.creditoFiscal2, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.creditoFiscal5, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
														</td>
														<td>
														</td>
														<td>
															<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.creditoFiscal, type:'currency', currencySymbol:'$')}</div>
														</td>
													</tr>
													<tr>
														<td style="text-align:left;">Total Compra</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalCompra21, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalCompra10, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalCompra27, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalCompra2, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalCompra5, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalNoGravadoCompra, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="">${formatNumber(number: liquidacionIvaInstance?.totalExentoCompra, type:'currency', currencySymbol:'$')}</div>
														</td>
														<td>
															<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.totalCompra, type:'currency', currencySymbol:'$')}</div>
														</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Saldos técnicos</h4>
									<div class="row">
										<div class="col-md-6">
											<g:if test="${liquidacionIvaInstance?.porcentajeDebitoCredito!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.porcentajeDebitoCredito.label" default="Deb/Cred" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.porcentajeDebitoCredito, type:'number')} %</div>
												</div>
											</div>
											</g:if>
											<g:if test="${liquidacionIvaInstance?.saldoTecnicoAFavor!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.saldoTecnicoAFavor.label" default="A favor período actual" /></h6>
												</div>
												<div class="col-7">
													<h6 class="m-b-30">${formatNumber(number: liquidacionIvaInstance?.saldoTecnicoAFavor, type:'currency', currencySymbol:'$')}</h6>
												</div>
											</div>
											</g:if>
										</div>
										
										<div class="col-md-6">
											<g:if test="${liquidacionIvaInstance?.debitoMenosCredito!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.debitoMenosCredito.label" default="Deb-Cred" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.debitoMenosCredito, type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
											<g:if test="${liquidacionIvaInstance?.saldoTecnicoAFavorPeriodoAnterior!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.saldoTecnicoAFavorPeriodoAnterior.label" default="A favor período anterior" /></h6>
												</div>
												<div class="col-7">
													<h6 class="m-b-30">${formatNumber(number: liquidacionIvaInstance?.saldoTecnicoAFavorPeriodoAnterior, type:'currency', currencySymbol:'$')}</h6>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Saldos de libre disponibilidad</h4>
									<div class="row">
										<div class="col-md-6">
											<g:if test="${liquidacionIvaInstance?.retencion!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.retencion.label" default="Retenciones" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.retencion, type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
											<g:if test="${liquidacionIvaInstance?.saldoLibreDisponibilidad!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.saldoLibreDisponibilidad.label" default="Período actual" /></h6>
												</div>
												<div class="col-7">
													<h6 class="m-b-30">${formatNumber(number: liquidacionIvaInstance?.saldoLibreDisponibilidad, type:'currency', currencySymbol:'$')}</h6>
												</div>
											</div>
											</g:if>
										</div>
										
										<div class="col-md-6">
											<g:if test="${liquidacionIvaInstance?.percepcion!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.percepcion.label" default="Percepciones" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIvaInstance?.percepcion, type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
											<g:if test="${liquidacionIvaInstance?.saldoLibreDisponibilidadPeriodoAnterior!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.saldoLibreDisponibilidadPeriodoAnterior.label" default="Período anterior" /></h6>
												</div>
												<div class="col-7">
													<h6 class="m-b-30">${formatNumber(number: liquidacionIvaInstance?.saldoLibreDisponibilidadPeriodoAnterior, type:'currency', currencySymbol:'$')}</h6>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								</div>
							</div>
							
							<g:if test="${(liquidacionIvaInstance?.ultimaModificacion!=null) || (liquidacionIvaInstance?.ultimoModificador!=null)}">
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Última modificación</h4>
									<div class="row">
										<div class="col-md-6">
											<g:if test="${liquidacionIvaInstance?.ultimaModificacion!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.ultimaModificacion.label" default="Fecha/hora" /></h6>
												</div>
												<div class="col-7">
													<h6 class="m-b-30">${liquidacionIvaInstance?.ultimaModificacion?.toString('dd/MM/yyyy HH:mm')}</h6>
												</div>
											</div>
											</g:if>
										</div>
										
										<div class="col-md-6">
											<g:if test="${liquidacionIvaInstance?.ultimoModificador!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIva.ultimoModificador.label" default="Responsable" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${liquidacionIvaInstance?.ultimoModificador}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								</div>
							</div>
							</g:if>
							
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
							
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title"></h4>
									<sec:ifAnyGranted roles="ROLE_ADMIN">
										<g:link class="btn btn-primary m-b-0" action="edit" id="${liquidacionIvaInstance?.id}"><g:message code="default.button.edit.label" default="Editar" /></g:link>
										<button type="button" class="btn btn-primary m-b-0" onclick="$('#modalPresentarDDJJ').modal('show');">Presentar</button>
										<g:if test="${liquidacionIvaInstance?.estado?.nombre == 'Presentada'}">
											<button type="button" class="btn btn-primary m-b-0" onclick="$('#modalVep').modal('show');">Subir VEP</button>
										</g:if>	
										<g:elseif test="${liquidacionIIBBInstance?.estado?.nombre != 'Autorizada'}">
											<button type="button" class="btn btn-primary m-b-0" onclick="notificar()">Notificar</button>
										</g:elseif>
										<button type="button" class="btn btn-danger alert-success-cancel m-b-0" ><g:message code="default.button.delete.label" default="Eliminar" /></button>
									</sec:ifAnyGranted>
									<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
								</div>
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
				<h4 class="modal-title">Presentar Declaración Jurada</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<g:uploadForm controller="declaracionJurada" action="savePorLiquidacionIva">
				<div class="modal-body">
					<g:hiddenField name="cuentaId" value="${liquidacionIvaInstance?.cuenta.id}" />
					<g:hiddenField name="liquidacionId" value="${liquidacionIvaInstance?.id}" />
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

<div class="modal fade" id="modalVep" tabindex="-1" role="dialog">
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
					<g:hiddenField name="esIva" value="true"/>
					<g:hiddenField name="liqId" value="${liquidacionIvaInstance.id}"/>
					<g:hiddenField name="cuentaId" value="${liquidacionIvaInstance.cuenta.id}" />
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

<script type="text/javascript">
$(document).ready(function () {
	//Success or cancel alert
	if(document.querySelector('.alert-success-cancel')!=null){
		document.querySelector('.alert-success-cancel').onclick = function(){
			swal({
				title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
				text: "<g:message code='zifras.liquidacionIva.LiquidacionIva.delete.message' default='La liquidacionIva se eliminará'/>",
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
					window.location.href = $('#urlDelete').text() + '/' + ${liquidacionIvaInstance?.id};
				}
				/*if (isConfirm) {
					swal("Deleted!", "Your imaginary file has been deleted.", "success");
				} else {
					swal("Cancelled", "Your imaginary file is safe :)", "error");
				}*/
			});
		};
	}
	
	$('#listDebitoFiscal').DataTable({
		"ordering": false,
		"searching": false,
		"paging":false,
		"info": false,
		"lengthChange": false,
		sPaginationType: 'simple'
	});
	
	$('#listCreditoFiscal').DataTable({
		"ordering": false,
		"searching": false,
		"paging":false,
		"info": false,
		"lengthChange": false,
		sPaginationType: 'simple'
	});

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
});

function notificar(){
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
			$.ajax("${createLink(controller:'liquidacionIva', action: 'ajaxEnviarNotificaciones')}", {
				dataType: "json",
				method: "POST",
				data: {
					ano: "${liquidacionIvaInstance.fecha.toString('yyyy')}",
					mes: "${liquidacionIvaInstance.fecha.toString('MM')}",
					cuentasIds: "${liquidacionIvaInstance.cuenta.id}"
				}
			}).done(function(data) {					
				swal("Notificaciones enviadas!", "El cliente ha recibido el mail para autorizar.", "success");
			});
		}
	})
}
</script>
</body>
</html>