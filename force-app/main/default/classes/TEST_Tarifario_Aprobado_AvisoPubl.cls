@isTest(SeeAllData=false)
public class TEST_Tarifario_Aprobado_AvisoPubl {
    
    private static PropiedadesIntegracion__c propiedades;
    static {
        
        propiedades = new PropiedadesIntegracion__c();
        propiedades.URL_WEBAVINTIA__c = 'http://prueba.com';
        propiedades.URL_WEBAVINTIA_PRO__c = 'http://prueba.com';
        propiedades.PasswordWSAvintia__c = '1234';
        propiedades.URL_AMLCHECK__c = 'http://test.test.com';
        propiedades.ILC_IDEALISTA__c = 'ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7';
        
        upsert propiedades;
        
    }
  
    @isTest
    public static  void testGenerarFactura(){
                
        User us = [SELECT Id FROM User LIMIT 1];
        
        Date fechaInicioComercializacionPrevista = Date.newInstance(2018, 09, 20);
        Date fechaFinComercializacionPrevista = Date.newInstance(2018, 10, 03);
        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
                
        Task tsk = new task();
        tsk.Type = 'Call';
        tsk.Subject = 'Other';
        tsk.Status = 'Open';
        tsk.Priority = 'Media';
        tsk.OwnerId = us.Id;
		tsk.Promocion__c = promocion.Id;
        insert tsk;
        
        Tarifario_Aprobado_AvisoPubl.pendiente(tsk.Id);
    }
    
    @IsTest
    static void testPublicacionPortalWebAvintia() {
          
        User us = [SELECT Id FROM User LIMIT 1];

        Date fechaInicioComercializacionPrevista = Date.newInstance(2018, 09, 20);
        Date fechaFinComercializacionPrevista = Date.newInstance(2018, 10, 03);
        Promocion__c promocion = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        
        Task tsk = new task();
        tsk.Type = 'Call';
        tsk.Subject = 'Other';
        tsk.Status = 'Open';
        tsk.Priority = 'Media';
		tsk.Promocion__c = promocion.Id;
        tsk.OwnerId = us.Id;
        insert tsk;
        
        TestUtil.testCrearInmueblePromocion(promocion.ID);
        TestUtil.testCrearAsociacionDocumentoslViviendas(promocion.ID);
        Test.startTest();
        TestUtil.testCrearAsociacionDocumentoslPromocion(promocion.ID);
        Tarifario_Aprobado_AvisoPubl.publicarWebAvintia(tsk.Id, true);
        Test.stopTest();

    }

    @IsTest
    static void testPublicacionPortalWebAvintiaPrueba() {
                
        User us = [SELECT Id FROM User LIMIT 1];
        
        Date fechaInicioComercializacionPrevista = Date.newInstance(2018, 09, 20);
        Date fechaFinComercializacionPrevista = Date.newInstance(2018, 10, 03);
        Promocion__c prom = TestUtil.getPromocion(fechaInicioComercializacionPrevista, fechaFinComercializacionPrevista);
        
        Task tsk = new task();
        tsk.Type = 'Call';
        tsk.Subject = 'Other';
        tsk.Status = 'Open';
        tsk.Priority = 'Media';
        tsk.OwnerId = us.Id;
        tsk.Promocion__c = prom.Id;
        insert tsk;
                
        TestUtil.testCrearInmueblePromocion(prom.ID);
        TestUtil.testCrearAsociacionDocumentoslViviendas(prom.ID);
        
        Test.startTest();
        TestUtil.testCrearAsociacionDocumentoslPromocion(prom.ID);
        Tarifario_Aprobado_AvisoPubl.publicarWebAvintia(tsk.Id, false);
        Test.stopTest();
        
    }

}