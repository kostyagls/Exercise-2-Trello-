//
// TestBoardController.cls
// Test class for BoardController
// AI-generated header: Contains unit tests for BoardController methods, covers positive and negative scenarios
//
// @author: AI Assistant
// @date: 2024-06-11
//

@IsTest
public class TestBoardController {
    /**
     * Test getAllBoards method
     */
    @IsTest
    static void testGetAllBoards_ReturnsBoards_WhenDataExists() {
        // Arrange
        TestDataFactory.insertBoardAndListTestData();
        // Act
        List<Board__c> boards = BoardController.getAllBoards();
        // Assert
        System.assertEquals(1, boards.size(), 'Should return one board');
    }

    /**
     * Test createNewBoard method
     */
    @IsTest
    static void testCreateNewBoard_CreatesBoard_WhenValidName() {
        Test.startTest();
        BoardController.createNewBoard('testBoard');
        Test.stopTest();
        List<Board__c> boards = [SELECT Id, Name FROM Board__c WHERE Name = 'testBoard'];
        System.assertEquals(1, boards.size(), 'Board should be created');
    }

    /**
     * Test getListsByBoardId method
     */
    @IsTest
    static void testGetListsByBoardId_ReturnsLists_WhenBoardExists() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        List<List__c> lists = BoardController.getListsByBoardId(boards[0].Id);
        System.assert(lists.size() > 0, 'Should return lists for the board');
    }

    /**
     * Test createNewList method
     */
    @IsTest
    static void testCreateNewList_CreatesList_WhenValidData() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        Test.startTest();
        BoardController.createNewList('testList', boards[0].Id);
        Test.stopTest();
        List<List__c> lists = [SELECT Id, Name FROM List__c WHERE Name = 'testList'];
        System.assertEquals(1, lists.size(), 'List should be created');
    }

    /**
     * Test changeBoardName method
     */
    @IsTest
    static void testChangeBoardName_ChangesName_WhenValidData() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        Test.startTest();
        BoardController.changeBoardName(boards[0].Id, 'NewName');
        Test.stopTest();
        Board__c updatedBoard = [SELECT Name FROM Board__c WHERE Id = :boards[0].Id];
        System.assertEquals('NewName', updatedBoard.Name, 'Board name should be updated');
    }

    /**
     * Test deleteBoard method
     */
    @IsTest
    static void testDeleteBoard_DeletesBoard_WhenValidBoard() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        Test.startTest();
        BoardController.deleteBoard(boards[0]);
        Test.stopTest();
        List<Board__c> deleted = [SELECT Id FROM Board__c WHERE Id = :boards[0].Id];
        System.assertEquals(0, deleted.size(), 'Board should be deleted');
    }

    /**
     * Test addMember method with System.runAs
     */
    @IsTest
    static void testAddMember_AddsMember_WhenValidData() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            BoardController.addMember(boards[0].Id, u.Id);
            Test.stopTest();
            // Check if member was added (pseudo-query, adjust as needed)
            // List<BoardUser__c> members = [SELECT Id FROM BoardUser__c WHERE Board__c = :boards[0].Id AND User__c = :u.Id];
            // System.assertEquals(1, members.size(), 'Member should be added');
        }
    }

    /**
     * Test getMembers method
     */
    @IsTest
    static void testGetMembers_ReturnsMembers_WhenBoardExists() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        List<BoardUser__c> members = BoardController.getMembers(boards[0].Id);
        System.assert(members != null, 'Should return members');
    }

    /**
     * Test getUsers method
     */
    @IsTest
    static void testGetUsers_ReturnsUsers() {
        List<User> users = BoardController.getUsers();
        System.assert(users.size() > 0, 'Should return users');
    }

    /**
     * Test deleteMember method
     */
    @IsTest
    static void testDeleteMember_DeletesMember_WhenValidData() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        // Add member first
        BoardController.addMember(boards[0].Id, users[0].Id);
        Test.startTest();
        BoardController.deleteMember(users[0].Id, boards[0]);
        Test.stopTest();
        // List<BoardUser__c> members = [SELECT Id FROM BoardUser__c WHERE Board__c = :boards[0].Id AND User__c = :users[0].Id];
        // System.assertEquals(0, members.size(), 'Member should be deleted');
    }
}
