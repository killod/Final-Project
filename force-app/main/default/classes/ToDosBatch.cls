public with sharing class ToDosBatch implements Database.Batchable<sObject> {
    private Integer numberOfMonths = (Integer) NumberOfMonths__mdt.getInstance('NumberOfMonths').NumberOfMonths__c;


    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT Id, CreationDate__c, Completed__c FROM ToDo__c '
        );
    }


    public void execute(Database.BatchableContext bc, List<ToDo__c> scope) {
        List<ToDo__c> oldToDos = new List<ToDo__c>();
        Date dateNumberOfMonthsAgo = Date.today().addMonths(-numberOfMonths);
        for (ToDo__c toDo : scope) {
            if (toDo.Completed__c && toDo.CreationDate__c < dateNumberOfMonthsAgo) {
                oldToDos.add(toDo);
            }
        }
        delete oldToDos;
    }

    public void finish(Database.BatchableContext bc) {
    }
}