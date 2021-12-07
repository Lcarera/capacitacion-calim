<!DOCTYPE html>
<html lang="en">

<head>
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
		                    <h4>Crear Plan Moratoria</h4>
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
				<div class="col-sm-12">
					<!-- Basic Form Inputs card start -->
					<div class="card">
						<div class="card-block">
							<h4 class="sub-title">Plan Moratoria</h4>
							<g:uploadForm id="formMoratoria" action="save">
								<g:render template="form"/>
								<div class="row">
									<div class="col-sm-10">
										<button id="buttonSubmit" type="submit" class="btn btn-primary m-b-0">Aceptar</button>
										<g:link class="btn btn-inverse m-b-0" controller="moratoria" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
									</div>
								</div>
							</g:uploadForm>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>