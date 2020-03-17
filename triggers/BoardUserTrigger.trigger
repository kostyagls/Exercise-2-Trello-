
trigger BoardUserTrigger on BoardUser__c (before insert, before delete) {
    BoardUserTriggerHandler boardUserTriggerHandler = new BoardUserTriggerHandler();
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            boardUserTriggerHandler.beforeInsert(Trigger.new);
        } else if (Trigger.isDelete) {
            boardUserTriggerHandler.beforeDelete(Trigger.old);
        }
    }
}