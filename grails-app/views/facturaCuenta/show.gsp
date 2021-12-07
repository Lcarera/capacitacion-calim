<!DOCTYPE html>
<html lang="en">
	<head>
		<meta name="layout" content="main">
	</head>
	<body>
		<div style="display: none;">
			<div id="urlDelete">
				<g:createLink controller="facturaCuenta" action="delete" />
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
									<h4>Factura Calim #${facturaCuentaInstance?.id}</h4>
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
						<div class="col-md-12 col-xl-8 ">
							<div class="card">
								<div class="card-block user-detail-card">
									<div class="row">
										<div class="col-sm-12 user-detail">
											<g:if test="${facturaCuentaInstance?.cuenta}">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.cuenta.label" default="Cliente" />
														</h6>
													</div>
													<div class="col-sm-7">
														<h6 class="m-b-30">${facturaCuentaInstance?.cuenta}</h6>
													</div>
												</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-12 user-detail">
											<g:if test="${facturaCuentaInstance?.fechaHora}">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.fechaHora.label" default="Emisión" />
														</h6>
													</div>
													<div class="col-sm-7">
														<h6 class="m-b-30">${facturaCuentaInstance?.fechaHora.toString("dd/MM/yyyy")}</h6>
													</div>
												</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-12 user-detail">
											<g:if test="${facturaCuentaInstance?.descripcion}">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.descripcion.label" default="Descripcion" />
														</h6>
													</div>
													<div class="col-sm-7">
														<h6 class="m-b-30">${facturaCuentaInstance?.descripcion}</h6>
													</div>
												</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-12 user-detail">
											<g:if test="${facturaCuentaInstance?.importe}">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.importe.label" default="Importe" />
														</h6>
													</div>
													<div class="col-sm-7">
														<h6 class="m-b-30">${formatNumber(number: facturaCuentaInstance?.importe, type:'currency', currencySymbol:'\$')}</h6>
													</div>
												</div>
											</g:if>
										</div>
									</div>
									<g:if test="${path != 'ventas'}">
										<div class="row">
											<div class="col-sm-12 user-detail">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.pagada.label" default="Pagada" />
														</h6>
													</div>
													<div class="col-sm-7">
														<h6 class="m-b-30">${facturaCuentaInstance?.pagada ? 'Sí' : 'No'} (${facturaCuentaInstance?.cantidadAvisos ?: 0} avisos)</h6>
													</div>
												</div>
											</div>
										</div>

										<div class="row">
											<div class="col-sm-12 user-detail">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.cae.label" default="CAE" />
														</h6>
													</div>
													<div class="col-sm-7">
														<g:if test="${facturaCuentaInstance?.cae}">
															<h6 class="m-b-30">${facturaCuentaInstance?.cae}</h6>
														</g:if>
														<g:else>
															<button type="button" class="btn btn-primary m-b-0" onclick="solicitarCae()">Solicitar CAE</button>
															<button type="button" class="btn btn-primary m-b-0" onclick="$('#modalCae').modal('show')">Ingreso Manual</button>
														</g:else>
													</div>
												</div>
											</div>
										</div>
									</g:if>
									<g:if test="${facturaCuentaInstance?.cae}">
										<div class="row">
											<div class="col-sm-12 user-detail">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.vencimientoCae.label" default="Vencimiento CAE" />
														</h6>
													</div>
													<div class="col-sm-7">
														<h6 class="m-b-30">${facturaCuentaInstance?.vencimientoCae?.toString("dd/MM/yyyy")}</h6>
													</div>
												</div>
											</div>
										</div>
										<div class="row">
											<div class="col-sm-12 user-detail">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.numero.label" default="Factura Nro." />
														</h6>
													</div>
													<div class="col-sm-7">
														<h6 class="m-b-30">${facturaCuentaInstance?.numero}</h6>
													</div>
												</div>
											</div>
										</div>
									</g:if>
									<div class="row">
										<div class="col-sm-12 user-detail">
											<g:if test="${facturaCuentaInstance?.nombreArchivo}">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.nombreArchivo.label" default="Archivo" />
														</h6>
													</div>
													<div class="col-sm-7">
														<h6 class="m-b-30">${facturaCuentaInstance?.nombreArchivo}</h6>
													</div>
												</div>
											</g:if>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-12 user-detail">
											<g:if test="${facturaCuentaInstance?.linkPago}">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.linkPago.label" default="Link de pago" />
														</h6>
													</div>
													<div class="col-sm-5">
														<h6 id="linkPago" class="m-b-30">${facturaCuentaInstance?.linkPago}</h6>
													</div>
													<div class="col-sm-2">	
														<button class="btn btn-primary" onclick="copyToClipboard('#linkPago')" >Copiar</button>
													</div>
												</div>
											</g:if>

										</div>
									</div>
									<div class="row">
										<div class="col-sm-12 user-detail">
											<g:if test="${facturaCuentaInstance?.local}">
												<div class="row">
													<div class="col-sm-5">
														<h6 class="f-w-400 m-b-30">
															<g:message code="zifras.documento.FacturaCuenta.local.label" default="Local" />
														</h6>
													</div>
													<div class="col-sm-7">
														<h6 class="m-b-30">${facturaCuentaInstance?.local}</h6>
													</div>
												</div>
											</g:if>
										</div>
									</div>
									<g:if test="${facturaCuentaInstance?.local?.telefono}">
									<div class="row">
										<div class="col-sm-12 user-detail">
											<div class="row">
												<div class="col-sm-5">
													<h6 class="f-w-400 m-b-30">
														<g:message code="zifras.documento.FacturaCuenta.local.telefono.label" default="Whatsapp" />
													</h6>
												</div>
												<div class="col-sm-7">
													<h6 class="m-b-30"><a href="https://api.whatsapp.com/send?phone=${facturaCuentaInstance.local.telefono}" target="_blank">${facturaCuentaInstance.local.telefono}</a></h6><br/>
													<h6 class="m-b-30"><a class="btn btn-primary m-b-0" href="https://api.whatsapp.com/send?phone=${facturaCuentaInstance.local.telefono}&text=${facturaCuentaInstance.linkPago.replace('&', '%26')}" target="_blank">Enviar link</a></h6>
												</div>
											</div>
										</div>
									</div>
									</g:if>
									<div class="row">
										<div class="col-sm-12">
											<h4 class="sub-title"></h4>
											<g:if test="${!(facturaCuentaInstance.pagada) && (path!='ventas')}">
												<button type="button" class="btn btn-primary m-b-0" onclick="generarPagoManualFactura()">Marcar como Pagada</button>
											</g:if>	
											<g:if test="${!(facturaCuentaInstance?.cae || facturaCuentaInstance?.pagada)}">
												<button type="button" class="btn btn-danger alert-success-cancel m-b-0" >
													<g:message code="default.button.delete.label" default="Eliminar" />
												</button>
											</g:if>
											<g:if test="${path == 'ventas'}">
												<g:link class="btn btn-inverse m-b-0" action="listSolicitudesPago">
													<g:message code="default.button.back.label" default="Volver" />
												</g:link>
											</g:if>
											<g:else>
												<g:link class="btn btn-inverse m-b-0" action="list">
													<g:message code="default.button.back.label" default="Volver" />
												</g:link>
											</g:else>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="modal fade" id="modalCae" tabindex="-1" role="dialog">
				<div class="modal-dialog modal-lg" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4 class="modal-title" id="modalDdjjTitulo">Ingreso manual de datos AFIP</h4>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<g:form name="caeForm" action="updateCae">
								<g:hiddenField name="facturaId" value="${facturaCuentaInstance.id}" />
								<div class="form-group row">
									<label class="col-sm-2 col-form-label">Número</label>
									<div class="col-sm-10">
										<input name="numero" id="modalCae_numero" type="text" class="form-control" value="00000000">
									</div>
								</div>
								<div class="form-group row">
									<label class="col-sm-2 col-form-label">CAE</label>
									<div class="col-sm-10">
										<input name="cae" id="modalCae_cae" type="text" class="form-control">
									</div>
								</div>
								<div class="form-group row">
									<label class="col-sm-2 col-form-label">Vencimiento</label>
									<div class="col-sm-10">
										<input id="modalCae_vencimiento" name="vencimiento" required class="form-control" type="text" data-format="d/m/Y" placeholder="Seleccione un día" value="${new org.joda.time.LocalDate().plusDays(10).toString('dd/MM/yyyy')}" />
									</div>
								</div>
							</g:form>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
							<button class="btn btn-primary waves-effect waves-light " onclick="$('#caeForm').submit();">Aceptar</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			$(document).ready(function () {
				$("#modalCae_vencimiento").dateDropper({
					dropWidth: 200,
					dropPrimaryColor: "#1abc9c",
					dropBorder: "1px solid #1abc9c",
					dropBackgroundColor: "#FFFFFF",
					format: "d/m/Y",
					lang: "es"
				});
				//Success or cancel alert
				document.querySelector('.alert-success-cancel').onclick = function(){
					swal({
						title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
						text: "<g:message code='zifras.documento.FacturaCuenta.delete.message' default='La factura cuenta se eliminará'/>",
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
							window.location.href = $('#urlDelete').text() + '/' + ${facturaCuentaInstance?.id};
						}
					});
				};
			});

			function copyToClipboard(element) {
			  var $temp = $("<input>");
			  $("body").append($temp);
			  $temp.val($(element).text()).select();
			  document.execCommand("copy");
			  $temp.remove();
			}

			function solicitarCae() {
				swal({
					title: '¿Estás seguro?',
					text: 'Se creará una factura electrónica en la AFIP.\nEsta acción no puede deshacerse.\n\n(La factura se crea automáticamente al recibir un pago)',
					type: 'warning',
					showCancelButton: true,
					confirmButtonClass: 'btn-danger',
					confirmButtonText: 'Sí, solicitar',
					cancelButtonText: 'No, cancelar',
					closeOnConfirm: true,
					closeOnCancel: true
				},
				function(isConfirm) {
					if (isConfirm) {
						window.location.href = "${createLink(action:'solicitarCae', id:facturaCuentaInstance.id)}"
					}
				});
			}

			function generarPagoManualFactura(){
				let listaIds = [];
				listaIds.push(${facturaCuentaInstance.movimiento.id})
				swal({
					title: "¿Generar movimiento positivo?",
					text: 'El importe de la factura a cancelar es de \$' + ${facturaCuentaInstance.importe}.toFixed(2).replace(".", ","),
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
						const urlBase = "${raw(createLink(controller: 'pagoCuenta', action: 'createManual', params:['cuentaId':facturaCuentaInstance.cuenta.id, 'movimientos': 'variableListaIds']))}"
						window.location.href =  urlBase.replace('variableListaIds', escape(listaIds));
					}
				});
			}

		</script>
	</body>
</html>