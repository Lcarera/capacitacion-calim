<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div class="main-body">
	<div class="page-wrapper">
		<g:form action="save">
		<!-- Page-header start -->
		<div class="page-header card" style="position:fixed;z-index:1024;border:1px #e9ecef solid;">
			<div class="row align-items-end" style="padding: 15px;">
				<div class="col-lg-6">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="default.add.label" default="Agregar {0}" args="['Liquidación Ganancias']"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="row">
						<label class="col-sm-4 col-form-label">Impuesto</label>
						<div class="col-sm-8">
							<div class="input-group" style="margin-bottom:0px;">
								<span class="input-group-addon" id="basic-addon1">$</span>
								<input id="impuesto" name="impuesto" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${liquidacionGananciaInstance?.impuesto}">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<!-- Page body start -->
		<div class="page-body">
			<div class="row">
				<div class="col-sm-12">
					<!-- Basic Form Inputs card start -->
					<div class="card" style="margin-top:150px;">
						<div class="card-block">
							<h4 class="sub-title">Liquidación Ganancias</h4>
								<g:hiddenField name="create" id="create" value="true"/>
								<g:render template="form"/>
								<div class="row">
									<label class="col-sm-2"></label>
									<div class="col-sm-10">
										<button id="botonAceptar" type="submit" class="btn btn-primary m-b-0">Aceptar</button>
										<g:link class="btn btn-inverse m-b-0" action="list"><g:message code="default.button.back.label" default="Volver" /></g:link>
									</div>
								</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		</g:form>
	</div>
</div>
</body>
</html>