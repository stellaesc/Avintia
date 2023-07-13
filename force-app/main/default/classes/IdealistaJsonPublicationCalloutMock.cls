@IsTest
global class IdealistaJsonPublicationCalloutMock implements HttpCallOutMock {

    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(202);
        return response; 
    }

}