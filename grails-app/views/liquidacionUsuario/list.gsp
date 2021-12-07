<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>	
<div style="display: none;">
	<div id="urlGetLiquidacionesIvaCuentaList">
		<g:createLink controller="liquidacionIva" action="ajaxGetLiquidacionesIvaCuentaList" />
	</div>

	<div id="urlGetVolantesSimplificado">
		<g:createLink controller="vep" action="ajaxGetVolantesSimplificado" />
	</div>

	<div id="urlDownloadVolanteSimplificado">
		<g:createLink controller="vep" action="download" />
	</div>

	<div id="urlShowIva">
		<g:createLink controller="liquidacionIvaUsuario" action="show" />
	</div>

	<div id="urlShowIIBB">
		<g:createLink controller="liquidacionIibbUsuario" action="show" />
	</div>

	<div id="urlShowGanancias">
		<g:createLink controller="liquidacionGanancia" action="show" />
	</div>
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-sm-6">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.liquidacion.periodo.list.label" default="Período"/></h4>
						</div>
						<div class="col-sm-6 filtro-busqueda">
							<div style="" class="d-inline">
								<input style="width:90px;text-align:center;margin-left:16px;margin-top: 5px" id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<g:if test="${cuenta.aplicaIva}">
			<div class="page-body">
				<div class="col-md-12 col-xl-12 ">
					<div class="card">
						<div class="card-block">
							<div class="dt-responsive table-responsive">
								<div id="headerIva">							
									<h4 style="float:left;margin-bottom:20px;"><g:message code="zifras.liquidacion.LiquidacionIva.list.label" default="Liquidaciones de IVA"/></h4>
									<div style="font-size: 20px;"><i class="botonFlecha ti-arrow-circle-down" style="float:right;padding-top:5px;margin-right:10px;"></i></div>
								</div>
								<div id="divTablaIVAId" style="display:none;">
									<table id="listLiquidaciones" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
										<thead>
											<tr>
												<th>Mes</th>
												<th>Estado</th>
												<th>A pagar</th>
												<th>Nota</th>
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
		</g:if>

		<g:if test="${cuenta.regimenIibb.nombre != 'Simplificado'}">
			<div class="col-md-12 col-xl-12 ">
				<div class="card">
					<div class="card-block">
						<div class="dt-responsive table-responsive">
							<div id="preloader2" class="preloader3" style="display:none;">
								<div class="circ1 loader-primary"></div>
								<div class="circ2 loader-primary"></div>
								<div class="circ3 loader-primary"></div>
								<div class="circ4 loader-primary"></div>
							</div>
							<div id="headerIIBB">							
								<h4 style="float:left;margin-bottom:20px;"><g:message code="zifras.liquidacion.LiquidacionIIBB.list.label" default="Liquidaciones de Ingresos Brutos"/></h4>
								<div style="font-size: 20px;"><i class="botonFlecha2 ti-arrow-circle-down" style="float:right;padding-top:5px;margin-right:10px;"></i></div>
							</div>
							<div id="divTablaIIBBId" style="display:none;">
								<table id="listLiquidacionesIIBB" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
									<thead>
										<tr>
											<th>Mes</th>
											<th>Estado</th>
											<th>A pagar</th>
											<th>Nota</th>
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
		</g:if>
		<g:else>
			<div class="col-md-12 col-xl-12 ">
				<div class="card">
					<div class="card-block">
						<div class="dt-responsive table-responsive">
							<div id="preloader2" class="preloader3" style="display:none;">
								<div class="circ1 loader-primary"></div>
								<div class="circ2 loader-primary"></div>
								<div class="circ3 loader-primary"></div>
								<div class="circ4 loader-primary"></div>
							</div>
							<div id="headerSimplificado">							
								<h4 style="float:left;margin-bottom:20px;"><g:message code="zifras.liquidacion.LiquidacionIIBB.list.label" default="Monotributo Simplificado"/></h4>
								<div style="font-size: 20px;"><i class="botonFlecha4 ti-arrow-circle-down" style="float:right;padding-top:5px;margin-right:10px;"></i></div>
							</div>
							<div id="divTablaSimplificadoId" style="display:none;">
								<table id="listSimplificado" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
									<thead>
										<tr>
											<th>Periodo</th>
											<th>Vencimiento</th>
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
		</g:else>


		<div class="col-md-12 col-xl-12 ">
			<div class="card">
				<div class="card-block">
					<div class="dt-responsive table-responsive">
						<div id="preloader3" class="preloader3" style="display:none;">
							<div class="circ1 loader-primary"></div>
							<div class="circ2 loader-primary"></div>
							<div class="circ3 loader-primary"></div>
							<div class="circ4 loader-primary"></div>
						</div>
						<div id="headerGanancias">							
							<h4 style="float:left;margin-bottom:20px;"><g:message code="zifras.liquidacion.LiquidacionGanancia.list.label" default="Liquidaciones de Ganancias"/></h4>
							<div style="font-size: 20px;"><i class="botonFlecha3 ti-arrow-circle-down" style="float:right;padding-top:5px;margin-right:10px;"></i></div>
						</div>
						<div id="divTablaGananciasId" style="display:none;">
							<table id="listLiquidacionesGanancias" class="table table-striped table-bordered nowrap" style="cursor:pointer;">
								<thead>
									<tr>
										<th>Año</th>
										<th>Estado</th>
										<th>Renta imp.</th>
										<th>Imp.det.</th>
										<th>Consumido</th>
										<th>Impuesto</th>
										<th>Ret.</th>
										<th>Per.</th>
										<th>Ant.</th>
										<th>Imp.Deb/Cred</th>
										<th>Nota</th>
										<th>Zona</th>
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

<script type="text/javascript">
var tablaIva;
var tablaIIBB;
var tablaGanancias;

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

    tablaIIBB = $('#listLiquidacionesIIBB').DataTable({
		"ordering": true,
		"searching": true,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando liquidaciones')}</a>",
			sEmptyTable: "No se encuentran liquidaciones",
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
		iDisplayLength: 100,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
			   			"mData": "mes",
			   			'sClass': 'bold'
					},{
		       			"aTargets": [1],
		       			"mData": "estadoUsuario"
		       		},{
		       			"aTargets": [2],
		       			"mData": "saldoDdjj",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [3],
		       			"mData": "advertencia",
		       			"sClass" : "text-right"
					}],
    	select: {
             style: 'os',
             selector: 'td:first-child',
             style: 'multi'
        },
		sPaginationType: 'simple',
		sDom: "Br",
   		buttons: [
   	            $.extend( true, {}, buttonCommon, {
					extend: 'excelHtml5',
					title: function () {
							var nombre = "${cuenta?.cuit} ${cuenta?.razonSocial} ";
							nombre = nombre + "Liquidacion IIBB " + $("#ano").val();
							return nombre;
						}
				} ),
   	            {
   	            	extend: 'pdfHtml5',
   	            	title: function () {
						var nombre = "${cuenta?.cuit} ${cuenta?.razonSocial} ";
						nombre = nombre + "Liquidacion IIBB " + $("#ano").val();
						return nombre;
					}
				}
   	        ],
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
   	   		if (aData['estadoUsuario'] =='Liquidado')
       			$(nRow).css({"background-color":"#2091a2","color":"white"});
   	   		// Row click
			$(nRow).on('click', function() {
				if(aData['estadoUsuario']!='Sin liquidar'){
					window.location.href = $('#urlShowIIBB').text() + '?mes=' + aData['mes'] + '&ano=${ano}';
					// TODO: link para el multiShow
				}			
			});
		}
	});
	
	llenarDatoslistLiquidacionesIIBB();
	

	tablaIva = $('#listLiquidaciones').DataTable({
		"ordering": false,
		"searching": true,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando liquidaciones')}</a>",
			sEmptyTable: "No se encuentran liquidaciones",
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
		iDisplayLength: 12,
		//scrollX: true,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
		       			"aTargets": [0],
		       			"mData": "mes",
		       			'sClass': 'bold'
		       		},{
		       			"aTargets": [1],
		       			"mData": "estadoUsuario"
					},{
		       			"aTargets": [2],
		       			"mData": "saldoDdjj",
		       			"sClass" : "text-right"
			       	},{
		       			"aTargets": [3],
		       			"mData": "advertencia"
					}],
    	select: {
             style: 'os',
             selector: 'td:first-child',
             style: 'multi'
        },
        sDom: "Br",
        buttons: [
   	            $.extend( true, {}, buttonCommon, {
					extend: 'excelHtml5',
					exportOptions: {
   	            		columns: [0 ,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
   	            	},
   	            	title: function () {
							var nombre = "Liquidaciones IVA " + $("#ano").val();
							return nombre;
						}
				} ),
   	            {
   	            	extend: 'pdfHtml5',
   	            	exportOptions: {
   	            		columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
   	            	},
   	            	orientation: 'landscape',
   	            	title: function () {
						var nombre = "Liquidaciones IVA " + $("#ano").val();
						return nombre;
					}
				}
   	        ],
		sPaginationType: 'simple',
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
   			if (aData['estadoUsuario'] =='Liquidado')
       			$(nRow).css({"background-color":"#2091a2","color":"white"});
   	   		// Row click
			$(nRow).on('click', function() {
				if(aData['estadoUsuario']!='Sin liquidar'){
					window.location.href = $('#urlShowIva').text() + '/' + aData['id'];
				}			
			});
		}
	});

	llenarDatoslistLiquidacionesIva();

	tablaSimplicado = $('#listSimplificado').DataTable({
		"ordering": false,
		"searching": true,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando liquidaciones')}</a>",
			sEmptyTable: "No se encuentran liquidaciones",
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
		iDisplayLength: 12,
		//scrollX: true,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
		       			"aTargets": [0],
		       			"mData": "periodo",
		       			'sClass': 'bold'
		       		},{
		       			"aTargets": [1],
		       			"mData": "vencimientoSimplificado"
					}],
    	select: {
             style: 'os',
             selector: 'td:first-child',
             style: 'multi'
        },
        sDom: "Br",
        buttons: [
   	        ],
		sPaginationType: 'simple',
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
   	   		// Row click
			$(nRow).on('click', function() {
				window.location.href = $('#urlDownloadVolanteSimplificado').text() + '/' + aData['id'];			
			});
		}
	});

	llenarDatoslistSimplificado();

		tablaGanancias = $('#listLiquidacionesGanancias').DataTable({
		"ordering": false,
		"searching": true,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'Buscando liquidaciones')}</a>",
			sEmptyTable: "No se encuentran liquidaciones",
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
		iDisplayLength: 12,
		//scrollX: true,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
		       			"aTargets": [0],
		       			"mData": "ano",
		       			'sClass': 'bold'
		       		},{
		       			"aTargets": [1],
		       			"mData": "estado"
		       		},{
		       			"aTargets": [2],
		       			"mData": "rentaImponible",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [3],
		       			"mData": "impuestoDeterminado",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [4],
		       			"mData": "consumido",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [5],
		       			"mData": "impuesto",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [6],
		       			"mData": "retencion",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [7],
		       			"mData": "percepcion",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [8],
		       			"mData": "anticipos",
		       			"sClass" : "text-right"
			       	},{
		       			"aTargets": [9],
		       			"mData": "impuestoDebitoCredito",
		       			"sClass" : "text-right"
			       	},{
		       			"aTargets": [10],
		       			"mData": "nota",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [11],
		       			"mData": "zonas"
					}],
    	select: {
             style: 'os',
             selector: 'td:first-child',
             style: 'multi'
        },
        sDom: "Br",
        buttons: [
   	            $.extend( true, {}, buttonCommon, {
					extend: 'excelHtml5',
					exportOptions: {
   	            		columns: [0 ,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
   	            	},
   	            	title: function () {
							var nombre = "Liquidaciones Ganancias " + $("#ano").val();
							return nombre;
						}
				} ),
   	            {
   	            	extend: 'pdfHtml5',
   	            	exportOptions: {
   	            		columns: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
   	            	},
   	            	orientation: 'landscape',
   	            	title: function () {
						var nombre = "Liquidaciones Ganancias " + $("#ano").val();
						return nombre;
					}
				}
   	        ],
		sPaginationType: 'simple',
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
   	   		// Row click
			$(nRow).on('click', function() {
				if(aData['estadoUsuario']!='Sin liquidar'){
					window.location.href = $('#urlShowGanancias').text() + '/' + aData['id'];
				}			
			});
		}
	});

	llenarDatoslistLiquidacionesGanancias();


	$("#ano").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "Y",
		minYear: 2015,
		maxYear: 2040,
		lang: "es"
    });

	$("#ano").change(function () {
		llenarDatoslistLiquidacionesIva();
		llenarDatoslistLiquidacionesIIBB();
	});

});

function llenarDatoslistLiquidacionesIva(){
	var ano = $("#ano").val();
	tablaIva.clear().draw();
	$("#preloader").show();
	$.ajax($('#urlGetLiquidacionesIvaCuentaList').text(), {
		dataType: "json",
		data: {
			cuentaId: "${cuenta.id}",
			ano: ano
		}
	}).done(function(data) {
		$("#preloader").hide();
		for(key in data){
			tablaIva.row.add(data[key]);
		}
		tablaIva.draw();
	});
}

function llenarDatoslistSimplificado(){
	var ano = $("#ano").val();
	tablaSimplicado.clear().draw();
	$("#preloader").show();
	$.ajax($('#urlGetVolantesSimplificado').text(), {
		dataType: "json",
		data: {
			cuentaId: "${cuenta.id}",
			ano: ano
		}
	}).done(function(data) {
		$("#preloader").hide();
		for(key in data){
			tablaSimplicado.row.add(data[key]);
		}
		tablaSimplicado.draw();
	});
}

	function llenarDatoslistLiquidacionesIIBB(){	
	var ano = $("#ano").val();
	tablaIIBB.clear().draw();
	$("#preloader2").show();
	$.ajax("${createLink(controller:'liquidacionIibbUsuario', action:'ajaxGetLiquidacionesUnificadas')}", {
		dataType: "json",
		data: {
			cuentaId: "${cuenta.id}",
			ano: ano
		}
	}).done(function(data) {
		$("#preloader2").hide();
		for(key in data){
			tablaIIBB.row.add(data[key]).draw();
		}
		tablaIIBB.draw();
	});
	}

	function llenarDatoslistLiquidacionesGanancias(){	
	tablaGanancias.clear().draw();
	$("#preloader3").show();
	$.ajax("${createLink(controller:'liquidacionGanancia', action:'ajaxGetLiquidacionesGananciaCuentaList')}", {
		dataType: "json",
		data: {
			cuentaId: "${cuenta.id}"
		}
	}).done(function(data) {
		$("#preloader3").hide();
		for(key in data){
			tablaGanancias.row.add(data[key]).draw();
		}
		tablaGanancias.draw();
	});
	}

	$("#headerIva").click(function() { 
        if($("#divTablaIVAId").css('display') == 'none'){
        	$("#divTablaIVAId").css('display', "");
        	$(".botonFlecha").attr('class', 'botonFlecha ti-arrow-circle-up');        
        }
    	else{
    		$("#divTablaIVAId").css('display', 'none');
    		$(".botonFlecha").attr('class', 'botonFlecha ti-arrow-circle-down');
    	}
    });

    $("#headerIIBB").click(function() { 
        if($("#divTablaIIBBId").css('display') == 'none'){
        	$("#divTablaIIBBId").css('display', ""); 
        	$(".botonFlecha2").attr('class', 'botonFlecha2 ti-arrow-circle-up');        
        }
    	else{
    		$("#divTablaIIBBId").css('display', 'none');
        	$(".botonFlecha2").attr('class', 'botonFlecha2 ti-arrow-circle-down');        
    	}
    });

     $("#headerGanancias").click(function() { 
        if($("#divTablaGananciasId").css('display') == 'none'){
        	$("#divTablaGananciasId").css('display', ""); 
        	$(".botonFlecha3").attr('class', 'botonFlecha3 ti-arrow-circle-up');        
        }
    	else{
    		$("#divTablaGananciasId").css('display', 'none');
        	$(".botonFlecha3").attr('class', 'botonFlecha3 ti-arrow-circle-down');        
    	}
    });

     $("#headerSimplificado").click(function(){
     	if($("#divTablaSimplificadoId").css('display') == 'none'){
     		$("#divTablaSimplificadoId").css('display',"");
     		$(".botonFlecha4").attr('class','botonFlecha4 ti-arrow-circle-down');
     	}
     	else{
     		$("#divTablaSimplificadoId").css('display', 'none');
        	$(".botonFlecha4").attr('class', 'botonFlecha4 ti-arrow-circle-down'); 
     	}
     })

</script>
</body>
</html>