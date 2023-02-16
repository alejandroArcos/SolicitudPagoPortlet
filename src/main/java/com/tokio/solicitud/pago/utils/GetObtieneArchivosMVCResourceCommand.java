package com.tokio.solicitud.pago.utils;

import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import com.google.gson.Gson;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCResourceCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCResourceCommand;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.tokio.cotizador.CotizadorService;
import com.tokio.cotizador.Bean.DocumentoResponse;
import com.tokio.solicitud.pago.constants.SolicitudPagoPortletKeys;

@Component(
		immediate = true, 
		property = { "javax.portlet.name=" + SolicitudPagoPortletKeys.PORTLET_NAME,
					 "mvc.command.name=/solicitudPago/obtieneArchivos" },
		service = MVCResourceCommand.class
)

public class GetObtieneArchivosMVCResourceCommand extends BaseMVCResourceCommand{

	
	@Reference
	CotizadorService cotizadorService;
	
	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {
		
		int idCarpeta = ParamUtil.getInteger(resourceRequest, "idCarpeta");
		int rowNum = 0;
		String tipo = "";
		int activo = 1;
		int idDocumento = 0;
		int idCatalogoDetalle = 0;
		String parametros = null;
		ThemeDisplay themeDisplay = (ThemeDisplay)resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		String usuario = themeDisplay.getUser().getScreenName();
		String pantalla = "Solicitdes Pago comisiones-bonos";
		System.out.println("idCarpeta " + idCarpeta );
		
		DocumentoResponse docResp = null; 
		docResp = cotizadorService.getListaDocumentos( rowNum, idCarpeta, idDocumento, idCatalogoDetalle, tipo, activo, parametros, usuario, pantalla);
		//pasar a string json  
		Gson gson = new Gson();
		String stringJson = gson.toJson(docResp);
		resourceResponse.getWriter().write(stringJson);
	}

}
