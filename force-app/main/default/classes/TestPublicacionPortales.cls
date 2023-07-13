@isTest
public class TestPublicacionPortales {
    private static PropiedadesIntegracion__c propiedades;
    static {

        propiedades = new PropiedadesIntegracion__c();
        propiedades.URL_FOTOCASA__c = 'http://prueba.com';
        propiedades.URL_WEBAVINTIA__c = 'http://prueba.com';
        propiedades.URL_WEBAVINTIA_PRO__c = 'http://prueba.com';
        propiedades.PasswordWSAvintia__c = '1234';
        propiedades.ILC_IDEALISTA__c = 'ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7';

        upsert propiedades;

    }

    @IsTest
    static void testPublicacionPortalWebAvintia() {
        Date fechaInicioComercializacionPrevista = Date.newInstance(2018, 09, 20);
        Date fechaFinComercializacionPrevista = Date.newInstance(2018, 10, 03);
        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        TestUtil.testCrearInmueblePromocion(promocion.ID);
        TestUtil.testCrearAsociacionDocumentoslViviendas(promocion.ID);
        Test.startTest();
        TestUtil.testCrearAsociacionDocumentoslPromocion(promocion.ID);
        PublicacionPortales.publicarWebAvintia(promocion.ID, false);
        PublicacionPortales.UpdateCurrIdea(promocion);
        PublicacionPortales.UpdateCurrWeb(promocion);
        Test.stopTest();

    }

    @IsTest
    static void testPublicacionPortalWebAvintiaPrueba() {
        Date fechaInicioComercializacionPrevista = Date.newInstance(2018, 09, 20);
        Date fechaFinComercializacionPrevista = Date.newInstance(2018, 10, 03);
        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        TestUtil.testCrearInmueblePromocion(promocion.ID);
        TestUtil.testCrearAsociacionDocumentoslViviendas(promocion.ID);
        Test.startTest();
        TestUtil.testCrearAsociacionDocumentoslPromocion(promocion.ID);
        PublicacionPortales.publicarWebAvintia(promocion.ID, true);
        Test.stopTest();
    }

    @IsTest
    static void testPublicacionPortalFotoCasa() {
        Date fechaInicioComercializacionPrevista = Date.newInstance(2018, 09, 20);
        Date fechaFinComercializacionPrevista = Date.newInstance(2018, 10, 03);
        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        TriggerHandler.bypass('Product2Trigger');
        TriggerHandler.bypass('PromocionTrigger');
        TestUtil.testCrearInmueblePromocion(promocion.ID);
        TestUtil.testCrearAsociacionDocumentoslViviendas(promocion.ID);
        TriggerHandler.clearAllBypasses();
        Test.startTest();
        TestUtil.testCrearAsociacionDocumentoslPromocion(promocion.ID);
        PublicacionPortales.generarXmlFotocasa(promocion.ID);
        Test.stopTest();
    }

    @IsTest
    public static void test_getProfileInfo() {
        System.assert(PublicacionPortales.getProfileInfo() != null);
    }


}