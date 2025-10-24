/**
 * ListControllerTest
 * @author AI
 * @description Unit tests for ListController class. Covers main logic paths, positive and negative scenarios.
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
        // Test method
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
        // Test method
        Test.startTest();
        List<Card__c> cards = ListController.getCardsOnList(testList.Id);
        Test.stopTest();
        System.assertEquals(0, cards.size(), 'Should return no cards for empty list');
    }

    @isTest
    static void testCreateNewCard() {
        List__c testList = new List__c(Name = 'List for New Card');
        insert testList;
        Test.startTest();
        ListController.createNewCard('New Card', testList.Id);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id, Name FROM Card__c WHERE List__c = :testList.Id];
        System.assertEquals(1, cards.size(), 'Should create one new card');
        System.assertEquals('New Card', cards[0].Name, 'Card name should match');
    }

    @isTest
    static void testChangeListName() {
        List__c testList = new List__c(Name = 'Old Name');
        insert testList;
        Test.startTest();
        ListController.changeListName(testList, 'New Name');
        Test.stopTest();
        testList = [SELECT Name FROM List__c WHERE Id = :testList.Id];
        System.assertEquals('New Name', testList.Name, 'List name should be updated');
    }

    @isTest
    static void testDeleteList() {
        List__c testList = new List__c(Name = 'List to Delete');
        insert testList;
        Test.startTest();
        ListController.deleteList(testList);
        Test.stopTest();
        List<List__c> lists = [SELECT Id FROM List__c WHERE Id = :testList.Id];
        System.assertEquals(0, lists.size(), 'List should be deleted');
    }

    @isTest
    static void testDeleteCard() {
        List__c testList = new List__c(Name = 'List for Card');
        insert testList;
        Card__c testCard = new Card__c(Name = 'Card to Delete', List__c = testList.Id);
        insert testCard;
        Test.startTest();
        ListController.deleteCard(testCard);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id FROM Card__c WHERE Id = :testCard.Id];
        System.assertEquals(0, cards.size(), 'Card should be deleted');
    }
}
