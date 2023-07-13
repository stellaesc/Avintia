@isTest
public class TestAttachmentTrigger {
    @isTest
    public static void testAttachmentTriggerDocumentoReserva() {
        // Insertamos oportunidad
        /*Opportunity opp = new Opportunity(
            Name = 'Opp Test', 
            Contrato_Reserva_firmado__c = false, 
            Contrato_Compraventa_firmado__c = false,
            StageName = 'Reserva', 
            CloseDate = Date.today().addDays(7)
        );
        insert opp;*/
        
        TestUtil.getProductoOportunidad();
        Product2 inmueble = [SELECT id, estado__c FROM Product2 WHERE name = 'Inmueble Test' LIMIT 1];
        inmueble.estado__c = 'Apalabrado';
        update inmueble;

        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE name = 'Oportunidad Test' LIMIT 1];
        // Insertar DocuSign Status
        //dsfs__DocuSign_Status__c docuSignStatus = new dsfs__DocuSign_Status__c(dsfs__Envelope_Status__c = 'Completed', dsfs__Opportunity__c = opp.Id);
        //insert docuSignStatus;
       
        HelloSign__HelloSign_Signature_Request__c hellosignStatus = new HelloSign__HelloSign_Signature_Request__c(HelloSign__Latest_Action__c = 'Signature Completed',
                                                                                                                  HelloSign__Opportunity__c= opp.Id);
        insert hellosignStatus;
        
        // Insertar Attachment
       	Attachment att = new Attachment(Name = 'FichaReserva', ParentId = hellosignStatus.Id, Body = Blob.valueOf('sadas'));
        insert att;
        
        opp = [SELECT Id,Contrato_Reserva_firmado__c FROM Opportunity WHERE Id = :opp.Id];
        
        // Comprobaciones
        //System.assert(opp.Contrato_Reserva_firmado__c);
        Test.stopTest();
    }
    @isTest
    public static void testAttachmentTriggerDocumentoReservaContratoCompraventa() {
        // Insertamos oportunidad
        /*Opportunity opp = new Opportunity(
            Name = 'Opp Test', 
            Contrato_Reserva_firmado__c = false, 
            Contrato_Compraventa_firmado__c = false,
            StageName = 'Reserva', 
            CloseDate = Date.today().addDays(7)
        );
        insert opp;*/
        
        TestUtil.getProductoOportunidad();
        Product2 inmueble = [SELECT id, estado__c FROM Product2 WHERE name = 'Inmueble Test' LIMIT 1];
        inmueble.estado__c = 'Apalabrado';
        update inmueble;
        
        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE name = 'Oportunidad Test' LIMIT 1];
        // Insertar DocuSign Status
        //dsfs__DocuSign_Status__c docuSignStatus = new dsfs__DocuSign_Status__c(dsfs__Envelope_Status__c = 'Completed', dsfs__Opportunity__c = opp.Id);
        //insert docuSignStatus;
        //
        HelloSign__HelloSign_Signature_Request__c hellosignStatus = new HelloSign__HelloSign_Signature_Request__c(HelloSign__Latest_Action__c = 'Signature Completed',
                                                                                                                  HelloSign__Opportunity__c= opp.Id);
        insert hellosignStatus;
        
        // Insertar Attachment
       	Attachment att = new Attachment(Name = 'CompraVenta', ParentId = hellosignStatus.Id, Body = Blob.valueOf('sadas'));
        insert att;
        
        opp = [SELECT Contrato_Compraventa_firmado__c FROM Opportunity WHERE Id = :opp.Id];
        
        // Comprobaciones
       //System.assert(opp.Contrato_Compraventa_firmado__c);
        Test.stopTest();
    }
}