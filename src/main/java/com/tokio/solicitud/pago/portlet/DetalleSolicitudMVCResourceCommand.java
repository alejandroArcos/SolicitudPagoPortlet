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
import com.tokio.cotizador.Bean.DetalleSolicitudPagoResponse;
import com.tokio.cotizador.Bean.SimpleResponse;
import com.tokio.solicitud.pago.constants.SolicitudPagoPortletKeys;

@Component(
		immediate = true, 
		property = { "javax.portlet.name=" + SolicitudPagoPortletKeys.PORTLET_NAME,
					 "mvc.command.name=/solicitudPago/detalle" },
		service = MVCResourceCommand.class
)

public class DetalleSolicitudMVCResourceCommand extends BaseMVCResourceCommand{

	
	@Reference
	CotizadorService cotizadorService;
	
	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {
		

		ThemeDisplay themeDisplay = (ThemeDisplay)resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		String usuario = themeDisplay.getUser().getScreenName();
		String pantalla = "Solicitud detalle pago";
		int rowNum=0;
		String parametros = "";
		String edoCuenta = ParamUtil.getString(resourceRequest, "edoCuenta");
		String agente = ParamUtil.getString(resourceRequest, "agente");
		int moneda = 0;
		
		DetalleSolicitudPagoResponse detalle = cotizadorService.detalleSolicitudPago(rowNum, agente, edoCuenta, moneda, usuario, pantalla, parametros);
		System.out.println(detalle );
		Gson gson = new Gson();
		String stringJson = gson.toJson(detalle);
		System.out.println( stringJson);
		resourceResponse.getWriter().write(stringJson);

		
		
	}

}
