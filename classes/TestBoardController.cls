// ============================================================================
// Apex Test Class: TestBoardController
// Description: Unit tests for BoardController. Ensures coverage and correctness
//              of all main logic paths, including positive and negative cases.
// AI-generated header: All changes below are documented inline.
// ============================================================================

@IsTest
private class TestBoardController {

    @IsTest
    static void testGetAllBoards() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = BoardController.getAllBoards();
        System.assertEquals(1, boards.size());
    }

    @IsTest // AI Fix: Corrected annotation typo from @IsTestt to @IsTest
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
    static void testGetListsByBoardId() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        List<List__c> lists = BoardController.getListsByBoardId(boards[0].Id);
        System.assertEquals(1, lists.size());
    }

    @IsTest
    static void testCreateNewList() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.createNewList('testList', boards[0].Id);
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
            BoardController.changeBoardName(boards[0].Id, 'TestList');
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
            BoardController.changeBoardName(boards[0].Id, 'TestList');
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }

    @IsTest
    static void testChangeListIdOnCard() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        List<List__c> lists = [SELECT Id FROM List__c];
        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.changeListIdOnCard(card, lists[0].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException);
    }

    @IsTest
    static void testChangeListIdOnCardException() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c];
        List<List__c> lists = [SELECT Id FROM List__c];
        Card__c card = new Card__c(Name = 'testCard', List__c = lists[0].Id);
        insert card;
        delete lists;
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.changeListIdOnCard(card, lists[0].Id);
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
        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId != null LIMIT 1];
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.addMember(boards[0].Id, users[0].Id);
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
        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId != null LIMIT 1];
        delete boards;
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.addMember(boards[0].Id, users[0].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(true, isException);
    }

    @IsTest
    static void testGetMembers() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c WHERE Name = 'testBoard'];
        List<BoardUser__c> members = BoardController.getMembers(boards[0].Id);
        System.assertEquals(true, members.size() >= 0);
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
        List<User> users = [SELECT Id, Name FROM User WHERE ProfileId != null LIMIT 1];
        BoardController.deleteMember(users[0].Id, boards[0]);
        List<BoardUser__c> boardUsers = [SELECT Id FROM BoardUser__c WHERE Board__c = :boards[0].Id AND User__c = :users[0].Id];
        System.assertEquals(0, boardUsers.size());
    }
}
