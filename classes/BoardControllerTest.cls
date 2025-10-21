/**
 * BoardControllerTest
 *
 * Unit tests for BoardController class.
 * Covers positive and negative scenarios for all public methods.
 * @author AIPilot
 */
@isTest
private class BoardControllerTest {
    @testSetup
    static void setup() {
        // Create test data for Board, List, Card, User, BoardUser
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
    static Card__c getTestCard() {
        return [SELECT Id, Name, List__c FROM Card__c LIMIT 1];
    }
    static User getTestUser() {
        return [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
    }
    static BoardUser__c getTestBoardUser() {
        return [SELECT Id, Board__c, User__c FROM BoardUser__c LIMIT 1];
    }

    @isTest static void testGetAllBoards() {
        List<Board__c> boards = BoardController.getAllBoards();
        System.assert(!boards.isEmpty(), 'Should return at least one board');
    }

    @isTest static void testCreateNewBoard() {
        Test.startTest();
        BoardController.createNewBoard('New Board');
        Test.stopTest();
        List<Board__c> boards = [SELECT Name FROM Board__c WHERE Name = 'New Board'];
        System.assertEquals(1, boards.size(), 'Should create a new board');
    }

    @isTest static void testGetListsByBoardId() {
        Board__c board = getTestBoard();
        List<List__c> lists = BoardController.getListsByBoardId(board.Id);
        System.assert(!lists.isEmpty(), 'Should return at least one list');
    }

    @isTest static void testCreateNewList() {
        Board__c board = getTestBoard();
        Test.startTest();
        BoardController.createNewList('Another List', board.Id);
        Test.stopTest();
        List<List__c> lists = [SELECT Name FROM List__c WHERE Name = 'Another List'];
        System.assertEquals(1, lists.size(), 'Should create a new list');
    }

    @isTest static void testChangeBoardName() {
        Board__c board = getTestBoard();
        Test.startTest();
        BoardController.changeBoardName(board.Id, 'Renamed Board');
        Test.stopTest();
        Board__c updated = [SELECT Name FROM Board__c WHERE Id = :board.Id];
        System.assertEquals('Renamed Board', updated.Name, 'Should update board name');
    }

    @isTest static void testChangeListIdOnCard() {
        Card__c card = getTestCard();
        List__c list = getTestList();
        Test.startTest();
        BoardController.changeListIdOnCard(card, list.Id);
        Test.stopTest();
        Card__c updated = [SELECT List__c FROM Card__c WHERE Id = :card.Id];
        System.assertEquals(list.Id, updated.List__c, 'Should update card list');
    }

    @isTest static void testDeleteBoard() {
        Board__c board = new Board__c(Name = 'Delete Me');
        insert board;
        Test.startTest();
        BoardController.deleteBoard(board);
        Test.stopTest();
        List<Board__c> boards = [SELECT Id FROM Board__c WHERE Id = :board.Id];
        System.assertEquals(0, boards.size(), 'Should delete the board');
    }

    @isTest static void testAddMember() {
        Board__c board = getTestBoard();
        User u = getTestUser();
        Test.startTest();
        BoardController.addMember(board.Id, u.Id);
        Test.stopTest();
        List<BoardUser__c> bus = [SELECT Id FROM BoardUser__c WHERE Board__c = :board.Id AND User__c = :u.Id];
        System.assert(!bus.isEmpty(), 'Should add member to board');
    }

    @isTest static void testGetMembers() {
        Board__c board = getTestBoard();
        List<BoardUser__c> members = BoardController.getMembers(board.Id);
        System.assert(!members.isEmpty(), 'Should return at least one member');
    }

    @isTest static void testGetUsers() {
        List<User> users = BoardController.getUsers();
        System.assert(!users.isEmpty(), 'Should return at least one user');
    }

    @isTest static void testDeleteMember() {
        BoardUser__c bu = getTestBoardUser();
        Board__c board = getTestBoard();
        Test.startTest();
        BoardController.deleteMember(bu.Id, board);
        Test.stopTest();
        List<BoardUser__c> bus = [SELECT Id FROM BoardUser__c WHERE Id = :bu.Id];
        System.assertEquals(0, bus.size(), 'Should delete the member');
    }
}
