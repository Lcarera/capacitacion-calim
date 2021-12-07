<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="layout" content="registroLayout">
</head>

<body class="fix-menu">
	<section class="login p-fixed d-flex text-center bg-primary common-img-bg">
		<!-- Pre-loader start -->
	<div class="theme-loader" id="loaderGeneral">
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

		<!-- Container-fluid starts -->
		<div class="container">
			<div class="row">
				<div class="col-sm-12">
					<!-- Authentication card start -->
					<div class="signup-card auth-body mr-auto ml-auto">
						<g:form action="saveMontos" class="md-float-material">
							<g:hiddenField name="cuentaId" value="${cuentaId}"/>
							<div class="text-center">
								<asset:image src="auth/logo-dark.png"/>
							</div>
							<br>
							<div class="auth-box">
								<!-- <g:if test="${flash.error}">
									<div class="alert alert-danger background-danger">
										<button type="button" class="close" data-dismiss="alert" aria-label="Close">
											<i class="icofont icofont-close-line-circled text-white"></i>
										</button>
										<strong>${flash.error}</strong>
									</div>
								</g:if> -->
								<h5 class="b-b-default text-left txt-primary m-b-20 ttl-login"><g:message code='zifras.security.signin' default='¡Autorizaste tu liquidación!'/></h5>
								<div class="text-left txt-primary m-b-20 ttl-login" style="color:#000000;"/>Para ahorrar tiempo, indicanos un monto máximo para presentar tus impuestos automáticamente.</div>
								<div class="text-left txt-primary m-b-20 ttl-login" style="color:#000000;"/><strong>¡Te avisaremos sólo cuando sea mayor!</strong></div>
								<div class="form-group row">
									<div style="${aplicaIva ? 'margin-bottom: 20px;' : 'display:none;'}" class="input-group col-12">
										<span class="input-group-addon" id="basic-addon1">$</span>
										<input id="valorIva" name="valorIva" type="text" value="${recomendadoIva}" data-a-sep="" data-a-dec="," class="form-control autonumber" placeholder="IVA"></input>
										<span class="input-group-addon" id="basic-addon1">IVA</span>
									</div>
									<div style="${aplicaIibb ? '' : 'display:none;'}" class="input-group col-12">
										<span class="input-group-addon" id="basic-addon1">$</span>
										<input id="valorIIBB" name="valorIIBB" type="text" value="${recomendadoIibb}" data-a-sep="" data-a-dec="," class="form-control autonumber" placeholder="IIBB"></input>
										<span class="input-group-addon" id="basic-addon1">IIBB</span>
									</div>
								</div>
								
								<div class="row" style="margin-top: 35px;">
									<div class="col-12">
										<button id="submitBtn" type="submit" style="width:100%" class="formBtn btn btn-primary block waves-effect">Aceptar</button>
									</div>
								</div>
							</div>
						</g:form>
						<!-- end of form -->
					</div>
					<!-- Authentication card end -->
				</div>
				<!-- end of col-sm-12 -->
			</div>
			<!-- end of row -->
		</div>
		<!-- end of container-fluid -->
	</section>
	<script>
	$(document).ready(() => {
		$("#valorIva").change(function(){
			var valorIva = 0;
			if(($('#valorIva').val()!="") && ($('#valorIva').val()!=null)){
				valorIva = parseFloat($('#valorIva').val().replace(",", "."));
			}else{
				valorIva = 0;
			}

			$("#valorIva").val(valorIva.toFixed(2).replace(".", ","));
		});

		$("#valorIIBB").change(function(){
			var valorIIBB = 0;
			if(($('#valorIIBB').val()!="") && ($('#valorIIBB').val()!=null)){
				valorIIBB = parseFloat($('#valorIIBB').val().replace(",", "."));
			}else{
				valorIIBB = 0;
			}

			$("#valorIIBB").val(valorIIBB.toFixed(2).replace(".", ","));
		});
	});    
	</script>
</body>

</html>
