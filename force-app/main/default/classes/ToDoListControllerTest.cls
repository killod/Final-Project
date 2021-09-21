@isTest
private with sharing class ToDoListControllerTest {

    @TestSetup
    static void makeData(){

        List<ToDo__c> toDosToInsert = new List<ToDo__c>();
        List<SubToDo__c> subToDosToInsert = new List<SubToDo__c>();

        for(Integer i = 0; i < 5000; i++){
            toDosToInsert.add(new ToDo__c(
                Name = 'test' + i,
                Description__c = i + 'desc' + i
            ));
        }

        insert toDosToInsert;

        for(Integer i = 0; i < 5000; i++){
            subToDosToInsert.add(new SubToDo__c(
                Name = 'test' + i,
                Description__c = i + 'desc' + i,
                ToDo__c = toDosToInsert[i].Id,
                Completed__c = false
            ));
        }

        insert subToDosToInsert;
    }

    @isTest
    static void testPositivefindTodos() {

        List<ToDo__c> toDosByName = new List<ToDo__c>();
        List<ToDo__c> toDosByDescription = new List<ToDo__c>();

        Test.startTest();
        toDosByName.addAll(ToDoListController.findTodos('test'));
        toDosByDescription.addAll(ToDoListController.findTodos('desc'));
        Test.stopTest();

        System.assertEquals(toDosByName.size(), [
            SELECT COUNT() 
            FROM ToDo__c 
            WHERE Name 
            LIKE '%test%' 
            LIMIT 1000]);
        System.assertEquals(toDosByDescription.size(), [
            SELECT COUNT() 
            FROM ToDo__c 
            WHERE Description__c 
            LIKE '%desc%' 
            LIMIT 1000]);
    }

    @isTest
    static void testNegativefindTodos() {

        List<ToDo__c> toDosByName = new List<ToDo__c>();
        List<ToDo__c> toDosByDescription = new List<ToDo__c>();

        Test.startTest();
        toDosByName.addAll(ToDoListController.findTodos('tost'));
        toDosByDescription.addAll(ToDoListController.findTodos('docs'));
        Test.stopTest();

        System.assertEquals(toDosByName.size(), [
            SELECT COUNT() 
            FROM ToDo__c 
            WHERE Name 
            LIKE '%tost%']);
        System.assertEquals(toDosByDescription.size(), [
            SELECT COUNT() 
            FROM ToDo__c 
            WHERE Description__c 
            LIKE '%docs%']);
        System.assertNotEquals(ToDoListController.findTodos('test').size(), [
            SELECT COUNT() 
            FROM ToDo__c 
            WHERE Description__c
            LIKE '%docs%']);
    }

    @isTest
    static void testPositiveUpdateSubToDos() {

        List<SubToDo__c> subToDosToInsert = [
            SELECT Completed__c 
            FROM SubToDo__c 
            WHERE Completed__c = false
            LIMIT 100];

        Test.startTest();
        for(SubToDo__c sub : subToDosToInsert){
            sub.Completed__c = ! sub.Completed__c;
            ToDoListController.updateSubToDo(sub);
        }
        Test.stopTest();

        System.assertEquals(subToDosToInsert.size(), [
            SELECT COUNT()
            FROM SubToDo__c 
            WHERE Completed__c = true]);
    }
}
