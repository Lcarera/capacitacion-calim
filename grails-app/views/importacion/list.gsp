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
	<div id="urlGetImportacionesFactura">
		<g:createLink controller="importacion" action="ajaxGetImportacionesFactura" />
	</div>
	<div id="urlDelete">
		<g:createLink controller="importacion" action="ajaxDeleteLogs" />
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
		                    <h4><g:message code="zifras.importacion.LogImportacion.importaciones.list.label" default="Logs de Importaciones"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<button type="button" class="btn btn-danger alert-success-cancel m-b-0" ><g:message code="default.button.undo.label" default="Deshacer seleccionadas" /></button>		
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listImportacionesFactura" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th id="listImportacionesFacturaTh1"></th>
									<th>Periodo</th> 
									<th>Tipo</th>
									<th>Cuenta</th>
									<th>Resp.</th>
									<th>Estado</th>
									<th>Importación</th>
									<th>Total</th>
									<th>Ok</th>
									<th>Mal</th>
									<th>Ignor.</th>
									<th>+Prov/Cli</th>
									<th>+Tipos</th>
									<th>Detalle</th>
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
	var todoSeleccionado = false;

	jQuery(document).ready(function() {
		//Success or cancel alert
		document.querySelector('.alert-success-cancel').onclick = function(){
			swal({
				title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
				text: "<g:message code='zifras.importacion.LogImportacion.delete.message' default='Todas las importaciones seleccionadas se eliminarán.'/>",
				type: "warning",
				showCancelButton: true,
				confirmButtonClass: "btn-danger",
				confirmButtonText: "<g:message code='zifras.facturacion.delete.ok' default='Si, eliminar'/>",
				cancelButtonText: "<g:message code='zifras.facturacion.delete.cancel' default='No, cancelar'/>",
				closeOnConfirm: true,
				closeOnCancel: true
			},
			function(isConfirm) {
				if (isConfirm) {
					deleteLogs();
				}
			});
		};


		$('#listImportacionesFacturaTh1').click(function() {
			if(todoSeleccionado===true){
				$('#listImportacionesFacturaTh1').parent().removeClass("selected");
				todoSeleccionado = false;
				tabla.rows().deselect();
			}else{
				$('#listImportacionesFacturaTh1').parent().addClass("selected");
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

		tabla = $('#listImportacionesFactura').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.importacion.LogImportacion.list.agregar', default: 'No hay Importaciones')}</a>",
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
				[6, 'desc'],
				[1, 'desc'],
				[3, 'desc'],
				[2, 'desc']
			],
			aoColumnDefs: [{
							"aTargets": [0],
				   			'orderable': false,
				   			'className': 'select-checkbox',
				   			"mData": "selected"
						},{
			       			"aTargets": [1],
			       			"mData": "fecha",
			       			"type": "date-eu"
						},{
			       			"aTargets": [2],
			       			"mData": "tipo"
						},{
			       			"aTargets": [3],
			       			"mData": "cuentaNombre"
						},{
			       			"aTargets": [4],
			       			"mData": "responsable"
						},{
			       			"aTargets": [5],
			       			"mData": "estado"
						},{
			       			"aTargets": [6],
			       			"mData": "fechaHora",
			       			"type": "date-eu"
						},{
			       			"aTargets": [7],
			       			"mData": "total"
						},{
			       			"aTargets": [8],
			       			"mData": "cantidadOk"
						},{
			       			"aTargets": [9],
			       			"mData": "cantidadMal"
						},{
			       			"aTargets": [10],
			       			"mData": "cantidadIgnoradas"
						},{
			       			"aTargets": [11],
			       			"mData": "nuevasPersonas"
						},{
			       			"aTargets": [12],
			       			"mData": "nuevosTiposComprobantes"
						},{
			       			"aTargets": [13],
			       			"mData": "detalle"
						}],
	    	select: {
	             style: 'multi',
	             selector: 'td:first-child'
	        },
        buttons: [
				'selectAll',
				'selectNone',
     	            $.extend( true, {}, buttonCommon, {
  					extend: 'excelHtml5',
  					exportOptions: {
     	            		rows: { selected: true },
     	            		columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
     	            	},
  					title: function () {
  							var nombre = "Importaciones";
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
  						var nombre = "Importaciones"
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
				// Row click
				$(nRow).on('click', function() {
					//window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistImportacionesFactura();
	});

	function llenarDatoslistImportacionesFactura(){
		tabla.clear();
		$.ajax($('#urlGetImportacionesFactura').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
			$("#loaderGrande").hide()
		});
	}

	function deleteLogs(){
		var logsId = "";
		for(i=0; i < tabla.rows('.selected').data().length ; i++){
			logsId += tabla.rows('.selected').data()[i].id;

			if(i != (tabla.rows('.selected').data().length - 1)){
				logsId += ',';
			}
		}
			
		$.ajax($('#urlDelete').text(), {
			dataType: "json",
			method: "POST",
			data: {
				logsId: logsId
			}
		}).done(function(data) {

			var rows = tabla.rows('.selected').data();
			var indexesImportaciones = tabla.rows('.selected').indexes();
			var indexTable = null;
			
			for(var i=0; i < rows.length; i++) {
				$.each(data, function(indexData, valueData) {
					if(valueData.id==rows[i].id){
						tabla.row(indexesImportaciones[i]).data(valueData);
						return false
					}
				});
			}
			swal("Se eliminaron las importaciones seleccionadas");
			llenarDatoslistImportacionesFactura();
		});
	}
</script>
</body>
</html>