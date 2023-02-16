<%@ include file="/init.jsp" %>


<portlet:actionURL name="/solicitudPago" var="solicitudPago" />
<portlet:resourceURL id="/solicitudpago/getPolizasAjax" var="solicitudPagoAjaxURL" />
<portlet:resourceURL id="/solicitudPago/detalle" var="detallePagoURL" >
</portlet:resourceURL>

<portlet:resourceURL id="/solicitudPago/detallePagoBono" var="detallePagoBonoURL" >
</portlet:resourceURL>

<portlet:resourceURL id="/solicitudPago/obtieneArchivos" var="obtieneArchivos" >
</portlet:resourceURL>
<portlet:resourceURL id="/solicitudPago/descargarDocumento" var="descargarDocumento" >
</portlet:resourceURL>

<c:set var="permisoComisiones" value="<%= RoleLocalServiceUtil.hasUserRole(user.getUserId(), user.getCompanyId(), \"TMX-COMISIONES\", false) %>"/>
<c:set var="permisoBonos" value="<%= RoleLocalServiceUtil.hasUserRole(user.getUserId(), user.getCompanyId(), \"TMX-BONOS\", false) %>"/>

  <div class="container">
                    <div class="form-wrapper">
                        <form id="search-form" action="<%= solicitudPago %>" class="mb-4" method="post">
                            
                            <div class="row">
								 <div class="col-sm-3">
                                    <div class="md-form form-group">
                                        <select id="agente" name="<portlet:namespace/>agente" class="mdb-select colorful-select dropdown-primary"
		        			        searchable='<liferay-ui:message key="ModuloComisionesPortlet.buscar" />' >
                                       		<c:if test="${fn:length(listaAgente) > 1}">
                                                <option value="0"> Todos </option>
											</c:if>
                                            
   											<c:forEach items="${listaAgente}" var="opc">
												<c:set var = "estatusAnterior" value = ""/>
												<c:if test = "${opc.idPersona == agente}" >
													<c:set var = "estatusAnterior" value = "selected"/>
												</c:if>
												<option value="${opc.idPersona}" ${estatusAnterior }>${opc.nombre} ${opc.appPaterno} ${opc.appMaterno}</option>
											</c:forEach>
                                        </select>
                                        <label for="agente" > <liferay-ui:message key="solitudPago.titulo.agente"/> </label>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="md-form form-group">
                                        <label for="modoCotizacion" class="active"> <liferay-ui:message key="solitudPago.titulo.fechaSolicitud"/> </label>
                                        <div class="row">
                                            <div class="col">
                                                <input placeholder="Desde" val="${ fechaSolDesde }" type="text" id="fechaI" name="<portlet:namespace/>fechaInicio" class="form-control datepicker">
                                            </div>
                                            <div class="col">
                                                <input placeholder="Hasta" val="${ fechaSolFin }" type="text" id="fechaF" name="<portlet:namespace/>fechaFin" class="form-control datepicker">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                               
                                <div class="col-sm-3">
                                   <div class="md-form form-group">
                                        <select name="<portlet:namespace/>status" class="mdb-select">
                                            <option value="0">Todos</option>
   											<c:forEach items="${listaEstatus}" var="opc">
												<c:set var = "estatusAnterior" value = ""/>
												<c:if test = "${opc.idCatalogoDetalle == status}" >
													<c:set var = "estatusAnterior" value = "selected"/>
												</c:if>
												<option value="${opc.idCatalogoDetalle}" ${estatusAnterior }>${opc.valor}</option>
											</c:forEach>
                                        </select>
                                        <label for="agente" > <liferay-ui:message key="solitudPago.titulo.status"/> </label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-12 text-right">
                                    <a class="btn btn-pink" onclick="document.getElementById('search-form').submit();"> 
                                    	<liferay-ui:message key="solitudPago.titulo.buscar"/>
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                    
                    <c:if test = "${not empty listaSolicitud}">

                    <div class="table-wrapper">
						<table class="table data-table table-striped table-bordered" style="width:100%;" id="tablaPolizas">
	                        <thead>
	                            <tr>
									<th> <liferay-ui:message key="solitudPago.tabla.edoCuenta"/> </th>
									<th> <liferay-ui:message key="solitudPago.tabla.fechaSolicitud"/> </th>
	                                <th> <liferay-ui:message key="solitudPago.tabla.tipoSolicitud"/> </th>
	                                <th> <liferay-ui:message key="solitudPago.tabla.estado"/> </th>
	                                <th> <liferay-ui:message key="solitudPago.tabla.comision"/> </th>
	                                <th> <liferay-ui:message key="solitudPago.tabla.iva"/> </th>
	                                <th> <liferay-ui:message key="solitudPago.tabla.retencionIva"/> </th>
	                                <th> <liferay-ui:message key="solitudPago.tabla.retencionIsr"/> </th>
	                                <th> <liferay-ui:message key="solitudPago.tabla.total"/> </th>
	                                <th> <liferay-ui:message key="solitudPago.tabla.primaNeta"/> </th>
	                                <th> <liferay-ui:message key="solitudPago.tabla.bono"/> </th>
	                                <th class="all" data-orderable="false"> <liferay-ui:message key="solitudPago.tabla.detalle"/> </th>
	                                <th class="all" data-orderable="false"> <liferay-ui:message key="solitudPago.tabla.verArchivos"/> </th>
	                            </tr>
	                        </thead>
	                        <tbody>
								<c:forEach items="${listaSolicitud}" var="sol">
								<c:if test="${ ( permisoComisiones && sol.tipoSolicitud == 'COMISIONES') || (permisoBonos && sol.tipoSolicitud == 'BONOS') }">	                        
	                            <tr>
	                                <td > ${sol.edoCuenta} </td>
	                                <td class="fecha" data-order="${sol.fechaSolicitud}"> ${sol.fechaSolicitud} </td>
	                                <td> ${ sol.tipoSolicitud } </td>
	                                <td> ${sol.estado} </td>
	                    	        <td class="number"> $<fmt:formatNumber value = "${sol.comision }" type = "number" minFractionDigits="2" maxFractionDigits="2"/> </td>
	                                <td class="number"> $<fmt:formatNumber value = "${sol.iva}" type = "number" minFractionDigits="2" maxFractionDigits="2"/> </td>
	                                <td class="number"> $<fmt:formatNumber value = "${sol.retIva}" type = "number" minFractionDigits="2" maxFractionDigits="2"/> </td>
	                                <td class="number"> $<fmt:formatNumber value = "${sol.retIsr}" type = "number" minFractionDigits="2" maxFractionDigits="2"/> </td>
	                                <td class="number"> $<fmt:formatNumber value = "${sol.totalPagar}" type = "number" minFractionDigits="2" maxFractionDigits="2"/> </td>
	                                <td class="number"> $<fmt:formatNumber value = "${sol.primaNeta}" type = "number" minFractionDigits="2" maxFractionDigits="2"/> </td>
									<td class="number"> $<fmt:formatNumber value = "${sol.bono}" type = "number" minFractionDigits="2" maxFractionDigits="2"/> </td>
	                                <td>
										<a class="dropdown-item" onclick="verDetallePago('${sol.tipoSolicitud}', '${ sol.edoCuenta }', '${agente }' )" data-toggle="modal" href="#modalPago-${sol.tipoSolicitud}"> <i class="fa fa-search" aria-hidden="true"></i> </a>
	                                </td>
	                                <td>
										<a class="dropdown-item" data-toggle="modal" href="#modal-archives" onclick="verArchivos('${ sol.idCarpeta }')"> <i class="far fa-file-alt mr-2"></i></a>
	                                </td>
	                            </tr>
	                            </c:if>
	                            </c:forEach>
	                        </tbody>
	                    </table>
                	</div>
                	</c:if>
   	</div>
   	
   	
   	
            <!-- Modal Ver Comisiones -->
            <div class="modal" id="modalPago-COMISIONES" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
                <div class="modal-dialog modal-fluid modal-dialog-centered" role="document" style="width:90%">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="">Detalle de Solicitud</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">

							<div class="table-wrapper">
								<table class="table table-striped table-bordered" style="width:100%;" id="detalleSolPagoTable">
									<thead>
									<tr>
										<th> Id  </th>
										<th> Asegurado  </th>
										<th> Poliza  </th>
										<th> Endoso  </th>
										<th> Producto  </th>
										<th> Moneda  </th>
										<th> Prima Neta  </th>
										<th> % Comisión  </th>
										<th> Comisión  </th>
										<th> IVA </th>
										<th> Total Comisión  </th>
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
            <!-- END Modal Ver Comisiones -->   	
   	
            <!-- Modal Ver Pago Bono -->
            <div class="modal" id="modalPago-BONOS" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
                <div class="modal-dialog modal-fluid modal-dialog-centered" role="document" style="width:90%">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="">Detalle de Solicitud</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">

							<div class="table-wrapper">
								<table class="table table-striped table-bordered" style="width:100%;" id="detalleSolPagoTable">
									<thead>
									<tr>
										<th> id Bono  </th>
										<th> Tipo de Bono  </th>
										<th> Linea de Negocio  </th>
										<th> Moneda  </th>
										<th> Prima Pagada  </th>
										<th> % Bono  </th>
										<th> Bono  </th>
										<th> IVA </th>
										<th> Retención Isr  </th>
										<th> Retención IVA  </th>
										<th> Total </th>
										<th> Comentario  </th>
										<th> Estatus  </th>

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
            <!-- END Modal Pago Bono -->   	
   			<!-- Modal Ver archivos -->
			<div class="modal" id="modal-archives" tabindex="-1" role="dialog" aria-labelledby="archivesLabel" aria-hidden="true">
			    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
			        <div class="modal-content">
			            <div class="modal-header">
			                <h5 class="modal-title" id="archivesLabel">Archivos</h5>
			                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			                    <span aria-hidden="true">&times;</span>
			                </button>
			            </div>
			            <a id='dwnldLnk'  style="display:none;"></a> 	
			            <div class="modal-body">
			                <table id="tableArchivos" class="table simple-data-table table-striped table-bordered" style="width:100%;">
			                    <thead>
			                        <tr>
			                            <th data-orderable="false">Archivo</th>
			                            <th data-orderable="false">Tipo</th>
			                            <th data-orderable="false"></th>
			                        </tr>
			                    </thead>
			                    <tbody>
			                        
			                    </tbody>
			                </table>
			            </div>
			        </div>
			    </div>
			</div>
			<!-- END Modal Ver archivos -->
<input type="hidden" id="buscaPolizaAjax" name="buscaPolizaAjax" value="${ solicitudPagoAjaxURL }">
<input type="hidden" id="agenteId" name="agenteId" value="${ agente }">
<script>

$( document ).ready(function() {
    console.log( "ready!" );
    var fechaI;
    var fechaF;
    
    $.extend( $.fn.dataTable.defaults, {
    	order: [[ 1, 'desc' ]]
    });
    
    finInput = $('#fechaF').pickadate({ 
	    format : 'dd/mm/yyyy',
		formatSubmit : 'dd/mm/yyyy'
	});
   
   finPicker =finInput.pickadate('picker');
   
  
  inicioInput = $('#fechaI').pickadate({ 
	    format : 'dd/mm/yyyy',
		formatSubmit : 'dd/mm/yyyy'
	});
 
 inicioPicker =inicioInput.pickadate('picker');

  $(".fecha").each(function() {
		value = $(this).text();
		value = new Date(parseInt(value.replace("/Date(", "").replace(")/",""), 10));
		month = value.getMonth() + 1;
		console.log(month);
		if( month < 9){
			month = "0" + month;
		}
		$(this).text( value.getDate() +"/"+ month +"/"+value.getFullYear() )
	});
  
  
  modalTableComi = $('#modalPago-COMISIONES table').DataTable({
      responsive: true,
      dom: 'Btr',
      columnDefs: [
          {targets: '_all', className: "py-2" }
      ],
      "language": {
          "sProcessing": "Procesando...",
          "sLengthMenu": "Mostrando _MENU_ registros por página",
          "sInfo": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
          "sInfoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
          "sInfoFiltered": "(filtrado de un total de _MAX_ registros)",
          "sSearch": "Buscar:",
          "sLoadingRecords": "Cargando...",
          "oPaginate": {
              "sFirst": "<i class='fa fa-angle-double-left'>first_page</i>",
              "sLast": "<i class='fa fa-angle-double-right'>last_page</i>",
              "sNext": "<i class='fa fa-angle-right' aria-hidden='false'></i>",
              "sPrevious": "<i class='fa fa-angle-left' aria-hidden='false'></i>"
          },
      },
      "lengthMenu": [[5,10,15], [5,10,15]],
      "order": [[ 1, "asc" ]],
    "pageLength": 10,
      searching: false,
      paging: false,
      buttons: [{
    	    extend:    'excelHtml5',
    	    text:      '<a class="btn-floating btn-sm teal waves-effect waves-light py-2 my-0">XLS</a>',
    	    titleAttr: 'Exportar XLS',
    	    className:"btn-unstyled",
    	    exportOptions: {
    	        /*columns: ':not(:last)',*/
    	        format: {
    	          body: function ( data, row, column, node ) {
    	              return data.replace( /[$,%]/g, '' );
    	          }
    	        }

    	    }
    	}]
  });
  

  modalPagoBono = $("#modalPago-BONOS table").DataTable({
      responsive: true,
      dom: 'tr',
      columnDefs: [
          {targets: '_all', className: "py-2" }
      ],
      "language": {
          "sProcessing": "Procesando...",
          "sLengthMenu": "Mostrando _MENU_ registros por página",
          "sInfo": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
          "sInfoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
          "sInfoFiltered": "(filtrado de un total de _MAX_ registros)",
          "sSearch": "Buscar:",
          "sLoadingRecords": "Cargando...",
          "oPaginate": {
              "sFirst": "<i class='fa fa-angle-double-left'>first_page</i>",
              "sLast": "<i class='fa fa-angle-double-right'>last_page</i>",
              "sNext": "<i class='fa fa-angle-right' aria-hidden='false'></i>",
              "sPrevious": "<i class='fa fa-angle-left' aria-hidden='false'></i>"
          },
      },
      "lengthMenu": [[5,10,15], [5,10,15]],
      "order": [[ 1, "asc" ]],
    "pageLength": 10,
      searching: false,
      paging: false,
      "destroy": true
  });  
  
	/*********** PAGINADO DINAMICO **************/
	$('#tablaPolizas').on('draw.dt', function(e) {
		var ultimoPaginador = $(this).siblings().find('li').last().prev();
		if (ultimoPaginador.hasClass('active')){
			generaTablas(
					'#search-form', /* id del formulario a enviar al resources comand */
					$('#buscaPolizaAjax').val(), /* Liga del resources comand */
					'#tablaPolizas', /* tabla que se le van a agregar los registros */
					listaLlavesJson, /* Lista de nombres de atributos a pegar emn la tabla */ 
					'listaPolizas', /* Nombre de la propiedad del json donde estan las listas de objetos a pegar a la tabla */
					btnHtml /* btn */
					);
		}
	});


	var listaLlavesJson =  [
		{
			"nombre" : "edoCuenta",
			"tipo" : 0
		},
		{
			"nombre" : "fechaSolicitud",
			"tipo" : 1
		},
		{
			"nombre" : "tipoSolicitud",
			"tipo" : 0
		},
		{
			"nombre" : "estado",
			"tipo" : 0
		},
		{
			"nombre" : "comision",
			"tipo" : 3,
			"attrCelda": 'class="number"'
		},
		{
			"nombre" : "iva",
			"tipo" : 3,
			"attrCelda": 'class="number"'
		},
		{
			"nombre" : "retIva",
			"tipo" : 3,
			"attrCelda": 'class="number"'
		},
		{
			"nombre" : "retIsr",
			"tipo" : 3,
			"attrCelda": 'class="number"'
		},
		{
			"nombre" : "totalPagar",
			"tipo" : 3,
			"attrCelda": 'class="number"'
		},
		{
			"nombre" : "primaNeta",
			"tipo" : 3,
			"attrCelda": 'class="number"'
		},
		{
			"nombre" : "bono",
			"tipo" : 3,
			"attrCelda": 'class="number"'
		}
	];


	var infoHtml = '<a class="dropdown-item" onclick="verDetallePago( \'¿?\',\'¿?\',\'+$("#agenteId").val()+\' )" data-toggle="modal" href="#modalPago-¿?"> <i class="fa fa-search" aria-hidden="true"></i> </a>';
		
		var btnHtml ={
				"requerido" : true,
				"html" :  infoHtml,
				"listaRemplazo" : ["tipoSolicitud","edoCuenta", "tipoSolicitud"]
		};
});

function verDetallePago(tipoSolicitud, edoCuenta, agenteSeleccionado){
	if (tipoSolicitud == "COMISIONES")
		verDetallePagoComision(edoCuenta, agenteSeleccionado);
	else
		verDetallePagoBono( edoCuenta,agenteSeleccionado);
}

function verDetallePagoComision( edoCuenta,agenteSeleccionado){
	showLoader();
	modalTableComi.clear().draw();
	$.ajax({
        url: '<%= detallePagoURL %>',
        type: 'POST',
        data: {edoCuenta: edoCuenta, agente: agenteSeleccionado},
       	success: function(data){
       		var archivo = JSON.parse(data);
       		console.log("respuesta detalle:"+ data);
       		console.log( archivo);
			
       		if( archivo.code !=0 ){
       			console.log("error en el servicio");
				showMessageError(".navbar",archivo.msg, 0);
		        $("#modalPago-comisiones").modal('toggle');

       		}else{
           		$.each(archivo.lista, function(i, stringJson) { 
           			console.log("entro");
 
           			modalTableComi.row.add(  
   			        		[ stringJson.numDocto ,valida(stringJson.asegurado),
   			        			valida(stringJson.poliza),valida(stringJson.endoso),
   			        			valida(stringJson.strTipoProducto)+"- "+valida(stringJson.producto),
   			        			valida(stringJson.moneda),valida(stringJson.primaNeta)
   			        			, stringJson.porcComision + '%',valida(stringJson.comision),
   			        			valida(stringJson.iva),valida(stringJson.totalComision)
   			        			] ).draw();
   			            				  
                  });
           		/*
           		$('#detalleSolPagoTable').DataTable({
      			  "destroy": true
      		  	} );*/
       		}
       	}	            
    }).always( function() {
    	hideLoader();
    } );

}


function verDetallePagoBono( edoCuenta,agenteSeleccionado){
	showLoader();
	modalPagoBono.clear().draw();
	$.ajax({
        url: '<%= detallePagoBonoURL %>',
        type: 'POST',
        data: {edoCuenta: edoCuenta, agente: agenteSeleccionado},
       	success: function(data){
       		var archivo = JSON.parse(data);
       		console.log("respuesta detalle:"+ data);
       		console.log( archivo);
			
       		if( archivo.code !=0 ){
       			console.log("error en el servicio");
				showMessageError(".navbar",archivo.msg, 0);
		        $("#modalPago-BONOS").modal('toggle');

       		}else{
           		$.each(archivo.lista, function(i, stringJson) { 
           			console.log("entro a pago bono");
           			modalPagoBono.row.add(  
   			        		[ stringJson.idBono ,valida(stringJson.tipoBono),
   			        			valida(stringJson.lineaNegocio),valida(stringJson.moneda),
   			        			valida(stringJson.primaPagada), stringJson.porcBono + '%',
   			        			valida(stringJson.Bono),valida(stringJson.iva),
   			        			valida(stringJson.retIsr),valida(stringJson.retIva),
   			        			valida(stringJson.totalBono),valida(stringJson.comentario)
   			        			,valida(stringJson.estatus)  ]   			        		
   			        ).draw();
    				  
                  });
           		/*
           		$('#detalleSolPagoTable').DataTable({
      			  "destroy": true
      		  	} );*/
       		}
       	}	            
    }).always( function() {
    	hideLoader();
    } );

}



function valida( valor){
	
	if(typeof valor === 'undefined'){
	  return "";
	} else {
		valor = ""+ valor;

/*		if( valor.includes("Date") ){*/
	    if (valor.indexOf("Date") != -1  ){
			  return calculaFecha( valor );
		}else{
			if( $.isNumeric( valor ) ){
				return setCoinFormat(valor);
			}else{
				return valor;
			}
		}
	}	
	
}

function calculaFecha( value ){
	
	value = new Date(parseInt(value.replace("/Date(", "").replace(")/",""), 10));
	month = value.getMonth() + 1;
	console.log(month);
	if( month < 9){
		month = "0" + month;
	}
	return value.getDate() +"/"+ month +"/"+value.getFullYear();
	
}

function setCoinFormat(num) {
	
	if( num ==""){
		return num;
	}
	
	arraySplit = num.split(".");
	izq = arraySplit[0];
	der = "00";
/*	if ( num.includes(".") ) {*/
    if (num.indexOf(".") != -1  ){
		der = arraySplit[1];
	}
	izq = izq.replace(/ /g, "");
	izq = izq.replace(/\$/g, "");
	izq = izq.replace(/,/g, "");

	var izqAux = "";
	var j = 0;
	for ( i = izq.length - 1; i >= 0; i-- ) {
		if ( j != 0 && j % 3 == 0 ) {
			izqAux += ",";
		}
		j++;
		izqAux += izq[i];
	}
	izq = "";
	for ( i = izqAux.length - 1; i >= 0; i-- ) {
		izq += izqAux[i];
	}
	der = der.substring(0, 2);
	if ( der.length < 2 ) {
		der += "0";
	}
	return izq + "." + der;
}

function verArchivos( idCarpeta ){
	console.log("obtiene docs");
	$("#tableArchivos tbody").html("");
	
	console.log("----");
	console.log("idCarpeta" + idCarpeta);
	console.log("----");

	showLoader();
	$.ajax({
        url: '<%= obtieneArchivos %>',
        type: 'POST',
        data: {idCarpeta: idCarpeta},
       	success: function(data){
       		var archivo = JSON.parse(data);
       		console.log("respuesta archivo:"+ data);
       		
       		$.each(archivo.listaDocumento, function(i, stringJson) { 
       			
                var htmlTabla;
                htmlTabla = "<tr>"
            	  
                  +"<td>"+stringJson.nombre + "." + stringJson.extension +"</td>"
            	  +"<td>"+stringJson.tipo+"</td>"
            	  +"<td> <button class=\"btn btn-primary btn-sm btn-block\" onclick=\" descargarDocumento( "+stringJson.idCarpeta+ ","+stringJson.idDocumento+ 
            			  ","+stringJson.idCatalogoDetalle +") \"> Descargar </button> </td>"
            	  +"</tr>";
            	  
				
				  $('#tableArchivos tbody').append(htmlTabla);
            	      	 
              });
       		
	       	}	            
    }).always( function() {
        hideLoader();
    } );
}

function  descargarDocumento( idCarpeta,idDocumento,idCatalogoDetalle) {
	showLoader();
	$.ajax({
        url: '<%= descargarDocumento %>',
        type: 'POST',
        data: {idCarpeta: idCarpeta,idDocumento:idDocumento,idCatalogoDetalle:idCatalogoDetalle},
       	success: function(data){

       		var archivo = JSON.parse(data);
       		
       		if( archivo.code ==0 ){
				
				fileAux = 'data:application/octet-stream;base64,'+archivo.documento
				var dlnk = document.getElementById('dwnldLnk');
				dlnk.href = fileAux;
				dlnk.download = archivo.nombre+'.'+archivo.extension;
				dlnk.click();
				
				hideLoader();
       			
       		}else{
				showMessageError(".navbar",archivo.msg, 0);
       		}
       		
       	}	            
    }).always( function() {
        hideLoader();
    } );
}
</script>





