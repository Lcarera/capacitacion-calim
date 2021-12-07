<div class="card">
	<div class="card-block">
		<div class="dt-responsive table-responsive">
			<div class="col-md-12 row align-items-end">
				<div class="col-md-10 row align-items-end">
					<g:if test="${!!cuentaId}">
						<div class="d-inline">
							<h4>Precargas</h4>
						</div>
					</g:if>
				</div>
				<button style="margin-bottom:20px;" type="button" class="col-md-2 btn btn-primary waves-effect waves-light" onclick="$('#modalAccionesPrecargas').modal('show')">Acciones</button>
			</div>
			<table id="listCuentasPrecargas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
				<thead>
					<tr>
						<th id="listTh1"></th>
						<th>CUIT</th>
						<th>Local</th>
						<th>Razón Social</th>
						<th>Periodo</th>
						<th>Cond. IVA</th>
						<th>Reg. IIBB</th>
						<th>Libro IVA</th>
						<th>DDJJ IVA</th>
						<th>Prec. Agip</th>
						<th>Prec. Arba</th>
						<th>Prec. Convenio</th>
						<th>Est.Liq</th>
						<th>Ok</th>
						<th>Error</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>

<div class="modal fade" id="modalResultadoImportacion" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document" style="width:100%;max-width:1250px">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Reporte</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">

				<div class="col-md-12">
					<table id="listaResultadoPrecargas" class="table table-striped table-bordered nowrap" style="width: 100%;">
						<thead>
							<tr>
								<th>Cuenta</th>
								<th>Periodo</th>
								<th>Libro IVA</th>
								<th>DDJJ IVA</th>
								<th>Agip</th>
								<th>Arba</th>
								<th>Convenio</th>
							</tr>
						</thead>
					</table>
				</div>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Continuar</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalAccionesPrecargas" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-sm" role="document" style="width:100%;max-width:625px">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Acciones</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="padding:0px;">
				<br/>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="precargas_afip" name="afip" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Libro IVA AFIP</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="afipDdjj" name="afipDdjj" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>DDJJ IVA AFIP</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="precargas_agip" name="agip" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>IIBB AGIP</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="precargas_arba" name="arba" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>IIBB ARBA</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="convenio" name="convenio" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>IIBB Convenio</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="notificar" name="notificar" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Notificar</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="precargas_forzarOk" name="precargas_forzarOk" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Marcar como OK</span>
						</label>
					</div>
				</div>

				<br/>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal" onclick="accion();">Aceptar</button>
				<button type="button" class="btn btn-default waves-effect" data-dismiss="modal">Cancelar</button>
			</div>
		</div>
	</div>
</div>
<sec:ifAnyGranted roles="ROLE_ADMIN">
	<style type="text/css">
		.fred {
		  height: 36px;
		  width: 65px;
		  text-align: center; 
		}
	</style>
</sec:ifAnyGranted>
<sec:ifAnyGranted roles="ROLE_USER,ROLE_VENTAS,ROLE_COBRANZA,ROLE_SM,ROLE_SE">
	<style type="text/css">
		.fred {
			visibility: hidden;
		}
	</style>
</sec:ifAnyGranted>

<script type="text/javascript">
	var tablaPrecargas;
	var tablaResultadoPrecargas;
	var todoSeleccionadoPrecargas = false;

	jQuery(document).ready(function() {
		$('#listTh1').click(function() {
			if(todoSeleccionadoPrecargas===true){
				$('#listTh1').parent().removeClass("selected");
				todoSeleccionadoPrecargas = false;
				tablaPrecargas.rows().deselect();
			}else{
				$('#listTh1').parent().addClass("selected");
				todoSeleccionadoPrecargas = true;
				tablaPrecargas.rows({ page: 'current', filter: 'applied' }).select();
			}
		});

		tablaPrecargas = $('#listCuentasPrecargas').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "Ninguna cuenta completó la etapa 1.",
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
				},
				buttons: {
					selectAll: "Todos",
					selectNone: "Ninguno"
				}
			},
			iDisplayLength: 25,
			//scrollX: true,
			aaSorting: [
				[4, 'asc'],
				[13, 'desc'],
				[5, 'asc'],
				[6, 'asc'],
				[1, 'asc']
			],
			lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "Todos"]],
			aoColumnDefs: [
					{
						"aTargets": [0],
						'orderable': false,
						'className': 'select-checkbox',
						"mData": "selected"
					},{
						"aTargets": [1],
						"mData": "cuit",
						'sClass': 'bold',
						"visible": ${!cuentaId}
					}, {
						"aTargets": [2],
						"mData": "local",
						"visible": ${!cuentaId && com.zifras.User.get(session.SPRING_SECURITY_CONTEXT?.authentication?.principal?.id)?.userTenantId == 1}
					}, {
						"aTargets": [3],
						"mData": "razonSocial",
						"visible": ${!cuentaId}
					}, {
						"aTargets": [4],
						"mData": "periodo",
						"visible": ${!!cuentaId}
					}, {
						"aTargets": [5],
						"mData": "condicionIva",
						"visible": ${!cuentaId}
					}, {
						"aTargets": [6],
						"mData": "regimenIibb",
						"visible": ${!cuentaId}
					}, {
						"aTargets": [7],
						"mData": "log.precargaIva",
						"mRender": function ( data, type, full ) {
							if (data == null)
								return "-"
							return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
						}
					}, {
						"aTargets": [8],
						"mData": "log.precargaIvaDdjj",
						"mRender": function ( data, type, full ) {
							if (data == null)
								return "-"
							return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
						}
					}, {
						"aTargets": [9],
						"mData": "log.precargaAgip",
						"mRender": function ( data, type, full ) {
							if (data == null)
								return "-"
							return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
						}
					}, {
						"aTargets": [10],
						"mData": "log.precargaArba",
						"mRender": function ( data, type, full ) {
							if (data == null)
								return "-"
							return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
						}
					},{
						"aTargets": [11],
						"mData": "log.precargaConvenio",
						"mRender": function ( data, type, full ) {
							if (data == null)
								return "-"
							return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
						}
					},{
						"aTargets": [12],
						"mData": "estadoLiq"
					},{
						"aTargets": [13],
						"mData": "log.etapa2",
						"mRender": function ( data, type, full ) {
							return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
						}
					},{
						"aTargets": [14],
						"mData": "log.errorE2"
					}
				],
			buttons: [
				$.extend(true, {}, {
					exportOptions: {
						columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,13,14],
						format: {
							body: function (data, row, column, node) {
								if((column==10)||(column==7)||(column==8)||(column==9)||(column==13)){
			            			if(data=='-')
			            				return '-'
			            			else{
			            				if(data=='<i class="icofont icofont-ui-check"></i> Si')
				            				return 'Si'
				            			else
				            				return 'No'	
				            		}
			            		}
								data = $('<p>' + data + '</p>').text();
								const dataNumerica = data.replace(/\./g, '').replace(',', '.');
								return $.isNumeric(dataNumerica) ? dataNumerica : data;
							}
						}
					}
				}, {
					extend: 'excelHtml5',
					className: 'fred',
					title: function () {
						var nombre = "Reporte Selenium"
						return nombre;
					}
				}),
				{
					extend: 'pdfHtml5',
					className: 'fred',
					orientation: 'landscape',
					title: function () {
						var nombre = "Reporte Selenium"
						return nombre;
					}
				},
				{
					extend: 'copyHtml5',
					className: 'fred'
				}],
			sPaginationType: 'simple',
			sDom: "lBfrtip",
			select: {
				 style: 'multi',
				 selector: 'td:first-child'
			},
			fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
				});
			}
		});
		tablaResultadoPrecargas = $('#listaResultadoPrecargas').DataTable({
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "No hubo errores",
				sInfo: "${message(code: 'default.datatable.info', default: 'Mostrando desde _START_ hasta _END_ de _TOTAL_ registros')}",
				sInfoFiltered: "${message(code: 'default.datatable.infoFiltered', default: '(filtrado de _MAX_ registros en total)')}",
				sInfoPostFix: "",
				sUrl: "",
				sInfoEmpty: "${message(code: 'default.datatable.infoEmpty', default: '0 de 0')}",
				oPaginate: {
					"sFirst": "${message(code: 'default.datatable.paginate.first', default: 'Primero')}",
					"sPrevious": "${message(code: 'default.datatable.paginate.previous', default: 'Anterior')}",
					"sNext": "${message(code: 'default.datatable.paginate.next', default: 'Siguiente')}",
					"sLast": "${message(code: 'default.datatable.paginate.last', default: '&Uacute;ltimo')}"
				}
			},
			aaSorting: [
				[1, 'desc'],
				[0, 'asc']
			],
			aoColumnDefs: [{
				"aTargets": [0],
				"mData": "cuenta",
				"visible": ${!cuentaId}
			}, {
				"aTargets": [1],
				"mData": "mes",
				"visible": ${!!cuentaId}
			}, {
				"aTargets": [2],
				"mData": "libroIva"
			}, {
				"aTargets": [3],
				"mData": "ddjjIva"
			}, {
				"aTargets": [4],
				"mData": "agip"
			}, {
				"aTargets": [5],
				"mData": "arba"
			}, {
				"aTargets": [6],
				"mData": "convenio"
			}],
			"scrollX": true,
			sPaginationType: 'simple',
			buttons: [
				$.extend(true, {}, {
					exportOptions: {
						columns: [0, 1, 2, 3, 4, 5, 6],
						format: {
							body: function (data, row, column, node) {
								data = $('<p>' + data + '</p>').text();
								const dataNumerica = data.replace(/\./g, '').replace(',', '.');
								return $.isNumeric(dataNumerica) ? dataNumerica : data;
							}
						}
					}
				}, {
					extend: 'excelHtml5',
					title: function () {
						var nombre = "Reporte Selenium"
						return nombre;
					}
				}),
				{
					extend: 'pdfHtml5',
					orientation: 'landscape',
					title: function () {
						var nombre = "Reporte Selenium"
						return nombre;
					}
				},
				{
					extend: 'copyHtml5'
				}
			],
			sDom: "lBfrtip"
		});

		$(document).on('shown.bs.modal', '#modalResultadoImportacion', function () {
			tablaResultadoPrecargas.columns.adjust().draw();
		});

		llenarListSelenium();
		
		/*$('#global_filter').keyup(function() {
			tablaPrecargas.search($('#global_filter').val()).draw();
		});*/
	});

	function accion(){
		var seleccionados = "";
		const tamanio = tablaPrecargas.rows('.selected').data().length
		for(i=0; i < tamanio ; i++){
			if (!${cuentaId})
				seleccionados += tablaPrecargas.rows('.selected').data()[i].id;
			else
				seleccionados += tablaPrecargas.rows('.selected').data()[i].periodo;

			if(i != (tamanio - 1)){
				seleccionados += ',';
			}
		}
		if (!seleccionados){
			swal("Error","No hay cuentas seleccionadas","error")
			return
		}
		if (tamanio > 3)
			swal("Selenium en proceso", "Recibirás un email con el resultado cuando el proceso termine." , "info")
		else
			$('#loaderGrande').show()
		$.ajax("${createLink(controller:'selenium', action:'ejecutarEtapa2')}", {
			dataType: "json",
			method: "POST",
			data: {
				cuentas: ${!cuentaId} ? seleccionados : ${cuentaId},
				periodos: ${!cuentaId} ? "" : seleccionados,
				mes: ${!cuentaId} ? $("#mes").val() : null,
				ano: $("#ano").val(),
				libroIva: $("#precargas_afip").prop('checked'),
				ddjjIva: $("#afipDdjj").prop('checked'),
				agip: $("#precargas_agip").prop('checked'),
				arba: $("#precargas_arba").prop('checked'),
				notificar: $("#notificar").prop('checked'),
				convenio: $("#convenio").prop('checked'),
				forzarOk: $("#precargas_forzarOk").prop('checked')
			}
		}).done(function(data) {
			if (tamanio <= 3){
				tablaResultadoPrecargas.clear()
				for(key in data){
					tablaResultadoPrecargas.row.add(data[key]);
				}
				$('#modalResultadoImportacion').modal('show');
				llenarListSelenium();
			}
		});
	}
</script>