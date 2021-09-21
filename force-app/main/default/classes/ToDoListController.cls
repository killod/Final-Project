public with sharing class ToDoListController {
    
    @AuraEnabled(Cacheable = true)
    public static List<Todo__c> findTodos(String searchKey){
        String key = '%' + searchKey + '%';

        return [
            SELECT Name, Category__c, Completed__c, Description__c, DueDate__c, Priority__c, Reminder__c,
            (SELECT Name, Description__c, Completed__c FROM SubToDos__r ORDER BY CreatedDate)
            FROM Todo__c
            WHERE (Name LIKE :key) OR (Description__c LIKE :key)
            WITH SECURITY_ENFORCED
            ORDER BY Id
            LIMIT 1000
        ];
    }

    @AuraEnabled
    public static void updateSubToDo(SubToDo__c subtodo){
        if(subtodo != null){
            update subtodo;
        }
    }
}
