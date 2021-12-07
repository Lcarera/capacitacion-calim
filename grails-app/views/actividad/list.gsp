<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
	<div class="theme-loader" id="loaderGrande">
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
</head>

<body>
<%@ page import="com.zifras.User" %>
<div style="display: none;">
	<div id="urlGetActividades">
		<g:createLink controller="actividad" action="ajaxGetActividades" />
	</div>
	<div id="urlShow">
		<g:createLink controller="actividad" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="actividad" action="edit" />
	</div>
	<g:set var="userLogged" value="${User.get(session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id)}"/>
	<input id="userTenantId" name="userTenantId" type="hidden" class=""  value="${userLogged?.userTenantId}"/>
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-7">
					<div class="page-header-title">
						<div class="d-inline">
							<h4><g:message code="zifras.cuenta.Actividad.list.label" default="Lista de Actividades"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-5">
					<div class="card-header-right" style="text-align:right;">
						<button id="buttonImportar" type="button" class="btn btn-primary" onclick="$('#modalImport').modal('show');">Importar Actividades</button>
						<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Actividad']"/></g:link>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listActividades" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Código</th>
									<th>Nombre</th>
									<th>Código AFIP</th>
									<th>Código NAES</th>
									<th>Código CUACM</th>
									<th>Descrip. AFIP</th>
									<th>Descrip. NAES</th>
									<th>Descrip. CUACM</th>
									<th>Utilidad Max.</th>
									<th>Utilidad Min.</th>
									<th>Alicuotas CABA</th>
									<th>Alicuotas BsAs</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Statistics and revenue End -->
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalImport" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Importar actividades</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">
				<g:uploadForm name="importacionActividades" controller="importacion" action="importacionActividades">
					<div class="card-block">
						<input type="file" name="files" id="archivos_importar" multiple="multiple">
					</div>
				</g:uploadForm>
			</div>
			<div class="modal-footer">
				<button id="buttonLocalVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonLocalAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="$('#importacionActividades').submit();">Aceptar</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var tabla;
var estudio = true;
if($('#userTenantId').val()=='2')
	estudio =false;

jQuery(document).ready(function() {
	var buttonCommon = {
			exportOptions: {
				format: {
					body: function ( data, row, column, node ) {
						data = $('<p>' + data + '</p>').text();
						data = data.replace(/\./g, '');
						return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
					}
				}
			}
		};

	tabla = $('#listActividades').DataTable({
		//bAutoWidth: false,
		//bSortCellsTop: true,
		//BProcessing: true,
		"ordering": true,
		"searching": true,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay actividades')}</a>",
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
						"mData": "codigo",
						'sClass': 'bold'
					},{
						"aTargets": [1],
						"mData": "nombre"
					},{
						"aTargets": [2],
						"mData": "codigoAfip"
					},{
						"aTargets": [3],
						"mData": "codigoNaes"
					},{
						"aTargets": [4],
						"mData": "codigoCuacm",
						'sClass': 'bold'
					},{
						"aTargets": [5],
						"mData": "descripcionAfip"
					},{
						"aTargets": [6],
						"mData": "descripcionNaes"
					},{
						"aTargets": [7],
						"mData": "descripcionCuacm"
					},{
						"aTargets": [8],
						"mData": "utilidadMaxima",
						"sClass" : "text-right",
						"visible" : estudio
					},{
						"aTargets": [9],
						"mData": "utilidadMinima",
						"sClass" : "text-right",
						"visible" : estudio
					},{
						"aTargets": [10],
						"mData": "cantidadAlicuotasCaba",
						"sClass" : "text-right",
						"visible" : !estudio
					},{
						"aTargets": [11],
						"mData": "cantidadAlicuotasBuenosAires",
						"sClass" : "text-right",
						"visible" : !estudio
					}],
		sDom: "lBfrtip",
		buttons: [
			$.extend( true, {}, buttonCommon, {
			extend: 'excelHtml5',
			title: function () {
				var nombre = "Actividades Calim";
				return nombre;
				}
			} ),
			'copyHtml5'
		],
		sPaginationType: 'simple',
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).on('click', function() {
				window.location.href = $('#urlEdit').text() + '/' + aData['id'];
			});
		}
	});

	llenarDatoslistActividades();

	$('#archivos_importar').filer({
		limit: null,
		maxSize: null,
		extensions: null,
		changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Arrastrá los archivos acá</h3> <span style="display:inline-block; margin: 15px 0">ó</span></div><a class="jFiler-input-choose-btn btn btn-primary waves-effect waves-light">Seleccionar archivos</a></div></div>',
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
});

function llenarDatoslistActividades(){
	$.ajax($('#urlGetActividades').text(), {
		dataType: "json",
		data: {
		}
	}).done(function(data) {
		for(key in data){
			tabla.row.add(data[key]);
		}
		tabla.draw();
		$('#loaderGrande').fadeOut('slow', function() {
			$(this).hide();
		});
	});
}
</script>
</body>
</html>