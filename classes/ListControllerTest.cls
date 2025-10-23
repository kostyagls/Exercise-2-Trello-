/**
 * ListControllerTest
 * Unit tests for ListController Apex class.
 * @author AI
 */
@isTest
private class ListControllerTest {
    @testSetup
    static void setup() {
        // Create test Board, List, Card, and User
        Board__c board = new Board__c(Name = 'Test Board');
        insert board;
        List__c list = new List__c(Name = 'Test List', Board__c = board.Id);
        insert list;
        Card__c card = new Card__c(Name = 'Test Card', List__c = list.Id);
        insert card;
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        BoardUser__c bu = new BoardUser__c(Board__c = board.Id, User__c = u.Id);
        insert bu;
    }

    static testMethod void testGetCardsOnList() {
        List__c list = [SELECT Id FROM List__c LIMIT 1];
        Test.startTest();
        List<Card__c> cards = ListController.getCardsOnList(list.Id);
        Test.stopTest();
        System.assert(cards != null, 'Should return cards');
    }

    static testMethod void testCreateNewCard() {
        List__c list = [SELECT Id FROM List__c LIMIT 1];
        Test.startTest();
        ListController.createNewCard('New Card', list.Id);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id FROM Card__c WHERE Name = 'New Card'];
        System.assertEquals(1, cards.size(), 'Should create a new card');
    }

    static testMethod void testChangeListName() {
        List__c list = [SELECT Id, Name FROM List__c LIMIT 1];
        Test.startTest();
        ListController.changeListName(list, 'Changed Name');
        Test.stopTest();
        List__c updated = [SELECT Name FROM List__c WHERE Id = :list.Id];
        System.assertEquals('Changed Name', updated.Name, 'List name should be updated');
    }

    static testMethod void testDeleteList() {
        List__c list = new List__c(Name = 'To Delete', Board__c = [SELECT Id FROM Board__c LIMIT 1].Id);
        insert list;
        Test.startTest();
        ListController.deleteList(list);
        Test.stopTest();
        List<List__c> lists = [SELECT Id FROM List__c WHERE Id = :list.Id];
        System.assertEquals(0, lists.size(), 'List should be deleted');
    }

    static testMethod void testDeleteCard() {
        Card__c card = new Card__c(Name = 'To Delete', List__c = [SELECT Id FROM List__c LIMIT 1].Id);
        insert card;
        Test.startTest();
        ListController.deleteCard(card);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id FROM Card__c WHERE Id = :card.Id];
        System.assertEquals(0, cards.size(), 'Card should be deleted');
    }

    static testMethod void testGetCardMembers() {
        Card__c card = [SELECT Id FROM Card__c LIMIT 1];
        Test.startTest();
        List<CardUser__c> members = ListController.getCardMembers(card.Id);
        Test.stopTest();
        System.assert(members != null, 'Should return card members');
    }

    static testMethod void testGetBoardMembers() {
        Board__c board = [SELECT Id FROM Board__c LIMIT 1];
        Test.startTest();
        List<BoardUser__c> members = ListController.getBoardMembers(board.Id);
        Test.stopTest();
        System.assert(members != null, 'Should return board members');
    }

    static testMethod void testAddAndDeleteCardMember() {
        Card__c card = [SELECT Id FROM Card__c LIMIT 1];
        BoardUser__c bu = [SELECT Id FROM BoardUser__c LIMIT 1];
        Test.startTest();
        ListController.addCardMember(card.Id, bu.Id);
        Test.stopTest();
        // Assume addCardMember creates a CardUser__c record
        List<CardUser__c> members = [SELECT Id FROM CardUser__c WHERE Card__c = :card.Id AND BoardUser__c = :bu.Id];
        System.assert(members.size() > 0, 'Should add card member');
        Test.startTest();
        ListController.deleteCardMember(card.Id, bu.Id);
        Test.stopTest();
        members = [SELECT Id FROM CardUser__c WHERE Card__c = :card.Id AND BoardUser__c = :bu.Id];
        System.assertEquals(0, members.size(), 'Should delete card member');
    }

    static testMethod void testCreateFileAndGetFiles() {
        Card__c card = [SELECT Id, Name FROM Card__c LIMIT 1];
        Test.startTest();
        List<File__c> files = ListController.createFile('TestFile.txt', 'TestContent', card);
        Test.stopTest();
        System.assert(files != null, 'Should create file');
        Test.startTest();
        List<File__c> fetched = ListController.getFiles(card.Id);
        Test.stopTest();
        System.assert(fetched != null, 'Should get files');
    }

    static testMethod void testDeleteFile() {
        Card__c card = [SELECT Id, Name FROM Card__c LIMIT 1];
        File__c file = new File__c(Name = 'ToDelete.txt', Card__c = card.Id);
        insert file;
        Test.startTest();
        ListController.deleteFile(file, card.Name);
        Test.stopTest();
        List<File__c> files = [SELECT Id FROM File__c WHERE Id = :file.Id];
        System.assertEquals(0, files.size(), 'File should be deleted');
    }
}
