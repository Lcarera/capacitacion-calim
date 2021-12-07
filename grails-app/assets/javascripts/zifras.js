if (typeof jQuery !== 'undefined') {
	(function($) {
		$('#spinner').ajaxStart(function() {
			$(this).fadeIn();
		}).ajaxStop(function() {
			$(this).fadeOut();
		});
	})(jQuery);
}

function notify(mensaje, from, align, icon, type, animIn, animOut){
	$.growl({
		icon: icon,
		title: ' Mensaje: ',
		message: mensaje,
		url: ''
	},{
		element: 'body',
		type: type,
		allow_dismiss: true,
		placement: {
			from: from,
			align: align
		},
		offset: {
			x: 30,
			y: 30
		},
		spacing: 10,
		z_index: 999999,
		delay: 2500,
		timer: 12000,
		url_target: '_blank',
		mouse_over: false,
		animate: {
			enter: animIn,
			exit: animOut
		},
		icon_type: 'class',
		template: '<div data-growl="container" class="alert" role="alert">' +
		'<button type="button" class="close" data-growl="dismiss">' +
		'<span aria-hidden="true">&times;</span>' +
		'<span class="sr-only">Close</span>' +
		'</button>' +
		'<span data-growl="icon"></span>' +
		'<span data-growl="title"></span>' +
		'<span data-growl="message"></span>' +
		'<a href="#" data-growl="url"></a>' +
		'</div>'
	});
};

$(document).ready(function() {
	if($('#flashMessage').val()!='')
		notify($('#flashMessage').val(), 'top', 'center', 'fa fa-comments', 'success', 'animated fadeIn', 'animated fadeOut');
	
	if($('#flashError').val()!='')
		notify($('#flashError').val(), 'top', 'center', 'fa fa-comments', 'danger', 'animated fadeIn', 'animated fadeOut');
});

function llenarCombo(params){
	var comboId = params.comboId;
	var ajaxUrlDiv = params.hasOwnProperty("ajaxUrlDiv") ? params.ajaxUrlDiv : null;
	var ajaxLink = params.hasOwnProperty("ajaxLink") ? params.ajaxLink : null;
	var idDefault = params.hasOwnProperty("idDefault") ? params.idDefault : null;
	var datosPasar = params.hasOwnProperty("parametros") ? params.parametros : null;
	var atributo = params.hasOwnProperty("atributo") ? params.atributo : "nombre";
	var readOnly = params.hasOwnProperty("readOnly") ? params.readOnly : false;
	var data = params.hasOwnProperty("data") ? params.data : null;

	/*La función llena el combo con todos los options que traiga el ajax.
		Parámetros:
			comboId -> El ID del select2 a llenar. Ejemplo: 'cbProvincia' llenaría el combo $("#cbProvincia").
			ajaxUrlDiv -> Teniendo un div hidden con el texto de la URL, su ID sin el #. Ejemplo: 'urlGetProvincias'.
			ajaxLink -> Sobreescribe al ajaxUrlDiv. Es para pasar directamente el link como string, usando por ejemplo el createlink desde la vista.
			idDefault -> Si se llena, y alguno de los valores del ajax coincide con este, se seleccionará. De lo contrario quedará seleccionado el primero.
			parametros -> el map de la data que hay que pasar al Ajax.
			atributo -> De los objetos que trae el ajax, cuál de ellos queremos mostrar como texto. Por ejemplo, el default es lo mismo que hacer 'item.nombre'.
			readOnly -> Si el combo se debe inicializar en ReadOnly.       

			data -> Un array de los objetos que contendrá el combo. Si esta propiedad se manda, ignoramos todo lo relacionado al ajax. Los objetos deben tener las propiedades nombre e id.
		*/
	var combo = $('#' + comboId)
	combo.children('option').remove();

	if (data != null){
		$.map(data, function(item) {
			var seleccionado = item.id==idDefault
			combo.append(new Option(item.nombre, item.id, seleccionado, seleccionado));
		});

		if(idDefault!=null)
			combo.val(idDefault);
		if (combo.val())
			combo.trigger("change");

		if (readOnly)
			toggleReadOnlyCombo(comboId);
	}
	else{
		var urlDestino = ajaxLink != null ? ajaxLink : $('#' + ajaxUrlDiv).text();
		$.ajax(urlDestino, {
			dataType: "json",
			data:datosPasar
		}).done(function(data) {
			$.map(data, function(item) {
				var seleccionado = item.id==idDefault
				combo.append(new Option(item[atributo], item.id, seleccionado, seleccionado));
			});

			if(idDefault!=null)
				combo.val(idDefault);
			if (combo.val())
				combo.trigger("change");

			if (readOnly)
				toggleReadOnlyCombo(comboId);
		});
	}
}

function toggleReadOnlyCombo(comboId, valorAbsoluto = null){
	var combo = $('#' + comboId);
	var divId = "div" + comboId + "Text";
	var divConLabel = $("#" + divId);
	if(divConLabel.length){ // El div con texto ya existía, así que en lugar de volverlo a crear muestro y oculto respectivamente el combo y el div.
		var texto = (combo.select2('data')[0]!=null) ? combo.select2('data')[0].text : ''
		divConLabel.text(texto);
		if (valorAbsoluto == null){
			combo.next(".select2-container").toggle();
			divConLabel.toggle();
		}else if (valorAbsoluto == true){
			combo.next(".select2-container").hide();
			divConLabel.show();
		}else{
			combo.next(".select2-container").show();
			divConLabel.hide();
		}
	}else if (valorAbsoluto == null || valorAbsoluto == true) // Creo el div con el texto
		setTimeout(function() {
			var texto = (combo.select2('data')[0]!=null) ? combo.select2('data')[0].text : ''
			$("<div/>", {
			  text: texto,
			  id: divId,
			  "class": "texto-select2-readonly",
			  appendTo: combo.parent()
			});
			combo.next(".select2-container").hide(); // Oculto el combo
		}, 200);
}

function isNumberKey(evt){
	var charCode = (evt.which) ? evt.which : evt.keyCode;
	if (charCode > 31 && (charCode < 48 || charCode > 57))
		return false;
	return true;
}

function leerFloat(nombreElemento, defecto = 0) {
	const elemento = $('#' + nombreElemento + '')
	if (! elemento.val())
		return defecto
	else
		return parsearFloat(elemento.val())
}

function parsearFloat(num){
	return parseFloat(num.replace(/\./g, "").replace(",", "."))
}

function leerInt(nombreElemento, defecto = 0) {
	const elemento = $('#' + nombreElemento)
	if (! elemento.val())
		return defecto
	else
		return parseInt($('#' + nombreElemento).val())
}

jQuery.fn.dataTableExt.oSort['numeric-comma-asc'] = function(a, b) {
	const x = (!a || a == "-") ? 0 : parseFloat(a.replace(/\./g, '').replace(',', '.'))
	const y = (!b || b == "-") ? 0 : parseFloat(b.replace(/\./g, '').replace(',', '.'))
	return ((x < y) ? -1 : ((x > y) ? 1 : 0));
};

jQuery.fn.dataTableExt.oSort['numeric-comma-desc'] = function(a, b) {
	const x = (!a || a == "-") ? 0 : parseFloat(a.replace(/\./g, '').replace(',', '.'))
	const y = (!b || b == "-") ? 0 : parseFloat(b.replace(/\./g, '').replace(',', '.'))
	return ((x < y) ? 1 : ((x > y) ? -1 : 0));
};