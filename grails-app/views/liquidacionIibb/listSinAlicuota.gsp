<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
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
</head>

<body>
<div style="display: none;">
	<div id="urlGetLiquidacionesIibbList">
		<g:createLink controller="liquidacionIibb" action="ajaxGetLiquidacionesSinAlicuota" />
	</div>
	<div id="urlShow">
		<g:createLink controller="liquidacionIibb" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="liquidacionIibb" action="edit" />
	</div>
	<div id="urlCreate">
		<g:createLink controller="liquidacionIibb" action="create" />
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
		                    <h4><g:message code="zifras.liquidacion.LiquidacionIibb.list.label" default="Liquidaciones de IIBB"/></h4>
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
						<table id="listLiqs" class="table table-striped table-bordered nowrap" style="">
							<thead>
								<tr>
									<th></th>
									<th>Cuit</th>
									<th>Razón Social</th>
									<th>Actividad</th>
									<th>Prov.</th>
									<th>Alicuota</th>
									<th>Estado</th>
									<!-- <th>Advertencia</th> -->
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
	var tabla;
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
	    
		tabla = $('#listLiqs').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay liquidaciones sin alicuotas cargadas.')}</a>",
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
				[1, 'asc'],
				[4, 'asc']
			],
			aoColumnDefs: [{
				   			"aTargets": [0],
				   			'orderable': false,
				   			"mData": "selected",
				   			"mRender": function ( data, type, full ) {
				       			var salida;
				
								var link1;
								var link2;
								
				       			salida = '<a class="dropdown-toggle addon-btn" data-toggle="dropdown" aria-expanded="true">' +
				                '<i class="icofont icofont-ui-settings"></i>' +
				                '</a>';
				
				                if(full['estado']!='Sin liquidar'){
				                	link1 = $('#urlShow').text() + '/' + full['id'];
				       				link2 = $('#urlEdit').text() + '/' + full['id'];
				       				
				                	salida+='<div class="dropdown-menu dropdown-menu-right">' +
				                    				'<a class="dropdown-item" href="' + link1 + '"><i class="icofont icofont-attachment"></i>Mostrar</a>' +
				                    				'<a class="dropdown-item" href="' + link2 + '"><i class="icofont icofont-ui-edit"></i>Editar</a>'
				                }else{
				                	link1 = $('#urlCreate').text() + '/?cuentaId=' + full['cuentaId'] + '&mes=' + full['mes'] + '&ano=' + full['ano'] + '&provinciaId=' + full['provinciaId'];
				
				                	salida+='<div class="dropdown-menu dropdown-menu-right">' +
				            					'<a class="dropdown-item" href="' + link1 + '"><i class="icofont icofont-ui-edit"></i>Editar</a>'
				                }

				                salida += '</div>'
				   				return salida;
				   	       	}
						},{
			       			"aTargets": [1],
			       			"mData": "cuentaCuit",
				   			'sClass': 'bold'
						},{
			       			"aTargets": [2],
			       			"mData": "cuentaNombre"
			       		},{
			       			"aTargets": [3],
			       			"mData": "actividades"
			       		},{
			       			"aTargets": [4],
			       			"mData": "provinciaNombre"
			       		},{
			       			"aTargets": [5],
			       			"mData": "alicuotas"
			       		},{
			       			"aTargets": [6],
			       			"mData": "estado"
			       		}/*,{
			       			"aTargets": [7],
			       			"mData": "advertencia",
			       			"sClass" : "text-right"
						}*/],
	    	buttons: [
	   	            $.extend( true, {}, buttonCommon, {
						extend: 'excelHtml5',
						title: function () {
								var nombre = "Liquidaciones IIBB " + $("#mes").val() + "-" + $("#ano").val();
								return nombre;
							}
					} ),
	   	            {
	   	            	extend: 'pdfHtml5',
	   	            	exportOptions: {
	   	            	},
	   	            	orientation: 'landscape',
	   	            	title: function () {
							var nombre = "Liquidaciones IIBB " + $("#mes").val() + "-" + $("#ano").val();
							return nombre;
						}
					},
					{
						extend: 'copyHtml5',
						exportOptions: {
	   	            	},
					}
	   	        ],
			sPaginationType: 'simple',
			sDom: "lBfrtip",
	   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
	   	   		/*if(aData['advertencia']!='' && aData["advertencia"] != "Utilizamos la Alicuota General de la provincia."){
	   	   			$(nRow).css({"background-color":"red","color":"white"});
	   	   	   	}*/
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

		llenarDatoslistLiquidacionesIibb();

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
			llenarDatoslistLiquidacionesIibb();
		});

		$("#mes").change(function () {
			llenarDatoslistLiquidacionesIibb();
		});
	});

	function llenarDatoslistLiquidacionesIibb(){
		$('#loaderGrande').fadeIn("slow");
		var ano = $("#ano").val();
		var mes = $("#mes").val();
		tabla.clear().draw();
		$.ajax($('#urlGetLiquidacionesIibbList').text(), {
			dataType: "json",
			method: "POST",
			data: {
				ano: ano,
				mes: mes
			}
		}).done(function(data) {
			$('#loaderGrande').fadeOut('slow');
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
		});
	}
</script>
</body>
</html>