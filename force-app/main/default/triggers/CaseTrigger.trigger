trigger CaseTrigger on Case (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {
    if (Trigger.isBefore && Trigger.isInsert) {
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
    }

    if (Trigger.isBefore && Trigger.isDelete) {
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        CaseTriggerHandler.handleAfterInsert(Trigger.New, Trigger.newMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
    }

    if (Trigger.isAfter && Trigger.isDelete) {
    }

    if (Trigger.isAfter && Trigger.isUndelete) {
    }
}