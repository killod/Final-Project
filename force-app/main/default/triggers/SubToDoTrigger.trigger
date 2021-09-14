trigger SubToDoTrigger on SubToDo__c (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {
    if (Trigger.isBefore && Trigger.isInsert) {
        //Trigger.new
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        //Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    }

    if (Trigger.isBefore && Trigger.isDelete) {
        //Trigger.old, Trigger.oldMap
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        SubToDoTriggerHandler.handleAfterInsert(Trigger.new, Trigger.newMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        SubToDoTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isDelete) {
        SubToDoTriggerHandler.handleAfterDelete(Trigger.old, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUndelete) {
        //Trigger.new, Trigger.newMap
    }

}