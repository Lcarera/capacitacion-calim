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
<div style="display: none;">
	<div id="urlEnviarMailBienvenida">
		<g:createLink controller="cuenta" action="ajaxReenviarMailMasivoBienvenida" />
	</div>
	<div id="urlBorrarCuentas">
		<g:createLink controller="cuenta" action="ajaxBorrarCuentas" />
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
		                    <h4><g:message code="zifras.cuenta.Cuenta.list.pendientes.label" default="Lista de Cuentas Pendientes"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_USER">
						<g:link action="create" class="btn btn-success"><g:message code="default.add.label" default="Agregar {0}" args="['Cuenta']"/></g:link>
						</sec:ifAnyGranted>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<div style="margin-bottom:20px;">
							<button id="btnVerCuenta" class="btn btn-success m-b-0" type="button">Ver cuenta</button>
							&nbsp
							<button id="btnReenviarMailBienvenida" class="btn btn-primary m-b-0" type="button" >Reenviar confirmación mail</button>
							&nbsp
							<button id="btnBorrarCuentas" class="btn btn-primary m-b-0" type="button" >Borrar cuentas</button>
						</div>
						<table id="listCuentas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th id="listCuentasTh1"></th>
									<th>Fecha de Registro</th>
									<th>CUIT</th>
									<th>Mail</th>
									<th>Nombre y Apellido</th>
									<th>Teléfono</th>
									<th>Mail Confirmado</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Statistics and revenue End -->
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	var tabla;
	var todoSeleccionado = false;
	var cantSelec = 0;

	jQuery(document).ready(function() {
		document.getElementById("btnVerCuenta").disabled = true;
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
			iDisplayLength: 100,
			//scrollX: true,
			aaSorting: [
				[7, 'desc']
			],
			aoColumnDefs: [{
							"aTargets": [0],
				   			'orderable': false,
				   			'className': 'select-checkbox',
				   			"mData": "selected"
						},{
			       			"aTargets": [1],
			       			"mData": "fechaAlta",
					       	"type": "date-eu"
					    },{
			       			"aTargets": [2],
			       			"mData": "cuit",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [3],
			       			"mData": "email",
			       			'sClass': 'bold'
			       		},{
			       			"aTargets": [4],
			       			"mData": "nombreApellido"
			       		},{
			       			"aTargets": [5],
			       			"mData": "telefono"
			       		},{
					    	"aTargets": [6],
			       			"mData": "mailConfirmado",
			       			"mRender": function ( data, type, full ) {
				       			return data ? 'Confirmado' : 'No verificado';
				       		}
					    },{
					    	"aTargets": [7],
							"mData": "milisegundos",
							visible: false
			       		}],
			select: {
	             style: 'multi',
	             selector: 'td:first-child'
	        },
  			buttons: [{
  	  				extend: 'excelHtml5',
 					title: function () {
 							var nombre = "Cuentas";
 							return nombre;
 					}
 				},{
   	            	extend: 'pdfHtml5',
   	            	orientation: 'landscape',
   	            	title: function () {
   	            		var nombre = "Cuentas";
							return nombre;
 					}
 				},{
 					extend: 'copyHtml5'
 				}],
       		sPaginationType: 'simple',
       		sDom: "lBfrtip",
       		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull, column ) {
       			if (aData['etiqueta']=='Rojo')
       				$(nRow).css({"background-color":"#CD6155","color":"white"});
       			else if (aData['etiqueta']=='Verde')
       				$(nRow).css({"background-color":"#73C6B6","color":"white"});
       			else if (aData['etiqueta']=='Amarillo')
       				$(nRow).css({"background-color":"#F4D03F","color":"black"});
       			else if (aData['etiqueta']=='Naranja')
       				$(nRow).css({"background-color":"#FC7600","color":"black"});
				// Row click
				$(nRow).on('click', function() {
					//window.location.href = '${createLink(action:"show")}' + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistCuentas();

		tabla.on('select', function (e, dt, type, indexes) {
			activarBotonShow();
		 } );

		tabla.on('deselect', function (e, dt, type, indexes) {
			activarBotonShow();
		} );

		$("#btnVerCuenta").click(function(){
			var data = tabla.rows( { selected: true } ).data();
			window.location.href = '${createLink(action:"show")}' + '/' + tabla.rows({selected:true}).data()[0]['id']
		});

		$("#btnReenviarMailBienvenida").click(function(){
			confirmarReenvioMail();
		});

		$("#btnBorrarCuentas").click(function(){
			confirmarBorradoCuentas();
		});

	});
		
		/*$('#global_filter').keyup(function() {
			tabla.search($('#global_filter').val()).draw();
		});*/

	function activarBotonShow(){
		if(tabla.rows( { selected: true } ).count() == 1){
			document.getElementById("btnVerCuenta").disabled = false;
		}
		else{
			document.getElementById("btnVerCuenta").disabled = true;
		}

	}
	function llenarDatoslistCuentas(){
		$.ajax('${createLink(action:"ajaxGetCuentasPendientesList")}', {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			$('#loaderCuenta').fadeOut('slow', function() {
		        $(this).remove();
		    });
			$("#preloader").hide();
			for(key in data){
				tabla.row.add(data[key]);
			}
			tabla.draw();		
		});
	}

	function enviarMailBienvenida(){
		var cuentasIds = "";
		for(i=0; i < tabla.rows('.selected').data().length ; i++){
			cuentasIds += tabla.rows('.selected').data()[i].id;

			if(i != (tabla.rows('.selected').data().length - 1)){
				cuentasIds += ',';
			}
		}

		var urlMail = $('#urlEnviarMailBienvenida').text();
			
		$.ajax(urlMail, {
			dataType: "json",
			method: "POST",
			data: {
				cuentasIds: cuentasIds
			}
		}).done(function(data) {
			setTimeout(function() {
				swal("Emails enviados!", "Los emails se enviaron correctamente", "success");
			}, 400);
		}).fail(function(data) {
			setTimeout(function() {
				swal("Error", "Ocurrió un error enviando los mails", "error");
			}, 400);
		});
	}

	function borrarCuentas(){
		var cuentasIds = "";
		for(i=0; i < tabla.rows('.selected').data().length ; i++){
			cuentasIds += tabla.rows('.selected').data()[i].id;

			if(i != (tabla.rows('.selected').data().length - 1)){
				cuentasIds += ',';
			}
		}

		var urlBorrarCuentas = $('#urlBorrarCuentas').text();
			
		$.ajax(urlBorrarCuentas, {
			dataType: "json",
			method: "POST",
			data: {
				cuentasIds: cuentasIds
			}
		}).done(function(data) {
			tabla.rows('.selected').remove().draw();
			setTimeout(function() {
				swal("Cuentas borradas!", "Las cuentas se borraron correctamente", "success");
			}, 400);
			
		}).fail(function(data) {
			setTimeout(function() {
				swal("Error", "Ocurrió un error borrando las cuentas", "error");
			}, 400);
		});
	}
	
	function confirmarReenvioMail(){
	swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro/a?'/>",
			text: "<g:message code='zifras.liquidacion.notificaciones.message' default='Se enviará el mail de confirmacion a los usuarios seleccionados'/>",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.enviar.ok' default='Si, enviar'/>",
			cancelButtonText: "<g:message code='zifras.enviar.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		},enviarMailBienvenida);
	}

	function confirmarBorradoCuentas(){
	swal({
			title: "<g:message code='default.button.delete.confirm.message' default='¿Estás seguro/a?'/>",
			text: "<g:message code='zifras.liquidacion.notificaciones.message' default='Se borrarán las cuentas seleccionadas'/>",
			type: "warning",
			showCancelButton: true,
			confirmButtonClass: "btn-danger",
			confirmButtonText: "<g:message code='zifras.enviar.ok' default='Si, eliminar'/>",
			cancelButtonText: "<g:message code='zifras.enviar.cancel' default='No, cancelar'/>",
			closeOnConfirm: true,
			closeOnCancel: true
		},borrarCuentas);
	}

</script>
</body>
</html>