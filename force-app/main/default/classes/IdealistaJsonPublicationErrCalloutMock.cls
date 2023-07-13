@IsTest
global class IdealistaJsonPublicationErrCalloutMock implements HttpCallOutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(500);
        return response; 
    }
}