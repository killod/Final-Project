trigger SubToDoTrigger on SubToDo__c (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {
    if (Trigger.isAfter && Trigger.isInsert) {
        SubToDoTriggerHandler.handleAfterInsert(Trigger.new, Trigger.newMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        SubToDoTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isDelete) {
        SubToDoTriggerHandler.handleAfterDelete(Trigger.old, Trigger.oldMap);
    }
}