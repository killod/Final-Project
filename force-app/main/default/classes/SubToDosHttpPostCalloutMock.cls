@IsTest
global class SubToDosHttpPostCalloutMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        SubToDo__c subToDo = [SELECT Id, ToDo__c FROM SubToDo__c WHERE Name = 'Test' LIMIT 1];
        System.assertEquals('callout:secondOrg/services/apexrest/SubToDo__c/', request.getEndpoint());
        System.assertEquals('POST', request.getMethod());
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('[ {\n' +
                '  "SameToDoId" : "",\n' +
                '  "SubToDo" : {\n' +
                '    "Name" : "Test",\n' +
                '    "Description__c" : "",\n' +
                '    "Completed__c" : false,\n' +
                '    "SameSubToDoId__c" : "' + subToDo.Id + '",\n' +
                '    "ToDo__c" : "' + subToDo.ToDo__c + '"\n' +
                '  }\n' +
                '} ]');
        response.setStatusCode(200);
        return response;
    }
}