@isTest
public class TEST_Documento_factura {

    
       @isTest
       public static void testDocumento_factura_controller() {
           
        Factura__c factura = TESTUtil.getFactura();
           
        PageReference pageRef = Page.VF_Documento_factura;
        pageRef.getParameters().put('id', factura.id);
           
        Test.setCurrentPage(pageRef);

        Documento_factura_controller controller = new Documento_factura_controller();
           
           
        String nextPage = pageRef.getUrl();

           //System.assertEquals('/apex/slider_promocion', nextPage);
        
       }
}