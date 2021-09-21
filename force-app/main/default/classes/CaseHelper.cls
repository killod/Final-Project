public with sharing class CaseHelper {

    public static void createToDo(List<Case> newList) {
        Group caseQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = 'Cases For Creation ToDos Queue' LIMIT 1];
        List<ToDo__c> toDosList = new List<ToDo__c>();
        for (Case element : newList) {
            if (element.OwnerId == caseQueue.Id) {
                ToDo__c toDo = new ToDo__c();
                toDo.Name = element.Subject;
                toDo.Category__c = 'Today';
                toDo.Description__c = element.Description;
                toDo.Priority__c = element.Priority;
                toDosList.add(toDo);
            }
        }
        if (!toDosList.isEmpty()) {
            insert toDosList;
        }
    }
}