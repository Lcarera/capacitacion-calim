<%@ page import="com.zifras.liquidacion.LiquidacionIva" %>

<g:hiddenField name="liquidacionIvaId" value="${liquidacionIvaInstance?.liquidacionIvaId}" />
<g:hiddenField name="id" value="${liquidacionIvaInstance?.liquidacionIvaId}" />
<g:hiddenField name="version" value="${liquidacionIvaInstance?.version}" />
<g:hiddenField name="pisarDatos" value="${liquidacionIvaInstance?.pisarDatos}" />
<g:hiddenField name="facturasVentaImportadas" value="${liquidacionIvaInstance?.facturasVentaImportadas}" />
<g:hiddenField name="facturasCompraImportadas" value="${liquidacionIvaInstance?.facturasCompraImportadas}" />

<div style="display: none;">
	<div id="urlGetEstados">
		<g:createLink controller="estado" action="ajaxGetLiquidacionIvaEstados" />
	</div>
	<div id="urlGetCuentas">
		<g:createLink controller="cuenta" action="ajaxGetCuentasNombresSQL" />
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Mes</label>
	<div class="col-sm-4">
		<input id="mes" name="mes" class="form-control" type="text" data-format="m" placeholder="Seleccione un mes" value="${liquidacionIvaInstance?.mes}" readonly=""/>
	</div>
	<label class="col-sm-2 col-form-label">Año</label>
	<div class="col-sm-4">
		<input id="ano" name="ano" class="form-control" type="text" data-format="Y" placeholder="Seleccione un año" data-min-year="2010" value="${liquidacionIvaInstance?.ano}" readonly=""/>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Cuenta</label>
	<div class="col-sm-10">
		<select id="cbCuenta" name="cuentaId" class="form-control"></select>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Estado</label>
	<div class="col-sm-4">
		<select id="cbEstado" name="estadoId" class="form-control"></select>
	</div>
	<label class="col-sm-2 col-form-label">Vencimiento</label>
	<div class="col-sm-4">
		<input id="fechaVencimiento" name="fechaVencimiento" class="form-control" type="text" data-format="d/m/Y" placeholder="Seleccione un día" value="${liquidacionIvaInstance?.fechaVencimiento?.toString('dd/MM/yyyy')}"/>
	</div>
</div>

<div class="form-group row">
	<label class="col-sm-2 col-form-label">Saldo DDJJ</label>
	<div class="col-sm-10">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="saldoDdjj" name="saldoDdjj" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'saldoDdjj', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.saldoDdjj}">
		</div>
	</div>
</div>
<h4 class="sub-title" style="margin-bottom:0px;border-bottom:0px;">Venta</h4>
<div class="row" style="margin-bottom:20px;text-align:right;">
	<table id="listDebitoFiscal" class="table table-framed compact">
		<thead>
			<tr>
				<th></th>
				<th style="text-align:right;">21%</th>
				<th style="text-align:right;">10,5%</th>
				<th style="text-align:right;">27%</th>
				<th style="text-align:right;">2,5%</th>
				<th style="text-align:right;">5%</th>
				<th style="text-align:right;">No grav</th>
				<th style="text-align:right;">Exento</th>
				<th style="text-align:right;">Total</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>Facturas A/M</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="facturasA21" name="facturasA21" value="${liquidacionIvaInstance?.facturasA21 ?: liquidacionIvaInstance?.facturasA21Sumatoria}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.facturasA21Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="facturasA10" name="facturasA10" value="${liquidacionIvaInstance?.facturasA10 ?: liquidacionIvaInstance?.facturasA10Sumatoria}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.facturasA10Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="facturasA27" name="facturasA27" value="${liquidacionIvaInstance?.facturasA27 ?: liquidacionIvaInstance?.facturasA27Sumatoria}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.facturasA27Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="facturasA2" name="facturasA2" value="${liquidacionIvaInstance?.facturasA2 ?: liquidacionIvaInstance?.facturasA2Sumatoria}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.facturasA2Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="facturasA5" name="facturasA5" value="${liquidacionIvaInstance?.facturasA5 ?: liquidacionIvaInstance?.facturasA5Sumatoria}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.facturasA5Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="noGravadoFacturasA" name="noGravadoFacturasA" value="${liquidacionIvaInstance?.noGravadoFacturasA ?: liquidacionIvaInstance?.noGravadoFacturasASumatoria}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.noGravadoFacturasASumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="exentoFacturasA" name="exentoFacturasA" value="${liquidacionIvaInstance?.exentoFacturasA ?: liquidacionIvaInstance?.exentoFacturasASumatoria}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.exentoFacturasASumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<div class="input-group" style="margin-bottom:0px;">
						<span class="input-group-addon" id="basic-addon1">$</span>
						<input id="facturasA" name="facturasA" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'facturasA', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.facturasA ?: liquidacionIvaInstance?.facturasASumatoria}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.facturasASumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
					</div>
				</td>
			</tr>
			<tr>
				<td>Otras Facturas</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="otrasFacturas21" name="otrasFacturas21" value="${liquidacionIvaInstance?.otrasFacturas21 ?: liquidacionIvaInstance?.otrasFacturas21Sumatoria}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.otrasFacturas21Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="otrasFacturas10" name="otrasFacturas10" value="${liquidacionIvaInstance?.otrasFacturas10 ?: liquidacionIvaInstance?.otrasFacturas10Sumatoria}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.otrasFacturas10Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="otrasFacturas27" name="otrasFacturas27" value="${liquidacionIvaInstance?.otrasFacturas27 ?: liquidacionIvaInstance?.otrasFacturas27Sumatoria}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.otrasFacturas27Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="otrasFacturas2" name="otrasFacturas2" value="${liquidacionIvaInstance?.otrasFacturas2 ?: liquidacionIvaInstance?.otrasFacturas2Sumatoria}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.otrasFacturas2Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="otrasFacturas5" name="otrasFacturas5" value="${liquidacionIvaInstance?.otrasFacturas5 ?: liquidacionIvaInstance?.otrasFacturas5Sumatoria}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.otrasFacturas5Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="noGravadoOtrasFacturas" name="noGravadoOtrasFacturas" value="${liquidacionIvaInstance?.noGravadoOtrasFacturas ?: liquidacionIvaInstance?.noGravadoOtrasFacturasSumatoria}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.noGravadoOtrasFacturasSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="exentoOtrasFacturas" name="exentoOtrasFacturas" value="${liquidacionIvaInstance?.exentoOtrasFacturas ?: liquidacionIvaInstance?.exentoOtrasFacturasSumatoria}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.exentoOtrasFacturasSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<div class="input-group" style="margin-bottom:0px;">
						<span class="input-group-addon" id="basic-addon1">$</span>
						<input id="otrasFacturas" name="otrasFacturas" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'otrasFacturas', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.otrasFacturas ?: liquidacionIvaInstance?.otrasFacturasSumatoria}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.otrasFacturasSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
					</div>
				</td>
			</tr>
			<tr>
				<td>Neto</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoVenta21" name="netoVenta21" value="${liquidacionIvaInstance?.netoVenta21}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoVenta21Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoVenta10" name="netoVenta10" value="${liquidacionIvaInstance?.netoVenta10}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoVenta10Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoVenta27" name="netoVenta27" value="${liquidacionIvaInstance?.netoVenta27}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoVenta27Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoVenta2" name="netoVenta2" value="${liquidacionIvaInstance?.netoVenta2}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoVenta2Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoVenta5" name="netoVenta5" value="${liquidacionIvaInstance?.netoVenta5}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoVenta5Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoNoGravadoVenta" name="netoNoGravadoVenta" value="${liquidacionIvaInstance?.netoNoGravadoVenta}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoNoGravadoVentaSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="exentoVenta" name="exentoVenta" value="${liquidacionIvaInstance?.exentoVenta}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.exentoVentaSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<div class="input-group" style="margin-bottom:0px;">
						<span class="input-group-addon" id="basic-addon1">$</span>
						<input id="netoVenta" name="netoVenta" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'netoVenta', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.netoVenta}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoVentaSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
					</div>
				</td>
			</tr>
			<tr>
				<td>DF</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="debitoFiscal21" name="debitoFiscal21" value="${liquidacionIvaInstance?.debitoFiscal21}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.debitoFiscal21Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="debitoFiscal10" name="debitoFiscal10" value="${liquidacionIvaInstance?.debitoFiscal10}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.debitoFiscal10Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber"  data-a-sep="" data-a-dec="," type="text" id="debitoFiscal27" name="debitoFiscal27" value="${liquidacionIvaInstance?.debitoFiscal27}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.debitoFiscal27Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="debitoFiscal2" name="debitoFiscal2" value="${liquidacionIvaInstance?.debitoFiscal2}"  title="Importado: ${formatNumber(number: liquidacionIvaInstance?.debitoFiscal2Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="debitoFiscal5" name="debitoFiscal5" value="${liquidacionIvaInstance?.debitoFiscal5}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.debitoFiscal5Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
				</td>
				<td>
				</td>
				<td>
					<div class="input-group" style="margin-bottom:0px;">
						<span class="input-group-addon" id="basic-addon1">$</span>
						<input id="debitoFiscal" name="debitoFiscal" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'creditoFiscal', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.debitoFiscal}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.debitoFiscalSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
					</div>
				</td>
			</tr>
			<tr>
				<td>Total</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalVenta21" name="totalVenta21" value="${liquidacionIvaInstance?.totalVenta21}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalVenta21Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalVenta10" name="totalVenta10" value="${liquidacionIvaInstance?.totalVenta10}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalVenta10Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber"  data-a-sep="" data-a-dec="," type="text" id="totalVenta27" name="totalVenta27" value="${liquidacionIvaInstance?.totalVenta27}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalVenta27Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalVenta2" name="totalVenta2" value="${liquidacionIvaInstance?.totalVenta2}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalVenta2Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalVenta5" name="totalVenta5" value="${liquidacionIvaInstance?.totalVenta5}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalVenta5Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalNoGravadoVenta" name="totalNoGravadoVenta" value="${liquidacionIvaInstance?.totalNoGravadoVenta}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalNoGravadoVentaSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalExentoVenta" name="totalExentoVenta" value="${liquidacionIvaInstance?.totalExentoVenta}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalExentoVentaSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<div class="input-group" style="margin-bottom:0px;">
						<span class="input-group-addon" id="basic-addon1">$</span>
						<input id="totalVenta" name="totalVenta" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'totalVenta', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.totalVenta}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalVentaSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
					</div>
				</td>
			</tr>
		</tbody>
	</table>
</div>

<h4 class="sub-title" style="margin-bottom:0px;border-bottom:0px;">Compra</h4>
<div class="row" style="margin-bottom:20px;text-align:right;">
	<table id="listCreditoFiscal" class="table table-framed compact">
		<thead>
			<tr>
				<th></th>
				<th style="text-align:right;">21%</th>
				<th style="text-align:right;">10,5%</th>
				<th style="text-align:right;">27%</th>
				<th style="text-align:right;">2,5%</th>
				<th style="text-align:right;">5%</th>
				<th style="text-align:right;">No grav</th>
				<th style="text-align:right;">Exento</th>
				<th style="text-align:right;">Total</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>Neto</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoCompra21" name="netoCompra21" value="${liquidacionIvaInstance?.netoCompra21}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoCompra21Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoCompra10" name="netoCompra10" value="${liquidacionIvaInstance?.netoCompra10}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoCompra10Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoCompra27" name="netoCompra27" value="${liquidacionIvaInstance?.netoCompra27}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoCompra27Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoCompra2" name="netoCompra2" value="${liquidacionIvaInstance?.netoCompra2}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoCompra2Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoCompra5" name="netoCompra5" value="${liquidacionIvaInstance?.netoCompra5}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoCompra5Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="netoNoGravadoCompra" name="netoNoGravadoCompra" value="${liquidacionIvaInstance?.netoNoGravadoCompra}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoNoGravadoCompraSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="exentoCompra" name="exentoCompra" value="${liquidacionIvaInstance?.exentoCompra}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.exentoCompraSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<div class="input-group" style="margin-bottom:0px;">
						<span class="input-group-addon" id="basic-addon1">$</span>
						<input id="netoCompra" name="netoCompra" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'netoCompra', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.netoCompra}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.netoCompraSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
					</div>
				</td>
			</tr>
			<tr>
				<td>CF</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="creditoFiscal21" name="creditoFiscal21" value="${liquidacionIvaInstance?.creditoFiscal21}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.creditoFiscal21Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="creditoFiscal10" name="creditoFiscal10" value="${liquidacionIvaInstance?.creditoFiscal10}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.creditoFiscal10Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber"  data-a-sep="" data-a-dec="," type="text" id="creditoFiscal27" name="creditoFiscal27" value="${liquidacionIvaInstance?.creditoFiscal27}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.creditoFiscal27Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="creditoFiscal2" name="creditoFiscal2" value="${liquidacionIvaInstance?.creditoFiscal2}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.creditoFiscal2Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="creditoFiscal5" name="creditoFiscal5" value="${liquidacionIvaInstance?.creditoFiscal5}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.creditoFiscal5Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
				</td>
				<td>
				</td>
				<td>
					<div class="input-group" style="margin-bottom:0px;">
						<span class="input-group-addon" id="basic-addon1">$</span>
						<input id="creditoFiscal" name="creditoFiscal" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'creditoFiscal', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.creditoFiscal}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.creditoFiscalSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
					</div>
				</td>
			</tr>
			<tr>
				<td>Total</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalCompra21" name="totalCompra21" value="${liquidacionIvaInstance?.totalCompra21}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalCompra21Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalCompra10" name="totalCompra10" value="${liquidacionIvaInstance?.totalCompra10}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalCompra10Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber"  data-a-sep="" data-a-dec="," type="text" id="totalCompra27" name="totalCompra27" value="${liquidacionIvaInstance?.totalCompra27}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalCompra27Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalCompra2" name="totalCompra2" value="${liquidacionIvaInstance?.totalCompra2}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalCompra2Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalCompra5" name="totalCompra5" value="${liquidacionIvaInstance?.totalCompra5}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalCompra5Sumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalNoGravadoCompra" name="totalNoGravadoCompra" value="${liquidacionIvaInstance?.totalNoGravadoCompra}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalNoGravadoCompraSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<input style="width:80%;text-align:right;" class="form-control autonumber" data-a-sep="" data-a-dec="," type="text" id="totalExentoCompra" name="totalExentoCompra" value="${liquidacionIvaInstance?.totalExentoCompra}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalExentoCompraSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
				</td>
				<td>
					<div class="input-group" style="margin-bottom:0px;">
						<span class="input-group-addon" id="basic-addon1">$</span>
						<input id="totalCompra" name="totalCompra" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'totalCompra', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.totalCompra}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.totalCompraSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
					</div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<h4 class="sub-title">Saldos Técnicos</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">%Deb/Cred</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">%</span>
			<input id="porcentajeDebitoCredito" name="porcentajeDebitoCredito" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'porcentajeDebitoCredito', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.porcentajeDebitoCredito}" readonly>
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Deb-Cred</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="debitoMenosCredito" name="debitoMenosCredito" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'debitoMenosCredito', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.debitoMenosCredito}" readonly>
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">A favor período actual</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="saldoTecnicoAFavor" name="saldoTecnicoAFavor" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'saldoTecnicoAFavor', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.saldoTecnicoAFavor}" readonly>
		</div>
	</div>
	<label class="col-sm-2 col-form-label">A favor período anterior</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="saldoTecnicoAFavorPeriodoAnterior" name="saldoTecnicoAFavorPeriodoAnterior" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'saldoTecnicoAFavorPeriodoAnterior', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.saldoTecnicoAFavorPeriodoAnterior}">
		</div>
	</div>
</div>
<h4 class="sub-title">Saldos de libre disponibilidad</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Retenciones</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="retencion" name="retencion" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'retencion', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.retencion}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.retencionImportadaSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Percepciones</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="percepcion" name="percepcion" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'percepcion', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.percepcion}" title="Importado: ${formatNumber(number: liquidacionIvaInstance?.percepcionImportadaSumatoria, , type:'currency', currencySymbol:'$')}" data-toggle="tooltip" data-placement="top">
		</div>
	</div>
</div>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Período actual</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="saldoLibreDisponibilidad" name="saldoLibreDisponibilidad" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'saldoLibreDisponibilidad', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.saldoLibreDisponibilidad}" readonly>
		</div>
	</div>
	<label class="col-sm-2 col-form-label">Período anterior</label>
	<div class="col-sm-4">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">$</span>
			<input id="saldoLibreDisponibilidadPeriodoAnterior" name="saldoLibreDisponibilidadPeriodoAnterior" type="text" class="form-control autonumber ${hasErrors(bean: liquidacionIvaInstance, field: 'saldoLibreDisponibilidadPeriodoAnterior', 'form-control-danger')}" data-a-sep="" data-a-dec="," value="${liquidacionIvaInstance?.saldoLibreDisponibilidadPeriodoAnterior}">
		</div>
	</div>
</div>

<h4 class="sub-title">Notas</h4>
<div class="form-group row">
	<label class="col-sm-2 col-form-label">Nota</label>
	<div class="col-sm-10">
		<textarea name="nota" class="form-control" rows="3" placeholder="Nota...">${liquidacionIvaInstance?.nota}</textarea>
	</div>
</div>


<script type="text/javascript">
var debitoFiscal;
var debitoFiscal21;
var debitoFiscal10;
var debitoFiscal27;
var debitoFiscal2;
var debitoFiscal5;
var netoVenta;
var netoVenta21;
var netoVenta10;
var netoVenta27;
var netoVenta2;
var netoVenta5;
var netoNoGravadoVenta;
var exentoVenta;
var totalVenta;
var totalVenta21;
var totalVenta10;
var totalVenta27;
var totalVenta2;
var totalVenta5;
var totalNoGravadoVenta;
var totalExentoVenta;

var creditoFiscal;
var creditoFiscal21;
var creditoFiscal10;
var creditoFiscal27;
var creditoFiscal2;
var creditoFiscal5;
var netoCompra;
var netoCompra21;
var netoCompra10;
var netoCompra27;
var netoCompra2;
var netoCompra5;
var netoNoGravadoCompra;
var exentoCompra;
var totalCompra;
var totalCompra21;
var totalCompra10;
var totalCompra27;
var totalCompra2;
var totalCompra5;
var totalNoGravadoCompra;
var totalExentoCompra;

var porcentajeDebitoCredito;
var debitoMenosCredito;

var saldoTecnicoAFavor;
var saldoTecnicoAFavorPeriodoAnterior;

var retencion;
var percepcion;
var saldoLibreDisponibilidad;
var saldoLibreDisponibilidadPeriodoAnterior;

var saldoDdjj;

var tablaCreditoFiscal;
var tablaDebitoFiscal;

$(document).ready(function () {
	$('[data-toggle="tooltip"]').tooltip();
	var actionName = "${actionName}";

	$("#fechaVencimiento").dateDropper( {
		dropWidth: 200,
		dropPrimaryColor: "#1abc9c", 
		dropBorder: "1px solid #1abc9c",
		dropBackgroundColor: "#FFFFFF",
		format: "d/m/Y",
		lang: "es"
	});

	/*** CUENTAS ***/
	$("#cbCuenta").select2({
		placeholder: '<g:message code="zifras.cuenta.Cuenta.placeHolder" default="Seleccione una cuenta"/>',
		formatNoMatches: function() {
			return '<g:message code="default.no.elements" default="No hay elementos"/>';
		},
		formatSearching: function() {
			return '<g:message code="default.searching" default="Buscando..."/>';
		},
		minimumResultsForSearch: 1,
		formatSelection: function(item) {
			return item.text;
		}
	});
	llenarCombo({
		comboId : "cbCuenta",
		ajaxUrlDiv : 'urlGetCuentas',
		idDefault : '${liquidacionIvaInstance?.cuentaId}',
		atributo : 'toString',
		readOnly : (actionName == "edit")
	});

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
		idDefault : '${liquidacionIvaInstance?.estadoId}'
	});

	if($("#mes").val()==''){
		$("#mes").dateDropper( {
			dropWidth: 200,
			dropPrimaryColor: "#1abc9c", 
			dropBorder: "1px solid #1abc9c",
			dropBackgroundColor: "#FFFFFF",
			format: "m",
			lang: "es"
		});
	}

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

	$('#listDebitoFiscal').DataTable({
		"ordering": false,
		"searching": false,
		"paging":false,
		"info": false,
		"lengthChange": false,
		sPaginationType: 'simple'
	});

	$('#listCreditoFiscal').DataTable({
		"ordering": false,
		"searching": false,
		"paging":false,
		"info": false,
		"lengthChange": false,
		sPaginationType: 'simple'
	});

	$("#netoVenta").change(function(){
		const exentoVenta = Math.round(leerFloat('exentoVenta') * 100) / 100;
		const netoNoGravadoVenta = Math.round(leerFloat('netoNoGravadoVenta') * 100) / 100;
		const netoVenta = Math.round(leerFloat('netoVenta') * 100) / 100;
		const netoVenta10 = leerFloat('netoVenta10');
		const netoVenta2 = leerFloat('netoVenta2');
		const netoVenta27 = leerFloat('netoVenta27');
		const netoVenta5 = leerFloat('netoVenta5');

		//Al modificar el netoVenta, sólo modifica el IVA 21%, entonces no puede superar la sumatoria de los netos 10, 27, 2 y 5
		let netoVenta21 = netoVenta -   netoVenta10 - netoVenta27 - netoVenta2 - netoVenta5 - netoNoGravadoVenta - exentoVenta;

		if(netoVenta21<0)
			netoVenta21 = 0;

		$('#netoVenta21').val(netoVenta21.toFixed(2).replace(".", ",")).trigger("change");
	});

	$("#debitoFiscal").change(function(){
		//Al modificar el debitoFiscal, sólo modifica el IVA 21%, entonces no puede superar la sumatoria de los creditos fiscales 10, 27, 2 y 5
		const debitoFiscal10 = leerFloat('debitoFiscal10');
		const debitoFiscal27 = leerFloat('debitoFiscal27');
		const debitoFiscal2 = leerFloat('debitoFiscal2');
		const debitoFiscal5 = leerFloat('debitoFiscal5');
		const debitoFiscal = Math.round(leerFloat('debitoFiscal') * 100) / 100;

		let debitoFiscal21 = debitoFiscal - debitoFiscal10 - debitoFiscal27 - debitoFiscal2 - debitoFiscal5;

		if(debitoFiscal21<0)
			debitoFiscal21 = 0;

		$('#debitoFiscal21').val(debitoFiscal21.toFixed(2).replace(".", ","));
		$('#debitoFiscal21').trigger("change");
	});

	$("#totalVenta").change(function(){
		//Al modificar el creditoFiscal, sólo modifica el IVA 21%, entonces no puede superar la sumatoria de los creditos fiscales 10, 27, 2 y 5
		const totalExentoVenta = Math.round(leerFloat('totalExentoVenta') * 100) / 100;
		const totalNoGravadoVenta = Math.round(leerFloat('totalNoGravadoVenta') * 100) / 100;
		const totalVenta = Math.round(leerFloat('totalVenta') * 100) / 100;
		const totalVenta10 = leerFloat('totalVenta10');
		const totalVenta2 = leerFloat('totalVenta2');
		const totalVenta27 = leerFloat('totalVenta27');
		const totalVenta5 = leerFloat('totalVenta5');

		let totalVenta21 = totalVenta - totalVenta10 - totalVenta27 - totalVenta2 - totalVenta5 - totalNoGravadoVenta - totalExentoVenta;

		if(totalVenta21<0)
			totalVenta21 = 0;

		$('#totalVenta21').val(totalVenta21.toFixed(2).replace(".", ","));
		$('#totalVenta21').trigger("change");
	});

	$("#netoCompra").change(function(){
		//Al modificar el netoCompra, sólo modifica el IVA 21%, entonces no puede superar la sumatoria de los netos 10, 27, 2 y 5
		const exentoCompra = Math.round(leerFloat('exentoCompra') * 100) / 100;
		const netoCompra = Math.round(leerFloat('netoCompra') * 100) / 100;
		const netoCompra10 = leerFloat('netoCompra10');
		const netoCompra2 = leerFloat('netoCompra2');
		const netoCompra27 = leerFloat('netoCompra27');
		const netoCompra5 = leerFloat('netoCompra5');
		const netoNoGravadoCompra = Math.round(leerFloat('netoNoGravadoCompra') * 100) / 100;

		let netoCompra21 = netoCompra -	netoCompra10 - netoCompra27 - netoCompra2 - netoCompra5 - netoNoGravadoCompra - exentoCompra;

		if(netoCompra21<0)
			netoCompra21 = 0;

		$('#netoCompra21').val(netoCompra21.toFixed(2).replace(".", ","));
		$('#netoCompra21').trigger("change");
	});

	$("#creditoFiscal").change(function(){
		//Al modificar el creditoFiscal, sólo modifica el IVA 21%, entonces no puede superar la sumatoria de los creditos fiscales 10, 27, 2 y 5
		const creditoFiscal = Math.round(leerFloat('creditoFiscal') * 100) / 100;
		const creditoFiscal10 = leerFloat('creditoFiscal10');
		const creditoFiscal2 = leerFloat('creditoFiscal2');
		const creditoFiscal27 = leerFloat('creditoFiscal27');
		const creditoFiscal5 = leerFloat('creditoFiscal5');

		let creditoFiscal21 = creditoFiscal - creditoFiscal10 - creditoFiscal27 - creditoFiscal2 - creditoFiscal5;

		if(creditoFiscal21<0)
			creditoFiscal21 = 0;

		$('#creditoFiscal21').val(creditoFiscal21.toFixed(2).replace(".", ","));
		$('#creditoFiscal21').trigger("change");
	});

	$("#totalCompra").change(function(){
		//Al modificar el creditoFiscal, sólo modifica el IVA 21%, entonces no puede superar la sumatoria de los creditos fiscales 10, 27, 2 y 5
		const totalCompra = Math.round(leerFloat('totalCompra') * 100) / 100;
		const totalCompra10 = leerFloat('totalCompra10');
		const totalCompra2 = leerFloat('totalCompra2');
		const totalCompra27 = leerFloat('totalCompra27');
		const totalCompra5 = leerFloat('totalCompra5');
		const totalExentoCompra = leerFloat('totalExentoCompra');
		const totalNoGravadoCompra = leerFloat('totalNoGravadoCompra');

		let totalCompra21 = totalCompra - totalCompra10 - totalCompra27 - totalCompra2 - totalCompra5 - totalNoGravadoCompra - totalExentoCompra;

		if(totalCompra21<0)
			totalCompra21 = 0;

		$('#totalCompra21').val(totalCompra21.toFixed(2).replace(".", ","));
		$('#totalCompra21').trigger("change");
	});

	$("#creditoFiscal21").change(function(){
		calcularCreditoFiscal();
	});

	$("#creditoFiscal27").change(function(){
		calcularCreditoFiscal();
	});

	$("#creditoFiscal10").change(function(){
		calcularCreditoFiscal();
	});

	$("#netoVenta21").change(function(){ cambioElementoNeto($("#netoVenta21"),$("#debitoFiscal21"), $("#totalVenta21"), 0.21, true); });
	$("#netoVenta10").change(function(){ cambioElementoNeto($("#netoVenta10"),$("#debitoFiscal10"), $("#totalVenta10"), 0.105, true); });
	$("#netoVenta27").change(function(){ cambioElementoNeto($("#netoVenta27"),$("#debitoFiscal27"), $("#totalVenta27"), 0.27, true); });
	$("#netoVenta2").change(function(){	cambioElementoNeto($("#netoVenta2"),$("#debitoFiscal2"), $("#totalVenta2"), 0.025, true); });
	$("#netoVenta5").change(function(){	cambioElementoNeto($("#netoVenta5"),$("#debitoFiscal5"), $("#totalVenta5"), 0.05, true); });
	$("#netoNoGravadoVenta").change(function(){	cambioElementoNetoNoGravadoExento($("#netoNoGravadoVenta"), $("#totalNoGravadoVenta"), true); });
	$("#exentoVenta").change(function(){ cambioElementoNetoNoGravadoExento($("#exentoVenta"), $("#totalExentoVenta"), true); });
	$("#debitoFiscal21").change(function(){ cambioElementoDebitoCredito($("#netoVenta21"),$("#debitoFiscal21"), $("#totalVenta21"), 0.21, true);  });
	$("#debitoFiscal10").change(function(){	cambioElementoDebitoCredito($("#netoVenta10"),$("#debitoFiscal10"), $("#totalVenta10"), 0.105, true);	 });
	$("#debitoFiscal27").change(function(){	cambioElementoDebitoCredito($("#netoVenta27"),$("#debitoFiscal27"), $("#totalVenta27"), 0.27, true);  });
	$("#debitoFiscal2").change(function(){ cambioElementoDebitoCredito($("#netoVenta2"),$("#debitoFiscal2"), $("#totalVenta2"), 0.025, true);	 });
	$("#debitoFiscal5").change(function(){ cambioElementoDebitoCredito($("#netoVenta5"),$("#debitoFiscal5"), $("#totalVenta5"), 0.05, true);  });
	$("#totalVenta21").change(function(){ cambioElementoTotal($("#netoVenta21"),$("#debitoFiscal21"), $("#totalVenta21"), 0.21, true);  });
	$("#totalVenta10").change(function(){ cambioElementoTotal($("#netoVenta10"),$("#debitoFiscal10"), $("#totalVenta10"), 0.105, true);  });
	$("#totalVenta27").change(function(){ cambioElementoTotal($("#netoVenta27"),$("#debitoFiscal27"), $("#totalVenta27"), 0.27, true);  });
	$("#totalVenta2").change(function(){ cambioElementoTotal($("#netoVenta2"),$("#debitoFiscal2"), $("#totalVenta2"), 0.025, true);  });
	$("#totalVenta5").change(function(){ cambioElementoTotal($("#netoVenta5"),$("#debitoFiscal5"), $("#totalVenta5"), 0.05, true);  });
	$("#totalNoGravadoVenta").change(function(){ cambioElementoTotalNoGravadoExento($("#netoNoGravadoVenta"), $("#totalNoGravadoVenta"), true); });
	$("#totalExentoVenta").change(function(){ cambioElementoTotalNoGravadoExento($("#exentoVenta"), $("#totalExentoVenta"), true); });

	$("#netoCompra21").change(function(){ cambioElementoNeto($("#netoCompra21"),$("#creditoFiscal21"), $("#totalCompra21"), 0.21); });
	$("#netoCompra10").change(function(){ cambioElementoNeto($("#netoCompra10"),$("#creditoFiscal10"), $("#totalCompra10"), 0.105); });
	$("#netoCompra27").change(function(){ cambioElementoNeto($("#netoCompra27"),$("#creditoFiscal27"), $("#totalCompra27"), 0.27); });
	$("#netoCompra2").change(function(){ cambioElementoNeto($("#netoCompra2"),$("#creditoFiscal2"), $("#totalCompra2"), 0.025); });
	$("#netoCompra5").change(function(){ cambioElementoNeto($("#netoCompra5"),$("#creditoFiscal5"), $("#totalCompra5"), 0.05); });
	$("#netoNoGravadoCompra").change(function(){ cambioElementoNetoNoGravadoExento($("#netoNoGravadoCompra"), $("#totalNoGravadoCompra"), false); });
	$("#exentoCompra").change(function(){ cambioElementoNetoNoGravadoExento($("#exentoCompra"), $("#totalExentoCompra"), false); });
	$("#creditoFiscal21").change(function(){ cambioElementoDebitoCredito($("#netoCompra21"),$("#creditoFiscal21"), $("#totalCompra21"), 0.21); });
	$("#creditoFiscal10").change(function(){ cambioElementoDebitoCredito($("#netoCompra10"),$("#creditoFiscal10"), $("#totalCompra10"), 0.105); });
	$("#creditoFiscal27").change(function(){ cambioElementoDebitoCredito($("#netoCompra27"),$("#creditoFiscal27"), $("#totalCompra27"), 0.27); });
	$("#creditoFiscal2").change(function(){ cambioElementoDebitoCredito($("#netoCompra2"),$("#creditoFiscal2"), $("#totalCompra2"), 0.025); });
	$("#creditoFiscal5").change(function(){ cambioElementoDebitoCredito($("#netoCompra5"),$("#creditoFiscal5"), $("#totalCompra5"), 0.05); });
	$("#totalCompra21").change(function(){ cambioElementoTotal($("#netoCompra21"),$("#creditoFiscal21"), $("#totalCompra21"), 0.21); });
	$("#totalCompra10").change(function(){ cambioElementoTotal($("#netoCompra10"),$("#creditoFiscal10"), $("#totalCompra10"), 0.105); });
	$("#totalCompra27").change(function(){ cambioElementoTotal($("#netoCompra27"),$("#creditoFiscal27"), $("#totalCompra27"), 0.27); });
	$("#totalCompra2").change(function(){ cambioElementoTotal($("#netoCompra2"),$("#creditoFiscal2"), $("#totalCompra2"), 0.025); });
	$("#totalCompra5").change(function(){ cambioElementoTotal($("#netoCompra5"),$("#creditoFiscal5"), $("#totalCompra5"), 0.05); });
	$("#totalNoGravadoCompra").change(function(){ cambioElementoTotalNoGravadoExento($("#netoNoGravadoCompra"), $("#totalNoGravadoCompra"), false); });
	$("#totalExentoCompra").change(function(){ cambioElementoTotalNoGravadoExento($("#exentoCompra"), $("#totalExentoCompra"), false); });

	$("#facturasA21").change(function(){ cambioElementoFacturas($("#facturasA21"),$("#otrasFacturas21"), $("#netoVenta21"),false); });
	$("#facturasA10").change(function(){ cambioElementoFacturas($("#facturasA10"),$("#otrasFacturas10"), $("#netoVenta10"),false); });
	$("#facturasA27").change(function(){ cambioElementoFacturas($("#facturasA27"),$("#otrasFacturas27"), $("#netoVenta27"),false); });
	$("#facturasA2").change(function(){ cambioElementoFacturas($("#facturasA2"),$("#otrasFacturas2"), $("#netoVenta2"),false); });
	$("#facturasA5").change(function(){ cambioElementoFacturas($("#facturasA5"),$("#otrasFacturas5"), $("#netoVenta5"),false); });
	$("#noGravadoFacturasA").change(function(){ cambioElementoFacturas($("#noGravadoFacturasA"),$("#noGravadoOtrasFacturas"), $("#netoNoGravadoVenta"),false); });
	$("#exentoFacturasA").change(function(){ cambioElementoFacturas($("#exentoFacturasA"),$("#exentoOtrasFacturas"), $("#exentoVenta"),false); });
	$("#facturasA").change(function(){ cambioElementoFacturas($("#facturasA"),$("#otrasFacturas"), $("#netoVenta"),false); });

	$("#otrasFacturas21").change(function(){ cambioElementoFacturas($("#facturasA21"),$("#otrasFacturas21"), $("#netoVenta21"),true); });
	$("#otrasFacturas10").change(function(){ cambioElementoFacturas($("#facturasA10"),$("#otrasFacturas10"), $("#netoVenta10"),true); });
	$("#otrasFacturas27").change(function(){ cambioElementoFacturas($("#facturasA27"),$("#otrasFacturas27"), $("#netoVenta27"),true); });
	$("#otrasFacturas2").change(function(){ cambioElementoFacturas($("#facturasA2"),$("#otrasFacturas2"), $("#netoVenta2"),true); });
	$("#otrasFacturas5").change(function(){ cambioElementoFacturas($("#facturasA5"),$("#otrasFacturas5"), $("#netoVenta5"),true); });
	$("#noGravadoOtrasFacturas").change(function(){ cambioElementoFacturas($("#noGravadoFacturasA"),$("#noGravadoOtrasFacturas"), $("#netoNoGravadoVenta"),true); });
	$("#exentoOtrasFacturas").change(function(){ cambioElementoFacturas($("#exentoFacturasA"),$("#exentoOtrasFacturas"), $("#exentoVenta"),true); });
	$("#otrasFacturas").change(function(){ cambioElementoFacturas($("#facturasA"),$("#otrasFacturas"), $("#netoVenta"),true); });

	$("#saldoTecnicoAFavorPeriodoAnterior").change(function(){
		calcularSaldosTecnicos();
	});

	$("#retencion").change(function(){
		calcularSaldosDeLibreDisponibilidad();
	});

	$("#percepcion").change(function(){
		calcularSaldosDeLibreDisponibilidad();
	});

	$("#saldoLibreDisponibilidadPeriodoAnterior").change(function(){
		calcularSaldosDeLibreDisponibilidad();
	});

	$("#saldoDdjj").change(function(){
		saldoDdjj = leerFloat('saldoDdjj')

		debitoFiscal = leerFloat('debitoFiscal')

		saldoTecnicoAFavorPeriodoAnterior = leerFloat('saldoTecnicoAFavorPeriodoAnterior')

		saldoLibreDisponibilidad = leerFloat('saldoLibreDisponibilidad')

		creditoFiscal = debitoFiscal - saldoDdjj - saldoTecnicoAFavorPeriodoAnterior - saldoLibreDisponibilidad;

		if(creditoFiscal<0){
			saldoDdjj = debitoFiscal - saldoTecnicoAFavorPeriodoAnterior - saldoLibreDisponibilidad;
			creditoFiscal = 0;
			$('#saldoDdjj').val(saldoDdjj.toFixed(2).replace(".", ","));
		}

		$('#creditoFiscal').val(creditoFiscal.toFixed(2).replace(".", ","));
		$('#creditoFiscal').change();
	});

	//Lógica de focus al presionar enter
	focusEnters();

	//Como traje los datos, llamo a los onchange
	if ($("#pisarDatos").val() == "true") {
		calcularSaldosTecnicos();
	}
});

function calcularNetoCompra() {
	//Tomo todos los valores de los distintos ivas
	creditoFiscal21 = leerFloat('creditoFiscal21')
	creditoFiscal27 = leerFloat('creditoFiscal27')
	creditoFiscal10 = leerFloat('creditoFiscal10')
	creditoFiscal2 = leerFloat('creditoFiscal2')
	creditoFiscal5 = leerFloat('creditoFiscal5')

	netoCompra = (Math.round((creditoFiscal21 / 0.21) * 100) / 100) + (Math.round((creditoFiscal27 / 0.27) * 100) / 100) + (Math.round((creditoFiscal10 / 0.105) * 100) / 100);
	$('#netoCompra').val(netoCompra.toFixed(2).replace(".", ","));
}

function calcularCreditoFiscal(){
	//Tomo todos los valores de los distintos creditos
	creditoFiscal21 = leerFloat('creditoFiscal21')
	creditoFiscal27 = leerFloat('creditoFiscal27')
	creditoFiscal10 = leerFloat('creditoFiscal10')
	creditoFiscal2 = leerFloat('creditoFiscal2')
	creditoFiscal5 = leerFloat('creditoFiscal5')
	//Los sumo en el creditofiscal final y subo el valor al form
	creditoFiscal= creditoFiscal10+creditoFiscal27+creditoFiscal21+creditoFiscal2+creditoFiscal5;
	$('#creditoFiscal').val(creditoFiscal.toFixed(2).replace(".", ","));

	//Construyo el netoCompra a partir de los creditosFiscales
	netoCompra = (Math.round((creditoFiscal21 / 0.21) * 100) / 100) + (Math.round((creditoFiscal27 / 0.27) * 100) / 100) + (Math.round((creditoFiscal10 / 0.105) * 100) / 100) + (Math.round((creditoFiscal2 / 0.02) * 100) / 100) + (Math.round((creditoFiscal5 / 0.05) * 100) / 100);
	$('#netoCompra').val(netoCompra.toFixed(2).replace(".", ","));
	//Actualizo el totalCompra
	totalCompra = netoCompra + creditoFiscal;
	$('#totalCompra').val(totalCompra.toFixed(2).replace(".", ","));

	calcularSaldosTecnicos();
}

function calcularSaldosTecnicos(){
	if(($('#creditoFiscal').val()!="") && ($('#creditoFiscal').val()!=null) && ($('#debitoFiscal').val()!="") && ($('#debitoFiscal').val()!=null)){
		creditoFiscal = leerFloat('creditoFiscal');
		debitoFiscal = leerFloat('debitoFiscal');

		debitoMenosCredito = Math.round((debitoFiscal - creditoFiscal) * 100) / 100 ;
		if(creditoFiscal!=0){
			porcentajeDebitoCredito = ((debitoFiscal / creditoFiscal) - 1) * 100;
		}else{
			porcentajeDebitoCredito = 0;
		}

		$('#debitoMenosCredito').val(debitoMenosCredito.toFixed(2).replace(".", ","));
		$('#porcentajeDebitoCredito').val(porcentajeDebitoCredito.toFixed(2).replace(".", ","));

		saldoTecnicoAFavorPeriodoAnterior = leerFloat('saldoTecnicoAFavorPeriodoAnterior')

		if((saldoTecnicoAFavorPeriodoAnterior + creditoFiscal) > debitoFiscal){
			saldoTecnicoAFavor = Math.round((saldoTecnicoAFavorPeriodoAnterior + creditoFiscal - debitoFiscal) * 100) / 100 ;
			$('#saldoTecnicoAFavor').val(saldoTecnicoAFavor.toFixed(2).replace(".", ","));
		}else{
			$('#saldoTecnicoAFavor').val("0,00");
		}
	}else{
		$('#debitoMenosCredito').val("");
		$('#porcentajeDebitoCredito').val("");
		$('#saldoTecnicoAFavor').val("");
	}

	calcularSaldosDeLibreDisponibilidad();
}

function calcularSaldosDeLibreDisponibilidad(){
	retencion = leerFloat('retencion')

	percepcion = leerFloat('percepcion')

	saldoLibreDisponibilidadPeriodoAnterior = leerFloat('saldoLibreDisponibilidadPeriodoAnterior')

	saldoLibreDisponibilidad = retencion + percepcion + saldoLibreDisponibilidadPeriodoAnterior;

	//Se debe calcular si (Debito - Credito - SaldoAFavorDePeriodoAnterior) aún es positivo hay que comenzar
	//a consumir el saldo técnico
	if(($('#creditoFiscal').val()!="") && ($('#creditoFiscal').val()!=null) && ($('#debitoFiscal').val()!="") && ($('#debitoFiscal').val()!=null)){
		creditoFiscal = leerFloat('creditoFiscal');
		debitoFiscal = leerFloat('debitoFiscal');

		debitoMenosCredito = Math.round((debitoFiscal - creditoFiscal) * 100) / 100 ;

		if(($('#saldoTecnicoAFavorPeriodoAnterior').val()!="") && ($('#saldoTecnicoAFavorPeriodoAnterior').val()!=null)){
			saldoTecnicoAFavorPeriodoAnterior = leerFloat('saldoTecnicoAFavorPeriodoAnterior');
		}else{
			saldoTecnicoAFavorPeriodoAnterior = 0;
		}

		var resultado = Math.round((debitoMenosCredito - saldoTecnicoAFavorPeriodoAnterior) * 100) / 100 ;

		//Si el resultado es mayor que cero, hay que consumir del saldoLibreDisponibilidad
		if(resultado>0){
			saldoLibreDisponibilidad = Math.round((saldoLibreDisponibilidad - resultado) * 100) / 100 ;

			if(saldoLibreDisponibilidad<0)
				saldoLibreDisponibilidad = 0;
		}
	}

	$('#saldoLibreDisponibilidad').val(saldoLibreDisponibilidad.toFixed(2).replace(".", ","));

	calcularSaldoDdjj();
}

function calcularSaldoDdjj(){
	creditoFiscal = leerFloat('creditoFiscal');
	debitoFiscal = leerFloat('debitoFiscal');
	percepcion = leerFloat('percepcion');
	retencion = leerFloat('retencion');
	saldoLibreDisponibilidadPeriodoAnterior = leerFloat('saldoLibreDisponibilidadPeriodoAnterior');
	saldoTecnicoAFavorPeriodoAnterior = leerFloat('saldoTecnicoAFavorPeriodoAnterior');

	saldoDdjj = Math.round((debitoFiscal - creditoFiscal - saldoTecnicoAFavorPeriodoAnterior - retencion - percepcion - saldoLibreDisponibilidadPeriodoAnterior) * 100) / 100 ;
	if(saldoDdjj<0){
		saldoDdjj = 0;
	}

	$('#saldoDdjj').val(saldoDdjj.toFixed(2).replace(".", ","));
}

function cambioElementoFacturas(elementoFacturasAM, elementoOtrasFacturas, elementoNeto, esOtrasFacturas = false){
	const neto = elementoNeto.val() ? parseFloat(elementoNeto.val().replace(",", ".")) : 0
	const valorFacturasAM = elementoFacturasAM.val() ? parseFloat(elementoFacturasAM.val().replace(",", ".")) : 0
	const valorOtrasFacturas = elementoOtrasFacturas.val() ? parseFloat(elementoOtrasFacturas.val().replace(",", ".")) : 0
	// Actualizo verticalmente:
		let elementoACambiar
		let elementoCambiador
		let valorFinal
		if (esOtrasFacturas){
			elementoCambiador = elementoOtrasFacturas
			elementoACambiar = elementoFacturasAM
			valorFinal = neto - valorOtrasFacturas
		}else{
			elementoCambiador = elementoFacturasAM
			elementoACambiar = elementoOtrasFacturas
			valorFinal = neto - valorFacturasAM
		}
		if (valorFinal < 0){
			valorFinal = 0
			elementoCambiador.val(neto.toFixed(2).replace(".", ","))
		}
		elementoACambiar.val(valorFinal.toFixed(2).replace(".", ","))
	// Actualizo horizontalmente ambas filas:
		const facturasA21 = leerFloat('facturasA21');
		const facturasA10 = leerFloat('facturasA10');
		const facturasA27 = leerFloat('facturasA27');
		const facturasA2 = leerFloat('facturasA2');
		const facturasA5 = leerFloat('facturasA5');
		const noGravadoFacturasA = leerFloat('noGravadoFacturasA');
		const exentoFacturasA = leerFloat('exentoFacturasA');

		const facturasA = (Math.round((facturasA21 + facturasA10 + facturasA27 + facturasA2 + facturasA5 + noGravadoFacturasA + exentoFacturasA) * 100) / 100);
		$('#facturasA').val(facturasA.toFixed(2).replace(".", ","));

		const otrasFacturas21 = leerFloat('otrasFacturas21');
		const otrasFacturas10 = leerFloat('otrasFacturas10');
		const otrasFacturas27 = leerFloat('otrasFacturas27');
		const otrasFacturas2 = leerFloat('otrasFacturas2');
		const otrasFacturas5 = leerFloat('otrasFacturas5');
		const noGravadoOtrasFacturas = leerFloat('noGravadoOtrasFacturas');
		const exentoOtrasFacturas = leerFloat('exentoOtrasFacturas');

		const otrasFacturas = (Math.round((otrasFacturas21 + otrasFacturas10 + otrasFacturas27 + otrasFacturas2 + otrasFacturas5 + noGravadoOtrasFacturas + exentoOtrasFacturas) * 100) / 100);
		$('#otrasFacturas').val(otrasFacturas.toFixed(2).replace(".", ","));
}

function recalcularDistribucionFacturas(){
	$('#facturasA21').trigger('change')
	$('#facturasA10').trigger('change')
	$('#facturasA27').trigger('change')
	$('#facturasA2').trigger('change')
	$('#facturasA5').trigger('change')
	$('#noGravadoFacturasA').trigger('change')
	$('#exentoFacturasA').trigger('change')
}

function cambioElementoNeto(elementoNeto, elementoDebitoCredito, elementoTotal, porcentaje, venta){
	var neto = 0;
	var debitoCredito = 0;
	var total = 0;

	if((elementoNeto.val()!="") && (elementoNeto.val()!=null)){
		neto = parseFloat(elementoNeto.val().replace(",", "."));
		neto = (Math.round( (neto) * 100) / 100);
	}

	debitoCredito = (Math.round( (neto * porcentaje) * 100 ) / 100);
	total = (Math.round( (neto + debitoCredito) * 100) / 100);

	elementoNeto.val(neto.toFixed(2).replace(".", ","));
	elementoDebitoCredito.val(debitoCredito.toFixed(2).replace(".", ","));
	elementoTotal.val(total.toFixed(2).replace(".", ","));

	if(venta)
		sumarElementosVenta();
	else
		sumarElementosCompra();
}

function cambioElementoNetoNoGravadoExento(elementoNeto, elementoTotal, venta){
	var neto = 0;
	var total = 0;

	if((elementoNeto.val()!="") && (elementoNeto.val()!=null)){
		neto = parseFloat(elementoNeto.val().replace(",", "."));
		neto = (Math.round( (neto) * 100) / 100);
	}

	total = neto;

	elementoNeto.val(neto.toFixed(2).replace(".", ","));
	elementoTotal.val(total.toFixed(2).replace(".", ","));

	if(venta)
		sumarElementosVenta();
	else
		sumarElementosCompra();
}

function cambioElementoDebitoCredito(elementoNeto, elementoDebitoCredito, elementoTotal, porcentaje, venta){
	var neto = 0;
	var debitoCredito = 0;
	var total = 0;

	if((elementoDebitoCredito.val()!="") && (elementoDebitoCredito.val()!=null)){
		debitoCredito = parseFloat(elementoDebitoCredito.val().replace(",", "."));
		debitoCredito = (Math.round( (debitoCredito) * 100) / 100);
	}

	if(porcentaje!=0)
		neto = (Math.round( (debitoCredito / porcentaje) * 100 ) / 100);

	total = (Math.round( (neto + debitoCredito) * 100) / 100);

	elementoNeto.val(neto.toFixed(2).replace(".", ","));
	elementoDebitoCredito.val(debitoCredito.toFixed(2).replace(".", ","));
	elementoTotal.val(total.toFixed(2).replace(".", ","));

	if(venta)
		sumarElementosVenta();
	else
		sumarElementosCompra();
}

function cambioElementoTotal(elementoNeto, elementoDebitoCredito, elementoTotal, porcentaje, venta){
	var neto = 0;
	var debitoCredito = 0;
	var total = 0;

	if((elementoTotal.val()!="") && (elementoTotal.val()!=null)){
		total = parseFloat(elementoTotal.val().replace(",", "."));
		total = (Math.round( (total) * 100) / 100);
	}

	neto = (Math.round( (total / (porcentaje + 1) ) * 100 ) / 100);
	debitoCredito = (Math.round( (neto * porcentaje) * 100 ) / 100);

	elementoNeto.val(neto.toFixed(2).replace(".", ","));
	elementoDebitoCredito.val(debitoCredito.toFixed(2).replace(".", ","));
	elementoTotal.val(total.toFixed(2).replace(".", ","));

	if(venta)
		sumarElementosVenta();
	else
		sumarElementosCompra();
}

function cambioElementoTotalNoGravadoExento(elementoNeto, elementoTotal, venta){
	var neto = 0;
	var total = 0;

	if((elementoTotal.val()!="") && (elementoTotal.val()!=null)){
		total = parseFloat(elementoTotal.val().replace(",", "."));
		total = (Math.round( (total) * 100) / 100);
	}

	neto = total;

	elementoNeto.val(neto.toFixed(2).replace(".", ","));
	elementoTotal.val(total.toFixed(2).replace(".", ","));

	if(venta)
		sumarElementosVenta();
	else
		sumarElementosCompra();
}

function sumarElementosVenta(){
	sumarElementoNetoVenta();
	sumarElementoDebitoFiscal();
	sumarElementoTotalVenta();
	recalcularDistribucionFacturas();

	calcularSaldosTecnicos();
}

function sumarElementoNetoVenta(){
	const exentoVenta = leerFloat('exentoVenta');
	const netoNoGravadoVenta = leerFloat('netoNoGravadoVenta');
	const netoVenta10 = leerFloat('netoVenta10');
	const netoVenta2 = leerFloat('netoVenta2');
	const netoVenta21 = leerFloat('netoVenta21');
	const netoVenta27 = leerFloat('netoVenta27');
	const netoVenta5 = leerFloat('netoVenta5');

	let netoVenta = (Math.round( (netoVenta21 + netoVenta10 + netoVenta27 + netoVenta2 + netoVenta5 + netoNoGravadoVenta + exentoVenta) * 100) / 100);

	$('#netoVenta').val(netoVenta.toFixed(2).replace(".", ","));
}

function sumarElementoDebitoFiscal(){
	const debitoFiscal10 = leerFloat('debitoFiscal10');
	const debitoFiscal2 = leerFloat('debitoFiscal2');
	const debitoFiscal21 = leerFloat('debitoFiscal21');
	const debitoFiscal27 = leerFloat('debitoFiscal27');
	const debitoFiscal5 = leerFloat('debitoFiscal5');

	const debitoFiscal = (Math.round( (debitoFiscal21 + debitoFiscal10 + debitoFiscal27 + debitoFiscal2 + debitoFiscal5) * 100) / 100);

	$('#debitoFiscal').val(debitoFiscal.toFixed(2).replace(".", ","));
}

function sumarElementoTotalVenta(){
	const totalExentoVenta = leerFloat('totalExentoVenta');
	const totalNoGravadoVenta = leerFloat('totalNoGravadoVenta');
	const totalVenta10 = leerFloat('totalVenta10');
	const totalVenta2 = leerFloat('totalVenta2');
	const totalVenta21 = leerFloat('totalVenta21');
	const totalVenta27 = leerFloat('totalVenta27');
	const totalVenta5 = leerFloat('totalVenta5');

	const totalVenta = (Math.round( (totalVenta21 + totalVenta10 + totalVenta27 + totalVenta2 + totalVenta5 + totalNoGravadoVenta + totalExentoVenta) * 100) / 100);

	$('#totalVenta').val(totalVenta.toFixed(2).replace(".", ","));
}

function sumarElementosCompra(){
	sumarElementoNetoCompra();
	sumarElementoCreditoFiscal();
	sumarElementoTotalCompra();

	calcularSaldosTecnicos();
}

function sumarElementoNetoCompra(){
	const netoCompra21 = leerFloat('netoCompra21');
	const netoCompra10 = leerFloat('netoCompra10');
	const netoCompra27 = leerFloat('netoCompra27');
	const netoCompra2 = leerFloat('netoCompra2');
	const netoCompra5 = leerFloat('netoCompra5');
	const netoNoGravadoCompra = leerFloat('netoNoGravadoCompra');
	const exentoCompra = leerFloat('exentoCompra');

	const netoCompra = (Math.round( (netoCompra21 + netoCompra10 + netoCompra27 + netoCompra2 + netoCompra5 + netoNoGravadoCompra + exentoCompra) * 100) / 100);

	$('#netoCompra').val(netoCompra.toFixed(2).replace(".", ","));
}

function sumarElementoCreditoFiscal(){
	const creditoFiscal21 = leerFloat('creditoFiscal21');
	const creditoFiscal10 = leerFloat('creditoFiscal10');
	const creditoFiscal27 = leerFloat('creditoFiscal27');
	const creditoFiscal2 = leerFloat('creditoFiscal2');
	const creditoFiscal5 = leerFloat('creditoFiscal5');

	const creditoFiscal = (Math.round( (creditoFiscal21 + creditoFiscal10 + creditoFiscal27 + creditoFiscal2 + creditoFiscal5) * 100) / 100);

	$('#creditoFiscal').val(creditoFiscal.toFixed(2).replace(".", ","));
}

function sumarElementoTotalCompra(){
	const totalCompra21 = leerFloat('totalCompra21');
	const totalCompra10 = leerFloat('totalCompra10');
	const totalCompra27 = leerFloat('totalCompra27');
	const totalCompra2 = leerFloat('totalCompra2');
	const totalCompra5 = leerFloat('totalCompra5');
	const totalNoGravadoCompra = leerFloat('totalNoGravadoCompra');
	const totalExentoCompra = leerFloat('totalExentoCompra');

	const totalCompra = (Math.round( (totalCompra21 + totalCompra10 + totalCompra27 + totalCompra2 + totalCompra5 + totalNoGravadoCompra + totalExentoCompra) * 100) / 100);

	$('#totalCompra').val(totalCompra.toFixed(2).replace(".", ","));
}

function focusEnters(){
	$("#saldoDdjj").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoVenta").focus().select();
		}
	});

	$("#netoVenta").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#debitoFiscal").focus().select();
		}
	});

	$("#debitoFiscal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalVenta").focus().select();
		}
	});

	$("#totalVenta").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoCompra").focus().select();
		}
	});

	$("#netoCompra").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#creditoFiscal").focus().select();
		}
	});

	$("#creditoFiscal").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalCompra").focus().select();
		}
	});

	$("#totalCompra").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#saldoTecnicoAFavorPeriodoAnterior").focus().select();
		}
	});

	$("#saldoTecnicoAFavorPeriodoAnterior").on('keydown', function(event) {
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
			$("#saldoLibreDisponibilidadPeriodoAnterior").focus().select();
		}
	});

	$("#saldoLibreDisponibilidadPeriodoAnterior").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#botonAceptar").focus();
		}
	});

	$("#netoVenta21").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#debitoFiscal21").focus().select();
		}
	});

	$("#debitoFiscal21").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalVenta21").focus().select();
		}
	});

	$("#totalVenta21").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoVenta10").focus().select();
		}
	});

	$("#netoVenta10").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#debitoFiscal10").focus().select();
		}
	});

	$("#debitoFiscal10").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalVenta10").focus().select();
		}
	});

	$("#totalVenta10").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoVenta27").focus().select();
		}
	});

	$("#netoVenta27").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#debitoFiscal27").focus().select();
		}
	});

	$("#debitoFiscal27").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalVenta27").focus().select();
		}
	});

	$("#totalVenta27").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoVenta2").focus().select();
		}
	});

	$("#netoVenta2").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#debitoFiscal2").focus().select();
		}
	});

	$("#debitoFiscal2").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalVenta2").focus().select();
		}
	});

	$("#totalVenta2").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoVenta5").focus().select();
		}
	});

	$("#netoVenta5").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#debitoFiscal5").focus().select();
		}
	});

	$("#debitoFiscal5").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalVenta5").focus().select();
		}
	});

	$("#totalVenta5").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoNoGravadoVenta").focus().select();
		}
	});

	$("#netoNoGravadoVenta").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalNoGravadoVenta").focus().select();
		}
	});

	$("#totalNoGravadoVenta").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#exentoVenta").focus().select();
		}
	});

	$("#exentoVenta").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalExentoVenta").focus().select();
		}
	});

	$("#totalExentoVenta").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoVenta").focus().select();
		}
	});

	$("#netoCompra21").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#creditoFiscal21").focus().select();
		}
	});

	$("#creditoFiscal21").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalCompra21").focus().select();
		}
	});

	$("#totalCompra21").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoCompra10").focus().select();
		}
	});

	$("#netoCompra10").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#creditoFiscal10").focus().select();
		}
	});

	$("#creditoFiscal10").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalCompra10").focus().select();
		}
	});

	$("#totalCompra10").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoCompra27").focus().select();
		}
	});

	$("#netoCompra27").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#creditoFiscal27").focus().select();
		}
	});

	$("#creditoFiscal27").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalCompra27").focus().select();
		}
	});

	$("#totalCompra27").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoCompra2").focus().select();
		}
	});

	$("#netoCompra2").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#creditoFiscal2").focus().select();
		}
	});

	$("#creditoFiscal2").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalCompra2").focus().select();
		}
	});

	$("#totalCompra2").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoCompra5").focus().select();
		}
	});

	$("#netoCompra5").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#creditoFiscal5").focus().select();
		}
	});

	$("#creditoFiscal5").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalCompra5").focus().select();
		}
	});

	$("#totalCompra5").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoNoGravadoCompra").focus().select();
		}
	});

	$("#netoNoGravadoCompra").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalNoGravadoCompra").focus().select();
		}
	});

	$("#totalNoGravadoCompra").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#exentoCompra").focus().select();
		}
	});

	$("#exentoCompra").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#totalExentoCompra").focus().select();
		}
	});

	$("#totalExentoCompra").on('keydown', function(event) {
		if(event.key === "Enter") {
			event.preventDefault();
			$("#netoCompra").focus().select();
		}
	});
}
</script>