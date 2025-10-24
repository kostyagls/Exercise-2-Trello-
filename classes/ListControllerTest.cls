/**
 * Unit test for ListController
 * @author AI
 */
@isTest
private class ListControllerTest {
    /**
     * Test getCardsOnList with valid and invalid input
     */
    @isTest static void testGetCardsOnList() {
        // Setup test data
        List__c testList = new List__c(Name='Test List');
        insert testList;
        Card__c testCard = new Card__c(Name='Test Card', List__c=testList.Id);
        insert testCard;
        // Positive scenario
        Test.startTest();
        List<Card__c> cards = ListController.getCardsOnList(testList.Id);
        Test.stopTest();
        System.assertEquals(1, cards.size(), 'Should return 1 card');
        // Negative scenario
        try {
            ListController.getCardsOnList(null);
            System.assert(false, 'Should have thrown an exception');
        } catch (Exception e) {
            System.assert(e.getMessage() != null);
        }
    }

    /**
     * Test createNewCard
     */
    @isTest static void testCreateNewCard() {
        List__c testList = new List__c(Name='Test List 2');
        insert testList;
        Test.startTest();
        ListController.createNewCard('Card Name', testList.Id);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id FROM Card__c WHERE List__c = :testList.Id];
        System.assertEquals(1, cards.size(), 'Card should be created');
    }

    /**
     * Test changeListName
     */
    @isTest static void testChangeListName() {
        List__c testList = new List__c(Name='Old Name');
        insert testList;
        Test.startTest();
        ListController.changeListName(testList, 'New Name');
        Test.stopTest();
        List__c updated = [SELECT Name FROM List__c WHERE Id = :testList.Id];
        System.assertEquals('New Name', updated.Name, 'List name should be updated');
    }

    /**
     * Test deleteList
     */
    @isTest static void testDeleteList() {
        List__c testList = new List__c(Name='To Delete');
        insert testList;
        Test.startTest();
        ListController.deleteList(testList);
        Test.stopTest();
        List<List__c> lists = [SELECT Id FROM List__c WHERE Id = :testList.Id];
        System.assertEquals(0, lists.size(), 'List should be deleted');
    }

    /**
     * Test deleteCard
     */
    @isTest static void testDeleteCard() {
        List__c testList = new List__c(Name='List for Card');
        insert testList;
        Card__c testCard = new Card__c(Name='Card to Delete', List__c=testList.Id);
        insert testCard;
        Test.startTest();
        ListController.deleteCard(testCard);
        Test.stopTest();
        List<Card__c> cards = [SELECT Id FROM Card__c WHERE Id = :testCard.Id];
        System.assertEquals(0, cards.size(), 'Card should be deleted');
    }

    /**
     * Test getCardMembers and getBoardMembers
     */
    @isTest static void testGetMembers() {
        // Setup
        List__c testList = new List__c(Name='List for Members');
        insert testList;
        Card__c testCard = new Card__c(Name='Card for Members', List__c=testList.Id);
        insert testCard;
        Board__c testBoard = new Board__c(Name='Board for Members');
        insert testBoard;
        BoardUser__c testBoardUser = new BoardUser__c(Board__c=testBoard.Id, User__c=UserInfo.getUserId());
        insert testBoardUser;
        CardUser__c testCardUser = new CardUser__c(Card__c=testCard.Id, User__c=UserInfo.getUserId());
        insert testCardUser;
        // Test
        Test.startTest();
        List<CardUser__c> cardMembers = ListController.getCardMembers(testCard.Id);
        List<BoardUser__c> boardMembers = ListController.getBoardMembers(testBoard.Id);
        Test.stopTest();
        System.assert(cardMembers.size() > 0, 'Should return card members');
        System.assert(boardMembers.size() > 0, 'Should return board members');
    }

    /**
     * Test addCardMember and deleteCardMember
     */
    @isTest static void testAddDeleteCardMember() {
        List__c testList = new List__c(Name='List for CardMember');
        insert testList;
        Card__c testCard = new Card__c(Name='Card for CardMember', List__c=testList.Id);
        insert testCard;
        BoardUser__c testBoardUser = new BoardUser__c(Board__c=testList.Id, User__c=UserInfo.getUserId());
        insert testBoardUser;
        Test.startTest();
        ListController.addCardMember(testCard.Id, testBoardUser.Id);
        ListController.deleteCardMember(testCard.Id, testBoardUser.Id);
        Test.stopTest();
        // No assert, just check no exceptions
    }

    /**
     * Test createFile and getFiles
     */
    @isTest static void testCreateFileAndGetFiles() {
        List__c testList = new List__c(Name='List for File');
        insert testList;
        Card__c testCard = new Card__c(Name='Card for File', List__c=testList.Id);
        insert testCard;
        Test.startTest();
        List<File__c> files = ListController.createFile('TestFile.txt', 'content', testCard);
        List<File__c> fetched = ListController.getFiles(testCard.Id);
        Test.stopTest();
        System.assert(files.size() > 0, 'File should be created');
        System.assert(fetched.size() > 0, 'Should fetch files');
    }

    /**
     * Test deleteFile
     */
    @isTest static void testDeleteFile() {
        List__c testList = new List__c(Name='List for DeleteFile');
        insert testList;
        Card__c testCard = new Card__c(Name='Card for DeleteFile', List__c=testList.Id);
        insert testCard;
        File__c testFile = new File__c(Name='FileToDelete', Card__c=testCard.Id);
        insert testFile;
        Test.startTest();
        ListController.deleteFile(testFile, testCard.Name);
        Test.stopTest();
        List<File__c> files = [SELECT Id FROM File__c WHERE Id = :testFile.Id];
        System.assertEquals(0, files.size(), 'File should be deleted');
    }
}
