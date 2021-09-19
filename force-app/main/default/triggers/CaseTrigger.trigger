trigger CaseTrigger on Case (
        before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {

    if (Trigger.isAfter && Trigger.isInsert) {
        CaseTriggerHandler.handleAfterInsert(Trigger.New, Trigger.newMap);
    }
}