@IsTest
private class ToDoTriggerHandlerTest {

    @IsTest
    static void handleBeforeUpdateTest() {
        List<ToDo__c> toDos = TestDataFactory.createDummyListOfToDos(1, 'Test Today', 'Tomorrow', false);
        ToDo__c toDoToday = TestDataFactory.createDummyToDo('Test Later', 'Today', false);
        ToDo__c toDoLater = TestDataFactory.createDummyToDo('Test Tomorrow', 'Later', false);
        toDos.add(toDoToday);
        toDos.add(toDoLater);
        insert toDos;
        toDos.get(0).Category__c = 'Today';
        toDos.get(1).Category__c = 'Later';
        toDos.get(2).Category__c = 'Tomorrow';
        Test.startTest();
        update toDos;
        Test.stopTest();
        Group todayQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Today Queue' LIMIT 1];
        Group tomorrowQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Tomorrow Queue' LIMIT 1];
        Group laterQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Later Queue' LIMIT 1];
        List<ToDo__c> updatedToDos = [SELECT Id, OwnerId, RecordTypeId, Category__c FROM ToDo__c];
        for (ToDo__c toDo : updatedToDos) {
            if (toDo.Category__c == 'Today') {
                System.assertEquals(Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Today').getRecordTypeId(), toDo.RecordTypeId);
                System.assertEquals(todayQueue.Id, toDo.OwnerId);
            } else if (toDo.Category__c == 'Tomorrow') {
                System.assertEquals(Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Tomorrow').getRecordTypeId(), toDo.RecordTypeId);
                System.assertEquals(tomorrowQueue.Id, toDo.OwnerId);
            } else if (toDo.Category__c == 'Later') {
                System.assertEquals(Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Later').getRecordTypeId(), toDo.RecordTypeId);
                System.assertEquals(laterQueue.Id, toDo.OwnerId);
            }
        }
    }
}