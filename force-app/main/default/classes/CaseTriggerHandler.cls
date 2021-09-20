public with sharing class CaseTriggerHandler {

    public static void handleAfterInsert(List<Case> newList, Map<Id, Case> newMap) {
        CaseHelper.createToDo(newList);
    }
}