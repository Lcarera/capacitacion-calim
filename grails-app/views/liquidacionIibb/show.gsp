<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlGetAlicuotas">
		<g:createLink controller="liquidacionIibb" action="ajaxGetAlicuotas" />
	</div>
</div>
<div class="main-body">
	<div class="page-wrapper">
	
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-8">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="default.show.label" default="Mostrar {0}" args="['Liquidación IIBB']"/></h4>
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
				<div class="col-md-12">
					<div class="card">
						<div class="card-block typography">
							<div class="row">
								<div class="col-md-6">
									<g:if test="${liquidacionIIBBInstance?.fecha}">
									<div class="row">
										<div class="col-5">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-calendar"></i> <g:message code="zifras.liquidacion.LiquidacionIIBB.fecha.label" default="Fecha" /></h6>
										</div>
										<div class="col-7">
											<h6 class="m-b-30">${liquidacionIIBBInstance?.fecha?.toString('dd/MM/yyyy')}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${liquidacionIIBBInstance?.cuenta}">
									<div class="row">
										<div class="col-5">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-id"></i> <g:message code="zifras.liquidacion.LiquidacionIIBB.razonSocial.label" default="Razón Social" /></h6>
										</div>
										<div class="col-7">
											<h6 class="m-b-30">${liquidacionIIBBInstance?.cuenta?.cuit} - ${liquidacionIIBBInstance?.cuenta?.razonSocial}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${liquidacionIIBBInstance?.provincia}">
									<div class="row">
										<div class="col-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.provincia.label" default="Provincia" /></h6>
										</div>
										<div class="col-7">
											<h6 class="m-b-30">${liquidacionIIBBInstance?.provincia?.nombre}</h6>
										</div>
									</div>
									</g:if>
								</div>
								<div class="col-md-6">
									<g:if test="${liquidacionIIBBInstance?.estado}">
									<div class="row">
										<div class="col-5">
											<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.estado.label" default="Estado" /></h6>
										</div>
										<div class="col-7">
											<h6 class="m-b-30">${liquidacionIIBBInstance?.estado?.nombre}</h6>
										</div>
									</div>
									</g:if>
									<g:if test="${liquidacionIIBBInstance?.saldoDdjj!=null}">
									<div class="row">
										<div class="col-5">
											<h6 class="f-w-400 m-b-30"><i class="icofont icofont-coins"></i> <g:message code="zifras.liquidacion.LiquidacionIIBB.saldoDdjj.label" default="Saldo DDJJ" /></h6>
										</div>
										<div class="col-7">
											<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIIBBInstance?.saldoDdjj, , type:'currency', currencySymbol:'$')}</div>
										</div>
									</div>
									</g:if>
									<g:if test="${liquidacionIIBBInstance?.fechaVencimiento}">
										<div class="row">
											<div class="col-5">
												<h6 class="f-w-400 m-b-30"><i class="icofont icofont-calendar"></i> <g:message code="zifras.liquidacion.LiquidacionIIBB.fechaVencimiento.label" default="Vencimiento" /></h6>
											</div>
											<div class="col-7">
												<h6 class="m-b-30">${liquidacionIIBBInstance?.fechaVencimiento?.toString('dd/MM/yyyy')}</h6>
											</div>
										</div>
									</g:if>
								</div>
							</div>
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Ventas</h4>
									<div class="row">
										<div class="col-md-6">
											<g:if test="${liquidacionIIBBInstance?.netoTotal!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.netoTotal.label" default="Neto total" /></h6>
												</div>
												<div class="col-7">
													<h6 class="m-b-30">${formatNumber(number: liquidacionIIBBInstance?.netoTotal, , type:'currency', currencySymbol:'$')}</h6>
												</div>
											</div>
											</g:if>
											<g:if test="${liquidacionIIBBInstance?.neto!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.neto.label" default="Neto" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIIBBInstance?.neto, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
										
										<div class="col-md-6">
											<g:if test="${liquidacionIIBBInstance?.porcentajeProvincia!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.porcentajeProvincia.label" default="Provincia" /></h6>
												</div>
												<div class="col-7">
													<h6 class="m-b-30">${formatNumber(number: liquidacionIIBBInstance?.porcentajeProvincia, type:'number')} %</h6>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Cálculo Impuesto IIBB</h4>
									<div class="table-responsive">
										<table id="listAlicuotas" class="table table-striped table-bordered nowrap" style="">
											<thead>
												<tr>
													<th>Alícuota</th>
													<th>%</th>
													<th>Base imponible</th>
													<th>Impuesto</th>
												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
									<div class="row">
										<div class="col-md-6">
											<g:if test="${liquidacionIIBBInstance?.impuesto!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.impuesto.label" default="Impuesto" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIIBBInstance?.impuesto, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Deducciones</h4>
									<div class="row">
										<div class="col-md-6">
											<g:if test="${liquidacionIIBBInstance?.retencion!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.retencion.label" default="Retenciones" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIIBBInstance?.retencion, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
											<g:if test="${liquidacionIIBBInstance?.percepcion!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.percepcion.label" default="Percepciones" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIIBBInstance?.percepcion, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
										
										<div class="col-md-6">
											<g:if test="${liquidacionIIBBInstance?.sircreb!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.sircreb.label" default="Sircreb" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${formatNumber(number: liquidacionIIBBInstance?.sircreb, , type:'currency', currencySymbol:'$')}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								</div>
							</div>
							
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Saldo a favor del Contribuyente</h4>
									<div class="row">
										<div class="col-md-6">
											<g:if test="${liquidacionIIBBInstance?.saldoAFavor!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.saldoAFavor.label" default="Período actual" /></h6>
												</div>
												<div class="col-7">
													<h6 class="m-b-30">${formatNumber(number: liquidacionIIBBInstance?.saldoAFavor, , type:'currency', currencySymbol:'$')}</h6>
												</div>
											</div>
											</g:if>
										</div>
										
										<div class="col-md-6">
											<g:if test="${liquidacionIIBBInstance?.saldoAFavorPeriodoAnterior!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.saldoAFavorPeriodoAnterior.label" default="Período anterior" /></h6>
												</div>
												<div class="col-7">
													<h6 class="m-b-30">${formatNumber(number: liquidacionIIBBInstance?.saldoAFavorPeriodoAnterior, , type:'currency', currencySymbol:'$')}</h6>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								</div>
							</div>
							
							<g:if test="${(liquidacionIIBBInstance?.ultimaModificacion!=null) || (liquidacionIIBBInstance?.ultimoModificador!=null)}">
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Última modificación</h4>
									<div class="row">
										<div class="col-md-6">
											<g:if test="${liquidacionIIBBInstance?.ultimaModificacion!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.ultimaModificacion.label" default="Fecha/hora" /></h6>
												</div>
												<div class="col-7">
													<h6 class="m-b-30">${liquidacionIIBBInstance?.ultimaModificacion?.toString('dd/MM/yyyy HH:mm')}</h6>
												</div>
											</div>
											</g:if>
										</div>
										
										<div class="col-md-6">
											<g:if test="${liquidacionIIBBInstance?.ultimoModificador!=null}">
											<div class="row">
												<div class="col-5">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.ultimoModificador.label" default="Responsable" /></h6>
												</div>
												<div class="col-7">
													<div class="f-w-700 text-primary">${liquidacionIIBBInstance?.ultimoModificador}</div>
												</div>
											</div>
											</g:if>
										</div>
									</div>
								</div>
							</div>
							</g:if>
							
							<g:if test="${(liquidacionIIBBInstance?.nota!=null)}">
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title">Nota</h4>
									<div class="row">
										<div class="col-md-12">
											<div class="row">
												<div class="col-2">
													<h6 class="f-w-400 m-b-30"><g:message code="zifras.liquidacion.LiquidacionIIBB.nota.label" default="Nota" /></h6>
												</div>
												<div class="col-10">
													<h6 class="m-b-30">${liquidacionIIBBInstance?.nota}</h6>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							</g:if>
							
							<div class="row">
								<div class="col-md-12">
									<h4 class="sub-title"></h4>
									<sec:ifAnyGranted roles="ROLE_ADMIN">
										<g:link class="btn btn-primary m-b-0" action="edit" id="${liquidacionIIBBInstance?.id}"><g:message code="default.button.edit.label" default="Editar" /></g:link>
										<button type="button" class="btn btn-primary m-b-0" onclick="$('#modalPresentarDDJJ').modal('show');">Presentar</button>
										<g:if test="${liquidacionIIBBInstance?.estado?.nombre == 'Presentada'}">
											<button type="button" class="btn btn-primary m-b-0" onclick="$('#modalVep').modal('show');">Subir VEP</button>
										</g:if>
										<g:elseif test="${liquidacionIIBBInstance?.estado?.nombre != 'Autorizada'}">
											<button type="button" class="btn btn-primary m-b-0" onclick="notificar()">Notificar</button>
										</g:elseif>
										<button type="button" class="btn btn-danger alert-success-cancel m-b-0" onclick="eliminar(false)"><g:message code="default.button.delete.label" default="Eliminar" /></button>
										<g:if test="${! ['Presentada','Autorizada'].contains(liquidacionIIBBInstance.estado.nombre)}">
											<button type="button" class="btn btn-danger alert-success-cancel m-b-0" onclick="eliminar(true)">Rehacer</button>
										</g:if>
									</sec:ifAnyGranted>
									<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalPresentarDDJJ" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Presentar Declaración Jurada</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<g:uploadForm controller="declaracionJurada" action="savePorLiquidacionIibb">
				<div class="modal-body">
					<g:hiddenField name="cuentaId" value="${liquidacionIIBBInstance?.cuenta.id}" />
					<g:hiddenField name="liquidacionId" value="${liquidacionIIBBInstance?.id}" />
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">Fecha</label>
						<div class="col-sm-10">
							<input id="modalDdjjFecha" name="fecha" required="" class="form-control" type="text" data-format="d/m/Y" placeholder="Seleccione un día" value="${fechaHoy}" />
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">Descripcion</label>
						<div class="col-sm-10">
							<textarea class="form-control" id="modalDdjjDescripcion" name="descripcion" rows="3"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2 col-form-label"></label>
						<div class="col-sm-10">
							<input type="file" name="archivo" id="archivos_importar">
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
					<button class="btn btn-primary waves-effect waves-light " onclick="">Presentar</button>
				</div>
			</div>
		</g:uploadForm>
	</div>
</div>

<div class="modal fade" id="modalVep" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4>Adjuntar VEP a DDJJ</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:uploadForm name="declaracionFormVep" controller="vep" action="subirPorLiquidacion">
					<g:hiddenField name="esIva" value="false"/>
					<g:hiddenField name="liqId" value="${liquidacionIIBBInstance.id}"/>
					<g:hiddenField name="cuentaId" value="${liquidacionIIBBInstance.cuenta.id}" />
					<div class="form-group row">
						<div class="col-sm-12">
							<input type="file" name="archivo" id="modalVepArchivo">
						</div>
					</div>
				</g:uploadForm>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button class="btn btn-primary waves-effect waves-light " onclick="$('#declaracionFormVep').submit();">Adjuntar</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var tablaAlicuotas;
$(document).ready(function () {
	tablaAlicuotas = $('#listAlicuotas').DataTable({
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay alícuotas')}</a>",
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
						"mData": "alicuota"
					},{
						"aTargets": [1],
						"mData": "porcentaje"
					},{
						"aTargets": [2],
						"mData": "baseImponible",
						"sClass" : "text-right"
					},{
						"aTargets": [3],
						"mData": "impuesto",
						"sClass" : "text-right"
					}],
		sPaginationType: 'simple',
		sDom: "rt",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			
		}
	});
	
	getAlicuotas();

	$("#modalDdjjFecha").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "d/m/Y",
		lang: "es"
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

	$('#modalVepArchivo').filer({
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

function getAlicuotas(){
	var liquidacionIIBBId = ${liquidacionIIBBInstance?.id};
	
	$.ajax({
		url : $('#urlGetAlicuotas').text(),
		data : {
			'liquidacionIIBBId' : liquidacionIIBBId
		},
		success : function(data) {
			for(key in data){
				$('#listAlicuotas').dataTable().fnAddData(data[key], false);
			}
			$('#listAlicuotas').dataTable().fnDraw();
			
			$('#alicuotas').val(JSON.stringify($('#listAlicuotas').dataTable().fnGetData()));
		},
		error : function() {
		}
	});
}

function eliminar(rehacer){
	swal({
		title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
		text: "La liquidación de IIBB se eliminará" + (rehacer ? " para todo el mes.\nSe generará una nueva con los datos importados." : "."),
		type: "warning",
		showCancelButton: true,
		confirmButtonClass: "btn-danger",
		confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, eliminar'/>",
		cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
		closeOnConfirm: true,
		closeOnCancel: true
	},
	function(isConfirm) {
		if (isConfirm)
			if (rehacer)
				window.location.href = "${raw(createLink(action:'liquidacionAutomatica', params:[cuentaId:liquidacionIIBBInstance.cuenta.id, mes: liquidacionIIBBInstance.fecha.toString('MM'), ano: liquidacionIIBBInstance.fecha.toString('yyyy')]))}"
			else
				window.location.href = "${createLink(action:'delete', id:liquidacionIIBBInstance.id)}"
	});
}
function notificar(){
	swal({
		title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
		text: "<g:message code='zifras.liquidacion.notificaciones.message' default='Se enviarán las notificaciones de liquidación lista a los usuarios'/>",
		type: "warning",
		showCancelButton: true,
		confirmButtonClass: "btn-danger",
		confirmButtonText: "<g:message code='zifras.enviar.ok' default='Si, enviar'/>",
		cancelButtonText: "<g:message code='zifras.enviar.cancel' default='No, cancelar'/>",
		closeOnConfirm: true,
		closeOnCancel: true
	},
	function(isConfirm) {
		if (isConfirm){
			$.ajax("${createLink(controller:'liquidacionIibb', action: 'ajaxEnviarNotificaciones')}", {
				dataType: "json",
				method: "POST",
				data: {
					ano: "${liquidacionIIBBInstance.fecha.toString('yyyy')}",
					mes: "${liquidacionIIBBInstance.fecha.toString('MM')}",
					cuentasIds: "${liquidacionIIBBInstance.cuenta.id}"
				}
			}).done(function(data) {					
				swal("Notificaciones enviadas!", "El cliente ha recibido el mail para autorizar.", "success");
			});
		}
	})
}
</script>
</body>
</html>