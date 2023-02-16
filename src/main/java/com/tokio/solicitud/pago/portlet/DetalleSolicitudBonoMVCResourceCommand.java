package com.tokio.solicitud.pago.portlet;

import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.google.gson.Gson;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCResourceCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCResourceCommand;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.tokio.cotizador.CotizadorService;
import com.tokio.cotizador.Bean.DetalleSolicitudPagoBonoResponse;
import com.tokio.cotizador.Bean.DetalleSolicitudPagoResponse;
import com.tokio.cotizador.Bean.SimpleResponse;
import com.tokio.solicitud.pago.constants.SolicitudPagoPortletKeys;

@Component(
		immediate = true, 
		property = { "javax.portlet.name=" + SolicitudPagoPortletKeys.PORTLET_NAME,
					 "mvc.command.name=/solicitudPago/detallePagoBono" },
		service = MVCResourceCommand.class
)

public class DetalleSolicitudBonoMVCResourceCommand extends BaseMVCResourceCommand{

	
	@Reference
	CotizadorService cotizadorService;
	
	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {
		
		try{
			ThemeDisplay themeDisplay = (ThemeDisplay)resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
			String usuario = themeDisplay.getUser().getScreenName();
			String pantalla = "Solicitud detalle pago";
			int rowNum=0;
			String parametros = "";
			String edoCuenta = ParamUtil.getString(resourceRequest, "edoCuenta");
			String agente = ParamUtil.getString(resourceRequest, "agente");
			int moneda = 0;
			
			DetalleSolicitudPagoBonoResponse detalle = cotizadorService.detalleSolicitudPagoBono(rowNum, agente, edoCuenta, moneda, usuario, pantalla, parametros);
			if( detalle.getMsg().equalsIgnoreCase("ok") ){
				detalle.setCode(0);
			}else{
				detalle.setCode(1);
			}
			System.out.println(detalle );
			Gson gson = new Gson();
			String stringJson = gson.toJson(detalle);
			System.out.println( stringJson);
			resourceResponse.getWriter().write(stringJson);
		}catch(Exception e){
			e.printStackTrace();
			String stringJson = "{\"code\":3, \"msg\": \"Error desconocido en la aplicacion\"}";
			resourceResponse.getWriter().write(stringJson);

		}

		
		
	}

}
