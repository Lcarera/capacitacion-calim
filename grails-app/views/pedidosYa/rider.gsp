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
	</head>
	<body>
		<g:hiddenField id="claveFiscal" name="claveFiscal" value="${claveFiscal}"/>
		<g:hiddenField id="puntoVentaCalim" name="puntoVentaCalim" value="${puntoVentaCalim}"/>
		<div style="display: none;">
			<div style="display: none;">
			<div id="urlCargarClaveFiscal">
				<g:createLink controller="cuenta" action="ajaxCargarClaveFiscal" />
			</div>
		</div>
		</div>
		<div class="main-body">
			<div class="page-wrapper">
				<div class="page-body">
					<div class="page-header card">
						<div class="row align-items-end">
							<div class="col-lg-12">
								<div class="page-header-title">
									<div class="d-inline">
										<h4>Semana del ${semana}</h4>
										<h4>Importe ${estado != 'Verificada' ? 'a facturar' : 'facturado'}: $${importe}</h4>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<!-- Inicio bloque -->
						<div class="col-md-6 col-xl-3" style="${(estado == 'Verificada' && ! facturadoCalim) ? 'display: none;' :''}">
							<div class="card widget-statstic-card">
								<div class="card-header">
									<div class="card-header-left">
										<h4>Factura Electrónica</h4>
										<h6 class="p-t-10 m-b-0 text-c-blue">¡Facturá en un click con CALIM!</h6>
									</div>
								</div>
								<div class="card-block">
									<g:if test="${estado == 'Verificada'}">
										<i class="ti-check st-icon bg-c-green"></i>
									</g:if>
									<g:else>
										<i class="ti-more-alt st-icon bg-c-blue"></i>
									</g:else>
									<g:if test="${estado != 'Verificada'}">
										<div class="text-left">
											<a id="btnCrearFactura" href=""><i class="icon-plus f-right" style="font-size:30px;"></i></a>
										</div>
									</g:if>
								</div>
								<div class="b-t-default">
									<div class="row m-0">
										<a href="${raw(createLink(controller:'facturaVentaUsuario', action:'list'))}" class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar">
											<p class="m-0 text-uppercase d-inline-block">Ver</p>
										</a>
									</div>
								</div>
							</div>
						</div>
						<!-- Fin -->
						<!-- Inicio bloque -->
						<div class="col-md-6 col-xl-3" style="${(estado == 'Verificada' && facturadoCalim) ? 'display: none;' :''}">
							<div class="card widget-statstic-card">
								<div class="card-header">
									<div class="card-header-left">
										<h4>Subir Factura de AFIP</h4>
										<h6 class="p-t-10 m-b-0 text-c-blue">Descargalo de AFIP y subilo</h6>
									</div>
								</div>
								<div class="card-block">
									<g:if test="${estado == 'Verificada'}">
										<i class="ti-check st-icon bg-c-green"></i>
									</g:if>
									<g:else>
										<i class="ti-more-alt st-icon bg-c-blue"></i>
									</g:else>
									<g:if test="${estado != 'Verificada'}">
										<div class="text-left">
											<a href=""  id="btnImportarFactura"><i class="ti-arrow-circle-up f-right" style="font-size:30px;"></i></a>
										</div>
									</g:if>
								</div>
								<div class="b-t-default">
									<div class="row m-0">
										<a href="${raw(createLink(controller:'facturaVentaUsuario', action:'list'))}" class="col-12 btn-primary text-center p-t-15 p-b-15 btn-presentar">
											<p class="m-0 text-uppercase d-inline-block">Ver</p>
										</a>
									</div>
								</div>
							</div>
						</div>
						<!-- Fin -->
					</div>
				</div>
			</div>

			<div class="modal fade" id="modalImport" tabindex="-1" role="dialog">
				<div class="modal-dialog modal-lg" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4>Importar Factura</h4>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<div class="form-group row">
								<div class="col-sm-12">
									<input type="file" name="archivo" id="modalArchivo">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="modal fade" id="modalClaveFiscal" tabindex="-1" role="dialog">
				<div class="modal-dialog modal-lg" role="document">
					<div class="modal-content">
						<div class="modal-header">
							<h4>Configurar Clave Fiscal</h4>
							<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<div class="col-sm-12">
								<h5>Para poder facturar fácilmente con Calim, necesitamos que ingreses tu clave fiscal para poder vincular correctamente tu cuenta con la AFIP:</h5>
							</div>
							</br>
							<div class="col-sm-12">
								<input type="text" class="form-control" name="claveFiscalInput" placeholder="Clave Fiscal" id="claveFiscalInput">
							</div>
							</br>
							<div class="col-sm-12">
								<h5>Cómo obtener tu clave fiscal:</h5>
							</div>
							</br>
							<div class="col-sm-12">
								<iframe  width="100%" height="400" src="https://www.youtube.com/embed/bfy5pHV4RAQ" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
							</div>	
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
 							<button type="button" class="btn btn-primary waves-effect waves-light " onclick="cargarClaveFiscal()">Confirmar</button>
						</div>
					</div>
				</div>
			</div>

		</div>
		<script type="text/javascript">
			jQuery(document).ready(function() {

				document.getElementById("btnImportarFactura").onclick = function(){
					if (${!!proformaId})
						$('#modalImport').modal('show');
					else
						swal({
							title: "Atencion",
							text: "Actualmente no hay ninguna proforma disponible para facturar.",
							type: "warning",
							confirmButtonClass: "btn-danger",
							confirmButtonText: "<g:message code='zifras.delete.ok' default='Aceptar'/>",
							closeOnConfirm: true,
						},
						function(isConfirm) {});
					return false
				}

				document.getElementById("btnCrearFactura").onclick = function(){
					if(($("#puntoVentaCalim").val() != "true")){
						if($("#claveFiscal").val() != "")
							swal({
								title: "Atencion",
								text: "Su punto de venta electrónico está siendo configurado, dentro de las próximas 48hs te habilitaremos la facturación electrónica",
								type: "warning",
								confirmButtonClass: "btn-danger",
								confirmButtonText: "<g:message code='zifras.delete.ok' default='Aceptar'/>",
								closeOnConfirm: true,
							},
							function(isConfirm) {
								if (isConfirm) {
									console.log("Si");
								}
							});
						else
							$('#modalClaveFiscal').modal('show');
					}else{
						if (${!!proformaId})
							window.location.href = "${raw(createLink(controller:'facturaVentaUsuario', action:'create', params:[proformaId:proformaId]))}"
						else
							swal({
								title: "Atencion",
								text: "Actualmente no hay ninguna proforma disponible para facturar.",
								type: "warning",
								confirmButtonClass: "btn-danger",
								confirmButtonText: "<g:message code='zifras.delete.ok' default='Aceptar'/>",
								closeOnConfirm: true,
							},
							function(isConfirm) {});
					}
					return false
				};

					$('#modalArchivo').filer({
					uploadFile: {
						url: "${raw(createLink(controller:'importacion', action:'pdfPedidosYa'))}",
						type: 'POST', //The type of request {String}
						data: {
							proformaId: "${proformaId}"
						},
						enctype: 'multipart/form-data', //Request enctype {String}
						synchron: true,
						beforeSend: function () {
							$("#loaderGrande").fadeIn()
						},
						success: function (resultado) {
							if (resultado.ok)
								window.location.reload();
							else{
								$("#loaderGrande").fadeOut()
								$('#modalImport').modal('hide');
								swal("Error", resultado.error, "error");
							}
						},
						onProgress: function (data) {},
						onComplete: function () {}
					},
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
			
			function claveFiscalValida(){
				let clave = $("#claveFiscalInput").val();
				return clave.length >= 6 
			}

			function cargarClaveFiscal(){
				$("#modalClaveFiscal").modal('hide');
				if(claveFiscalValida()){
					$.ajax($("#urlCargarClaveFiscal").text(), {
						dataType: "json",
						data: {
							claveFiscal:$("#claveFiscalInput").val()
						}
					}).done(function(data){
						if(data.hasOwnProperty('error')){
							setTimeout(function() {
				  				swal("Error", data['error'], "error");
				    		}, 400);
						}
						else{
				  				swal({
									title: "Clave Fiscal actualizada!",
									text: "Dentro de las próximas 48 hs podrás facturar fácilmente con Calim",
									type: "success",
									confirmButtonClass: "btn-success",
									confirmButtonText: "Aceptar",
									closeOnConfirm: true,
								},
								function(isConfirm) {
									if (isConfirm) {
										location.reload();
									}
								});
				    	}
					});
				}
				else{
					swal("Error","La clave fiscal no puede tener menos de 10 caracteres", "error");_
				}
			}

		</script>
	</body>
</html>
