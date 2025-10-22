// BoardUserTrigger: delegates all logic to handler class for maintainability
trigger BoardUserTrigger on BoardUser__c (before insert, before delete) {
    BoardUserTriggerHandler handler = new BoardUserTriggerHandler();
    if (Trigger.isBefore) {
        handler.handle(Trigger.new, Trigger.old);
    }
}
