<!DOCTYPE html>
<html lang="en">

<head>
    <div class="theme-loader" id="loaderCuenta">
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
	<div id="urlGetCuentasList">
		<g:createLink controller="cuenta" action="ajaxGetCuentasSQL" />
	</div>
	<div id="urlEnviarNotificaciones">
		<g:createLink controller="notificacion" action="ajaxEnviarNotificacionesPersonalizadas" />
	</div>
</div>

<div class="main-body">
	<div class="page-wrapper">
		<!-- Page-header start -->
		<div class="page-header card">
			<div class="row align-items-end">
				<div class="col-lg-8">
					<div class="page-header-title">
						<div class="d-inline">
		                    <h4 style="margin-bottom: 20px;"><g:message code="zifras.cuenta.pp.label" default="Notificación Personalizable"/></h4>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		<g:form action="enviarNotificacionesPersonalizadas" controller="notificacion" name="formNotificaciones">
		<div class="page-body">
			<div class="d-inline">
                <h3 style="margin-bottom: 20px; text-decoration: underline;"><g:message code="zifras.cuenta.pp.label" default="Mail"/></h3>
			</div>
			<div class="card">
				<div class="d-inline">
                    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Asunto:</h5>
				</div>
				<div class="form-group row">
                    <div class="col-sm-10">
                        <input id="asuntoMail" name="asuntoMail" class="form-control-primary form-control" placeholder="Asunto" style="align-self: left; margin-left: 10px"></input>
                    </div>
                </div>
				<div class="d-inline">
                    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Html:</h5>
				</div>
				<div class="form-group row">
                    <div class="col-sm-10">
                        <textarea id="cuerpoEmail" name="cuerpoEmail" rows="8" cols="6" class="form-control-primary form-control" placeholder="Html" style="align-self: left; margin-left: 10px"></textarea>
                        <button id="btnHtml" name="btnHtml" type="button" style="margin-left: 10px; margin-top: 10px;"> Visualizar HTML </button>
                    </div>
                </div>
                <div class="form-group row">
					<div class="col-sm-10">
						<div class="results" id="results" style="display:none; border:1px solid blue; overflow:hidden; width:1200px; height:500px; margin-left: 10px; overflow-y: scroll;"></div>
					</div>
				</div>
			</div>

			<div class="d-inline">
           		<h3 style="margin-bottom: 20px; text-decoration: underline;"><g:message code="zifras.cuenta.pp.label" default="Notificación Push"/></h3>
			</div>
			<div class="card">
				<div class="d-inline">
		                    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Titulo:</h5>
						</div>
				<div class="form-group row">
                    <div class="col-sm-10">
                        <input id="tituloApp" name="tituloApp" type="text" class="form-control-primary form-control" placeholder="Titulo Notificacion App" style="align-self: left; margin-left: 10px"></input>
                    </div>
                </div>
				<div class="d-inline">
		                    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Texto:</h5>
						</div>
				<div class="form-group row">
                    <div class="col-sm-10">
                        <input id="textoApp" name="textoApp" type="text" class="form-control-primary form-control" placeholder="Notificacion App" style="align-self: left; margin-left: 10px"></input>
                    </div>
                </div>
			</div>
			<br></br>

			<div class="d-inline">
				<div class="row">
	           		<h3 style="margin-bottom: 20px; text-decoration: underline; margin-left: 20px"><g:message code="zifras.cuenta.pp.label" default="Programar fecha"/></h3>
	           		<div class="form-radio" style="margin-left: 20px; margin-top:5px">
		           		<div class="radio radio-inline">
		                    <label style="color:black">
		                        <input type="radio" name="programada" id="no" value="no" checked="checked">
		                        <i class="helper"></i>No
		                    </label>
		                </div>
		                <div class="radio radio-inline">
		                    <label style="color:black">
		                        <input type="radio" name="programada" id="si" value="si">
		                        <i class="helper"></i>Si
		                    </label>
		                </div>
		            </div>
                </div>
			</div>
			<div id="divFecha" class="card" style= "display: none;">
				<div class="d-inline">
                    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Fecha:</h5>
				</div>
				<div class="form-group row">
					<div class="col-sm-10">
						<input id="fecha" name="fecha" class="form-control-primary form-control" type="text" data-format="d/m/Y" placeholder="Seleccione un día" value="${comprobantePagoInstance?.fecha?.toString('dd/MM/yyyy')}" style="align-self: left; margin-left: 10px"/>
					</div>
				</div>
				<div class="d-inline">
                    <h5 style="padding-top: 10px; margin-left: 10px; margin-bottom: 15px">Hora:</h5>
				</div>
				<div class="form-group row">
					<div class="col-sm-10">
						<input type="time" class="form-control-primary form-control" id="hora" name="hora" min="09:00" max="24:00" style="align-self: left; margin-left: 10px">
					</div>
				</div>

			</div>

			<br></br>
			<div class="d-inline">
           		<h3 style="margin-bottom: 20px; text-decoration: underline;"><g:message code="zifras.cuenta.pp.label" default="Cuentas a notificar"/></h3>
			</div>		
			<div class="card">
				<div class="card-block">
					<div class="dt-responsive table-responsive" id="divListCuentas">
						<table id="listCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<button id="selecBuscados" class="btn btn-primary m-b-0" type="button">Seleccionar Buscados</button>
								<tr>
									<th id="listCuentasTh1"></th>
									<th>CUIT</th>
									<th>Razón Social</th>
									<th>Cond. IVA</th>
									<th>AppCalim</th>
									<th>Delivery</th>
									<th>Servicio Pagado</th>
									<th>Provincia IIBB</th>
									<th>Reg. IIBB</th>
									<th>MercadoLibre</th>
									<th>AFIP</th>
									<th>IIBB</th>
									<th>Info.Revisada</th>
									<th>Etiqueta</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Statistics and revenue End -->
			</div>
			<button type="submit" id="submitBtn" class="btn btn-primary m-b-0" style="height: 50px; width: 130px" >NOTIFICAR</button>
		</div>
	</g:form>
	</div>

<script type="text/javascript">
	var tabla;
	var todoSeleccionado = false;

	jQuery(document).ready(function() {

		window.onload = function(){
			var button = document.getElementById("btnHtml");
			const compileMarkup = () => {
				var markUp = $("#cuerpoEmail").val();
				const resultsContainer = document.getElementById("results");
				$("#results").show();
				resultsContainer.innerHTML = markUp
			}
			button.addEventListener('click',compileMarkup,false);
		}

		$('input[type=radio][name=programada]').change(function() {
		    if (this.value == 'si') {
		        $("#divFecha").show();
		    }
		    else if (this.value == 'no') {
		        $("#divFecha").hide();
		    }
		});


		document.getElementById("submitBtn").addEventListener("click", function(event){
            var emailCuentas = "";
			var idCuentas = "";
			for(i=0; i < tabla.rows('.selected').data().length ; i++){
				emailCuentas += tabla.rows('.selected').data()[i].email;
				idCuentas += tabla.rows('.selected').data()[i].id;

				if(i != (tabla.rows('.selected').data().length - 1)){
					emailCuentas += ',';
					idCuentas += ',';
				}
			}
			if(emailCuentas == ""){
				alert("Selecciona al menos una cuenta");
                event.preventDefault();
			}
			else{
				if($("#htmlMail").val()==""){
					alert("Ingrese el html del mail a notificar");
                	event.preventDefault();
				}
				else{
					if(($("#tituloApp").val()=="") && ($("#textoApp").val()!="")){
						alert("Ingrese un titulo para la notificacion push");
                		event.preventDefault();
					}
					else{
						$("#formNotificaciones").append('<input type="hidden" name="emailCuentas" value='+emailCuentas+' >');
			            $("#formNotificaciones").submit();
					}
	        	}
	        }
        });


		$('#listCuentasTh1').click(function() {
			if(todoSeleccionado===true){
				$('#listCuentasTh1').parent().removeClass("selected");
				todoSeleccionado = false;
				tabla.rows().deselect();
			}else{
				$('#listCuentasTh1').parent().addClass("selected");
				todoSeleccionado = true;
				tabla.rows({ filter: 'applied' }).select();
			}
		});

		var buttonCommon = {
        exportOptions: {
        	columns: [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        	rows: { selected: true },
            format: {
            	body: function ( data, row, column, node ) {
            		if((column==3)||(column==4)){
            			if(data=='-')
            				return 'No'
            			else
            				return 'Si'
            		}
                	data = $('<p>' + data + '</p>').text();
                	data = data.replace(/\./g, '');
                    return $.isNumeric(data.replace(',', '.')) ? data.replace(',', '.') : data;
                	}
           		}
        	}
    	};

		tabla = $('#listCuentas').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.list.agregar', default: 'No hay cuentas ¡Agrega una cuenta!')}</a>",
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
			iDisplayLength: 25,
			//scrollX: true,
			aaSorting: [
				[8, 'desc']
			],
			aoColumnDefs: [{
							"aTargets": [0],
				   			'orderable': false,
				   			'className': 'select-checkbox',
				   			"mData": "selected"
				   		},{
			       			"aTargets": [1],
			       			"mData": "cuit",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [2],
			       			"mData": "razonSocial"
						},{
			       			"aTargets": [3],
			       			"mData": "condicionIva"
						},{
							"aTargets": [4],
			       			"mData": "appCalimDescargada",
							"mRender": function ( data, type, full ) {
				       			return data ? 'Descargada' : 'Sin Descargar';
				   	       	}
						},{
			       			"aTargets": [5],
			       			"mData": "trabajaConApp",
							"mRender": function ( data, type, full ) {
				       			return data ? 'Delivery' : '-';
				   	       	}
				   	    },{
				   	    	"aTargets": [6],
			       			"mData": "algunServicioPagado",
							"mRender": function ( data, type, full ) {
				       			return data ? 'Servicio Pago' : '-';
				   	       	}
						},{
			       			"aTargets": [7],
			       			"mData": "porcentajesProvinciaIIBB"
						},{
			       			"aTargets": [8],
			       			"mData": "regimenIibb"
			       		},{
			       			"aTargets": [9],
			       			"mData": "esMercadoLibre",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
			       		},{
			       			"aTargets": [10],
			       			"mData": "afipMiscomprobantes",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
			       		},{
			       			"aTargets": [11],
			       			"mData": "ingresosBrutos",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
			       		},{
			       			"aTargets": [12],
			       			"mData": "infoRevisada",
							"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
			       		},{
			       			"aTargets": [13],
			       			"mData": "etiqueta"
			       		}],
			select: {
	             style: 'multi',
	             selector: 'td:first-child'
	        },
       		sPaginationType: 'simple',
       		sDom: "flrtip",
       		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					//window.location.href = $('#urlShow').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistCuentas();

		$("#selecBuscados").click(function(){
			tabla.rows( { search: 'applied' } ).select();
		});
		
		/*$('#global_filter').keyup(function() {
			tabla.search($('#global_filter').val()).draw();
		});*/
		$("#fecha").dateDropper( {
        dropWidth: 200,
        dropPrimaryColor: "#1abc9c", 
        dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		minYear: 2020,
		format: "d/m/Y",
		lang: "es"
    	});	
	});

	

	function llenarDatoslistCuentas(){
		$.ajax($('#urlGetCuentasList').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			$('#loaderCuenta').fadeOut('slow', function() {
		        $(this).remove();
		    });
			for(key in data){
				tabla.row.add(data[key]);
			}
			$("#divListCuentas").show();
			tabla.draw();
			
		});
	}
</script>
</body>
</html>