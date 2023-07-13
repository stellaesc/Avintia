@IsTest
public class TestIdealistaLeadManager {

    @IsTest
    public static void testCreateLeadOK() {
        Promocion__c p = TestUtil.getPromocion(Date.today(), Date.today() + 1);
        Test.startTest();
        List<Product2> inmuebles = TestUtil.testCrearInmueblePromocionWithReturn(p.Id);
        System.debug('Id promocion test: ' + p.Id);

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/IdealistaLeads/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(
            '{'+
                '"customerCode" : "ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7",'+
                '"customerProperties" : [ {'+
                        '"propertyId" : "'+inmuebles.get(0).Id+'",'+
                        '"propertyReference" : "'+inmuebles.get(0).Id+'",'+
                        '"propertyOperation" : "sale",'+
                        '"propertyLeads" : [ {'+
                                '"leadType" : "normal",'+
                                '"leadContactName" : "Test 1",'+
                                '"leadContactEmail" : "test1@test.com",'+
                                '"leadContactPhone" : "476507096",'+
                                '"leadDate" : "11/07/2018 09:02:18",'+
                                '"leadMessage" : "Could you please send me an overview of the available apartments, additional costs and the timeline for this apartment? Thank you, Els"'+
                            '},' + 
                            '{'+
                                '"leadType" : "normal",'+
                                '"leadContactName" : "Test 2",'+
                                '"leadContactEmail" : "test2@test.com",'+
                                '"leadContactPhone" : "637559778",'+
                                '"leadDate" : "11/07/2018 16:11:18",'+
                                '"leadMessage" : "Hola, me interesa esta promoción y me gustaría hacer una visita. Un saludo"'+
                            '}'+
                        ']'+
                    '}'+
                ']'+
            '}'
        );

        RestContext.request = request;
        RestContext.response = response;
        IdealistaLeadManager.createLead();

        System.assertEquals(201, RestContext.response.statusCode);
        Test.stopTest();
    }

    @IsTest 
    public static void testCreateLeadKO1() {
        Promocion__c p = TestUtil.getPromocion(Date.today(), Date.today() + 1);
        Test.startTest();
        List<Product2> inmuebles = TestUtil.testCrearInmueblePromocionWithReturn(p.Id);
        System.debug('Id promocion test: ' + p.Id);

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/IdealistaLeads/';
        request.httpMethod = 'POST';

        RestContext.request = request;
        RestContext.response = response;

        try {
            IdealistaLeadManager.createLead();
        } catch(Exception e) {
            System.assert(e.getMessage().contains('JSON no encontrado'));
        }
        Test.stopTest();
    }

    @IsTest 
    public static void testCreateLeadKO2() {
        Promocion__c p = TestUtil.getPromocion(Date.today(), Date.today() + 1);
        Test.startTest();
        List<Product2> inmuebles = TestUtil.testCrearInmueblePromocionWithReturn(p.Id);
        System.debug('Id promocion test: ' + p.Id);

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/IdealistaLeads/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(
            '{'+
                '"customerCode" : "ilc1f58c0cc5ad3dd64528c6ae121a8de8a11a8a4f7",'+
                '"customerProperties" : [ {'+
                        '"propertyId" : "'+inmuebles.get(0).Id+'",'+
                        '"propertyReference" : "'+inmuebles.get(0).Id+'",'+
                        '"propertyOperation" : "sale",'+
                        '"propertyLeads" : [ {'+
                                '"leadType" : "normal",'+
                                '"leadContactName" : "Test 1",'+
                                '"leadContactEmail" : "test1@test.com",'+
                                '"leadContactPhone" : "476507096",'+
                                '"leadDate" : "11/07/2018 09:02:18",'+
                                '"leadMessage" : "Could you please send me an overview of the available apartments, additional costs and the timeline for this apartment? Thank you, Els"'+
                            '},' + 
                            '{'+
                                '"leadType" : "normal",'+
                                '"leadContactName" : "Test 2",'+
                                '"leadContactEmail" : "test2@test.com",'+
                                '"leadContactPhone" : "637559778",'+
                                '"leadDate" : "11/07/2018 16:11:18",'+
                                '"leadMessage" : "Hola, me interesa esta promoción y me gustaría hacer una visita. Un saludo"'+
                            '}'+
                        ']'+
                    '}'+
            '}'
        );

        RestContext.request = request;
        RestContext.response = response;

        try {
            IdealistaLeadManager.createLead();
        } catch(Exception e) {
            System.assert(e.getMessage().contains('Error:'));
        }
        Test.stopTest();
    }
}