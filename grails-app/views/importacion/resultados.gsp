<%@ page import="com.zifras.importacion.LogImportacion" %>
<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
	<g:hiddenField id="facturas" name="factura" value="${facturas}" />
	<div class="main-body">
		<div class="page-wrapper">
		
			<!-- Page-header start -->
			<div class="page-header card">
				<div class="row align-items-end">
					<div class="col-lg-8">
						<div class="page-header-title">
							<div class="d-inline">
			                    <h4>Resultado de la importación</h4>
							</div>
						</div>
					</div>
					<div class="col-lg-4">
						
					</div>
				</div>
			</div>
			<!-- Page-header end -->
			
			<!-- Page body start -->
			<div class="page-body">
				<div class="row">
					<!-- Sho Map Start -->
					<div class="col-md-12">
						<div class="card">
							<div class="card-block typography">
								<div class="row">
									<div class="col-md-12">
										<table id="lista" class="table table-striped table-bordered nowrap" style="width: 100%;">
											<thead>
												<tr>
													<th>Archivo</th>
													<th>Tipo</th>
													<th>Cuenta</th>
													<th>Cantidad Ok</th> 
													<th>Cantidad Ignoradas</th>
													<th>Cantidad Mal</th>
													<th>Nuevos Clie./Prov.</th>
													<th>Estado.</th>
													<th>Detalle</th>
												</tr>
											</thead>
											<tbody>
												<g:each in="${command}">
													<tr>
														<td>${it.nombreArchivo}</td>
														<td>${it.getTipo()}</td>
														<g:if test="${it.cuenta}">
															<td>${it.cuenta.toString()}</td>
														</g:if>
														<g:else>
															<td>-</td>
														</g:else>
														<td>${it.cantidadOk}</td>
														<td>${it.cantidadIgnoradas}</td>
														<td>${it.cantidadMal}</td>
														<td>${it.nuevasPersonas}</td>
														<td>${it.estado.nombre}</td>
														<td>${it.detalle}</td>
													</tr>
												</g:each>
											</tbody>
										</table>
									</div>
								</div>
								
								<div class="row">
									<div class="col-md-12">
										<h4 class="sub-title"></h4>
										<g:link class="btn btn-inverse m-b-0" action="panel"><g:message code="default.button.back.label" default="Volver" /></g:link>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>


<script type="text/javascript">
	var tabla;
	var facturas;

	jQuery(document).ready(function() {
		facturas = ($("#facturas").val() == "true");
		tabla = $('#lista').DataTable({
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
				[0, 'asc']
			],
			aoColumnDefs: [
	            {
	                "targets": [ 4 ],
	                "visible": facturas,
	                "searchable": facturas
	            },
	            {
	                "targets": [ 5 ],
	                "visible": facturas,
	                "searchable": facturas
	            },
	            {
	                "targets": [ 6 ],
	                "visible": facturas,
	                "searchable": facturas
	            }
	        ],
        	"scrollX": true,
       		sPaginationType: 'simple',
	   		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
	   			if(aData[7]!='Activo'){
	   	   			$(nRow).css({"background-color":"red","color":"white"});
	   	   	   	}
			}
		});
		tabla.draw();
	});
</script>
</body>
</html>