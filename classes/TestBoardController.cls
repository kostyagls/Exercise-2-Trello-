/*
 * TestBoardController.cls
 * Unit tests for BoardController
 * Author: AI Assistant
 * Last Modified: 2024-06
 *
 * This class contains unit tests for BoardController methods, following best practices for Apex test classes.
 */
@IsTest
public class TestBoardController {
    /**
     * Test getAllBoards method
     */
    @IsTest
    static void testGetAllBoards() {
        // Setup test data
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = BoardController.getAllBoards();
        System.assertEquals(1, boards.size(), 'Should return one board');
    }

    /**
     * Test createNewBoard method
     */
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
        System.assertEquals(false, isException, 'Should not throw exception');
    }

    /**
     * Test getListsByBoardId method
     */
    @IsTest
    static void testGetListsByBoardId() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        List<List__c> lists = BoardController.getListsByBoardId(boards[0].Id);
        System.assert(lists != null, 'Lists should not be null');
    }

    /**
     * Test createNewList method
     */
    @IsTest
    static void testCreateNewList() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.createNewList('testList', boards[0].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException, 'Should not throw exception');
    }

    /**
     * Test changeBoardName method
     */
    @IsTest
    static void testChangeBoardName() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.changeBoardName(boards[0].Id, 'NewName');
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException, 'Should not throw exception');
    }

    /**
     * Test changeListIdOnCard method
     */
    @IsTest
    static void testChangeListIdOnCard() {
        TestDataFactory.insertBoardAndListTestData();
        List<Card__c> cards = [SELECT Id, List__c FROM Card__c LIMIT 1];
        List<List__c> lists = [SELECT Id FROM List__c LIMIT 1];
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.changeListIdOnCard(cards[0], lists[0].Id);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException, 'Should not throw exception');
    }

    /**
     * Test deleteBoard method
     */
    @IsTest
    static void testDeleteBoard() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.deleteBoard(boards[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException, 'Should not throw exception');
    }

    /**
     * Test addMember method
     */
    @IsTest
    static void testAddMember() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        User u = [SELECT Id FROM User LIMIT 1];
        Boolean isException = false;
        Test.startTest();
        System.runAs(u) {
            try {
                BoardController.addMember(boards[0].Id, u.Id);
            } catch (AuraHandledException e) {
                isException = true;
            }
        }
        Test.stopTest();
        System.assertEquals(false, isException, 'Should not throw exception');
    }

    /**
     * Test getMembers method
     */
    @IsTest
    static void testGetMembers() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        List<BoardUser__c> members = BoardController.getMembers(boards[0].Id);
        System.assert(members != null, 'Members should not be null');
    }

    /**
     * Test getUsers method
     */
    @IsTest
    static void testGetUsers() {
        Boolean isException = false;
        Test.startTest();
        try {
            List<User> users = BoardController.getUsers();
            System.assert(users != null, 'Users should not be null');
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException, 'Should not throw exception');
    }

    /**
     * Test deleteMember method
     */
    @IsTest
    static void testDeleteMember() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        User u = [SELECT Id FROM User LIMIT 1];
        Boolean isException = false;
        Test.startTest();
        try {
            BoardController.deleteMember(u.Id, boards[0]);
        } catch (AuraHandledException e) {
            isException = true;
        }
        Test.stopTest();
        System.assertEquals(false, isException, 'Should not throw exception');
    }
}
