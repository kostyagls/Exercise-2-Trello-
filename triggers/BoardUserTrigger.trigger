trigger BoardUserTrigger on BoardUser__c (before insert, before delete, before update) {
    // Delegate all logic to handler class for maintainability
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
