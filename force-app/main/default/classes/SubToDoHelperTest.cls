@IsTest
private class SubToDoHelperTest {

    @IsTest
    static void deleteCalloutTest() {
        Test.setMock(HttpCalloutMock.class, new SubToDoHttpDeleteCalloutMock());
        List<Id> listForDeleteById = TestDataFactory.getIdsOfDummyListOfSubToDos(3, 'Test');
        List<Id> listForDeleteBySameSubToDoId = new List<Id>();
        Test.startTest();
        HttpResponse response = SubToDoHelper.deleteCallout(listForDeleteById, listForDeleteBySameSubToDoId);
        Test.stopTest();
        System.assertEquals(200, response.getStatusCode());
    }


    @IsTest
    static void postCalloutTest() {
        SubToDo__c subToDo = TestDataFactory.createDummySubToDo('Test', true);
        List<Id> subToDosId = new List<Id>();
        subToDosId.add(subToDo.Id);
        Test.setMock(HttpCalloutMock.class, new SubToDosHttpPostCalloutMock());
        Test.startTest();
        HttpResponse response = SubToDoHelper.postCallout(subToDosId);
        Test.stopTest();
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json;charset=UTF-8');
        String actualValue = response.getBody();
        String expectedValue = '[ {\n' +
                '  "SameToDoId" : "",\n' +
                '  "SubToDo" : {\n' +
                '    "Name" : "Test",\n' +
                '    "Description__c" : "",\n' +
                '    "Completed__c" : false,\n' +
                '    "SameSubToDoId__c" : "' + subToDo.Id + '",\n' +
                '    "ToDo__c" : "' + subToDo.ToDo__c + '"\n' +
                '  }\n' +
                '} ]';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }


    @IsTest
    static void patchCalloutTest() {
        SubToDo__c subToDo = TestDataFactory.createDummySubToDo('Test', true);
        List<Id> subToDosId = new List<Id>();
        subToDosId.add(subToDo.Id);
        Test.setMock(HttpCalloutMock.class, new SubToDosHttpPatchCalloutMock());
        Test.startTest();
        HttpResponse response = SubToDoHelper.patchCallout(subToDosId);
        Test.stopTest();
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json;charset=UTF-8');
        String actualValue = response.getBody();
        String expectedValue = '[ {\n' +
                '  "Id" : "' + subToDo.Id + '",\n' +
                '  "Name" : "New Test",\n' +
                '  "Completed__c" : false,\n' +
                '  "Description__c" : "",\n' +
                '  "SameSubToDoId__c" : ""\n' +
                '} ]';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }
}