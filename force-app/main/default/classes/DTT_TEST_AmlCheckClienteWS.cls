@IsTest
public with sharing class DTT_TEST_AmlCheckClienteWS {

    /*@TestSetUp
    private static void setUp() {
        CNO__c cnoObj = new CNO__c(
            Codigo__c = '1212',
            Name = 'CNO TEST',
            FullName__c = 'CNO TEST'
        );
        insert cnoObj;

        Pais__c pais = new Pais__c();
        pais.name = 'España';
        pais.Codigo_ISO3__c='ESP';
        insert pais;

        Comunidad_Autonoma__c comunidadAutonoma = new Comunidad_Autonoma__c();
        comunidadAutonoma.name = 'Madrid';
        comunidadAutonoma.Pais__c = pais.id;
        
        insert comunidadAutonoma;

        Provincia__c provincia = new Provincia__c();
        provincia.name = 'Madrid';
        provincia.Codigo__c=8;
        provincia.Comunidad_autonoma__c = comunidadAutonoma.id;
        
        
        insert provincia;

        Municipio__c localidad = new Municipio__c();
        localidad.name = 'Madrid';
        localidad.Codigo_municipio__c = 28;

        localidad.provincia__c = provincia.id;
        
        insert localidad;

        Account cuenta = new Account();
        cuenta.name = 'Cuenta test1';
        cuenta.Movil_empresa__c = '660112233';
        cuenta.Email__c = 'test@test.test';
        cuenta.Tipo_de_documento__c = 'NIF';
        cuenta.N_Documento__c = '00000001A';
        cuenta.AccountSource = 'Caseta';
        cuenta.Nacionalidad__c = pais.Id;
        cuenta.Fecha_constitucion__c = date.newInstance(2018, 3, 13);
        
        //Dirección fiscal
        cuenta.Tipo_de_via_FISCAL__c = 'Calle';
        cuenta.Puerta_FISCAL__c = 'a';
        cuenta.Nombre_de_via_FISCAL__c = 'via';
        cuenta.N_via_FISCAL__c = 4;
        cuenta.Pais_FISCAL__c = pais.Id;
        cuenta.Localidad_FISCAL__c = localidad.Id;
        cuenta.Escalera_FISCAL__c = 'a';
        cuenta.Codigo_postal_FISCAL__c = '23456';
        //Dirección de facturación
        cuenta.DF_Tipo_de_via__c = 'Calle';
        cuenta.DF_Puerta__c = 'a';
        cuenta.DF_Nombre_via__c = 'via';
        cuenta.DF_N_via__c = 4;
        cuenta.DF_Pais__c = pais.Id;
        cuenta.DF_Localidad__c = localidad.Id;
        cuenta.DF_Escalera__c = 'a';
        cuenta.DF_Codigo_postal__c = '23456';
        //Dirección de facturación
        cuenta.DP_Tipo_de_via__c = 'Calle';
        cuenta.DP_Puerta__c = 'a';
        cuenta.DP_Nombre_via__c = 'via';
        cuenta.DP_N_via__c = 4;
        cuenta.DP_Pais__c = pais.Id;
        cuenta.DP_Localidad__c = localidad.Id;
        cuenta.DP_Escalera__c = 'a';
        cuenta.DP_Codigo_postal__c = '23456';
        cuenta.CNO__c = cnoObj.Id;
        
        //
        cuenta.tomo__c = '1';
        cuenta.Seccion__c ='2';
        cuenta.Folio__c ='3';
        cuenta.N_Hoja__c ='4';
        
        AccountTriggerHandler.bypass('AccountTriggerHandler');
        insert cuenta;
        TriggerHandler.clearBypass('AccountTriggerHandler');

        PropiedadesIntegracion__c propiedades = new PropiedadesIntegracion__c(
            UsuarioAMLCHECK__c = 'AVINTIA',
            PasswordAMLCHECK__c = 'Qn5sv8gZ',
            URL_AMLCHECK__c = 'http://test.test.com',
            ILC_IDEALISTA__c = 'ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7'
        );
        insert propiedades;
    }

    @IsTest
    private static void testOnboardingOK() {
        Test.StartTest();
        AmlCheckClienteWS.AmlCheckParams params = new AmlCheckClienteWS.AmlCheckParams();
        params.orisys = 'ADI-CRM';
		params.persnume = '001n000000WRzgOAAT';
		params.perscodi = 'F';
		params.persiden = '00000001A';
		params.apellido1 = 'TESTING';
		params.apellido2 = 'TESTING2';
		params.nombre = 'Test';
		params.gender = 'H';
		params.persnaci = 'ESP';
		params.persnaci2 = '';
		params.persnac = 'ESP';
		params.perspais = 'ESP';
		params.perspais2 = '';
		params.persfiju = 'F';
		params.persfnac = '1973-05-17';
		params.usertokenid = '';

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AmlCheckOnboardRequestOK');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/xml');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);

        AmlCheckClienteWS service = new AmlCheckClienteWS();
        AmlCheckClienteWS.Respuesta respuesta = service.onboarding(params);

        System.assert(respuesta.returnCode == '0');
        System.assert(respuesta.returnCodeDescription == '');
        System.assert(respuesta.persiden == '11031001');
        System.assert(respuesta.idalerta == '0');
        System.assert(respuesta.idevidencia == '0');
        Test.StopTest();
    }

    @IsTest
    private static void testOnboardingKO() {
        Test.StartTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AmlCheckOnboardRequestOK');
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);

        AmlCheckClienteWS.AmlCheckParams params = new AmlCheckClienteWS.AmlCheckParams();
        params.orisys = 'ADI-CRM';
		params.persnume = '001n000000WRzgOAAT';
		params.perscodi = 'F';
		params.persiden = '00000001A';
		params.apellido1 = 'TESTING';
		params.apellido2 = 'TESTING2';
		params.nombre = 'Test';
		params.gender = 'H';
		params.persnaci = 'ESP';
		params.persnaci2 = '';
		params.persnac = 'ESP';
		params.perspais = 'ESP';
		params.perspais2 = '';
		params.persfiju = 'F';
		params.persfnac = '1973-05-17';
		params.usertokenid = '';

        AmlCheckClienteWS service = new AmlCheckClienteWS();
        AmlCheckClienteWS.Respuesta respuesta = service.onboarding(params);
        System.assert(respuesta == null);
        Test.StopTest();
    }

    @IsTest
    private static void testOnboadingRBAOK() {
        Test.StartTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AmlCheckOnboardRBARequestOK');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);

        AmlCheckClienteWS.AmlCheckParams params = new AmlCheckClienteWS.AmlCheckParams();
        params.orisys = 'ADI-CRM';
		params.persnume = '001n000000WRzgOAAT';
		params.perscodi = 'F';
		params.persiden = '0000001G';
		params.apellido1 = 'TESTING';
		params.apellido2 = 'TESTING2';
		params.nombre = 'Test';
		params.gender = 'H';
		params.persnaci = 'ESP';
		params.persnaci2 = '';
		params.persnac = 'ESP';
		params.perspais = 'ESP';
		params.perspais2 = '';
		params.persfiju = 'F';
		params.persfnac = '1973-05-17';
		params.usertokenid = '';

        AmlCheckClienteWS service = new AmlCheckClienteWS();
        AmlCheckClienteWS.Respuesta respuesta = service.onboardingRBA(params, true);
        System.assert(respuesta.returnCode == '0');
        System.assert(respuesta.returnCodeDescription == '');
        System.assert(respuesta.persiden == '0000001G');
        System.assert(respuesta.idalerta == '0');
        System.assert(respuesta.idevidencia == '0');
        System.assert(respuesta.rbalevel == 'risk.2.medium');
        Test.StopTest();
    }

    @IsTest
    private static void testOnboadingRBAKO() {
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AmlCheckOnboardRBARequestOK');
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);

        AmlCheckClienteWS.AmlCheckParams params = new AmlCheckClienteWS.AmlCheckParams();
        params.orisys = 'ADI-CRM';
		params.persnume = '001n000000WRzgOAAT';
		params.perscodi = 'F';
		params.persiden = '0000001G';
		params.apellido1 = 'TESTING';
		params.apellido2 = 'TESTING2';
		params.nombre = 'Test';
		params.gender = 'H';
		params.persnaci = 'ESP';
		params.persnaci2 = '';
		params.persnac = 'ESP';
		params.perspais = 'ESP';
		params.perspais2 = '';
		params.persfiju = 'F';
		params.persfnac = '1973-05-17';
		params.usertokenid = '';

        AmlCheckClienteWS service = new AmlCheckClienteWS();
        AmlCheckClienteWS.Respuesta respuesta = service.onboardingRBA(params, true);
        System.assert(respuesta == null);
        Test.stopTest();
    }

    @IsTest
    private static void testGetClientOK() {
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockGetClientOKImpl());
            AmlCheckClienteWS.AmlCheckParams params = new AmlCheckClienteWS.AmlCheckParams();
            params.orisys = 'ADI-CRM';
            params.persnume = '001n000000WRzgOAAT';
            params.perscodi = 'F';
            params.persiden = '0000001G';
            params.apellido1 = 'TESTING';
            params.apellido2 = 'TESTING2';
            params.nombre = 'Test';
            params.gender = 'H';
            params.persnaci = 'ESP';
            params.persnaci2 = '';
            params.persnac = 'ESP';
            params.perspais = 'ESP';
            params.perspais2 = '';
            params.persfiju = 'F';
            params.persfnac = '1973-05-17';
            params.usertokenid = '';
            AmlCheckClienteWS.Respuesta respuesta = AmlCheckClienteWS.getClient(params);
        Test.stopTest();
        System.assert(respuesta.returnCode == '1');
        System.assert(respuesta.returnCodeDescription == 'Screening alert found : 20285');
        System.assert(respuesta.idalerta == '20285');
        System.assert(respuesta.idevidencia == '69083');
        System.assert(respuesta.rbalevel == 'risk.1.low');
    }

    @IsTest
    private static void testGetClientKO() {
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockGetClientNoExistKOImpl());
            AmlCheckClienteWS.AmlCheckParams params = new AmlCheckClienteWS.AmlCheckParams();
            params.orisys = 'ADI-CRM';
            params.persnume = '001n000000WRzgOAAT';
            params.perscodi = 'F';
            params.persiden = '0000001G';
            params.apellido1 = 'TESTING';
            params.apellido2 = 'TESTING2';
            params.nombre = 'Test';
            params.gender = 'H';
            params.persnaci = 'ESP';
            params.persnaci2 = '';
            params.persnac = 'ESP';
            params.perspais = 'ESP';
            params.perspais2 = '';
            params.persfiju = 'F';
            params.persfnac = '1973-05-17';
            params.usertokenid = '';
            AmlCheckClienteWS.Respuesta respuesta = AmlCheckClienteWS.getClient(params);
        Test.stopTest();
        System.assert(respuesta.returnCode == '78');
        System.assert(respuesta.returnCodeDescription == 'Error, client does not exit.');
    }

    @IsTest
    public static void testInsertarLog() {
        Id accId = [SELECT Id FROM Account WHERE Name = 'Cuenta test1'].Id;

        String nombreMetodo = 'AltaClientesOnboarding';
        String idCuenta = accId;
        String mensajeEnviado = 'TEST';
        String resultado = 'OK';
        AmlCheckClienteWS.insertarLog(nombreMetodo, idCuenta, mensajeEnviado, resultado);

        Log__c log = [SELECT Id, Aplicacion__c, Name, Identificador__c, MensajeEnviado__c, MensajeRecibido__c FROM Log__c LIMIT 1];
        System.assertEquals('AMLCHECK', log.Aplicacion__c);
        System.assertEquals(nombreMetodo, log.Name);
        System.assertEquals(accId, log.Identificador__c);
        System.assertEquals(mensajeEnviado, log.MensajeEnviado__c);
        System.assertEquals(resultado, log.MensajeRecibido__c);
    }

    @IsTest
    public static void testDocTypeMapping() {
        String type;

        type = AmlCheckClienteWS.docTypeMapping('NIF');
        System.assert(type == 'F');

        type = AmlCheckClienteWS.docTypeMapping('CIF');
        System.assert(type == 'C');

        type = AmlCheckClienteWS.docTypeMapping('NIE');
        System.assert(type == 'N');

        type = AmlCheckClienteWS.docTypeMapping('Pasaporte');
        System.assert(type == 'P');

        type = AmlCheckClienteWS.docTypeMapping('Otro');
        System.assert(type == 'O');
    }

    @IsTest
    public static void testGenderMapping() {
        String gender;
        gender = AmlCheckClienteWS.genderMapping('Hombre');
        System.assert(gender == 'H');

        gender = AmlCheckClienteWS.genderMapping('Mujer');
        System.assert(gender == 'M');

        gender = AmlCheckClienteWS.genderMapping('asdas');
        System.assert(gender == null);
    }

    public class HttpCalloutMockGetClientOKImpl implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            String responseBody = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+
                                    '<SOAP-ENV:Header/>'+
                                        '<SOAP-ENV:Body>'+
                                            '<ns3:getClientResponse xmlns:ns2="http://www.amlcheck.es/ws/clientbase/v1" xmlns:ns3="http://www.amlcheck.es/ws/client/v1">'+
                                                '<ns2:returnCode>1</ns2:returnCode>'+
                                                '<ns2:returnCodeDescription>Screening alert found : 20285</ns2:returnCodeDescription>'+
                                                '<ns2:persnume>001M000001CbCVQIA3</ns2:persnume>'+
                                                '<ns2:perscodi>P</ns2:perscodi>'+
                                                '<ns2:persiden>5464921</ns2:persiden>'+
                                                '<ns2:idalerta>20285</ns2:idalerta>'+
                                                '<ns2:idevidencia>69083</ns2:idevidencia>'+
                                                '<ns2:rbalevel>risk.1.low</ns2:rbalevel>'+
                                                '<ns2:rbarulecode/>' +
                                                '<ns2:rbarulecodedesc/>' +
                                                '<ns3:pendingScrAlerts>1</ns3:pendingScrAlerts>'+
                                                '<ns3:manualGlobalRisk>risk.1.low</ns3:manualGlobalRisk>'+
                                                '<ns3:higherReasonGroup>1</ns3:higherReasonGroup>'+
                                            '</ns3:getClientResponse>'+
                                        '</SOAP-ENV:Body>'+
                                    '</SOAP-ENV:Envelope>';

            HttpResponse res = new HttpResponse();
            res.setBody(responseBody);
            res.setHeader('Content-Type', 'text/xml');
            res.setStatusCode(200);
            return res;
        }
    }

    public class HttpCalloutMockGetClientNoExistKOImpl implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            String responseBody = '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+
                                    '<SOAP-ENV:Header/>'+
                                        '<SOAP-ENV:Body>'+
                                            '<ns3:getClientResponse xmlns:ns2="http://www.amlcheck.es/ws/clientbase/v1" xmlns:ns3="http://www.amlcheck.es/ws/client/v1">'+
                                                '<ns2:returnCode>78</ns2:returnCode>'+
                                                '<ns2:returnCodeDescription>Error, client does not exit.</ns2:returnCodeDescription>'+
                                                '<ns2:idalerta>0</ns2:idalerta>'+
                                                '<ns2:idevidencia>0</ns2:idevidencia>'+
                                            '</ns3:getClientResponse>'+
                                        '</SOAP-ENV:Body>'+
                                    '</SOAP-ENV:Envelope>';

            HttpResponse res = new HttpResponse();
            res.setBody(responseBody);
            res.setHeader('Content-Type', 'text/xml');
            res.setStatusCode(200);
            return res;
        }
    }

    public class HttpCalloutMockGetClientKOImpl implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            String responseBody = '';

            HttpResponse res = new HttpResponse();
            res.setBody(responseBody);
            res.setHeader('Content-Type', 'text/xml');
            res.setStatusCode(400);
            return res;
        }
    }*/
}