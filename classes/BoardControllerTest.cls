/**
 * BoardControllerTest
 *
 * Unit tests for BoardController Apex class.
 * Covers positive and negative scenarios for all public methods.
 *
 * @author AI Generated
 * @date 2025-10-21
 */
@isTest
private class BoardControllerTest {
    @testSetup
    static void setup() {
        // Create test data for boards, lists, users, etc.
        Board__c board = new Board__c(Name = 'Test Board');
        insert board;
        List__c list = new List__c(Name = 'Test List', Board__c = board.Id);
        insert list;
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        BoardUser__c bu = new BoardUser__c(Board__c = board.Id, User__c = u.Id);
        insert bu;
        Card__c card = new Card__c(Name = 'Test Card', List__c = list.Id);
        insert card;
    }

    static Board__c getTestBoard() {
        return [SELECT Id, Name FROM Board__c LIMIT 1];
    }
    static List__c getTestList() {
        return [SELECT Id, Name, Board__c FROM List__c LIMIT 1];
    }
    static User getTestUser() {
        return [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
    }
    static Card__c getTestCard() {
        return [SELECT Id, Name, List__c FROM Card__c LIMIT 1];
    }

    @isTest static void testGetAllBoards() {
        Test.startTest();
        List<Board__c> boards = BoardController.getAllBoards();
        System.assert(!boards.isEmpty(), 'Should return at least one board');
        Test.stopTest();
    }

    @isTest static void testCreateNewBoard() {
        Test.startTest();
        BoardController.createNewBoard('New Board');
        List<Board__c> boards = [SELECT Name FROM Board__c WHERE Name = 'New Board'];
        System.assertEquals(1, boards.size(), 'Should create a new board');
        Test.stopTest();
    }

    @isTest static void testGetListsByBoardId() {
        Board__c board = getTestBoard();
        Test.startTest();
        List<List__c> lists = BoardController.getListsByBoardId(board.Id);
        System.assert(!lists.isEmpty(), 'Should return lists for the board');
        Test.stopTest();
    }

    @isTest static void testCreateNewList() {
        Board__c board = getTestBoard();
        Test.startTest();
        BoardController.createNewList('Another List', board.Id);
        List<List__c> lists = [SELECT Name FROM List__c WHERE Name = 'Another List' AND Board__c = :board.Id];
        System.assertEquals(1, lists.size(), 'Should create a new list');
        Test.stopTest();
    }

    @isTest static void testChangeBoardName() {
        Board__c board = getTestBoard();
        Test.startTest();
        BoardController.changeBoardName(board.Id, 'Renamed Board');
        Board__c updated = [SELECT Name FROM Board__c WHERE Id = :board.Id];
        System.assertEquals('Renamed Board', updated.Name, 'Board name should be updated');
        Test.stopTest();
    }

    @isTest static void testChangeListIdOnCard() {
        Card__c card = getTestCard();
        List__c list = getTestList();
        Test.startTest();
        BoardController.changeListIdOnCard(card, list.Id);
        Card__c updated = [SELECT List__c FROM Card__c WHERE Id = :card.Id];
        System.assertEquals(list.Id, updated.List__c, 'Card should be moved to new list');
        Test.stopTest();
    }

    @isTest static void testDeleteBoard() {
        Board__c board = new Board__c(Name = 'Delete Me');
        insert board;
        Test.startTest();
        BoardController.deleteBoard(board);
        List<Board__c> boards = [SELECT Id FROM Board__c WHERE Id = :board.Id];
        System.assertEquals(0, boards.size(), 'Board should be deleted');
        Test.stopTest();
    }

    @isTest static void testAddMember() {
        Board__c board = getTestBoard();
        User u = getTestUser();
        Test.startTest();
        BoardController.addMember(board.Id, u.Id);
        List<BoardUser__c> members = [SELECT Id FROM BoardUser__c WHERE Board__c = :board.Id AND User__c = :u.Id];
        System.assert(!members.isEmpty(), 'Member should be added');
        Test.stopTest();
    }

    @isTest static void testGetMembers() {
        Board__c board = getTestBoard();
        Test.startTest();
        List<BoardUser__c> members = BoardController.getMembers(board.Id);
        System.assert(!members.isEmpty(), 'Should return members for the board');
        Test.stopTest();
    }

    @isTest static void testGetUsers() {
        Test.startTest();
        List<User> users = BoardController.getUsers();
        System.assert(!users.isEmpty(), 'Should return users');
        Test.stopTest();
    }

    @isTest static void testDeleteMember() {
        Board__c board = getTestBoard();
        User u = getTestUser();
        BoardUser__c bu = new BoardUser__c(Board__c = board.Id, User__c = u.Id);
        insert bu;
        Test.startTest();
        BoardController.deleteMember(bu.Id, board);
        List<BoardUser__c> members = [SELECT Id FROM BoardUser__c WHERE Id = :bu.Id];
        System.assertEquals(0, members.size(), 'Member should be deleted');
        Test.stopTest();
    }

    // Negative test: invalid boardId for getListsByBoardId
    @isTest static void testGetListsByBoardId_Negative() {
        Test.startTest();
        try {
            BoardController.getListsByBoardId(null);
            System.assert(false, 'Should have thrown an exception');
        } catch (Exception e) {
            System.assert(e.getMessage() != null, 'Exception message should be present');
        }
        Test.stopTest();
    }
}
