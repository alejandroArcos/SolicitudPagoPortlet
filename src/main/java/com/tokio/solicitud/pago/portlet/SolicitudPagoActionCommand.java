package com.tokio.solicitud.pago.portlet;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCActionCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCActionCommand;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.WebKeys;
import com.tokio.cotizador.CotizadorService;
import com.tokio.cotizador.Bean.CotizacionResponse;
import com.tokio.cotizador.Bean.SolicitudPagoResponse;
import com.tokio.solicitud.pago.constants.SolicitudPagoPortletKeys;

@Component(
		 property = {
		 "javax.portlet.name="+ SolicitudPagoPortletKeys.PORTLET_NAME,
		 "mvc.command.name=/solicitudPago"
		 },
		 service = MVCActionCommand.class
		 )
public class SolicitudPagoActionCommand extends BaseMVCActionCommand {

	@Reference
	CotizadorService cotizadorService; 
	
	@Override
	protected void doProcessAction(ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {

		System.out.println("entro a accion de solicitud pago");
		
		int rowNum = 0;
		String tipTransaccion = "B";
		String agente = ParamUtil.getString(actionRequest, "agente");
		String fechaSolDesde = ParamUtil.getString(actionRequest, "fechaInicio");
		String fechaSolFin = ParamUtil.getString(actionRequest, "fechaFin");
		int estado  = ParamUtil.getInteger(actionRequest, "status");
		
		
		int moneda = 0;
		User user = (User) actionRequest.getAttribute(WebKeys.USER);
		String usuario = user.getScreenName();
		String pantalla = "Cotizaciones";
		String parametros ="";
		try{
			SolicitudPagoResponse solicitudPagoResponse = cotizadorService.solicitudPago(rowNum, tipTransaccion, agente, fechaSolDesde, fechaSolFin, estado, moneda, usuario, pantalla, parametros);
			actionRequest.setAttribute("listaSolicitud", solicitudPagoResponse.getLista());
		}catch( Exception e){
			e.printStackTrace();
		}
		
		actionRequest.setAttribute("agente", agente);
		actionRequest.setAttribute("fechaSolDesde", fechaSolDesde);
		actionRequest.setAttribute("fechaSolFin", fechaSolFin);
		actionRequest.setAttribute("status", estado);
		
		
	}
	
	

}
