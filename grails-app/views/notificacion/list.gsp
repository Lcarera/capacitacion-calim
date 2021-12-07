<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">
</head>

<body>
<div style="display: none;">
	<div id="urlActualizarNotificacionesPendientes">
		<g:createLink controller="notificacion" action="ajaxActualizarNotificacionesPendientes" />
	</div>
</div>
<g:hiddenField name="cuenta" id="cuenta" value="${cuenta}"/>
<div class="main-body">
	<div class="page-wrapper">
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-8">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4><g:message code="zifras.documento" default="Notificaciones"/></h4>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="page-body">
			<div class="col-lg-12">
                <h6 class="sub-title"></h6>
                <ul class="basic-list list-icons">
                	<g:each in="${notificacionesCuenta}" var="n">
                		<li style="border-bottom: 1px solid #E8E8E8">
                			<h6 ${n.notificacionLeida == true ? '' : raw('style="font-weight: bold"')}><label style="color:gray">${n.fechaHora.toString("dd/MM")}</label>&nbsp&nbsp${n.tituloNotificacionApp}</h6>
		                    <p class="text-c-blue">${n.textoNotificacionApp}</p>
	                    </li>
		                	</br>
	                </g:each>
                </ul>
            </div>
		</div>
	</div>
</div>



<script type="text/javascript">
	jQuery(document).ready(function() {
		$.ajax($('#urlActualizarNotificacionesPendientes').text(), {
		data: {
			cuentaId: "${cuenta.id}"
		}
		});
	});
</script>
</body>
</html>