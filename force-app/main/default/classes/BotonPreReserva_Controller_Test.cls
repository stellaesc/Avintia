@isTest
public class BotonPreReserva_Controller_Test {

    @TestSetUp
    public static void setUp() {
        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        insert new SharePointConnector__c(
            spClientId__c = 'test',
            spClientSecret__c = 'test',
            spResource__c = 'test',
            spDocumentNumber__c = 1,
            spParentDir__c = 'Promociones',
            spSiteDomain__c = 'http...',
            spSiteUrl__c = 'http..'
        );

        Quote quote = TESTUtil.getPresupuesto_Ficha_Forma_Pago_controller();

        DocumentCategory__c c = new DocumentCategory__c();
        c.Level__c = 1;
        c.Code__c = '01';
        c.Name = 'Contratos de reserva viviendas';
        c.ParentDirectoryName__c = 'COMERCIAL';
        insert c;
    }

    @isTest
    public static void testBotonPreReserva(){
        
        
        Quote quote = [SELECT Id,OpportunityId FROM Quote WHERE Name = 'Presupuesto Test' LIMIT 1];
        system.debug('TEST PRESUPUESTO '+quote);
        
        String tipoInmueble = BotonPreReserva_Controller.getTipoInmueble(quote.Id);
        BotonPreReserva_Controller.generarContrato(quote.Id, null);
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :quote.OpportunityId];
        System.assert(docs.size() > 0);
      
    }

    @isTest
    public static void testGetUrl() {
        String url = BotonPreReserva_Controller.getUrl();
        System.assert(url.containsIgnoreCase('http'));
    }     
    
}