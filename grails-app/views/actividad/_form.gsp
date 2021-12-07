<%@ page import="com.zifras.User" %>
<g:set var="userLogged" value="${User.get(session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id)}"/>
<input id="userTenantId" name="userTenantId" type="hidden" class=""  value="${userLogged?.userTenantId}"/>
<g:hiddenField name="actividadId" value="${actividadInstance?.actividadId}" />
<g:hiddenField name="id" value="${actividadInstance?.actividadId}" />
<g:hiddenField name="version" value="${actividadInstance?.version}" />

<div style="display: none;">

</div>

<div class="form-group ${hasErrors(bean: actividadInstance, field: 'codigo', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Código</label>
	<div class="col-sm-10">
		<input name="codigo" type="text" class="form-control ${hasErrors(bean: actividadInstance, field: 'codigo', 'form-control-danger')}" value="${actividadInstance.codigo}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: actividadInstance, field: 'nombre', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Nombre</label>
	<div class="col-sm-10">
		<input name="nombre" type="text" class="form-control ${hasErrors(bean: actividadInstance, field: 'nombre', 'form-control-danger')}" value="${actividadInstance.nombre}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: actividadInstance, field: 'codigoAfip', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Código AFIP</label>
	<div class="col-sm-10">
		<input name="codigoAfip" type="text" class="form-control ${hasErrors(bean: actividadInstance, field: 'codigoAfip', 'form-control-danger')}" value="${actividadInstance.codigoAfip}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: actividadInstance, field: 'codigoNaes', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Código NAES</label>
	<div class="col-sm-10">
		<input name="codigoNaes" type="text" class="form-control ${hasErrors(bean: actividadInstance, field: 'codigoNaes', 'form-control-danger')}" value="${actividadInstance.codigoNaes}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: actividadInstance, field: 'codigoCuacm', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Código CUACM</label>
	<div class="col-sm-10">
		<input name="codigoCuacm" type="text" class="form-control ${hasErrors(bean: actividadInstance, field: 'codigoCuacm', 'form-control-danger')}" value="${actividadInstance.codigoCuacm}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: actividadInstance, field: 'descripcionAfip', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Descripción AFIP</label>
	<div class="col-sm-10">
		<input name="descripcionAfip" type="text" class="form-control ${hasErrors(bean: actividadInstance, field: 'descripcionAfip', 'form-control-danger')}" value="${actividadInstance.descripcionAfip}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: actividadInstance, field: 'descripcionNaes', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Descripción NAES</label>
	<div class="col-sm-10">
		<input name="descripcionNaes" type="text" class="form-control ${hasErrors(bean: actividadInstance, field: 'descripcionNaes', 'form-control-danger')}" value="${actividadInstance.descripcionNaes}">
	</div>
</div>

<div class="form-group ${hasErrors(bean: actividadInstance, field: 'descripcionCuacm', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Descripción CUACM</label>
	<div class="col-sm-10">
		<input name="descripcionCuacm" type="text" class="form-control ${hasErrors(bean: actividadInstance, field: 'descripcionCuacm', 'form-control-danger')}" value="${actividadInstance.descripcionCuacm}">
	</div>
</div>

<g:if test="${userLogged?.userTenantId!=2}">
<div class="form-group ${hasErrors(bean: actividadInstance, field: 'utilidadMaxima', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Utilidad máxima</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">%</span>
			<input id="utilidadMaxima" name="utilidadMaxima" type="text" class="form-control autonumber ${hasErrors(bean: actividadInstance, field: 'utilidadMaxima', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${actividadInstance?.utilidadMaxima}">
		</div>
	</div>
</div>
</g:if>

<g:if test="${userLogged?.userTenantId!=2}">
<div class="form-group ${hasErrors(bean: actividadInstance, field: 'utilidadMinima', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Utilidad mínima</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">%</span>
			<input id="utilidadMinima" name="utilidadMinima" type="text" class="form-control autonumber ${hasErrors(bean: actividadInstance, field: 'utilidadMinima', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${actividadInstance?.utilidadMinima}">
		</div>
	</div>
</div>
</g:if>

<script type="text/javascript">
$(document).ready(function () {
	
});
</script>