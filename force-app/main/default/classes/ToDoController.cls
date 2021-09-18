@RestResource(urlMapping='/ToDo__c/*')
global with sharing class ToDoController {
    private class ToDoWrapper {
        public String OwnerToDo { get; set; }
        public ToDo__c ToDo { get; set; }
    }
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
        Group todayQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Today Queue' LIMIT 1];
        Group tomorrowQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Tomorrow Queue' LIMIT 1];
        Group laterQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Later Queue' LIMIT 1];
        List<User> usersList = [SELECT Id FROM User WHERE IsActive = TRUE];
        List<ToDo__c> toDosListBeforeUpdate = [SELECT Id, OwnerId FROM ToDo__c];
        Map<Id, ToDo__c> toDosMapBeforeUpdate = new Map<Id, ToDo__c>(toDosListBeforeUpdate);
        RestRequest request = RestContext.request;
        List<ToDoWrapper> toDoList = (List<ToDoWrapper>) JSON.deserialize(request.requestBody.toString(), List<ToDoWrapper>.class);
        List<ToDo__c> toDoListForUpdate = new List<ToDo__c>();
        Map<Id, ToDoWrapper> updatedToDos = new Map<Id, ToDoWrapper>();
        for (ToDoWrapper toDo : toDoList) {
            if (toDo.ToDo.SameToDoId__c == '') {
                updatedToDos.put(toDo.ToDo.Id, toDo);
            } else {
                toDo.ToDo.Id = toDo.ToDo.SameToDoId__c;
                toDo.ToDo.SameToDoId__c = null;//'';
                ToDo__c toDoBeforeUpdate = toDosMapBeforeUpdate.get(toDo.ToDo.Id);
                if (toDo.OwnerToDo == 'queue' && toDoBeforeUpdate.OwnerId != todayQueue.Id && toDoBeforeUpdate.OwnerId != tomorrowQueue.Id && toDoBeforeUpdate.OwnerId != laterQueue.Id) {
                    switch on toDo.ToDo.Category__c {
                        when 'Today' {
                            toDo.ToDo.OwnerId = todayQueue.Id;
                        }
                        when 'Tomorrow' {
                            toDo.ToDo.OwnerId = tomorrowQueue.Id;
                        }
                        when 'Later' {
                            toDo.ToDo.OwnerId = laterQueue.Id;
                        }
                    }
                } else if (toDo.OwnerToDo == 'user' && (toDoBeforeUpdate.OwnerId == todayQueue.Id || toDoBeforeUpdate.OwnerId == tomorrowQueue.Id || toDoBeforeUpdate.OwnerId == laterQueue.Id)) {
                    Integer randomUser = (Integer) (Math.random() * usersList.size());
                    toDo.ToDo.OwnerId = usersList.get(randomUser).Id;
                } else {
                    toDo.ToDo.OwnerId = toDoBeforeUpdate.OwnerId;
                }
                toDoListForUpdate.add(toDo.ToDo);
            }
        }
        if (!updatedToDos.isEmpty()) {
            Set<Id> sameIdSet = updatedToDos.keySet();
            List<ToDo__c> toDoListBeforeUpdate = [SELECT Id, SameToDoId__c, OwnerId FROM ToDo__c WHERE SameToDoId__c IN :sameIdSet];
            for (ToDo__c toDo : toDoListBeforeUpdate) {
                ToDoWrapper updatedToDo = updatedToDos.get(toDo.SameToDoId__c);
                toDo.Name = updatedToDo.ToDo.Name;
                toDo.Category__c = updatedToDo.ToDo.Category__c;
                toDo.Completed__c = updatedToDo.ToDo.Completed__c;
                toDo.Description__c = updatedToDo.ToDo.Description__c;
                toDo.Priority__c = updatedToDo.ToDo.Priority__c;
                toDo.Reminder__c = updatedToDo.ToDo.Reminder__c;
                toDo.DueDate__c = updatedToDo.ToDo.DueDate__c;
                if (updatedToDo.OwnerToDo == 'queue' && toDo.OwnerId != todayQueue.Id && toDo.OwnerId != tomorrowQueue.Id && toDo.OwnerId != laterQueue.Id) {
                    switch on toDo.Category__c {
                        when 'Today' {
                            toDo.OwnerId = todayQueue.Id;
                        }
                        when 'Tomorrow' {
                            toDo.OwnerId = tomorrowQueue.Id;
                        }
                        when 'Later' {
                            toDo.OwnerId = laterQueue.Id;
                        }
                    }
                } else if (updatedToDo.OwnerToDo == 'user' && (toDo.OwnerId == todayQueue.Id || toDo.OwnerId == tomorrowQueue.Id || toDo.OwnerId == laterQueue.Id)) {
                    Integer randomUser = (Integer) (Math.random() * usersList.size());
                    toDo.OwnerId = usersList.get(randomUser).Id;
                }
                toDoListForUpdate.add(toDo);
            }
        }
        update toDoListForUpdate;
    }
}