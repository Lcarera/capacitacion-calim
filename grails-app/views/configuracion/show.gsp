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
				<div class="col-md-8 offset-md-2 col-sm-12">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4>Configuración</h4>
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
				<div class="col-md-8 offset-md-2 col-sm-12">
					<div class="card">
						<div class="card-block user-detail-card">							
							
						<g:form action="update">
							<g:hiddenField name="cuentaId" value="${cuentaInstance?.id}" />
							<g:hiddenField name="version" value="${cuentaInstance?.version}" />

							<div class="form-group row">
								<label class="col-sm-2 col-form-label">CBU</label>
								<div class="col-sm-10">
									<input name="cbu" type="text" class="form-control ${hasErrors(bean: cuentaInstance, field: 'cbu', 'form-control-danger')}" placeholder="" value="${cuentaInstance?.cbu}">
								</div>
							</div>

							<div class="form-group row">
								<label class="col-sm-2 col-form-label">Medio de pago para VEPs</label>
								<div class="col-sm-10">
									<select id="cbMedioPago" name="medioPagoId" class="form-control"></select>
								</div>
							</div>

							<div style="${cuentaInstance.aplicaIva ? ' ' : 'display:none;'}" class="form-group row">
								<label class="col-sm-2 col-form-label">Máx. Autoautorizar IVA</label>
								<div class="col-sm-10 input-group">
									<span class="input-group-addon" id="basic-addon1">$</span>
									<input id="maximoAutorizarIva" name="maximoAutorizarIva" value="${cuentaInstance?.maximoAutorizarIva}"class="form-control autonumber ${hasErrors(bean: cuentaInstance, field: 'maximoAutorizarIva', 'form-control-danger')}"data-a-sep="" data-a-dec="," placeholder="Deje en blanco para no autorizar automáticamente."></input>
								</div>
							</div>

							<div style="${cuentaInstance.aplicaIIBB ? ' ' : 'display:none;'}" class="form-group row">
								<label class="col-sm-2 col-form-label">Máx. Autoautorizar IIBB</label>
								<div class="col-sm-10 input-group">
									<span class="input-group-addon" id="basic-addon1">$</span>
									<input id="maximoAutorizarIIBB" name="maximoAutorizarIIBB" value="${cuentaInstance?.maximoAutorizarIIBB}"class="form-control autonumber ${hasErrors(bean: cuentaInstance, field: 'maximoAutorizarIIBB', 'form-control-danger')}"data-a-sep="" data-a-dec="," placeholder="Deje en blanco para no autorizar automáticamente."></input>
								</div>
							</div>

							<div class="col-sm-12">
								<div class="checkbox-fade fade-in-primary">
									<label class="check-task">
										<input id="checkNotificaciones" name="recibirNotificaciones" type="checkbox" value="true">
										<span class="cr">
											<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
										</span>
										<span>Recibir notificaciones</span>
									</label>
								</div>
							</div>

							<div class="col-sm-12">
								<div class="checkbox-fade fade-in-primary">
									<label class="check-task">
										<input id="checkPromociones" name="recibirPromociones" type="checkbox" value="true">
										<span class="cr">
											<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
										</span>
										<span>Recibir contenido promocional</span>
									</label>
								</div>
							</div>

							<div id="divNotificaciones" style="margin-left:10px">
								<div class="col-sm-12">
									<div class="checkbox-fade fade-in-primary">
										<label class="check-task">
											<span>Recibir notificaciones de VEPS</span>
											<input id="checkNotificacionesVEPS" name="recibirNotificacionVep" type="checkbox" value="true">
											<span class="cr">
												<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
											</span>
											
										</label>
									</div>
								</div>

								<div class="col-sm-12">
									<div class="checkbox-fade fade-in-primary">
										<label class="check-task">
											<input id="checkNotificacionesDDJJ" name="recibirNotificacionDeclaracionJurada" type="checkbox" value="true">
											<span class="cr">
												<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
											</span>
											<span>Recibir notificaciones de DDJJ</span>
										</label>
									</div>
								</div>

								<div class="col-sm-12">
									<div class="checkbox-fade fade-in-primary">
										<label class="check-task">
											<input id="checkNotificacionesFC" name="recibirNotificacionFacturaCuenta" type="checkbox" value="true">
											<span class="cr">
												<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
											</span>
											<span>Recibir notificaciones de Facturacion</span>
										</label>
									</div>
								</div>
							</div>	

							<div class="row">
								<div class="col-sm-12">
									<h4 class="sub-title"></h4>
									
									<button type="submit" class="btn btn-primary m-b-0">Aceptar</button>

									<g:link class="btn btn-inverse m-b-0" controller="dashboard" action="index"><g:message code="default.button.back.label" default="Volver" /></g:link>
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
	
	if("${cuentaInstance?.recibirNotificaciones}" == "true"){
		$("#checkNotificaciones").prop('checked', true);
		$("#divNotificaciones").show();
	}
	else{
		$("#checkNotificaciones").prop('checked', false);
		$("#divNotificaciones").hide();
	}

	if("${cuentaInstance?.recibirNotificacionVep}" == "true"){
		$("#checkNotificacionesVEPS").prop('checked', true);
	}
	else{
		$("#checkNotificacionesVEPS").prop('checked', false);
	}

	if("${cuentaInstance?.recibirNotificacionDeclaracionJurada}" == "true"){
		$("#checkNotificacionesDDJJ").prop('checked', true);
	}
	else{
		$("#checkNotificacionesDDJJ").prop('checked', false);
	}

	if("${cuentaInstance?.recibirNotificacionFacturaCuenta}" == "true"){
		$("#checkNotificacionesFC").prop('checked', true);
	}
	else{
		$("#checkNotificacionesFC").prop('checked', false);
	}

	$( "#checkNotificaciones").change(function() {
		$("#divNotificaciones").toggle();
		
	});

	$("#cbMedioPago").select2({
		placeholder: 'Seleccione medio de pago',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: 1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbMedioPago",
		ajaxLink : '${createLink(controller:"cuenta", action:"ajaxGetMediosPago")}',
		idDefault : '${cuentaInstance?.medioPagoId}',
		parametros : {
			'regimenIibbId' : "${cuentaInstance?.regimenIibb?.id}",
			'condicionIvaId' : "${cuentaInstance?.condicionIva?.id}"
		}
	});

});
</script>
</body>
</html>