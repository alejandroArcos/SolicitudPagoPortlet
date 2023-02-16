package com.tokio.solicitud.pago.portlet;

import java.io.IOException;
import java.util.List;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.servlet.http.HttpServletRequest;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.tokio.cotizador.CotizadorService;
import com.tokio.cotizador.Bean.Persona;
import com.tokio.cotizador.Bean.Registro;
import com.tokio.cotizador.constants.CotizadorServiceKey;

/**
 * @author josemigueltomastrejo
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=SolicitudPagoPortlet Portlet",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user",
		"com.liferay.portlet.requires-namespaced-parameters=false"

	},
	service = Portlet.class
)
public class SolicitudPagoPortlet extends MVCPortlet {

	@Reference
	CotizadorService cotizadorService;
	
	@Override
	public void doView(RenderRequest renderRequest, RenderResponse renderResponse)
					throws IOException, PortletException {
		
		
		int rowNum =0;
		String transaccion = "B";
		int active = 1;
		User user = (User) renderRequest.getAttribute(WebKeys.USER);
		String usuario = user.getScreenName();
		String pantalla = "Solicitud Pago";
		
		HttpServletRequest originalRequest = PortalUtil
				.getOriginalServletRequest(PortalUtil.getHttpServletRequest(renderRequest));
		Integer idUsuario = (Integer)originalRequest.getSession().getAttribute("idUsuario");

		
		try {
			List<Registro> listaEstatus = cotizadorService.getCatalogo(rowNum,transaccion, CotizadorServiceKey.LISTA_ESTADO_COBRANZA,active,usuario,pantalla);
			List<Persona> listaAgente = cotizadorService.getListaAgenteUsuario(rowNum,idUsuario, usuario, pantalla);
			
			renderRequest.setAttribute("listaEstatus", listaEstatus);
			renderRequest.setAttribute("listaAgente", listaAgente);
			
			
		} catch (Exception e) {

			e.printStackTrace();
		}

		super.doView(renderRequest, renderResponse);
		
	}
		
	
	
}