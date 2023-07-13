@isTest
public class TEST_HL_FacturaTrigger {

    @isTest
    public static void testBeforeDelete() {
        Factura__c factura = TestUtil.getFactura();
        Factura__c f = [SELECT Id, IsDeleted, Numero_de_factura__c, Permitir_borrado_con_numeracion__c FROM Factura__c WHERE Id = :factura.Id];
        f.Numero_de_factura__c = '200100036';
        f.SecuencialFactura__c = 36;
        update f;
        
        Test.startTest();
        try{
            delete f;
        } catch(DmlException ex) {
            //System.assert(ex.getMessage().contains('La factura que se desea eliminar tiene número de factura y no está marcado el check'+
           //                   +' "Permitir borrado con numeración". Si desea eliminar la factura, recuerde marcar dicho check.')); 
        }
        
        f.Permitir_borrado_con_numeracion__c = true;
        update f;
        delete f;
        Test.stopTest();
    }
    
     public static void testBeforeUpdate() {
         
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
         
        Factura__c factura = TestUtil.getFactura();
        Factura__c f = TestUtil.getFactura();
        factura.Numero_de_factura__c = '1';
        factura.Fecha_de_emision__c = Date.newInstance(2018, 10, 03);
        factura.Oportunidad__c = opp.Id;
        update factura;
        
        f.Oportunidad__c = opp.Id;
        f.Numero_de_factura__c = '2';
        f.Fecha_de_emision__c = Date.newInstance(2017, 10, 03);
        
        Test.startTest();
        try{
            update f;
        } catch(DmlException ex) {}
        
        Test.stopTest();
    }
    
}