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
	<script type="text/javascript">
	    var cuitValido = false;
	        function validarCuit(elemento){
	            var valor = elemento.val();
	            if (valor.length != 11){
	                elemento.addClass('is-invalid');
	                cuitValido = false;
	                return;
	            }
	            if (!(['20', '23', '24', '27', '30', '33', '34'].includes(valor.slice(0,2)))){
	                elemento.addClass('is-invalid');
	                cuitValido = false;
	                return;
	            }
	            elemento.removeClass('is-invalid');
	            cuitValido = true;
	            return;
	        }
	</script>
</head>

<body>
<div style="display: none;">
	<div id="urlAutorizarIva">
		<g:createLink controller="liquidacionIvaUsuario" action="presentar" id="${idIva}"/>
	</div>
	<div id="urlAutorizarIIBB">
		<g:createLink controller="liquidacionIibbUsuario" action="presentarMes" params="[mes: mes, ano: ano]"/>
	</div>
	<div id="urlImportFrenteDni">
		<g:createLink controller="importacion" action="ajaxImportarFrenteDni" />
	</div>
	<div id="urlImportDorsoDni">
		<g:createLink controller="importacion" action="ajaxImportarDorsoDni" />
	</div>
	<div id="urlImportSelfie">
		<g:createLink controller="importacion" action="ajaxImportarSelfie" />
	</div>
</div>
<g:hiddenField name="facturacionMensualCuenta" id="facturacionMensualCuenta" value="${facturacionMensualCuenta}"/>
<g:hiddenField name="promedioMensualCategoria" id="promedioMensualCategoria" value="${promedioMensualCategoria}"/>
<div class="main-body">
	<div class="page-wrapper">
		<div class="page-body">
			<g:if test="${mostrarPasos && trabajaConApp}">
			<div class="row">
				<div class="col-lg-12">
					<div class="card">
						<div class="card-block accordion-block" style="padding:1em;">
							<div id="accordion" role="tablist" aria-multiselectable="true">
								<div class="accordion-panel">
									<div class=" accordion-heading" role="tab" id="headingThree">
										<h4 class="card-title accordion-title">
											<a id="stepsPasos" class="accordion-msg" data-toggle="collapse"
											   data-parent="#accordion" href="#collapseThree"
											   aria-expanded="true"
											   style=" cursor:default;font-weight: 300; font-size: 22px;border:0px;">
											   <g:if test="${saldo < 0}">
											  		<i class="icon-info" style="margin-right: 10px; color: red;"></i> <b style="color:red;">Paso 1/3 Importante:</b> Para poder darte de alta en el monotributo, necesitas abonar el importe del servicio
												</g:if>
												<g:elseif test="${claveFiscal == null}">
											   		<i class="icon-info" style="margin-right: 10px; color: red;"></i> <b style="color:red;">Paso 2/3 Importante:</b> Para poder darte de alta en el monotributo, necesitas obtener tu clave fiscal
												</g:elseif>
												<g:elseif test="${!ingresoFotosRegistro}">
													<i class="icon-info" style="margin-right: 10px; color: red;"></i> <b style="color:red;">Paso 3/3 Importante:</b> Para poder darte de alta en el monotributo, necesitamos que subas fotos de tu DNI y de tu rostro
												</g:elseif>
												<g:elseif test="${domicilio.direccion == 'ERROR' || domicilio.codigoPostal == 'ERROR'}">
													<i class="icon-info" style="margin-right: 10px; color: red;"></i> <b style="color:red;">Atención:</b> Ocurrió un error con tu domicilio al intentar darte de alta en el monotributo, necesitamos que ingreses el mismo nuevamente
												</g:elseif>
												<g:elseif test="${stepRegistro=='registroCompleto'}">		
														<h4>¡Listo! Ya tenemos todo lo necesario para realizar tu Monotributo en las próximas 48 horas.</h4>
														<br>
														<h5>(En caso de detectar algún error en la información, te vamos a avisar)</h5>				
												</g:elseif>
											</a>
										</h4>
									</div>
										
											<g:if test="${trabajaConApp && saldo<0}">
												<div class="content" style="border: none; min-height: 19em;">
											</g:if>
											<g:else>
												<g:if test="${!ingresoFotosRegistro || !claveFiscal}">
													<div class="content" style="border: none; min-height: 36em;">
												</g:if>
												<g:else>
													<g:if test="${domicilio.direccion == 'ERROR' || domicilio.codigoPostal == 'ERROR'}">
														<div class="content" style="border: none; min-height: 19em;">
													</g:if>
													<g:else>
														<div class="content" style="border: none; min-height: 2em;">
													</g:else>
												</g:else>
											</g:else>
												<div class="body">
													<g:if test="${!trabajaConApp || (!claveFiscal && saldo >= 0)}">
														<div class="row">
															<div class="col-lg-6">
																<iframe width="100%" height="360" src="https://www.youtube.com/embed/bfy5pHV4RAQ" frameborder="0" allowfullscreen></iframe>
															</div>
															<div class="col-lg-6">
																<h3>Para inscribirte a AFIP necesitás tu Clave Fiscal</h3>
																<h5 style="color:#2091a2;">Podés obtenerla desde tu celular. Aquí te explicamos cómo hacerlo:</h5><br/>
																<label style="margin-bottom: 20px;"><b>Importante:</b> es requisito contar con DNI argentino formato tarjeta, un celular que posea cámara frontal, y un fondo blanco para tomarte una foto.</label>
																<div class="f-14 m-b-10">
																	<div style="float:left;">
																		<label class="badge badge-lg bg-info m-r-20">1</label>
																	</div>
																	<div>
																		Descargá la app Mi AFIP en tu celular.
																	</div>
																</div>
																<div class="f-14 m-b-10">
																	<div style="float:left;">
																		<label class="badge badge-lg bg-info m-r-20">2</label>
																	</div>
																	<div>
																		Abrí la app y hace click en ‘Solicitar o recuperar tu Clave Fiscal a través del reconocimiento facial’.
																	</div>
																</div>
																<div class="f-14 m-b-10">
																	<div style="float:left;">
																		<label class="badge badge-lg bg-info m-r-20">3</label>
																	</div>
																	<div>
																		Clickeá en “Continuar” y autorizá el acceso a tu cámara.
																	</div>
																</div>
																<div class="f-14 m-b-10">
																	<div style="float:left;">
																		<label class="badge badge-lg bg-info m-r-20">4</label>
																	</div>
																	<div>
																		Escaneá el código de barra de tu DNI, y luego escribí la serie de letras y números que te aparecerá en pantalla.
																	</div>
																</div>
																<div class="f-14 m-b-10">
																	<div style="float:left;">
																		<label class="badge badge-lg bg-info m-r-20">5</label>
																	</div>
																	<div>
																		Repetí los movimientos faciales que te pida la app (paciencia, puede que tardes varios intentos hasta que lo tome). De lo contrario, intentá desde otro celular y asegurate de tener un fondo blanco atrás.
																	</div>
																</div>
																<div class="f-14 m-b-10">
																	<div style="float:left;">
																		<label class="badge badge-lg bg-info m-r-20">6</label>
																	</div>
																	<div>
																		Ingresá la Clave Fiscal que desees, con los requerimientos que pide la App (una mayúscula, 10 caracteres y 2 números). Te recomendamos que anotes esta contraseña en algún lugar.
																	</div>
																</div>
															</div>
														</div>
														<br>
														<div class="row">
															<div class="col-lg-6">
																<div style="float:left; margin-right: 30px; margin-top: 8px;">
																	
																<h5>Una vez obtenida la clave fiscal, ingresala acá</h5> &nbsp
																</div>
																<button style="margin-bottom: 30px;" id="btnClaveFiscal" class="btn btn-primary" onclick="$('#modalClaveFiscal').modal('show');">Ingresar Clave</button>
															</div>
															
														</div>
													</g:if>
													<g:elseif test="${saldo < 0}">
														<div class="row">
															<div class="col-md-4" style="margin:auto;">
																<h4 style="text-align: center;">El importe a abonar es $${saldo*-1}</h4> <br>
																<h5 style="color:#2091a2; text-align: center;"> Abonalo aqui con Mercado Pago: </h5> <button id="btnPagar" onclick="onclickBtnPagar()" type="button" style="width:100%;margin: 20px 0px 10px 0px;" class="formBtn btn btn-primary block waves-effect">Pagar <asset:image width="35" height="30" src="mercado-pago.png"/></button>
																<br>
																<h6 style="color:grey; text-align: center;"><asset:image width="40" height="40" src="tls.png"/> La transacción está protegida mediante el protocolo <u>TLS</u></h6>
															</div>
														</div>
													</g:elseif>
													<g:elseif test="${!ingresoFotosRegistro}">
														<div class="row"  style="padding: 0px 20px 0px 20px;">
															<div class="col-md-4" align="center">
																<h5 style="text-align: center;">Frente DNI</h5>
																<br>
																<div class="col-md-4">
																	<asset:image id="imagenFrenteDni" src="dni-frente.jpg" class="img-fluid p-b-10"/>
																</div>
																<br>
																<input type="file" name="fotoFrenteDni" id="frenteDni_importar">
															</div>
															<div class="col-md-4" align="center">
																<h5 style="text-align: center;">Dorso DNI</h5>
																<br>
																<div class="col-md-4">
																	<asset:image id="imagenDorsoDni" src="dni-dorso.jpg" class="img-fluid p-b-10"/>
																</div>
																<br>
																<input type="file" name="fotoDorsoDni" id="dorsoDni_importar">
															</div>
															<div class="col-md-4" align="center">
																<h5 style="text-align: center;">Foto Tipo Documento</h5>
																<br>
																<div id="colSelfie" class="col-md-4">
																	<asset:image id="imagenSelfie" src="avatar.jpg" class="img-fluid p-b-10"/>
																</div>
																<br>
																<input type="file" name="fotoSelfie" id="selfie_importar">
															</div>
														</div>
													</g:elseif>
													<g:elseif test="${domicilio.direccion == 'ERROR' || domicilio.codigoPostal == 'ERROR'}">
														<div class="form-group row">
															<label class="col-sm-1 col-form-label">Direccion</label>
															<div class="col-sm-4">
																<input  id="inputDireccion" class="form-control" value="${domicilio.direccion}">
															</div>
														</div>
														<div class="form-group row">
															<label class="col-sm-1 col-form-label">Codigo Postal</label>
															<div class="col-sm-4">
																<input id="inputCodigoPostal" class="form-control" value="${domicilio.codigoPostal}">
															</div>
														</div>
														<div class="form-group row">
															<button type="button" id="btnDomicilio" class="btn btn-primary" onclick="actualizarDomicilio();" style="margin-left: 15px;">Ingresar</button>
														</div>
													</g:elseif>
												</div>
											</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					</g:if>
					<!-- Design Wizard card end -->
				</div>
			</div>
			
			
			<div class="row">
		   		<g:if test="${saldo!=0 && stepRegistro != 'registroEnCurso'}">
					<div class="col-md-6 col-xl-3">
						<div class="card widget-statstic-card">
							<div class="card-header">
								<div class="card-header-left">
									<h4>Saldo</h4>
									<h6 class="p-t-10 m-b-0 text-c-blue">${saldo<0 ? "Deuda a pagar" : "Dinero a favor"}</h6>
									<br>
								</div>
							</div>
							<div class="card-block">
								<i class="ti-money st-icon bg-c-blue"></i>

								<div class="text-left">
									<h3 class="d-inline-block">${formatNumber(number: saldo*(-1), type:'currency', currencySymbol:'\$')}</h3>
									<g:link controller="miCuenta" action="show"><i class="icon-arrow-right-circle f-right" style="font-size:30px;"></i></g:link>
								</div>                            
							</div>
							<div class="b-t-default">
								<div class="row m-0">
									<g:if test="${saldo<0}">
										<a href="${createLink(controller:'pagoCuenta', action:'cancelarSaldo')}"  class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar">
											<p class="m-0 text-uppercase d-inline-block">Pagar</p>
										</a>
									</g:if>
									<g:else>
										<div class="col-12 text-center p-t-15 p-b-15 btn-presentar ok" style="font-weight: 600;">
											<p class="m-0 text-uppercase d-inline-block">Sin deuda</p>
											<i class="icon-emotsmile"></i>
										</div>
									</g:else>

								</div>
							</div>
						</div>
					</div>
				</g:if>
				<!-- statstic card end -->
				<g:if test="${saldo >= 0 || inscriptoAfip}">
					<div class="col-md-6 col-xl-3">
						<div class="card widget-statstic-card">
							<div class="card-header">
								<div class="card-header-left">
									<h4>Facturas</h4>
									<h6 class="p-t-10 m-b-0 text-c-blue" style="margin-bottom: 21px;">${periodoFacturacionString}</h6>
								</div>
							</div>
							<div class="card-block">
								<i class="ti-receipt st-icon bg-c-blue"></i>
								<div class="text-left">
									<h3 class="d-inline-block">${formatNumber(number: facturacionUltimoMes, type:'currency', currencySymbol:'$')} facturado este mes</h3>
									<g:if test="${claveFiscal != null}">
										<g:link controller="facturaVentaUsuario" action="create"><i class="icon-plus f-right" style="font-size:30px;"></i></g:link>
									</g:if>
									<g:else>
										<i class="icon-plus f-right" onclick= "alertarClaveFiscal()" style="font-size:30px; cursor:pointer;"></i>
									</g:else>
								</div>
							</div>
							<div class="b-t-default">
								<div class="row m-0">
									<a href="${createLink(controller:'facturaVentaUsuario', action:'list')}" class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar">
										<p class="m-0 text-uppercase d-inline-block">Listar</p>
									</a>
								</div>
							</div>
						</div>
					</div>
				</g:if>
				<!-- statstic card start -->
				<g:if test="${monotributista}">
					<div class="col-md-6 col-xl-3">
						<div class="card widget-statstic-card">
							<div class="card-header">
								<div class="card-header-left">
									<h4>Monotributo</h4>
									<h6 class="p-t-10 m-b-0 text-c-blue">Categoría: "${categoria}"</h6>
									<br>
								</div>
							</div>
							<div class="card-block">
								<i class="ti-more-alt st-icon bg-c-blue"></i>
								<div class="text-left">
									<h3 class="d-inline-block">Cuota Mensual: ${formatNumber(number: cuotaMensual, type:'currency', currencySymbol:'$')}</h3>
								</div>
							</div>
							<div class="b-t-default">
								<div class="row m-0">
									<a data-target="#modalMonotributo" data-toggle="modal" id="btnVerMas" href="#modalMonotributo" class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar">
										<p class="m-0 text-uppercase d-inline-block">Ver más</p>
									</a>
								</div>
							</div>
						</div>
					</div>
				</g:if>
				<g:elseif test="${condicionIva != 'Sin inscribir'}">
					<div class="col-md-6 col-xl-3">
						<div class="card widget-statstic-card">
							<div class="card-header">
								<div class="card-header-left">
									<h4>Liquidación IVA</h4>
									<h6 class="p-t-10 m-b-0 text-c-blue">Impuesto al Valor Agregado</h6>
									<br>
								</div>
							</div>
							<div class="card-block">
								<g:if test="${estadoIva == 'Presentada' || pagadoIva}">
									<i class="ti-check st-icon bg-c-green"></i>
								</g:if>
								<g:else>
									<i class="ti-more-alt st-icon bg-c-blue"></i>
								</g:else>
								<div class="text-left">
									<h3 class="d-inline-block">${(estadoIva == 'Sin liquidar') ? "-" : formatNumber(number: totalIva, type:'currency', currencySymbol:'$')}</h3>
									<g:if test="${estadoIva != 'Sin liquidar'}">
										<g:link controller="liquidacionIvaUsuario" action="show" id="${idIva}"><i class="icon-arrow-right-circle f-right" style="font-size:30px;"></i></g:link>
									</g:if>
								</div>

							</div>
							<div class="b-t-default">
								<div class="row m-0">
									<a href="#!" onclick="autorizarIVA();" style="${(estadoIva != 'Liquidado') ? 'display: none;' : ''}" class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar"><!-- Siempre se crea el botón para evitar errores, pero si es estado es diferente a liquidado lo ocultamos para que no puedan interactuar con él. -->
										<p class="m-0 text-uppercase d-inline-block">Autorizar</p>
									</a>
									<g:if test="${estadoIva == 'Presentada' || pagadoIva}">
										<div class="col-12 text-center p-t-15 p-b-15 btn-presentar ok" style="font-weight: 600;">
											<p class="m-0 text-uppercase d-inline-block">${pagadoIva ? "Pagada" : "Presentada"}</p>
											<i class="icon-emotsmile"></i>
										</div>
									</g:if>
									<g:elseif test="${estadoIva == 'Autorizada' || estadoIva == 'Sin liquidar'}">
										<div class="col-12 text-center p-t-15 p-b-15 btn-presentar" style="font-weight: 600;">
											<p class="m-0 text-uppercase d-inline-block">${(estadoIva == 'Autorizada') ? "Autorizada" : "Sin liquidar"}</p>
										</div>
									</g:elseif>
								</div>
							</div>
						</div>
					</div>
				</g:elseif>
				<!-- statstic card end -->
				<!-- statstic card start -->
				<g:if test="${servicioActivo}">
					<g:if test="${condicionIva != 'Sin inscribir'}">
						<g:if test="${regimen != 'Simplificado'}">
							<div class="col-md-6 col-xl-3">
								<div class="card widget-statstic-card">
									<div class="card-header">
										<div class="card-header-left">
											<h4>Liquidación - ${mesString}</h4>
											<h6 class="p-t-10 m-b-0 text-c-blue">Ingresos Brutos</h6>
											<br>
										</div>
									</div>
									<div class="card-block">
										<g:if test="${estadoIIBB == 'Presentada' || pagadoIIBB}">
											<i class="ti-check st-icon bg-c-green"></i>
										</g:if>
										<g:else>
											<i class="ti-more-alt st-icon bg-c-blue"></i>
										</g:else>
										<div class="text-left">
											<g:if test="${estadoIIBB == 'Sin liquidar'}">
												<h3 class="d-inline-block">-</h3>
											</g:if>
											<g:else>
												<g:if test="${aFavorIIBB==false}">
													<h3 class="d-inline-block">${formatNumber(number: totalIIBB, type:'currency', currencySymbol:'$')}</h3>
												</g:if>
												<g:else>
													<h3 class="d-inline-block">${formatNumber(number: saldoAFavorIIBB, type:'currency', currencySymbol:'$')} a favor</h3>
												</g:else>
											</g:else>

											<g:if test="${estadoIIBB != 'Sin liquidar'}">
												<g:link controller="liquidacionIibbUsuario" action="show" params="[mes:mes,ano:ano]"><i class="icon-arrow-right-circle f-right" style="font-size:30px;"></i></g:link>
											</g:if>
										</div>
									</div>
									<div class="b-t-default">
										<div class="row m-0">
											<a href="#!" id="btn-autorizar-iibb" onclick="onclickBtnAutorizar()" style="${(estadoIIBB != 'Liquidado') ? 'display: none;' : ''}" class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar"><!-- Siempre se crea el botón para evitar errores, pero si es estado es diferente a liquidado lo ocultamos para que no puedan interactuar con él. -->
												<p class="m-0 text-uppercase d-inline-block">Autorizar</p>
											</a>
											<g:if test="${estadoIIBB == 'Presentada' || pagadoIIBB}">
												<div class="col-12 text-center p-t-15 p-b-15 btn-presentar ok" style="font-weight: 600;">
													<p class="m-0 text-uppercase d-inline-block">${pagadoIIBB ? "Pagada" : "Presentada"}</p>
													<i class="icon-emotsmile"></i>
												</div>
											</g:if>
											<g:elseif test="${estadoIIBB == 'Autorizada' || estadoIIBB == 'Sin liquidar'}">
												<div class="col-12 text-center p-t-15 p-b-15 btn-presentar" style="font-weight: 600;">
													<p class="m-0 text-uppercase d-inline-block">${(estadoIIBB == 'Autorizada') ? "Autorizada" : "Sin liquidar"}</p>
												</div>
											</g:elseif>
										</div>
									</div>
								</div>
							</div>
						</g:if>
						<g:else>
							<div class="col-md-6 col-xl-3">
								<div class="card widget-statstic-card">
									<div class="card-header">
										<div class="card-header-left">
											<h4>Monotributo Simplificado</h4>
										</br>
											<div class="row">
											<h6 class="p-t-10 m-b-0 text-c-blue" style="margin-left: 15px ">Período</h6>
											<h6 class="p-t-10 m-b-0 text-c-blue" style="margin-left: 250px">Vencimiento</h6>
										</div>
										</div>
									</div>
									<div class="card-block">
										<div class="row m-0">
											<div class="text-left">
												<h3 class="d-inline-block">${volantePago?.getPeriodo() ?: "-"}</h3>
											</div>
											<div class="text-right">
												<h3 class="d-inline-block" style="margin-left: 215px">${fechaVencimiento ?: "-"}</h3>
											</div>
										</div>
									</div>
									<div class="b-t-default">
										<div class="row m-0">
											<g:if test="${volantePago}">
												<a href="/vep/download/${volantePago?.id}" id="btn-descargar-volante" class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar">
													<p class="m-0 text-uppercase d-inline-block">DESCARGAR</p>
												</a>
											</g:if>
											<g:else>
												<div class="col-12 text-center p-t-15 p-b-15 btn-presentar" style="font-weight: 600;">
													<p class="m-0 text-uppercase d-inline-block">Sin volante</p>
												</div>
											</g:else>
										</div>
									</div>
								</div>
							</div>
						</g:else>
					</g:if>
				</g:if>
				<g:else>
					<div class="col-md-6 col-xl-3">
						<div class="card widget-statstic-card">
							<div class="card-header">
								<div class="card-header-left">
									<h4>Soporte contable</h4>
									<h6 class="p-t-10 m-b-0 text-c-blue" style="margin-bottom: 21px;">soporte@calim.com.ar</h6>
								</div>
							</div>
							<div class="card-block">
								<i class="ti-receipt st-icon bg-c-blue"></i>
								<div class="text-left">
									<h3 class="d-inline-block">Obtener ayuda contable</h3>
								</div>
							</div>
							<div class="b-t-default">
								<div class="row m-0">
									<a href="/soporte" class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar">
										<p class="m-0 text-uppercase d-inline-block"> Contactar</p>
									</a>
								</div>
							</div>
						</div>
					</div>
				</g:else>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalClaveFiscal" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Ingresar Clave Fiscal</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">CUIT</label>
					<div class="col-sm-10">
						<input onkeyup="validarCuit($(this));" id="inputModalCuit" type="number" class="form-control" placeholder="Numero CUIT" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Clave Fiscal</label>
					<div class="col-sm-10">
						<input id="inputModalClaveFiscal" type="text" class="form-control" placeholder="Clave" value="">
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttonVolverClaveFiscal" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonIngresarClaveFiscal" type="button" class="btn btn-primary waves-effect waves-light " onclick="ingresarClaveFiscal();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalMonotributo" role="dialog">
   	<div class="modal-dialog modal-lg" role="document">
   		<div class="modal-content">
   			<div class="modal-header">
   				<h4 class="modal-title">Monotributo</h4>
   				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
    				<span aria-hidden="true">&times;</span>
   				</button>
    		</div>
   			<div class="modal-body">
				<div class="form-group row">
					<label class="col-sm-2 col-form-label" style="font-size: 18px"><b>Categoría:</b> </label>
					<label class="col-sm-10 col-form-label" style="font-size: 18px"> ${categoria} </label>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label" style="font-size: 18px"><b>Actividades:</b></label>
					<label class="col-sm-10 col-form-label" style="font-size: 18px">-${actividades?.join("<br/>")} </label>
				</div>
				<canvas id="myChart" width="300" height="200"></canvas>
				</br>
				<div class="form-group row">
					<label class="col-sm-6 col-form-label" style="font-size: 18px"> Máximo anual disponible: ${formatNumber(number: facturacionAnualMaxima, type:'currency', currencySymbol:'$')}</label>
				</div>
				<div class="form-group row">
					<label class="col-sm-6 col-form-label" style="font-size: 18px"> Facturado anual hasta hoy: ${formatNumber(number: facturacionAnualActual, type:'currency', currencySymbol:'$')}</label>
				</div>
				<div class="form-group row">
					<label class="col-sm-6 col-form-label" style="font-size: 18px"> Restante disponible: ${formatNumber(number: facturacionAnualRestante, type:'currency', currencySymbol:'$')}</label>
				</div>
				<div class="form-group row">
					<label class="col-sm-6 col-form-label" style="font-size: 18px">Disponible total mensual: ${formatNumber(number: promedioMensualCategoria, type:'currency', currencySymbol:'$')}</h6>
				</div>
				<div class="form-group row">
					<label class="col-sm-11 col-form-label" style="font-size: 18px"> <span style="color:red"><i class="icofont icofont-warning"></i> &nbsp Advertencia:</span> Si superás el limite de ${formatNumber(number: limiteServicios, type:'currency', currencySymbol:'$')} para Servicios o ${formatNumber(number: limiteProductos, type:'currency', currencySymbol:'$')} para Productos, te pasarán a la categoría de Autónomo</label>
				</div>
				<div class="form-group row">
					<label class="col-sm-11 col-form-label" style="font-size: 18px"> <span style="color:red"><i class="icofont icofont-warning"></i> &nbsp Advertencia:</span> Si vendés un producto a más de ${formatNumber(number: limiteVentaProducto, type:'currency', currencySymbol:'$')}, te pasarán a la categoría de Autónomo</label>
				</div>
      		</div>
   			<div class="modal-footer">			
   			</div>
    	</div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
<script type="text/javascript">
	var dniFrenteSubido = false;
	var dniDorsoSubido = false;
	var selfieSubido = false;
	var banderaBeforeSend = true;
	var ctx = document.getElementById('myChart').getContext('2d');
	var myChart = new Chart(ctx, {
	    type: 'bar',
	    data: {
	        labels: getMesesFacturacion(),
	        datasets: [{
	            label: 'Facturación mensual',
	            data: getDataMeses(),
	            backgroundColor: 'rgba(32, 145, 162, 1)',
	            borderColor: 'rgba(32, 158, 162, 1)',
	            borderWidth: 1
	        }]
	    },
	    options: {
	        scales: {
	            yAxes: [{
	                ticks: {
	                	callback: function(value, index, values) {
                        return '$' + value;
                    	},
	                    beginAtZero: true,
	                    min:0//,
	                    // max:$("#promedioMensualCategoria").val()
	                }
	            }]
	        }
	    }
	});


jQuery(document).ready(function() {

	if (${preguntarCF})
		alertarClaveFiscal()

	$("#stepsPasos").click();
	$("#stepsPasos").removeAttr("href");

	inicializarFilerFrenteDni();
	inicializarFilerDorsoDni();
	inicializarFilerSelfie();

	var fallbackToStore = function() {
		window.location.replace('market://details?id=com.myapp.package'); //Reemplazar con url del store
	};

	var openApp = function() {
	  window.location.replace('calim://calim.com.ar');
	};

	var triggerAppOpen = function() {
	  openApp();
	  setTimeout(fallbackToStore, 250);
	};


	/*if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
		console.log('Es mobile');
	}else{
		console.log('No');
	}*/

});
function alertarClaveFiscal(){
	swal("Todavía no podes facturar","Para poder hacerlo, debes obtener tu Clave Fiscal e ingresarla al sistema","error");
	$('#modalClaveFiscal').modal('show');
}

function onclickBtnAutorizar(){
	swal({
		title: "<g:message code='default.button.presentar.confirm.message' default='¿Estás seguro de que desea autorizar la presentación de IIBB?'/>",
		text: '${"Total: " + formatNumber(number: totalIIBB, type:"currency", currencySymbol:"\$")}',
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
			var urlString = $('#urlAutorizarIIBB').text();
			window.location.href = urlString.replace(/\s+/g, '');
		}
	});
}

function autorizarIVA(){
	swal({
		title: "<g:message code='default.button.presentar.confirm.message' default='¿Estás seguro de que desea autorizar la presentación de IVA?'/>",
		text: '${"Total: " + formatNumber(number: totalIva, type:"currency", currencySymbol:"\$")}',
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
			var urlString = $('#urlAutorizarIva').text();
			window.location.href = urlString.replace(/\s+/g, '');
		}
	});
}

function onclickBtnPagar(){
	$.ajax('${createLink(action:"ajaxLinkMercadoPago")}', {
		dataType: "json",
		data: {
		}
	}).done(function(data) {
		window.location.href = data.link		
	});
}

function ingresarClaveFiscal(){
	if (!cuitValido){
		swal("Hay un problema con tu clave", "El CUIT ingresado es inválido." ,"error");
		return
	}
	$("#loaderGrande").show()
	$.ajax('${createLink(controller:"cuenta",action:"ajaxCargarClaveFiscal")}', {
		dataType: "json",
		data: {
			cuit: $("#inputModalCuit").val(),
			claveFiscal: $("#inputModalClaveFiscal").val()
		}
	}).done(function(data) {
		$("#loaderGrande").hide()
		if(data.error)
			swal("Hay un problema con tu clave",data.error,"error");
		else{
			swal({
				title: "Clave guardada exitosamente!",
				text: "Ya estás a un paso de terminar tu trámite",
				type: "success",
				showCancelButton: false,
				confirmButtonClass: "btn-primary",
				confirmButtonText: "<g:message code='zifras.autorizar.ok' default='Siguiente'/>",
				closeOnConfirm: true
			},
			function(isConfirm) {
				window.location.href = "/dashboard/index?mensaje=" + escape("En 24 horas se generará tu punto de venta y podrás facturar. Gracias por confiar en nosotros.")
			});
		}
	});
}

function inicializarFilerFrenteDni(){
		var padre = $('#divPadreFrente');
		padre.empty();
		$("<input/>", {
		  id: "frenteDni_importar",
		  "type": "file",
		  "name": "fotoFrenteDni",
		  appendTo: padre
		});
		$('#frenteDni_importar').filer({
			uploadFile: {
				url: $('#urlImportFrenteDni').text(), //URL to which the request is sent {String}
			    type: 'POST', //The type of request {String}
			    enctype: 'multipart/form-data', //Request enctype {String}
			    synchron: true,
			    beforeSend: function(){
			    	if (banderaBeforeSend){
						banderaBeforeSend = false;
					}
			    },
			    success: function(resultado){
			    	document.getElementById("imagenFrenteDni").src = "/assets/tilde-verde.png";
			    	dniFrenteSubido = true;
			    	checkFinStep3();
			    },
			    onProgress: function(data){
			    	// Barra de porcentaje de subida de archivo
			    },
			    onComplete: function(){
					$("#frenteDni_importar").prop("jFiler").reset();
					banderaBeforeSend = true;
			    }
			},
			limit: null,
			maxSize: null,
			extensions: null,
			changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Arrastrá la foto acá</h3> <span style="display:inline-block; margin: 15px 0">ó</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Seleccionar archivo</a></div></div>',
			showThumbs: false,
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
	}

function inicializarFilerDorsoDni(){
		var padre = $('#divPadreDorso');
		padre.empty();
		$("<input/>", {
		  id: "dorsoDni_importar",
		  "type": "file",
		  "name": "fotoDorsoDni",
		  appendTo: padre
		});
		$('#dorsoDni_importar').filer({
			uploadFile: {
				url: $('#urlImportDorsoDni').text(), //URL to which the request is sent {String}
			    type: 'POST', //The type of request {String}
			    enctype: 'multipart/form-data', //Request enctype {String}
			    synchron: true,
			    beforeSend: function(){
			    	if (banderaBeforeSend){
						banderaBeforeSend = false;
					}
			    },
			    success: function(resultado){
			    	document.getElementById("imagenDorsoDni").src = "/assets/tilde-verde.png";
			    	dniDorsoSubido = true;
			    	checkFinStep3();
			    },
			    onProgress: function(data){
			    	// Barra de porcentaje de subida de archivo
			    },
			    onComplete: function(){
					$("#dorsoDni_importar").prop("jFiler").reset();
					banderaBeforeSend = true;
			    }
			},
			limit: null,
			maxSize: null,
			extensions: null,
			changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Arrastrá la foto acá</h3> <span style="display:inline-block; margin: 15px 0">ó</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Seleccionar archivo</a></div></div>',
			showThumbs: false,
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
	}

function inicializarFilerSelfie(){
		var padre = $('#divPadreSelfie');
		padre.empty();
		$("<input/>", {
		  id: "selfie_importar",
		  "type": "file",
		  "name": "fotoSelfie",
		  appendTo: padre
		});
		$('#selfie_importar').filer({
			uploadFile: {
				url: $('#urlImportSelfie').text(), //URL to which the request is sent {String}
			    type: 'POST', //The type of request {String}
			    enctype: 'multipart/form-data', //Request enctype {String}
			    synchron: true,
			    beforeSend: function(){
			    	if (banderaBeforeSend){
						banderaBeforeSend = false;
					}
			    },
			    success: function(resultado){
			    	document.getElementById("colSelfie").className = "col-md-4";
			    	document.getElementById("imagenSelfie").style.marginTop = "20px";
			    	document.getElementById("imagenSelfie").src = "/assets/tilde-verde.png";
			    	selfieSubido = true;
			    	checkFinStep3();
			    },
			    onProgress: function(data){
			    	// Barra de porcentaje de subida de archivo
			    },
			    onComplete: function(){
					$("#selfie_importar").prop("jFiler").reset();
					banderaBeforeSend = true;
			    }
			},
			limit: null,
			maxSize: null,
			extensions: null,
			changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Arrastrá la foto acá</h3> <span style="display:inline-block; margin: 15px 0">ó</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Seleccionar archivo</a></div></div>',
			showThumbs: false,
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
	}

function getMesesFacturacion(){
	var today = new Date();
	var primerSemestre = "01,02,03,04,05,06"
	var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!

	if(primerSemestre.includes(mm))
		return ["07","08","09","10","11","12","01","02","03","04","05","06"]
	else 
		return ["01","02","03","04","05","06","07","08","09","10","11","12"]
}

function actualizarDomicilio(){

	$.ajax('${createLink(controller:"cuenta",action:"ajaxActualizarDomicilio")}', {
		dataType: "json",
		data: {
			direccion: $("#inputDireccion").val(),
			codigoPostal: $("#inputCodigoPostal").val()
		}
	}).done(function(data) {
		if(data.error)
			swal("Hay un problema con la direccion ingresada",data.error,"error");
		else{
			swal({
				title: "Domicilio actualizado exitosamente!",
				text: "Ahora podemos continuar con tu alta de Monotributo",
				type: "success",
				showCancelButton: false,
				confirmButtonClass: "btn-primary",
				confirmButtonText: "<g:message code='zifras.autorizar.ok' default='Siguiente'/>",
				closeOnConfirm: true
			},
			function(isConfirm) {
				window.location.reload();
			});
		}
	});
}

function checkFinStep3(){
	
	if(dniFrenteSubido && dniDorsoSubido && selfieSubido){
		swal({
				title: "¡Fotos subidas exitosamente!",
				text: "Ya completaste tu trámite, en los próximos días te enviaremos tu constancia de monotributo",
				type: "success",
				showCancelButton: false,
				confirmButtonClass: "btn-primary",
				confirmButtonText: "<g:message code='zifras.autorizar.ok' default='Finalizar'/>",
				closeOnConfirm: true
			},
			function(isConfirm) {
				if (isConfirm) {
					window.location.reload();
				}
			});
	}

}

function getDataMeses(){
	var valoresString = $("#facturacionMensualCuenta").val().replace('[','').replace(']','').split(', ')
	var valores = Array.from(valoresString, x =>  parseInt(x));

	return valores
}

</script>
</body>
</html>
