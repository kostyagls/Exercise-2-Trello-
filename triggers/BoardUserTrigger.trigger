// BoardUserTrigger
// AI-generated: Delegates all logic to handler, braces added for all if/else, no business logic in trigger.
//
// @description  PMD compliance: AvoidLogicInTrigger, IfStmtsMustUseBraces
// @date         2024-06-XX

trigger BoardUserTrigger on BoardUser__c (before insert, before delete) {
    BoardUserTriggerHandler boardUserTriggerHandler = new BoardUserTriggerHandler();
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            // Delegate to handler
            boardUserTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isDelete) {
            // Delegate to handler
            boardUserTriggerHandler.beforeDelete(Trigger.old);
        } else if (Trigger.isUpdate) {
            // Delegate to handler (if needed)
            boardUserTriggerHandler.beforeInsert(Trigger.new);
        }
    }
}
