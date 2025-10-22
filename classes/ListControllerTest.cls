/**
 * @author AI
 * @description Unit tests for ListController
 * @date 2025-10-22
 */
@isTest
private class ListControllerTest {
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
    static void testGetCardsOnList_Exception() {
        Test.startTest();
        try {
            ListController.getCardsOnList(null);
            System.assert(false, 'Exception should have been thrown');
        } catch (Exception e) {
            System.assert(e.getMessage() != null, 'Exception message should not be null');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateNewCard_Positive() {
        List__c testList = new List__c(Name = 'Test List');
        insert testList;
        Test.startTest();
        ListController.createNewCard('New Card', testList.Id);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id FROM Card__c WHERE List__c = :testList.Id];
        System.assert(cards.size() > 0, 'Card should be created');
    }

    @isTest
    static void testChangeListName_Positive() {
        List__c testList = new List__c(Name = 'Old Name');
        insert testList;
        Test.startTest();
        ListController.changeListName(testList, 'New Name');
        Test.stopTest();
        List__c updatedList = [SELECT Name FROM List__c WHERE Id = :testList.Id];
        System.assertEquals('New Name', updatedList.Name, 'List name should be updated');
    }

    @isTest
    static void testDeleteList_Positive() {
        List__c testList = new List__c(Name = 'To Delete');
        insert testList;
        Test.startTest();
        ListController.deleteList(testList);
        Test.stopTest();
        List<List__c> lists = [SELECT Id FROM List__c WHERE Id = :testList.Id];
        System.assertEquals(0, lists.size(), 'List should be deleted');
    }

    @isTest
    static void testDeleteCard_Positive() {
        List__c testList = new List__c(Name = 'List');
        insert testList;
        Card__c testCard = new Card__c(Name = 'Card', List__c = testList.Id);
        insert testCard;
        Test.startTest();
        ListController.deleteCard(testCard);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id FROM Card__c WHERE Id = :testCard.Id];
        System.assertEquals(0, cards.size(), 'Card should be deleted');
    }

    @isTest
    static void testGetCardMembers_Positive() {
        Card__c testCard = new Card__c(Name = 'Card');
        insert testCard;
        CardUser__c member = new CardUser__c(Card__c = testCard.Id, Name = 'Member');
        insert member;
        Test.startTest();
        List<CardUser__c> members = ListController.getCardMembers(testCard.Id);
        Test.stopTest();
        System.assertEquals(1, members.size(), 'Should return one member');
    }

    @isTest
    static void testGetBoardMembers_Positive() {
        Board__c board = new Board__c(Name = 'Board');
        insert board;
        BoardUser__c member = new BoardUser__c(Board__c = board.Id, Name = 'Member');
        insert member;
        Test.startTest();
        List<BoardUser__c> members = ListController.getBoardMembers(board.Id);
        Test.stopTest();
        System.assertEquals(1, members.size(), 'Should return one board member');
    }

    @isTest
    static void testAddCardMember_Positive() {
        Card__c card = new Card__c(Name = 'Card');
        insert card;
        BoardUser__c boardUser = new BoardUser__c(Name = 'BoardUser');
        insert boardUser;
        Test.startTest();
        ListController.addCardMember(card.Id, boardUser.Id);
        Test.stopTest();
        List<CardUser__c> members = [SELECT Id FROM CardUser__c WHERE Card__c = :card.Id];
        System.assert(members.size() > 0, 'Card member should be added');
    }

    @isTest
    static void testDeleteCardMember_Positive() {
        Card__c card = new Card__c(Name = 'Card');
        insert card;
        BoardUser__c boardUser = new BoardUser__c(Name = 'BoardUser');
        insert boardUser;
        CardUser__c member = new CardUser__c(Card__c = card.Id, BoardUser__c = boardUser.Id);
        insert member;
        Test.startTest();
        ListController.deleteCardMember(card.Id, boardUser.Id);
        Test.stopTest();
        List<CardUser__c> members = [SELECT Id FROM CardUser__c WHERE Card__c = :card.Id];
        System.assertEquals(0, members.size(), 'Card member should be deleted');
    }
}
