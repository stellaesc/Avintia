@IsTest
public class TestSharePointConnectorMappings {

    @TestSetUp
    private static void setUp() {
        //new TestUtil();
        TestUtil.getOportunidadDocumento_reserva_controller();

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
        c.Code__c = '02';
        c.Name = 'Contratos de reserva viviendas';
        c.ParentDirectoryName__c = 'COMERCIAL';
        insert c;
    }

    @IsTest
    public static void testGetFilterByType() {
        // Promocion
        Promocion__c promo = [SELECT Id FROM Promocion__c WHERE Name = 'Promocion test'];
        String filter = SharePointConnectorMappings.getFilterByType(promo.Id.getSObjectType(), promo.Id);
        System.assertEquals('IdPromocion eq \''+promo.Id+'\'', filter);

        // Oportunidad
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Promocion__c = :promo.Id];
        filter = SharePointConnectorMappings.getFilterByType(opp.Id.getSObjectType(), opp.Id);
        System.assertEquals('IdOportunidad eq \''+opp.Id+'\'', filter);
    }

    @IsTest
    public static void testGetSelectFieldsByType() {
        // Promocion
        Promocion__c promo = [SELECT Id FROM Promocion__c WHERE Name = 'Promocion test'];
        List<String> selectFields = SharePointConnectorMappings.getSelectFieldsByType(promo.Id.getSObjectType());
        System.assert(selectFields.contains('IdPromocion'));

        // Oportunidad
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Promocion__c = :promo.Id];
        selectFields = SharePointConnectorMappings.getSelectFieldsByType(opp.Id.getSObjectType());
        System.assert(selectFields.contains('IdOportunidad'));
    }

    @IsTest
    public static void testGetParentMetadataFieldByType() {
        // Promocion
        Promocion__c promo = [SELECT Id FROM Promocion__c WHERE Name = 'Promocion test'];
        String metaDataField = SharePointConnectorMappings.getParentMetadataFieldByType(promo.Id.getSObjectType());
        System.assert(metaDataField.equals('IdPromocion'));

        // Oportunidad
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Promocion__c = :promo.Id];
        metaDataField = SharePointConnectorMappings.getParentMetadataFieldByType(opp.Id.getSObjectType());
        System.assert(metaDataField.equals('IdOportunidad'));
    }

    @IsTest
    public static void testGetPromotionQueryByType() {
        // Promocion
        Promocion__c promo = [SELECT Id FROM Promocion__c WHERE Name = 'Promocion test'];
        String promotionQuery = SharePointConnectorMappings.getPromotionQueryByType(promo.Id.getSObjectType());
        System.assert(promotionQuery.equals('SELECT Name FROM Promocion__c WHERE Id = $value$'));

        // Oportunidad
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Promocion__c = :promo.Id];
        promotionQuery = SharePointConnectorMappings.getPromotionQueryByType(opp.Id.getSObjectType());
        System.assert(promotionQuery.equals('SELECT Name FROM Promocion__c WHERE Id IN (SELECT Promocion__c FROM Opportunity WHERE Id = $value$)'));
    }
	/*
    @IsTest
    public static void testGetNameByCats() {
        String fileName = SharePointConnectorMappings.getNameByCats(new List<String> {'Contratos de reserva viviendas'});
        system.debug('fileName:::'+fileName);
        System.assert(fileName.containsIgnoreCase('001-02-Contratos de reserva viviendas-COMERCIAL_Contratos de reserva viviendas-20'));
    }
	*/
}