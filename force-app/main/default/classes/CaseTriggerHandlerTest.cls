@IsTest
private class CaseTriggerHandlerTest {
    @IsTest
    static void handleAfterInsertTest() {
        List<Case> cases = TestDataFactory.createDummyListOfCases(2, 'Test', 'Cases For Creation ToDos Queue', 'ToDo from Case', false);
        Test.startTest();
        insert cases;
        Test.stopTest();
        List<ToDo__c> toDos = [SELECT Name, Category__c, Description__c, Priority__c FROM ToDo__c];
        System.assertEquals(2, toDos.size());
        for (Integer i = 0; i < toDos.size(); i++) {
            System.assertEquals('Test', toDos.get(i).Name);
            System.assertEquals('ToDo from Case', toDos.get(i).Description__c);
            System.assertEquals('Today', toDos.get(i).Category__c);
            System.assertEquals('Medium', toDos.get(i).Priority__c);
        }
    }
}