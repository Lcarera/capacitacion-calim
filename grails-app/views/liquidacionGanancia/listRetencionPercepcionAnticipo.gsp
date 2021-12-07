<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetLiquidacionesGananciaList">
		<g:createLink controller="liquidacionGanancia" action="ajaxGetLiquidacionesGananciaList" />
	</div>
	<div id="urlShow">
		<g:createLink controller="liquidacionGanancia" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="liquidacionGanancia" action="edit" />
	</div>
	<div id="urlCreate">
		<g:createLink controller="liquidacionGanancia" action="create" />
	</div>
	<div id="urlModificarRetencionPercepcionAnticipo">
		<g:createLink controller="liquidacionGanancia" action="ajaxModificarRetencionPercepcionAnticipo" />
	</div>
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-10">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.liquidacion.LiquidacionGanancia.RetencionPercepcionAnticipo.list.label" default="Retenciones/Percepciones/Anticipos"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-2">
					<div style="text-align:right;">
						<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<div id="preloader" class="preloader3" style="display:none;height:50px;">
							<div class="circ1 loader-primary"></div>
							<div class="circ2 loader-primary"></div>
							<div class="circ3 loader-primary"></div>
							<div class="circ4 loader-primary"></div>
						</div>
						<table id="listCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Cuit</th>
									<th>Razón Social</th>
									<th>Estado</th>
									<th>Zona</th>
									<th>Direccion</th>
									<th>Ret.</th>
									<th>Per.</th>
									<th>Anticipo</th>
									<th>Imp.Deb/Cred</th>
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

<div class="modal fade" id="modalRetencionPercepcionAnticipo" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Editar</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group row" style="margin-bottom:0px;">
					<label class="col-sm-3 col-form-label">Período</label>
					<label class="col-sm-9" id="anoLabel"></label>
					
					<label class="col-sm-3 col-form-label">CUIT</label>
					<label class="col-sm-9" id="cuitLabel"></label>
					
					<label class="col-sm-3 col-form-label">Cuenta</label>
					<label class="col-sm-9" id="cuentaNombreLabel"></label>
					
					<label class="col-sm-3 col-form-label">Retenciones</label>
					<div class="col-sm-9">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="retencionModal" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
					<label class="col-sm-3 col-form-label">Percepciones</label>
					<div class="col-sm-9">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="percepcionModal" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
					<label class="col-sm-3 col-form-label">Anticipos</label>
					<div class="col-sm-9">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="anticipoModal" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
					<label class="col-sm-3 col-form-label">Impuesto Debito/Crédito</label>
					<div class="col-sm-9">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="impuestoDebitoCreditoModal" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="botonRetencionPercepcionAnticipo" type="button" class="btn btn-primary waves-effect waves-light" onclick="modificarRetencionPercepcionAnticipo();">Modificar</button>
				<button type="button" class="btn btn-inverse m-b-0" data-dismiss="modal">Volver</button>
			</div>
		</div>
	</div>
</div>


<script type="text/javascript">
var tabla;
var itemSeleccionado;

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
    
		tabla = $('#listCuentas').DataTable({
		//bAutoWidth: false,
		//bSortCellsTop: true,
		//BProcessing: true,
		"ordering": true,
		"searching": true,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando liquidaciones')}</a>",
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
		       			"mData": "cuentaCuit",
			   			'sClass': 'bold'
					},{
		       			"aTargets": [1],
		       			"mData": "cuentaNombre"
		       		},{
		       			"aTargets": [2],
		       			"mData": "estado"
		       		},{
		       			"aTargets": [3],
		       			"mData": "zonas"
					},{
		       			"aTargets": [4],
		       			"mData": "direcciones"
			       	},{
		       			"aTargets": [5],
		       			"mData": "retencion",
		       			"sClass" : "text-right"
			       	},{
		       			"aTargets": [6],
		       			"mData": "percepcion",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [7],
		       			"mData": "anticipos",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [8],
		       			"mData": "impuestoDebitoCredito",
		       			"sClass" : "text-right"
					}],
    	select: {
             style: 'os',
             selector: 'td:first-child',
             style: 'multi'
        },
        buttons: [
                $.extend( true, {}, buttonCommon, {
  					extend: 'excelHtml5',
  					exportOptions: {
     	            		columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
     	            	},
  					title: function () {
  							var nombre = "Liquidaciones Ganancias " + $("#ano").val();
  							return nombre;
  						}
  				} ),
     	            {
     	            	extend: 'pdfHtml5',
     	            	exportOptions: {
     	            		columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
     	            	},
     	            	orientation: 'landscape',
     	            	title: function () {
  						var nombre = "Liquidaciones Ganancias " + $("#ano").val();
  						return nombre;
  					}
  				},
  				{
  					extend: 'copyHtml5',
  					exportOptions: {
  						columns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
     	            	},
  				}
     	        ],
		sPaginationType: 'simple',
   		sDom: "lBfrtip",
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).bind('click', function() {
				$("#cuitLabel").text(aData['cuentaCuit']);
				$("#anoLabel").text(aData['ano']);
				$("#cuentaNombreLabel").text(aData['cuentaNombre']);
				if((aData['retencion']!=null)&&(aData['retencion']!='')){
					$("#retencionModal").val(aData['retencion'].toString().replace(".", ""));
				}else{
					$("#retencionModal").val('0,00');
				}
				if((aData['percepcion']!=null)&&(aData['percepcion']!='')){
					$("#percepcionModal").val(aData['percepcion'].toString().replace(".", ""));
				}else{
					$("#percepcionModal").val('0,00');
				}
				if((aData['anticipos']!=null)&&(aData['anticipos']!='')){
					$("#anticipoModal").val(aData['anticipos'].toString().replace(".", ""));
				}else{
					$("#anticipoModal").val('0,00');
				}
				if((aData['impuestoDebitoCredito']!=null)&&(aData['impuestoDebitoCredito']!='')){
					$("#impuestoDebitoCreditoModal").val(aData['impuestoDebitoCredito'].toString().replace(".", ""));
				}else{
					$("#impuestoDebitoCreditoModal").val('0,00');
				}
				
				$("#modalRetencionPercepcionAnticipo").modal({
					show: true
				});

				itemSeleccionado = aData;			
			});
		}
	});

	llenarDatoslistLiquidacionesGanancia();

	$("#ano").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "Y",
		minYear: 2010,
		maxYear: 2040,
		lang: "es"
    });

	$("#ano").change(function () {
		llenarDatoslistLiquidacionesGanancia();
	});

	$("#retencionModal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#percepcionModal").focus().select();
		}
	});

	$("#percepcionModal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#anticipoModal").focus().select();
		}
	});

	$("#anticipoModal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#impuestoDebitoCreditoModal").focus();
		}
	});

	$("#impuestoDebitoCreditoModal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#botonRetencionPercepcionAnticipo").focus();
		}
	});
});

function llenarDatoslistLiquidacionesGanancia(){
	var ano = $("#ano").val();
	tabla.clear().draw();
	$("#preloader").show();
	$.ajax($('#urlGetLiquidacionesGananciaList').text(), {
		dataType: "json",
		data: {
			ano: ano
		}
	}).done(function(data) {
		$("#preloader").hide();
		for(key in data){
			tabla.row.add(data[key]);
		}
		tabla.draw();
	});
}

function modificarRetencionPercepcionAnticipo(){
	itemSeleccionado.retencion = $("#retencionModal").val();
	itemSeleccionado.percepcion = $("#percepcionModal").val();
	itemSeleccionado.anticipos = $("#anticipoModal").val();
	itemSeleccionado.impuestoDebitoCredito = $("#impuestoDebitoCreditoModal").val();

	$.ajax($('#urlModificarRetencionPercepcionAnticipo').text(), {
		method: "POST",
		dataType: "json",
		data: itemSeleccionado
	}).done(function(data) {
		var rows = tabla.rows().data();
		var indexesLiquidaciones = tabla.rows().indexes();
		var indexTable=null;
		for(var i=0; i < rows.length; i++) {
			if(data.cuentaId == rows[i].cuentaId){
				indexTable = indexesLiquidaciones[i];
			}
		}
		if(indexTable!=null){
			var liquidacion = tabla.row(indexTable).data();
			liquidacion = data;
			tabla.row(indexTable).data(liquidacion);
		}

		$("#modalRetencionPercepcionAnticipo").modal('hide');
	});
}
</script>
</body>
</html>