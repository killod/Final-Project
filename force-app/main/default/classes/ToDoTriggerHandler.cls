public with sharing class ToDoTriggerHandler {

    public static void handleBeforeInsert(List<ToDo__c> newList) {
        ToDoHelper.assignmentToDoToQueue(newList);
        ToDoHelper.fillRecordType(newList);
    }


    public static void handleBeforeUpdate(List<ToDo__c> newList, Map<Id, ToDo__c> newMap, List<ToDo__c> oldList, Map<Id, ToDo__c> oldMap) {
        ToDoHelper.updateQueueField(newList, oldMap);
        ToDoHelper.fillRecordType(newList, oldMap);
    }


    public static void handleBeforeDelete(List<ToDo__c> oldList, Map<Id, ToDo__c> oldMap) {
    }


    public static void handleAfterInsert(List<ToDo__c> newList, Map<Id, ToDo__c> newMap) {
        Boolean toDosAreNew = false;
        for (ToDo__c toDo : newMap.values()) {
            if (toDo.SameToDoId__c == null) {
                toDosAreNew = true;
                break;
            }
        }
        if (toDosAreNew) {
            List<Id> toDosId = new List<Id>(newMap.keySet());
            ToDoHelper.makePostCallout(toDosId);
        }
    }


    public static void handleAfterUpdate(List<ToDo__c> newList, Map<Id, ToDo__c> newMap, List<ToDo__c> oldList, Map<Id, ToDo__c> oldMap) {
        List<Id> toDosId = new List<Id>(newMap.keySet());
        ToDoHelper.makePatchCallout(toDosId);
    }


    public static void handleAfterDelete(List<ToDo__c> oldList, Map<Id, ToDo__c> oldMap) {
        List<Id> listForDeleteById = new List<Id>();
        List<Id> listForDeleteBySameToDoId = new List<Id>();
        for (ToDo__c toDo : oldList) {
            if (toDo.SameToDoId__c == null) {
                listForDeleteBySameToDoId.add(toDo.Id);
            } else {
                listForDeleteById.add(toDo.SameToDoId__c);
            }
        }
        ToDoHelper.makeDeleteCallout(listForDeleteById, listForDeleteBySameToDoId);
    }


    public static void handleAfterUndelete(List<ToDo__c> newList, Map<Id, ToDo__c> newMap) {
    }
}