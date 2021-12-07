<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
	<style>
		.resaltadoTabla{
			background-color: #E6F4F4!important;
			color: black!important;
		}
	</style>
</head>

<body>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-sm-6">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.cuenta.MiCuenta.CuentaCorriente.list.label" default="Cuenta Corriente"/></h4>
						</div>
					</div>
				</div>
				<div class="col-sm-6" style="text-align:right;">
					<div class="page-header-title">
						<div class="">
							<span style="font-size: 18px; color:#000; margin-top: 5px;">Saldo a pagar</span>
							<h3 style="float:right; margin-left: 10px;">${formatNumber(number: saldo*(-1), type:'currency', currencySymbol:'\$')}</h3>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->

		<div class="page-body tab-icon">
			 <div class="row">
			 	<div class="col-sm-12">
			 		<div class="card">

			 			<div class="card-block tab-icon">
			 				<div class="row">
			 					<div class="col-lg-12 col-xl-12">
									<div class="tab-content card-block">
										<div class="tab-pane active" id="movimientos">
											<div class="dt-responsive table-responsive">
												<div id="preloaderMovimientos" class="preloader3" style="display:none;height:50px;">
													<div class="circ1 loader-primary"></div>
													<div class="circ2 loader-primary"></div>
													<div class="circ3 loader-primary"></div>
													<div class="circ4 loader-primary"></div>
												</div>
												<div style="float:right;">
													<label class="btn btn-primary" onclick="showModalPago();" style="float:left;padding-top:8px;margin-right:10px;margin-bottom:2px;text-transform: none">Pagar seleccionadas</label>
												</div>
												<table id="listMovimientos" class="table table-striped table-bordered nowrap" style="cursor: pointer;">
													<thead>
														<tr>
															<th id="listMovimientosTh1"></th>
															<th>Fecha</th>
															<th>Tipo</th>
															<th>Pagado</th>
															<th>Descripción</th>
															<th>Importe</th>
															<th>Saldo</th>
															<th>Milisegundos</th>
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
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var tablaMovimientos;
	var todoSeleccionado = false;

jQuery(document).ready(function() {
	var buttonCommon = {
        exportOptions: {
        	columns: [1, 2, 3, 4, 5, 6],
            format: {
            	body: function ( data, row, column, node ) {
                	data = $('<p>' + data + '</p>').text();
                	data = data.replace(/\./g, '');
                	return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
                }
            }
        }
    };


	$('#listMovimientosTh1').click(function() {
		if(todoSeleccionado===true){
			$('#listMovimientosTh1').parent().removeClass("selected");
			todoSeleccionado = false;
			tablaMovimientos.rows().deselect();
		}else{
			$('#listMovimientosTh1').parent().addClass("selected");
			todoSeleccionado = true;
			tablaMovimientos.rows( function (index, data, nodo) {
				return ! data.pagado;
			} ).select();
		}
	});
    
	tablaMovimientos = $('#listMovimientos').DataTable({
		"ordering": true,
		"searching": true,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay movimientos')}</a>",
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
			[7, 'desc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
			   			'orderable': false,
			   			'className': 'select-checkbox',
			   			"mData": "selected"
					},{
			   			"aTargets": [1],
			   			'orderable': false,
			   			"mData": "fechaHora",
			       		"type": "date-eu"
					},{
		       			"aTargets": [2],
		       			"mData": "tipo",
			   			'orderable': false,
			   			'sClass': 'bold'
					},{
		       			"aTargets": [3],
			   			'orderable': false,
						"mRender": function ( data, type, full ) {
							return full.pagado ? '<i class="icofont icofont-ui-check"></i>' : '-';
			   	       	}
		       		},{
		       			"aTargets": [4],
			   			'orderable': false,
		       			"mData": "descripcion"
		       		},{
		       			"aTargets": [5],
			   			'orderable': false,
		       			"mData": "importe",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [6],
			   			'orderable': false,
		       			"mData": "saldo",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [7],
		       			"mData": "milisegundos"
		       		}],
       	select: {
	        style: 'multi',
	        selector: 'td:first-child'
        },
    	buttons: [
   	            $.extend( true, {}, buttonCommon, {
					extend: 'excelHtml5',
					exportOptions: {
   	            		columns: [1, 2, 3, 4, 5, 6]
   	            	},
   	            	title: function () {
							var nombre = "Movimientos Cuenta Corrinete ";
							return nombre;
						}
				} ),
   	            {
   	            	extend: 'pdfHtml5',
   	            	exportOptions: {
   	            		columns: [1, 2, 3, 4, 5, 6]
   	            	},
   	            	orientation: 'landscape',
   	            	title: function () {
						var nombre = "Movimientos Cuenta Corriente ";
						return nombre;
					}
				},
				{
					extend: 'copyHtml5',
					exportOptions: {
   	            		columns: [1, 2, 3, 4, 5, 6]
   	            	},
				}
   	        ],
		sPaginationType: 'simple',
		sDom: "lBfrtip",
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
   	   		if (aData['positivo']){
   	   			const color = aData['tipo'] == 'Pago Reembolsado' ? "#CD6155" : "#b1c91e"
   	   			$(nRow).css({
   	   				"color": color,
   	   				"font-weight": "bold"
   	   			})
   	   		}
	   		$(nRow).on('click', function () {
				// Despinto todas
				tablaMovimientos.rows().every(function (rowIdx, tableLoop, rowLoop) {
					$(this.node()).removeClass('resaltadoTabla');
				});
				// Pinto las que corresponden
				tablaMovimientos.rows(function (index, data, nodo) {
					return aData.movimientosRelacionados.includes(data.id);
				}).every(function (rowIdx, tableLoop, rowLoop) {
					$(this.node()).addClass('resaltadoTabla');
				});
				$(nRow).addClass('resaltadoTabla')
			});
		}
	});

	tablaMovimientos.on( 'user-select', function ( e, dt, type, cell, originalEvent ) {
		const data = dt.row( cell.index().row ).data();
        if (data.pagado) {
            e.preventDefault();
        }
    } );

	llenarDatoslistMovimientos();
});

function llenarDatoslistMovimientos(){
	tablaMovimientos.clear().draw();
	$("#preloaderMovimientos").show();
	$.ajax('${createLink(action:"ajaxGetMovimientosList")}', {
		dataType: "json",
		method: "POST",
		data: {			
		}
	}).done(function(data) {
		$("#preloaderMovimientos").hide();
		for(key in data){
			tablaMovimientos.row.add(data[key]);
		}
		tablaMovimientos.draw();
		tablaMovimientos.column(7).visible(false)
	});
}

function showModalPago(){
	let total = 0;
	let listaIds = [];
	for(i=0; i < tablaMovimientos.rows('.selected').data().length ; i++){
		const data = tablaMovimientos.rows('.selected').data()[i];
		total+=parseFloat(data.importe.replace(".", "").replace(",", "."));
		listaIds.push(data.id);
	}
	if (total == 0){
		swal("Debe seleccionar los movimientos a pagar", "No puede generarse un botón de pago para el importe seleccionado.", "error");
		return
	}
    swal({
        title: "¿Generar botón de pago?",
        text: 'La suma total de los movimientos seleccionados es de \$' + total.toFixed(2).replace(".", ","),
        type: "warning",
        showCancelButton: true,
        confirmButtonClass: "btn-danger",
        confirmButtonText: "<g:message code='zifras.generar.ok' default='Si, generar'/>",
        cancelButtonText: "<g:message code='zifras.generar.cancel' default='No, cancelar'/>",
        closeOnConfirm: true,
        closeOnCancel: true
    },
    function(isConfirm) {
    	if (isConfirm){
			const urlBase = "${raw(createLink(controller: 'pagoCuenta', action: 'pagarMovimientos', params:['movimientos': 'variableListaIds']))}"
			window.location.href = urlBase.replace('variableListaIds', escape(listaIds));
		}
    });
}
</script>
</body>
</html>