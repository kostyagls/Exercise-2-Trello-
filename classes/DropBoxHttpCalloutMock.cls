
@IsTest
public class DropBoxHttpCalloutMock implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/octet-stream');
        response.setStatusCode(200);
        return response;
    }
}