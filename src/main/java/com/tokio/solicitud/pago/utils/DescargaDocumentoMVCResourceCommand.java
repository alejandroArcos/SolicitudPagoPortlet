package com.tokio.solicitud.pago.utils;

import java.util.Arrays;

import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.google.gson.Gson;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCResourceCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCResourceCommand;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.MimeTypesUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.tokio.cotizador.CotizadorService;
import com.tokio.cotizador.Bean.DocumentoResponse;
import com.tokio.cotizador.util.Codifica;
import com.tokio.solicitud.pago.constants.SolicitudPagoPortletKeys;

@Component(
		immediate = true, 
		property = { "javax.portlet.name=" + SolicitudPagoPortletKeys.PORTLET_NAME,
					 "mvc.command.name=/solicitudPago/descargarDocumento" },
		service = MVCResourceCommand.class
)

public class DescargaDocumentoMVCResourceCommand extends BaseMVCResourceCommand{

	@Reference
	CotizadorService cotizadorService;
	
	@Override
	protected void doServeResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws Exception {
		
		int rowNum = 0;
		String tipTransaccion = "B";
		int activo = 1;
		String tipo ="COTIZACIONES";
		String parametros = "";
		int idAsigna = ParamUtil.getInteger(resourceRequest, "idAsigna"); //Preguntar a jorge que valor va? 
		ThemeDisplay themeDisplay = (ThemeDisplay)resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		String usuario = themeDisplay.getUser().getScreenName();
		String pantalla = "Cotizaciones";
		StringBuilder builder = new StringBuilder();
		
		String idCarpeta= ParamUtil.getString(resourceRequest, "idCarpeta");
		String idDocumento= ParamUtil.getString(resourceRequest, "idDocumento");
		String idCatalogoDetalle= ParamUtil.getString(resourceRequest, "idCatalogoDetalle");
		
		builder.append("{");
		builder.append("\"idCarpeta\":" + idCarpeta + ",");
		builder.append("\"idDocumento\":" + idDocumento+ ",");
		builder.append("\"idCatalogoDetalle\":" + idCatalogoDetalle+ ",");
		builder.append("\"documento\":\"\",");
		builder.append("\"nombre\":\"\",");
		builder.append("\"extension\":\"\"" );
		builder.append("}");
		
		String jsonDocumentos = builder.toString();
		
		DocumentoResponse response = cotizadorService.wsDocumentos(rowNum, tipTransaccion, jsonDocumentos, activo, tipo, idAsigna, parametros, usuario, pantalla);
		
		System.out.println("regreso");
		System.out.println( response );
		int code =0;
		if( !response.getMsg().equalsIgnoreCase("ok") ){
			code=1;
		}
		
		response.getListaDocumento().get(0).getNombre();
		
		StringBuilder stringJson = new StringBuilder();
		stringJson.append("{");
		stringJson.append("\"code\":" + code);
		stringJson.append(",\"msg\":\"" + response.getMsg() );
		stringJson.append("\",\"documento\":\""+ response.getListaDocumento().get(0).getDocumento() +"\""  );
		stringJson.append( ",\"nombre\":\""+ response.getListaDocumento().get(0).getNombre() +"\"");
		stringJson.append( ",\"extension\":\""+ response.getListaDocumento().get(0).getExtension() + "\"" );
		stringJson.append( ",\"mimeType\":\""+ MimeTypesUtil.getExtensionContentType( response.getListaDocumento().get(0).getExtension() )+ "\"" );
		stringJson.append("}");
		System.out.println( stringJson.toString() );
		resourceResponse.getWriter().write(stringJson.toString());

	}

}
