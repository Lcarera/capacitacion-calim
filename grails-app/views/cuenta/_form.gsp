<%@ page import="com.zifras.Localidad" %>
<g:hiddenField name="cuentaId" value="${cuentaInstance?.cuentaId}" />
<g:hiddenField name="id" value="${cuentaInstance?.cuentaId}" />
<g:hiddenField name="version" value="${cuentaInstance?.version}" />
<g:hiddenField name="parientes" value="${cuentaInstance?.parientes}" />
<g:hiddenField name="parientesBorrados" value="${cuentaInstance?.parientesBorrados}" />
<g:hiddenField name="locales" value="${cuentaInstance?.locales}" />
<g:hiddenField name="alicuotasIIBB" value="${cuentaInstance?.alicuotasIIBB}" />
<g:hiddenField name="impuestos"/>
<g:hiddenField name="alicuotasIIBBBorradas" value="" />
<g:hiddenField name="porcentajesProvinciaIIBB" value="${cuentaInstance?.porcentajesProvinciaIIBB}" />
<g:hiddenField name="porcentajesActividadIIBB" value="${cuentaInstance?.porcentajesActividadIIBB}" />
<g:hiddenField name="porcentajesActividadIIBBBorradas" value="" />
<g:hiddenField name="porcentajesProvinciaIIBBBorradas" value="" />
<g:hiddenField name="estadoActivoId" value="${cuentaInstance?.estadoActivoId}" />
<g:hiddenField name="provinciaCabaId" value="${cuentaInstance?.provinciaCabaId}" />
<g:hiddenField name="actividadDefaultId" value="${cuentaInstance?.actividadDefaultId}" />
<g:hiddenField name="localidadCabaId" value="${cuentaInstance?.localidadCabaId}" />
<g:hiddenField name="tenantId" value="${cuentaInstance?.tenantId}" />
<g:hiddenField name="convenioMultilateralId" value="${cuentaInstance?.convenioMultilateralId}" />
<g:hiddenField name="appsCuenta" value="${cuentaInstance?.apps}" />

<div style="display: none;">
	<div id="urlGetActividades">
		<g:createLink controller="actividad" action="ajaxGetActividades" />
	</div>
	<div id="urlGetActividad">
		<g:createLink controller="actividad" action="ajaxGetActividad" />
	</div>
	<div id="urlGetCondicionesIVA">
		<g:createLink controller="condicionIva" action="ajaxGetCondicionesIVA" />
	</div>
	<div id="urlGetCondicionIVA">
		<g:createLink controller="condicionIva" action="ajaxGetCondicionIVA" />
	</div>
	<div id="urlGetRegimenesIIBB">
		<g:createLink controller="regimenIibb" action="ajaxGetRegimenesIIBB" />
	</div>
	<div id="urlGetRegimenIIBB">
		<g:createLink controller="regimenIibb" action="ajaxGetRegimenIIBB" />
	</div>
	<div id="urlGetEstados">
		<g:createLink controller="estado" action="ajaxGetEstados" />
	</div>
	<div id="urlGetEstadosLocales">
		<g:createLink controller="estado" action="ajaxGetLocales" />
	</div>
	<div id="urlGetEstado">
		<g:createLink controller="estado" action="ajaxGetEstado" />
	</div>
	<div id="urlGetLocalidades">
		<g:createLink controller="localidad" action="ajaxGetLocalidades" />
	</div>
	<div id="urlGetLocalidad">
		<g:createLink controller="localidad" action="ajaxGetLocalidad" />
	</div>
	<div id="urlGetZonas">
		<g:createLink controller="zona" action="ajaxGetZonas" />
	</div>
	<div id="urlGetZona">
		<g:createLink controller="zona" action="ajaxGetZona" />
	</div>
	<div id="urlGetLocales">
		<g:createLink controller="cuenta" action="ajaxGetLocales" />
	</div>
	<div id="urlGetAlicuotasIIBB">
		<g:createLink controller="cuenta" action="ajaxGetAlicuotasIIBB" />
	</div>
	<div id="urlGetPorcentajesProvinciaIIBB">
		<g:createLink controller="cuenta" action="ajaxGetPorcentajesProvinciaIIBB" />
	</div>
	<div id="urlGetPorcentajesActividadIIBB">
		<g:createLink controller="cuenta" action="ajaxGetPorcentajesActividadIIBB" />
	</div>
	<div id="urlGetParientes">
		<g:createLink controller="cuenta" action="ajaxGetParientes" />
	</div>
	<div id="urlGetProvincias">
		<g:createLink controller="provincia" action="ajaxGetProvincias" />
	</div>
	<div id="urlGetProvincia">
		<g:createLink controller="provincia" action="ajaxGetProvincia" />
	</div>
</div>

<div class="form-group ${hasErrors(bean: cuentaInstance, field: 'cuit', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Cuit *</label>
	<div class="col-sm-7">
		<input name="cuit" id="cuit" type="text" class="form-control ${hasErrors(bean: cuentaInstance, field: 'cuit', 'form-control-danger')}" value="${cuentaInstance?.cuit}">
	</div>
	<button type="button" class="col-sm-2 btn btn-primary waves-effect waves-light " onclick="window.location.href = '/cuenta/editPorAfip/${cuentaInstance.cuentaId}/?cuit=' + $('#cuit').val()">Llenar por AFIP</button>
</div>
<!-- <div class="form-group ${hasErrors(bean: cuentaInstance, field: 'cuitAdministrador', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Cuit Administrador</label>
	<div class="col-sm-10">
		<input name="cuitAdministrador" type="text" class="form-control ${hasErrors(bean: cuentaInstance, field: 'cuitAdministrador', 'form-control-danger')}" value="${cuentaInstance?.cuitAdministrador}">
	</div>
</div> -->
<div class="form-group ${hasErrors(bean: cuentaInstance, field: 'cuitRepresentante', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Cuit Representante/Admin</label>
	<div class="col-sm-10">
		<input name="cuitRepresentante" type="text" class="form-control ${hasErrors(bean: cuentaInstance, field: 'cuitRepresentante', 'form-control-danger')}" value="${cuentaInstance?.cuitRepresentante}">
	</div>
</div>
<g:if test="${cuentaInstance?.tenantId == 1}">
	<div class="form-group ${hasErrors(bean: cuentaInstance, field: 'cuitGeneradorVep', 'has-danger')} row">
		<label class="col-sm-2 col-form-label">Cuit Generador de VEPS</label>
		<div class="col-sm-10">
			<input name="cuitGeneradorVep" type="text" class="form-control ${hasErrors(bean: cuentaInstance, field: 'cuitGeneradorVep', 'form-control-danger')}" value="${cuentaInstance?.cuitGeneradorVep}">
		</div>
	</div>
</g:if>
<g:if test="${cuentaInstance?.tenantId == 1}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Clave Generadora VEPs</label>
		<div class="col-sm-10">
			<input name="claveVeps" type="text" class="form-control" placeholder="Clave Generadora VEPs" value="${cuentaInstance?.claveVeps}">
		</div>
	</div>
</g:if>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Clave Fiscal</label>
	<div class="col-sm-10">
		<input name="claveFiscal" type="text" class="form-control" placeholder="Clave Fiscal" value="${cuentaInstance?.claveFiscal}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Clave Arba</label>
	<div class="col-sm-10">
		<input name="claveArba" type="text" class="form-control" placeholder="Clave Arba" value="${cuentaInstance?.claveArba}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Clave Agip</label>
	<div class="col-sm-10">
		<input name="claveAgip" type="text" class="form-control" placeholder="Clave Agip" value="${cuentaInstance?.claveAgip}">
	</div>
</div>
<g:if test="${cuentaInstance?.tenantId == 2}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Tipo Clave</label>
		<div class="col-sm-5">
			<select id="cbTipoClave" name="tipoClaveId" class="form-control"></select>
		</div>
		<div class="col-sm-5">
			<select id="cbEstadoClave" name="estadoClaveId" class="form-control"></select>
		</div>
	</div>
</g:if>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Razón social</label>
	<div class="col-sm-10">
		<input name="razonSocial" type="text" class="form-control" value="${cuentaInstance?.razonSocial}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Contrato Social</label>
	<div class="col-sm-10">
		<input id="fechaContratoSocial" name="fechaContratoSocial" class="form-control" type="text" data-format="d/m/Y" placeholder="Seleccione un día" value="${cuentaInstance?.fechaContratoSocial?.toString('dd/MM/yyyy')}"/>
	</div>
</div>
<g:if test="${cuentaInstance?.tenantId == 2}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Mes de Cierre</label>
		<div class="col-sm-10">
			<input id="mesCierre" name="mesCierre" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${cuentaInstance?.mesCierre}"/>
		</div>
	</div>
</g:if>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Nombre y Apellido</label>
	<div class="col-sm-10">
		<input name="nombreApellido" type="text" class="form-control" placeholder="Nombre de contacto" value="${cuentaInstance?.nombreApellido}">
	</div>
</div>
<g:if test="${cuentaInstance?.tenantId == 2}">
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Tipo Documento</label>
	<div class="col-sm-10">
	        <label style="margin-right: 10px">
	            <input type="radio" name="tipoDocumento" id="dni" value="dni" checked="checked"> DNI
	        </label>
	        <label style="margin-right: 10px">
	            <input type="radio" name="tipoDocumento" id="pasaporte" value="pasaporte">Pasaporte
	        </label>
	        <label>
	            <input type="radio" name="tipoDocumento" id="precaria" value="precaria">Precaria
	        </label>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Nº Doc</label>
	<div class="col-sm-10">
		<input name="documento" type="text" class="form-control" placeholder="Nro Documento" value="${cuentaInstance?.documento}" style="text-transform: uppercase;">
	</div>
</div>
</g:if>
<g:if test="${cuentaInstance?.tenantId == 2}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Tipo Persona</label>
		<div class="col-sm-10">
			<select id="cbTipoPersona" name="tipoPersonaId" class="form-control"></select>
		</div>
	</div>
</g:if>
<g:if test="${cuentaInstance?.tenantId == 2}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Profesion</label>
		<div class="col-sm-10">
			<select id="cbProfesion" name="profesion" class="form-control"><g:if test="${!cuentaInstance?.profesion}"><option value="default" disabled="disabled">Seleccionar profesion</option></g:if><option value="mercadolibre">MercadoLibre</option><option value="profesional">Profesional Independiente</option><option value="oficio">Oficio Independiente</option><option value="comercio">Tiene comercio (local)</option><option value="ecommerce">E-commerce</option><option value="app">Trabaja con App</option><option value="otro">Otro</option></select>
		</div>	
	</div>
	<div id="checkApps" class="form-group-row" style="display: none; margin-bottom: 10px;">
		<label class="col-sm-2 col-form-label" style="padding-left: 1px">Apps</label>
		<div class="checkbox-fade fade-in-primary">
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
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">App Calim descargada</label>
		<div class="col-sm-10">
			 <label style="margin-top: 4px">${cuentaInstance?.appCalimDescargada}</label>
		</div>	
	</div>
</g:if>
<g:if test="${cuentaInstance?.tenantId == 2}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Rango de Facturacion</label>
		<div class="col-sm-10">
			<select id="cbRangoFacturacion" name="rangoFacturacion" class="form-control"><g:if test="${!cuentaInstance?.rangoFacturacion}"><option value="default" disabled="disabled">Seleccionar rango facturacion</option></g:if> <option value="Menos de 15000">Menos de $15000/mes</option><option value="Entre 15000 y 50000">Entre $15000 y $50000</option><option value="Entre 50000 y 100000">Entre $50000 y $100000/mes</option><option value="Entre 100000 y 500000">Entre $100000 y $500000</option><option value="Mas de 500000">Mas de $500000</option></select>
		</div>
	</div>
</g:if>
<g:if test="${cuentaInstance?.tenantId == 2}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Inscripto en AFIP</label>
		<div class="col-sm-10">
	        <label style="margin-right: 10px">
	            <input type="radio" name="inscriptoAfip" id="Si" value="true"> Si
	        </label>
	        <label style="margin-right: 10px">
	            <input type="radio" name="inscriptoAfip" id="No" value="false">No
	        </label>
		</div>
	</div>
</g:if>
<g:if test="${cuentaInstance?.tenantId == 2}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Relacion de Dependencia</label>
		<div class="col-sm-10">
	        <label style="margin-right: 10px">
	            <input type="radio" name="relacionDependencia" id="SiRel" value="true"> Si
	        </label>
	        <label style="margin-right: 10px">
	            <input type="radio" name="relacionDependencia" id="NoRel" value="false">No
	        </label>
		</div>
	</div>
</g:if>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Teléfono</label>
	<div class="col-sm-10">
		<input name="telefono" type="text" class="form-control" placeholder="Celular" value="${cuentaInstance?.telefono}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Email</label>
	<div class="col-sm-10">
		<input name="email" type="text" class="form-control ${hasErrors(bean: cuentaInstance, field: 'email', 'form-control-danger')}" placeholder="" value="${cuentaInstance?.email}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Wechat</label>
	<div class="col-sm-10">
		<input name="wechat" type="text" class="form-control ${hasErrors(bean: cuentaInstance, field: 'wechat', 'form-control-danger')}" placeholder="" value="${cuentaInstance?.wechat}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Whatsapp</label>
	<div class="col-sm-10">
		<input name="whatsapp" type="text" class="form-control ${hasErrors(bean: cuentaInstance, field: 'whatsapp', 'form-control-danger')}" placeholder="" value="${cuentaInstance?.whatsapp}">
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Condición IVA</label>
	<div class="col-sm-10">
		<select id="cbCondicionIva" name="condicionIvaId" class="form-control"></select>
	</div>
</div>
<g:if test="${cuentaInstance?.tenantId == 2}">
	<div id="divMonotributo" class="form-group row" style="display: none;">
		<label class="col-sm-2 col-form-label">Monotributo</label>
		<div class="col-sm-10">
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Categoría</label>
				<div class="col-sm-10">
					<select id="cbCategoriaMonotributo" name="categoriaMonotributoId" class="form-control elementoDivMonotributo"></select>
				</div>
			</div>
			<hr/>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Impuesto</label>
				<div class="col-sm-10">
					<select id="cbImpuestoMonotributo" name="impuestoMonotributoId" value="${cuentaInstance?.impuestoMonotributoId}" class="form-control elementoDivMonotributo"></select>
				</div>
			</div>
			<hr/>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Fecha Alta</label>
				<div class="col-sm-10">
					<input id="periodoMonotributo" name="periodoMonotributo" value="${cuentaInstance?.periodoMonotributo}" class="form-control elementoDivMonotributo" type="text" data-format="m/Y" placeholder="Seleccione la fecha de alta"/>
				</div>
			</div>
		</div>
	</div>
	<div id="divAutonomo" class="form-group row" style="display: none;">
		<label class="col-sm-2 col-form-label">Autónomo</label>
		<div class="col-sm-10">
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Categoría</label>
				<div class="col-sm-10">
					<select id="cbCategoriaAutonomo" name="categoriaAutonomoId" class="form-control elementoDivAutonomo"></select>
				</div>
			</div>
			<hr/>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Impuesto</label>
				<div class="col-sm-10">
					<select id="cbImpuestoAutonomo" name="impuestoAutonomoId" value="${cuentaInstance?.impuestoAutonomoId}" class="form-control elementoDivAutonomo"></select>
				</div>
			</div>
			<hr/>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Fecha Alta</label>
				<div class="col-sm-10">
					<input id="periodoAutonomo" name="periodoAutonomo" value="${cuentaInstance?.periodoAutonomo}" class="form-control elementoDivAutonomo" type="text" data-format="m/Y" placeholder="Seleccione la fecha de alta"/>
				</div>
			</div>
		</div>
	</div>
</g:if>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Régimen IIBB</label>
	<div class="col-sm-10">
		<select id="cbRegimenIibb" name="regimenIibbId" class="form-control"></select>
	</div>
</div>
<g:if test="${cuentaInstance?.tenantId == 1}">
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Actividad</label>
	<div class="col-sm-10">
		<select id="cbActividad" name="actividadId" class="form-control"></select>
	</div>
</div>
</g:if>
<div class="form-group row" id="divNumeroSicol" style="display:none;">
	<label class="col-sm-2 col-form-label">Número Sicol</label>
	<div class="col-sm-10">
		<input id="numeroSicol" name="numeroSicol" type="text" class="form-control ${hasErrors(bean: cuentaInstance, field: 'numeroSicol', 'form-control-danger')}"  placeholder="" value="${cuentaInstance?.numeroSicol}">
	</div>
</div>
<div class="form-group ${hasErrors(bean: cuentaInstance, field: 'detalle', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Detalle</label>
	<div class="col-sm-10">
		<textarea class="form-control" id="detalle" name="detalle" rows="3" class="form-control ${hasErrors(bean: cuentaInstance, field: 'detalle', 'form-control-danger')}">${cuentaInstance?.detalle}</textarea>
	</div>
</div>


<g:if test="${cuentaInstance?.tenantId == 2}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Domicilio Fiscal</label>
		<div class="col-sm-10">
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Código Postal</label>
				<div class="col-sm-10">
					<input name="domicilioFiscalCodigoPostal" type="text" class="form-control" value="${cuentaInstance?.domicilioFiscalCodigoPostal}">
				</div>
			</div>
			<hr/>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Dirección</label>
				<div class="col-sm-10">
					<input name="domicilioFiscalDireccion" type="text" class="form-control" value="${cuentaInstance?.domicilioFiscalDireccion}">
				</div>
			</div>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Piso Dpto</label>
				<div class="col-sm-10">
					<input name="domicilioFiscalPisoDpto" type="text" class="form-control" value="${cuentaInstance?.domicilioFiscalPisoDpto}">
				</div>
			</div>
			<hr/>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Provincia</label>
				<div class="col-sm-10">
					<select id="cbDomicilioFiscalProvincia" name="domicilioFiscalProvinciaId" class="form-control"></select>
				</div>
			</div>
			<hr/>
			<div class="form-group row">
				<label class="col-sm-2 col-form-label">Localidad</label>
				<div class="col-sm-10">
					<input name="domicilioFiscalLocalidad" type="text" class="form-control" value="${cuentaInstance?.domicilioFiscalLocalidad}">
				</div>
			</div>
		</div>
	</div>
</g:if>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Medio de Pago VEP</label>
	<div class="col-sm-10">
		<select id="cbMedioPago" name="medioPagoId" class="form-control"></select>
	</div>
</div>

<div class="form-group row" id="divMedioPagoIva" ${cuentaInstance?.condicionIvaId != 11 ? raw('hidden') : ''}>
	<label class="col-sm-2 col-form-label">Medio de Pago VEP IVA</label>
	<div class="col-sm-10">
		<select id="cbMedioPagoIva" name="medioPagoIvaId" class="form-control"></select>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Medio de Pago VEP IIBB</label>
	<div class="col-sm-10">
		<select id="cbMedioPagoIibb" name="medioPagoIibbId" class="form-control"></select>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">CBU</label>
	<div class="col-sm-10">
		<input name="cbu" type="text" class="form-control ${hasErrors(bean: cuentaInstance, field: 'cbu', 'form-control-danger')}" placeholder="" value="${cuentaInstance?.cbu}">
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Debito Automatico</label>
	<div class="col-sm-10">
        <label style="margin-right: 10px">
            <input type="radio" name="debitoAutomatico" id="siDebito" value="true"> Si
        </label>
        <label style="margin-right: 10px">
            <input type="radio" name="debitoAutomatico" id="noDebito" value="false"> No
        </label>
        <br>
        <div id="divTarjeta" style="display: none;">
	        <div class="form-group row">
					<label class="col-sm-2 col-form-label">Número Tarjeta Crédito</label>
					<div class="col-sm-10">
						<input id="numeroTarjeta" name="numeroTarjeta" type="text" class="form-control" maxlength="16" value="${cuentaInstance?.numeroTarjeta}">
					</div>
				</div>
				<hr/>
			</div>
			<hr/>
	</div>
</div>

<div class="modal fade" id="modalPariente" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Pariente</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:hiddenField name="modalParienteId" value="" />
				<g:hiddenField name="modalParienteIndex" value="" />
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Tipo</label>
					<div class="col-sm-10">
						<select id="modalParienteTipo"class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Nombre</label>
					<div class="col-sm-10">
						<input id="modalParienteNombre" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Apellido</label>
					<div class="col-sm-10">
						<input id="modalParienteApellido" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">CUIL</label>
					<div class="col-sm-10">
						<input id="modalParienteCuil" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Fecha</label>
					<div class="col-sm-10">
						<input id="modalParienteFecha" type="text" class="form-control" data-format="d/m/Y" placeholder="Seleccione un día" value="">
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttonParienteVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonParienteEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deletePariente();">Eliminar</button>
				<button id="buttonParienteAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addPariente();">Aceptar</button>
				<button id="buttonParienteModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updatePariente();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalLocal" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Local</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:hiddenField name="modalLocalId" value="" />
				<g:hiddenField name="modalLocalIndex" value="" />
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Numero Local</label>
					<div class="col-sm-10">
						<input id="modalLocalNumero" type="text" class="form-control" placeholder="" value="" readonly>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">* Dirección</label>
					<div class="col-sm-10">
						<input id="modalLocalDireccion" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Whatsapp</label>
					<div class="col-sm-10">
						<input id="modalLocalTelefono" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Email</label>
					<div class="col-sm-10">
						<input id="modalLocalEmail" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">* Provincia</label>
					<div class="col-sm-10">
						<select id="cbModalProvincia" name="modalLocalProvinciaId" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">* Localidad</label>
					<div class="col-sm-10">
						<select id="cbModalLocalidad" name="modalLocalLocaliadId" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Zona</label>
					<div class="col-sm-10">
						<select id="cbModalZona" name="modalLocalZonaId" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Cantidad de Empleados</label>
					<div class="col-sm-10">
						<input id="modalLocalCantidadEmpleados" class="form-control" placeholder="" value=""></input>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">* Porcentaje</label>
					<div class="col-sm-10">
						<input id="modalLocalPorcentaje" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">* Porcentaje IIBB</label>
					<div class="col-sm-10">
						<input id="modalLocalPorcentajeIIBB" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Estado</label>
					<div class="col-sm-10">
						<select id="cbModalEstado" name="modalLocalEstadoId" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label"  style="color:grey">(*) Campos Obligatorios</label>
				</div>
			</div>

			<div class="modal-footer">
				<button id="buttonLocalVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonLocalEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deleteLocal();">Eliminar</button>
				<button id="buttonLocalAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addLocal();">Aceptar</button>
				<button id="buttonLocalModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updateLocal();">Aceptar</button>
			</div>
		</div>
	</div>
</div>
<div class="form-group row">
	<div class="col-sm-12">
		<div class="card">
			<div class="card-header">
				<div class="row">
					<div class="col-lg-8">
						<h5>Locales</h5>
					</div>
					<div class="col-lg-4">
						<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showLocal(null);">Agregar</button>
					</div>
				</div>				
			</div>
			<div class="card-block">
				<div class="table-responsive">
					<table id="listLocales" class="table table-striped table-bordered nowrap" style="cursor:pointer">
						<thead>
							<tr>
								<th>Numero local</th>
								<th>Dirección</th>
								<th>Email</th>
								<th>Whatsapp</th>
								<th>Localidad</th>
								<th>Zona</th>
								<th>Provincia</th>
								<th>Cantidad Empleados</th>
								<th>% Pago IVA</th>
								<th>% Pago IIBB</th>
								<th>Estado</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalAlicuotaIIBB" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Alícuota IIBB</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:hiddenField name="modalAlicuotaIIBBId" value="" />
				<g:hiddenField name="modalAlicuotaIIBBIndex" value="" />
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Provincia</label>
					<div class="col-sm-10">
						<select id="cbModalAlicuotaIIBBProvincia" name="modalAlicuotaIIBBProvinciaId" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Alicuota</label>
					<div class="col-sm-10">
						<input id="modalAlicuotaIIBBValor" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Porcentaje</label>
					<div class="col-sm-10">
						<input id="modalAlicuotaIIBBPorcentaje" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttonAlicuotaIIBBVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonAlicuotaIIBBEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deleteAlicuotaIIBB();">Eliminar</button>
				<button id="buttonAlicuotaIIBBAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addAlicuotaIIBB();">Aceptar</button>
				<button id="buttonAlicuotaIIBBModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updateAlicuotaIIBB();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<g:if test="${cuentaInstance?.tenantId == 1}">
<div class="form-group row">
	<div class="col-sm-12">
		<div class="card">
			<div class="card-header">
				<div class="row">
					<div class="col-lg-8">
						<h5>Alícuotas IIBB</h5>
					</div>
					<div class="col-lg-4">
						<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showAlicuotaIIBB(null);">Agregar</button>
					</div>
				</div>				
			</div>
			<div class="card-block">
				<div class="table-responsive">
					<table id="listAlicuotasIIBB" class="table table-striped table-bordered nowrap" style="cursor:pointer">
						<thead>
							<tr>
								<th>Provincia</th>
								<th>Alícuota</th>
								<th>%</th>
								<th>Ult. modificación</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
</g:if>

<div class="form-group row">
	<div class="col-sm-12">
		<div class="card">
			<div class="card-header">
				<div class="row">
					<div class="col-lg-8">
						<h5>Distribucion de IIBB por Provincia</h5>
					</div>
					<div class="col-lg-4">
						<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showPorcentajeProvinciaIIBB();">Agregar</button>
					</div>
				</div>				
			</div>
			<div class="card-block">
				<div class="table-responsive">
					<table id="listPorcentajesProvinciaIIBB" class="table table-striped table-bordered nowrap" style="cursor:pointer">
						<thead>
							<tr>
								<th>Provincia</th>
								<th>%</th>
								<th>Ult. modificación</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<g:if test="${cuentaInstance?.tenantId == 2}">
<div class="form-group row">
	<div class="col-sm-12">
		<div class="card">
			<div class="card-header">
				<div class="row">
					<div class="col-lg-8">
						<h5>Distribucion de IIBB por Actividad</h5>
					</div>
					<div class="col-lg-4">
						<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showPorcentajeActividadIIBB();">Agregar</button>
					</div>
				</div>				
			</div>
			<div class="card-block">
				<div class="table-responsive">
					<table id="listPorcentajesActividadIIBB" class="table table-striped table-bordered nowrap" style="cursor:pointer">
						<thead>
							<tr>
								<th>Actividad</th>
								<th>%</th>
								<th>Ult. modificación</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="form-group row">
	<div class="col-sm-12">
		<div class="card">
			<div class="card-header">
				<div class="row">
					<div class="col-lg-8">
						<h5>Impuestos</h5>
					</div>
					<div class="col-lg-4">
						<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showImpuesto();">Agregar</button>
					</div>
				</div>				
			</div>
			<div class="card-block">
				<div class="table-responsive">
					<table id="listImpuestos" class="table table-striped table-bordered nowrap" style="cursor:pointer">
						<thead>
							<tr>
								<th>Impuesto</th>
								<th>Fecha Alta</th>
								<th>Monotributo</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
</g:if>

<div class="form-group row">
	<div class="col-sm-12">
		<div class="card">
			<div class="card-header">
				<div class="row">
					<div class="col-lg-8">
						<h5>Parientes</h5>
					</div>
					<div class="col-lg-4">
						<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showPariente(null);">Agregar</button>
					</div>
				</div>				
			</div>
			<div class="card-block">
				<div class="table-responsive">
					<table id="listParientes" class="table table-striped table-bordered nowrap" style="cursor:pointer">
						<thead>
							<tr>
								<th>Tipo</th>
								<th>Nombre</th>
								<th>Apellido</th>
								<th>CUIL</th>
								<th>Fecha</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalPorcentajeProvinciaIIBB" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Distribucion de IIBB</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:hiddenField name="modalPorcentajeProvinciaIIBBId" value="" />
				<g:hiddenField name="modalPorcentajeProvinciaIIBBIndex" value="" />
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Provincia</label>
					<div class="col-sm-10">
						<select id="cbModalPorcentajeProvinciaIIBBProvincia" name="modalPorcentajeProvinciaIIBBProvinciaId" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Porcentaje</label>
					<div class="col-sm-10">
						<input id="modalPorcentajeProvinciaIIBBPorcentaje" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttonPorcentajeProvinciaIIBBVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonPorcentajeProvinciaIIBBEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deletePorcentajeProvinciaIIBB();">Eliminar</button>
				<button id="buttonPorcentajeProvinciaIIBBAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addPorcentajeProvinciaIIBB();">Aceptar</button>
				<button id="buttonPorcentajeProvinciaIIBBModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updatePorcentajeProvinciaIIBB();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalPorcentajeActividadIIBB" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Distribucion de IIBB</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:hiddenField name="modalPorcentajeActividadIIBBId" value="" />
				<g:hiddenField name="modalPorcentajeActividadIIBBIndex" value="" />
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Actividad</label>
					<div class="col-sm-10">
						<select id="cbModalPorcentajeActividadIIBBActividad" name="modalPorcentajeActividadIIBBActividadId" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Porcentaje</label>
					<div class="col-sm-10">
						<input id="modalPorcentajeActividadIIBBPorcentaje" type="text" class="form-control" placeholder="" value="">
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttonPorcentajeActividadIIBBVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonPorcentajeActividadIIBBEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deletePorcentajeActividadIIBB();">Eliminar</button>
				<button id="buttonPorcentajeActividadIIBBAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addPorcentajeActividadIIBB();">Aceptar</button>
				<button id="buttonPorcentajeActividadIIBBModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updatePorcentajeActividadIIBB();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<g:if test="${cuentaInstance?.tenantId == 2}">
	<div class="modal fade" id="modalImpuesto" role="dialog">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Impuesto</h4>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<g:hiddenField name="modalImpuestoIndex" value="" />
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">Impuesto</label>
						<div class="col-sm-10">
							<select id="cbModalImpuestoId" class="form-control"></select>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">Fecha Alta</label>
						<div class="col-sm-10">
							<input id="modalImpuestoPeriodo" class="form-control" type="text" data-format="m/Y" placeholder="Seleccione la fecha de alta"/>
						</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-12">
							<div class="checkbox-fade fade-in-primary">
								<label class="check-task">
									<span>Monotributo</span>
									<input id="checkMonotributo" type="checkbox" value="true", checked="true">
									<span class="cr">
										<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
									</span>
									
								</label>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button id="buttonImpuestoVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
					<button id="buttonImpuestoEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deleteImpuesto();">Eliminar</button>
					<button id="buttonImpuestoAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addImpuesto();">Aceptar</button>
					<button id="buttonImpuestoModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updateImpuesto();">Aceptar</button>
				</div>
			</div>
		</div>
	</div>
</g:if>

<script type="text/javascript">
var alicuotasIIBBBorradas = [];
var porcentajesProvinciaIIBBBorradas = [];
var porcentajesActividadIIBBBorradas = [];
var parientesBorrados = [];

var tablaParientes;
var tiposDeParientes = [{
	id:0,
	text: 'Conyuge'
},{
	id:1,
	text: 'Hijo/a'
}];

$(document).ready(function () {

	/**INSCRIPTOAFIP ACTUAL**/
	if("${cuentaInstance.inscriptoAfip}"=="true")
		$("#Si").prop("checked", true);
	else
		if("${cuentaInstance.inscriptoAfip}" =="false")
		$("#No").prop("checked", true);		
	
	/**INSCRIPTOAFIP ACTUAL**/
	if("${cuentaInstance.relacionDependencia}"=="true")
		$("#SiRel").prop("checked", true);
	else
		if("${cuentaInstance.relacionDependencia}" =="false")
			$("#NoRel").prop("checked", true);		
	
	/**DEBITO AUTOMATICO ACTUAL**/
	if("${cuentaInstance.tarjetaDebitoAutomaticoId}"){
		$("#siDebito").prop("checked", true);
		$("#divTarjeta").show();
	}
	else
		$("#noDebito").prop("checked", true);

   	 $('input[type=radio][name="debitoAutomatico"]').change(function() {
    	$("#numeroTarjeta").val("");
    	$("#divTarjeta").toggle();
    	$("#credito").prop("checked", true);
    	$("#debito").prop("checked", false);
    	$("#visa").prop("checked", true);
    	$("#mastercard").prop("checked", false);
  	});

	/**PROFESION ACTUAL**/
	if("${cuentaInstance.profesion}"=="")
		$("#cbProfesion").val("default");
	else
		$("#cbProfesion").val("${cuentaInstance?.profesion}");	

	if("${cuentaInstance.profesion}"=="app"){
		$("#checkApps").show();
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
	}	

	/**RANGO FACTURACION ACTUAL**/
	if("${cuentaInstance.profesion}"=="")
		$("#cbRangoFacturacion").val("default");
	else
		$("#cbRangoFacturacion").val("${cuentaInstance?.rangoFacturacion}");
	
	$("#cbProfesion").change(function(){
		var sel = $("#cbProfesion").val()
		if(sel=="app")
			$("#checkApps").show()
		else
			$("#checkApps").hide()
	})

	/*** ACTIVIDADES ***/
	$("#cbActividad").select2({
		placeholder: '<g:message code="zifras.cuenta.CondicionIva.placeHolder" default="Seleccione una actividad"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: 1,
		allowClear: true,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbActividad",
		ajaxUrlDiv : 'urlGetActividades',
		idDefault : '${cuentaInstance?.actividadId}',
		atributo : 'toString'
	});
	
	/*** CONDICIONES DE IVA ***/
	$("#cbCondicionIva").select2({
		placeholder: '<g:message code="zifras.cuenta.CondicionIva.placeHolder" default="Seleccione una condición"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbCondicionIva",
		ajaxUrlDiv : 'urlGetCondicionesIVA',
		idDefault : '${cuentaInstance?.condicionIvaId}'
	});
	
	/*** REGIMENES DE IIBB ***/
	$("#cbRegimenIibb").select2({
		placeholder: '<g:message code="zifras.cuenta.RegimenIibb.placeHolder" default="Seleccione un régimen"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbRegimenIibb",
		ajaxUrlDiv : 'urlGetRegimenesIIBB',
		idDefault : '${cuentaInstance?.regimenIibbId}'
	});
	
	/** Funcionalidad entre los combos **/
	$('#cbRegimenIibb').change(function(){
		var sicol = $('#cbRegimenIibb').val();
		
		if(sicol==15){
			//Es sicol
			$('#divNumeroSicol').show();
		}else{
			$('#divNumeroSicol').hide();
			$('#numeroSicol').val('');
		}
		llenarComboMedioPago();
		llenarComboMedioPagoIva();
		llenarComboMedioPagoIibb();
	});
	
	var sicol = $('#cbRegimenIibb').val();
		
	if(sicol==15){
		//Es sicol
		$('#divNumeroSicol').show();
	}else{
		$('#divNumeroSicol').hide();
		$('#numeroSicol').val('');
	}

	$('#cbCondicionIva').change(function(){
		var nombre = $("#cbCondicionIva").select2('data')[0].text;
		$("#divAutonomo").hide();
		$("#divMonotributo").hide();
		$('.elementoDivMonotributo').removeAttr('required');
		$('.elementoDivAutonomo').removeAttr('required');
		if ('${cuentaInstance?.tenantId == 2}' == 'true')
			if (nombre=="Monotributista"){
				$("#divMedioPagoIva").hide();
				$("#divMonotributo").show();
				$(".elementoDivMonotributo").prop('required',true);
			}else if (nombre=="Responsable inscripto"){
				$("#divMedioPagoIva").show();
				$("#divAutonomo").show();
				$(".elementoDivAutonomo").prop('required',true);
			}
	});
	
	/*** PROVINCIAS ***/
	$("#cbModalProvincia").select2({
		placeholder: '<g:message code="zifras.Provincia.placeHolder" default="Seleccione una provincia"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbModalProvincia",
		ajaxUrlDiv : 'urlGetProvincias'
	});

	$("#cbDomicilioFiscalProvincia").select2({
		placeholder: '<g:message code="zifras.Provincia.placeHolder" default="Seleccione una provincia"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbDomicilioFiscalProvincia",
		ajaxUrlDiv : 'urlGetProvincias',
		idDefault : '${cuentaInstance?.domicilioFiscalProvinciaId}'
	});
	
	/*** LOCALIDADES ***/
	$("#cbModalLocalidad").select2({
		placeholder: '<g:message code="zifras.Localidad.placeHolder" default="Seleccione una localidad"/>',
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
	//Se llena el combo, pero hay que pasarle la provincia como parametro
	llenarCombo({
		comboId : "cbModalLocalidad",
		ajaxUrlDiv : 'urlGetLocalidades',
		parametros : {
			'provinciaId' : $("#cbModalProvincia").val()
		}
	});
	
	/*** ZONAS ***/
	$("#cbModalZona").select2({
		placeholder: '<g:message code="zifras.Zona.placeHolder" default="Seleccione una zona"/>',
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
		comboId : "cbModalZona",
		ajaxUrlDiv : 'urlGetZonas'
	});
	
	/*** ESTADOS ***/
	$("#cbModalEstado").select2({
		placeholder: '<g:message code="zifras.Localidad.placeHolder" default="Seleccione un estado"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbModalEstado",
		ajaxUrlDiv : 'urlGetEstadosLocales'
	});

	$("#cbEstadoClave").select2({
		placeholder: '<g:message code="zifras.Localidad.placeHolder" default="Seleccione un estado"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbEstadoClave",
		ajaxLink : '${createLink(controller:"estado", action:"ajaxGetTiposClave")}',
		idDefault : '${cuentaInstance?.estadoClaveId}'
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
	/*** CATEGORÍAS ***/
	$("#cbCategoriaAutonomo").select2({
		placeholder: '<g:message code="zifras.Categoria.placeHolder" default="Seleccione una categoría"/>',
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
		comboId : "cbCategoriaAutonomo",
		ajaxLink : '${createLink(action:"ajaxGetCategoriasList")}',
		idDefault : '${cuentaInstance?.categoriaAutonomoId}'
	});

	$("#cbCategoriaMonotributo").select2({
		placeholder: '<g:message code="zifras.Categoria.placeHolder" default="Seleccione una categoría"/>',
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
		comboId : "cbCategoriaMonotributo",
		ajaxLink : '${createLink(action:"ajaxGetCategoriasList")}',
		idDefault : '${cuentaInstance?.categoriaMonotributoId}'
	});

	/*** TIPOS CLAVE ***/
	$("#cbTipoClave").select2({
		placeholder: '<g:message code="zifras.cuenta.tipoClave.placeHolder" default="Seleccione un tipo de clave"/>',
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
		comboId : "cbTipoClave",
		ajaxLink : '${createLink(action:"ajaxGetTiposClaveList")}',
		idDefault : '${cuentaInstance?.tipoClaveId}'
	});

	/*** TIPOS Persona ***/
	$("#cbTipoPersona").select2({
		placeholder: '<g:message code="zifras.cuenta.tipoClave.placeHolder" default="Seleccione un tipo de persona"/>',
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
		comboId : "cbTipoPersona",
		ajaxLink : '${createLink(action:"ajaxGetTiposPersonaList")}',
		idDefault : '${cuentaInstance?.tipoPersonaId}'
	});

	/*** IMPUESTOS ***/
	$("#cbModalImpuestoId").select2({
		placeholder: '<g:message code="zifras.cuenta.tipoClave.placeHolder" default="Seleccione un impuesto"/>',
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
		comboId : "cbModalImpuestoId",
		ajaxLink : '${createLink(action:"ajaxGetImpuestosList")}'
	});

	$("#cbImpuestoMonotributo").select2({
		placeholder: '<g:message code="zifras.cuenta.tipoClave.placeHolder" default="Seleccione un impuesto"/>',
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
		comboId : "cbImpuestoMonotributo",
		ajaxLink : '${createLink(action:"ajaxGetImpuestosList")}'
	});

	$("#cbImpuestoAutonomo").select2({
		placeholder: '<g:message code="zifras.cuenta.tipoClave.placeHolder" default="Seleccione un impuesto"/>',
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
		comboId : "cbImpuestoAutonomo",
		ajaxLink : '${createLink(action:"ajaxGetImpuestosList")}'
	});


	$('#cbModalLocalidad').change(function(){
		verificarLocalModal();
	});
	
	$('#cbModalProvincia').change(function(){
		llenarCombo({
			comboId : "cbModalLocalidad",
			ajaxUrlDiv : 'urlGetLocalidades',
			parametros : {
				'provinciaId' : $("#cbModalProvincia").val()
			}
		});
		verificarLocalModal();
	});
	
	$('#cbModalEstado').change(function(){
		verificarLocalModal();
	});
	
	$('#cbModalZona').change(function(){
		verificarLocalModal();
	});
	
	$('#modalLocalDireccion').change(function(){
		verificarLocalModal();
	});
	
	$('#modalLocalPorcentaje').change(function(){
		verificarLocalModal();
	});
	
	$('#modalLocalPorcentajeIIBB').change(function(){
		verificarLocalModal();
	});
	
	/*** PROVINCIAS IIBB ***/
	$("#cbModalAlicuotaIIBBProvincia").select2({
		placeholder: '<g:message code="zifras.Provincia.placeHolder" default="Seleccione una provincia"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbModalAlicuotaIIBBProvincia",
		ajaxUrlDiv : 'urlGetProvincias'
	});

	/*** PROVINCIAS DISTRIBUCION PROVINCIA IIBB ***/
	$("#cbModalPorcentajeProvinciaIIBBProvincia").select2({
		placeholder: '<g:message code="zifras.Provincia.placeHolder" default="Seleccione una provincia"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbModalPorcentajeProvinciaIIBBProvincia",
		ajaxUrlDiv : 'urlGetProvincias'
	});

	/*** ACTIVIDADES DISTRIBUCION PROVINCIA IIBB ***/
	$("#cbModalPorcentajeActividadIIBBActividad").select2({
		placeholder: '<g:message code="zifras.Provincia.placeHolder" default="Seleccione una actividad"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbModalPorcentajeActividadIIBBActividad",
		ajaxUrlDiv : 'urlGetActividades',
		atributo : 'toString'
	});
	
	tablaParientes = $('#listParientes').DataTable({
		//bAutoWidth: false,
		//bSortCellsTop: true,
		//BProcessing: true,
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No tiene parientes')}</a>",
			sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
			sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
			sInfoPostFix: "",
			sUrl: "",
			sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
			oPaginate: {
				"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
				"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
				"sNext":	"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
				"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
			}
		},
		//iDisplayLength: 100,
		//scrollX: true,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
						"mData": "tipoNombre"
					},{
						"aTargets": [1],
						"mData": "nombre"
					},{
						"aTargets": [2],
						"mData": "apellido"
					},{
						"aTargets": [3],
						"mData": "cuil"
					},{
						"aTargets": [4],
						"mData": "fecha",
			       		"type": "date-eu"
					}],
		sPaginationType: 'simple',
		//sDom: "<'row-fluid' <'widget-header' <'span12'<'table-tool-wrapper'><'table-tool-container'>> > > rt <ip>",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showPariente(aData.parienteId, $(listParientes).dataTable().fnGetPosition(nRow), aData.tipoId, aData.nombre, aData.apellido,aData.cuil, aData.fecha)
			});
		}
	});
	
	if($("#id").val()!="")
		getParientes($("#id").val());
	
	tabla = $('#listLocales').DataTable({
		//bAutoWidth: false,
		//bSortCellsTop: true,
		//BProcessing: true,
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay local ¡Agrega un local!')}</a>",
			sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
			sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
			sInfoPostFix: "",
			sUrl: "",
			sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
			oPaginate: {
				"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
				"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
				"sNext":	"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
				"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
			}
		},
		//iDisplayLength: 100,
		//scrollX: true,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
						"mData": "numeroLocal"
					},{
						"aTargets": [1],
						"mData": "direccion"
					},{
						"aTargets": [2],
						"mData": "email"
					},{
						"aTargets": [3],
						"mData": "telefono"
					},{
						"aTargets": [4],
						"mData": "localidadNombre"
					},{
						"aTargets": [5],
						"mData": "zonaNombre"
					},{
						"aTargets": [6],
						"mData": "provinciaNombre"
					},{
						"aTargets": [7],
						"mData": "cantidadEmpleados"
					},{
						"aTargets": [8],
						"mData": "porcentaje"
					},{
						"aTargets": [9],
						"mData": "porcentajeIIBB"
					},{
						"aTargets": [10],
						"mData": "estadoNombre"
					}],
		sPaginationType: 'simple',
		//sDom: "<'row-fluid' <'widget-header' <'span12'<'table-tool-wrapper'><'table-tool-container'>> > > rt <ip>",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				//window.location.href = $('#urlShow').text() + '/' + aData['id'];
				showLocal(aData.localId, $(listLocales).dataTable().fnGetPosition(nRow),aData.numeroLocal, aData.direccion, aData.email, aData.provinciaId, aData.localidadId,aData.zonaId,aData.cantidadEmpleados, aData.porcentaje, aData.telefono, aData.porcentajeIIBB, aData.estadoId)
			});
		}
	});

	if($("#id").val()!="")
		getLocales($("#id").val());

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

setInputFilter(document.getElementById("modalLocalCantidadEmpleados"), function(value) {
  return /^\d*\.?\d*$/.test(value);
});
setInputFilter(document.getElementById("numeroTarjeta"), function(value) {
  return /^\d*\.?\d*$/.test(value);
});
setInputFilter(document.getElementById("modalLocalPorcentaje"), function(value) {
  return /^\d*\.?\d*$/.test(value);
});
setInputFilter(document.getElementById("modalLocalPorcentajeIIBB"), function(value) {
  return /^\d*\.?\d*$/.test(value);
});
		
	tablaAlicuotasIIBB = $('#listAlicuotasIIBB').DataTable({
		//bAutoWidth: false,
		//bSortCellsTop: true,
		//BProcessing: true,
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay alícuota')}</a>",
			sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
			sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
			sInfoPostFix: "",
			sUrl: "",
			sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
			oPaginate: {
				"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
				"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
				"sNext":	"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
				"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
			}
		},
		//iDisplayLength: 100,
		//scrollX: true,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
						"mData": "provinciaNombre"
					},{
						"aTargets": [1],
						"mData": "valor"
					},{
						"aTargets": [2],
						"mData": "porcentaje"
					},{
						"aTargets": [3],
						"mData": "ultimaModificacion"
					}],
		sPaginationType: 'simple',
		//sDom: "<'row-fluid' <'widget-header' <'span12'<'table-tool-wrapper'><'table-tool-container'>> > > rt <ip>",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showAlicuotaIIBB(aData.alicuotaIIBBId, aData.provinciaId, $('#listAlicuotasIIBB').dataTable().fnGetPosition(nRow), aData.valor, aData.porcentaje)
			});
		}
	});

	if($("#id").val()!="")
		getAlicuotasIIBB($("#id").val());

	tablaPorcentajesProvinciaIIBB = $('#listPorcentajesProvinciaIIBB').DataTable({
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay alícuota')}</a>",
			sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
			sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
			sInfoPostFix: "",
			sUrl: "",
			sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
			oPaginate: {
				"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
				"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
				"sNext":	"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
				"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
			}
		},
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
						"mData": "provinciaNombre"
					},{
						"aTargets": [1],
						"mData": "porcentaje"
					},{
						"aTargets": [2],
						"mData": "ultimaModificacion"
					}],
		sPaginationType: 'simple',
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showPorcentajeProvinciaIIBB(aData.porcentajeProvinciaIIBBId, aData.provinciaId, $('#listPorcentajesProvinciaIIBB').dataTable().fnGetPosition(nRow), aData.valor, aData.porcentaje)
			});
		}
	});

	if($("#id").val()!="")
		getPorcentajesProvinciaIIBB($("#id").val());

	tablaImpuestos = $('#listImpuestos').DataTable({
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay impuesto')}</a>",
			sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
			sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
			sInfoPostFix: "",
			sUrl: "",
			sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
			oPaginate: {
				"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
				"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
				"sNext":	"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
				"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
			}
		},
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
						"mData": "impuestoNombre"
					},{
						"aTargets": [1],
						"mData": "periodoMesAno"
					},{
						"aTargets": [2],
						"mData": "monotributo",
						"mRender": function ( data, type, full ) {
			       			if(data == true)
								return '<i class="icofont icofont-ui-check"></i>';
			       			else
				       			return '<i class="icofont icofont-ui-close"></i>';
			   	       	}
					}],
		sPaginationType: 'simple',
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showImpuesto(aData.impuestoId, aData.periodoMesAno, aData.monotributo, $('#listImpuestos').dataTable().fnGetPosition(nRow))
			});
		}
	});

	if($("#id").val()!="")
		getImpuestos();

	tablaPorcentajesActividadIIBB = $('#listPorcentajesActividadIIBB').DataTable({
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay alícuota')}</a>",
			sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
			sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
			sInfoPostFix: "",
			sUrl: "",
			sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
			oPaginate: {
				"sFirst":	"${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
				"sPrevious":"${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
				"sNext":	"${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
				"sLast":	"${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
			}
		},
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
						"mData": "actividadNombre"
					},{
						"aTargets": [1],
						"mData": "porcentaje"
					},{
						"aTargets": [2],
						"mData": "ultimaModificacion"
					}],
		sPaginationType: 'simple',
		//sDom: "<'row-fluid' <'widget-header' <'span12'<'table-tool-wrapper'><'table-tool-container'>> > > rt <ip>",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showPorcentajeActividadIIBB(aData.porcentajeActividadIIBBId, aData.actividadId, $('#listPorcentajesActividadIIBB').dataTable().fnGetPosition(nRow), aData.valor, aData.porcentaje)
			});
		}
	});

	if($("#id").val()!="")
		getPorcentajesActividadIIBB();
		
	$("#fechaContratoSocial").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "d/m/Y",
		lang: "es"
    });
		
	$("#modalImpuestoPeriodo").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "m/Y",
		lang: "es"
    });

	$("#periodoAutonomo").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "m/Y",
		lang: "es"
    });

	$("#periodoMonotributo").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "m/Y",
		lang: "es"
    });
		
	$("#mesCierre").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "m",
		lang: "es"
    });
    
    $("#modalParienteFecha").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "d/m/Y",
		lang: "es"
    });
    
    /*** Tipo de pariente ***/
	$("#modalParienteTipo").select2({
		placeholder: '<g:message code="zifras.Localidad.placeHolder" default="Seleccione un tipo"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		data: tiposDeParientes
	});
    
    $("#cbModalEstado").change(function() {
    	if($("#cbModalEstado").select2('data').text=='Borrado'){
    		$("#modalLocalPorcentaje").val('0');
    	}
    });
    
    $("#modalLocalPorcentaje").change(function() {
    	if($("#cbModalEstado").select2('data').text=='Borrado'){
    		$("#modalLocalPorcentaje").val('0');
    	}else{
    		var porcentaje = $("#modalLocalPorcentaje").val();
    		$("#modalLocalPorcentaje").val(porcentaje.replace(',', '.'));
    	}
    });
    
    $("#modalAlicuotaIIBBValor").change(function() {
    	var valor = $("#modalAlicuotaIIBBValor").val();
    	$("#modalAlicuotaIIBBValor").val(valor.replace(',', '.'));
 
    });
    
    $("#modalAlicuotaIIBBPorcentaje").change(function() {
    	var porcentaje = $("#modalAlicuotaIIBBPorcentaje").val();
    	$("#modalAlicuotaIIBBPorcentaje").val(porcentaje.replace(',', '.'));
 
    });

    $("#modalPorcentajeProvinciaIIBBPorcentaje").change(function() {
    	var porcentaje = $("#modalPorcentajeProvinciaIIBBPorcentaje").val();
    	$("#modalPorcentajeProvinciaIIBBPorcentaje").val(porcentaje.replace(',', '.'));
 
    });
});

function addPariente(){
	var parienteId = 0;
	var tipoId = $("#modalParienteTipo").val();
	var nombre = $("#modalParienteNombre").val();
	var apellido = $("#modalParienteApellido").val();
	var cuil = $("#modalParienteCuil").val();
	var fecha = $("#modalParienteFecha").val();
	
	var tipoNombre;
	if($("#modalParienteTipo").select2('data')[0]!=null)
		tipoNombre = $("#modalParienteTipo").select2('data')[0].text;
	else
		tipoNombre = '';
	
	$('#listParientes').dataTable().fnAddData({
		parienteId: parienteId, 
		tipoId: tipoId,
		tipoNombre: tipoNombre,
		nombre: nombre, 
		apellido: apellido,
		cuil: cuil, 
		fecha: fecha
	});
	$('#parientes').val(JSON.stringify($('#listParientes').dataTable().fnGetData()));
	
	$('#modalPariente').modal('hide');
}

function updatePariente(){
	var parienteId = $('#modalParienteId').val();
	var index2 = parseInt($('#modalParienteIndex').val());
	var tipoId = $("#modalParienteTipo").val();
	//var tipo = $("#modalParienteTipo").val();
	var nombre = $("#modalParienteNombre").val();
	var apellido = $("#modalParienteApellido").val();
	var cuil = $("#modalParienteCuil").val();
	var fecha = $("#modalParienteFecha").val();
	
	var tipoNombre;
	if($("#modalParienteTipo").select2('data')[0]!=null)
		tipoNombre = $("#modalParienteTipo").select2('data')[0].text;
	else
		tipoNombre = '';
	
	$('#listParientes').dataTable().fnUpdate({
		parienteId: parienteId, 
		tipoId: tipoId,
		tipoNombre: tipoNombre,
		nombre: nombre, 
		apellido: apellido,
		cuil: cuil, 
		fecha: fecha
	},index2);
	$('#parientes').val(JSON.stringify($('#listParientes').dataTable().fnGetData()));
	
	$('#modalPariente').modal('hide');
}

function addLocal(){
	var localId = 0;
	var direccion = $("#modalLocalDireccion").val();
	var email = $("#modalLocalEmail").val();
	var provinciaId = $("#cbModalProvincia").val();
	var provinciaNombre = $("#cbModalProvincia").select2('data')[0].text;
	var localidadId = $("#cbModalLocalidad").val();
	var localidadNombre = $("#cbModalLocalidad").select2('data')[0].text;
	var zonaId = $("#cbModalZona").val();
	var zonaNombre;
	var porcentaje = $("#modalLocalPorcentaje").val();
	var cantidadEmpleados = $("#modalLocalCantidadEmpleados").val();
	var numeroLocal = $("#modalLocalNumero").val();
	var telefono = $("#modalLocalTelefono").val();
	var porcentajeIIBB = $("#modalLocalPorcentajeIIBB").val();
	var estadoId = $("#cbModalEstado").val();
	var estadoNombre = $("#cbModalEstado").select2('data')[0].text;
	
	if($("#cbModalZona").select2('data')[0]!=null)
		zonaNombre = $("#cbModalZona").select2('data')[0].text;
	else
		zonaNombre = '';
		
	$('#listLocales').dataTable().fnAddData({
		localId: localId, 
		numeroLocal: numeroLocal,
		direccion: direccion,
		email: email,
		provinciaId: provinciaId, 
		provinciaNombre: provinciaNombre,
		localidadId: localidadId, 
		localidadNombre: localidadNombre,
		zonaId: zonaId, 
		zonaNombre: zonaNombre,
		cantidadEmpleados: cantidadEmpleados,
		porcentaje: porcentaje,
		telefono: telefono,
		porcentajeIIBB: porcentajeIIBB,
		estadoId: estadoId,
		estadoNombre: estadoNombre
	});
	$('#locales').val(JSON.stringify($('#listLocales').dataTable().fnGetData()));
	
	$('#modalLocal').modal('hide');
}

function updateLocal(){
	var localId = $('#modalLocalId').val();
	var index2 = parseInt($('#modalLocalIndex').val());
	var direccion = $("#modalLocalDireccion").val();
	var email = $("#modalLocalEmail").val();
	var provinciaId = $("#cbModalProvincia").val();
	var provinciaNombre = $("#cbModalProvincia").select2('data')[0].text;
	var localidadId = $("#cbModalLocalidad").val();
	var localidadNombre = $("#cbModalLocalidad").select2('data')[0].text;
	var zonaId = $("#cbModalZona").val();
	var zonaNombre;
	var cantidadEmpleados = $("#modalLocalCantidadEmpleados").val();
	var numeroLocal = $("#modalLocalNumero").val();
	var porcentaje = $("#modalLocalPorcentaje").val();
	var telefono = $("#modalLocalTelefono").val();
	var porcentajeIIBB = $("#modalLocalPorcentajeIIBB").val();
	var estadoId = $("#cbModalEstado").val();
	var estadoNombre = $("#cbModalEstado").select2('data')[0].text;
	
	if($("#cbModalZona").select2('data')[0]!=null)
		zonaNombre = $("#cbModalZona").select2('data')[0].text;
	else
		zonaNombre = '';
	
	$('#listLocales').dataTable().fnUpdate({
		localId: localId, 
		numeroLocal: numeroLocal,
		direccion: direccion,
		email: email,
		provinciaId: provinciaId, 
		provinciaNombre: provinciaNombre,
		localidadId: localidadId, 
		localidadNombre: localidadNombre,
		zonaId: zonaId, 
		zonaNombre: zonaNombre,
		cantidadEmpleados: cantidadEmpleados,
		porcentaje: porcentaje,
		telefono: telefono,
		porcentajeIIBB: porcentajeIIBB,
		estadoId: estadoId,
		estadoNombre: estadoNombre
	},index2);
	$('#locales').val(JSON.stringify($('#listLocales').dataTable().fnGetData()));
	
	$('#modalLocal').modal('hide');
}

function addAlicuotaIIBB(){
	var alicuotaIIBBId = 0;
	var provinciaId = $("#cbModalAlicuotaIIBBProvincia").val();
	var provinciaNombre = $("#cbModalAlicuotaIIBBProvincia").select2('data')[0].text;
	var valor = $("#modalAlicuotaIIBBValor").val();
	var porcentaje = $("#modalAlicuotaIIBBPorcentaje").val();
	var estadoId = $("#estadoActivoId").val();
	
	$('#listAlicuotasIIBB').dataTable().fnAddData({
		alicuotaIIBBId: alicuotaIIBBId,
		provinciaId: provinciaId,
		provinciaNombre: provinciaNombre,
		valor: valor, 
		porcentaje: porcentaje,
		estadoId: estadoId,
		ultimaModificacion: ''
	});
	$('#alicuotasIIBB').val(JSON.stringify($('#listAlicuotasIIBB').dataTable().fnGetData()));
	
	$('#modalAlicuotaIIBB').modal('hide');
}

function updateAlicuotaIIBB(){
	deleteAlicuotaIIBB();
	addAlicuotaIIBB();
}

function verificarLocalModal(){
	if( ($("#modalLocalDireccion").val()!='') &&
		($("#cbModalProvincia").val()!='') &&
		($("#cbModalLocalidad").val()!='') &&
		($("#modalLocalPorcentaje").val()!='') &&
		($("#modalLocalPorcentajeIIBB").val()!='') &&
		($("#cbModalEstado").val()!='') ){
		
		$("#buttonLocalAgregar").prop('disabled', false);
		$("#buttonLocalModificar").prop('disabled', false);	
	}else{
		$("#buttonLocalAgregar").prop('disabled', true);
		$("#buttonLocalModificar").prop('disabled', true);
	}
	
}

function showPariente(parienteId, index, tipoId, nombre, apellido, cuil, fecha){
	//Carga de datos de la fila
	$('#modalParienteId').val(parienteId);
	if(parienteId==null){
		$('#modalParienteIndex').val('');
		$("#modalParienteTipo").val('0').trigger("change");
		$("#modalParienteNombre").val('');
		$("#modalParienteApellido").val('');
		$("#modalParienteCuil").val('');
		$("#modalParienteFecha").val('01/01/2000');
		
		$("#buttonParienteAgregar").show();
		$("#buttonParienteEliminar").hide();
		$("#buttonParienteModificar").hide();
	}else{
		$('#modalParienteIndex').val(index);
	
		$('#modalParienteTipo').val(tipoId).trigger("change");
		$("#modalParienteNombre").val(nombre);
		$("#modalParienteApellido").val(apellido);
		$("#modalParienteCuil").val(cuil);
		$("#modalParienteFecha").val(fecha);
		
		$("#buttonParienteAgregar").hide();
		$("#buttonParienteEliminar").show();
			
		$("#buttonParienteModificar").show();
	}
	//verificarParienteModal();
	$('#modalPariente').modal('show');
}

function showLocal(localId, index, numeroLocal, direccion, email, provinciaId, localidadId, zonaId, cantidadEmpleados, porcentaje, telefono, porcentajeIIBB, estadoId){
	//Carga de datos de la fila
	$('#modalLocalId').val(localId);
	
	if(localId==null){
		$('#modalLocalIndex').val('');
		if ($("input[name='locales']").val())
			$("#modalLocalNumero").val($("input[name='locales']").val().split('},').length + 1)
		else
			$("#modalLocalNumero").val(1)
		$("#modalLocalDireccion").val('');
		$("#modalLocalEmail").val('');
		$('#cbModalProvincia').val($("#provinciaCabaId").val()).trigger('change');
		$('#cbModalLocalidad').val($("#localidadCabaId").val()).trigger('change');
		$('#cbModalZona').val('').trigger('change').trigger('change');
		$('#modalLocalCantidadEmpleados').val('');
		$("#modalLocalPorcentaje").val('');
		$("#modalLocalTelefono").val('');
		$("#modalLocalPorcentajeIIBB").val('');
		$('#cbModalEstado').val($("#estadoActivoId").val()).trigger('change');
		
		$("#buttonLocalAgregar").show();
		$("#buttonLocalEliminar").hide();
		$("#buttonLocalModificar").hide();
	}else{
		$('#modalLocalIndex').val(index);
		$('#modalLocalNumero').val(numeroLocal);
		$("#modalLocalDireccion").val(direccion);
		$("#modalLocalEmail").val(email);
		$('#cbModalProvincia').val(provinciaId).trigger('change');
		$('#cbModalLocalidad').val(localidadId).trigger('change');
		$('#cbModalZona').val(zonaId).trigger('change');
		$('#modalLocalCantidadEmpleados').val(cantidadEmpleados);
		$("#modalLocalPorcentaje").val(porcentaje);
		$("#modalLocalTelefono").val(telefono);
		$("#modalLocalPorcentajeIIBB").val(porcentajeIIBB);
		$('#cbModalEstado').val(estadoId).trigger('change');
		
		$("#buttonLocalAgregar").hide();
		if(localId==0)
			$("#buttonLocalEliminar").show();
		else
			$("#buttonLocalEliminar").hide();
			
		$("#buttonLocalModificar").show();
	}
	
	verificarLocalModal();
	$('#modalLocal').modal('show');
}

function showAlicuotaIIBB(alicuotaIIBBId, provinciaId, index, valor, porcentaje){
	//Carga de datos de la fila
	$('#modalAlicuotaIIBBId').val(alicuotaIIBBId);
	
	if(alicuotaIIBBId==null){
		$('#modalAlicuotaIIBBIndex').val('');
		$('#cbModalAlicuotaIIBBProvincia').val($("#provinciaCabaId").val()).trigger("change");;
		$("#modalAlicuotaIIBBValor").val('');
		$("#modalAlicuotaIIBBPorcentaje").val('');
		
		$("#buttonAlicuotaIIBBAgregar").show();
		$("#buttonAlicuotaIIBBEliminar").hide();
		$("#buttonAlicuotaIIBBModificar").hide();

		$("#buttonAlicuotaIIBBAgregar").prop('disabled', false);
		$("#buttonAlicuotaIIBBModificar").prop('disabled', true);
	}else{
		$('#modalAlicuotaIIBBIndex').val(index);
		$('#cbModalAlicuotaIIBBProvincia').val(provinciaId).trigger("change");
		
		$("#modalAlicuotaIIBBValor").val(valor);
		$("#modalAlicuotaIIBBPorcentaje").val(porcentaje);
		
		$("#buttonAlicuotaIIBBAgregar").hide();
		$("#buttonAlicuotaIIBBEliminar").show();
			
		$("#buttonAlicuotaIIBBModificar").show();

		$("#buttonAlicuotaIIBBAgregar").prop('disabled', true);
		$("#buttonAlicuotaIIBBModificar").prop('disabled', false);
	}
	
	$('#modalAlicuotaIIBB').modal('show');
}

function updatePorcentajeProvinciaIIBB(){
	deletePorcentajeProvinciaIIBB();
	addPorcentajeProvinciaIIBB();
}

function updatePorcentajeActividadIIBB(){
	deletePorcentajeActividadIIBB();
	addPorcentajeActividadIIBB();
}

function showPorcentajeProvinciaIIBB(porcentajeProvinciaLocalidadIIBBId = null, provinciaId = null, index = '', valor, porcentaje = ''){
	// TOFIX: No se hace nada con el Valor, utilizar o sacar de los atributos
	if (provinciaId==null)
		provinciaId = $("#provinciaCabaId").val();
	//Carga de datos de la fila
	$('#modalPorcentajeProvinciaIIBBId').val(porcentajeProvinciaLocalidadIIBBId);
	$('#modalPorcentajeProvinciaIIBBIndex').val(index);
	$('#cbModalPorcentajeProvinciaIIBBProvincia').val(provinciaId).trigger("change");
	$("#modalPorcentajeProvinciaIIBBPorcentaje").val(porcentaje);
	if(porcentajeProvinciaLocalidadIIBBId==null){
		$("#buttonPorcentajeProvinciaIIBBAgregar").show();
		$("#buttonPorcentajeProvinciaIIBBEliminar").hide();
		$("#buttonPorcentajeProvinciaIIBBModificar").hide();
		$("#buttonPorcentajeProvinciaIIBBAgregar").prop('disabled', false);
		$("#buttonPorcentajeProvinciaIIBBModificar").prop('disabled', true);
	}else{
		$("#buttonPorcentajeProvinciaIIBBAgregar").hide();
		$("#buttonPorcentajeProvinciaIIBBEliminar").show();
		$("#buttonPorcentajeProvinciaIIBBModificar").show();
		$("#buttonPorcentajeProvinciaIIBBAgregar").prop('disabled', true);
		$("#buttonPorcentajeProvinciaIIBBModificar").prop('disabled', false);
	}
	$('#modalPorcentajeProvinciaIIBB').modal('show');
}

function showPorcentajeActividadIIBB(porcentajeActividadIIBBId = null, actividadId = null, index = '', valor, porcentaje = ''){
	if (actividadId==null)
		actividadId = $("#actividadDefaultId").val();
	//Carga de datos de la fila
	$('#modalPorcentajeActividadIIBBId').val(porcentajeActividadIIBBId);
	$('#modalPorcentajeActividadIIBBIndex').val(index);
	$('#cbModalPorcentajeActividadIIBBActividad').val(actividadId).trigger("change");
	$("#modalPorcentajeActividadIIBBPorcentaje").val(porcentaje);
	if(porcentajeActividadIIBBId==null){
		$("#buttonPorcentajeActividadIIBBAgregar").show();
		$("#buttonPorcentajeActividadIIBBEliminar").hide();
		$("#buttonPorcentajeActividadIIBBModificar").hide();
		$("#buttonPorcentajeActividadIIBBAgregar").prop('disabled', false);
		$("#buttonPorcentajeActividadIIBBModificar").prop('disabled', true);
	}else{
		$("#buttonPorcentajeActividadIIBBAgregar").hide();
		$("#buttonPorcentajeActividadIIBBEliminar").show();
		$("#buttonPorcentajeActividadIIBBModificar").show();
		$("#buttonPorcentajeActividadIIBBAgregar").prop('disabled', true);
		$("#buttonPorcentajeActividadIIBBModificar").prop('disabled', false);
	}
	$('#modalPorcentajeActividadIIBB').modal('show');
}

function addPorcentajeProvinciaIIBB(){
	let porcentaje = $("#modalPorcentajeProvinciaIIBBPorcentaje").val()
	if (! porcentaje)
		porcentaje = "0";
	var porcentajeProvinciaIIBBId = 0;
	var provinciaId = $("#cbModalPorcentajeProvinciaIIBBProvincia").val();
	var provinciaNombre = $("#cbModalPorcentajeProvinciaIIBBProvincia").select2('data')[0].text;
	var estadoId = $("#estadoActivoId").val();

	$('#listPorcentajesProvinciaIIBB').dataTable().fnAddData({
		porcentajeProvinciaIIBBId: porcentajeProvinciaIIBBId,
		provinciaNombre: provinciaNombre,
		provinciaId: provinciaId,
		porcentaje: porcentaje,
		ultimaModificacion: ''
	});
	$('#porcentajesProvinciaIIBB').val(JSON.stringify($('#listPorcentajesProvinciaIIBB').dataTable().fnGetData()));
	

	$('#modalPorcentajeProvinciaIIBB').modal('hide');
}

function addPorcentajeActividadIIBB(){
	var porcentajeActividadIIBBId = 0;
	var actividadId = $("#cbModalPorcentajeActividadIIBBActividad").val();
	var actividadNombre = $("#cbModalPorcentajeActividadIIBBActividad").select2('data')[0].text;
	var porcentaje = $("#modalPorcentajeActividadIIBBPorcentaje").val();
	var estadoId = $("#estadoActivoId").val();

	$('#listPorcentajesActividadIIBB').dataTable().fnAddData({
		porcentajeActividadIIBBId: porcentajeActividadIIBBId,
		actividadNombre: actividadNombre,
		actividadId: actividadId, 
		porcentaje: porcentaje,
		ultimaModificacion: ''
	});
	$('#porcentajesActividadIIBB').val(JSON.stringify($('#listPorcentajesActividadIIBB').dataTable().fnGetData()));
	

	$('#modalPorcentajeActividadIIBB').modal('hide');
}

function deletePorcentajeProvinciaIIBB(){
	var index2 = parseInt($('#modalPorcentajeProvinciaIIBBIndex').val());
	
	if($('#modalPorcentajeProvinciaIIBBId').val()!=0){
		porcentajesProvinciaIIBBBorradas.push(JSON.parse(JSON.stringify($('#listPorcentajesProvinciaIIBB').dataTable().fnGetData(index2))));
		$('#porcentajesProvinciaIIBBBorradas').val(JSON.stringify(porcentajesProvinciaIIBBBorradas));
	}
	 
	$('#listPorcentajesProvinciaIIBB').dataTable().fnDeleteRow(index2);
	$('#porcentajesProvinciaIIBB').val(JSON.stringify($('#listPorcentajesProvinciaIIBB').dataTable().fnGetData()));
	$('#modalPorcentajeProvinciaIIBB').modal('hide');
}

function deletePorcentajeActividadIIBB(){
	var index2 = parseInt($('#modalPorcentajeActividadIIBBIndex').val());
	
	if($('#modalPorcentajeActividadIIBBId').val()!=0){
		porcentajesActividadIIBBBorradas.push(JSON.parse(JSON.stringify($('#listPorcentajesActividadIIBB').dataTable().fnGetData(index2))));
		$('#porcentajesActividadIIBBBorradas').val(JSON.stringify(porcentajesActividadIIBBBorradas));
	}
	 
	$('#listPorcentajesActividadIIBB').dataTable().fnDeleteRow(index2);
	$('#porcentajesActividadIIBB').val(JSON.stringify($('#listPorcentajesActividadIIBB').dataTable().fnGetData()));
	$('#modalPorcentajeActividadIIBB').modal('hide');
}

function getPorcentajesProvinciaIIBB(cuentaId){
	$.ajax({
		url : $('#urlGetPorcentajesProvinciaIIBB').text(),
		data : {
			'id' : cuentaId
		},
		success : function(data) {
			for(key in data){
				$('#listPorcentajesProvinciaIIBB').dataTable().fnAddData(data[key], false);
			}
			$('#listPorcentajesProvinciaIIBB').dataTable().fnDraw();
			
			$('#porcentajesProvinciaIIBB').val(JSON.stringify($('#listPorcentajesProvinciaIIBB').dataTable().fnGetData()));
		},
		error : function() {
		}
	});
}

function getPorcentajesActividadIIBB(){
	const data = JSON.parse('${raw(cuentaInstance.porcentajesActividadIIBB)}')
	for(key in data)
		$('#listPorcentajesActividadIIBB').dataTable().fnAddData(data[key], false);
	$('#listPorcentajesActividadIIBB').dataTable().fnDraw();
	$('#porcentajesActividadIIBB').val(JSON.stringify($('#listPorcentajesActividadIIBB').dataTable().fnGetData()));
}

function deletePariente(){
	var index2 = parseInt($('#modalParienteIndex').val());
	
	if($('#modalParienteId').val()!=0){
		parientesBorrados.push(JSON.parse(JSON.stringify($('#listParientes').dataTable().fnGetData(index2))));
		$('#parientesBorrados').val(JSON.stringify(parientesBorrados));
	}
	
	$('#listParientes').dataTable().fnDeleteRow(index2);
	$('#parientes').val(JSON.stringify($('#listParientes').dataTable().fnGetData()));

	$('#modalPariente').modal('hide');
}

function deleteLocal(){
	var index2 = parseInt($('#modalLocalIndex').val());
	$('#listLocales').dataTable().fnDeleteRow(index2);
	$('#locales').val(JSON.stringify($('#listLocales').dataTable().fnGetData()));

	$('#modalLocal').modal('hide');
}

function deleteAlicuotaIIBB(){
	var index2 = parseInt($('#modalAlicuotaIIBBIndex').val());
	
	if($('#modalAlicuotaIIBBId').val()!=0){
		alicuotasIIBBBorradas.push(JSON.parse(JSON.stringify($('#listAlicuotasIIBB').dataTable().fnGetData(index2))));
		$('#alicuotasIIBBBorradas').val(JSON.stringify(alicuotasIIBBBorradas));
	}
	 
	$('#listAlicuotasIIBB').dataTable().fnDeleteRow(index2);
	$('#alicuotasIIBB').val(JSON.stringify($('#listAlicuotasIIBB').dataTable().fnGetData()));
	$('#modalAlicuotaIIBB').modal('hide');
}

function getParientes(cuentaId){
	$.ajax({
		url : $('#urlGetParientes').text(),
		data : {
			'id' : cuentaId
		},
		success : function(data) {
			for(key in data){
				$('#listParientes').dataTable().fnAddData(data[key], false);
			}
			$('#listParientes').dataTable().fnDraw();
			
			$('#parientes').val(JSON.stringify($('#listParientes').dataTable().fnGetData()));
		},
		error : function() {
		}
	});
}

function getLocales(cuentaId){
	$.ajax({
		url : $('#urlGetLocales').text(),
		data : {
			'id' : cuentaId
		},
		success : function(data) {
			for(key in data){
				$('#listLocales').dataTable().fnAddData(data[key], false);
			}
			$('#listLocales').dataTable().fnDraw();
			
			$('#locales').val(JSON.stringify($('#listLocales').dataTable().fnGetData()));
		},
		error : function() {
		}
	});
}

function getAlicuotasIIBB(cuentaId){
	$.ajax({
		url : $('#urlGetAlicuotasIIBB').text(),
		data : {
			'id' : cuentaId
		},
		success : function(data) {
			for(key in data){
				$('#listAlicuotasIIBB').dataTable().fnAddData(data[key], false);
			}
			$('#listAlicuotasIIBB').dataTable().fnDraw();
			
			$('#alicuotasIIBB').val(JSON.stringify($('#listAlicuotasIIBB').dataTable().fnGetData()));
		},
		error : function() {
		}
	});
}

function showImpuesto(impuestoId = '', periodo = '', monotributo = true, index = ''){
	//Carga de datos de la fila
	$('#cbModalImpuestoId').val(impuestoId).trigger("change");
	$('#modalImpuestoPeriodo').val(periodo);
	$("#checkMonotributo").prop('checked', monotributo);
	$('#modalImpuestoIndex').val(index);
	if(impuestoId==''){
		$("#buttonImpuestoAgregar").show();
		$("#buttonImpuestoEliminar").hide();
		$("#buttonImpuestoModificar").hide();
		$("#buttonImpuestoAgregar").prop('disabled', false);
		$("#buttonImpuestoModificar").prop('disabled', true);
	}else{
		$("#buttonImpuestoAgregar").hide();
		$("#buttonImpuestoEliminar").show();
		$("#buttonImpuestoModificar").show();
		$("#buttonImpuestoAgregar").prop('disabled', true);
		$("#buttonImpuestoModificar").prop('disabled', false);
	}
	$('#modalImpuesto').modal('show');
}

function validarCantidadImpuesto(){
	var impuesto = $("#cbModalImpuestoId").val();
	var periodo = $("#modalImpuestoPeriodo").val();
	var errorString = (impuesto == null || impuesto == "") ? "Debe seleccionar un impuesto." : "";
	if (periodo == null ||periodo == "")
		errorString = (errorString!="" ? (errorString + "\n") : "") + "Debe ingresar la fecha de alta."

	if (errorString!=""){
		swal("Datos incompletos", errorString, "error");
		return false
	}else
		return true
}

function addImpuesto(){
	if (validarCantidadImpuesto()){
		$('#listImpuestos').dataTable().fnAddData({
			impuestoNombre: $("#cbModalImpuestoId").select2('data')[0].text,
			impuestoId: $("#cbModalImpuestoId").val(),
			monotributo: $("#checkMonotributo").prop('checked'),
			periodoMesAno: $("#modalImpuestoPeriodo").val()
		});
		$('#impuestos').val(JSON.stringify($('#listImpuestos').dataTable().fnGetData()));

		$('#modalImpuesto').modal('hide');
	}
}

function deleteImpuesto(){
	$('#listImpuestos').dataTable().fnDeleteRow(parseInt($('#modalImpuestoIndex').val()));
	$('#impuestos').val(JSON.stringify($('#listImpuestos').dataTable().fnGetData()));
	$('#modalImpuesto').modal('hide');
}

function updateImpuesto(){
	if (validarCantidadImpuesto()){
		deleteImpuesto();
		addImpuesto();
	}
}

function getImpuestos(){
	const data = JSON.parse('${raw(cuentaInstance.impuestos)}')
	for(key in data)
		$('#listImpuestos').dataTable().fnAddData(data[key], false);
	$('#listImpuestos').dataTable().fnDraw();
	$('#impuestos').val(JSON.stringify($('#listImpuestos').dataTable().fnGetData()));
}

function llenarComboMedioPago(){
	llenarCombo({
		comboId : "cbMedioPago",
		ajaxLink : '${createLink(action:"ajaxGetMediosPago")}',
		idDefault : '${cuentaInstance?.medioPagoId}',
		parametros : {
			'regimenIibbId' : $("#cbRegimenIibb").val(),
			'condicionIvaId' : $("#cbCondicionIva").val()
		}
	});
}

function llenarComboMedioPagoIva(){
	llenarCombo({
		comboId : "cbMedioPagoIva",
		ajaxLink : '${createLink(action:"ajaxGetMediosPago")}',
		idDefault : '${cuentaInstance?.medioPagoIvaId}',
		parametros : {
			'condicionIvaId' : $("#cbCondicionIva").val()
		}
	});
}

function llenarComboMedioPagoIibb(){
	llenarCombo({
		comboId : "cbMedioPagoIibb",
		ajaxLink : '${createLink(action:"ajaxGetMediosPago")}',
		idDefault : '${cuentaInstance?.medioPagoIibbId}',
		parametros : {
			'regimenIibbId' : $("#cbRegimenIibb").val()
		}
	});
}

</script>