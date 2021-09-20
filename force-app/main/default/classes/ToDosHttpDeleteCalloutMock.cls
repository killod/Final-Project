@IsTest
global class ToDosHttpDeleteCalloutMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        System.assertEquals('callout:secondOrg/services/apexrest/ToDo__c/', request.getEndpoint());
        System.assertEquals('DELETE', request.getMethod());
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        return response;
    }
}