/**
 * Created by dgonzalezantona on 30/09/2019.
 */

@IsTest
public with sharing class AmlOpportunityRestV1_Test {

/*    @TestSetup
    public static void setUp() {
        TestUtil.getOportunidadDocumento_reserva_controller();
    }

    @IsTest
    public static void testHttpPostOK() {
        // Obtenemos datos necesarios
        Opportunity opp = [SELECT Id, OpportunityNumber__c FROM Opportunity WHERE Name = 'Oportunidad Test' LIMIT 1];
        System.debug('Opp Number:' + opp.OpportunityNumber__c);

        // Simulamos petición y la añadimos al contexto
        RestRequest request = new RestRequest();
        request.requestUri = '/AML/v1/Opportunity';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{ "proposalNumber": "100327", "manualStatus": "KO", "manualRisk": "P", "comments": "test1", "resolution": "test2", "conditions": "test3"}');
        RestContext.request = request;
        AmlOpportunityRestV1.setHttpRequestContext();

        // Simulamos respuesta y la añadimos al contexto
        RestContext.response = new RestResponse();
        RestContext.response.statusCode = 200;
        AmlOpportunityRestV1.setHttpResponseContext();

        // Probamos el servicio
        AmlOpportunityRestV1.httpPost();
        //System.assertEquals(201, RestContext.response.statusCode);
    }

    @IsTest
    public static void testHttpPost_EmptyParamsKO() {
        // Simulamos petición y la añadimos al contexto
        RestRequest request = new RestRequest();
        request.requestUri = '/AML/v1/Opportunity';
        request.httpMethod = 'POST';
        RestContext.request = request;
        AmlOpportunityRestV1.setHttpRequestContext();

        // Simulamos respuesta y la añadimos al contexto
        RestContext.response = new RestResponse();
        RestContext.response.statusCode = 200;
        AmlOpportunityRestV1.setHttpResponseContext();

        // Probamos el servicio
        DTT_VersionedRestService.KOResponse koResp = (DTT_VersionedRestService.KOResponse) AmlOpportunityRestV1.httpPost();
        System.assertEquals(404, RestContext.response.statusCode);
        System.assert(koResp.message.containsIgnoreCase('No se ha encontrado párametros de entrada'));

    }

    @IsTest
    public static void testHttpPost_EmptyProposalNumberKO() {
        // Simulamos petición y la añadimos al contexto
        RestRequest request = new RestRequest();
        request.requestUri = '/AML/v1/Opportunity';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{ "proposalNumber": "", "manualStatus": "KO", "manualRisk": "P", "comments": "test1", "resolution": "test2", "conditions": "test3"}');
        RestContext.request = request;
        AmlOpportunityRestV1.setHttpRequestContext();

        // Simulamos respuesta y la añadimos al contexto
        RestContext.response = new RestResponse();
        RestContext.response.statusCode = 200;
        AmlOpportunityRestV1.setHttpResponseContext();

        // Probamos el servicio
        DTT_VersionedRestService.KOResponse koResp = (DTT_VersionedRestService.KOResponse) AmlOpportunityRestV1.httpPost();
        System.assertEquals(404, RestContext.response.statusCode);
        System.assert(koResp.message.containsIgnoreCase('El parámetro proposalNumber es obligatorio'));
    }

    @IsTest
    public static void testHttpPost_NotExistProposalNumberKO() {
        // Simulamos petición y la añadimos al contexto
        RestRequest request = new RestRequest();
        request.requestUri = '/AML/v1/Opportunity';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{ "proposalNumber": "asdas", "manualStatus": "KO", "manualRisk": "P", "comments": "test1", "resolution": "test2", "conditions": "test3"}');
        RestContext.request = request;
        AmlOpportunityRestV1.setHttpRequestContext();

        // Simulamos respuesta y la añadimos al contexto
        RestContext.response = new RestResponse();
        RestContext.response.statusCode = 200;
        AmlOpportunityRestV1.setHttpResponseContext();

        // Probamos el servicio
        DTT_VersionedRestService.KOResponse koResp = (DTT_VersionedRestService.KOResponse) AmlOpportunityRestV1.httpPost();
        System.assertEquals(404, RestContext.response.statusCode);
        System.assert(koResp.message.containsIgnoreCase('No hay ninguna oportunidad con ese proposalNumber'));
    }
*/
}