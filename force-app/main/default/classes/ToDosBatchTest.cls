@IsTest
private class ToDosBatchTest {

    @testSetup
    static void setup() {
        List<ToDo__c> toDos = TestDataFactory.createDummyListOfToDos(5, 'Test', 'Today', false);
        ToDo__c completedToDo = TestDataFactory.createDummyCompletedToDo('Test', 'Tomorrow', false);
        toDos.add(completedToDo);
        insert toDos;
    }


    @IsTest
    static void test() {
        Test.startTest();
        ToDosBatch batchToDos = new ToDosBatch();
        Id batchId = Database.executeBatch(batchToDos);
        Test.stopTest();
        System.assertEquals(5, [SELECT  COUNT() FROM ToDo__c]);
    }
}