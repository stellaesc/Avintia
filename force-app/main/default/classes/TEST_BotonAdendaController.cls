@isTest(SeeAllData=false)
public class TEST_BotonAdendaController {

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

        Plan_de_pagos__c planPagos = TESTUtil.getPlan_de_Pagos_controller();
        //TestUtil.getImagen();
		
        DocumentCategory__c c = new DocumentCategory__c();
        c.Level__c = 1;
        c.Code__c = '01';
        c.Name = 'Contratos de reserva viviendas';
        c.ParentDirectoryName__c = 'COMERCIAL';
        insert c;
        
        /*APXTConga4__Conga_Template__c CongaTemp = new APXTConga4__Conga_Template__c();
        CongaTemp.APXTConga4__Name__c = 'DocumentoAdendaSolution';
        insert CongaTemp;*/  
        
    }

    @IsTest 
    public static void getTipoVivienda_Test1(){
        Test.startTest();
        Plan_de_pagos__c planPagos = [SELECT Id,Oportunidad__c FROM Plan_de_pagos__c WHERE Name = 'Plan Pagos Test' LIMIT 1];
        system.debug('TEST PLAN DE PAGOS'+planPagos);
        
        BotonAdendaController.getUrl();
        //BotonAdendaController.getCongaURL(planPagos.Id);
        BotonAdendaController.generarContrato(planPagos.Oportunidad__c, 'Libre', 'VF_Documento_adenda', 'Prueba');
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :planPagos.Oportunidad__c];
        System.assert(docs.size() > 0);
       	Test.stopTest();
    }

    @IsTest
    public static void getTipoVivienda_Test2(){
        Test.startTest();
        Plan_de_pagos__c planPagos = [SELECT Id,Oportunidad__c FROM Plan_de_pagos__c WHERE Name = 'Plan Pagos Test' LIMIT 1];
        system.debug('TEST PLAN DE PAGOS'+planPagos);
        
        BotonAdendaController.getUrl();
        BotonAdendaController.generarContrato(planPagos.Oportunidad__c, 'Reserva', 'VF_Documento_reserva_conIVA', 'FichaReserva');
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :planPagos.Oportunidad__c];
        System.assert(docs.size() > 0);
        Test.stopTest();
    }

    @IsTest
    public static void getTipoVivienda_Test3(){
       	Test.startTest();
        Plan_de_pagos__c planPagos = [SELECT Id,Oportunidad__c FROM Plan_de_pagos__c WHERE Name = 'Plan Pagos Test' LIMIT 1];
        system.debug('TEST PLAN DE PAGOS'+planPagos);
           
        BotonAdendaController.getUrl();
        BotonAdendaController.generarContrato(planPagos.Oportunidad__c, 'Escrituración', 'VF_Documento_reserva_conIVA', 'FichaReserva');
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :planPagos.Oportunidad__c];
        System.assert(docs.size() > 0);
        Test.stopTest();
    }
    
    @IsTest
    public static void getTipoVivienda_Test4(){
        Test.startTest();
        Plan_de_pagos__c planPagos = [SELECT Id,Oportunidad__c FROM Plan_de_pagos__c WHERE Name = 'Plan Pagos Test' LIMIT 1];
        system.debug('TEST PLAN DE PAGOS'+planPagos);
        
        BotonAdendaController.getUrl();
        BotonAdendaController.generarContrato(planPagos.Oportunidad__c, 'Contrato', 'VF_Documento_reserva_conIVA', 'FichaReserva');
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :planPagos.Oportunidad__c];
        System.assert(docs.size() > 0);
        Test.stopTest();
    }
    
    @IsTest
    public static void getTipoVivienda_Test5(){
        Test.startTest();
        Plan_de_pagos__c planPagos = [SELECT Id,Oportunidad__c FROM Plan_de_pagos__c WHERE Name = 'Plan Pagos Test' LIMIT 1];
        system.debug('TEST PLAN DE PAGOS'+planPagos);
        
        BotonAdendaController.getUrl();
        BotonAdendaController.generarContrato(planPagos.Oportunidad__c, 'Cancelada', 'VF_Documento_reserva_conIVA', 'FichaReserva');
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :planPagos.Oportunidad__c];
        System.assert(docs.size() > 0);
        Test.stopTest();
    }
    
}