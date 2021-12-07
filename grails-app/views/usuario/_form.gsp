<g:hiddenField name="usuarioId" value="${usuarioInstance?.usuarioId}" />
<g:hiddenField name="id" value="${usuarioInstance?.usuarioId}" />

<g:hiddenField name="accountExpired" value="${usuarioInstance?.accountExpired}" />
<g:hiddenField name="accountLocked" value="${usuarioInstance?.accountLocked}" />
<g:hiddenField name="passwordExpired" value="${usuarioInstance?.passwordExpired}" />

<div style="display: none;">
	<div id="urlGetRoles">
		<g:createLink controller="usuario" action="ajaxGetRolesBackoffice" />
	</div>
</div>

<div class="form-group ${hasErrors(bean: usuarioInstance, field: 'username', 'has-danger')} row">
	<label class="col-sm-2 col-form-label">Email</label>
	<div class="col-sm-10">
		<input name="username" type="text" class="form-control ${hasErrors(bean: usuarioInstance, field: 'username', 'form-control-danger')}" value="${usuarioInstance?.username}">
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Rol</label>
	<div class="col-sm-10">
		<select id="cbRole" name="roleId" class="form-control"></select>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Estudio</label>
	<div class="col-sm-10">
		<select id="cbEstudio" name="userTenantId" class="form-control"></select>
	</div>
</div>


<div class="checkbox-fade fade-in-primary">
    <label>
        <g:checkBox name="enabled" value="${usuarioInstance?.enabled}" />
        <span class="cr">
            <i class="cr-icon icofont icofont-ui-check txt-primary"></i>
        </span>
        <span>Habilitado</span>
    </label>
</div>
<script type="text/javascript">
$(document).ready(function () {

	/*** CBO ESTUDIO ***/
	$("#cbEstudio").select2({
		placeholder: '<g:message code="zifras.liquidacion.tipoRetPer.placeHolder" default="Seleccionar..."/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: 1,
		data: [
		    {
		        id: '1',
		        text: 'Estudio Pavoni'
		    },
		    {
		        id: '2',
		        text: 'Calim'
		    }
		]
	});
	$("#cbEstudio").val(${usuarioInstance?.userTenantId?.toString()}).trigger("change");

	/*** Role ***/
	$("#cbRole").select2({
		placeholder: '<g:message code="zifras.Role.placeHolder" default="Seleccione un rol"/>',
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
		comboId : "cbRole",
		ajaxUrlDiv : 'urlGetRoles',
		idDefault : '${usuarioInstance?.roleId}'
	});
});
</script>