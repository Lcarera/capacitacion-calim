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
	<div id="urlEnviarNotificaciones">
		<g:createLink controller="liquidacionIva" action="ajaxEnviarNotificaciones" />
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
		                    <h4><g:message code="zifras.liquidacion.LiquidacionIva.list.notificacion.label" default="Liq. Notificación de IVA"/></h4>
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
						<button style="margin-bottom:20px;" type="button" class="btn btn-primary waves-effect waves-light" onclick="confirmarEnvio();">Notificar</button>
						<div id="preloader" class="preloader3" style="display:none;height:50px;">
							<div class="circ1 loader-primary"></div>
							<div class="circ2 loader-primary"></div>
							<div class="circ3 loader-primary"></div>
							<div class="circ4 loader-primary"></div>
						</div>
						<table id="listLiquidaciones" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th id="listLiquidacionesTh1"></th>
									<th>Cuit</th>
									<th>Razón Social</th>
									<th>Email</th>
									<th>Estado</th>
									<th>Vencimiento</th>
									<th>S DDJJ</th>
									<th>SAF</th>
									<th>Nota</th>
									<th>Fecha</th>
									<th>Notificado</th>
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
        	columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
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
		       			"mData": "cuentaEmail"
		       		},{
		       			"aTargets": [4],
		       			"mData": "estado"
		       		},{
		       			"aTargets": [5],
		       			"mData": "fechaVencimiento",
		       			"type": "date-eu"
		       		},{
		       			"aTargets": [6],
		       			"mData": "saldoDdjj",
		       			"sClass" : "text-right"
			       	},{
		       			"aTargets": [7],
		       			"mData": "saldoTecnicoAFavor",
		       			"sClass" : "text-right"
					},{
		       			"aTargets": [8],
		       			"mData": "nota"
		       		},{
		       			"aTargets": [9],
		       			"mData": "fechaHoraNotificacion"
					},{
		       			"aTargets": [10],
		       			"mData": "notificado",
		       			"mRender": function ( data, type, full ) {
			       			if(data == "Si")
								return '<i class="icofont icofont-ui-check"></i>';
			       			else
				       			return "-";
			   	       	}
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
     	            		columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
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
     	            		columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
     	            	}
  				}
     	        ],
		sPaginationType: 'simple',
		sDom: "lBfrtip",
   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
   			if(aData['advertencia']!=''){
   	   			$(nRow).css({"background-color":"red","color":"white"});
   	   	   	}
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
});

function llenarDatoslistLiquidacionesIva(){
	var ano = $("#ano").val();
	var mes = $("#mes").val();
	tabla.clear().draw();
	$("#preloader").show();
	$.ajax($('#urlGetLiquidacionesIvaList').text(), {
		dataType: "json",
		method: "POST",
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

function enviarNotificaciones(){
	var cuentasIds = "";
	for(i=0; i < tabla.rows('.selected').data().length ; i++){
		cuentasIds += tabla.rows('.selected').data()[i].cuentaId;

		if(i != (tabla.rows('.selected').data().length - 1)){
			cuentasIds += ',';
		}
	}

	var ano = $("#ano").val();
	var mes = $("#mes").val();

	var urlLiquidacion = $('#urlEnviarNotificaciones').text();
		
	$.ajax(urlLiquidacion, {
		dataType: "json",
		method: "POST",
		data: {
			ano: ano,
			mes: mes,
			cuentasIds: cuentasIds
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
		
		swal("Notificaciones enviadas!", "Los resultados seguiran en la lista como seleccionados", "success");
	});
}

function confirmarEnvio(){
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
		},enviarNotificaciones);
}
</script>
</body>
</html>