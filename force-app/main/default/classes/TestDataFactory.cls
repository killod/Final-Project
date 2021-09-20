@IsTest
public class TestDataFactory {

    public static ToDo__c createDummyToDo(String name, String category, Boolean needInsert) {
        ToDo__c toDo = new ToDo__c(Name = name, Category__c = category);
        if (needInsert) {
            insert toDo;
        }
        return toDo;
    }


    public static List<ToDo__c> createDummyListOfToDos(Integer count, String name, String category, Boolean needInsert) {
        List<ToDo__c> toDos = new List<ToDo__c>();
        for (Integer i = 0; i < count; i++) {
            toDos.add(createDummyToDo(name, category, false));
        }
        if (needInsert) {
            insert toDos;
        }
        return toDos;
    }


    public static List<Id> getIdsOfDummyListOfToDos(Integer count, String name, String category){
        createDummyListOfToDos(count, name, category, true);
        List<ToDo__c> toDos = [SELECT Id FROM ToDo__c];
        Map<Id, ToDo__c> toDosMap = new Map<Id, ToDo__c>(toDos);
        return new List<Id>(toDosMap.keySet());
    }


    public static ToDo__c createDummyCompletedToDo(String name, String category, Boolean needInsert) {
        ToDo__c toDo = new ToDo__c(Name = name, Category__c = category, Completed__c = true);
        if (needInsert) {
            insert toDo;
        }
        return toDo;
    }


    public static List<ToDo__c> createDummyListOfCompletedToDos(Integer count, String name, String category, Boolean needInsert) {
        List<ToDo__c> toDos = new List<ToDo__c>();
        for (Integer i = 0; i < count; i++) {
            toDos.add(createDummyCompletedToDo(name, category, false));
        }
        if (needInsert) {
            insert toDos;
        }
        return toDos;
    }


    public static Case createDummyCase(String subject, String queueName, String description, Boolean needInsert) {
        Case element = new Case(Subject = subject);
        Group caseQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :queueName LIMIT 1];
        element.OwnerId = caseQueue.Id;
        element.Description = description;
        if (needInsert) {
            insert element;
        }
        return element;
    }


    public static List<Case> createDummyListOfCases(Integer count, String subject, String queueName, String description, Boolean needInsert) {
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < count; i++) {
            cases.add(createDummyCase(subject, queueName, description, false));
        }
        if (needInsert) {
            insert cases;
        }
        return cases;
    }


    public static SubToDo__c createDummySubToDo(String name, Boolean needInsert) {
        SubToDo__c subToDo = new SubToDo__c(Name = name);
        ToDo__c toDo = createDummyToDo(name, 'Today', true);
        subToDo.ToDo__c = toDo.Id;
        if (needInsert) {
            insert subToDo;
        }
        return subToDo;
    }


    public static List<SubToDo__c> createDummyListOfSubToDos(Integer count, String name, Boolean needInsert) {
        List<SubToDo__c> subToDos = new List<SubToDo__c>();
        for (Integer i = 0; i < count; i++) {
            subToDos.add(createDummySubToDo(name, false));
        }
        if (needInsert) {
            insert subToDos;
        }
        return subToDos;
    }


    public static List<Id> getIdsOfDummyListOfSubToDos(Integer count, String name) {
        createDummyListOfSubToDos(count, name, true);
        List<SubToDo__c> subToDos = [SELECT Id FROM SubToDo__c];
        Map<Id, SubToDo__c> subToDosMap = new Map<Id, SubToDo__c>(subToDos);
        return new List<Id>(subToDosMap.keySet());
    }
}