@isTest
public class TestCambioEstadoCobroTrigger {

    @isTest
    static void testValidarCambioDeEstadoFactura() {
        Factura__c fact= TestUtil.getFactura();
        //Damos de alta el Cobro
        Cobro__c cobro= new Cobro__c();
        cobro.Name = 'prueba';
        cobro.Nombre_sociedad__c='nombre Sociedad';
        cobro.Factura__c= fact.Id;
        //cobro.Concepto__c= 'prueba0';
        cobro.Importe__c=6000;
        cobro.Referencia__c='0000';

    
        Test.startTest();
            insert cobro;
        Test.stopTest();
    }

}