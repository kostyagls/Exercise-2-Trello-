/**
 * BoardUserTriggerTest
 * Unit tests for BoardUserTrigger Apex trigger.
 * @author AI
 */
@isTest
private class BoardUserTriggerTest {
    @testSetup
    static void setup() {
        // Create test Board and User
        Board__c board = new Board__c(Name = 'Test Board');
        insert board;
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
    }

    static testMethod void testBeforeInsert() {
        Board__c board = [SELECT Id FROM Board__c LIMIT 1];
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        Test.startTest();
        BoardUser__c bu = new BoardUser__c(Board__c = board.Id, User__c = u.Id);
        insert bu;
        Test.stopTest();
        System.assert(bu.Id != null, 'BoardUser__c should be inserted');
    }

    static testMethod void testBeforeDelete() {
        Board__c board = [SELECT Id FROM Board__c LIMIT 1];
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        BoardUser__c bu = new BoardUser__c(Board__c = board.Id, User__c = u.Id);
        insert bu;
        Test.startTest();
        delete bu;
        Test.stopTest();
        List<BoardUser__c> bus = [SELECT Id FROM BoardUser__c WHERE Id = :bu.Id];
        System.assertEquals(0, bus.size(), 'BoardUser__c should be deleted');
    }

    static testMethod void testBeforeUpdate() {
        Board__c board = [SELECT Id FROM Board__c LIMIT 1];
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        BoardUser__c bu = new BoardUser__c(Board__c = board.Id, User__c = u.Id);
        insert bu;
        Test.startTest();
        bu.Some_Field__c = 'Updated';
        update bu;
        Test.stopTest();
        BoardUser__c updated = [SELECT Id, Some_Field__c FROM BoardUser__c WHERE Id = :bu.Id];
        System.assertEquals('Updated', updated.Some_Field__c, 'BoardUser__c should be updated');
    }
}
