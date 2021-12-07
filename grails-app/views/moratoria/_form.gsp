<g:hiddenField name="planMoratoriaId" value="${planMoratoriaInstance?.planMoratoriaId}" />
<g:hiddenField name="version" value="${planMoratoriaInstance?.version}" />
<g:hiddenField name="cuentaId" value="${cuentaId}"/>
<g:hiddenField id="cantidadCuotas" name="cantidadCuotas" value="${planMoratoriaInstance?.cantidadCuotas}"/>
<g:hiddenField id="cuotas" name="cuotas" value="${planMoratoriaInstance?.cuotas}"/>

<div style="display: none;">
	<div id="urlGetServiciosMoratoriaCuenta">
		<g:createLink controller="moratoria" action="ajaxGetServiciosMoratoriaCuenta" />
	</div>
	<div id="urlGetCuotas">
		<g:createLink controller="moratoria" action="ajaxGetCuotasMoratoria" />
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Fecha de Inicio</label>
	<div class="col-sm-10">
		<div style="text-align:right;">
			<input id="inicio" name="inicio" class="form-control" type="text" data-format="d/m/Y" placeholder="Seleccione una fecha de inicio" value="${planMoratoriaInstance?.inicio?.toString('dd/MM/YYYY')}"/>
		</div>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Servicio Especial</label>
	<div class="col-sm-10">
		<select id="cbServicioMoratoria" name="servicioEspecialId" value="${planMoratoriaInstance?.servicioEspecialId}" class="form-control"></select>
	</div>
</div>

<div class="form-group row">
	<div class="col-sm-12">
		<div class="card">
			<div class="card-header">
				<div class="row">
					<div class="col-lg-8">
						<h5>Cuotas</h5>
					</div>
					<div class="col-lg-4">
						<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showCuotaModal(null);">Agregar</button>
					</div>
				</div>				
			</div>
			<div class="card-block">
				<div class="table-responsive">
					<table id="listCuotas" class="table table-striped table-bordered nowrap" style="cursor:pointer">
						<thead>
							<tr>
								<th>Numero</th>
								<th>Importe</th>
							</tr>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalCuota" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Cuota</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<g:hiddenField name="modalCuotaId" value="" />
			<g:hiddenField name="modalCuotaIndex" value="" />
			<div class="modal-body">
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Numero</label>
					<div class="col-sm-10">
						<input id="modalCuotaNumero" type="text" class="form-control" readonly />
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Importe</label>
					<div class="col-sm-10">
						<input id="modalCuotaImporte" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," placeholder="" value="">
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttonCuotaVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonCuotaEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deleteCuota();">Eliminar</button>
				<button id="buttonCuotaAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addCuota();">Aceptar</button>
				<button id="buttonCuotaModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updateCuota();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">

	$(document).ready(function () {

		$("#buttonSubmit").click(function(){
			//calcularTotales();
			$("#formMoratoria").submit();
		})

		$("#inicio").dateDropper( {
	        dropWidth: 200,
	        dropPrimaryColor: "#1abc9c", 
	        dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format:"d/m/Y",
			lang: "es"
	    });

		$("#cbServicioMoratoria").select2({
			placeholder: '<g:message code="zifras.cuenta.PlanMoratoria.placeHolder" default="Seleccione un SE"/>',
			formatNoMatches: function() {
				return '<g:message code="default.no.elements" default="No hay elementos"/>';
			},
			formatSearching: function() {
				return '<g:message code="default.searching" default="Buscando..."/>';
			},
			minimumResultsForSearch: 1,
			allowClear: true,
			formatSelection: function(item) {
				return item.text;
			}
		});

		llenarCombo({
			comboId : "cbServicioMoratoria",
			ajaxUrlDiv : 'urlGetServiciosMoratoriaCuenta',
			idDefault : '${planMoratoriaInstance?.servicioEspecialId}',
			atributo : 'id',
			parametros : {
			'cuentaId' : $("#cuentaId").val()
		}
		});


		var tablaCuotas
		tablaCuotas = $('#listCuotas').DataTable({
		//bAutoWidth: false,
		//bSortCellsTop: true,
		//BProcessing: true,
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No tiene cuotas')}</a>",
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
		//iDisplayLength: 100,
		//scrollX: true,
		aaSorting: [
			[0, 'asc']
		],
		aoColumnDefs: [{
						"aTargets": [0],
						"mData": "numero"
					},{
						"aTargets": [1],
						"mData": "importe"
					}],
		sPaginationType: 'simple',
		//sDom: "<'row-fluid' <'widget-header' <'span12'<'table-tool-wrapper'><'table-tool-container'>> > > rt <ip>",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showCuota(aData.cuotaId, $(listCuotas).dataTable().fnGetPosition(nRow), aData.numero, aData.importe)
			});
		}
	});
	/*	if($("#id").val()!="")
			getCuotas($("#id").val());*/
	});

	function getCuotas(planMoratoriaId){
		$.ajax({
			url : $('#urlGetCuotas').text(),
			data : {
				'planMoratoriaId' : planMoratoriaId
			},
			success : function(data) {
				for(key in data){
					$('#listCuotas').dataTable().fnAddData(data[key], false);
				}
				$('#listCuotas').dataTable().fnDraw();
				
				$('#cuotas').val(JSON.stringify($('#listLocales').dataTable().fnGetData()));
			},
			error : function() {
			}
		});
	}

	function indiceSiguiente(){
		var tablaCuotas = $("#listCuotas").DataTable()
		var indice = (tablaCuotas.data().count()) + 1
		return indice
	}

	function showCuotaModal(cuotaId, numero, importe){
		//Carga de datos de la fila
		$('#modalCuotaId').val(cuotaId);
		if(cuotaId==null){
			$('#modalCuotaNumero').val(indiceSiguiente());
			$("#modalCuotaImporte").val('')

			$("#buttonCuotaAgregar").show();
			$("#buttonCuotaEliminar").hide();
			$("#buttonCuotaModificar").hide();
		}else{
			$('#modalCuotaNumero').val(numero);	
			$('#modalCuotaImporte').val(importe)

			$("#buttonCuotaAgregar").hide();
			$("#buttonCuotaEliminar").show();
			$("#buttonCuotaModificar").show();
		}
		//verificarParienteModal();
		$('#modalCuota').modal('show');
	}

	function addCuota(){
		var cuotaId = 0;
		var numero = indiceSiguiente();
		var importe = $("#modalCuotaImporte").val();
		
		$('#listCuotas').dataTable().fnAddData({
			numero: numero, 
			importe: importe,
		});
		$('#cuotas').val(JSON.stringify($('#listCuotas').dataTable().fnGetData()));
		$('#cantidadCuotas').val(indiceSiguiente() - 1)
		$('#modalCuota').modal('hide');
	}


	function updateCuota(){
		var cuotaId = $('#modalCuotaId').val();
		var index2 = parseInt($('#modalCuotaIndex').val());
		var numero = $('#modalCuotaNumero').val();
		var importe = $('#modalCuotaImporte').val();
		
		$('#listCuotas').dataTable().fnUpdate({
			parienteId: parienteId, 
			tipoId: tipoId,
			tipoNombre: tipoNombre,
		},index2);
		$('#parientes').val(JSON.stringify($('#listParientes').dataTable().fnGetData()));
		
		$('#modalCuota').modal('hide');
	}

	function addJquery(){
		var numeroCuota = $('ul#listCuotas li').length

		$("#listCuotas").append('<li><b>'+numeroCuota+'</b>&nbsp<input placeholder="$"></li>');
	}
	function removeItem(){
	  	$('#listCuotas li:last-child').remove();
	  	if(indiceSiguiente() == 1)
	  		$("#buttonRemove").hide();
	}

	function calcularTotales(){
		var lista = document.getElementById('listCuotas');
		var items = lista.getElementsByTagName('li');
		var cantidadCuotas = 0;
		var arr = []
		console.log(items);

	     for (var i = 1; i < items.length; i++) {
	         console.log(items[i].childNodes[0].childNodes[1].childNodes[0].value);
	         cantidadCuotas++;
	         arr.push(items[i].childNodes[0].childNodes[1].childNodes[0].value);
	     }

	    /* $('#listCuotas').each(function(){// id of ul
			  var li = $(this).find('li')//get each li in ul
			console.log(li.text())//get text of each li
			})
		*/
	     console.log("cant cuotas:"+cantidadCuotas);
	     console.log("importes: "+arr)
	     $("#cantidadCuotas").val(cantidadCuotas);
	     $("#cuotas").val(arr);
	     console.log($("#cantidadCuotas").val());
	     console.log($("#cuotas").val());
	}

</script>