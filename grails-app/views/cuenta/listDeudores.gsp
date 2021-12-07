<!DOCTYPE html>
<html lang="en">

<head>
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
	<meta name="layout" content="main">	
</head>

<body>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-3">
					<div class="page-header-title">
						<div class="d-inline">
							<h4>Lista de Deudores</h4>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listado" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Cuit</th>
									<th>Razón Social</th>
									<th>SM Activo</th>
									<th>Primer Pago</th>
									<th>Cant. SM impagos</th>
									<th>Saldo adeudado</th>
									<th>Bitrix</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
							<tfoot>
								<tr>
									<th colspan="2"></th>
									<th id="cantTotal">a</th>
									<th id="saldoTotal">b</th>
							    </tr>
							</tfoot>
						</table>
					</div>
				</div>
				<!-- Statistics and revenue End -->
			</div>
		</div>
		
	</div>
</div>

<script type="text/javascript">
var tabla;

	jQuery(document).ready(function() {
		tabla = $('#listado').DataTable({
			bAutoWidth: true,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			iDisplayLength: 50,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.ceunta.Deudores.list.agregar', default: 'No hay deudores')}</a>",
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
				[2, 'asc'], // Cantidad
			],
			aoColumnDefs: [{
							"aTargets": [0],
							"mData": "cuit"
						},{
							"aTargets": [1],
							"mData": "razonSocial",
							'sClass': 'bold'
						},{
							"aTargets": [2],
							"mData": "smActivo"
						},{
							"aTargets": [3],
							"mData": "algunSmPago",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				       		}
						},{
							"aTargets": [4],
							"mData": "cantidad",
						},{
							"aTargets": [5],
							"mData": "total",
							"sClass": "text-right",
							"sType": "numeric-comma"
						},{
							"aTargets": [6],
							"mData": "bitrixId",
							"mRender": function ( data, type, full ) {
				       			return data ? '<a target="_blank" href = "https://calim.bitrix24.com/crm/contact/details/'+ data + '/"> ' + data + " </a>" : '-';
				       		}
						}],
			buttons: [
					$.extend(true, {}, {
						exportOptions: {
							format: {
								body: function (data, row, column, node) {
									if (column == 3){
										if (tabla.row(node).data().algunSmPago)
											return "Sí"
										else
											return "No"
									}
									else if (column == 6){
										const bitrixId = tabla.row(node).data().bitrixId
										if (bitrixId)
											return "https://calim.bitrix24.com/crm/contact/details/" + bitrixId
										else
											return "-"
									}
									data = $('<p>' + data + '</p>').text();
									data = data.replace(/\./g, '');
									return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
								}
							}
						}
					}, {
						extend: 'excelHtml5',
						title: function () {
							return "Lista Deudores";
						}
					}),
					{
						extend: 'pdfHtml5',
						orientation: 'landscape',
						title: function () {
							return "Lista Deudores";
						}
					},
					{
						extend: 'copyHtml5'
					}
				],
			sPaginationType: 'simple',
			sDom: "lBfrtip"
		});

		$('#listado').on('click', 'tbody td', function() {
			if (this.cellIndex != 6)
				window.open(
				  "${createLink(action:'show')}" + '/' + tabla.row(this).data().id + "#cuentaCorriente",
				  '_blank' // <- This is what makes it open in a new window.
				);
		})

		llenarDatoslist();
	});

	function llenarDatoslist(){
		$('#loaderGrande').fadeIn("fast");
		tabla.clear().draw();
		$.ajax("${createLink(action:'ajaxObtenerDeudores')}", {
			dataType: "json",
			data: {}
		}).done(function(data) {
			for(key in data.lista)
				tabla.row.add(data.lista[key]);
			$("#cantTotal").text(data.cantidad)
			$("#saldoTotal").text("$" + data.total)
			$('#loaderGrande').fadeOut('slow');
			tabla.draw();
		});
	}
</script>
</body>
</html>
