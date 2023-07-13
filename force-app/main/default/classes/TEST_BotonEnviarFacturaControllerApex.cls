@isTest(SeeAllData=false)
public class TEST_BotonEnviarFacturaControllerApex {
    
    @TestSetUp
    public static void setUp() {
        TestUtil.getLineaFactura();

        SharePointConnector__c spCustomSettings = SharePointConnector__c.getOrgDefaults();
        if(spCustomSettings.spClientId__c == null) {
            insert new SharePointConnector__c(
                spClientId__c = 'test',
                spClientSecret__c = 'test',
                spResource__c = 'test',
                spDocumentNumber__c = 1,
                spParentDir__c = 'Promociones',
                spSiteDomain__c = 'http...',
                spSiteUrl__c = 'http..'
            );
        }

        DocumentCategory__c c = new DocumentCategory__c();
        c.Level__c = 1;
        c.Code__c = '01';
        c.Name = 'Facturas';
        c.ParentDirectoryName__c = 'FACTURAS';
        insert c;
    }

    @isTest
    public static  void testGenerarFactura(){
        Factura__c factura = [SELECT Id FROM Factura__c WHERE Name = 'Test Factura' LIMIT 1];
        Id facturaId = factura.Id;
        
        BotonEnviarFacturaControllerApex.getUrl();
       	BotonEnviarFacturaControllerApex.GenerarFactura(facturaId);
        List<ContentDocumentLink> invoices = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :facturaId];
        System.assert(invoices.size() > 0);

        //BotonEnviarFacturaControllerApex.guardarFactura(facturaId);
        BotonEnviarFacturaControllerApex.enviarEmail(facturaId);
        BotonEnviarFacturaControllerApex.generarFacturaAnulacion(facturaId);
    
    }

}