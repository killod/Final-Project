@IsTest
global class SubToDoHttpDeleteCalloutMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        System.assertEquals('callout:secondOrg/services/apexrest/SubToDo__c/', request.getEndpoint());
        System.assertEquals('DELETE', request.getMethod());
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        return response;
    }
}

