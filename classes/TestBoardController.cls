
@IsTest
private class TestBoardController {

    @IsTest
    static void testGetAllBoards() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = BoardController.getAllBoards();
        System.assertEquals(1, boards.size());
    }

    @IsTest
    static void testCreateNewBoard() {
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.createNewBoard('testBoard');
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testGetListsByBoard() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        List<List__c> lists = BoardController.getListsByBoard(boards[0]);
        System.assertEquals(1, lists.size());
    }

    @IsTest
    static void testCreateNewList() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.createNewList('testList', boards[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testChangeBoardName() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];

        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.changeBoardName(boards[0], 'TestList');
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testChangeBoardNameException() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        delete boards;

        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.changeBoardName(boards[0], 'TestList');
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }

    @IsTest
    static void testChangeCardListId() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];

        List__c cList = new List__c(Name = 'testList2', Board__c = boards[0].Id);
        insert cList;
        List<List__c> lists = [SELECT Id FROM List__c];

        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;
        List<Card__c> cards = [SELECT Id FROM Card__c];

        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.changeCardListId(cards[0], lists[1].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testChangeCardListIdException() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];

        List__c cList = new List__c(Name = 'testList2', Board__c = boards[0].Id);
        insert cList;
        List<List__c> lists = [SELECT Id FROM List__c];

        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;
        List<Card__c> cards = [SELECT Id FROM Card__c];
        delete cards;

        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.changeCardListId(cards[0], lists[1].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }


    @IsTest
    static void testDeleteBoard() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];

        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.deleteBoard(boards[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }


    @IsTest
    static void testDeleteBoardException() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        delete boards;

        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.deleteBoard(boards[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }

    @IsTest(SeeAllData=true)
    static void testAddMember() {

        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId = '00e3X000001BnB0QAK'];

        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.addMember(boards[0], users[0].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest(SeeAllData=true)
    static void testAddMemberException() {

        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId = '00e3X000001BnB0QAK'];
        delete boards;
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.addMember(boards[0], users[0].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }

    @IsTest(SeeAllData=true)
    static void testGetMembers() {

        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c WHERE Name = 'testBoard'];
        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId = '00e3X000001BnB0QAK'];

        BoardUser__c boardUser = new BoardUser__c(Board__c = boards[0].Id, User__c = users[0].Id);
        insert boardUser;
        List<BoardUser__c> boardUsers = [SELECT Id FROM BoardUser__c];

        List<BoardUser__c> result =  BoardController.getMembers(boards[0]);
        System.assertEquals(users[0].Id, result[0].User__c);

    }

    @IsTest
    static void testGetUsers() {

        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.getUsers();
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);

    }

    @IsTest(SeeAllData=true)
    static void testDeleteMember() {
        
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c WHERE Name = 'testBoard'];
        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId = '00e3X000001BnB0QAK'];

        BoardUser__c boardUser = new BoardUser__c(Board__c = boards[0].Id, User__c = users[0].Id);
        insert boardUser;
        BoardController.deleteMember(users[0].Id, boards[0]);
        List<BoardUser__c> boardUsers = [
                SELECT Id
                FROM BoardUser__c
                WHERE Board__c = :boards[0].Id AND User__c = :users[0].Id
        ];
        System.assertEquals(0, boardUsers.size());

    }


}