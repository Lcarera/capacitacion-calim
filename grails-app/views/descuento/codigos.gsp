<!DOCTYPE html>
<html lang="en">

<head>
    <div class="theme-loader" id="loaderList">
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
				<div class="col-lg-8">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4>Códigos de descuento</h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<button type="button" class="btn btn-success" onclick="$('#modalGenerarCodigos').modal('show')">Generar Códigos</button>
						<button type="button" class="btn btn-danger alert-success-cancel m-b-0" onclick="deleteCodigos()">Eliminar seleccionados</button>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listCodigosDescuento" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th id="listCodigosDescuentoTh1"></th>
									<th>Código</th>
									<th>Vendedor</th>
									<th>Descuento</th>
									<th>Fecha Generado</th>
									<th>Fecha Expiracion</th>
									<th>Fecha Activacion</th>
									<th>Cuenta Activadora</th>
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

		<div class="modal fade" id="modalLoading" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">Generando...</h4>
					</div>
					<div class="modal-body" style="padding:0px;">
						<div class="loader-block">
		                    <svg id="loader2" viewBox="0 0 100 100">
		                        <circle id="circle-loader2" cx="50" cy="50" r="45"></circle>
		                    </svg>
		                </div>
					</div>
					<div class="modal-footer">
						<label>El tiempo de espera es de aproximadamente 1 minuto por cada 1000 códigos.</label>
					</div>
				</div>
			</div>
		</div>

		<div class="modal fade" id="modalGenerarCodigos" tabindex="-1" role="dialog">
			<div class="modal-dialog modal-lg" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">Generar Códigos</h4>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Expiración</label>
							<div class="col-sm-10">
								<input id="modalGenerarCodigos_fecha" class="form-control" type="text" data-format="d/m/Y" placeholder="Seleccione un día" value="${fechaExpiracionDefault}"/>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Cantidad</label>
							<div class="col-sm-10">
								<input id="modalGenerarCodigos_cantidad" class="form-control" type="number"placeholder="Ingrese la cantidad" value="1000"/>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Vendedor</label>
							<div class="col-sm-10">
								<select id="modalGenerarCodigos_vendedor" name="cuentaId"></select>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Descuento</label>
							<div class="col-sm-10">
								<input id="modalGenerarCodigos_descuento" class="form-control" type="text" placeholder="Ingrese descuento"/>
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 col-form-label">Detalle</label>
							<div class="col-sm-10">
								<input id="modalGenerarCodigos_detalle" class="form-control" type="text"/>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
						<button class="btn btn-primary waves-effect waves-light " onclick="generarCodigos()">Generar</button>
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

		$("#modalGenerarCodigos_fecha").dateDropper( {
	        dropWidth: 200,
	        dropPrimaryColor: "#1abc9c", 
	        dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "d/m/Y",
			lang: "es"
	    });

		$('#listCodigosDescuentoTh1').click(function() {
			if(todoSeleccionado===true){
				$('#listCodigosDescuentoTh1').parent().removeClass("selected");
				todoSeleccionado = false;
				tabla.rows().deselect();
			}else{
				$('#listCodigosDescuentoTh1').parent().addClass("selected");
				todoSeleccionado = true;
				tabla.rows({ filter: 'applied' }).select();
			}
		});

		tabla = $('#listCodigosDescuento').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.descuento.codigo.list.agregar', default: 'No hay códigos de descuento')}</a>",
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
				[0, 'asc']
			],
			aoColumnDefs: [{
							"aTargets": [0],
				   			'orderable': false,
				   			'className': 'select-checkbox',
				   			"mData": "selected"
						},{
			       			"aTargets": [1],
			       			"mData": "codigo"
						},{
			       			"aTargets": [2],
			       			"mData": "vendedor"
						},{
			       			"aTargets": [3],
			       			"mData": "descuento"
						},{
			       			"aTargets": [4],
			       			"mData": "fechaGenerado",
			       			"type": "date-eu"
						},{
			       			"aTargets": [5],
			       			"mData": "fechaExpiracion",
			       			"type": "date-eu"
						},{
			       			"aTargets": [6],
			       			"mData": "fechaActivacion",
			       			"type": "date-eu"
						},{
			       			"aTargets": [7],
			       			"mData": "beneficiado"
						},{
			       			"aTargets": [8],
			       			"mData": "detalle"
						}],
			sDom: "lBfrtip",
	    	select: {
	             style: 'multi',
	             selector: 'td:first-child'
	        },
			buttons: [
				$.extend( true, {}, {
		        exportOptions: {
		            format: {
		                body: function ( data, row, column, node ) {
		                	data = $('<p>' + data + '</p>').text();
		                	data = data.replace(/\./g, '');
		                    return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
		                }
		            }
		        }
			    }, {
					extend: 'excelHtml5',
					title: function () {
						var nombre = "Codigos Descuento Calim";
						return nombre;
						}
					} ),
				'copyHtml5',
				'selectAll',
				'selectNone'
			],
			sPaginationType: 'simple',
			fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					// window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistCodigosDescuento();

		/*** CBO Usuarios ***/
			$("#modalGenerarCodigos_vendedor").select2({
				placeholder: 'Seleccione al vendedor',
				formatNoMatches: function() {
					return '<g:message code="default.no.elements" default="No hay elementos"/>';
				},
				formatSearching: function() {
					return '<g:message code="default.searching" default="Buscando..."/>';
				},
				minimumResultsForSearch: 1,
				formatSelection: function(item) {
					return item.text;
				}
			});
			llenarCombo({
				comboId : "modalGenerarCodigos_vendedor",
				ajaxLink : '${createLink(controller: "usuario", action:"ajaxGetAdmins")}',
				atributo : 'username'
			});
	});

	function llenarDatoslistCodigosDescuento(){
		// $('#loaderList').show()
		tabla.clear();
		$.ajax("${createLink(action:'ajaxGetCodigos')}", {
			dataType: "json",
			data: {}
		}).done(function(data) {
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();
			$('#loaderList').fadeOut('slow', function() {
		        $(this).hide();
		    });
		});
	}

	function deleteCodigos(){
		swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro?'/>",
			text: "<g:message code='zifras.descuento.codigo.delete.message' default='Todos los códigos seleccionados se eliminarán.'/>",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.descuento.codigo.delete.ok' default='Si, eliminar'/>",
			cancelButtonText: "<g:message code='zifras.descuento.codigo.delete.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		},
		function(isConfirm) {
			if (! isConfirm)
				return
			$("#modalLoading").modal("show")
			var idsCodigos = "";
			for(i=0; i < tabla.rows('.selected').data().length ; i++){
				idsCodigos += tabla.rows('.selected').data()[i].id;

				if(i != (tabla.rows('.selected').data().length - 1)){
					idsCodigos += ',';
				}
			}
				
			$.ajax("${createLink(action:'ajaxBorrarCodigos')}", {
				dataType: "json",
				method: "POST",
				data: {
					idsCodigos: idsCodigos
				}
			}).done(function(respuesta) {
				setTimeout(function() {
					if (respuesta.hasOwnProperty('error'))
						swal("Error", respuesta.error, "error")
					else
						swal({ title: "", text: "Se eliminaron los códigos seleccionados", type: "success" })
					llenarDatoslistCodigosDescuento();
					$("#modalLoading").modal("hide")
				}, 500)
			});
		});
	}

	function generarCodigos(){
		$("#modalGenerarCodigos").modal("hide")
		$("#modalLoading").modal("show")
		$.ajax("${createLink(action: 'ajaxGenerarCodigos')}", {
			dataType: "json",
			method: "POST",
			data: {
				cantidad: $("#modalGenerarCodigos_cantidad").val(),
				vendedorId: $("#modalGenerarCodigos_vendedor").val(),
				descuento: $("#modalGenerarCodigos_descuento").val(),
				detalle: $("#modalGenerarCodigos_detalle").val(),
				fechaExpiracion:$("#modalGenerarCodigos_fecha").val()
			}
		}).done(function(data) {
			let texto;
			let tipo;
			if (data.estado == "ok"){
				texto = "Se generaron correctamente los códigos."
				tipo = "success"
				$("#modalLoading").modal("hide")
			}else{
				texto = "Ocurrió un error generando los códigos"
				tipo = "error"
				setTimeout(function(){
					$("#modalLoading").modal("hide")
				}, 500);
			}

			swal({
				title: "",
				text: texto,
				type: tipo
			},
			function() {
				llenarDatoslistCodigosDescuento();
			});
		});
	}
</script>
</body>
</html>