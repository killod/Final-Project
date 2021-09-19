@IsTest
global class ToDosHttpCalloutMock  implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('{"name": "Account NEW", "phone" : "80123456", "billingState" : "TX"}');
        response.setStatusCode(200);
        return response;
    }
}