<div class="card">
	<div class="card-block">
		<div class="dt-responsive table-responsive">
			<div class="col-md-12 row align-items-end">
				<div class="col-md-10 row align-items-end">
					<g:if test="${!!cuentaId}">
						<div class="d-inline">
							<h4>Descargas</h4>
						</div>
					</g:if>
				</div>
				<button style="margin-bottom:20px;" type="button" class="col-md-2 btn btn-primary waves-effect waves-light" onclick="$('#modalAccionesDescargas').modal('show')">Acciones</button>
			</div>
			<table id="listCuentasDescargas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
				<thead>
					<tr>
						<th id="listTh1"></th>
						<th>CUIT</th>
						<th>Local</th>
						<th>Razón Social</th>
						<th>Periodo</th>
						<th>Cond. IVA</th>
						<th>Reg. IIBB</th>
						<th>Comp.</th>
						<th>Iva</th>
						<th>Agip</th>
						<th>Arba</th>
						<th>Sifere</th>
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

<div class="modal fade" id="modalResultadoImportacionDescargas" tabindex="-1" role="dialog">
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
					<table id="listaResultadoDescargas" class="table table-striped table-bordered nowrap" style="width: 100%;">
						<thead>
							<tr>
								<th>Cuenta</th>
								<th>Periodo</th>
								<th>Comprobantes</th>
								<th>R/P Afip</th>
								<th>R/P Agip</th>
								<th>R/P Arba</th>
								<th>R/P Sifere</th>
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

<div class="modal fade" id="modalAccionesDescargas" tabindex="-1" role="dialog">
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
							<input id="comprobantes" name="comprobantes" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Comprobantes</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="descargas_afip" name="afip" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Ret/Per AFIP</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="descargas_agip" name="agip" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Ret/Per AGIP</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="descargas_arba" name="arba" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Ret/Per ARBA</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="descargas_convenio" name="descargas_convenio" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Ret/Per Sifere</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<!-- Espacio separador -->
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="liquidarIVA" checked name="liquidarIVA" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Liquidar IVA</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="liquidarIIBB" checked name="liquidarIIBB" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Liquidar IIBB</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="descargas_forzarOk" name="forzarOk" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Marcar como OK</span>
						</label>
					</div>
				</div>

				<div class="col-md-12">
					<div class="checkbox-fade fade-in-primary">
						<label class="check-task">
							<input id="precargar" checked name="precargar" type="checkbox">
							<span class="cr">
								<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
							</span>
							<span>Precargar</span>
						</label>
					</div>
				</div>

				<br/>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary waves-effect waves-light" data-dismiss="modal" onclick="accionDescargas();">Aceptar</button>
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
	var tablaDescargas;
	var tablaResultadoDescargas;
	var todoSeleccionadoDescargas = false;

		jQuery(document).ready(function() {
			$('#listTh1').click(function() {
				if(todoSeleccionadoDescargas===true){
					$('#listTh1').parent().removeClass("selected");
					todoSeleccionadoDescargas = false;
					tablaDescargas.rows().deselect();
				}else{
					$('#listTh1').parent().addClass("selected");
					todoSeleccionadoDescargas = true;
					tablaDescargas.rows({ page: 'current', filter: 'applied' }).select();
				}
			});

			tablaDescargas = $('#listCuentasDescargas').DataTable({
				//bAutoWidth: false,
				//bSortCellsTop: true,
				//BProcessing: true,
				"ordering": true,
				"searching": true,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay cuentas ¡Agrega una cuenta!')}</a>",
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
					[12, 'desc'],
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
							"mData": "log.comprobantes",
							"mRender": function ( data, type, full ) {
								if (data == null)
									return "-"
								return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
							}
						}, {
							"aTargets": [8],
							"mData": "log.afipRetenciones",
							"mRender": function ( data, type, full ) {
								if (data == null)
									return "-"
								return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
							}
						}, {
							"aTargets": [9],
							"mData": "log.agipRetenciones",
							"mRender": function ( data, type, full ) {
								if (data == null)
									return "-"
								return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
							}
						}, {
							"aTargets": [10],
							"mData": "log.arbaRetenciones",
							"mRender": function ( data, type, full ) {
								if (data == null)
									return "-"
								return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
							}
						},{
							"aTargets": [11],
							"mData": "log.convenioRetenciones",
							"mRender": function ( data, type, full ) {
								if (data == null)
									return "-"
								return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
							}
						},{
							"aTargets": [12],
							"mData": "log.etapa1",
							"mRender": function ( data, type, full ) {
								return data ? '<i class="icofont icofont-ui-check"></i> Si' : '<i class="icofont icofont-error"></i> No';
							}
						},{
							"aTargets": [13],
							"mData": "log.errorE1"
						}
					],
	  			buttons: [
	  				$.extend(true, {}, {
						exportOptions: {
							// columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
							format: {
								body: function (data, row, column, node) {
									if(column >= 7 && column <= 12){
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
						orientation: 'landscape',
						className: 'fred',
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
						// window.location.href = $('#urlShow').text() + '/' + aData['id'];
					});
				}
			});

			tablaResultadoDescargas = $('#listaResultadoDescargas').DataTable({
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
					[1, 'asc'],
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
					"mData": "comprobantes"
				}, {
					"aTargets": [3],
					"mData": "afip"
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
							// columns: [0, 1, 2, 3, 4],
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

			$(document).on('shown.bs.modal', '#modalResultadoImportacionDescargas', function () {
				tablaResultadoDescargas.columns.adjust().draw();
			});

			/*$('#global_filter').keyup(function() {
				tablaDescargas.search($('#global_filter').val()).draw();
			});*/

			llenarListSelenium();
		});

		function accionDescargas(){
			var seleccionados = "";
			const tamanio = tablaDescargas.rows('.selected').data().length
			for(i=0; i < tamanio ; i++){
				if (${!cuentaId})
					seleccionados += tablaDescargas.rows('.selected').data()[i].id;
				else
					seleccionados += tablaDescargas.rows('.selected').data()[i].periodo;

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

			$.ajax("${createLink(controller:'selenium', action:'ejecutarEtapa1')}", {
				dataType: "json",
				method: "POST",
				data: {
					cuentas: ${!cuentaId} ? seleccionados : ${cuentaId},
					periodos: ${!cuentaId} ? "" : seleccionados,
					mes: ${!cuentaId} ? $("#mes").val() : null,
					ano: $("#ano").val(),
					comprobantes: $("#comprobantes").prop('checked'),
					afip: $("#descargas_afip").prop('checked'),
					agip: $("#descargas_agip").prop('checked'),
					arba: $("#descargas_arba").prop('checked'),
					convenio: $("#descargas_convenio").prop('checked'),
					liquidarIVA: $("#liquidarIVA").prop('checked'),
					liquidarIIBB: $("#liquidarIIBB").prop('checked'),
					precargar: $("#precargar").prop('checked'),
					forzarOk: $("#descargas_forzarOk").prop('checked')
				}
			}).done(function(data) {
				if (tamanio <= 3){
					tablaResultadoDescargas.clear()
					for(key in data){
						tablaResultadoDescargas.row.add(data[key]);
					}
					$('#modalResultadoImportacionDescargas').modal('show');
					llenarListSelenium();
				}
			});
		}
</script>