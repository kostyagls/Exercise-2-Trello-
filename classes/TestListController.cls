
@IsTest
private class TestListController {


    @IsTest
    static void testGetCardsByList() {

        Board__c board = new Board__c(Name = 'testBoard');
        insert board;
        List<Board__c> boards = [SELECT Id FROM Board__c];

        List__c cList = new List__c(Name = 'testList', Board__c = boards[0].Id);
        insert cList;
        List<List__c> lists = [SELECT Id FROM List__c];

        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;

        List<Card__c> result = ListController.getCardsByList(lists[0]);
        System.assertEquals(1, result.size());
    }


    @IsTest
    static void testCreateNewCard() {

        Board__c board = new Board__c(Name = 'testBoard');
        insert board;
        List<Board__c> boards = [SELECT Id FROM Board__c];

        List__c cList = new List__c(Name = 'testList', Board__c = boards[0].Id);
        insert cList;
        List<List__c> lists = [SELECT Id FROM List__c];

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.createNewCard( ' ', lists[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testCreateNewCardException() {

        Board__c board = new Board__c(Name = 'testBoard');
        insert board;
        List<Board__c> boards = [SELECT Id FROM Board__c];

        List__c cList = new List__c(Name = 'testList', Board__c = boards[0].Id);
        insert cList;
        List<List__c> lists = [SELECT Id FROM List__c];
        delete lists;

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.createNewCard( 'testCard', lists[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }


    @IsTest
    static void testChangeListName() {

        Board__c board = new Board__c(Name = 'testBoard');
        insert board;
        List<Board__c> boards = [SELECT Id FROM Board__c];

        List__c cList = new List__c(Name = 'testList', Board__c = boards[0].Id);
        insert cList;
        List<List__c> lists = [SELECT Id FROM List__c];

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.changeListName(lists[0], 'test');
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testChangeListNameException() {

        Board__c board = new Board__c(Name = 'testBoard');
        insert board;
        List<Board__c> boards = [SELECT Id FROM Board__c];

        List__c cList = new List__c(Name = 'testList', Board__c = boards[0].Id);
        insert cList;
        List<List__c> lists = [SELECT Id FROM List__c];
        delete lists;

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.changeListName(lists[0], 'test');
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }


}