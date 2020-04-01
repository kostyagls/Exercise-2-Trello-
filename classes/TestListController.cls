
@IsTest
private class TestListController {


    @IsTest
    static void testGetCardsByListId() {

        TestDataFactory.insertBoardAndListTestData();
        List<List__c> lists = [SELECT Id FROM List__c];

        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;

        List<Card__c> result = ListController.getCardsByListId(lists[0].Id);
        System.assertEquals(1, result.size());
    }


    @IsTest
    static void testCreateNewCard() {

        TestDataFactory.insertBoardAndListTestData();
        List<List__c> lists = [SELECT Id FROM List__c];

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.createNewCard( ' testCard', lists[0].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testCreateNewCardException() {

        TestDataFactory.insertBoardAndListTestData();
        List<List__c> lists = [SELECT Id FROM List__c];
        delete lists;

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.createNewCard( 'testCard', lists[0].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }


    @IsTest
    static void testChangeListName() {

        TestDataFactory.insertBoardAndListTestData();
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

        TestDataFactory.insertBoardAndListTestData();
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

    @IsTest
    static void testDeleteList() {

        TestDataFactory.insertBoardAndListTestData();
        List<List__c> lists = [SELECT Id FROM List__c];

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.deleteList(lists[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testDeleteListException() {

        TestDataFactory.insertBoardAndListTestData();
        List<List__c> lists = [SELECT Id FROM List__c];
        delete lists;

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.deleteList(lists[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }

    @IsTest
    static void testDeleteCard() {

        TestDataFactory.insertBoardAndListTestData();
        List<List__c> lists = [SELECT Id FROM List__c];

        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;
        List<Card__c> cards = [SELECT Id FROM Card__c];

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.deleteCard(cards[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testDeleteCardException() {

        TestDataFactory.insertBoardAndListTestData();
        List<List__c> lists = [SELECT Id FROM List__c];

        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;
        List<Card__c> cards = [SELECT Id FROM Card__c];
        delete cards;

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.deleteCard(cards[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }


    @IsTest(SeeAllData=true)
    static void testGetCardMembers() {

        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        List<List__c> lists = [SELECT Id FROM List__c];

        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;
        List<Card__c> cards = [SELECT Id FROM Card__c];

        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId = '00e3X000001BnB0QAK'];

        BoardUser__c boardUser = new BoardUser__c(Board__c = boards[0].Id, User__c = users[0].Id);
        insert boardUser;
        List<BoardUser__c> boardUsers = [SELECT Id FROM BoardUser__c];

        CardUser__c cardUser = new CardUser__c(Card__c = cards[0].Id, BoardUser__c = boardUsers[0].Id);
        insert cardUser;

        List<CardUser__c> result = ListController.getCardMembers(cards[0].Id);
        System.assertEquals(users[0].Name, result[0].BoardUser__r.User__r.Name);

    }


    @IsTest(SeeAllData=true)
    static void testGetBoardMembers() {

        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        List<List__c> lists = [SELECT Id FROM List__c];

        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;
        List<Card__c> cards = [SELECT Id FROM Card__c];

        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId = '00e3X000001BnB0QAK'];

        BoardUser__c boardUser = new BoardUser__c(Board__c = boards[0].Id, User__c = users[0].Id);
        insert boardUser;
        List<BoardUser__c> boardUsers = [SELECT Id FROM BoardUser__c];

        List<BoardUser__c> result = ListController.getBoardMembers(boards[0].Id);
        System.assertEquals(users[0].Name, result[0].User__r.Name);

    }

    @IsTest(SeeAllData=true)
    static void testAddCardMember() {

        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        List<List__c> lists = [SELECT Id FROM List__c];

        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;
        List<Card__c> cards = [SELECT Id FROM Card__c];

        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId = '00e3X000001BnB0QAK'];

        BoardUser__c boardUser = new BoardUser__c(Board__c = boards[0].Id, User__c = users[0].Id);
        insert boardUser;
        List<BoardUser__c> boardUsers = [SELECT Id FROM BoardUser__c];

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.addCardMember(cards[0].Id, boardUsers[0].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);

    }

    @IsTest(SeeAllData=true)
    static void testDeleteCardMember() {

        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        List<List__c> lists = [SELECT Id FROM List__c];

        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;
        List<Card__c> cards = [SELECT Id FROM Card__c];

        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId = '00e3X000001BnB0QAK'];

        BoardUser__c boardUser = new BoardUser__c(Board__c = boards[0].Id, User__c = users[0].Id);
        insert boardUser;
        List<BoardUser__c> boardUsers = [SELECT Id FROM BoardUser__c];

        CardUser__c cardUser = new CardUser__c(Card__c = cards[0].Id, BoardUser__c = boardUsers[0].Id);
        insert cardUser;

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.deleteCardMember(cards[0].Id, boardUsers[0].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }


    @IsTest
    static void testGetFiles() {
        Card__c card = new Card__c(Name = 'testCard');
        insert card;
        List<Card__c> cards = [SELECT Id FROM Card__c];

        File__c file = new File__c(Name = 'testFile', Card__c = cards[0].Id);
        insert file;

        List<File__c> result = ListController.getFiles(cards[0].Id);
        System.assertEquals(1, result.size());

    }

    @IsTest
    static void testCreateFile() {
        Test.setMock(HttpCalloutMock.class, new DropBoxHttpCalloutMock());
        Card__c card = new Card__c(Name = 'testCard');
        insert card;
        List<Card__c> cards = [SELECT Id, Name FROM Card__c];

        String fileName = 'testFile.txt';
        String fileContents = 'aGVsbG8=';

        Boolean isException = false;
        Test.startTest();
        try {
            List<File__c> result = ListController.createFile(fileName, fileContents, cards[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testDeleteFile() {
        Test.setMock(HttpCalloutMock.class, new DropBoxHttpCalloutMock());
        Card__c card = new Card__c(Name = 'testCard');
        insert card;
        List<Card__c> cards = [SELECT Id, Name FROM Card__c];

        File__c file = new File__c(Name = 'testFile.txt', Card__c = cards[0].Id);
        insert file;
        List<File__c> files = [SELECT Id,Name FROM File__c];

        Boolean isException = false;
        Test.startTest();
        try {
            ListController.deleteFile(files[0], cards[0].Name);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }



}