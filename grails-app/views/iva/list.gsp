<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
	
	<!-- Data Table Css -->
	<link rel="stylesheet" type="text/css" href="${resource(dir: 'assets/guru/bower_components/datatables.net-bs4/css', file: 'dataTables.bootstrap4.min.css')}" />
	<link rel="stylesheet" type="text/css" href="${resource(dir: 'assets/guru/assets/pages/data-table/css', file: 'buttons.dataTables.min.css')}">
	<link rel="stylesheet" type="text/css" href="${resource(dir: 'assets/guru/bower_components/datatables.net-responsive-bs4/css', file: 'responsive.bootstrap4.min.css')}" />
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
		                    <h4><g:message code="zifras.impuestos.Iva.list.label" default="Liquidaciones de IVA"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<!-- <g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Cuenta']"/></g:link> -->
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<!-- <table id="listCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>CUIT</th>
									<th>Razón Social</th>
									<th>Nombre</th>
									<th>Apellido</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table> -->
					</div>
				</div>
				<!-- Statistics and revenue End -->
			</div>
		</div>
	</div>
</div>

<!-- data-table js -->
<script type="text/javascript" src="${resource(dir: 'assets/guru/bower_components/datatables.net/js', file: 'jquery.dataTables.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'assets/guru/bower_components/datatables.net-buttons/js', file: 'dataTables.buttons.min.js')}"></script>
	
<script type="text/javascript" src="${resource(dir: 'assets/guru/assets/pages/data-table/js', file: 'jszip.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'assets/guru/assets/pages/data-table/js', file: 'pdfmake.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'assets/guru/assets/pages/data-table/js', file: 'vfs_fonts.js')}"></script>

<script type="text/javascript" src="${resource(dir: 'assets/guru/bower_components/datatables.net-buttons/js', file: 'buttons.print.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'assets/guru/bower_components/datatables.net-buttons/js', file: 'buttons.html5.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'assets/guru/bower_components/datatables.net-bs4/js', file: 'dataTables.bootstrap4.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'assets/guru/bower_components/datatables.net-responsive/js', file: 'dataTables.responsive.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'assets/guru/bower_components/datatables.net-responsive-bs4/js', file: 'responsive.bootstrap4.min.js')}"></script>
	
<!-- Custom js -->
<script type="text/javascript" src="${resource(dir: 'assets/guru/assets/pages/data-table/js', file: 'data-table-custom.js')}"></script>
	
<script type="text/javascript">

</script>
</body>
</html>