<!DOCTYPE html>
<html lang="en">

<head>
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
	<div id="urlModificarNota">
		<g:createLink controller="liquidacionIva" action="ajaxModificarNota" />
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
		                    <h4><g:message code="zifras.liquidacion.Notas.list.label" default="Notas IVA"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-2">
					<div style="text-align:right;">
						<input id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
						<!--<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Liquidacion']"/></g:link>-->
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
									<th>S DDJJ</th>
									<th>Nota</th>
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

<div class="modal fade" id="modalNota" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Agregar Nota</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group row" style="margin-bottom:0px;">
					<label class="col-sm-3 col-form-label">Período</label>
					<label class="col-sm-9" id="mesAnoLabel"></label>
					
					<label class="col-sm-3 col-form-label">CUIT</label>
					<label class="col-sm-9" id="cuitLabel"></label>
					
					<label class="col-sm-3 col-form-label">Cuenta</label>
					<label class="col-sm-9" id="cuentaNombreLabel"></label>
					
					<label class="col-sm-3 col-form-label">Nota</label>
					<div class="col-sm-9">
						<textarea class="form-control" id="notaModal" rows="3" class="form-control"></textarea>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="botonRetencionPercepcion" type="button" class="btn btn-primary waves-effect waves-light" onclick="agregarNota();">Agregar</button>
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
		       			"mData": "direcciones",
		       			"sClass" : "text-right"
		       		},{
		       			"aTargets": [5],
		       			"mData": "saldoDdjj",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [6],
		       			"mData": "nota",
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
  					title: function () {
  							var nombre = "Rentenciones-Percepciones " + $("#mes").val() + "-" + $("#ano").val();
  							return nombre;
  						}
  				} ),
     	            {
     	            	extend: 'pdfHtml5',
     	            	title: function () {
  						var nombre = "Rentenciones-Percepciones " + $("#mes").val() + "-" + $("#ano").val();
  						return nombre;
  					}
  				},
     	         	'copyHtml5'
     	        ],
		sPaginationType: 'simple',
   		sDom: "lBfrtip",
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).bind('click', function() {
				$("#cuitLabel").text(aData['cuentaCuit']);
				$("#mesAnoLabel").text(aData['mes'] + ' / ' + aData['ano']);
				$("#cuentaNombreLabel").text(aData['cuentaNombre']);
				if(aData['nota']!=null){
					$("#notaModal").val(aData['nota']);
				}else{
					$("#notaModal").val('');
				}
				
				$("#modalNota").modal({
					show: true
				});

				itemSeleccionado = aData;
				/*if(aData['estado']!='Sin liquidar'){
					window.location.href = $('#urlShow').text() + '/' + aData['id'];
				}else{
					window.location.href = $('#urlCreate').text() + '/?cuentaId=' + aData['cuentaId'];
				}*/				
			});
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

	$("#retencionModal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#percepcionModal").focus().select();
		}
	});

	$("#percepcionModal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#botonRetencionPercepcion").focus();
		}
	});
});

function llenarDatoslistLiquidacionesIva(){
	var ano = $("#ano").val();
	var mes = $("#mes").val();
	tabla.clear().draw();
	$("#preloader").show();
	$.ajax($('#urlGetLiquidacionesIvaList').text(), {
		dataType: "json",
		data: {
			ano: ano,
			mes: mes
		}
	}).done(function(data) {
		$("#preloader").hide();
		for(key in data){
			tabla.row.add(data[key]);
		}
		tabla.draw();
	});
}

function agregarNota(){
	itemSeleccionado.nota = $("#notaModal").val();
	
	$.ajax($('#urlModificarNota').text(), {
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
			tabla.row(indexTable).data(liquidacion);//.draw();
		}

		$("#modalNota").modal('hide');
	});
}
</script>
</body>
</html>