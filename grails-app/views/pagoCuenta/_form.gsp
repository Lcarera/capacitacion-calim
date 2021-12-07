<g:hiddenField name="pagoCuentaId" value="${pagoCuentaInstance?.pagoCuentaId}" />
<g:hiddenField name="id" value="${pagoCuentaInstance?.pagoCuentaId}" />
<g:hiddenField name="version" value="${pagoCuentaInstance?.version}" />

<div style="display: none;">
	<div id="urlGetEstados">
		<g:createLink controller="estado" action="ajaxGetpagoCuentaEstados" />
	</div>
	<div id="urlGetCuentas">
		<g:createLink controller="cuenta" action="ajaxGetCuentasNombresSQL" />
	</div>
	<div id="urlDownloadpagoCuenta">
		<g:createLink controller="pagoCuenta" action="download" />
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Cuenta</label>
	<div class="col-sm-10">
		<select id="cbCuenta" name="cuentaId" class="form-control"></select>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Estado</label>
	<div class="col-sm-10">
		<select id="cbEstado" name="estadoId" class="form-control"></select>
	</div>
</div>

<div class="form-group row">	
	<label class="col-sm-2 col-form-label">Importe</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="importe" name="importe" type="text" class="form-control autonumber ${hasErrors(bean: pagoCuentaInstance, field: 'importe', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${pagoCuentaInstance?.importe}">
		</div>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Descripcion</label>
	<div class="col-sm-10">
		<textarea class="form-control" id="descripcion" name="descripcion" rows="3" class="form-control ${hasErrors(bean: pagoCuentaInstance, field: 'descripcion', 'form-control-danger')}">${pagoCuentaInstance?.descripcion}</textarea>
	</div>
</div>

<g:if test="${pagoCuentaInstance?.nombreArchivo}">
	<div class="form-group row">
		<label class="col-sm-2 col-form-label">Archivo actual:</label>
		<div class="col-sm-10">
			<div class="input-group" onclick="">
				<span class="btn btn-primary" onclick="downloadpagoCuenta()">${pagoCuentaInstance?.nombreArchivo} <i class="icofont icofont-download-alt"></i> </span>
			</div>
		</div>
	</div>
</g:if>

<div class="form-group row">
	<label class="col-sm-2 col-form-label"></label>
	<div class="col-sm-10">
        <input type="file" name="archivo" id="archivos_importar">
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Hora de pago</label>
	<div class="col-sm-10">
		<input id="horaPago" name="horaPago" type="time" class="form-control" value="${pagoCuentaInstance?.horaPago}"/>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Fecha de pago</label>
	<div class="col-sm-10">
		<input id="fechaPago" name="fechaPago" class="form-control" type="text" data-format="d/m/Y" placeholder="Seleccione un día" value="${pagoCuentaInstance?.fechaPago?.toString('dd/MM/yyyy')}"/>
	</div>
</div>

<script type="text/javascript">
$(document).ready(function () {
	/*Read Only cuenta:*/
	var actionName = "${actionName}";

	/*** ESTADOS ***/
	$("#cbEstado").select2({
		placeholder: '<g:message code="zifras.pagoCuenta.pagoCuenta.placeHolder" default="Seleccione un estado"/>',
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
		comboId : "cbEstado",
		ajaxUrlDiv : 'urlGetEstados',
		idDefault : '${pagoCuentaInstance?.estadoId}'
	});
	
	/*** CUENTAS ***/
	$("#cbCuenta").select2({
		placeholder: '<g:message code="zifras.cuenta.Cuenta.placeHolder" default="Seleccione una cuenta"/>',
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
		comboId : "cbCuenta",
		ajaxUrlDiv : 'urlGetCuentas',
		idDefault : '${pagoCuentaInstance?.cuentaId}',
		atributo : 'toString',
		readOnly : (actionName == "edit")
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

	//Para el datePicker
    
    $("#fechaPago").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "d/m/Y",
		lang: "es"
    });	
});

function downloadpagoCuenta(){
	window.location.href = $('#urlDownloadpagoCuenta').text() + '/' + "${pagoCuentaInstance?.pagoCuentaId}";
}

</script>
