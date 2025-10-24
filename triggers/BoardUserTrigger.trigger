// BoardUserTrigger
// Delegates all logic to BoardUserTriggerHandler for PMD compliance.
// AI-generated logic comments and PMD compliance.
trigger BoardUserTrigger on BoardUser__c (before insert, before delete) {
    // Instantiate handler
    BoardUserTriggerHandler boardUserTriggerHandler = new BoardUserTriggerHandler();
    if (Trigger.isBefore) {
        // Delegate all logic to handler class
        if (Trigger.isInsert) {
            boardUserTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isDelete) {
            boardUserTriggerHandler.beforeDelete(Trigger.old);
        }
        // PMD: Removed logic from trigger, update logic should be handled in handler
    }
}
