@IsTest
global class ToDosHttpPatchCalloutMock implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest request) {
        ToDo__c toDo = [SELECT Id FROM ToDo__c WHERE Name = 'Test' LIMIT 1];
        System.assertEquals('callout:secondOrg/services/apexrest/ToDo__c/', request.getEndpoint());
        System.assertEquals('PATCH', request.getMethod());
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('[ {\n' +
                '  "Name" : "New Test",\n' +
                '  "Category__c" : "Today",\n' +
                '  "Completed__c" : true,\n' +
                '  "Description__c" : "",\n' +
                '  "Priority__c" : "None",\n' +
                '  "Reminder__c" : "Don’t remind me",\n' +
                '  "SameToDoId__c" : "' + toDo.Id + '"\n' +
                '} ]');
        response.setStatusCode(200);
        return response;
    }
}