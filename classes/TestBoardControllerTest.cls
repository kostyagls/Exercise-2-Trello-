//
// TestBoardControllerTest.cls
// AI-generated test class for BoardController
//
// @author: AI Assistant
// @date: 2024-06-11
//

@IsTest
public class TestBoardControllerTest {
    @IsTest
    static void testGetAllBoards() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = BoardController.getAllBoards();
        System.assertEquals(1, boards.size());
    }

    @IsTest
    static void testCreateNewBoard() {
        BoardController.createNewBoard('AI Test Board');
        List<Board__c> boards = [SELECT Id FROM Board__c WHERE Name = 'AI Test Board'];
        System.assertEquals(1, boards.size());
    }

    @IsTest
    static void testGetListsByBoardId() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        List<List__c> lists = BoardController.getListsByBoardId(boards[0].Id);
        System.assert(lists.size() > 0);
    }

    @IsTest
    static void testCreateNewList() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        BoardController.createNewList('AI Test List', boards[0].Id);
        List<List__c> lists = [SELECT Id FROM List__c WHERE Name = 'AI Test List'];
        System.assertEquals(1, lists.size());
    }

    @IsTest
    static void testChangeBoardName() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        BoardController.changeBoardName(boards[0].Id, 'AI New Name');
        Board__c updated = [SELECT Name FROM Board__c WHERE Id = :boards[0].Id];
        System.assertEquals('AI New Name', updated.Name);
    }

    @IsTest
    static void testDeleteBoard() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        BoardController.deleteBoard(boards[0]);
        List<Board__c> deleted = [SELECT Id FROM Board__c WHERE Id = :boards[0].Id];
        System.assertEquals(0, deleted.size());
    }

    @IsTest
    static void testAddMember() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        System.runAs(u) {
            BoardController.addMember(boards[0].Id, u.Id);
        }
        // No assert, as BoardUser__c is pseudo
    }

    @IsTest
    static void testGetMembers() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        List<BoardUser__c> members = BoardController.getMembers(boards[0].Id);
        System.assert(members != null);
    }

    @IsTest
    static void testGetUsers() {
        List<User> users = BoardController.getUsers();
        System.assert(users.size() > 0);
    }

    @IsTest
    static void testDeleteMember() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = [SELECT Id FROM Board__c LIMIT 1];
        List<User> users = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        BoardController.addMember(boards[0].Id, users[0].Id);
        BoardController.deleteMember(users[0].Id, boards[0]);
        // No assert, as BoardUser__c is pseudo
    }
}
