@isTest
public class Documento_reserva_controller_Test {
    
    @isTest
    public static void testDocumentoReserva(){
        Opportunity oportunidad = TESTUtil.getOportunidad_Contrato_Compraventa_VPO_controller();
        system.debug('TEST OPORTUNIDAD VPO'+oportunidad);

        Test.startTest();
        PageReference pageRef = Page.VF_Documento_reserva_conIVA;
        pageRef.getParameters().put('id', oportunidad.id);
        
        Test.setCurrentPage(pageRef);
        
        Documento_reserva_controller documento_reserva_controller = new Documento_reserva_controller();
        String nextPage = pageRef.getUrl(); 
        //System.assertEquals('/apex/slider_promocion', nextPage);    
        //Métodos que devuleven valores
        //Documento_reserva_controller.getFechaEscrita(Date fecha);
        //Documento_reserva_controller.getMesEscrito(Integer mes);
        documento_reserva_controller.getPromocion();
        documento_reserva_controller.getPromotora();
        documento_reserva_controller.getTitulares();
        documento_reserva_controller.getCliente();
        documento_reserva_controller.getRepresentanteLegal();
        documento_reserva_controller.getRepresentantesLegalesParticipantes();
        documento_reserva_controller.getRecordTypeIdCustomSetting();
        documento_reserva_controller.getInmuebles();
        documento_reserva_controller.getFechaFinReserva();
        documento_reserva_controller.getRestoEscrituraPublica();
        documento_reserva_controller.getReservaConIva();
        Test.stopTest();
    }    
    
}