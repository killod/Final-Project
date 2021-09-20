public with sharing class SubToDoHelper {

    @Future(Callout = true)
    public static void makeDeleteCallout(List<Id> listForDeleteById, List<Id> listForDeleteBySameSubToDoId) {
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartObject();
        fillGenerator(listForDeleteById, generator, 'ById');
        fillGenerator(listForDeleteBySameSubToDoId, generator, 'BySameSubToDoId');
        generator.writeEndObject();

        String jsonString = generator.getAsString();
        System.debug('jsonMaterials' + jsonString);

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:secondOrg/services/apexrest/SubToDo__c/');//listForDeleteBySameToDoId.get(0));
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
    public static void makePostCallout(List<Id> subToDosId) {
        List<SubToDo__c> subToDoList = [
                SELECT Id, Name, Description__c, Completed__c, SameSubToDoId__c, ToDo__c
                FROM SubToDo__c
                WHERE Id IN :subToDosId
        ];
        List<Id> toDoIdList = new List<Id>();
        for (SubToDo__c subToDo : subToDoList) {
            toDoIdList.add(subToDo.ToDo__c);
        }
        List<ToDo__c> toDoList = [
                SELECT Id, SameToDoId__c
                FROM ToDo__c
                WHERE Id IN :toDoIdList
        ];
        Map<Id, ToDo__c> toDoMap = new Map<Id, ToDo__c>(toDoList);
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        for (SubToDo__c subToDo : subToDoList) {
            generator.writeStartObject();
            if (toDoMap.get((Id) subToDo.ToDo__c).SameToDoId__c == null) {
                generator.writeStringField('SameToDoId', '');
            } else {
                generator.writeStringField('SameToDoId', toDoMap.get((Id) subToDo.ToDo__c).SameToDoId__c);
            }
            generator.writeFieldName('SubToDo');
            generator.writeStartObject();
            generator.writeStringField('Name', subToDo.Name);
            generator.writeStringField('Description__c', (subToDo.Description__c == null) ? '' : subToDo.Description__c);
            generator.writeBooleanField('Completed__c', subToDo.Completed__c);
            generator.writeStringField('SameSubToDoId__c', subToDo.Id);
            generator.writeStringField('ToDo__c', subToDo.ToDo__c);
            generator.writeEndObject();
            generator.writeEndObject();
        }
        generator.writeEndArray();
        String jsonString = generator.getAsString();
        System.debug('jsonMaterials' + jsonString);

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:secondOrg/services/apexrest/SubToDo__c/');
        request.setMethod('POST');
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


    @Future(Callout = true)
    public static void makePatchCallout(List<Id> subToDosId) {
        List<SubToDo__c> subToDoList = [
                SELECT Id, Name, Description__c, Completed__c, SameSubToDoId__c
                FROM SubToDo__c
                WHERE Id IN :subToDosId
        ];
        JSONGenerator generator = JSON.createGenerator(true);
        generator.writeStartArray();
        for (SubToDo__c subToDo : subToDoList) {
            generator.writeStartObject();
            generator.writeStringField('Id', subToDo.Id);
            generator.writeStringField('Name', subToDo.Name);
            generator.writeBooleanField('Completed__c', subToDo.Completed__c);
            generator.writeStringField('Description__c', (subToDo.Description__c == null) ? '' : subToDo.Description__c);
            generator.writeStringField('SameSubToDoId__c', (subToDo.SameSubToDoId__c == null) ? '' : subToDo.SameSubToDoId__c);
            generator.writeEndObject();
        }
        generator.writeEndArray();
        String jsonString = generator.getAsString();
        System.debug('jsonMaterials' + jsonString);

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:secondOrg/services/apexrest/SubToDo__c/');
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