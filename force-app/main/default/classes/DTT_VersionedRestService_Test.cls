@IsTest
public class DTT_VersionedRestService_Test {

    private static String endpointUrl = 'https://yourInstance.salesforce.com/services/apexrest/TEST/v1/TEST';

    @IsTest
    public static void testHttpGet() {
        Test.startTest();
        DTT_VersionedRestService.KOResponse resp = (DTT_VersionedRestService.KOResponse) DTT_VersionedRestService.httpGet();
        System.assertEquals('No existe esa versión del servicio. Por favor consume una versión existente', resp.message);
        Test.stopTest();
    }

    @IsTest
    public static void testHttpPost() {
        Test.startTest();
        DTT_VersionedRestService.KOResponse resp = (DTT_VersionedRestService.KOResponse) DTT_VersionedRestService.httpPost();
        System.assertEquals('No existe esa versión del servicio. Por favor consume una versión existente', resp.message);
        Test.stopTest();
    }

    @IsTest
    public static void testHttpPut() {
        Test.startTest();
        DTT_VersionedRestService.KOResponse resp = (DTT_VersionedRestService.KOResponse) DTT_VersionedRestService.httpPut();
        System.assertEquals('No existe esa versión del servicio. Por favor consume una versión existente', resp.message);
        Test.stopTest();
    }

    @IsTest
    public static void testHttpPatch() {
        Test.startTest();
        DTT_VersionedRestService.KOResponse resp = (DTT_VersionedRestService.KOResponse) DTT_VersionedRestService.httpPatch();
        System.assertEquals('No existe esa versión del servicio. Por favor consume una versión existente', resp.message);
        Test.stopTest();
    }

    @IsTest
    public static void testHttpDelete() {
        Test.startTest();
        DTT_VersionedRestService.KOResponse resp = (DTT_VersionedRestService.KOResponse) DTT_VersionedRestService.httpDelete();
        System.assertEquals('No existe esa versión del servicio. Por favor consume una versión existente', resp.message);
        Test.stopTest();
    }

    @IsTest
    public static void testSetHttpRequestContext() {
        Test.startTest();

        RestRequest request = new RestRequest();
        request.requestUri = endpointUrl;
        request.httpMethod = 'GET';
        RestContext.request = request;

        DTT_VersionedRestService.setHttpRequestContext();
        System.assertEquals(request, DTT_VersionedRestService.sRestRequest);
        
        Test.stopTest();
    }

    @IsTest
    public static void testSetHttpResponseContext() {
        Test.startTest();
        RestContext.response = new RestResponse();
        RestContext.response.statusCode = 200;
        DTT_VersionedRestService.setHttpResponseContext();
        System.assertEquals(RestContext.response, DTT_VersionedRestService.sRestResponse);
        Test.stopTest();
    }

    @IsTest
    public static void testAddHttpResponseHeader() {
        Test.startTest();
        RestContext.response = new RestResponse();
        RestContext.response.statusCode = 200;
        DTT_VersionedRestService.setHttpResponseContext();
        DTT_VersionedRestService.addHttpResponseHeader('Content-type', 'application/xml');
        System.assertEquals('application/xml', DTT_VersionedRestService.sRestResponse.headers.get('Content-type'));
        Test.stopTest();
    }

    @IsTest
    public static void testSetHttpGetParams() {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri = endpointUrl;
        request.httpMethod = 'GET';
        request.params.put('test', '1');
        RestContext.request = request;
        DTT_VersionedRestService.setHttpRequestContext();
        DTT_VersionedRestService.setHttpGetParams(new List<String>{ 'test' });
        System.assertEquals('1', DTT_VersionedRestService.httpParameters.get('test'));
        Test.stopTest();
    }

    @IsTest
    public static void testGetHttpGetParam() {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri = endpointUrl;
        request.httpMethod = 'GET';
        request.params.put('test', '1');
        RestContext.request = request;
        DTT_VersionedRestService.setHttpRequestContext();
        DTT_VersionedRestService.setHttpGetParams(new List<String>{ 'test' });
        String num = (String) DTT_VersionedRestService.getHttpGetParam('test');
        System.assertEquals('1', num);
        Test.stopTest();
    }

    @IsTest
    public static void testSetHttpPostJSONParams() {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri = endpointUrl;
        request.httpMethod = 'POST';
        RestContext.request = request;
        DTT_VersionedRestService.setHttpRequestContext();
        DTT_VersionedRestService.sRestRequest.requestBody = Blob.valueOf('{}');
        RestContext.request = request;
        DTT_VersionedRestService.setHttpPostJSONParams();
        Test.stopTest();
    }

    @IsTest
    public static void testGetHttpPostParams() {
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri = endpointUrl;
        request.httpMethod = 'POST';
        RestContext.request = request;
        DTT_VersionedRestService.setHttpRequestContext();
        DTT_VersionedRestService.sRestRequest.requestBody = Blob.valueOf('{}');
        RestContext.request = request;
        DTT_VersionedRestService.setHttpPostJSONParams();
        DTT_VersionedRestRequestParameters params = DTT_VersionedRestService.getHttpPostParams();
        System.assert(params != null);
        Test.stopTest();
    }

    @IsTest
    public static void testSetHttpResponseStatusCode() {
        Test.startTest();
        RestContext.response = new RestResponse();
        DTT_VersionedRestService.setHttpResponseContext();
        DTT_VersionedRestService.setHttpResponseStatusCode(400);
        System.assertEquals(400, DTT_VersionedRestService.sRestResponse.statusCode);
        Test.stopTest();
    }

    @IsTest
    public static void testGetKOResponse() {
        Test.startTest();
        DTT_VersionedRestService.KOResponse response = (DTT_VersionedRestService.KOResponse) DTT_VersionedRestService.getKOResponse();
        System.assertEquals('No existe esa versión del servicio. Por favor consume una versión existente', response.message);
        Test.stopTest();
    }

    @IsTest
    public static void testGetNotImplementedResponse() {
        Test.startTest();
        DTT_VersionedRestService.KOResponse response = (DTT_VersionedRestService.KOResponse) DTT_VersionedRestService.getNotImplementedResponse();
        System.assertEquals('Método no implementado aún.', response.message);
        Test.stopTest();
    }
}