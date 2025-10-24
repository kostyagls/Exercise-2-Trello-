/**
 * ListControllerTest
 *
 * Unit tests for ListController Apex class.
 *
 * @author AI Pilot
 * @date 2024-06-XX
 */
@isTest
private class ListControllerTest {
    @testSetup
    static void setupTestData() {
        // Create Board, List, Card, User, BoardUser, CardUser, File test data
        Board__c board = new Board__c(Name = 'Test Board');
        insert board;
        List__c list = new List__c(Name = 'Test List', Board__c = board.Id);
        insert list;
        Card__c card = new Card__c(Name = 'Test Card', List__c = list.Id);
        insert card;
        User u = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];
        BoardUser__c bu = new BoardUser__c(Board__c = board.Id, User__c = u.Id);
        insert bu;
        CardUser__c cu = new CardUser__c(Card__c = card.Id, User__c = u.Id);
        insert cu;
        File__c file = new File__c(Name = 'TestFile.txt', Card__c = card.Id);
        insert file;
    }

    static Id getTestListId() {
        return [SELECT Id FROM List__c LIMIT 1].Id;
    }
    static Id getTestCardId() {
        return [SELECT Id FROM Card__c LIMIT 1].Id;
    }
    static Id getTestBoardId() {
        return [SELECT Id FROM Board__c LIMIT 1].Id;
    }
    static Id getTestBoardUserId() {
        return [SELECT Id FROM BoardUser__c LIMIT 1].Id;
    }
    static Id getTestCardUserId() {
        return [SELECT Id FROM CardUser__c LIMIT 1].Id;
    }
    static Id getTestFileId() {
        return [SELECT Id FROM File__c LIMIT 1].Id;
    }

    @isTest
    static void testGetCardsOnList_Positive() {
        List<Card__c> cards = ListController.getCardsOnList(getTestListId());
        System.assert(cards != null, 'Should return cards');
    }

    @isTest
    static void testCreateNewCard_Positive() {
        Test.startTest();
        ListController.createNewCard('New Card', getTestListId());
        Test.stopTest();
        List<Card__c> cards = [SELECT Id FROM Card__c WHERE Name = 'New Card'];
        System.assertEquals(1, cards.size(), 'Should create a new card');
    }

    @isTest
    static void testChangeListName_Positive() {
        List__c list = [SELECT Id, Name FROM List__c LIMIT 1];
        Test.startTest();
        ListController.changeListName(list, 'Renamed List');
        Test.stopTest();
        list = [SELECT Name FROM List__c WHERE Id = :list.Id];
        System.assertEquals('Renamed List', list.Name, 'List name should be updated');
    }

    @isTest
    static void testDeleteList_Positive() {
        List__c list = new List__c(Name = 'ToDelete', Board__c = getTestBoardId());
        insert list;
        Test.startTest();
        ListController.deleteList(list);
        Test.stopTest();
        List<List__c> lists = [SELECT Id FROM List__c WHERE Id = :list.Id];
        System.assertEquals(0, lists.size(), 'List should be deleted');
    }

    @isTest
    static void testDeleteCard_Positive() {
        Card__c card = new Card__c(Name = 'ToDeleteCard', List__c = getTestListId());
        insert card;
        Test.startTest();
        ListController.deleteCard(card);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id FROM Card__c WHERE Id = :card.Id];
        System.assertEquals(0, cards.size(), 'Card should be deleted');
    }

    @isTest
    static void testGetCardMembers_Positive() {
        List<CardUser__c> members = ListController.getCardMembers(getTestCardId());
        System.assert(members != null, 'Should return card members');
    }

    @isTest
    static void testGetBoardMembers_Positive() {
        List<BoardUser__c> members = ListController.getBoardMembers(getTestBoardId());
        System.assert(members != null, 'Should return board members');
    }

    @isTest
    static void testAddCardMember_Positive() {
        Card__c card = [SELECT Id FROM Card__c LIMIT 1];
        BoardUser__c bu = [SELECT Id FROM BoardUser__c LIMIT 1];
        Test.startTest();
        ListController.addCardMember(card.Id, bu.Id);
        Test.stopTest();
        // No exception = pass
        System.assert(true, 'addCardMember executed');
    }

    @isTest
    static void testDeleteCardMember_Positive() {
        Card__c card = [SELECT Id FROM Card__c LIMIT 1];
        BoardUser__c bu = [SELECT Id FROM BoardUser__c LIMIT 1];
        Test.startTest();
        ListController.deleteCardMember(card.Id, bu.Id);
        Test.stopTest();
        // No exception = pass
        System.assert(true, 'deleteCardMember executed');
    }

    @isTest
    static void testCreateFile_Positive() {
        Card__c card = [SELECT Id, Name FROM Card__c LIMIT 1];
        Test.startTest();
        List<File__c> files = ListController.createFile('UniqueFile.txt', 'TestContent', card);
        Test.stopTest();
        System.assert(files != null, 'Should create file');
    }

    @isTest
    static void testGetFiles_Positive() {
        Card__c card = [SELECT Id FROM Card__c LIMIT 1];
        List<File__c> files = ListController.getFiles(card.Id);
        System.assert(files != null, 'Should return files');
    }

    @isTest
    static void testDeleteFile_Positive() {
        File__c file = [SELECT Id, Name, Card__c FROM File__c LIMIT 1];
        Card__c card = [SELECT Name FROM Card__c WHERE Id = :file.Card__c LIMIT 1];
        Test.startTest();
        ListController.deleteFile(file, card.Name);
        Test.stopTest();
        // No exception = pass
        System.assert(true, 'deleteFile executed');
    }

    @isTest
    static void testCreateFile_Duplicate() {
        Card__c card = [SELECT Id, Name FROM Card__c LIMIT 1];
        // Insert a file with the same name
        File__c file = new File__c(Name = 'DuplicateFile.txt', Card__c = card.Id);
        insert file;
        Boolean exceptionThrown = false;
        try {
            ListController.createFile('DuplicateFile.txt', 'TestContent', card);
        } catch (Exception e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown, 'Exception should be thrown for duplicate file');
    }
}
