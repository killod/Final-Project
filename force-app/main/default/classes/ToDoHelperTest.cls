@IsTest
private class ToDoHelperTest {
    @IsTest
    static void fillRecordTypeTest() {
        List<ToDo__c> toDos = TestDataFactory.createDummyListOfToDos(5, 'new toDo', 'Today', false);
        Test.startTest();
        ToDoHelper.fillRecordType(toDos);
        Test.stopTest();
        for (ToDo__c toDo : toDos) {
            System.assertEquals(Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Today').getRecordTypeId(), toDo.RecordTypeId );
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


/*
    @IsTest
    static void postCalloutTest() {
        Test.setMock(HttpCalloutMock.class, new ToDosHttpCalloutMock());
        ToDo__c toDo = TestDataFactory.createDummyToDo('Test', 'Today', true);
        List<Id> toDosId = new List<Id>();
        toDosId.add(toDo.Id);

        HttpResponse response = (HttpResponse) ToDoHelper.makePostCallout(toDosId);
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue = '{"name": "Account NEW", "phone" : "80123456", "billingState" : "TX"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }
*/
}