@isTest
public class TestPublicacionBabonLab {
    
    private static PropiedadesIntegracion__c propiedades;
    
    static {
        propiedades = new PropiedadesIntegracion__c();
        propiedades.URL_BABONLAB_VIVIENDAS__c = 'http://prueba.com';
        propiedades.URL_BABONLAB_PROMOCION__c = 'http://prueba.com';
        propiedades.API_KEY_BABONLAB__c = '123456';
        propiedades.ILC_IDEALISTA__c = 'ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7';
        upsert propiedades;
    }

    @isTest
    static void testPublicacionBabonLab() {
        date fechaInicioComercializacionPrevista = date.newInstance(2018, 09, 20);
        date fechaFinComercializacionPrevista = date.newInstance(2018, 10, 03);
        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        TestUtil.testCrearInmueblePromocion2(promocion.ID);
        TestUtil.getHitos(promocion.ID);
        Test.startTest();
        PublicacionBabonlab.enviarPromocion(promocion.ID);
        PublicacionBabonlab.actualizarPromocion(promocion.ID, promocion.idPromocionBabonlab__c);
        PublicacionBabonlab.enviarViviendas(promocion.ID);
        PublicacionBabonlab.generarPeticionAltaModifVivienda(promocion.ID);
        Test.stopTest();
    }
    
    @isTest
    static void testPublicacionBabonLab2() {
        date fechaInicioComercializacionPrevista = date.newInstance(2018, 09, 20);
        date fechaFinComercializacionPrevista = date.newInstance(2018, 10, 03);
        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        TestUtil.testCrearInmueblePromocion2(promocion.ID);
        TestUtil.getHitos2(promocion.ID);
        Test.startTest();
        PublicacionBabonlab.enviarPromocion(promocion.ID);
        PublicacionBabonlab.actualizarPromocion(promocion.ID, promocion.idPromocionBabonlab__c);
        PublicacionBabonlab.enviarViviendas(promocion.ID);
        PublicacionBabonlab.generarPeticionAltaModifVivienda(promocion.ID);
        PublicacionBabonlab.actualizarViviendas(promocion.ID);
        Test.stopTest();
    }
    
    @isTest
    static void testPublicacionBabonLab3() {

        date fechaInicioComercializacionPrevista = date.newInstance(2018, 09, 20);
        date fechaFinComercializacionPrevista = date.newInstance(2018, 10, 03);
        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        TestUtil.testCrearInmueblePromocion2(promocion.ID);
        TestUtil.getHitos3(promocion.ID);
        Test.startTest();
        TriggerHandler.bypass('PromocionTrigger');
        TriggerHandler.bypass('Product2Trigger');
        PublicacionBabonlab.enviarPromocion(promocion.ID);
        PublicacionBabonlab.actualizarPromocion(promocion.ID, promocion.idPromocionBabonlab__c);
        PublicacionBabonlab.enviarViviendas(promocion.ID);
        PublicacionBabonlab.generarPeticionAltaModifVivienda(promocion.ID);
        TriggerHandler.clearAllBypasses();
        Test.stopTest();

    }

}