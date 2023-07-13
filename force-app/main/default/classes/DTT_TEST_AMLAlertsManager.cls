@IsTest
public with sharing class DTT_TEST_AMLAlertsManager {

    /*public static final String rows = 'ID|ALERTSCRTYPE|STATUS|CREATIONDATE|FECUPDATE|PERSNUME|PERSIDEN|PERSCODI|CONFIRMED|PUBLICCOMMENTS\n' + 
                          '01|alerttype.webservice|OPEN|10/12/2018 12:59:54|10/12/2018 12:59:54|PRU0001A|0000001A|P|SI|Falso positivo\n';

    @TestSetUp
    public static void setUp() {
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
        
        insert cuenta;
    }

    @IsTest
    public static void testCreateAlertOK() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/AmlAlerts/v1/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(rows);
        RestContext.request = request;
        RestContext.response = response;

        AmlAlertsManagerV1.createAlert();
        System.assert(response.statusCode == 201);
        
        List<AML_Alerts__c> alerts = [SELECT Id FROM AML_Alerts__c];
        System.assert(alerts.size() > 0);
    }

    @IsTest
    public static void testCreateAlertKO1() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/AmlAlerts/v1/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('ID|ALERTSCRTYPE|STATUS|CREATIONDATE|FECUPDATE|PERSNUME|PERSIDEN|PERSCODI|CONFIRMED|PUBLICCOMMENTS\n');
        RestContext.request = request;
        RestContext.response = response;
        AmlAlertsManagerV1.createAlert();
        System.assert(response.statusCode == 201);
        
        List<AML_Alerts__c> alerts = [SELECT Id FROM AML_Alerts__c];
        System.assert(alerts.size() == 0);
    }
    
    @IsTest
    public static void testCreateAlertKO2() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = System.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/AmlAlerts/v1/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('ID|ALERTSCRTYPE|STATUS|CREATIONDATE|FECUPDATE|PERSNUME|PERSIDEN|PERSCODI|CONFIRMED|PUBLICCOMMENTS\n | ');
        RestContext.request = request;
        RestContext.response = response;
        AmlAlertsManagerV1.createAlert();
        System.assert(response.statusCode == 404);
        
        List<AML_Alerts__c> alerts = [SELECT Id FROM AML_Alerts__c];
        System.assert(alerts.size() == 0);
    }*/
}