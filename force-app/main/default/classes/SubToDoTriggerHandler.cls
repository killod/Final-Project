public with sharing class SubToDoTriggerHandler {

    public static void handleBeforeInsert(List<SubToDo__c> newList) {
    }


    public static void handleBeforeUpdate(List<SubToDo__c> newList, Map<Id, SubToDo__c> newMap, List<SubToDo__c> oldList, Map<Id, SubToDo__c> oldMap) {
    }


    public static void handleBeforeDelete(List<SubToDo__c> oldList, Map<Id, SubToDo__c> oldMap) {
    }


    public static void handleAfterInsert(List<SubToDo__c> newList, Map<Id, SubToDo__c> newMap) {
        Boolean subToDosAreNew = false;
        for (SubToDo__c subToDo : newMap.values()) {
            if (subToDo.SameSubToDoId__c == null){
                subToDosAreNew = true;
                break;
            }
        }
        if (subToDosAreNew) {
            List<Id> subToDosId = new List<Id>(newMap.keySet());
            SubToDoHelper.makePostCallout(subToDosId);
        }
    }


    public static void handleAfterUpdate(List<SubToDo__c> newList, Map<Id, SubToDo__c> newMap, List<SubToDo__c> oldList, Map<Id, SubToDo__c> oldMap) {
        List<Id> subToDosId = new List<Id>(newMap.keySet());
        SubToDoHelper.makePatchCallout(subToDosId);
    }


    public static void handleAfterDelete(List<SubToDo__c> oldList, Map<Id, SubToDo__c> oldMap) {
        List<Id> listForDeleteById = new List<Id>();
        List<Id> listForDeleteBySameSubToDoId = new List<Id>();
        for (SubToDo__c subToDo : oldList) {
            if (subToDo.SameSubToDoId__c == null) {
                listForDeleteBySameSubToDoId.add(subToDo.Id);
            } else {
                listForDeleteById.add(subToDo.SameSubToDoId__c);
            }
        }
        SubToDoHelper.makeDeleteCallout(listForDeleteById, listForDeleteBySameSubToDoId);
    }


    public static void handleAfterUndelete(List<ToDo__c> newList, Map<Id, ToDo__c> newMap) {
    }
}