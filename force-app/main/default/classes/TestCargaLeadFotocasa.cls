@isTest
public class TestCargaLeadFotocasa {
    private static PropiedadesIntegracion__c propiedades;
    static {

        propiedades = new PropiedadesIntegracion__c();

        propiedades.URL_LEAD_FOTOCASA__c = 'http://prueba.com';

        propiedades.UsuarioLeadFotocasa__c = 'usuario';
        propiedades.PasswordWSAvintia__c = '1234';
        propiedades.NumDiasLeadFotocasa__c = 1;
        propiedades.ILC_IDEALISTA__c = 'ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7';

        upsert propiedades;

    }
    @isTest
    static void testCaragarLead() {

        date fechaInicioComercializacionPrevista = date.newInstance(2018, 09, 20);
        date fechaFinComercializacionPrevista = date.newInstance(2018, 10, 03);
        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        TestUtil.testCrearInmueblePromocion(promocion.ID);

        Test.startTest();
        CargaLeadFotocasa carga = new CargaLeadFotocasa();
        carga.execute(null);
        Test.stopTest();
    }
}