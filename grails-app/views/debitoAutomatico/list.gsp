<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<g:hiddenField id="debitoMensualPendiente" name="debitoMensualPendiente" value="${debitoMensualPendiente}"/>
<div style="display: none;">
	<div id="urlGetDebitosMensuales">
		<g:createLink controller="debitoAutomatico" action="ajaxGetDebitosMensuales" />
	</div>
	<div id="urlGenerarDebitosMensuales">
		<g:createLink controller="debitoAutomatico" action="ajaxSaveDebitosMensuales" />
	</div>
	<div id="urlGetDebitosMensualesGenerados">
		<g:createLink controller="debitoAutomatico" action="ajaxGetDebitosMensualesGenerados"/>
	</div>
	<div id="urlDescargaVisa">
		<g:createLink controller="debitoAutomatico" action="descargarTxtVisa"/>
	</div>
	<div id="urlDescargaMastercard">
		<g:createLink controller="debitoAutomatico" action="descargarTxtMastercard"/>
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
		                    <h4>Debito Automatico Mensual</h4>
						</div>
					</div>
				</div>
				<div class="col-lg-2">
					<div class="card-header-right" style="text-align:right;">
						<g:link action="listCuentasSinTarjeta" class="btn btn-danger">Cuentas a revisar &nbsp
						<span class="badge">${cuentasSinTarjeta}</span>
						</g:link>
					</div>
				</div>
				<div class="col-lg-1">
					<div class="card-header-right" style="text-align:right;">
		        		<g:link action="cargarDebitos" class="btn btn-primary">Importar Débitos</g:link>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<button  id="btnGenerarDebitos" class="btn btn-success m-b-0" type="button">Generar debitos mensuales</button>
					<br>
					<br>	
					<div class="dt-responsive table-responsive">
						<div id="preloader" class="preloader3" style="display:none;">
    							<div class="circ1 loader-primary"></div>
    							<div class="circ2 loader-primary"></div>
    							<div class="circ3 loader-primary"></div>
    							<div class="circ4 loader-primary"></div>
    						</div>
						<table id="listDebitosPendientes" class="table table-striped table-bordered nowrap" style="cursor:default;">
							<thead>
								<tr>
									<th>Cuenta</th>
									<th>Tarjeta</th>
									<th>Id Factura</th>
									<th>Importe</th>
									<th>Id Cuenta</th>
									<th>Primer Debito</th>
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
			<a id="linkVisa" href="#"><button type="submit" class="btn btn-primary m-b-0">Descargar TXT VISA</button></a> 
			<br>
			<br>
			<a id="linkMastercard" href="#"><button type="submit" class="btn btn-primary m-b-0">Descargar TXT MASTERCARD</button></a>
		</div>
	</div>
</div>

<script type="text/javascript">
var tablaDebitos;
var banderaBeforeSend = true;

	jQuery(document).ready(function() {
		$("#mes").dateDropper({
			dropWidth: 200,
			dropPrimaryColor: "#1abc9c",
			dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "m",
			lang: "es"
		});
		$("#ano").dateDropper({
			dropWidth: 200,
			dropPrimaryColor: "#1abc9c",
			dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "Y",
			lang: "es"
		});
		$("#mes").change(function () {
			$("#ano").trigger('change');
		});
		$("#ano").change(function () {
			llenarDatoslistDebitoAutomaticoGenerados();
		});

		$("#linkVisa").click(function (e) {
	        e.preventDefault();
	        console.log(${debitoMensualPendiente});
	        window.location.href = $('#urlDescargaVisa').text() + "?debitoPendiente="+ ${debitoMensualPendiente};
	    });

	    $("#linkMastercard").click(function (e) {
	        e.preventDefault();
	        window.location.href = $('#urlDescargaMastercard').text() + "?debitoPendiente="+ ${debitoMensualPendiente};
	    });

		tablaDebitos = $('#listDebitosPendientes').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"pageLength": 25,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.comprobantePago.llenarDatoslistDebitoAutomaticoGeneradosComprobantePago.list.agregar', default: 'No hay Elementos')}</a>",
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
				[1, 'asc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "cuenta",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [1],
			       			"mData": "numeroTarjeta"
			       		},{
			       			"aTargets": [2],
			       			"mData": "facturaId"
						},{
			       			"aTargets": [3],
			       			"mData": "importe",
			       			"sClass" : "text-right"
			       		},{
			       			"aTargets": [4],
			       			"mData": "cuentaId"
				   	    },{
				   	    	"aTargets": [5],
			       			"mData": "primerDebito"
			       		},{
			       			"aTargets": [6],
			       			"mData": "tipo",
			       			"visible": false
			       		}],
       		sPaginationType: 'simple',
       		sDom: "flrtip",
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					//window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}
		});

		tablaDebitosGenerados = $('#listDebitosGenerados').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			"pageLength": 25,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.comprobantePago.ComprobantePago.list.agregar', default: 'No hay Elementos')}</a>",
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
				[1, 'asc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "cuenta",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [1],
			       			"mData": "numeroTarjeta"
			       		},{
			       			"aTargets": [2],
			       			"mData": "facturaId"
						},{
			       			"aTargets": [3],
			       			"mData": "fechaVencimiento",
			       			"type": "date-eu"	       			
						},{
			       			"aTargets": [4],
			       			"mData": "importeCrudo"
			       		},{
			       			"aTargets": [5],
			       			"mData": "cuentaId"
				   	    },{
				   	    	"aTargets": [6],
			       			"mData": "primerDebito"
			       		},{
			       			"aTargets": [7],
			       			"mData": "tipo",
			       			"visible": false
			       		}],
			buttons: [{
  	  				extend: 'excelHtml5',
  	  				exportOptions: {
							columns: [1, 2, 3, 4, 5, 6]
						},
 					title: function () {
 						var nombreBusq = $('.dataTables_filter input').val();
 						return nombreBusq;
 					}
 				}],
       		sPaginationType: 'simple',
       		sDom: "fBlrtip",
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					//window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}
		});

		document.getElementById("btnGenerarDebitos").onclick = function(){
			swal({
				title: "¿Estás seguro?",
				text: "Se generarán los debitos mensuales sobre la última factura mensual de cada cuenta",
				type: "warning",
				showCancelButton: true,
				confirmButtonClass: "btn-danger",
				confirmButtonText: "<g:message code='zifras.delete.ok' default='Si, generar'/>",
				cancelButtonText: "<g:message code='zifras.delete.cancel' default='No, cancelar'/>",
				closeOnConfirm: true,
				closeOnCancel: true
			},
			function(isConfirm) {
				if (isConfirm) {
					generarDebitosMensuales();
				}
			});
	};

		llenarDatoslistDebitoAutomatico();
		llenarDatoslistDebitoAutomaticoGenerados();

		$("#btnVisaCredito").click(function(){
			tablaDebitosGenerados.search('visacredito');
			tablaDebitosGenerados.draw()
		});

		$("#btnVisaDebito").click(function(){
			tablaDebitosGenerados.search('visadebito');
			tablaDebitosGenerados.draw()
		});

		$("#btnMastercard").click(function(){
			tablaDebitosGenerados.search('mastercard');
			tablaDebitosGenerados.draw()
		});
	});

	function llenarDatoslistDebitoAutomatico(){
		tablaDebitos.clear().draw();
		$("#preloader").show();
		$.ajax($('#urlGetDebitosMensuales').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			$("#preloader").hide();
			for(key in data){
				tablaDebitos.row.add(data[key]);
			}
			tablaDebitos.draw();
		});
	}

	function llenarDatoslistDebitoAutomaticoGenerados(){
		tablaDebitosGenerados.clear().draw();
		$.ajax($('#urlGetDebitosMensualesGenerados').text(), {
			dataType: "json",
			data: {
				mes: $("#mes").val(),
				ano: $("#ano").val()
			}
		}).done(function(data) {
			for(key in data){
				tablaDebitosGenerados.row.add(data[key]);
			}
			tablaDebitosGenerados.search('visacredito');
			tablaDebitosGenerados.draw();
		});
	}


	function generarDebitosMensuales(){
		$.ajax($("#urlGenerarDebitosMensuales").text(), {
			dataType: "json",
			data: {}
		}).done(function(data){
			if(data.hasOwnProperty('error')){
				setTimeout(function() {
	  				swal("Error", data['error'], "error");
	    		}, 400);
			}
			else{
				setTimeout(function() {
	  				swal("Debitos almacenados!", "Los debitos automaticos se guardaron correctamente, ya puede generar los excel", "success");
	    		}, 400);
	    		llenarDatoslistDebitoAutomaticoGenerados();
	    	}
		});
	}
</script>
</body>
</html>