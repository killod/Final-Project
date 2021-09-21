@RestResource(urlMapping='/SubToDo__c/*')
global with sharing class SubToDoController {

    class SubToDoWrapper {
        public String SameToDoId { get; set; }
        public SubToDo__c SubToDo { get; set; }
    }

    class IdWrapper {
        public List<String> ById { get; set; }
        public List<String> BySameSubToDoId { get; set; }
    }


    @HttpPost
    global static void createSubToDos() {
        RestRequest request = RestContext.request;
        List<SubToDoWrapper> subToDoWrapperList = (List<SubToDoWrapper>) JSON.deserialize(request.requestBody.toString(), List<SubToDoWrapper>.class);
        List<SubToDo__c> subToDoListForInsert = new List<SubToDo__c>();
        List<SubToDo__c> subToDoList = new List<SubToDo__c>();
        Set<Id> toDoIdSet = new Set<Id>();
        for (SubToDoWrapper subToDo : subToDoWrapperList) {
            if (subToDo.SameToDoId != '') {
                subToDo.SubToDo.ToDo__c = subToDo.SameToDoId;
                subToDoListForInsert.add(subToDo.SubToDo);
            }
            else {
                toDoIdSet.add(subToDo.SubToDo.ToDo__c);
                subToDoList.add(subToDo.SubToDo);
            }
        }
        if (!subToDoList.isEmpty()) {
            List<ToDo__c> toDoList = [SELECT Id, SameToDoId__c FROM ToDo__c WHERE SameToDoId__c IN :toDoIdSet];
            Map<Id, String> toDoIdMap = new Map<Id, String>();
            for (ToDo__c toDo : toDoList) {
                toDoIdMap.put(toDo.SameToDoId__c, toDo.Id);
            }
            for (SubToDoWrapper subToDo : subToDoWrapperList) {
                subToDo.SubToDo.ToDo__c = toDoIdMap.get(subToDo.SubToDo.ToDo__c);
                subToDoListForInsert.add(subToDo.SubToDo);
            }
        }

        insert subToDoListForInsert;
    }


    @HttpDelete
    global static void deleteSubToDos() {
        RestRequest request = RestContext.request;
        IdWrapper idForDelete = (IdWrapper) JSON.deserialize(request.requestBody.toString(), IdWrapper.class);
        List<String> idListDeleteById = idForDelete.ById;
        List<String> idListDeleteBySameSubToDoId = idForDelete.BySameSubToDoId;
        if (idListDeleteById == null) {
            idListDeleteById = new List<String>();
        }
        if (idListDeleteBySameSubToDoId == null) {
            idListDeleteBySameSubToDoId = new List<String>();
        }
        List<SubToDo__c> subToDoList = [SELECT Id, SameSubToDoId__c FROM SubToDo__c WHERE (Id IN :idListDeleteById OR SameSubToDoId__c IN :idListDeleteBySameSubToDoId )];

        delete subToDoList;
    }


    @HttpPatch
    global static void updateSubToDos() {
        RestRequest request = RestContext.request;
        List<SubToDo__c> subToDoList = (List<SubToDo__c>) JSON.deserialize(request.requestBody.toString(), List<SubToDo__c>.class);
        List<SubToDo__c> subToDoListForUpdate = new List<SubToDo__c>();
        Map<Id, SubToDo__c> updatedSubToDos = new Map<Id, SubToDo__c>();
        for (SubToDo__c subToDo : subToDoList) {
            if (subToDo.SameSubToDoId__c == '') {
                updatedSubToDos.put(subToDo.Id, subToDo);
            } else {
                subToDo.Id = subToDo.SameSubToDoId__c;
                subToDo.SameSubToDoId__c = '';
                subToDoListForUpdate.add(subToDo);
            }
        }
        if (!updatedSubToDos.isEmpty()) {
            Set<Id> sameIdSet = updatedSubToDos.keySet();
            List<SubToDo__c> subToDoListBeforeUpdate = [SELECT Id, SameSubToDoId__c FROM SubToDo__c WHERE SameSubToDoId__c IN :sameIdSet];
            for (SubToDo__c subToDo : subToDoListBeforeUpdate) {
                SubToDo__c updatedSubToDo = updatedSubToDos.get(subToDo.SameSubToDoId__c);
                subToDo.Name = updatedSubToDo.Name;
                subToDo.Completed__c = updatedSubToDo.Completed__c;
                subToDo.Description__c = updatedSubToDo.Description__c;
                subToDoListForUpdate.add(subToDo);
            }
        }
        update subToDoListForUpdate;
    }

}