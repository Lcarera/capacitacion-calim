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
<div style="display: none;">
	<div id="urlGetLiquidacionesIvaList">
		<g:createLink controller="liquidacionIva" action="ajaxGetLiquidacionesIvaList" />
	</div>
	<div id="urlShow">
		<g:createLink controller="liquidacionIva" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="liquidacionIva" action="edit" />
	</div>
	<div id="urlCreate">
		<g:createLink controller="liquidacionIva" action="create" />
	</div>
	<div id="urlLiquidacionMasiva">
		<g:createLink controller="liquidacionIva" action="ajaxLiquidacionMasiva" />
	</div>
	<div id="urlLiquidacionMasiva2">
		<g:createLink controller="liquidacionIva" action="ajaxLiquidacionMasiva2" />
	</div>
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-4">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.liquidacion.LiquidacionIva.list.label" default="Liq. Masiva de IVA"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div style="text-align:right;">
						<input id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
						<!--<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Liquidacion']"/></g:link>-->
					</div>
				</div>
				<div class="col-lg-4">
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
						<button style="margin-bottom:20px;" type="button" class="btn btn-primary waves-effect waves-light" onclick="liquidacionMasivaModal();">Liquidar</button>
						<table id="listLiquidaciones" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th id="listLiquidacionesTh1"></th>
									<th>Cuit</th>
									<th>Razón Social</th>
									<th>Estado</th>
									<th>FV</th>
									<th>FC</th>
									<th>%D/C</th>
									<th>S DDJJ</th>
									<th>Déb.</th>
									<th>DF21</th>
									<th>DF10</th>
									<th>DF27</th>
									<th>NoGrav V</th>
									<th>Exento V</th>
									<th>Créd.</th>
									<th>CF21</th>
									<th>CF10</th>
									<th>CF27</th>
									<th>NoGrav C</th>
									<th>Exento C</th>
									<th>ST</th>
									<th>ST Ant.</th>
									<th>SLD</th>
									<th>SLD Ant.</th>
									<th>Ret.</th>
									<th>Per.</th>
									<th>Nota</th>
									<th>Zona</th>
									<th>Direccion</th>
									<th>Cant. Locales</th>
									<th>Locales</th>
									<th>Advertencia</th>
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

<div class="modal fade" id="modalLiquidacionMasiva" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Liquidar</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group row" style="margin-bottom:0px;">
					<div class="col-sm-12">
						<div class="checkbox-fade fade-in-primary">
							<label class="check-task">
								<input id="checkLiquidacion" type="checkbox" value="">
								<span class="cr">
									<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
								</span>
								<span>Nuevo</span>
							</label>
						</div>
					</div>

					<div class="col-sm-12">
						<div class="checkbox-fade fade-in-primary">
							<label class="check-task">
								<input id="checkRetPer" type="checkbox" value="">
								<span class="cr">
									<i class="cr-icon icofont icofont-ui-check txt-primary"></i>
								</span>
								<span>Pisar Ret/Per</span>
							</label>
						</div>
					</div>
									
					<label class="col-sm-3 col-form-label">Período</label>
					<label class="col-sm-9" id="mesAnoLabel"></label>
					
					<label class="col-sm-3 col-form-label">Cant. cuentas</label>
					<label class="col-sm-9" id="cantidadCuentas"></label>
					
					<label class="col-sm-3 col-form-label">% Saldo DDJJ</label>
					<div class="col-sm-9">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">%</span>
							<input id="porcentajeSaldoDdjj" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
					<label id="labelPorcentajeDebito" class="col-sm-3 col-form-label">% Débito</label>
					<div id="valorPorcentajeDebito" class="col-sm-9">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">%</span>
							<input id="porcentajeDebitoFiscal" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="botonLiquidacionMasiva" type="button" class="btn btn-primary waves-effect waves-light" onclick="liquidacionMasiva();">Liquidar</button>
				<button type="button" class="btn btn-inverse m-b-0" data-dismiss="modal">Volver</button>
			</div>
		</div>
	</div>
</div>


<script type="text/javascript">
var tabla;
var todoSeleccionado = false;
var nuevo = false;

jQuery(document).ready(function() {
	$('#listLiquidacionesTh1').click(function() {
		if(todoSeleccionado===true){
			$('#listLiquidacionesTh1').parent().removeClass("selected");
			todoSeleccionado = false;
			tabla.rows().deselect();
		}else{
			$('#listLiquidacionesTh1').parent().addClass("selected");
			todoSeleccionado = true;
			tabla.rows({ filter: 'applied' }).select();
		}
	});
	
	var buttonCommon = {
        exportOptions: {
        	columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31],
        	rows: { selected: true },
            format: {
            	body: function ( data, row, column, node ) {
            		if((column==3)||(column==4)){
            			if(data=='-')
            				return 'No'
            			else
            				return 'Si'
            		}
                	data = $('<p>' + data + '</p>').text();
                	data = data.replace(/\./g, '');
                    return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
                }
            }
        }
    };
    
	tabla = $('#listLiquidaciones').DataTable({
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
			},
			buttons: {
	            selectAll: "Todos",
	            selectNone: "Ninguno"
	        }
		},
		//iDisplayLength: 100,
		//scrollX: true,
		aaSorting: [
			[1, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
			   			'orderable': false,
			   			'className': 'select-checkbox',
			   			"mData": "selected"
					},{
		       			"aTargets": [1],
		       			"mData": "cuentaCuit",
			   			'sClass': 'bold'
					},{
		       			"aTargets": [2],
		       			"mData": "cuentaNombre"
		       		},{
		       			"aTargets": [3],
		       			"mData": "estado"
		       		},{
		       			"aTargets": [4],
		       			"mData": "facturasVentaImportadas",
						"mRender": function ( data, type, full ) {
			       			if(data == "Importado")
								return '<i class="icofont icofont-ui-check"></i>';
			       			else
				       			return "-";
			   	       	}
		       		},{
		       			"aTargets": [5],
		       			"mData": "facturasCompraImportadas",
						"mRender": function ( data, type, full ) {
			       			if(data == "Importado")
								return '<i class="icofont icofont-ui-check"></i>';
			       			else
				       			return "-";
			   	       	}
		       		},{
		       			"aTargets": [6],
		       			"mData": "porcentajeDebitoCredito",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [7],
		       			"mData": "saldoDdjj",
		       			"sClass" : "text-right"
			       	},{
		       			"aTargets": [8],
		       			"mData": "debitoFiscal",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [9],
		       			"mData": "debitoFiscal21",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [10],
		       			"mData": "debitoFiscal10",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [11],
		       			"mData": "debitoFiscal27",
		       			"sClass" : "text-right"
					},{
						"aTargets": [12],
		       			"mData": "totalNoGravadoVenta",
		       			"sClass" : "text-right"
					},{
						"aTargets": [13],
		       			"mData": "totalExentoVenta",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [14],
		       			"mData": "creditoFiscal",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [15],
		       			"mData": "creditoFiscal21",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [16],
		       			"mData": "creditoFiscal10",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [17],
		       			"mData": "creditoFiscal27",
		       			"sClass" : "text-right"
					},{
						"aTargets": [18],
		       			"mData": "totalNoGravadoCompra",
		       			"sClass" : "text-right"
					},{
						"aTargets": [19],
		       			"mData": "totalExentoCompra",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [20],
		       			"mData": "saldoTecnicoAFavor",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [21],
		       			"mData": "saldoTecnicoAFavorPeriodoAnterior",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [22],
		       			"mData": "saldoLibreDisponibilidad",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [23],
		       			"mData": "saldoLibreDisponibilidadPeriodoAnterior",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [24],
		       			"mData": "retencion",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [25],
		       			"mData": "percepcion",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [26],
		       			"mData": "nota"
					},{
		       			"aTargets": [27],
		       			"mData": "zonas"
					},{
		       			"aTargets": [28],
		       			"mData": "direcciones"
					},{
		       			"aTargets": [29],
		       			"mData": "cantidadLocales",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [30],
		       			"mData": "locales",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [31],
		       			"mData": "advertencia"
					}],
		buttons: [
		            'copy', 'csv', 'excel', 'pdf', 'print'
		        ],
    	select: {
             style: 'multi',
             selector: 'td:first-child'
        },
        buttons: [
				'selectAll',
				'selectNone',
     	            $.extend( true, {}, buttonCommon, {
  					extend: 'excelHtml5',
  					title: function () {
  							var nombre = "Liquidaciones IVA " + $("#mes").val() + "-" + $("#ano").val();
  							return nombre;
  						}
  				} ),
     	            {
     	            	extend: 'pdfHtml5',
     	            	exportOptions: {
     	            		rows: { selected: true },
     	            		columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
     	            	},
     	            	orientation: 'landscape',
     	            	title: function () {
  						var nombre = "Liquidaciones IVA " + $("#mes").val() + "-" + $("#ano").val();
  						return nombre;
  					}
  				},
  				{
  					extend: 'copyHtml5',
  					exportOptions: {
  							rows: { selected: true },
     	            		columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
     	            	}
  				}
     	        ],
		sPaginationType: 'simple',
		sDom: "lBfrtip",
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
   			if(aData['advertencia']!=''){
   	   			$(nRow).css({"background-color":"red","color":"white"});
   	   	   	}
   	   	   	// Row click
			/*$(nRow).on('click', function() {
				if(aData['estado']!='Sin liquidar'){
					window.location.href = $('#urlShow').text() + '/' + aData['id'];
				}else{
					window.location.href = $('#urlCreate').text() + '/?cuentaId=' + aData['cuentaId'];
				}				
			});*/
		}
	});

	llenarDatoslistLiquidacionesIva();

	$("#mes").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "m",
		lang: "es"
    });

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
		llenarDatoslistLiquidacionesIva();
	});

	$("#mes").change(function () {
		llenarDatoslistLiquidacionesIva();
	});
	
	$("#checkLiquidacion").change(function () {
		nuevo = !nuevo;
		if(nuevo){
			$("#labelPorcentajeDebito").hide();
			$("#valorPorcentajeDebito").hide();
		}else{
			$("#labelPorcentajeDebito").show();
			$("#valorPorcentajeDebito").show();
		}
	});

	$("#porcentajeSaldoDdjj").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#porcentajeDebitoFiscal").focus().select();
		}
	});

	$("#porcentajeDebitoFiscal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#botonLiquidacionMasiva").focus();
		}
	});
});

function llenarDatoslistLiquidacionesIva(){
	var ano = $("#ano").val();
	var mes = $("#mes").val();
	tabla.clear().draw();
	$("#loaderGrande").show();
	$.ajax($('#urlGetLiquidacionesIvaList').text(), {
		dataType: "json",
		method: "POST",
		data: {
			ano: ano,
			mes: mes
		}
	}).done(function(data) {
		$("#loaderGrande").hide();
		for(key in data){
			tabla.row.add(data[key]);
		}
		tabla.draw();
	});
}

function liquidacionMasivaModal(){
	$("#mesAnoLabel").text($("#mes").val() + ' / ' + $("#ano").val());
	$("#cantidadCuentas").text(tabla.rows('.selected').data().length);

	$("#porcentajeSaldoDdjj").val('1,00');
	$("#porcentajeDebitoFiscal").val('1,00');

	$("#modalLiquidacionMasiva").modal({
		show: true
	});	
}

function liquidacionMasiva(){
	var cuentasIds = "";
	for(i=0; i < tabla.rows('.selected').data().length ; i++){
		cuentasIds += tabla.rows('.selected').data()[i].cuentaId;

		if(i != (tabla.rows('.selected').data().length - 1)){
			cuentasIds += ',';
		}
	}

	var ano = $("#ano").val();
	var mes = $("#mes").val();

	var porcentajeSaldoDdjj = $("#porcentajeSaldoDdjj").val();
	var porcentajeDebitoFiscal = $("#porcentajeDebitoFiscal").val();
	
	var urlLiquidacion = "";
	
	if(nuevo)
		urlLiquidacion = $('#urlLiquidacionMasiva2').text();
	else
		urlLiquidacion = $('#urlLiquidacionMasiva').text();
		
	$.ajax(urlLiquidacion, {
		dataType: "json",
		method: "POST",
		data: {
			ano: ano,
			mes: mes,
			cuentasIds: cuentasIds,
			porcentajeSaldoDdjj: porcentajeSaldoDdjj,
			porcentajeDebitoFiscal: porcentajeDebitoFiscal,
			pisarRetPer: $("#checkRetPer").prop('checked')
		}
	}).done(function(data) {

		var rows = tabla.rows('.selected').data();
		var indexesLiquidaciones = tabla.rows('.selected').indexes();
		var indexTable = null;
		
		for(var i=0; i < rows.length; i++) {
			$.each(data, function(indexData, valueData) {
				if(valueData.cuentaId==rows[i].cuentaId){
					tabla.row(indexesLiquidaciones[i]).data(valueData);
					return false
				}
			});
		}
		$("#modalLiquidacionMasiva").modal('hide');

		swal("Liquidación realizada!", "Los resultados seguiran en la lista como seleccionados", "success");
	});
}
</script>
</body>
</html>