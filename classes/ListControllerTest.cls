/**
 * ListControllerTest
 * Unit tests for ListController class.
 * @author AI
 * @date 2025-10-22
 */
@isTest
public class ListControllerTest {
    @isTest
    static void testGetCardsOnList_Positive() {
        // Setup test data
        List__c testList = new List__c(Name = 'Test List');
        insert testList;
        Card__c testCard = new Card__c(Name = 'Test Card', List__c = testList.Id);
        insert testCard;
        Test.startTest();
        List<Card__c> cards = ListController.getCardsOnList(testList.Id);
        Test.stopTest();
        System.assertEquals(1, cards.size(), 'Should return one card');
        System.assertEquals(testCard.Id, cards[0].Id, 'Returned card should match inserted card');
    }

    @isTest
    static void testGetCardsOnList_Negative() {
        // Setup test data
        List__c testList = new List__c(Name = 'Empty List');
        insert testList;
        Test.startTest();
        List<Card__c> cards = ListController.getCardsOnList(testList.Id);
        Test.stopTest();
        System.assertEquals(0, cards.size(), 'Should return no cards for empty list');
    }

    @isTest
    static void testCreateNewCard() {
        List__c testList = new List__c(Name = 'Create Card List');
        insert testList;
        Test.startTest();
        ListController.createNewCard('New Card', testList.Id);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id, Name FROM Card__c WHERE List__c = :testList.Id];
        System.assertEquals(1, cards.size(), 'Should create one card');
        System.assertEquals('New Card', cards[0].Name, 'Card name should match');
    }

    @isTest
    static void testChangeListName() {
        List__c testList = new List__c(Name = 'Old Name');
        insert testList;
        Test.startTest();
        ListController.changeListName(testList, 'New Name');
        Test.stopTest();
        List__c updatedList = [SELECT Name FROM List__c WHERE Id = :testList.Id];
        System.assertEquals('New Name', updatedList.Name, 'List name should be updated');
    }

    @isTest
    static void testDeleteList() {
        List__c testList = new List__c(Name = 'Delete Me');
        insert testList;
        Test.startTest();
        ListController.deleteList(testList);
        Test.stopTest();
        List<List__c> lists = [SELECT Id FROM List__c WHERE Id = :testList.Id];
        System.assertEquals(0, lists.size(), 'List should be deleted');
    }

    @isTest
    static void testDeleteCard() {
        List__c testList = new List__c(Name = 'List For Card');
        insert testList;
        Card__c testCard = new Card__c(Name = 'Delete Card', List__c = testList.Id);
        insert testCard;
        Test.startTest();
        ListController.deleteCard(testCard);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id FROM Card__c WHERE Id = :testCard.Id];
        System.assertEquals(0, cards.size(), 'Card should be deleted');
    }

    @isTest
    static void testGetCardMembers() {
        Card__c testCard = new Card__c(Name = 'Card For Members');
        insert testCard;
        CardUser__c member = new CardUser__c(Card__c = testCard.Id, Name = 'Member');
        insert member;
        Test.startTest();
        List<CardUser__c> members = ListController.getCardMembers(testCard.Id);
        Test.stopTest();
        System.assertEquals(1, members.size(), 'Should return one member');
        System.assertEquals(member.Id, members[0].Id, 'Returned member should match inserted member');
    }

    @isTest
    static void testGetBoardMembers() {
        Board__c board = new Board__c(Name = 'Board For Members');
        insert board;
        BoardUser__c member = new BoardUser__c(Board__c = board.Id, Name = 'Board Member');
        insert member;
        Test.startTest();
        List<BoardUser__c> members = ListController.getBoardMembers(board.Id);
        Test.stopTest();
        System.assertEquals(1, members.size(), 'Should return one board member');
        System.assertEquals(member.Id, members[0].Id, 'Returned member should match inserted member');
    }

    @isTest
    static void testAddAndDeleteCardMember() {
        Card__c testCard = new Card__c(Name = 'Card For Add/Delete Member');
        insert testCard;
        BoardUser__c boardMember = new BoardUser__c(Name = 'Board Member');
        insert boardMember;
        Test.startTest();
        ListController.addCardMember(testCard.Id, boardMember.Id);
        Test.stopTest();
        List<CardUser__c> members = [SELECT Id FROM CardUser__c WHERE Card__c = :testCard.Id AND BoardUser__c = :boardMember.Id];
        System.assertEquals(1, members.size(), 'Should add card member');
        Test.startTest();
        ListController.deleteCardMember(testCard.Id, boardMember.Id);
        Test.stopTest();
        members = [SELECT Id FROM CardUser__c WHERE Card__c = :testCard.Id AND BoardUser__c = :boardMember.Id];
        System.assertEquals(0, members.size(), 'Should delete card member');
    }

    @isTest
    static void testCreateFileAndGetFiles() {
        Card__c testCard = new Card__c(Name = 'Card For File');
        insert testCard;
        Test.startTest();
        List<File__c> files = ListController.createFile('TestFile.txt', 'Test Content', testCard);
        Test.stopTest();
        System.assertEquals(1, files.size(), 'Should create one file');
        Test.startTest();
        List<File__c> fetchedFiles = ListController.getFiles(testCard.Id);
        Test.stopTest();
        System.assertEquals(1, fetchedFiles.size(), 'Should fetch one file');
    }

    @isTest
    static void testDeleteFile() {
        Card__c testCard = new Card__c(Name = 'Card For File Delete');
        insert testCard;
        File__c file = new File__c(Name = 'DeleteMe.txt', Card__c = testCard.Id);
        insert file;
        Test.startTest();
        ListController.deleteFile(file, testCard.Name);
        Test.stopTest();
        List<File__c> files = [SELECT Id FROM File__c WHERE Id = :file.Id];
        System.assertEquals(0, files.size(), 'File should be deleted');
    }
}
