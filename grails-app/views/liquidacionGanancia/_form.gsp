<%@ page import="com.zifras.liquidacion.LiquidacionGanancia" %>

<g:hiddenField name="liquidacionGananciaId" value="${liquidacionGananciaInstance?.liquidacionGananciaId}" />
<g:hiddenField name="id" value="${liquidacionGananciaInstance?.liquidacionGananciaId}" />
<g:hiddenField name="version" value="${liquidacionGananciaInstance?.version}" />
<g:hiddenField name="baseConyuge" value="${liquidacionGananciaInstance?.baseConyuge}" />
<g:hiddenField name="baseHijo" value="${liquidacionGananciaInstance?.baseHijo}" />
<g:hiddenField name="cuentaId" value="${liquidacionGananciaInstance?.cuentaId}" />
<g:hiddenField name="cuenta" value="${liquidacionGananciaInstance?.cuenta}" />
<g:hiddenField name="gastosDeducciones"/>
<g:hiddenField name="deduccionesParientes"/>
<g:hiddenField name="gastosDeduccionesBorradas"/>
<g:hiddenField name="patrimonios"/>

<div style="display: none;">
	<div id="urlGetEstados">
		<g:createLink controller="estado" action="ajaxGetLiquidacionGananciaEstados" />
	</div>
	<div id="urlGetCuentas">
		<g:createLink controller="cuenta" action="ajaxGetCuentasNombresSQL" />
	</div>
	<div id="urlGetDeduccionesParientesList">
		<g:createLink controller="liquidacionGanancia" action="ajaxGetDeduccionesParientesList" />
	</div>
	<div id="urlGetGastosDeduccionesList">
		<g:createLink controller="liquidacionGanancia" action="ajaxGetGastosDeduccionesList" />
	</div>
	<div id="urlGetPatrimoniosList">
		<g:createLink controller="liquidacionGanancia" action="ajaxGetPatrimoniosList" />
	</div>
	<div id="urlGetTipoGastoDeduccionGanancias">
		<g:createLink controller="tipoGastoDeduccionGanancia" action="ajaxGetTipoGastoDeduccionGanancias" />
	</div>
	<div id="urlGetTipoGastoDeduccionGanancia">
		<g:createLink controller="tipoGastoDeduccionGanancia" action="ajaxGetTipoGastoDeduccionGanancia" />
	</div>
	<div id="urlGetParientes">
		<g:createLink controller="cuenta" action="ajaxGetParientes" />
	</div>
	<div id="urlGetPariente">
		<g:createLink controller="cuenta" action="ajaxGetPariente" />
	</div>
	<div id="urlGetTipoPatrimonioGanancias">
		<g:createLink controller="tipoPatrimonioGanancia" action="ajaxGetTipoPatrimonioGanancias" />
	</div>
	<div id="urlGetTipoPatrimonioGanancia">
		<g:createLink controller="tipoPatrimonioGanancia" action="ajaxGetTipoPatrimonioGanancia" />
	</div>
	<div id="urlGetRangoImpuestoGananciaList">
		<g:createLink controller="rangoImpuestoGanancia" action="ajaxGetRangoImpuestoGananciaList" />
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Año</label>
	<div class="col-sm-4">
		<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${liquidacionGananciaInstance?.ano}" readonly=""/>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Cuenta</label>
	<div class="col-sm-10">
		${liquidacionGananciaInstance?.cuenta}
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Estado</label>
	<div class="col-sm-10">
		<select id="cbEstado" name="estadoId" class="form-control"></select>
	</div>
</div>
<h4 class="sub-title">Netos</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Ventas</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="netoVenta" name="netoVenta" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.netoVenta, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Compras</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="netoCompra" name="netoCompra" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.netoCompra, groupingUsed:false, type:'number')}" title="Importado: ${formatNumber(number: liquidacionGananciaInstance?.netoCompraSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
		</div>
	</div>
</div>
<h4 class="sub-title">Ingresos</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Totales</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="totalIngresos" name="totalIngresos" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.totalIngresos, groupingUsed:false, type:'number')}">
		</div>
	</div>
</div>
<h4 class="sub-title">Existencias</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Inicial</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="existenciaInicial" name="existenciaInicial" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.existenciaInicial, groupingUsed:false, type:'number')}">
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Final</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="existenciaFinal" name="existenciaFinal" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.existenciaFinal, groupingUsed:false, type:'number')}">
		</div>
	</div>
</div>
<h4 class="sub-title">Gastos y Deducciones</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Ingresos brutos</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="ingresosBrutos" name="ingresosBrutos" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.ingresosBrutos, groupingUsed:false, type:'number')}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Otros gastos y deducciones</label>
	<div class="col-sm-10">
		<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showGastoDeduccion('crear', null, null, null, null, null, null, null, null);">Agregar</button>
		<div class="table-responsive">
			<table id="listGastosDeducciones" class="table table-striped table-bordered nowrap" style="cursor:pointer">
				<thead>
					<tr>
						<th>Tipo</th>
						<th>Valor</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Total de gastos y ded.</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="totalGastosDeducciones" name="totalGastosDeducciones" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'totalGastosDeducciones', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.totalGastosDeducciones, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
</div>
<h4 class="sub-title">Cálculos</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Costo mercadería vendida</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="costoMercaderiaVendida" name="costoMercaderiaVendida" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'costoMercaderiaVendida', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.costoMercaderiaVendida, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Costo total</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="costoTotal" name="costoTotal" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'costoTotal', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.costoTotal, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Renta Imponible</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="rentaImponible" name="rentaImponible" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'rentaImponible', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.rentaImponible, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
</div>
<h4 class="sub-title">Otras deducciones</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Base Ganancia no imp.</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="baseGNI" name="baseGNI" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'baseGNI', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.baseGNI, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Meses</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">n</span>
			<input id="mesesGNI" name="mesesGNI" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'mesesGNI', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionGananciaInstance?.mesesGNI}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Ganancia no imponible</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="gananciaNoImponible" name="gananciaNoImponible" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'gananciaNoImponible', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.gananciaNoImponible, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Base Deducción esp.</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="baseDE" name="baseDE" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'baseDE', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.baseDE, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Meses</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">n</span>
			<input id="mesesDE" name="mesesDE" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'mesesDE', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionGananciaInstance?.mesesDE}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Deducción especial</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="deduccionEspecial" name="deduccionEspecial" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'deduccionEspecial', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.deduccionEspecial, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Deducción Parientes</label>
	<div class="col-sm-10">
		<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showDeduccionPariente('crear', null, null, null, null, null, null, null, null);">Agregar</button>
		<div class="table-responsive">
			<table id="listDeduccionesParientes" class="table table-striped table-bordered nowrap" style="cursor:pointer">
				<thead>
					<tr>
						<th>Tipo</th>
						<th>Nombre</th>
						<th>Apellido</th>
						<th>CUIL</th>
						<th>Fecha</th>
						<th>Base</th>
						<th>Meses</th>
						<th>Valor</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Total deducciones personales</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="subtotalGananciaImponible" name="subtotalGananciaImponible" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'subtotalGananciaImponible', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.subtotalGananciaImponible, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Ganancia Imponible</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="gananciaImponible" name="gananciaImponible" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'gananciaImponible', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.gananciaImponible, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
</div>
<h4 class="sub-title">Impuesto determinado</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Impuesto determinado</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="impuestoDeterminado" name="impuestoDeterminado" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'impuestoDeterminado', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.impuestoDeterminado, groupingUsed:false, type:'number')}">
		</div>
	</div>
</div>
<h4 class="sub-title">Saldos</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Retenciones</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="retencion" name="retencion" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'retencion', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.retencion, groupingUsed:false, type:'number')}">
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Percepciones</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="percepcion" name="percepcion" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'percepcion', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.percepcion, groupingUsed:false, type:'number')}">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Anticipos</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="anticipos" name="anticipos" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'anticipos', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.anticipos, groupingUsed:false, type:'number')}">
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Impuesto Débito/Crédito</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="impuestoDebitoCredito" name="impuestoDebitoCredito" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'impuestoDebitoCredito', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.impuestoDebitoCredito, groupingUsed:false, type:'number')}">
		</div>
	</div>
</div>
<h4 class="sub-title">Patrimonio</h4>
<div class="form-group row">
	<div class="col-sm-12">
		<button type="button" style="float:right;" class="btn btn-primary waves-effect" onclick="showPatrimonio('crear', null, null, null, null, null, null, null);">Agregar</button>
		<div class="table-responsive">
			<table id="listPatrimonios" class="table table-striped table-bordered nowrap" style="cursor:pointer">
				<thead>
					<tr>
						<th>Concepto</th>
						<th>Inicial</th>
						<th>Detalle</th>
						<th>Cierre</th>
						<th>Detalle</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Total Inicial</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="sumatoriaPatrimonioInicial" name="sumatoriaPatrimonioInicial" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'sumatoriaPatrimonioInicial', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.sumatoriaPatrimonioInicial, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Total Cierre</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="sumatoriaPatrimonioFinal" name="sumatoriaPatrimonioFinal" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'sumatoriaPatrimonioFinal', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.sumatoriaPatrimonioFinal, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Renta imponible</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="rentaImponiblePatrimonio" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'rentaImponible', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.rentaImponible, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Consumido</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="consumido" name="consumido" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'consumido', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.consumido, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Inicial+RI = Cierre+Cons.</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="totalPatrimonio" name="totalPatrimonio" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionGananciaInstance, field: 'totalPatrimonio', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${formatNumber(number: liquidacionGananciaInstance?.totalPatrimonio, groupingUsed:false, type:'number')}" readonly>
		</div>
	</div>
</div>
<h4 class="sub-title">Notas</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Nota</label>
	<div class="col-sm-10">
		<textarea name="nota" class="form-control" rows="3" placeholder="Nota...">${liquidacionGananciaInstance?.nota}</textarea>
	</div>
</div>

<div class="modal fade" id="modalGastoDeduccion" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Gasto o deducción</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:hiddenField name="modalGastoDeduccionId" value="" />
				<g:hiddenField name="modalGastoDeduccionIndex" value="" />
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Tipo</label>
					<div class="col-sm-10">
						<select id="modalTipoGastoDeduccionGananciaId" name="modalTipoGastoDeduccionGananciaId" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Valor</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalGastoDeduccionGananciaValor" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttonGastoDeduccionVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonGastoDeduccionEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deleteGastoDeduccion();">Eliminar</button>
				<button id="buttonGastoDeduccionAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addGastoDeduccion();">Aceptar</button>
				<button id="buttonGastoDeduccionModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updateGastoDeduccion();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalDeduccionPariente" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Deducción pariente</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:hiddenField name="modalParienteGananciaId" value="" />
				<g:hiddenField name="modalDeduccionParienteIndex" value="" />
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Pariente</label>
					<div class="col-sm-10">
						<select id="modalDeduccionParienteBaseParienteId" name="modalDeduccionParienteBaseParienteId" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Base</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalDeduccionParienteBase" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Meses</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalDeduccionParienteMeses" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Valor</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalDeduccionParienteValor" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="" readonly>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttoDeduccionParienteVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonDeduccionParienteEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deleteDeduccionPariente();">Eliminar</button>
				<button id="buttonDeduccionParienteAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addDeduccionPariente();">Aceptar</button>
				<button id="buttonDeduccionParienteModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updateDeduccionPariente();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="modalPatrimonio" tabindex="-1" role="dialog">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Patrimonio</h4>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<g:hiddenField name="modalPatrimonioId" value="" />
				<g:hiddenField name="modalPatrimonioIndex" value="" />
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Concepto</label>
					<div class="col-sm-10">
						<select id="modalPatrimonioTipoId" name="modalPatrimonioTipoId" class="form-control"></select>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Inicial</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalPatrimonioInicial" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
					<label class="col-sm-2 col-form-label">Detalle</label>
					<div class="col-sm-10">
						<textarea id="modalPatrimonioDetalleInicial" class="form-control" rows="3" placeholder="Detalle inicial..."></textarea>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">Cierre</label>
					<div class="col-sm-10">
						<div class="input-group">
							<span class="input-group-addon" id="basic-addon1">$</span>
							<input id="modalPatrimonioCierre" type="text" class="form-control autonumber" data-a-sep="" data-a-dec="," value="">
						</div>
					</div>
					<label class="col-sm-2 col-form-label">Detalle</label>
					<div class="col-sm-10">
						<textarea id="modalPatrimonioDetalleCierre" class="form-control" rows="3" placeholder="Detalle cierre..."></textarea>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button id="buttonPatrimonioVolver" type="button" class="btn btn-default waves-effect " data-dismiss="modal">Volver</button>
				<button id="buttonPatrimonioEliminar" type="button" class="btn btn-danger waves-effect waves-light " onclick="deletePatrimonio();">Eliminar</button>
				<button id="buttonPatrimonioAgregar" type="button" class="btn btn-primary waves-effect waves-light " onclick="addPatrimonio();">Aceptar</button>
				<button id="buttonPatrimonioModificar" type="button" class="btn btn-primary waves-effect waves-light " onclick="updatePatrimonio();">Aceptar</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
var netoVenta;
var netoCompra;

var totalIngresos;

var existenciaInicial;
var existenciaFinal;

var ingresosBrutos;
var totalGastosDeducciones;

var costoMercaderiaVendida;
var costoTotal;
var rentaImponible;

var baseGNI;
var mesesGNI;
var gananciaNoImponible;
var baseDE;
var mesesDE;
var deduccionEspecial;
var subtotalGananciaImponible;
var gananciaImponible;
var retencion;
var percepcion;
var anticipos;
var impuestoDebitoCredito;
var impuestoDeterminado;
var impuesto;

var sumatoriaPatrimonioInicial;
var sumatoriaPatrimonioFinal;
var rentaImponiblePatrimonio;
var consumido;
var totalPatrimonio;

var tablaGastosDeducciones;
var tablaDeduccionesParientes;
var tablaPatrimonios;

var parientes = [];
var rangosImpuestosGanancias = [];

var rangoImpuestoGananciaCargado = false;
var gastosDeduccionesCargado = false;
var deduccionesParientesCargado = false;

$(document).ready(function () {
	getParientes();
	
	var actionName = "${actionName}";
	
	tablaGastosDeducciones = $('#listGastosDeducciones').DataTable({
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay gastos y deducciones')}</a>",
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
						"mData": "tipoNombre"
					},{
						"aTargets": [1],
						"mData": "valor",
						"sClass" : "text-right"
					}],
		sPaginationType: 'simple',
		sDom: "rt",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showGastoDeduccion('modificar', $('#listGastosDeducciones').dataTable().fnGetPosition(nRow), aData.gastoDeduccionId, aData.tipoId, aData.valor);
			});
		}
	});
	
	getGastosDeducciones();
	
	tablaDeduccionesParientes = $('#listDeduccionesParientes').DataTable({
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay deducciones por parientes')}</a>",
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
						"mData": "parienteTipoNombre"
					},{
						"aTargets": [1],
						"mData": "parienteNombre"
					},{
						"aTargets": [2],
						"mData": "parienteApellido"
					},{
						"aTargets": [3],
						"mData": "parienteCuil"
					},{
						"aTargets": [4],
						"mData": "parienteFecha",
						"sClass" : "text-right"
					},{
						"aTargets": [5],
						"mData": "base",
						"sClass" : "text-right"
					},{
						"aTargets": [6],
						"mData": "meses",
						"sClass" : "text-right"
					},{
						"aTargets": [7],
						"mData": "valor",
						"sClass" : "text-right"
					}],
		sPaginationType: 'simple',
		sDom: "rt",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showDeduccionPariente('modificar', $('#listDeduccionesParientes').dataTable().fnGetPosition(nRow), aData.parienteGananciaId, aData.parienteId, aData.base, aData.meses, aData.valor);
			});
		}
	});

	getDeduccionesParientes();

	tablaPatrimonios = $('#listPatrimonios').DataTable({
		"ordering": true,
		"searching": false,
		"lengthChange": false,
		oLanguage: {
			sProcessing: "${message(code: 'default.datatable.processing', default: 'Buscando...')}",
			sSearch: "${message(code: 'default.datatable.search', default: 'Buscar')}",
			sLengthMenu: "${message(code: 'default.datatable.lengthMenu', default: 'Mostrar _MENU_ registros')}",
			sZeroRecords: "${message(code: 'zifras.cuenta.Cuenta.local.list.agregar', default: 'No hay patrimonios')}</a>",
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
						"mData": "tipoNombre"
					},{
						"aTargets": [1],
						"mData": "valorInicial",
						"sClass" : "text-right"
					},{
						"aTargets": [2],
						"mData": "detalleInicial"
					},{
						"aTargets": [3],
						"mData": "valorCierre",
						"sClass" : "text-right"
					},{
						"aTargets": [4],
						"mData": "detalleCierre"
					}],
		sPaginationType: 'simple',
		sDom: "rt",
		fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
			// Row click
			$(nRow).unbind('click');
			$(nRow).on('click', function() {
				showPatrimonio('modificar', $('#listPatrimonios').dataTable().fnGetPosition(nRow), aData.patrimonioId, aData.tipoId, aData.valorInicial, aData.detalleInicial, aData.valorCierre, aData.detalleCierre);
			});
		}
	});

	getPatrimonios();
	
	/*** ESTADOS ***/
	$("#cbEstado").select2({
		placeholder: '<g:message code="zifras.Localidad.placeHolder" default="Seleccione un estado"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbEstado",
		ajaxUrlDiv : 'urlGetEstados',
		idDefault : '${liquidacionGananciaInstance?.estadoId}'
	});
	
	/*** Tipo de GastosDeduccionGanancias ***/
	$("#modalTipoGastoDeduccionGananciaId").select2({
		placeholder: '<g:message code="zifras.liquidacion.TipoGastoDeduccionGanancia.placeHolder" default="Seleccione un tipo',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "modalTipoGastoDeduccionGananciaId",
		ajaxUrlDiv : 'urlGetTipoGastoDeduccionGanancias'
	});


	$("#modalTipoGastoDeduccionGananciaId").change(function(){
		$("#buttonGastoDeduccionAgregar").prop('disabled', false);
	});
	
	/*** Tipo de Deduccion Pariente ***/
	$("#modalDeduccionParienteBaseParienteId").select2({
		placeholder: '<g:message code="zifras.liquidacion.TipoGastoDeduccionGanancia.placeHolder" default="Seleccione un pariente',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "modalDeduccionParienteBaseParienteId",
		ajaxUrlDiv : 'urlGetParientes',
		parametros : {
			'id': '${liquidacionGananciaInstance?.cuentaId}'
		},
		atributo :  'toString'
	});
	
	$("#modalDeduccionParienteBaseParienteId").change(function(){
		$("#buttonDeduccionParienteAgregar").prop('disabled', false);
		
		var parienteId = $("#modalDeduccionParienteBaseParienteId").val();
		var parienteTipoId = 0;
		var parienteFecha = "";
		
		parientes.forEach(function(pariente, index) {
			if(pariente.id==parienteId){
				parienteTipoId = pariente.tipoId;
				parienteFecha = pariente.fecha;
			}
		});

		var basePariente;
		if(parienteTipoId==0){
			basePariente = parseFloat($("#baseConyuge").val().replace(",", "."));
		}
		if(parienteTipoId==1){
			basePariente = parseFloat($("#baseHijo").val().replace(",", "."));
		}
		
		$('#modalDeduccionParienteBase').val(basePariente.toFixed(2).replace(".", ","));
			
		var mesPariente = parseInt(parienteFecha.substring(3, 5));
		var anoPariente = parseInt(parienteFecha.substring(6, 10));
		
		var anoLiquidacion = parseInt($("#ano").val());
		
		var meses = 0;
		if(anoPariente==anoLiquidacion){
			meses = 13 - mesPariente;
		}
		if(anoPariente<anoLiquidacion){
			meses = 12;
		}
		
		var valorCalculado = (basePariente / 12) * meses;
		
		$('#modalDeduccionParienteMeses').val(meses);
		$('#modalDeduccionParienteValor').val(valorCalculado.toFixed(2).replace(".", ","));
	});
	
	/*** Tipo de Patrimonio ***/
	$("#modalPatrimonioTipoId").select2({
		placeholder: '<g:message code="zifras.liquidacion.TipoPatrimonioGanancia.placeHolder" default="Seleccione un concepto',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: -1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "modalPatrimonioTipoId",
		ajaxUrlDiv : 'urlGetTipoPatrimonioGanancias'
	});
	
	$("#modalPatrimonioTipoId").change(function(){
		$("#buttonPatrimonioAgregar").prop('disabled', false);
	});
	
	if($("#ano").val()==''){
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
	}
	
	$("#ingresosBrutos").change(function(){
		calcularTotalGastosDeducciones();
	});

	$("#totalIngresos").change(function(){
		calcularCalculos();
	});
	
	$("#netoCompra").change(function(){
		actualizarMercaderiasEnPatrimonios();
	
		calcularCalculos();
	});

	$("#existenciaInicial").change(function(){
		actualizarMercaderiasEnPatrimonios();
	
		calcularCalculos();
	});

	$("#existenciaFinal").change(function(){
		actualizarMercaderiasEnPatrimonios();
		
		calcularCalculos();
	});
	
	$("#modalGastoDeduccionGananciaValor").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			if($("#buttonGastoDeduccionAgregar").is(':visible')===true)
				$("#buttonGastoDeduccionAgregar").focus().select();
			else
				$("#buttonGastoDeduccionModificar").focus().select();
		}
	});
	
	$("#modalDeduccionParienteBase").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#modalDeduccionParienteMeses").focus().select();
		}
	});
	
	$("#modalDeduccionParienteMeses").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			if($("#buttonDeduccionParienteAgregar").is(':visible')===true)
				$("#buttonDeduccionParienteAgregar").focus().select();
			else
				$("#buttonDeduccionParienteModificar").focus().select();
		}
	});
	
	$("#modalPatrimonioInicial").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#modalPatrimonioDetalleInicial").focus().select();
		}
	});
	
	$("#modalPatrimonioDetalleInicial").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#modalPatrimonioCierre").focus().select();
		}
	});
	
	$("#modalPatrimonioCierre").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#modalPatrimonioDetalleCierre").focus().select();
		}
	});
	
	$("#modalPatrimonioDetalleCierre").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			if($("#buttonPatrimonioAgregar").is(':visible')===true)
				$("#buttonPatrimonioAgregar").focus().select();
			else
				$("#buttonPatrimonioModificar").focus().select();
		}
	});
	
	$("#baseGNI").change(function(){
		calcularGananciaImponible();
	});
	
	$("#mesesGNI").change(function(){
		mesesGNI = parseFloat($('#mesesGNI').val().replace(",", "."));
		
		if(mesesGNI>12){
			mesesGNI = 12;
			$('#mesesGNI').val(mesesGNI.toFixed(2).replace(".", ","));
		}
		
		if(mesesGNI<0){
			mesesGNI = 0;
			$('#mesesGNI').val(mesesGNI.toFixed(2).replace(".", ","));
		}
		
		calcularGananciaImponible();
	});
	
	$("#baseDE").change(function(){
		calcularGananciaImponible();
	});
	
	$("#mesesDE").change(function(){
		mesesDE = parseFloat($('#mesesDE').val().replace(",", "."));
		
		if(mesesDE>12){
			mesesDE = 12;
			$('#mesesDE').val(mesesDE.toFixed(2).replace(".", ","));
		}
		
		if(mesesDE<0){
			mesesDE = 0;
			$('#mesesDE').val(mesesDE.toFixed(2).replace(".", ","));
		}
		
		calcularGananciaImponible();
	});
	
	$("#modalDeduccionParienteBase").change(function(){
		var base = 0;
		var meses = 0;
		var valor = 0;
		
		if(($('#modalDeduccionParienteBase').val()!="") && ($('#modalDeduccionParienteBase').val()!=null)){
			base = parseFloat($('#modalDeduccionParienteBase').val().replace(",", "."));
		}
		
		if(($('#modalDeduccionParienteMeses').val()!="") && ($('#modalDeduccionParienteMeses').val()!=null)){
			meses = parseFloat($('#modalDeduccionParienteMeses').val().replace(",", "."));
		}
		
		valor = Math.round(((base / 12) * meses) * 100) / 100;
		
		$('#modalDeduccionParienteValor').val(valor.toFixed(2).replace(".", ","));
	});
	
	$("#modalDeduccionParienteMeses").change(function(){
		var base = 0;
		var meses = 0;
		var valor = 0;
		
		if(($('#modalDeduccionParienteBase').val()!="") && ($('#modalDeduccionParienteBase').val()!=null)){
			base = parseFloat($('#modalDeduccionParienteBase').val().replace(",", "."));
		}
		
		if(($('#modalDeduccionParienteMeses').val()!="") && ($('#modalDeduccionParienteMeses').val()!=null)){
			meses = parseFloat($('#modalDeduccionParienteMeses').val().replace(",", "."));
		}
		
		if(meses>12){
			meses = 12;
			$('#modalDeduccionParienteMeses').val(meses.toFixed(2).replace(".", ","));
		}
		
		valor = Math.round(((base / 12) * meses) * 100) / 100;
		
		$('#modalDeduccionParienteValor').val(valor.toFixed(2).replace(".", ","));
	});
	
	$("#retencion").change(function(){
		calcularImpuesto();
	});
	
	$("#percepcion").change(function(){
		calcularImpuesto();
	});
	
	$("#anticipos").change(function(){
		calcularImpuesto();
	});
	
	$("#impuestoDebitoCredito").change(function(){
		calcularImpuesto();
	});
	
	//Lógica de focus al presionar enter
	$("#impuesto").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalIngresos").focus().select();
		}
	});
	
	$("#totalIngresos").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#existenciaInicial").focus().select();
		}
	});

	$("#existenciaInicial").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#existenciaFinal").focus().select();
		}
	});
	
	$("#existenciaFinal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#ingresosBrutos").focus().select();
		}
	});
	
	$("#ingresosBrutos").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#mesesGNI").focus().select();
		}
	});
	
	$("#mesesGNI").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#mesesDE").focus().select();
		}
	});
	
	$("#mesesDE").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#impuestoDeterminado").focus().select();
		}
	});
	
	$("#impuestoDeterminado").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#retencion").focus().select();
		}
	});
	
	$("#retencion").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#percepcion").focus().select();
		}
	});
	
	$("#percepcion").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#anticipos").focus().select();
		}
	});
	
	$("#anticipos").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#impuestoDebitoCredito").focus().select();
		}
	});
	
	$("#impuestoDebitoCredito").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#botonAceptar").focus().select();
		}
	});
	
	$("#nota").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#botonAceptar").focus();
		}
	});
	
	getRangoImpuestoGanancia();
});

function getRangoImpuestoGanancia(){
	var ano = $('#ano').val();
	
	$.ajax({
		url : $('#urlGetRangoImpuestoGananciaList').text(),
		data : {
			'ano' : ano
		},
		success : function(data) {
			rangoImpuestoGananciaCargado = true;
			rangosImpuestosGanancias = data;
			calcularTotalGastosDeducciones();
		},
		error : function() {
		}
	});
}

function getPatrimonios(){
	var cuentaId = '${liquidacionGananciaInstance?.cuentaId}';
	var ano = $('#ano').val();
	
	$.ajax({
		url : $('#urlGetPatrimoniosList').text(),
		data : {
			'cuentaId' : cuentaId,
			'ano' : ano
		},
		success : function(data) {
			for(key in data){
				$('#listPatrimonios').dataTable().fnAddData(data[key], false);
			}
			$('#listPatrimonios').dataTable().fnDraw();
			
			calcularConsumido();
			$('#patrimonios').val(JSON.stringify($('#listPatrimonios').dataTable().fnGetData()));
		},
		error : function() {
		}
	});
}

function getGastosDeducciones(){
	var cuentaId = '${liquidacionGananciaInstance?.cuentaId}';
	var ano = $('#ano').val();
	
	$.ajax({
		url : $('#urlGetGastosDeduccionesList').text(),
		data : {
			'cuentaId' : cuentaId,
			'ano' : ano
		},
		success : function(data) {
			for(key in data){
				$('#listGastosDeducciones').dataTable().fnAddData(data[key], false);
			}
			$('#listGastosDeducciones').dataTable().fnDraw();
			
			gastosDeduccionesCargado = true;
			calcularTotalGastosDeducciones();
			$('#gastosDeducciones').val(JSON.stringify($('#listGastosDeducciones').dataTable().fnGetData()));
		},
		error : function() {
		}
	});
}

function getDeduccionesParientes(){
	var cuentaId = '${liquidacionGananciaInstance?.cuentaId}';
	var ano = $('#ano').val();
	
	$.ajax({
		url : $('#urlGetDeduccionesParientesList').text(),
		data : {
			'cuentaId' : cuentaId,
			'ano' : ano
		},
		success : function(data) {
			
			for(key in data){
				$('#listDeduccionesParientes').dataTable().fnAddData(data[key], false);
			}
			$('#listDeduccionesParientes').dataTable().fnDraw();
			
			$('#deduccionesParientes').val(JSON.stringify($('#listDeduccionesParientes').dataTable().fnGetData()));
			
			deduccionesParientesCargado = true;
			calcularTotalGastosDeducciones();
			/*if($("#create").val()=="true"){
				calcularGananciaImponible();
			}*/
		},
		error : function() {
		}
	});
}

function getParientes(){
	$.ajax({
		url : $('#urlGetParientes').text(),
		data : {
			'id' : ${liquidacionGananciaInstance?.cuentaId}
		},
		success : function(data) {
			parientes = data;
		},
		error : function() {
		}
	});
}

function showPatrimonio(modalidad, index, patrimonioId, tipoId, valorInicial, detalleInicial, valorCierre, detalleCierre){
	//Carga de datos de la fila
	$('#modalPatrimonioId').val(patrimonioId);
	
	if(modalidad!='modificar'){
		$('#modalPatrimonioIndex').val('');
		
		$("#modalPatrimonioInicial").val('');
		$("#modalPatrimonioDetalleInicial").val('');
		$("#modalPatrimonioCierre").val('');
		$("#modalPatrimonioDetalleCierre").val('');
		
		$("#buttonPatrimonioAgregar").show();
		$("#buttonPatrimonioEliminar").hide();
		$("#buttonPatrimonioModificar").hide();

		if($("#modalPatrimonioTipoId").val()=="")
			$("#buttonPatrimonioAgregar").prop('disabled', true);
		else
			$("#buttonPatrimonioAgregar").prop('disabled', false);
			
		$("#buttonPatrimonioModificar").prop('disabled', true);
	}else{
		$('#modalPatrimonioIndex').val(index);
		$("#modalPatrimonioTipoId").val(tipoId).trigger('change');
		$("#modalPatrimonioInicial").val(valorInicial);
		$("#modalPatrimonioDetalleInicial").val(detalleInicial);
		$("#modalPatrimonioCierre").val(valorCierre);
		$("#modalPatrimonioDetalleCierre").val(detalleCierre);
		
		$("#buttonPatrimonioAgregar").hide();
		$("#buttonPatrimonioEliminar").show();
			
		$("#buttonPatrimonioModificar").show();

		$("#buttonPatrimonioAgregar").prop('disabled', true);
		$("#buttonPatrimonioModificar").prop('disabled', false);
	}
	
	$('#modalPatrimonio').modal('show');
}

function showGastoDeduccion(modalidad, index, gastoDeduccionId, tipoId, valor){
	//Carga de datos de la fila
	$('#modalGastoDeduccionId').val(gastoDeduccionId);
	
	if(modalidad!='modificar'){
		$('#modalGastoDeduccionIndex').val('');
		
		valor = $('#valor').val();
		
		$("#modalGastoDeduccionGananciaValor").val('0,00');
		
		$("#buttonGastoDeduccionAgregar").show();
		$("#buttonGastoDeduccionEliminar").hide();
		$("#buttonGastoDeduccionModificar").hide();

		if($("#modalTipoGastoDeduccionGananciaId").val()=="")
			$("#buttonGastoDeduccionAgregar").prop('disabled', true);
		else
			$("#buttonGastoDeduccionAgregar").prop('disabled', false);
			
		$("#buttonGastoDeduccionModificar").prop('disabled', true);
	}else{
		$('#modalGastoDeduccionIndex').val(index);
		$("#modalTipoGastoDeduccionGananciaId").val(tipoId).trigger('change');
		$("#modalGastoDeduccionGananciaValor").val(valor);
		
		$("#buttonGastoDeduccionAgregar").hide();
		$("#buttonGastoDeduccionEliminar").show();
			
		$("#buttonGastoDeduccionModificar").show();

		$("#buttonGastoDeduccionAgregar").prop('disabled', true);
		$("#buttonGastoDeduccionModificar").prop('disabled', false);
	}
	
	$('#modalGastoDeduccion').modal('show');
}

function showDeduccionPariente(modalidad, index, parienteGananciaId, parienteId, base, meses, valor){
	//Carga de datos de la fila
	$('#modalParienteGananciaId').val(parienteGananciaId);
	
	if(modalidad!='modificar'){
		$('#modalDeduccionParienteIndex').val('');
		
		$("#modalDeduccionParienteBase").val('0,00');
		$("#modalDeduccionParienteMeses").val('12');
		$("#modalDeduccionParienteValor").val('0,00');
		
		$("#buttonDeduccionParienteAgregar").show();
		$("#buttonDeduccionParienteEliminar").hide();
		$("#buttonDeduccionParienteModificar").hide();

		$("#buttonDeduccionParienteAgregar").prop('disabled', true);
		$("#buttonDeduccionParienteModificar").prop('disabled', true);
	}else{
		$('#modalDeduccionParienteIndex').val(index);
		$("#modalDeduccionParienteBaseParienteId").val(parienteId).trigger('change');
		$("#modalDeduccionParienteBase").val(base);
		$("#modalDeduccionParienteMeses").val(meses);
		$("#modalDeduccionParienteValor").val(valor);
		
		$("#buttonDeduccionParienteAgregar").hide();
		$("#buttonDeduccionParienteEliminar").show();
			
		$("#buttonDeduccionParienteModificar").show();

		$("#buttonDeduccionParienteAgregar").prop('disabled', true);
		$("#buttonDeduccionParienteModificar").prop('disabled', false);
	}
	
	$('#modalDeduccionPariente').modal('show');
}

function updatePatrimonio(){
	var patrimonioId = $('#modalPatrimonioId').val();
	var index2 = parseInt($('#modalPatrimonioIndex').val());
	
	
	var valorInicial = $("#modalPatrimonioInicial").val();
	var detalleInicial = $("#modalPatrimonioDetalleInicial").val();
	var valorCierre = $("#modalPatrimonioCierre").val();
	var detalleCierre = $("#modalPatrimonioDetalleCierre").val();
	var patrimonioTipoId = parseInt($("#modalPatrimonioTipoId").val());
	var patrimonioTipoNombre = $("#modalPatrimonioTipoId").select2('data')[0].text;
	
	//El id de Mercaderías es 32419
	if(patrimonioTipoId==32419){
		actualizarExistenciasConPatrimonio(valorInicial, valorCierre);
	}
	
	$('#listPatrimonios').dataTable().fnUpdate({
		id: patrimonioId,
		patrimonioId: patrimonioId,
		tipoId: patrimonioTipoId, 
		tipoNombre: patrimonioTipoNombre,
		valorInicial: valorInicial,
		detalleInicial: detalleInicial,
		valorCierre: valorCierre,
		detalleCierre: detalleCierre
	},index2);
	$('#patrimonios').val(JSON.stringify($('#listPatrimonios').dataTable().fnGetData()));
	
	$('#modalPatrimonio').modal('hide');
	
	calcularTotalGastosDeducciones();
}

function updateGastoDeduccion(){
	var gastoDeducionId = $('#modalGastoDeduccionId').val();
	var index2 = parseInt($('#modalGastoDeduccionIndex').val());
	
	var valor = $("#modalGastoDeduccionGananciaValor").val();
	var gastoDeduccionTipoId = $("#modalTipoGastoDeduccionGananciaId").val();
	var gastoDeduccionTipoNombre = $("#modalTipoGastoDeduccionGananciaId").select2('data')[0].text;
	
	$('#listGastosDeducciones').dataTable().fnUpdate({
		id: gastoDeducionId,
		gastoDeducionId: gastoDeducionId, 
		valor: valor,
		tipoId: gastoDeduccionTipoId,
		tipoNombre: gastoDeduccionTipoNombre
	},index2);
	$('#gastosDeducciones').val(JSON.stringify($('#listGastosDeducciones').dataTable().fnGetData()));
	
	$('#modalGastoDeduccion').modal('hide');
	
	calcularTotalGastosDeducciones();
}

function updateDeduccionPariente(){
	var parienteGananciaId = $('#modalParienteGananciaId').val();
	var index2 = parseInt($('#modalDeduccionParienteIndex').val());
	
	var parienteId = $("#modalDeduccionParienteBaseParienteId").val();
	var base = $("#modalDeduccionParienteBase").val();
	var meses = Math.round(parseFloat($('#modalDeduccionParienteMeses').val().replace(",", ".")));
	var valor = $("#modalDeduccionParienteValor").val();
	
	var parienteTipoId = 0;
	var parienteTipoNombre = "";
	var parienteNombre = "";
	var parienteApellido = "";
	var parienteCuil = "";
	var parienteFecha = "";
	
	parientes.forEach(function(pariente, index) {
		if(pariente.id==parienteId){
			parienteTipoId = pariente.tipoId;
			parienteTipoNombre = pariente.tipoNombre;
			parienteNombre = pariente.nombre;
			parienteApellido = pariente.apellido;
			parienteCuil = pariente.cuil;
			parienteFecha = pariente.fecha;
		}
	});
	
	$('#listDeduccionesParientes').dataTable().fnUpdate({
		id: parienteGananciaId,
		parienteGananciaId: parienteGananciaId,
		parienteId: parienteId,
		parienteTipoId: parienteTipoId,
		parienteTipoNombre: parienteTipoNombre,
		parienteNombre: parienteNombre,
		parienteApellido: parienteApellido,
		parienteCuil: parienteCuil,
		parienteFecha: parienteFecha,
		base: base, 
		meses: meses,
		valor: valor
	},index2);
	$('#deduccionesParientes').val(JSON.stringify($('#listDeduccionesParientes').dataTable().fnGetData()));
	$('#modalDeduccionPariente').modal('hide');
	
	calcularGananciaImponible();
}

function addPatrimonio(){
	var patrimonioId = -1;
	
	var valorInicial = $("#modalPatrimonioInicial").val();
	var detalleInicial = $("#modalPatrimonioDetalleInicial").val();
	var valorCierre = $("#modalPatrimonioCierre").val();
	var detalleCierre = $("#modalPatrimonioDetalleCierre").val();
	var patrimonioTipoId = parseInt($("#modalPatrimonioTipoId").val());
	var patrimonioTipoNombre = $("#modalPatrimonioTipoId").select2('data')[0].text;
	
	//El id de Mercaderías es 32419
	if(patrimonioTipoId==32419)
		actualizarExistenciasConPatrimonio(valorInicial, valorCierre);
		
	$('#listPatrimonios').dataTable().fnAddData({
		id: patrimonioId,
		patrimonioId: patrimonioId,
		tipoId: patrimonioTipoId, 
		tipoNombre: patrimonioTipoNombre,
		valorInicial: valorInicial,
		detalleInicial: detalleInicial,
		valorCierre: valorCierre,
		detalleCierre: detalleCierre
	});
	$('#patrimonios').val(JSON.stringify($('#listPatrimonios').dataTable().fnGetData()));
	$('#modalPatrimonio').modal('hide');
	
	calcularConsumido();
}

function addGastoDeduccion(){
	var gastoDedducionId = -1;
	
	var valor = $("#modalGastoDeduccionGananciaValor").val();
	var gastoDeduccionTipoId = parseInt($("#modalTipoGastoDeduccionGananciaId").val());
	var gastoDeduccionTipoNombre = $("#modalTipoGastoDeduccionGananciaId").select2('data')[0].text;
	
	$('#listGastosDeducciones').dataTable().fnAddData({
		id: gastoDedducionId,
		gastoDeduccionId: gastoDedducionId,
		tipoId: gastoDeduccionTipoId, 
		tipoNombre: gastoDeduccionTipoNombre,
		valor: valor
	});
	$('#gastosDeducciones').val(JSON.stringify($('#listGastosDeducciones').dataTable().fnGetData()));
	$('#modalGastoDeduccion').modal('hide');
	
	calcularTotalGastosDeducciones();
}

function addDeduccionPariente(){
	var parienteGananciaId = '-1';
	
	var parienteId = $("#modalDeduccionParienteBaseParienteId").val();
	var base = $("#modalDeduccionParienteBase").val();
	var meses = $("#modalDeduccionParienteMeses").val();
	var valor = $("#modalDeduccionParienteValor").val();
	
	var parienteTipoId = 0;
	var parienteTipoNombre = "";
	var parienteNombre = "";
	var parienteApellido = "";
	var parienteCuil = "";
	var parienteFecha = "";
	
	parientes.forEach(function(pariente, index) {
		if(pariente.id==parienteId){
			parienteTipoId = pariente.tipoId;
			parienteTipoNombre = pariente.tipoNombre;
			parienteNombre = pariente.nombre;
			parienteApellido = pariente.apellido;
			parienteCuil = pariente.cuil;
			parienteFecha = pariente.fecha;
		}
	});
	
	$('#listDeduccionesParientes').dataTable().fnAddData({
		id: parienteGananciaId,
		parienteGananciaId: parienteGananciaId,
		parienteId: parienteId,
		parienteTipoId: parienteTipoId,
		parienteTipoNombre: parienteTipoNombre,
		parienteNombre: parienteNombre,
		parienteApellido: parienteApellido,
		parienteCuil: parienteCuil,
		parienteFecha: parienteFecha,
		base: base, 
		meses: meses,
		valor: valor
	});
	$('#deduccionesParientes').val(JSON.stringify($('#listDeduccionesParientes').dataTable().fnGetData()));
	$('#modalDeduccionPariente').modal('hide');
	
	calcularGananciaImponible();
}

function deletePatrimonio(){
	var index2 = parseInt($('#modalPatrimonioIndex').val());
	
	/*if($('#modalGastoDeduccionId').val()!=0){
		gastosDeduccionesBorradas.push(JSON.parse(JSON.stringify($('#listGastosDeducciones').dataTable().fnGetData(index2))));
		$('#gastosDeduccionesBorradas').val(JSON.stringify(gastosDeduccionesBorradas));
	}*/
	 
	$('#listPatrimonios').dataTable().fnDeleteRow(index2);
	$('#patrimonios').val(JSON.stringify($('#listPatrimonios').dataTable().fnGetData()));
	$('#modalPatrimonio').modal('hide');
	
	calcularConsumido();
}

function deleteGastoDeduccion(){
	var index2 = parseInt($('#modalGastoDeduccionIndex').val());
	
	/*if($('#modalGastoDeduccionId').val()!=0){
		gastosDeduccionesBorradas.push(JSON.parse(JSON.stringify($('#listGastosDeducciones').dataTable().fnGetData(index2))));
		$('#gastosDeduccionesBorradas').val(JSON.stringify(gastosDeduccionesBorradas));
	}*/
	 
	$('#listGastosDeducciones').dataTable().fnDeleteRow(index2);
	$('#gastosDeducciones').val(JSON.stringify($('#listGastosDeducciones').dataTable().fnGetData()));
	$('#modalGastoDeduccion').modal('hide');
	
	calcularTotalGastosDeducciones();
}

function deleteDeduccionPariente(){
	var index2 = parseInt($('#modalDeduccionParienteIndex').val());
	
	/*if($('#modalParienteGananciaId').val()!=0){
		deduccionesParientesBorradas.push(JSON.parse(JSON.stringify($('#listDeduccionesParientes').dataTable().fnGetData(index2))));
		$('#deduccionesParientesBorradas').val(JSON.stringify(deduccionesParientesBorradas));
	}*/
	 
	$('#listDeduccionesParientes').dataTable().fnDeleteRow(index2);
	$('#deduccionesParientes').val(JSON.stringify($('#listDeduccionesParientes').dataTable().fnGetData()));
	$('#modalDeduccionPariente').modal('hide');
	
	calcularGananciaImponible();
}

function calcularTotalGastosDeducciones(){
	//Sólo calcula si están cargadas las 3 condiciones
	if(rangoImpuestoGananciaCargado&&gastosDeduccionesCargado&&deduccionesParientesCargado){
		if(($('#ingresosBrutos').val()!="") && ($('#ingresosBrutos').val()!=null)){
			ingresosBrutos = parseFloat($('#ingresosBrutos').val().replace(",", "."));
		}else{
			ingresosBrutos = 0;
		}
		
		var rows = tablaGastosDeducciones.rows().data();
		var indexesGastosDeducciones = tablaGastosDeducciones.rows().indexes();
		var indexTable=null;
		
		totalGastosDeducciones = ingresosBrutos;
		
		for(var i=0; i < rows.length; i++) {
			var valor = parseFloat(rows[i].valor.replace(",", "."));
			valor = Math.round(valor * 100) / 100 ;
			
			totalGastosDeducciones += valor;
		}
		
		totalGastosDeducciones = Math.round(totalGastosDeducciones * 100) / 100;
		$('#totalGastosDeducciones').val(totalGastosDeducciones.toFixed(2).replace(".", ","));
		
		calcularCalculos();
	}else{
		console.log("Aún no están cargadas las 3 condiciones para realizar los cálculos");
	}
}

function calcularCalculos(){
	if(($('#existenciaInicial').val()!="") && ($('#existenciaInicial').val()!=null)){
		existenciaInicial = parseFloat($('#existenciaInicial').val().replace(",", "."));
	}else{
		existenciaInicial = 0;
	}
	
	if(($('#netoCompra').val()!="") && ($('#netoCompra').val()!=null)){
		netoCompra = parseFloat($('#netoCompra').val().replace(",", "."));
	}else{
		netoCompra = 0;
	}
	
	if(($('#existenciaFinal').val()!="") && ($('#existenciaFinal').val()!=null)){
		existenciaFinal = parseFloat($('#existenciaFinal').val().replace(",", "."));
	}else{
		existenciaFinal = 0;
	}
	
	if(($('#totalGastosDeducciones').val()!="") && ($('#totalGastosDeducciones').val()!=null)){
		totalGastosDeducciones = parseFloat($('#totalGastosDeducciones').val().replace(",", "."));
	}else{
		totalGastosDeducciones = 0;
	}
	
	if(($('#totalIngresos').val()!="") && ($('#totalIngresos').val()!=null)){
		totalIngresos = parseFloat($('#totalIngresos').val().replace(",", "."));
	}else{
		totalIngresos = 0;
	}
	
	costoMercaderiaVendida = Math.round((existenciaInicial + netoCompra - existenciaFinal) * 100) / 100;
	costoTotal = Math.round((costoMercaderiaVendida + totalGastosDeducciones) * 100) / 100;
	const venta = leerFloat("netoVenta")
	let utilidad
	if (venta > 0)
		utilidad = (costoTotal / venta) * 100
	else
		utilidad = 0
	$('#utilidad').val(utilidad.toFixed(2).replace(".", ","));
	rentaImponible =  Math.round((totalIngresos - costoTotal) * 100) / 100;
	
	
	$('#costoMercaderiaVendida').val(costoMercaderiaVendida.toFixed(2).replace(".", ","));
	$('#costoTotal').val(costoTotal.toFixed(2).replace(".", ","));
	$('#rentaImponible').val(rentaImponible.toFixed(2).replace(".", ","));
	
	calcularGananciaImponible();
	
	calcularConsumido();
}

function calcularGananciaImponible(){
	if(($('#baseGNI').val()!="") && ($('#baseGNI').val()!=null)){
		baseGNI = parseFloat($('#baseGNI').val().replace(",", "."));
	}else{
		baseGNI = 0;
	}
	
	if(($('#mesesGNI').val()!="") && ($('#mesesGNI').val()!=null)){
		mesesGNI = parseFloat($('#mesesGNI').val().replace(",", "."));
	}else{
		mesesGNI = 0;
	}
	
	if(($('#baseDE').val()!="") && ($('#baseDE').val()!=null)){
		baseDE = parseFloat($('#baseDE').val().replace(",", "."));
	}else{
		baseDE = 0;
	}
	
	if(($('#mesesDE').val()!="") && ($('#mesesDE').val()!=null)){
		mesesDE = parseFloat($('#mesesDE').val().replace(",", "."));
	}else{
		mesesDE = 0;
	}
	
	gananciaNoImponible = Math.round( (baseGNI / 12) * mesesGNI * 100) / 100;
	deduccionEspecial = Math.round( (baseDE / 12) * mesesDE * 100) / 100;
	
	$('#gananciaNoImponible').val(gananciaNoImponible.toFixed(2).replace(".", ","));
	$('#deduccionEspecial').val(deduccionEspecial.toFixed(2).replace(".", ","));
	
	var rows = tablaDeduccionesParientes.rows().data();
	var indexesDeduccionesParientes = tablaDeduccionesParientes.rows().indexes();
	var indexTable=null;
	
	subtotalGananciaImponible = gananciaNoImponible + deduccionEspecial;
	
	for(var i=0; i < rows.length; i++) {
		var valor = parseFloat(rows[i].valor.replace(",", "."));
		valor = Math.round(valor * 100) / 100 ;
		
		subtotalGananciaImponible += valor;
	}
	
	subtotalGananciaImponible = Math.round( subtotalGananciaImponible * 100) / 100;
	$('#subtotalGananciaImponible').val(subtotalGananciaImponible.toFixed(2).replace(".", ","));
	
	gananciaImponible = 0;
	if(($('#rentaImponible').val()!="") && ($('#rentaImponible').val()!=null)){
		rentaImponible = parseFloat($('#rentaImponible').val().replace(",", "."));
	}else{
		rentaImponible = 0;
	}	
	gananciaImponible = Math.round( (rentaImponible - subtotalGananciaImponible) * 100 ) / 100;
	
	$('#gananciaImponible').val(gananciaImponible.toFixed(2).replace(".", ","));
	
	calcularImpuestoDeterminado();
}

function calcularImpuestoDeterminado(){
	if(($('#gananciaImponible').val()!="") && ($('#gananciaImponible').val()!=null)){
		gananciaImponible = parseFloat($('#gananciaImponible').val().replace(",", "."));
	}else{
		gananciaImponible = 0;
	}
	
	impuestoDeterminado = 0;
	$('#impuestoDeterminado').val(impuestoDeterminado.toFixed(2).replace(".", ","));
	
	$.each(rangosImpuestosGanancias, function(index, rango){
		var desde = parseFloat(rango['desde'].replace(".", "").replace(",", "."));
		var hasta = null;
		if(rango[hasta]!=null)
			hasta = parseFloat(rango['hasta'].replace(".", "").replace(",", "."));
		var fijo = parseFloat(rango['fijo'].replace(".", "").replace(",", "."));
		var porcentaje = parseFloat(rango['porcentaje'].replace(".", "").replace(",", "."));
		
		if(desde<=gananciaImponible){
			if((gananciaImponible<=hasta)||(hasta==null)){
				impuestoDeterminado = (gananciaImponible * porcentaje / 100) + (fijo - (desde * porcentaje / 100));
				$('#impuestoDeterminado').val(impuestoDeterminado.toFixed(2).replace(".", ","));
			}
		}
	});	
	
	calcularImpuesto();
}

function calcularImpuesto(){
	if(($('#impuestoDeterminado').val()!="") && ($('#impuestoDeterminado').val()!=null)){
		impuestoDeterminado = parseFloat($('#impuestoDeterminado').val().replace(",", "."));
	}else{
		impuestoDeterminado = 0;
	}
	
	if(($('#retencion').val()!="") && ($('#retencion').val()!=null)){
		retencion = parseFloat($('#retencion').val().replace(",", "."));
	}else{
		retencion = 0;
	}
	
	if(($('#percepcion').val()!="") && ($('#percepcion').val()!=null)){
		percepcion = parseFloat($('#percepcion').val().replace(",", "."));
	}else{
		percepcion = 0;
	}
	
	if(($('#anticipos').val()!="") && ($('#anticipos').val()!=null)){
		anticipos = parseFloat($('#anticipos').val().replace(",", "."));
	}else{
		anticipos = 0;
	}
	
	if(($('#impuestoDebitoCredito').val()!="") && ($('#impuestoDebitoCredito').val()!=null)){
		impuestoDebitoCredito = parseFloat($('#impuestoDebitoCredito').val().replace(",", "."));
	}else{
		impuestoDebitoCredito = 0;
	}
	
	impuesto = Math.round((impuestoDeterminado - retencion - percepcion - anticipos - impuestoDebitoCredito) * 100) / 100;
	
	if(impuesto<0){
		impuesto = 0;
	}
	
	$('#impuesto').val(impuesto.toFixed(2).replace(".", ","));
}

function calcularConsumido(){
	if(($('#rentaImponible').val()!="") && ($('#rentaImponible').val()!=null)){
		rentaImponiblePatrimonio = parseFloat($('#rentaImponible').val().replace(",", "."));
	}else{
		rentaImponiblePatrimonio = 0;
	}
	
	var rows = tablaPatrimonios.rows().data();
	var indexesPatrimonios = tablaPatrimonios.rows().indexes();
	var indexTable=null;
	
	sumatoriaPatrimonioInicial = 0;
	sumatoriaPatrimonioFinal = 0;
	
	for(var i=0; i < rows.length; i++) {
		var valorInicial = 0;
		if((rows[i].valorInicial!='')&&(rows[i].valorInicial!=null))
			valorInicial = parseFloat(rows[i].valorInicial.replace(",", "."));
		valorInicial = Math.round(valorInicial * 100) / 100 ;
		
		var valorCierre = 0;
		if((rows[i].valorCierre!='')&&(rows[i].valorCierre!=null))
			valorCierre = parseFloat(rows[i].valorCierre.replace(",", "."));
		valorCierre = Math.round(valorCierre * 100) / 100 ;
		
		sumatoriaPatrimonioInicial += valorInicial;
		sumatoriaPatrimonioFinal += valorCierre;
	}
	
	sumatoriaPatrimonioInicial = Math.round(sumatoriaPatrimonioInicial * 100) / 100;
	sumatoriaPatrimonioFinal = Math.round(sumatoriaPatrimonioFinal * 100) / 100;
	
	totalPatrimonio = Math.round( (sumatoriaPatrimonioInicial + rentaImponiblePatrimonio) * 100) / 100;
	consumido = Math.round( (totalPatrimonio - sumatoriaPatrimonioFinal) * 100) / 100;
	
	$('#sumatoriaPatrimonioInicial').val(sumatoriaPatrimonioInicial.toFixed(2).replace(".", ","));
	$('#sumatoriaPatrimonioFinal').val(sumatoriaPatrimonioFinal.toFixed(2).replace(".", ","));
	$('#rentaImponiblePatrimonio').val(rentaImponiblePatrimonio.toFixed(2).replace(".", ","));
	$('#consumido').val(consumido.toFixed(2).replace(".", ","));
	$('#totalPatrimonio').val(totalPatrimonio.toFixed(2).replace(".", ","));
	
}

function actualizarMercaderiasEnPatrimonios(){
	//Se reemplaza el valor de Mercaderías en la lista de Patrimonio
	if(($('#existenciaInicial').val()!="") && ($('#existenciaInicial').val()!=null)){
		existenciaInicial = $('#existenciaInicial').val();
	}else{
		existenciaInicial = '';
	}
	
	if(($('#existenciaFinal').val()!="") && ($('#existenciaFinal').val()!=null)){
		existenciaFinal = $('#existenciaFinal').val();
	}else{
		existenciaFinal = '';
	}
	
	var rows = tablaPatrimonios.rows().data();
	var indexesPatrimonios = tablaPatrimonios.rows().indexes();
	var indexTable=null;
	
	var patrimonioId;
	var tipoId=32419;
	var tipoNombre="Mercaderías";
	var valorInicial;
	var detalleInicial;
	var valorCierre;
	var detalleCierre;
	var index2=-1;
	
	for(var i=0; i < rows.length; i++) {
		if(rows[i].tipoId==tipoId){
			patrimonioId=rows[i].patrimonioId;
			tipoId=rows[i].tipoId;
			valorInicial=existenciaInicial;
			detalleInicial=rows[i].detalleInicial;
			valorCierre=existenciaFinal;
			detalleCierre=rows[i].detalleCierre;
			index2=indexesPatrimonios[i];
		}
	}
	
	if(index2!=-1){
		$('#listPatrimonios').dataTable().fnUpdate({
			id: patrimonioId,
			patrimonioId: patrimonioId,
			tipoId: tipoId, 
			tipoNombre: tipoNombre,
			valorInicial: valorInicial,
			detalleInicial: detalleInicial,
			valorCierre: valorCierre,
			detalleCierre: detalleCierre
		},index2);
	}
	
	$('#patrimonios').val(JSON.stringify($('#listPatrimonios').dataTable().fnGetData()));
}

function actualizarExistenciasConPatrimonio(inicial, cierre){
	$('#existenciaInicial').val(inicial);
	$('#existenciaFinal').val(cierre);
}
</script>