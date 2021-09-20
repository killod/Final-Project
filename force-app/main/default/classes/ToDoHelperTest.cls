@IsTest
private class ToDoHelperTest {
    @IsTest
    static void fillRecordTypeTest() {
        List<ToDo__c> toDos = TestDataFactory.createDummyListOfToDos(5, 'new toDo', 'Today', false);
        Test.startTest();
        ToDoHelper.fillRecordType(toDos);
        Test.stopTest();
        for (ToDo__c toDo : toDos) {
            System.assertEquals(Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Today').getRecordTypeId(), toDo.RecordTypeId);
        }
    }


    @IsTest
    static void assignmentToDoToQueueTest() {
        List<ToDo__c> toDos = TestDataFactory.createDummyListOfToDos(5, 'new toDo', 'Later', false);
        Test.startTest();
        ToDoHelper.assignmentToDoToQueue(toDos);
        Test.stopTest();
        Group laterQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Later Queue' LIMIT 1];
        for (ToDo__c toDo : toDos) {
            System.assertEquals(laterQueue.Id, toDo.OwnerId);
        }
    }


    @IsTest
    static void deleteCalloutTest() {
        Test.setMock(HttpCalloutMock.class, new ToDosHttpDeleteCalloutMock());
        List<Id> listForDeleteById = TestDataFactory.getIdsOfDummyListOfToDos(3, 'Test', 'Today');
        List<Id> listForDeleteBySameToDoId = new List<Id>();
        Test.startTest();
        HttpResponse response = ToDoHelper.deleteCallout(listForDeleteById, listForDeleteBySameToDoId);
        Test.stopTest();
        System.assertEquals(200, response.getStatusCode());
    }


    @IsTest
    static void postCalloutTest() {
        ToDo__c toDo = TestDataFactory.createDummyToDo('Test', 'Today', true);
        List<Id> toDosId = new List<Id>();
        toDosId.add(toDo.Id);
        Test.setMock(HttpCalloutMock.class, new ToDosHttpPostCalloutMock());
        Test.startTest();
        HttpResponse response = ToDoHelper.postCallout(toDosId);
        Test.stopTest();
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json;charset=UTF-8');
        String actualValue = response.getBody();
        String expectedValue = '[ {\n' +
                '  "Name" : "Test",\n' +
                '  "Category__c" : "Today",\n' +
                '  "Completed__c" : false,\n' +
                '  "Description__c" : "",\n' +
                '  "Priority__c" : "None",\n' +
                '  "Reminder__c" : "Don’t remind me",\n' +
                '  "SameToDoId__c" : "' + toDo.Id + '"\n' +
                '} ]';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }


    @IsTest
    static void patchCalloutTest() {
        ToDo__c toDo = TestDataFactory.createDummyToDo('Test', 'Today', true);
        List<Id> toDosId = new List<Id>();
        toDosId.add(toDo.Id);
        Test.setMock(HttpCalloutMock.class, new ToDosHttpPatchCalloutMock());
        Test.startTest();
        HttpResponse response = ToDoHelper.patchCallout(toDosId);
        Test.stopTest();
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json;charset=UTF-8');
        String actualValue = response.getBody();
        String expectedValue = '[ {\n' +
                '  "Name" : "New Test",\n' +
                '  "Category__c" : "Today",\n' +
                '  "Completed__c" : true,\n' +
                '  "Description__c" : "",\n' +
                '  "Priority__c" : "None",\n' +
                '  "Reminder__c" : "Don’t remind me",\n' +
                '  "SameToDoId__c" : "' + toDo.Id + '"\n' +
                '} ]';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }
}