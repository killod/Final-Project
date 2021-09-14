@RestResource(urlMapping='/ToDo__c/*')
global with sharing class ToDoController {

    class IdWrapper {
        public List<String> ById { get; set; }
        public List<String> BySameToDoId { get; set; }
    }


    @HttpPost
    global static void createToDos() {
        RestRequest request = RestContext.request;
        List<ToDo__c> toDoList = (List<ToDo__c>) JSON.deserialize(request.requestBody.toString(), List<ToDo__c>.class);

        insert toDoList;
    }


    @HttpDelete
    global static void deleteToDos() {
        RestRequest request = RestContext.request;
        IdWrapper idForDelete = (IdWrapper) JSON.deserialize(request.requestBody.toString(), IdWrapper.class);
        List<String> idListDeleteById = idForDelete.ById;
        List<String> idListDeleteBySameToDoId = idForDelete.BySameToDoId;
        if (idListDeleteById == null) {
            idListDeleteById = new List<String>();
        }
        if (idListDeleteBySameToDoId == null) {
            idListDeleteBySameToDoId = new List<String>();
        }
        List<ToDo__c> toDoList = [SELECT Id, SameToDoId__c FROM ToDo__c WHERE (Id IN :idListDeleteById OR SameToDoId__c IN :idListDeleteBySameToDoId )];

        delete toDoList;
    }


    @HttpPatch
    global static void updateToDos() {
        RestRequest request = RestContext.request;
        List<ToDo__c> toDoList = (List<ToDo__c>) JSON.deserialize(request.requestBody.toString(), List<ToDo__c>.class);
        List<ToDo__c> toDoListForUpdate = new List<ToDo__c>();
        Map<Id, ToDo__c> updatedToDos = new Map<Id, ToDo__c>();
        for (ToDo__c toDo : toDoList) {
            if (toDo.SameToDoId__c == '') {
                updatedToDos.put(toDo.Id, toDo);
            } else {
                toDo.Id = toDo.SameToDoId__c;
                toDo.SameToDoId__c = null;//'';
                toDoListForUpdate.add(toDo);
            }
        }
        if (!updatedToDos.isEmpty()) {
            Set<Id> sameIdSet = updatedToDos.keySet();
            List<ToDo__c> toDoListBeforeUpdate = [SELECT Id, SameToDoId__c FROM ToDo__c WHERE SameToDoId__c IN :sameIdSet];
            for (ToDo__c toDo : toDoListBeforeUpdate) {
                ToDo__c updatedToDo = updatedToDos.get(toDo.SameToDoId__c);
                toDo.Name = updatedToDo.Name;
                toDo.Category__c = updatedToDo.Category__c;
                toDo.Completed__c = updatedToDo.Completed__c;
                toDo.Description__c = updatedToDo.Description__c;
                toDo.Priority__c = updatedToDo.Priority__c;
                toDo.Reminder__c = updatedToDo.Reminder__c;
                toDo.DueDate__c = updatedToDo.DueDate__c;
                toDoListForUpdate.add(toDo);
            }
        }

        update toDoListForUpdate;
    }

}