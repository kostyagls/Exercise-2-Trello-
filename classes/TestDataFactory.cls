@isTest
public with sharing class TestDataFactory {

    public static void insertBoardAndListTestData() {
        Board__c board = new Board__c(Name = 'testBoard');
        insert board;
        List<Board__c> boards = [SELECT Id FROM Board__c];

        List__c cList = new List__c(Name = 'testList', Board__c = boards[0].Id);
        insert cList;
    }

}