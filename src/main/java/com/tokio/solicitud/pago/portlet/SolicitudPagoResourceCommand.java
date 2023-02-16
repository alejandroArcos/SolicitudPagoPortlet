package com.tokio.solicitud.pago.portlet;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.google.gson.Gson;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCResourceCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCResourceCommand;
import com.liferay.portal.kernel.service.RoleLocalServiceUtil;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.tokio.cotizador.CotizadorService;
import com.tokio.cotizador.Bean.SolicitudPago;
import com.tokio.cotizador.Bean.SolicitudPagoResponse;
import com.tokio.solicitud.pago.constants.SolicitudPagoPortletKeys;

@Component(
		immediate = true, 
		property = { "javax.portlet.name=" + SolicitudPagoPortletKeys.PORTLET_NAME,
					 "mvc.command.name=/solicitudpago/getPolizasAjax" },
		service = MVCResourceCommand.class
)

public class SolicitudPagoResourceCommand extends BaseMVCResourceCommand{
	@Reference
	CotizadorService cotizadorService;

	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {
		System.out.println("entro a accion de solicitud pago");
		
		int rowNum = ParamUtil.getInteger(resourceRequest, "rowNum");
		String tipTransaccion = "B";
		String agente = ParamUtil.getString(resourceRequest, "agente");
		String fechaSolDesde = ParamUtil.getString(resourceRequest, "fechaInicio");
		String fechaSolFin = ParamUtil.getString(resourceRequest, "fechaFin");
		int estado  = ParamUtil.getInteger(resourceRequest, "status");
		
		
		int moneda = 0;
		User user = (User) resourceRequest.getAttribute(WebKeys.USER);
		String usuario = user.getScreenName();
		String pantalla = "Cotizaciones";
		String parametros ="";
		try{
			SolicitudPagoResponse solicitudPagoResponse = cotizadorService.solicitudPago(rowNum, tipTransaccion, agente, fechaSolDesde, fechaSolFin, estado, moneda, usuario, pantalla, parametros);
			//resourceRequest.setAttribute("listaSolicitud", solicitudPagoResponse.getLista());
			boolean permisoComisiones = RoleLocalServiceUtil.hasUserRole(user.getUserId(), user.getCompanyId(), "TMX-COMISIONES", false);
			boolean permisoBonos = RoleLocalServiceUtil.hasUserRole(user.getUserId(), user.getCompanyId(), "TMX-BONOS", false);
			
			if( solicitudPagoResponse.getCode() == 0  ){
				Gson gson = new Gson();
				String stringJson = "";
				if (permisoBonos && permisoComisiones)
					stringJson =  "{ \"code\" : "+solicitudPagoResponse.getCode()+", \"listaPolizas\" : " +  solicitudPagoResponse.getLista() + "}"; 
				else{
				    List<SolicitudPago> newList = new ArrayList<SolicitudPago>();
					for(SolicitudPago solicituPago : solicitudPagoResponse.getLista()){
						if ( (permisoComisiones && solicituPago.getTipoSolicitud().equals("COMISIONES")) || (permisoBonos && solicituPago.getTipoSolicitud().equals("BONOS")) ){
							newList.add(solicituPago);
							System.out.println(solicituPago);
						}
					}
					stringJson =  "{ \"code\" : "+solicitudPagoResponse.getCode()+", \"listaPolizas\" : " +  newList + "}"; 
				}
					
				System.out.println(stringJson);
				resourceResponse.getWriter().write(stringJson);
				SessionMessages.add(resourceRequest, "consultaExitosa");
			}else{
				String jsonString = "{ \"code\" : "+solicitudPagoResponse.getCode()+", \"msj\" : \"" + solicitudPagoResponse.getMsg() + "\"}"; 
				PrintWriter writer = resourceResponse.getWriter();
				writer.write(jsonString);
			}
		}catch( Exception e){
			e.printStackTrace();
		}

	}
}
