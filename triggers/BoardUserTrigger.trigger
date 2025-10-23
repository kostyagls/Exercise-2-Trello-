/**
 * BoardUserTrigger
 * Handles before insert, before delete, and before update events for BoardUser__c.
 * All logic is delegated to BoardUserTriggerHandler.
 */
trigger BoardUserTrigger on BoardUser__c (before insert, before delete, before update) {
    BoardUserTriggerHandler boardUserTriggerHandler = new BoardUserTriggerHandler();
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            boardUserTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isDelete) {
            boardUserTriggerHandler.beforeDelete(Trigger.old);
        } else if (Trigger.isUpdate) {
            boardUserTriggerHandler.beforeUpdate(Trigger.new, Trigger.old);
        }
    }
}
