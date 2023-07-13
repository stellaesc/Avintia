@IsTest
public class BotonReservaController_Test {

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

        Opportunity oportunidad = TESTUtil.getOportunidad_Contrato_Compraventa_VPO_controller();

        DocumentCategory__c c = new DocumentCategory__c();
        c.Level__c = 1;
        c.Code__c = '01';
        c.Name = 'Contratos de reserva viviendas';
        c.ParentDirectoryName__c = 'COMERCIAL';
        insert c;
    }

    @IsTest 
    public static void getTipoVivienda_Test1() {
        Test.startTest();
        Opportunity oportunidad = [SELECT Id FROM Opportunity WHERE Name = 'Oportunidad Test' LIMIT 1];
        system.debug('TEST OPORTUNIDAD VPO'+oportunidad);

        PageReference pageRef = Page.VF_Documento_reserva_conIVA;
        pageRef.getParameters().put('id', oportunidad.id);
        System.debug('Oportunidad Id Test: ' + oportunidad.Id);
           
        Test.setCurrentPage(pageRef);
        
        String tipoVivienda = BotonReservaController.getTipoVivienda(oportunidad.Id);
        String tipoInmueble = BotonReservaController.getTipoInmueble(oportunidad.Id);

        BotonReservaController.generarContrato(oportunidad.Id, 'Libre', 'VF_Documento_reserva_conIVA', 'Prueba');
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :oportunidad.Id];
        System.assert(docs.size() > 0);

        BotonReservaController.generarFacturaAbono(oportunidad.Id);
        Test.stopTest();
        
    }

    @IsTest
    public static void getTipoVivienda_Test2() {
        Test.startTest();
        Opportunity oportunidad = [SELECT Id FROM Opportunity WHERE Name = 'Oportunidad Test' LIMIT 1];
        system.debug('TEST OPORTUNIDAD VPO'+oportunidad);

        PageReference pageRef = Page.VF_Documento_reserva_conIVA;
        pageRef.getParameters().put('id', oportunidad.id);
           
        Test.setCurrentPage(pageRef);
        
        String tipoVivienda = BotonReservaController.getTipoVivienda(oportunidad.Id);
        String tipoInmueble = BotonReservaController.getTipoInmueble(oportunidad.Id);

        BotonReservaController.generarContrato(oportunidad.Id, 'Reserva', 'VF_Documento_reserva_conIVA', 'FichaReserva');
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :oportunidad.Id];
        System.assert(docs.size() > 0);
        Test.stopTest();

    }

    @IsTest
    public static void getTipoVivienda_Test3() {
        Test.startTest();
        Opportunity oportunidad = [SELECT Id FROM Opportunity WHERE Name = 'Oportunidad Test' LIMIT 1];
        system.debug('TEST OPORTUNIDAD VPO'+oportunidad);

        PageReference pageRef = Page.VF_Documento_reserva_conIVA;
        pageRef.getParameters().put('id', oportunidad.id);
           
        Test.setCurrentPage(pageRef);
        
        String tipoVivienda = BotonReservaController.getTipoVivienda(oportunidad.Id);
        String tipoInmueble = BotonReservaController.getTipoInmueble(oportunidad.Id);

        BotonReservaController.generarContrato(oportunidad.Id, 'Escrituración', 'VF_Documento_reserva_conIVA', 'FichaReserva');
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :oportunidad.Id];
        System.assert(docs.size() > 0);
        Test.stopTest();

    }

    @IsTest
    public static void getTipoVivienda_Test4() {
        Test.startTest();
        Opportunity oportunidad = [SELECT Id FROM Opportunity WHERE Name = 'Oportunidad Test' LIMIT 1];
        system.debug('TEST OPORTUNIDAD VPO'+oportunidad);

        PageReference pageRef = Page.VF_Documento_reserva_conIVA;
        pageRef.getParameters().put('id', oportunidad.id);
           
        Test.setCurrentPage(pageRef);
        
        String tipoVivienda = BotonReservaController.getTipoVivienda(oportunidad.Id);
        String tipoInmueble = BotonReservaController.getTipoInmueble(oportunidad.Id);

        BotonReservaController.generarContrato(oportunidad.Id, 'Contrato', 'VF_Documento_reserva_conIVA', 'FichaReserva');
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :oportunidad.Id];
        System.assert(docs.size() > 0);
        Test.stopTest();
    }

    @IsTest
    public static void getTipoVivienda_Test5() {
        Test.startTest();
        Opportunity oportunidad = [SELECT Id FROM Opportunity WHERE Name = 'Oportunidad Test' LIMIT 1];
        system.debug('TEST OPORTUNIDAD VPO'+oportunidad);

        PageReference pageRef = Page.VF_Documento_reserva_conIVA;
        pageRef.getParameters().put('id', oportunidad.id);
           
        Test.setCurrentPage(pageRef);
        
        String tipoVivienda = BotonReservaController.getTipoVivienda(oportunidad.Id);
        String tipoInmueble = BotonReservaController.getTipoInmueble(oportunidad.Id);

        BotonReservaController.generarContrato(oportunidad.Id, 'Cancelada', 'VF_Documento_reserva_conIVA', 'FichaReserva');
        List<ContentDocumentLink> docs = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :oportunidad.Id];
        System.assert(docs.size() > 0);
        Test.stopTest();
    }

    
}