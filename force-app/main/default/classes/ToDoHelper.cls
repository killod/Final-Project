public with sharing class ToDoHelper {

    public static void fillRecordType(List<ToDo__c> newList){
        for (ToDo__c toDo : newList) {
            switch on toDo.Category__c {
                when 'Today' {
                    toDo.RecordTypeId = Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Today').getRecordTypeId();
                }
                when 'Tomorrow' {
                    todo.RecordTypeId = Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Tomorrow').getRecordTypeId();
                }
                when 'Later' {
                    toDo.RecordTypeId = Schema.SObjectType.ToDo__c.getRecordTypeInfosByName().get('Later').getRecordTypeId();
                }
            }
        }
    }


    public static void updateQueueField(List<ToDo__c> newList, Map<Id, ToDo__c> oldMap){
        List<Group> queueList = [SELECT Id FROM Group WHERE Type = 'Queue' AND (Name = 'Today Queue' OR Name = 'Tomorrow Queue' OR Name = 'Later Queue')];
        Map<Id, Group> queueMap = new Map<Id, Group>(queueList);
        List<ToDo__c> toDosListForUpdateQueueField = new List<ToDo__c>();
        for (ToDo__c toDo : newList) {
            if (toDo.Category__c != oldMap.get(toDo.Id).Category__c && queueMap.keySet().contains(toDo.OwnerId)) {
                toDosListForUpdateQueueField.add(toDo);
            }
        }
        if (!toDosListForUpdateQueueField.isEmpty()) {
            assignmentToDoToQueue(toDosListForUpdateQueueField);
        }
    }


    public static void assignmentToDoToQueue(List<ToDo__c> toDosList){
        Group todayQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Today Queue' LIMIT 1];
        Group tomorrowQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Tomorrow Queue' LIMIT 1];
        Group laterQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Later Queue' LIMIT 1];
        for (ToDo__c toDo : toDosList) {
            switch on toDo.Category__c {
                when 'Today' {
                    toDo.OwnerId = todayQueue.Id;
                }
                when 'Tomorrow' {
                    todo.OwnerId = tomorrowQueue.Id;
                }
                when 'Later' {
                    toDo.OwnerId = laterQueue.Id;
                }
            }
        }
    }


    @Future(Callout = true)
    public static void makeDeleteCallout(List<Id> listForDeleteById, List<Id> listForDeleteBySameToDoId) {
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartObject();
        fillGenerator(listForDeleteById, generator, 'ById');
        fillGenerator(listForDeleteBySameToDoId, generator, 'BySameToDoId');
        generator.writeEndObject();

        String jsonString = generator.getAsString();
        System.debug('jsonMaterials' + jsonString);

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:secondOrg/services/apexrest/ToDo__c/');//listForDeleteBySameToDoId.get(0));
        request.setMethod('DELETE');
        request.setBody(jsonString);

        Http http = new Http();
        HttpResponse response;
        try {
            response = http.send(request);
            System.debug(response.getStatus());
        } catch (System.CalloutException e) {
            System.debug(e.getCause() + ' ' + e.getMessage());
        }
    }


    private static void fillGenerator(List<Id> listForDelete, JSONGenerator generator, String fieldName) {
        if (!listForDelete.isEmpty()) {
            generator.writeFieldName(fieldName);
            generator.writeStartArray();
            for (Id toDoId : listForDelete) {
                generator.writeString(toDoId);
            }
            generator.writeEndArray();
        }
    }


    @Future(Callout = true)
    public static void makePostCallout(List<Id> toDosId) {
        List<ToDo__c> toDoList = [
                SELECT Id, Name, Category__c, Completed__c, Description__c, DueDate__c, Priority__c, Reminder__c, SameToDoId__c
                FROM ToDo__c
                WHERE Id IN :toDosId
        ];
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        for (ToDo__c toDo : toDoList) {
            generator.writeStartObject();
            generator.writeStringField('Name', toDo.Name);
            generator.writeStringField('Category__c', toDo.Category__c);
            generator.writeBooleanField('Completed__c', toDo.Completed__c);
            generator.writeStringField('Description__c', (toDo.Description__c == null) ? '' : toDo.Description__c);
            if (toDo.DueDate__c != null) {
                generator.writeDateTimeField('DueDate__c', toDo.DueDate__c);
            }
            generator.writeStringField('Priority__c', todo.Priority__c);
            generator.writeStringField('Reminder__c', toDo.Reminder__c);
            generator.writeStringField('SameToDoId__c', todo.Id);
            generator.writeEndObject();
        }
        generator.writeEndArray();
        String jsonString = generator.getAsString();
        System.debug('jsonMaterials' + jsonString);

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:secondOrg/services/apexrest/ToDo__c/');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonString);

        Http http = new Http();
        HttpResponse response;
        try {
            response = http.send(request);
            System.debug(response.getStatus());
            System.debug(response.getBody());
        } catch (System.CalloutException e) {
            System.debug(e.getCause() + ' ' + e.getMessage());
        }
    }


    @Future(Callout = true)
    public static void makePatchCallout(List<Id> toDosId) {
        List<ToDo__c> toDoList = [
                SELECT Id, Name, Category__c, Completed__c, CreationDate__c, Description__c, DueDate__c, Priority__c, Reminder__c, SameToDoId__c
                FROM ToDo__c
                WHERE Id IN :toDosId
        ];
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        for (ToDo__c toDo : toDoList) {
            generator.writeStartObject();
            generator.writeStringField('Id', toDo.Id);
            generator.writeStringField('Name', toDo.Name);
            generator.writeStringField('Category__c', toDo.Category__c);
            generator.writeBooleanField('Completed__c', toDo.Completed__c);
            generator.writeStringField('Description__c', (toDo.Description__c == null) ? '' : toDo.Description__c);
            if (toDo.DueDate__c != null) {
                generator.writeDateTimeField('DueDate__c', toDo.DueDate__c);
            }
            generator.writeStringField('Priority__c', todo.Priority__c);
            generator.writeStringField('Reminder__c', toDo.Reminder__c);
            generator.writeStringField('SameToDoId__c', (toDo.SameToDoId__c == null) ? '' : toDo.SameToDoId__c);
            generator.writeEndObject();
        }
        generator.writeEndArray();
        String jsonString = generator.getAsString();
        System.debug('jsonMaterials' + jsonString);

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:secondOrg/services/apexrest/ToDo__c/');
        request.setMethod('PATCH');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonString);

        Http http = new Http();
        HttpResponse response;
        try {
            response = http.send(request);
            System.debug(response.getStatus());
        } catch (System.CalloutException e) {
            System.debug(e.getCause() + ' ' + e.getMessage());
        }
    }
}