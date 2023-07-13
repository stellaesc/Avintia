@isTest
public class Ficha_Escrituracion_Controller_Test {
    
    @isTest
    public static void testFicha_Escrituracion(){
        Opportunity oportunidad = TESTUtil.getOportunidad_Contrato_Compraventa_VPO_controller();
        
        PageReference pageRef = Page.Ficha_Escrituracion;
        pageRef.getParameters().put('id', oportunidad.id);
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        Ficha_Escrituracion_Controller ficha_Escrituracion_Controller = new Ficha_Escrituracion_Controller();
        String nextPage = pageRef.getUrl();
        ficha_Escrituracion_Controller.getTitulares();
        ficha_Escrituracion_Controller.getLocalidadTitulares();
        ficha_Escrituracion_Controller.getCliente();
        ficha_Escrituracion_Controller.getRecordTypeIdCustomSetting();
        ficha_Escrituracion_Controller.getRepresentantesLegales();
        Test.stopTest();
    } 
    
}