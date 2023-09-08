@IsTest
public class TestPublicacionPortalIdealista {
	@TestSetUp
    public static void setUp() {
        new TestUtil();
        Promocion__c promo = [SELECT Id FROM Promocion__c WHERE Idealista__c = true];
        TestUtil.getImagen();
        Test.startTest();
        TestUtil.testCrearInmueblePromocionWithReturn(promo.Id);
        
        PropiedadesIntegracion__c propiedades = new PropiedadesIntegracion__c();
        propiedades.URL_IDEALISTA__c = 'http://prueba.com';
        propiedades.ILC_IDEALISTA__c = 'ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7';
        upsert propiedades;
        Test.stopTest();
    }
    
    @IsTest
    public static void test_GetPromotions() {
        Test.startTest();
        List<Promocion__c> promos = PublicacionPortalIdealista.getPromotions();
        System.assert(promos.size() > 0);
        Test.stopTest();
    }

    @IsTest
    public static void test_GetPromotionsInmuebles() {
        List<Promocion__c> promos = PublicacionPortalIdealista.getPromotions();
        Set<Id> promosIds = new Set<Id>();
        for(Promocion__c promo : promos) promosIds.add(promo.Id);

        Test.startTest();
        Map<Id, List<Product2>> inmuebles = PublicacionPortalIdealista.getPromotionsInmuebles(promosIds);
        System.assert(inmuebles.size() > 0);
        Test.stopTest();
    }

    @IsTest
    public static void test_GetProductAnnexesByPromo() {
        List<Promocion__c> promos = PublicacionPortalIdealista.getPromotions();
        Set<Id> promosIds = new Set<Id>();
        for(Promocion__c promo : promos) promosIds.add(promo.Id);

        Test.startTest();
        Map<Id, List<Product2>> annexes = PublicacionPortalIdealista.getProductAnnexesByPromo(promosIds);
        System.assert(!annexes.isEmpty());
        Test.stopTest();
    }

    @IsTest
    public static void test_getTotalPriceWithAnnexesIncluded() {
        List<Promocion__c> promos = PublicacionPortalIdealista.getPromotions();
        Set<Id> promosIds = new Set<Id>();
        for(Promocion__c promo : promos) promosIds.add(promo.Id);
        Map<Id, List<Product2>> inmuebles = PublicacionPortalIdealista.getPromotionsInmuebles(promosIds);
        Map<Id, List<Product2>> annexes = PublicacionPortalIdealista.getProductAnnexesByPromo(promosIds);

        Test.startTest();
        Decimal priceTotal = PublicacionPortalIdealista.getTotalPriceWithAnnexesIncluded(inmuebles.get(promos[0].Id).get(0), annexes.get(inmuebles.get(promos[0].Id).get(0).Id));
        System.assertEquals(1200, priceTotal);
        Test.stopTest();
    }

    @IsTest
    public static void test_GetPromotionsImgs() {
        PropiedadesIntegracion__c propiedadesIntegracion = PropiedadesIntegracion__c.getInstance();	
        String base64Content = EncodingUtil.Base64Encode( 
                Blob.valueOf('Test') 
        );
        Blob blobContent = EncodingUtil.base64Decode( base64Content );
        List<Promocion__c> promos = PublicacionPortalIdealista.getPromotions();
        System.debug('SIZE 19723: ' + promos.size());
        Set<Id> promosIds = new Set<Id>();
        for(Promocion__c promo : promos) promosIds.add(promo.Id);

        Test.startTest();
        Map<Id, List<ContentVersion>> imgsMap = PublicacionPortalIdealista.getPromotionsImgs(promosIds);
        System.debug('SIZE: ' + imgsMap.size());
        System.assert(imgsMap.size() == 1);
        Test.stopTest();
    }

    @IsTest
    public static void test_GetInmueblesImgs() {
        List<Promocion__c> promos = PublicacionPortalIdealista.getPromotions();
        Set<Id> promosIds = new Set<Id>();
        for(Promocion__c promo : promos) promosIds.add(promo.Id);

        Map<Id, Product2> inmueblesMap = new Map<Id, Product2>();
        Set<Id> tipoInmueblesIds = new Set<Id>();
        Map<Id, List<Product2>> inmuebles = PublicacionPortalIdealista.getPromotionsInmuebles(promosIds);
        for(Id promoId : inmuebles.keySet()) {
            for(Product2 inmueble : inmuebles.get(promoId)) {
                inmueblesMap.put(inmueble.Id, inmueble);    
                tipoInmueblesIds.add(inmueble.Tipo_de_inmueble__c);
            }
        }

        Test.startTest();
        Map<Id, List<ContentDocumentLink>> imgsMap = PublicacionPortalIdealista.getInmueblesImgs(tipoInmueblesIds, inmueblesMap);
        System.assertEquals(1, imgsMap.size());
        System.assertEquals(2, imgsMap.values().get(0).size());
        Test.stopTest();
    }

    @IsTest
    public static void test_GenerarJson() {
        Test.startTest();
        try{
            String jsonStr = PublicacionPortalIdealista.generarJson();
            System.debug(jsonStr);
            //JSONParser jsonParser = JSON.createParser(jsonStr);
            System.assert(jsonStr.contains('"customerCountry" : "Spain",'));
            System.assert(jsonStr.contains('"propertyCode" : "'));
            System.assert(jsonStr.contains('"addressVisibility" : "hidden",'));
            System.assert(jsonStr.contains('"featuresType" : "promo",'));
            System.assert(jsonStr.contains('"newDevelopmentTypologies" : [ {'));
            System.assert(jsonStr.contains('"featuresType" : "'));
        }catch(System.Exception e){
            System.debug(e);
        }
        

        Test.stopTest();
    }

    /*@IsTest
    public static void test_PublishOK() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IdealistaJsonPublicationCalloutMock());
        HttpResponse response = PublicacionPortalIdealista.publish();
        System.assertEquals(202, response.getStatusCode());
        Test.stopTest();
    }

    @IsTest
    public static void test_PublishJSONKO() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IdealistaJsonPublicationErrCalloutMock());
        try {
            HttpResponse response = PublicacionPortalIdealista.publish();
        } catch(Exception e) {
            System.assert(e.getMessage().contains('Error al formar el JSON de las promociones y propiedades'));
        }
        Test.stopTest();
    }

    @IsTest
    public static void test_PublishResponseKO() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IdealistaJsonPublicationErrCalloutMock());
        try {
            HttpResponse response = PublicacionPortalIdealista.publish();
        } catch(Exception e) {
            System.assert(e.getMessage().contains('Error en la llamada a Logic App de Azure -> Req: '));
        }
        Test.stopTest();
    }*/
}