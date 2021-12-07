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
		                    <h4><g:message code="default.add.label" default="Agregar {0}" args="['Plantilla de Notificacion']"/></h4>
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
							<h4 class="sub-title">Datos Plantilla</h4>
							<g:uploadForm action="saveNotificacionTemplate">
								<g:render template="formNotificacionesTemplates"/>
								<div class="row">
									<div class="col-sm-10">
										<button type="submit" class="btn btn-primary m-b-0">Aceptar</button>
										<g:link class="btn btn-inverse m-b-0" action="listTemplates"><g:message code="default.button.back.label" default="Volver" /></g:link>
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