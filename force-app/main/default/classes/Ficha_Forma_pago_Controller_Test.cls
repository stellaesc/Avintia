@isTest(SeeAllData = false)
public class Ficha_Forma_pago_Controller_Test {

    @isTest
    public static void testFichaFormaPagoController(){
        
        
        Quote presupuesto = TESTUtil.getPresupuesto_Ficha_Forma_Pago_controller();
        
        system.debug('TEST  presupuesto:::'+presupuesto);
           
        PageReference pageRef = Page.VF_Ficha_Forma_pago;
        pageRef.getParameters().put('id', presupuesto.id);
           
        Test.setCurrentPage(pageRef);

        Ficha_Forma_pago_Controller controller = new Ficha_Forma_pago_Controller();
           
           
        String nextPage = pageRef.getUrl();

           //System.assertEquals('/apex/slider_promocion', nextPage);
        
       }    
    
}