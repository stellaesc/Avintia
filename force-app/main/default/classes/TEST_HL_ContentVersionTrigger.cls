@isTest
public class TEST_HL_ContentVersionTrigger {
    
    @isTest 
    public static void testaddURLPublica(){
        Test.startTest();
        ContentVersion imagen = TestUtil.getImagen();
        imagen.Title = 'Imagen prueba v2';
        update imagen;
        Test.stopTest();
        
        imagen = [SELECT id, Title,Tipo__c, URL__c FROM ContentVersion WHERE id =:Imagen.id LIMIT 1];

        System.assert(Imagen.URL__c != null);
        System.assertEquals('Imagen prueba v2', Imagen.Title);
    }
    
    @isTest
    public static void testRelateDocumentOpportunity(){
        Test.startTest();
        Promocion__c promocion = TestUtil.getPromocion(Date.today(), Date.today().addMonths(12));
        Account cuenta = [SELECT Id FROM Account WHERE Name = 'Cuenta test1']; 
        
        Opportunity oportunidad = new Opportunity();
        oportunidad.Promocion__c = promocion.Id;
        oportunidad.Name = 'Prueba';
        oportunidad.StageName = 'Pre-Reserva';
        oportunidad.CloseDate = Date.today();
        oportunidad.AccountId = cuenta.Id;
        insert oportunidad;
        
        ContentVersion memoriaCalidades = new ContentVersion();
        memoriaCalidades.Title = 'memoriaCalidades';
        memoriaCalidades.PathOnClient = 'memoriaCalidades.png';
        memoriaCalidades.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        memoriaCalidades.Tipo__c = 'Memoria_calidades';
        memoriaCalidades.Posicion__c = 1;
        memoriaCalidades.ParentId__c = promocion.Id;
        insert memoriaCalidades;
        
        ContentVersion cv = [SELECT ContentDocumentId, Title, VersionData FROM ContentVersion WHERE Id = :memoriaCalidades.Id];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.LinkedEntityId = promocion.Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        Test.stopTest();

        Set<Id> linkedEntities = new Set<Id>();
        List<ContentDocumentLink> cdlOpps = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId = :cv.ContentDocumentId];
        for(ContentDocumentLink cdlOpp : cdlOpps) linkedEntities.add(cdlOpp.LinkedEntityId);
        
        System.assert(linkedEntities.contains(oportunidad.Id));
    }
    
    @isTest
    public static void testCreateDocumentVersionHistoryRecord(){
        Test.startTest();
        Promocion__c promocion = TestUtil.getPromocion(Date.today(), Date.today().addMonths(12));
        Account cuenta = [SELECT Id FROM Account WHERE Name = 'Cuenta test1']; 
        
        Opportunity oportunidad = new Opportunity();
        oportunidad.Promocion__c = promocion.Id;
        oportunidad.Name = 'Prueba';
        oportunidad.StageName = 'Pre-Reserva';
        oportunidad.CloseDate = Date.today();
        oportunidad.AccountId = cuenta.Id;
        insert oportunidad;
        
        ContentVersion memoriaCalidades = new ContentVersion();
        memoriaCalidades.Title = 'Test Memoria Calidades';
        memoriaCalidades.PathOnClient = 'Test Memoria Calidades.png';
        memoriaCalidades.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body');
        memoriaCalidades.Tipo__c = 'Memoria_calidades';
        memoriaCalidades.Posicion__c = 1;
        memoriaCalidades.ParentId__c = promocion.Id;
        memoriaCalidades.IsMajorVersion = false;
        insert memoriaCalidades;
        
        ContentVersion cv = [SELECT ContentDocumentId, PathOnClient, Title, VersionNumber, VersionData FROM ContentVersion WHERE Id = :memoriaCalidades.Id];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.LinkedEntityId = promocion.Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;

        Test.stopTest();
        
        DocumentVersionHistory__c dvh1 = [SELECT Id, Name, Document_Version_History_Name__c, Tipo__c, Estado__c, Promocion__c, VersionNumber__c FROM DocumentVersionHistory__c];
        
        System.assertEquals(cv.Title + ' - v1', dvh1.Document_Version_History_Name__c);
        System.assertEquals(1, dvh1.VersionNumber__c);
        System.assertEquals('Memoria_calidades', dvh1.Tipo__c);
        System.assertEquals('Pendiente de Aprobación', dvh1.Estado__c);
        
        for(Integer i = 0; i < 6; i++) approveProcess(dvh1.Id);
        
        dvh1 = [SELECT Id, Name, Document_Version_History_Name__c, Tipo__c, Estado__c, Promocion__c, VersionNumber__c FROM DocumentVersionHistory__c];
        
        System.assertEquals(cv.Title + ' - v1', dvh1.Document_Version_History_Name__c);
        System.assertEquals(1, dvh1.VersionNumber__c);
        System.assertEquals('Memoria_calidades', dvh1.Tipo__c);
        System.assertEquals('Aprobado', dvh1.Estado__c);
    }
    
    private static void approveProcess(Id parent) {
        List<ProcessInstanceWorkitem> workItems = [
             SELECT Id
               FROM ProcessInstanceWorkitem 
              WHERE ProcessInstance.TargetObjectId = :parent
                AND ProcessInstance.Status = 'Pending'];
                
        if(!workItems.isEmpty()){
            Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
            pwr.setWorkitemId(workItems.get(0).Id);
            pwr.setAction('Approve');
            pwr.setComments('Approved.');
            Approval.process(pwr);
        }
    }

}