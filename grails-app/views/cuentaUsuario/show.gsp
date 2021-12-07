<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<%@ page import="com.zifras.User" %>
<div style="display: none;">
	<div id="urlUpdateCuenta">
		<g:createLink action="ajaxUpdate"/>
	</div>
	<div id="urlUpdatePassword">
		<g:createLink controller="usuario" action="ajaxUpdatePassword"/>
	</div>
</div>
<g:hiddenField name="selectedApps" id="selectedApps"/>
<g:hiddenField name="appsCuenta" value="${appsCuenta}" />

<div class="main-body">
	<div class="page-wrapper">
		<div class="page-body">
			<div class="row">
				<div class="col-md-12 col-lg-7">
					<div class="card">
						<div class="card-header">
							<div class="card-header-left">
								<h4>Mi Perfil</h4>
							</div>
							<div id="botonEdit" class="card-header-right">
								<i class="ti-pencil-alt" style="font-size: 26px;" onclick="editCuenta();"></i>
							</div>
						</div>
						<div class="card-block user-detail-card">
							<div class="row">
								<div class="col-md-12 col-lg-3">
									<asset:image src="widget/Group-user.jpg" class="img-fluid p-b-10"/>
								</div>
								<div class="col-md-12 col-lg-9 user-detail">

									<div class="row">
										<div class="col-md-5 col-lg-4">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-file-text"></i>CUIT</h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<h6 class="m-b-30">${cuentaInstance?.cuit}</h6>
										</div>
									</div>

									<g:if test="${cuentaInstance?.cuitRepresentante}">
										<div class="row">
											<div class="col-md-5 col-lg-4">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-file-text"></i>CUIT Representante</h6>
											</div>
											<div class="col-md-7 col-lg-8">
												<h6 class="m-b-30">${cuentaInstance?.cuitRepresentante}</h6>
											</div>
										</div>
									</g:if>

									<div class="row">
										<div class="col-md-5 col-lg-4">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-fax"></i><g:message code="zifras.cuenta.Cuenta.razonSocial.label" default="Razón Social" /></h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<h6 id="razonSocialLabel" class="m-b-30">${cuentaInstance?.razonSocial}</h6>
											<input id="razonSocialInput" type="text" class="form-control" style="display: none;">
										</div>
									</div>

									<div class="row">
										<div class="col-md-5 col-lg-4">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-user"></i><g:message code="zifras.cuenta.Cuenta.nombreApellido.label" default="Nombre" /></h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<h6 id="nombreApellidoLabel" class="m-b-30">${cuentaInstance?.nombreApellido}</h6>
											<input id="nombreApellidoInput" type="text" class="form-control" style="display: none;">
										</div>
									</div>

									<div class="row">
										<div class="col-md-5 col-lg-4">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-email"></i>email</h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<h6 class="m-b-30"><a href="mailto:${cuentaInstance?.email}">${cuentaInstance?.email}</a></h6>
										</div>
									</div>

									<div class="row">
										<div class="col-md-5 col-lg-4">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-touch-phone"></i>Teléfono</h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<h6 id="telefonoLabel" class="m-b-30">${cuentaInstance?.telefono}</h6>
											<input id="telefonoInput" type="text" class="form-control" style="display: none;">
										</div>
									</div>

									<div class="row">
										<div class="col-md-5 col-lg-4">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-brand-whatsapp"></i>Whatsapp</h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<h6 id="whatsAppLabel" class="m-b-30">${cuentaInstance?.whatsapp}</h6>
											<input id="whatsAppInput" type="text" class="form-control" style="display: none;">
										</div>
									</div>

									<g:if test="${cuentaInstance?.locales.direccion}">
										<div class="row">
											<div class="col-md-5 col-lg-4">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-web"></i>Domicilio Fiscal</h6>
											</div>
											<div class="col-md-7 col-lg-8">
												<h6 class="m-b-30">${cuentaInstance?.locales.direccion[0]}</h6>
											</div>
										</div>
									</g:if>

									<g:if test="${cuentaInstance?.profesion}">
										<div class="row">
											<div class="col-md-5 col-lg-4">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-web"></i><g:message code="zifras.cuenta.Cuenta.profesion.label" default="Profesion" /></h6>
											</div>
											<div class="col-md-7 col-lg-8">
												<h6 id="profesionLabel" name="profesion" class="m-b-30">${cuentaInstance?.profesion}</h6>
											</div>
										</div>
									</g:if>

									<div class="row" id="checkApps" style="display: none">
										<div class="col-md-5 col-lg-4">
											<h6 class="f-w-400 m-b-30" id="appLabel"><i class="icofont icofont-web"></i><g:message code="zifras.cuenta.Cuenta.apps.label" default="Apps" /></h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<h6 id="appsLabel" class="m-b-30" style="display: none">${cuentaInstance?.apps.each{i->i.toString()}.toString().replace("[","").replace("]","")}</h6>
											<div id="cbApps" class="checkbox-fade fade-in-primary" style="display: none">
												<g:each in="${apps}">
											        <label>
											            <input type="checkbox" id="${it.nombre}" name="apps" value="${it.nombre}">
											            <span class="cr">
											                <i class="cr-icon icofont icofont-ui-check txt-primary"></i>
											            </span>
											            <span>${it.nombre}</span>
											        </label>
											    </g:each>
										    </div>
										</div>
									</div>

									<g:if test="${cuentaInstance?.condicionIva}">
										<div class="row">
											<div class="col-md-5 col-lg-4">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-file-file"></i>Condición IVA</h6>
											</div>
											<div class="col-md-7 col-lg-8">
												<h6 class="m-b-30">${cuentaInstance?.condicionIva?.nombre}</h6>
											</div>
										</div>
									</g:if>	

									<g:if test="${cuentaInstance?.regimenIibb}">
										<div class="row">
											<div class="col-md-5 col-lg-4">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-file-file"></i>Régimen IIBB</h6>
											</div>
											<div class="col-md-7 col-lg-8">
												<h6 class="m-b-30">${cuentaInstance?.regimenIibb?.nombre}</h6>
											</div>
										</div>
									</g:if>

									<g:if test="${cuentaInstance?.condicionIva.nombre == 'Responsable inscripto'}">
										<div class="row">
											<div class="col-md-5 col-lg-4">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-file-file"></i>Medio de Pago IVA</h6>
											</div>
											<div class="col-md-7 col-lg-8">
												<h6 id="medioPagoIvaLabel" class="m-b-30">${cuentaInstance?.medioPagoIva?.nombre ?: '-'}</h6>
												<div id="divMedioPagoIva" style="display: none">
													<select id="cbMedioPagoIva" name="medioPagoIvaId" class="form-control"></select>
												</div>
											</div>
										</div>
									</g:if>	

									<div class="row">
										<div class="col-md-5 col-lg-4">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-file-file"></i>Medio de Pago IIBB</h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<h6 id="medioPagoIibbLabel" class="m-b-30">${cuentaInstance?.medioPagoIibb?.nombre ?: '-'}</h6>
											<div id="divMedioPagoIibb" style="display: none">
												<select id="cbMedioPagoIibb" name="medioPagoIibbId" class="form-control"></select>
											</div>
										</div>
									</div>
									
									<g:if test="${cuentaInstance.servicioActivo != null}">
										<div class="row">
											<div class="col-md-5 col-lg-4">
												<h6 id="debAutomaticoLabel" class="f-w-400 m-b-30"><i class="icofont icofont-credit-card"></i>Débito Automático</h6>
											</div>
											<div class="col-md-7 col-lg-8">
												<h6 id="tarjetaLabel" class="m-b-30">${cuentaInstance?.tarjetaDebitoAutomatico ? "Si" : "No"} ${cuentaInstance?.tarjetaDebitoAutomatico?.visa ? '| Visa' : (cuentaInstance?.tarjetaDebitoAutomatico?.mastercard ? '| Mastercard' : '')} ${cuentaInstance?.tarjetaDebitoAutomatico?.numeroOculto}</h6>
												<input id="tarjetaInput" type="text" class="form-control" onclick="showAlertCredito()" placeholder="Número Tarjeta de Crédito" maxlength="16" value="${cuentaInstance?.tarjetaDebitoAutomatico?.numero}" style="display: none;">
											</div>
										</div>
									</g:if>
									<input style="display:none"></input>
									<div id="divBtnContrasena" class="row">
										<div class="col-md-5 col-lg-4">
											<h6 id="contrasenaLabel" class="f-w-400 m-b-30"><i class="icofont icofont-ui-password"></i>Contraseña</h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<h6 class="cuentaUsuario-contrasena btn btn-primary btn-mini waves-effect waves-light" onclick="toggleContrasena();">Cambiar Contraseña</h6>
											<input id="contrasenaAnterior" type="password" class="form-control cuentaUsuario-contrasena" style="display: none;">
										</div>
									</div>

									<div class="row cuentaUsuario-contrasena" style="display: none;">
										<div class="col-md-5 col-lg-4">
											<h6 class="f-w-400 m-b-30">Nueva contraseña</h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<input id="contrasenaNueva1" type="password" class="form-control">
										</div>
									</div>

									<div class="row cuentaUsuario-contrasena" style="display: none;">
										<div class="col-md-5 col-lg-4">
											<h6 class="f-w-400 m-b-30">Nueva contraseña (repetir)</h6>
										</div>
										<div class="col-md-7 col-lg-8">
											<input id="contrasenaNueva2" type="password" class="form-control">
										</div>
									</div>

									<div class="row" id="rowBotones" style="text-align:right; display: none; margin-top: 5px;">
										<label class="col-sm-2"></label>
										<div class="col-sm-10">
											<button id="btn" class="btn btn-primary m-b-0" onclick="cambioPassword ? savePassword() : saveCuenta();">Actualizar</button>
											<button class="btn btn-inverse m-b-0" onclick="cambioPassword ? toggleContrasena() : toggleEditMode();">Cancelar</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	var cambioPassword = false;
	var alertaCredito = false;
	var selected = [];
	$(document).ready(function() {

		if("${cuentaInstance.tarjetaDebitoAutomatico?.mastercard}" == "true")
			$("#mastercard").prop("checked", true);
		else
			$("#visa").prop("checked", true);


		if("${cuentaInstance.tarjetaDebitoAutomatico?.debito}" == "true")
			$("#debito").prop("checked", true);
		else
			$("#credito").prop("checked", true);
		
		$('#btn').click(function(){
			$(":checkbox[name=apps]").each(function() {
			if (this.checked) {
				selected.push($(this).val());
			}
		});
		})

		if("${cuentaInstance.profesion}"=="app"){
			if($("#appsCuenta").val() != "[]"){
		   		var apps = $("#appsCuenta").val().slice(1,$("#appsCuenta").val().length-1).split(',');
		   		for(var i=0;i<apps.length;i++){
		   			var app
	   				if(i==0)
	   					app=apps[i];
	   				else
	   					app=apps[i].slice(1,apps[i].length);
		   			document.getElementById(app).checked = true;
		   		}
		   	}
		   	$('#checkApps').show();
		   	$('#appsLabel').show();
		}

		$("#cbMedioPagoIva").select2({
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
		$("#cbMedioPagoIibb").select2({
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

		llenarComboMedioPagoIva()
		llenarComboMedioPagoIibb()

	});

	function editCuenta(){
		$('#razonSocialInput').val($('#razonSocialLabel').text());
		$('#nombreApellidoInput').val($('#nombreApellidoLabel').text());
		$('#telefonoInput').val($('#telefonoLabel').text());
		$('#whatsAppInput').val($('#whatsAppLabel').text());
		$('#wechatInput').val($('#wechatLabel').text());

		toggleEditMode();
	}

	function getNumeroContactoVendedor(){
		var wpp = document.getElementById("wpp")
		var URL="${createLink(controller:'registrar',action:'getVendedorNecesitoAyuda')}";
		  $.ajax({
	                url:URL,
	                data:{
	                	ayuda:true
	                },
	                async: false,
	                success: function(resp){
	                    wpp.href = resp.wsp;
	                }
	            });
	}	

	function showAlertCredito(){
		if(!alertaCredito){
			swal("Atención", "La tarjeta ingresada debe ser de Crédito ¡Gracias!","warning");
			alertaCredito = true;
		}
	}

	function toggleEditMode(){
		$('#razonSocialLabel').toggle();
		$('#razonSocialInput').toggle();
		$('#nombreApellidoLabel').toggle();
		$('#nombreApellidoInput').toggle();
		$('#telefonoLabel').toggle();
		$('#telefonoInput').toggle();
		if($('#profesionLabel').text() == "app"){
			$('#appsLabel').toggle();
			$('#cbApps').toggle();
		}
		$('#whatsAppLabel').toggle();
		$('#whatsAppInput').toggle();
		$('#wechatLabel').toggle();
		$('#wechatInput').toggle();
		$('#tarjetaLabel').toggle();
		$('#tarjetaInput').toggle();
		$('#red').toggle();
		$('#tipo').toggle();
		$('#tarjetaInput2').toggle();

		$("#br1").toggle();
		$("#br2").toggle();
		$('#botonEdit').toggle();
		$('#rowBotones').toggle();
		$('#divBtnContrasena').toggle();

		$('#medioPagoIvaLabel').toggle();
		$('#medioPagoIibbLabel').toggle();
		$('#divMedioPagoIva').toggle();
		$('#divMedioPagoIibb').toggle();
	}

	function setInputFilter(textbox, inputFilter) {
	  ["input", "keydown", "keyup", "mousedown", "mouseup", "select", "contextmenu", "drop"].forEach(function(event) {
	    textbox.addEventListener(event, function() {
	      if (inputFilter(this.value)) {
	        this.oldValue = this.value;
	        this.oldSelectionStart = this.selectionStart;
	        this.oldSelectionEnd = this.selectionEnd;
	      } else if (this.hasOwnProperty("oldValue")) {
	        this.value = this.oldValue;
	        this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
	      } else {
	        this.value = "";
	      }
	    });
	  });
	}

	setInputFilter(document.getElementById("tarjetaInput"), function(value) {
	  return /^\d*\.?\d*$/.test(value);
	});

	function toggleContrasena(){
		cambioPassword = !cambioPassword;
		$('#contrasenaLabel').text("Contraseña" + (cambioPassword ? " anterior" : ""))
		$('.cuentaUsuario-contrasena').toggle();

		$('#rowBotones').toggle();
		$('#botonEdit').toggle();
	}

	function saveCuenta(){
		if($('#tarjetaInput').val() != null)
			if($('#tarjetaInput').val().length >0 && $('#tarjetaInput').val().length < 16 ){
				swal("Error", "El numero de tarjeta debe tener 16 digitos","error");
				return
			}else{
				if($('#tarjetaInput').val().length == 0)
					$("#tarjetaLabel").text("No");
				else
					$("#tarjetaLabel").text("Si");
			}
		
		$('#razonSocialLabel').text($('#razonSocialInput').val());
		$('#nombreApellidoLabel').text($('#nombreApellidoInput').val());
		$('#telefonoLabel').text($('#telefonoInput').val());
		$('#whatsAppLabel').text($('#whatsAppInput').val());
		$('#wechatLabel').text($('#wechatInput').val());
		$('#medioPagoIvaLabel').text($('#cbMedioPagoIva option:selected').text());
		$('#medioPagoIibbLabel').text($('#cbMedioPagoIibb option:selected').text());

		selected = [];
		$(":checkbox[name=apps]").each(function() {
			if (this.checked) {
				selected.push($(this).val());
			}
		});

		if(selected.length>0)
			$('#selectedApps').val(selected)


		$.ajax({
			url : $('#urlUpdateCuenta').text(),
			data : {
				// Datos a editar:
				'razonSocial' : $('#razonSocialInput').val(),
				'nombreApellido' : $('#nombreApellidoInput').val(),
				'telefono' : $('#telefonoInput').val(),
				'whatsapp' : $('#whatsAppInput').val(),
				'wechat' : $('#wechatInput').val(),
				'profesion' : $('#profesionLabel').text(),
				'apps' : $('#selectedApps').val(),
				'numeroTarjeta': $("#tarjetaInput").val(),
				'tarjetaVisa': $('input[name=tarjetaVisa]:checked').val(),
				'tarjetaCredito': $('input[name=tarjetaCredito]:checked').val(),
				'medioPagoIvaId': $('#cbMedioPagoIva').val(),
				'medioPagoIibbId': $('#cbMedioPagoIibb').val(),
				// Datos que no editaremos pero son not null en el command:
				'cuit' : '${cuentaInstance?.cuit}',
				'tenantId' : '${cuentaInstance?.tenantId}',
				'email' : '${cuentaInstance?.email}',
				'cuentaId' : '${cuentaInstance?.id}'
			},
			success : function(resultado){
				if($('#profesionLabel').text()!="app")
					limpiarChecksApps();
				else
					recargarLabelApps();
				if (resultado.hasOwnProperty('error'))
					swal("Error", resultado.error, "error");
				else
					swal("Éxito!", "Tu cuenta se actualizó correctamente", "success");
				toggleEditMode();
			}
		});
	}

	function savePassword(){
		$.ajax({
			url : $('#urlUpdatePassword').text(),
			data : {
				'password' : $('#contrasenaNueva1').val(),
				'password2' : $('#contrasenaNueva2').val(),
				'passwordViejo' : $('#contrasenaAnterior').val(),
				'userId' : "${session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id}"
			},
			success : function(resultado){
				if (resultado.hasOwnProperty('error'))
					swal("Error", resultado.error, "error");
				else{
					swal("Contraseña modificada", null, "success");
					toggleContrasena();
				}
			}
		});
	}

	function limpiarChecksApps(){
		$(":checkbox[name=apps]").each(function() {
			this.checked = false;
		});
	}

	function recargarLabelApps(){
		selected = [];
		$(":checkbox[name=apps]").each(function() {
			if (this.checked) {
				selected.push($(this).val());
			}
		});
		$('#appsLabel').text(selected);
	}

	function llenarComboMedioPagoIva(){
		llenarCombo({
			comboId : "cbMedioPagoIva",
			ajaxLink : '${createLink(controller:"cuenta", action:"ajaxGetMediosPago")}',
			idDefault : '${cuentaInstance?.medioPagoIva?.id}',
			parametros : {
				'condicionIvaId' : '${cuentaInstance.condicionIva?.id}'
			}
		});
	}

	function llenarComboMedioPagoIibb(){
		llenarCombo({
			comboId : "cbMedioPagoIibb",
			ajaxLink : '${createLink(controller:"cuenta", action:"ajaxGetMediosPago")}',
			idDefault : '${cuentaInstance?.medioPagoIibb?.id}',
			parametros : {
				'regimenIibbId' : '${cuentaInstance.regimenIibb?.id}'
			}
		});
	}
</script>
</body>
</html>