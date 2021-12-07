<!DOCTYPE html>
<html lang="en">

<head>
	<meta name="layout" content="main">	
</head>

<body>
<div style="display: none;">
	<div id="urlGetElementos">
		<g:createLink controller="elementoFaq" action="ajaxGetElementos" />
	</div>
	<div id="urlGetCategorias">
		<g:createLink controller="elementoFaq" action="ajaxGetCategoriasFaq" />
	</div>
	<div id="urlShow">
		<g:createLink controller="elementoFaq" action="show" />
	</div>
	<div id="urlEdit">
		<g:createLink controller="elementoFaq" action="edit" />
	</div>	
	<div id="urlEditCategoria">
		<g:createLink controller="elementoFaq" action="editarCategoria" />
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
		                    <h4><g:message code="zifras.documento.ElementoFaq.list.label" default="Lista de FAQ's"/></h4>
						</div>
					</div>
				</div>
				<div class="col-lg-4">
					<div class="card-header-right" style="text-align:right;">
						<g:link action="create" class="btn btn-success" style="margin-right: 10px"><g:message code="default.add.label" default="Agregar {0}" args="['FAQ']"/></g:link>
						<button action="create" type="button" class="btn btn-success" onclick="$('#modalCategoria').modal('show');"><g:message code="default.add.label" default="Agregar {0}" args="['Categoría']"/></button>
					</div>
				</div>
			</div>
		</div>
		<!-- Page-header end -->
		
		<div class="page-body">
			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listElementosFaq" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Titulo</th>
									<th>Peso</th>
									<th>Categoría</th>
									<th>Monotributista</th>
									<th>Autonomo</th>
									<th>Simplificado</th>
									<th>Convenio</th>
									<th>Local</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
				<!-- Statistics and revenue End -->
			</div>

			<div class="col-lg-8">
				<div class="page-header-title">
					<div class="d-inline">
	                    <h4><g:message code="zifras.documento.CategoriaFaq.list.label" default="Lista de Categorías"/></h4>
	                    <br>
					</div>
				</div>
			</div>

			<div class="card">
				<div class="card-block ">
					<div class="dt-responsive table-responsive">
						<table id="listCategoriasFaq" class="table table-striped table-bordered nowrap" style="cursor:pointer">
							<thead>
								<tr>
									<th>Nombre</th>
									<th>Peso</th>
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


<div class="modal fade" id="modalCategoria" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Crear Categoría FAQ</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
            	<g:form name="creacionCategoria" controller="elementoFaq" action="saveCategoria">
	            	<div class="form-group row">
		            	<label class="col-sm-2 col-form-label">Nombre</label>
	   					<div class="col-sm-10">
	                		<input id="nombreCategoria" name="nombreCategoria" class="form-control-primary form-control" placeholder="Nombre"></input>
	   					</div>
		   			</div>
		   			<div class="form-group row">
		            	<label class="col-sm-2 col-form-label">Peso</label>
	   					<div class="col-sm-10">
	                		<input id="pesoCategoria" name="pesoCategoria" class="form-control-primary form-control" placeholder="Peso"></input>
	   					</div>
		   			</div>
		   		</g:form>
            </div>
            <div class="modal-footer">
                <button id="buttonLocalVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
                <button id="buttonLocalAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="$('#creacionCategoria').submit();">Aceptar</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
var tablaElementosFaq;
var banderaBeforeSend = true;

	jQuery(document).ready(function() {
		tablaElementosFaq = $('#listElementosFaq').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			"pageLength": 25,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.comprobantePago.ComprobantePago.list.agregar', default: 'No hay Elementos')}</a>",
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
			aaSorting: [
				[1, 'asc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "titulo",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [1],
			       			"mData": "peso"
						},{
							"aTargets": [2],
			       			"mData": "categoria"
						},{
			       			"aTargets": [3],
			       			"mData": "monotributista",
			       			"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}		       			
						},{
			       			"aTargets": [4],
			       			"mData": "respInscripto",
			       			"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}
			       		},{
			       			"aTargets": [5],
			       			"mData": "regimenSimplificado",
			       			"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}     
				   	    },{
				   	    	"aTargets": [6],
			       			"mData": "convenio",
			       			"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}   
				   	    },{
				   	    	"aTargets": [7],
			       			"mData": "local",
			       			"mRender": function ( data, type, full ) {
				       			return data ? '<i class="icofont icofont-ui-check"></i>' : '-';
				   	       	}   			
			       		}],
       		sPaginationType: 'simple',
       		sDom: "flrtip",
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlEdit').text() + '/' + aData['id'];
				});
			}
		});

		tablaCategoriasFaq = $('#listCategoriasFaq').DataTable({
			//bAutoWidth: false,
			//bSortCellsTop: true,
			//BProcessing: true,
			"ordering": true,
			"searching": true,
			"pageLength": 25,
			oLanguage: {
				sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
				sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
				sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
				sZeroRecords: "${message(code: 'zifras.comprobantePago.ComprobantePago.list.agregar', default: 'No hay Elementos')}</a>",
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
			aaSorting: [
				[1, 'asc']
			],
			aoColumnDefs: [{
			       			"aTargets": [0],
			       			"mData": "nombre",
			       			'sClass': 'bold'
						},{
			       			"aTargets": [1],
			       			"mData": "peso"
			       		}],
       		sPaginationType: 'simple',
       		sDom: "flrtip",
    		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
				// Row click
				$(nRow).on('click', function() {
					window.location.href = $('#urlEditCategoria').text() + '/' + aData['id'];
				});
			}
		});

		llenarDatoslistElementosFaq();
		llenarDatoslistCategoriasFaq();

		function setInputFilter(textbox, inputFilter) {
          ["input", "keydown", "keyup", "mousedown", "mouseup", "select", "contextmenu", "drop"].forEach(function(event) {
            textbox.addEventListener(event, function() {
              if (inputFilter(this.value)) {
                this.oldValue = this.value;
                this.oldSelectionStart = this.selectionStart;
                this.oldSelectionEnd = this.selectionEnd;
              } else if (this.hasOwnProperty("oldValue")) {
                this.value = this.oldValue;
                this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
              } else {
                this.value = "";
              }
            });
          });
        }

		setInputFilter(document.getElementById("pesoCategoria"), function(value) {
          return /^\d*\.?\d*$/.test(value); // Allow digits and '.' only, using a RegExp
        });

	});

	function llenarDatoslistElementosFaq(){
		tablaElementosFaq.clear().draw();
		$.ajax($('#urlGetElementos').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			for(key in data){
				tablaElementosFaq.row.add(data[key]);
			}
			tablaElementosFaq.draw();
		});
	}

	function llenarDatoslistCategoriasFaq(){
		tablaCategoriasFaq.clear().draw();
		$.ajax($('#urlGetCategorias').text(), {
			dataType: "json",
			data: {
			}
		}).done(function(data) {
			for(key in data){
				tablaCategoriasFaq.row.add(data[key]);
			}
			tablaCategoriasFaq.draw();
		});
	}
</script>
</body>
</html>