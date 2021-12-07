<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>
<body>
<div style="display: none;">
	<div id="urlGetCuotas">
		<g:createLink controller="moratoria" action="ajaxGetCuotasMoratoria" />
	</div>
</div>

<g:hiddenField name="cuentaId" value="${cuentaId}"/>
<g:hiddenField id="cantidadCuotas" name="cantidadCuotas" value="${planMoratoriaInstance?.cantidadDeCuotas}"/>
<g:hiddenField id="cuotas" name="cuotas" value="${planMoratoriaInstance?.cuotas}"/>
<g:hiddenField id="planMoratoriaId" name="planMoratoriaId" value="${planMoratoriaInstance?.id}"/>

<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="page-header-title">
				<div class="d-inline">
					<h4>Plan Moratoria Cuenta: ${planMoratoriaInstance?.cuenta.id}</h4>
				</div>
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Fecha de Inicio</label>
			<div class="col-sm-10">
				<h4>${planMoratoriaInstance?.inicio?.toString('dd/MM/YYYY')}</h4>
			</div>
		</div>

		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Cantidad de Cuotas</label>
			<div class="col-sm-10">
				<h4>${planMoratoriaInstance?.getCantidadDeCuotas()}</h4>
			</div>
		</div>

		<div class="form-group row">
			<label class="col-sm-2 col-form-label">Servicio Especial</label>
			<div class="col-sm-10">
				<h4>${planMoratoriaInstance?.servicioEspecialId}</h4>
			</div>
		</div>

		<div class="form-group row">
			<div class="col-sm-12">
				<div class="card">
					<div class="card-header">
						<div class="row">
							<div class="col-lg-8">
								<h5>Cuotas</h5>
							</div>
						</div>				
					</div>
					<div class="card-block">
						<div class="table-responsive">
							<table id="listCuotas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
								<thead>
									<tr>
										<th>Numero</th>
										<th>Importe</th>
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
		<g:link class="btn btn-inverse m-b-0" action="list">
			<g:message code="default.button.back.label" default="Volver" />
		</g:link>
	</div>
</div>

<script type="text/javascript">
	var tablaCuotas
	$(document).ready(function () {
	tablaCuotas = $('#listCuotas').DataTable({
				//bAutoWidth: false,
				//bSortCellsTop: true,
				//BProcessing: true,
				"ordering": true,
				"searching": true,
				oLanguage: {
					sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
					sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
					sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
					sZeroRecords: "${message(code: 'zifras.declaracionJurada.DeclaracionJurada.list.agregar', default: 'No hay Cuotas')}</a>",
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
					[0, 'asc']
				],
				aoColumnDefs: [{
					"aTargets": [0],
					"mData": "numero",
					"sClass" : "text-right"
				}, {
					"aTargets": [1],
					"mData": "importe",
					"sClass" : "text-right"

				}],
				sPaginationType: 'simple',
				fnRowCallback: function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
					// Row click
					/*$(nRow).on('click', function () {
						window.location.href = $('#urlEditDDJJ').text() + '/' + aData['id'];
					});*/
				}
			});

			llenarDatoslistCuotasMoratoria();
	});
	
	function llenarDatoslistCuotasMoratoria(){
		tablaCuotas.clear().draw();
		$.ajax($('#urlGetCuotas').text(), {
			dataType: "json",
			data: {
				planMoratoriaId: $("#planMoratoriaId").val()
			}
		}).done(function(data) {
			for(key in data){
				tablaCuotas.row.add(data[key]);
			}
			tablaCuotas.draw();
		});
	}
</script>
</body>
</html>