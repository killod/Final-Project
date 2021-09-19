@IsTest
private class CleanOldToDosJobTest {
    public static String CRON_EXP = '0 0 0 19 9 ? 2022';


    @testSetup
    static void setup() {
        ToDo__c toDo = TestDataFactory.createDummyToDo('Test', 'Today', false);
        List<ToDo__c> toDos = TestDataFactory.createDummyListOfCompletedToDos(5, 'Test', 'Tomorrow', false);
        toDos.add(toDo);
        insert toDo;
    }


    @isTest
    static void test() {
        Test.startTest();
        CleanOldToDosJob job = new CleanOldToDosJob();
        String jobId = System.schedule('ScheduledApexTest',
                CRON_EXP,
                job);
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM ToDo__c]);
    }
}