<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Example 1</title>
    <asset:stylesheet src="facturaVenta.css"/>
  </head>
  <body>
    <header class="clearfix">
      <div id="logo">
        <asset:image src="logo-dark.png"/>
      </div>
      <h1>Factura Nº${factura.numero}</h1>
      <div id="project">
        <div><span>CUIT: </span>${factura.cuenta.cuit}</div>
        <div><span>Razón social:</span>${factura.cuenta.razonSocial}</div>
        <div><span>Condicion IVA: </span>${factura.cuenta.condicionIva.nombre}</div>
        <div><span>Domicilio: </span>${factura.cuenta?.domicilioFiscal?.direccion} ${factura.cuenta?.domicilioFiscal?.localidad} ${factura.cuenta?.domicilioFiscal?.provincia}</div>
        <div><span>Ingresos Brutos: </span>${factura.cuenta?.regimenIibb?.nombre ?: Exento}</div>
      </div>
      <div id="company" class="clearfix">
        <div><span>CUIT: </span>30715803891</div>
        <div><span>Razón social: </span>RAPPI ARG S.A.S</div>
        <div><span>Condicion IVA: </span></div>
        <div><span>Domicilio Comercial: </span>Jorge Newbery 1651</div>
        <div><span>Condicion de venta: </span>Contado</div>
      </div>
    </header>
    <main>
        <br></br>
      <table>
        <thead>
          <tr>
            <th class="service">Servicio</th>
            <th>Cantidad</th>
            <th>U.Medida</th>
            <th>Precio Unitario</th>
            <th>Subtotal</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td class="service">Servicio de delivery</td>
            <td class="desc">1</td>
            <td class="unit">unidades</td>
            <td class="qty">${factura.total}</td>
            <td class="total">${factura.total}</td>
          </tr>
          <tr>
            <td colspan="4" class="grand total">TOTAL:</td>
            <td class="grand total">${factura.total}</td>
          </tr>
        </tbody>
      </table>
        <br></br>
        <hr></hr>
      <header class="clearfix">
        <div id="project">
            <div>Calim | Calculo mis impuestos</div>
            <div>Juramento 1662,<br /> C1428DMV, CABA</div>
            <div>Argentina</div>
            <div><a href="https://app.calim.com.ar">app.calim.com.ar</a></div>
        </div>
        <div id="company">
            <div><b>CAE Nº: </b> ${factura.cae}</div>
            <div><b>Vencimiento CAE: </b> ${factura.vencimientoCae}</div>
            <div style="margin-bottom: 8px">Comprobante Autorizado </div>         
            <div id="logoAfip">
                <asset:image src="logo-afip.png"/>
            </div>
        </div>  
      </header>
    </main>
  </body>
</html>