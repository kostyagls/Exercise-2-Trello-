/*
 * TestBoardControllerTest.cls
 * AI-generated test class for BoardController
 * Author: AI Assistant
 * Last Modified: 2024-06
 *
 * This class provides additional coverage for BoardController methods.
 */
@IsTest
public class TestBoardControllerTest {
    @IsTest
    static void testGetAllBoardsCoverage() {
        TestDataFactory.insertBoardAndListTestData();
        List<Board__c> boards = BoardController.getAllBoards();
        System.assert(boards != null);
    }

    @IsTest
    static void testCreateNewBoardCoverage() {
        Test.startTest();
        BoardController.createNewBoard('AI Test Board');
        Test.stopTest();
        List<Board__c> boards = [SELECT Id FROM Board__c WHERE Name = 'AI Test Board' LIMIT 1];
        System.assertEquals(1, boards.size());
    }
}
