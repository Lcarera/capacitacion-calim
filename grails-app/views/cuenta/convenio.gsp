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
				<div class="col-lg-6">
					<div class="row">
						<div class="col-12">
							<div class="page-header-title">
	                    		<h4>Distribución de Coeficientes</h4>
	                    	</div>
	                    </div>
	                    <div class="col-12">
	                    	<a href="/cuenta/show/${cuentaId}">${cuit} - ${razonSocial}<a/>
	                    </div>
					</div>
				</div>
				<div class="col-lg-6">
					<div style="text-align:right;">
						<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block">
					<div class="dt-responsive table-responsive">
						<div class="row" style="float: right;">
							<button
								id="btnVentas"
								class="btn btn-primary btn-danger m-b-0"
								style="margin-right: 10px;"
								onclick="
									actualizarVisibilidad('Ventas');
								"
							>Ventas</button>
							<button
								id="btnCompras"
								class="btn btn-primary m-b-0"
								style="margin-right: 10px;"
								onclick="
									actualizarVisibilidad('Compras');
								"
							>Compras</button>
							<button
								id="btnRetenciones"
								class="btn btn-primary m-b-0"
								style="margin-right: 10px;"
								onclick="
									actualizarVisibilidad('Retenciones');
								"
							>Retenciones</button>
							<button
								id="btnPercepciones"
								class="btn btn-primary m-b-0"
								style="margin-right: 10px;"
								onclick="
									actualizarVisibilidad('Percepciones');
								"
							>Percepciones</button>
							<button
								id="btnPintar"
								class="btn btn-primary m-b-0"
								style="margin-right: 20px;"
								onclick="
									pintarDetalles();
								"
							>Pintar</button>
						</div>
						<table id="listDetalle" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Jurisdicción</th>
									<!-- Ventas -->
									<th>01</th>
									<th>02</th>
									<th>03</th>
									<th>04</th>
									<th>05</th>
									<th>06</th>
									<th>07</th>
									<th>08</th>
									<th>09</th>
									<th>10</th>
									<th>11</th>
									<th>12</th>
									<th>Total Ventas</th>
									<!-- Compras -->
									<th>01</th>
									<th>02</th>
									<th>03</th>
									<th>04</th>
									<th>05</th>
									<th>06</th>
									<th>07</th>
									<th>08</th>
									<th>09</th>
									<th>10</th>
									<th>11</th>
									<th>12</th>
									<th>Total Compras</th>
									<!-- Retenciones -->
									<th>01</th>
									<th>02</th>
									<th>03</th>
									<th>04</th>
									<th>05</th>
									<th>06</th>
									<th>07</th>
									<th>08</th>
									<th>09</th>
									<th>10</th>
									<th>11</th>
									<th>12</th>
									<th>Total Retenciones</th>
									<!-- Percepciones -->
									<th>01</th>
									<th>02</th>
									<th>03</th>
									<th>04</th>
									<th>05</th>
									<th>06</th>
									<th>07</th>
									<th>08</th>
									<th>09</th>
									<th>10</th>
									<th>11</th>
									<th>12</th>
									<th>Total Percepciones</th>
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

<script type="text/javascript">
	var ventas = true;
	var compras = false;
	var retenciones = false;
	var percepciones = false;
	var detallesPintados = false;
	var tablaDetalle;

	jQuery(document).ready(function() {
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
			llenarListDetalle();
		});

		tablaDetalle = $('#listDetalle').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": false,
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
				}
			},
			iDisplayLength: -1,
			//scrollX: true,
			aaSorting: [
				[0, 'asc']
			],
			// lengthMenu: [[10, 25, 50, 100, -1], [10, 25, 50, 100, "Todos"]],
			aoColumnDefs: [
					{
						"aTargets": [0],
						"mData": "jurisdiccion",
						'sClass': 'bold'
					}, {
						"aTargets": [1],
						"mData": "ventas1",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [2],
						"mData": "ventas2",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [3],
						"mData": "ventas3",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [4],
						"mData": "ventas4",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [5],
						"mData": "ventas5",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [6],
						"mData": "ventas6",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [7],
						"mData": "ventas7",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [8],
						"mData": "ventas8",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [9],
						"mData": "ventas9",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [10],
						"mData": "ventas10",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [11],
						"mData": "ventas11",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [12],
						"mData": "ventas12",
		       			"sClass" : "text-right",
						"visible": ventas
					}, {
						"aTargets": [13],
						"mData": "ventasTotal",
		       			"sClass" : "text-right",
						'sClass': 'bold',
						"visible": ventas
					}, {
						"aTargets": [14],
						"mData": "compras1",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [15],
						"mData": "compras2",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [16],
						"mData": "compras3",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [17],
						"mData": "compras4",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [18],
						"mData": "compras5",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [19],
						"mData": "compras6",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [20],
						"mData": "compras7",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [21],
						"mData": "compras8",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [22],
						"mData": "compras9",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [23],
						"mData": "compras10",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [24],
						"mData": "compras11",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [25],
						"mData": "compras12",
		       			"sClass" : "text-right",
						"visible": compras
					}, {
						"aTargets": [26],
						"mData": "comprasTotal",
		       			"sClass" : "text-right",
						'sClass': 'bold',
						"visible": compras
					}, {
						"aTargets": [27],
						"mData": "retenciones1",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [28],
						"mData": "retenciones2",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [29],
						"mData": "retenciones3",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [30],
						"mData": "retenciones4",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [31],
						"mData": "retenciones5",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [32],
						"mData": "retenciones6",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [33],
						"mData": "retenciones7",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [34],
						"mData": "retenciones8",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [35],
						"mData": "retenciones9",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [36],
						"mData": "retenciones10",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [37],
						"mData": "retenciones11",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [38],
						"mData": "retenciones12",
		       			"sClass" : "text-right",
						"visible": retenciones
					}, {
						"aTargets": [39],
						"mData": "retencionesTotal",
		       			"sClass" : "text-right",
						'sClass': 'bold',
						"visible": retenciones
					}, {
						"aTargets": [40],
						"mData": "percepciones1",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [41],
						"mData": "percepciones2",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [42],
						"mData": "percepciones3",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [43],
						"mData": "percepciones4",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [44],
						"mData": "percepciones5",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [45],
						"mData": "percepciones6",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [46],
						"mData": "percepciones7",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [47],
						"mData": "percepciones8",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [48],
						"mData": "percepciones9",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [49],
						"mData": "percepciones10",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [50],
						"mData": "percepciones11",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [51],
						"mData": "percepciones12",
		       			"sClass" : "text-right",
						"visible": percepciones
					}, {
						"aTargets": [52],
						"mData": "percepcionesTotal",
		       			"sClass" : "text-right",
						'sClass': 'bold',
						"visible": percepciones
					}
				],
  			buttons: [
  				$.extend(true, {}, {
					exportOptions: {
						columns: [':visible'],
						format: {
							body: function (data, row, column, node) {
								const dataNumerica = data.replace(/\./g, '').replace(',', '.');
								return $.isNumeric(dataNumerica) ? dataNumerica : data;
							}
						}
					}
				}, {
					extend: 'excelHtml5',
					className: 'fred',
					title: function () {
						var tipo
						if (ventas)
							tipo = "Ventas"
						else if (compras)
							tipo = "Compras"
						else if (retenciones)
							tipo = "Retenciones"
						else if (percepciones)
							tipo = "Percepciones"
						return "Detalle " + tipo + " " + $("#ano").val() + " ${cuit}";
					}
				}),
				{
					extend: 'pdfHtml5',
					orientation: 'landscape',
					className: 'fred',
					title: function () {
						var tipo
						if (ventas)
							tipo = "Ventas"
						else if (compras)
							tipo = "Compras"
						else if (retenciones)
							tipo = "Retenciones"
						else if (percepciones)
							tipo = "Percepciones"
						return "Detalle " + tipo + " " + $("#ano").val() + " ${cuit}";
					}
				},
				{
					extend: 'copyHtml5',
					className: 'fred'
				}],
       		sPaginationType: 'simple',
       		sDom: "Bfrtip",
       		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					// window.location.href = $('#urlShow').text() + '/' + aData['id'];
				});
			}
		});
		llenarListDetalle();

	});

	function llenarListDetalle(){
		$('#loaderGrande').show()
		tablaDetalle.clear()
		$.ajax("${createLink(controller:'cuenta', action:'ajaxObtenerDistribucionConvenio')}", {
			dataType: "json",
			data: {
				ano: $("#ano").val(),
				cuentaId: ${cuentaId}
			}
		}).done(function(data) {
			for(key in data){
				tablaDetalle.row.add(data[key]);
			}
			tablaDetalle.draw();
			$('#loaderGrande').fadeOut('slow', function() {
		        $(this).hide();
		    });
		});
	}

	function actualizarVisibilidad(botonTocado){
		compras = false;
		ventas = false;
		retenciones = false;
		percepciones = false;
		$("#btnCompras").removeClass("btn-danger")
		$("#btnVentas").removeClass("btn-danger")
		$("#btnRetenciones").removeClass("btn-danger")
		$("#btnPercepciones").removeClass("btn-danger")
		if (botonTocado == "Compras"){
			$("#btnCompras").addClass("btn-danger")
			compras = true;
		}
		else if (botonTocado == "Ventas"){
			$("#btnVentas").addClass("btn-danger")
			ventas = true;
		}
		else if (botonTocado == "Retenciones"){
			$("#btnRetenciones").addClass("btn-danger")
			retenciones = true;
		}
		else if (botonTocado == "Percepciones"){
			$("#btnPercepciones").addClass("btn-danger")
			percepciones = true;
		}
		tablaDetalle.columns([1,2,3,4,5,6,7,8,9,10,11,12,13]).visible(ventas);
		tablaDetalle.columns([14,15,16,17,18,19,20,21,22,23,24,25,26]).visible(compras);
		tablaDetalle.columns([27,28,29,30,31,32,33,34,35,36,37,38,39]).visible(retenciones);
		tablaDetalle.columns([40,41,42,43,44,45,46,47,48,49,50,51,52]).visible(percepciones);
		// tablaDetalle.columns.adjust().draw();
	}

	function pintarDetalles(){
		if (detallesPintados){
			$("#btnPintar").removeClass("btn-danger")
			$(".resaltadoTabla").removeClass("resaltadoTabla")
		}
		else{
			$("#btnPintar").addClass("btn-danger")
			tablaDetalle.cells().every(function(){
				if(this.data() != "0,00" && this[0][0].column > 0)
					$(this.node()).addClass("resaltadoTabla")
			});
		}
		detallesPintados = ! detallesPintados;
	}

</script>
<style>
	.resaltadoTabla{
		background-color: cadetblue!important;
		color: white!important;
	}
</style>
</body>
</html>