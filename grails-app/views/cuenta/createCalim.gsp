<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-8">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="default.add.label" default="Agregar {0}" args="['Cuenta']"/></h4>
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
				<div class="col-sm-12">
					<!-- Basic Form Inputs card start -->
					<div class="card">
						<div class="card-block">
							<h4 class="sub-title">Cuenta</h4>
							<g:form action="saveCalim">
								<!-- Inicio del form -->
								<div id="alertaDescuento" class="alert alert-info icons-alert" style="display: none">
		                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
		                                <i class="icofont icofont-close-line-circled"></i>
		                            </button>
		                            <p><strong>Info!</strong> A esta cuenta se le aplicará un descuento por comerciar con MercadoPago / MercadoLibre</p>
		                        </div>
								<div class="form-group row">
									<label class="col-sm-2 col-form-label">Nombre y Apellido</label>
									<div class="col-sm-10">
										<input name="nombre" type="text" class="form-control" placeholder="Nombre de contacto">
									</div>
								</div>
								<div class="form-group row">
									<label class="col-sm-2 col-form-label">Email</label>
									<div class="col-sm-10">
										<input name="email" type="text" class="form-control" placeholder="Correo" style="text-transform: lowercase;">
									</div>
								</div>
								<div class="form-group row">
									<label class="col-sm-2 col-form-label">Teléfono</label>
									<div class="col-sm-10">
										<input name="telefono" type="text" class="form-control" placeholder="Celular">
									</div>
								</div>
								<div class="form-group row">
									<label class="col-sm-2 col-form-label">ID Deal Bitrix</label>
									<div class="col-sm-10">
										<input name="bitrixId" type="text" class="form-control" placeholder="Ingrese el ID del Deal. Deje en blanco para generar un nuevo contacto y negociación.">
									</div>
								</div>
								<div class="form-group row">
									<label class="col-sm-2 col-form-label">Servicios Iniciales</label>
									<div class="col-sm-10">
										<select id="cbServicio" name="servicios" multiple></select>
									</div>
								</div>
								<div id="divDetalleServicio" style="display: none;">
									<div class="form-group row">
										<label class="col-sm-2 col-form-label">Importe</label>
										<div class="col-sm-10">
											<div class="input-group">
												<span class="input-group-addon" id="basic-addon1">$</span>
												<input id="importe" name="total" type="text" class="form-control autonumber" value="0,00" data-a-sep="" data-a-dec=",">
											</div>
										</div>
									</div>
									<div class="form-group row">
										<label class="col-sm-2 col-form-label">Comentario</label>
										<div class="col-sm-10">
											<input name="comentarioServicio" id="comentarioServicio" type="text" class="form-control" placeholder="Detalle sobre el/los trámites a realizar">
										</div>
									</div>
									<div class="form-group row">
										<label class="col-sm-2 col-form-label">Cantidad Cuotas</label>
										<div class="col-sm-10">
											<div class="input-group">
												<input id="cuotas" name="cuotas" type="text" class="form-control" value="1" onkeypress='return isNumberKey(event)'>
											</div>
										</div>
									</div>
									<div class="form-group row">
										<label class="col-sm-2 col-form-label">Primer pago</label>
										<div class="col-sm-10">
											<input name="primerPago" id="fecha" type="text" class="form-control" data-format="d/m/Y" placeholder="Seleccione un día" value="${new org.joda.time.LocalDate().toString('dd/MM/yyyy')}">
										</div>
									</div>
								</div>

								<div class="form-group row">
									<label class="col-sm-2 col-form-label">Mercado Libre</label>
									<div class="col-sm-10">
										<div class="checkbox-fade fade-in-primary" style="margin-top: 4px">
											<label class="check-task">
												<input  type="checkbox" name="mercadoLibre" id="checkboxMercadoLibre">
												<span class="cr">
													<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
												</span>
											</label>
										</div>
										
									</div>
								</div>

								<!-- Fin del form -->
								<div class="row">
									<label class="col-sm-2"></label>
									<div class="col-sm-10">
										<button type="submit" class="btn btn-primary m-b-0">Aceptar</button>
										<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
									</div>
								</div>
							</g:form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(document).ready(function () {

		/*** CBO SERVICIO ***/
			$("#cbServicio").select2({
				placeholder: '<g:message code="zifras.servicio.Servicio.placeHolder" default="Ningún servicio seleccionado"/>',
				formatNoMatches: function() {
					return '<g:message code="default.no.elements" default="No hay elementos"/>';
				},
				formatSearching: function() {
					return '<g:message code="default.searching" default="Buscando..."/>';
				},
				minimumResultsForSearch: 1,
				allowClear:true,
				formatSelection: function(item) {
					return item.text;
				}
			});
			llenarCombo({
				comboId : "cbServicio",
				ajaxLink : '${createLink(controller:"servicio", action:"ajaxGetServiciosEspeciales")}',
				atributo : 'toString',
				idDefault: '' //Lo paso vacío porque si no se selecciona el primero
			});
			$("#cbServicio").change(function () {
				if ($("#cbServicio").val().length){
					$.ajax("${createLink(controller:'servicio', action:'ajaxGetServiciosPorId')}", {
						dataType: "json",
						data: {ids: $("#cbServicio").val()}
					}).done(function(servicios) {
						let sumatoria = 0;
						for (index in servicios){
							sumatoria += servicios[index].precio
						}
						$("#importe").val(sumatoria.toFixed(2).replace(".", ","))
					});
					$('#divDetalleServicio').show()
				}else
					$('#divDetalleServicio').hide()
			});
		/*** Fechas ***/
			$("#fecha").dateDropper( {
				dropWidth: 200,
				dropPrimaryColor: "#1abc9c", 
				dropBorder: "1px solid #1abc9c",
				dropBackgroundColor: "#FFFFFF",
				format: "d/m/Y",
				lang: "es"
			});

			$("#checkboxMercadoLibre").click(function(){
				$("#alertaDescuento").toggle();
			});

	});
</script>
</body>
</html>