@IsTest
global class SubToDosHttpPatchCalloutMock implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest request) {
        SubToDo__c subToDo = [SELECT Id FROM SubToDo__c WHERE Name = 'Test' LIMIT 1];
        System.assertEquals('callout:secondOrg/services/apexrest/SubToDo__c/', request.getEndpoint());
        System.assertEquals('PATCH', request.getMethod());
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('[ {\n' +
                '  "Id" : "' + subToDo.Id + '",\n' +
                '  "Name" : "New Test",\n' +
                '  "Completed__c" : false,\n' +
                '  "Description__c" : "",\n' +
                '  "SameSubToDoId__c" : ""\n' +
                '} ]');
        response.setStatusCode(200);
        return response;
    }
}