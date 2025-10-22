/**
 * BoardUserTrigger
 * Trigger for BoardUser__c object to handle before insert, before delete, and before update events.
 *
 * @description AI-generated documentation and PMD fixes applied.
 * @date 2025-10-22
 */
trigger BoardUserTrigger on BoardUser__c (before insert, before delete, before update) {
    // Delegate all logic to handler class for maintainability and testability
    BoardUserTriggerHandler.handle(Trigger.isBefore, Trigger.isInsert, Trigger.isDelete, Trigger.isUpdate, Trigger.new, Trigger.old);
}
