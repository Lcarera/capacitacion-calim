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
<div style="display: none;">
	<div id="urlShow">
		<g:createLink controller="cuenta" action="show" />
	</div>	
</div>
<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-6">
					<div class="row">
						<div class="col-12">
							<div class="page-header-title">
	                    		<h4>Selenium</h4>
	                    	</div>
	                    </div>
	                    <div class="col-12">
	                    	<a href="/cuenta/show/${cuentaId}">${cuit} - ${razonSocial}<a/>
	                    </div>
					</div>
				</div>
				<div class="col-lg-6">
					<div style="text-align:right;">
						<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${ano}"/>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<g:render template="/selenium/listaDescargas"/>
			<g:render template="/selenium/listaPrecargas"/>
		</div>
	</div>
</div>

<script type="text/javascript">
	jQuery(document).ready(function() {
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

		$("#ano").change(function () {
			llenarListSelenium()
		});
	});

	function llenarListSelenium(){
		$('#loaderGrande').show()
		tablaDescargas.clear()
		tablaPrecargas.clear()
		$.ajax("${createLink(controller:'cuenta', action:'ajaxListEtapasSelenium')}", {
			dataType: "json",
			data: {
				ano: $("#ano").val(),
				cuentaId: ${cuentaId ?: "null"}
			}
		}).done(function(data) {
			$('#loaderGrande').fadeOut('slow', function() {
		        $(this).hide();
		    });
			for(key in data){
				tablaDescargas.row.add(data[key]);
				tablaPrecargas.row.add(data[key]);
			}
			tablaDescargas.draw();
			tablaPrecargas.draw();
			$('#loaderGrande').show()
		});
	}
</script>
</body>
</html>