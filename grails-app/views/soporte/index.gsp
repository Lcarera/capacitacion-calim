<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">

</div>
<g:hiddenField name="soporteWpp" id="soporteWpp" value="${soporteWpp}"/>
<g:hiddenField name="cantidadFaqs" id="cantidadFaqs" value="${cantidadFaqs}"/>
<div class="main-body">
	<div class="page-wrapper">
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-8">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.documento" default="Soporte"/></h4>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="page-body">
			<g:if test="${empleadoSoporte}">
				<sec:ifNotGranted roles="ROLE_RIDER_PY">
					<div class="col-md-12 col-lg-12">
							<div class="card">
								<div class="card-header">
									<div class="card-header-left">
										<h4>Soporte Contable</h4>
									</div>
								</div>
								<div class="card-block user-detail-card">
									<div class="row">
										<div class="col-sm-12 col-md-2">
											<asset:image src="avatar-soporte.jpg" class="img-fluid p-b-10"/>
										</div>
										<div class="col-sm-12 col-md-9 user-detail">
											<div class="row">
												<div class="col-sm-12">
													<h6 class="f-w-400 m-b-30"><i class="icofont icofont-ui-email"></i>Email</h6>
												</div>
												<div class="col-sm-12">
													<h6 class="m-b-30"><a href="mailto:soporte@calim.com.ar">soporte@calim.com.ar</a></h6>
												</div>
											</div>
											<g:if test="${empleadoSoporte?.celular}">
												<div class="row">
													<div class="col-sm-12">
														<a style="font-size: 26px" id="wpp" target="_blank"  href="https://api.whatsapp.com/send?phone=${empleadoSoporte.celular}" >
													  		<i class="fa fa-whatsapp my-float"></i> Contactar
													 	</a>
													</div>
												</div>
											</g:if>

										</div>
									</div>
								</div>
							</div>
						</div>	
		        </sec:ifNotGranted>
		    </g:if>
			<div class="col-lg-12">
				<g:if test="${faqs}">
                <h6 class="sub-title">Preguntas Frecuentes</h6>
            	</g:if>
            	<g:each status="j" var="categoria" in="${categoriasFaq}">
            		<g:if test="${faqs.any{f -> f.categoria?.nombre == categoria}}">
		            	<div class="card">
		                    <div class="card-header">
		                        <h3 class="card-header-text"><b>${categoria}</b></h3>
		                    </div>
		                    <div class="card-block accordion-block">
		                        <div id="accordion${j}" role="tablist" aria-multiselectable="true">
		                    		<g:each status="i" var="faq" in="${faqs}">
			                        	<g:if test="${faq.categoria?.nombre == categoria}">
				                            <div class="accordion-panel">
				                                <div class="accordion-heading" role="tab" id="heading${j}${i}">
				                                    <h3 class="card-title accordion-title">
				                                    <a class="accordion-msg scale_active collapsed" data-toggle="collapse" data-parent="#accordion${j}" href="#collapse${j}${i}" aria-expanded="false" aria-controls="collapse${j}${i}">
				                                        ${faq.titulo}
				                                    </a>
				                                	</h3>
				                                </div>
				                                <div id="collapse${j}${i}" class="panel-collapse in collapse" role="tabpanel" aria-labelledby="heading${j}${i}" style="">
				                                    <div class="accordion-content accordion-desc">
				                                		<div id="div${i}">
								                    		<p id="p${i}" style="display: none;">${faq.contenidoHtml}</p>
								                    	</div>
				                                    </div>
				                                </div>
				                            </div>
				                        </g:if>
			                		</g:each>
		                        </div>
		                    </div>
		                </div>
	               	</g:if>
	            </g:each>
            </div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$(document).ready(function () {
		var cant = $("#cantidadFaqs").val();
		for(i=0;i<cant;i++)
			document.getElementById("div"+i).innerHTML = $("#p"+i).text();
	});

</script>
</body>
</html>
