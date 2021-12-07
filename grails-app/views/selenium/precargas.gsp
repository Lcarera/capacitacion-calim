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
<%@ page import="com.zifras.User" %>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-4">
					<div class="page-header-title">
						<div class="d-inline">
							<h4>Precargas</h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div style="text-align:right;">
						<input id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${mes}"/>
						<!--<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Liquidacion']"/></g:link>-->
					</div>
				</div>
				<div class="col-lg-4">
					<div style="text-align:right;">
						<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<g:render template = "listaPrecargas" model="[cuentaId:false]"/>
		</div>
	</div>
</div>

<script type="text/javascript">
	jQuery(document).ready(function() {
		$("#mes").dateDropper( {
	        dropWidth: 200,
	        dropPrimaryColor: "#1abc9c", 
	        dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "m",
			lang: "es"
	    });

		$("#ano").dateDropper( {
	        dropWidth: 200,
	        dropPrimaryColor: "#1abc9c", 
	        dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "Y",
			minYear: 2010,
			maxYear: 2040,
			lang: "es"
	    });

		$("#mes").change(function () {
			llenarListSelenium()
		});

		$("#ano").change(function () {
			llenarListSelenium()
		});
	});

	function llenarListSelenium(){
		$('#loaderGrande').show()
		tablaPrecargas.clear()
		$.ajax("${createLink(controller:'cuenta', action:'ajaxListEtapasSelenium')}", {
			dataType: "json",
			data: {
				mes: $("#mes").val(),
				ano: $("#ano").val(),
				etapa: 2,
				cuentaId: ${cuentaId ?: "null"},
				etiqueta: "${etiqueta}"
			}
		}).done(function(data) {
			$('#loaderGrande').fadeOut('slow', function() {
				$(this).hide();
			});
			for(key in data){
				tablaPrecargas.row.add(data[key]);
			}
			tablaPrecargas.draw();
			$('#loaderGrande').show()
		});
	}
</script>
</body>
</html>